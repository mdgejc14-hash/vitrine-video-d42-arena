import { AwsClient } from "aws4fetch";
import { createRemoteJWKSet, jwtVerify } from "jose";
import { executePurgeOperation } from "./purge-executor-core.js";

const PROJECT_ID = "vitrine-video";
const ISSUER = `https://securetoken.google.com/${PROJECT_ID}`;

const FIREBASE_KEYS = createRemoteJWKSet(
  new URL(
    "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com"
  )
);

const ALLOWED_TONES = [
  "neutre",
  "professionnel",
  "chaleureux",
  "dynamique",
  "premium"
];

const ALLOWED_LANGUAGES = ["fr", "yo", "ha", "fon"];
const MAX_AUDIO_BYTES = 4 * 1024 * 1024;
// Époque de cache audio : à INCRÉMENTER à chaque rotation de la bibliothèque
// (remplacement d'objets B2 sous les mêmes clés). Les entrées bord mises en
// cache sous une époque antérieure sont orphanées (plus jamais servies) sans
// purge Cloudflare — le cache plein GET est "immutable" 30 j par conception.
const AUDIO_CACHE_EPOCH = "v2-20261101";
const MAX_PROXY_BYTES = 18 * 1024 * 1024;
const MAX_FINAL_RENDER_BYTES = 32 * 1024 * 1024;
const UPLOAD_URL_TTL = 600;
const PENDING_PURGE_AT = "9999-12-31T23:59:59.999Z";
const AUDIO_PROXY_RETENTION_MS = 7 * 24 * 60 * 60 * 1000;
const FAILED_CANCELLED_RETENTION_MS = 72 * 60 * 60 * 1000;
const PURGE_LEDGER_BATCH_SIZE = 25;
const PURGE_LEDGER_SCHEMA_VERSION = 1;
const PURGE_EXECUTOR_MAX_OPERATIONS_PER_RUN = 3;
const PURGE_EXECUTOR_MAX_ATTEMPTS = 8;
const PURGE_EXECUTOR_LEASE_MS = 10 * 60 * 1000;
const PURGE_EXECUTOR_MAX_FILES_PER_ORDER = 50;

/*
 * Les transitions sont écrites par le serveur, jamais par un champ SQL brut
 * fourni par le client. Les callbacks du moteur distant utilisent une
 * signature HMAC et le secret Cloudflare ORDER_LIFECYCLE_SECRET.
 */
const ORDER_STATUS_TRANSITIONS = Object.freeze({
  brouillon: new Set(["fichiers_recus", "echec", "annule"]),
  fichiers_recus: new Set([
    "edl_pret",
    "rendu_local",
    "rendu_cloud_en_cours",
    "nouvelle_prise_requise",
    "echec",
    "annule"
  ]),
  edl_pret: new Set([
    "rendu_local",
    "rendu_cloud_en_cours",
    "nouvelle_prise_requise",
    "echec",
    "annule"
  ]),
  rendu_local: new Set([
    "livre",
    "nouvelle_prise_requise",
    "echec",
    "annule"
  ]),
  rendu_cloud_en_cours: new Set([
    "livre",
    "nouvelle_prise_requise",
    "echec",
    "annule"
  ]),
  nouvelle_prise_requise: new Set([
    "brouillon",
    "fichiers_recus",
    "echec",
    "annule"
  ]),
  echec: new Set(["brouillon", "fichiers_recus"]),
  annule: new Set(["brouillon", "fichiers_recus"]),
  livre: new Set()
});

const OWNER_REPORTABLE_STATUSES = new Set([
  "edl_pret",
  "rendu_local",
  "livre",
  "nouvelle_prise_requise",
  "echec",
  "annule",
  "brouillon"
]);

/* =====================================================
   UTILITAIRES
===================================================== */

function json(data, status = 200, extraHeaders = {}) {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      "content-type": "application/json; charset=utf-8",
      "cache-control": "no-store",
      "x-content-type-options": "nosniff",
      ...extraHeaders
    }
  });
}

function createUUIDv7() {
  const bytes = new Uint8Array(16);
  crypto.getRandomValues(bytes);

  const timestamp = Date.now();

  bytes[0] = Math.floor(timestamp / 2 ** 40) & 255;
  bytes[1] = Math.floor(timestamp / 2 ** 32) & 255;
  bytes[2] = Math.floor(timestamp / 2 ** 24) & 255;
  bytes[3] = Math.floor(timestamp / 2 ** 16) & 255;
  bytes[4] = Math.floor(timestamp / 2 ** 8) & 255;
  bytes[5] = timestamp % 256;

  bytes[6] = (bytes[6] & 0x0f) | 0x70;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  const hex = Array.from(bytes, byte =>
    byte.toString(16).padStart(2, "0")
  ).join("");

  return [
    hex.slice(0, 8),
    hex.slice(8, 12),
    hex.slice(12, 16),
    hex.slice(16, 20),
    hex.slice(20)
  ].join("-");
}

async function readResponseBytesLimited(response, maxBytes) {
  if (!Number.isSafeInteger(maxBytes) || maxBytes < 0) {
    throw new Error("Invalid response size limit");
  }

  if (!response.body) {
    return { ok: true, bytes: new Uint8Array(0) };
  }

  const reader = response.body.getReader();
  const buffer = new Uint8Array(maxBytes);
  let total = 0;

  try {
    while (true) {
      const { done, value } = await reader.read();
      if (done) break;
      if (!value) continue;

      if (total + value.byteLength > maxBytes) {
        try {
          await reader.cancel("Object exceeds expected size");
        } catch {
          // Stop reading once the declared maximum has been exceeded.
        }

        return {
          ok: false,
          actual_at_least: total + value.byteLength
        };
      }

      buffer.set(value, total);
      total += value.byteLength;
    }

    return { ok: true, bytes: buffer.subarray(0, total) };
  } catch (error) {
    try {
      await reader.cancel();
    } catch {
      // Preserve the original read error.
    }

    throw error;
  } finally {
    try {
      reader.releaseLock();
    } catch {
      // The stream may already be unlocked after cancellation.
    }
  }
}

async function sha256Hex(bytes) {
  const digest = await crypto.subtle.digest("SHA-256", bytes);

  return Array.from(new Uint8Array(digest), byte =>
    byte.toString(16).padStart(2, "0")
  ).join("");
}

function safeJsonParse(value, fallback = null) {
  if (!value) return fallback;

  try {
    return JSON.parse(value);
  } catch {
    return fallback;
  }
}

function normalizeText(value, maxLength, required = false) {
  if (value === undefined || value === null) {
    return required
      ? { ok: false }
      : { ok: true, value: null };
  }

  if (typeof value !== "string") {
    return { ok: false };
  }

  const trimmed = value.trim();

  if (
    (required && !trimmed) ||
    trimmed.length > maxLength
  ) {
    return { ok: false };
  }

  return {
    ok: true,
    value: trimmed || null
  };
}

async function readJsonBody(request, maxBytes = 16384) {
  const contentType =
    request.headers.get("content-type") ?? "";

  if (!contentType.toLowerCase().includes("application/json")) {
    return {
      ok: false,
      response: json({
        error: "content_type_required",
        message: "Send a JSON request body."
      }, 415)
    };
  }

  const raw = await request.text();
  const size = new TextEncoder().encode(raw).length;

  if (size > maxBytes) {
    return {
      ok: false,
      response: json({
        error: "body_too_large"
      }, 413)
    };
  }

  let body;

  try {
    body = JSON.parse(raw);
  } catch {
    return {
      ok: false,
      response: json({
        error: "invalid_json"
      }, 400)
    };
  }

  if (
    !body ||
    typeof body !== "object" ||
    Array.isArray(body)
  ) {
    return {
      ok: false,
      response: json({
        error: "invalid_body"
      }, 400)
    };
  }

  return { ok: true, body };
}

function normalizeCoordinates(value) {
  if (value === undefined || value === null) {
    return { ok: true, value: null };
  }

  if (
    typeof value !== "object" ||
    Array.isArray(value)
  ) {
    return { ok: false };
  }

  const result = {};

  for (const [key, maxLength] of [
    ["tel", 40],
    ["whatsapp", 40],
    ["adresse", 250]
  ]) {
    const field = normalizeText(value[key], maxLength);

    if (!field.ok) return { ok: false };

    if (field.value !== null) {
      result[key] = field.value;
    }
  }

  return {
    ok: true,
    value: Object.keys(result).length ? result : null
  };
}

function normalizeBrief(value) {
  if (
    !value ||
    typeof value !== "object" ||
    Array.isArray(value)
  ) {
    return { ok: false };
  }

  const allowed = new Set([
    "produit_service",
    "description",
    "prix",
    "avantages",
    "appel_action",
    "objectif"
  ]);

  if (
    Object.keys(value).some(key => !allowed.has(key))
  ) {
    return { ok: false };
  }

  const product =
    normalizeText(value.produit_service, 160, true);
  const description =
    normalizeText(value.description, 800);
  const price =
    normalizeText(value.prix, 100);
  const cta =
    normalizeText(value.appel_action, 160);
  const objective =
    normalizeText(value.objectif, 100);

  if (
    !product.ok ||
    !description.ok ||
    !price.ok ||
    !cta.ok ||
    !objective.ok
  ) {
    return { ok: false };
  }

  const benefits = [];

  if (value.avantages !== undefined) {
    if (
      !Array.isArray(value.avantages) ||
      value.avantages.length > 5
    ) {
      return { ok: false };
    }

    for (const item of value.avantages) {
      const benefit = normalizeText(item, 160, true);

      if (!benefit.ok) return { ok: false };

      benefits.push(benefit.value);
    }
  }

  return {
    ok: true,
    value: {
      produit_service: product.value,
      description: description.value,
      prix: price.value,
      avantages: benefits,
      appel_action: cta.value,
      objectif: objective.value
    }
  };
}

/* =====================================================
   FIREBASE ET PROFILS
===================================================== */

async function authenticate(request) {
  const authorization =
    request.headers.get("Authorization") ?? "";

  const match = authorization.match(/^Bearer\s+(\S+)$/i);

  if (!match) {
    return {
      ok: false,
      response: json({
        error: "unauthorized",
        message: "A valid Firebase ID token is required."
      }, 401)
    };
  }

  try {
    const { payload } = await jwtVerify(
      match[1],
      FIREBASE_KEYS,
      {
        issuer: ISSUER,
        audience: PROJECT_ID,
        algorithms: ["RS256"]
      }
    );

    if (
      typeof payload.sub !== "string" ||
      !payload.sub
    ) {
      throw new Error("Invalid Firebase subject");
    }

    return { ok: true, payload };
  } catch {
    return {
      ok: false,
      response: json({
        error: "unauthorized",
        message: "The Firebase ID token is invalid or expired."
      }, 401)
    };
  }
}

async function getActiveUser(env, firebaseUid) {
  return env.DB.prepare(`
    SELECT
      id,
      firebase_uid,
      email,
      locale,
      status,
      plan,
      created_at
    FROM users
    WHERE firebase_uid = ?
    LIMIT 1
  `).bind(firebaseUid).first();
}

async function requireUser(request, env) {
  const auth = await authenticate(request);

  if (!auth.ok) return auth;

  try {
    const user = await getActiveUser(env, auth.payload.sub);

    if (!user) {
      return {
        ok: false,
        response: json({
          error: "profile_not_initialized"
        }, 404)
      };
    }

    if (user.status !== "actif") {
      return {
        ok: false,
        response: json({
          error: "account_inactive"
        }, 403)
      };
    }

    return {
      ok: true,
      payload: auth.payload,
      user
    };
  } catch {
    return {
      ok: false,
      response: json({
        error: "database_unavailable"
      }, 503)
    };
  }
}

async function bootstrapProfile(env, payload) {
  try {
    await env.DB.prepare(`
      INSERT INTO users (
        id,
        firebase_uid,
        email,
        locale,
        status,
        plan,
        last_seen_at
      )
      VALUES (
        ?, ?, ?, 'fr-BJ', 'actif', 'gratuit',
        strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
      )
      ON CONFLICT(firebase_uid) DO UPDATE SET
        email = COALESCE(excluded.email, users.email),
        last_seen_at =
          strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
    `).bind(
      createUUIDv7(),
      payload.sub,
      typeof payload.email === "string"
        ? payload.email
        : null
    ).run();

    const user = await getActiveUser(env, payload.sub);

    if (!user) {
      return json({
        error: "profile_unavailable"
      }, 503);
    }

    return json({
      authenticated: true,
      profile: {
        id: user.id,
        email: user.email,
        locale: user.locale,
        status: user.status,
        plan: user.plan,
        createdAt: user.created_at
      }
    });
  } catch (error) {
    console.error(
      "Profile initialization failed:",
      error?.name ?? "UnknownError"
    );

    return json({
      error: "profile_initialization_failed"
    }, 503);
  }
}

/* =====================================================
   FORMAT DES RÉPONSES
===================================================== */

function exposeMerchant(row) {
  return {
    id: row.id,
    nom_commerce: row.nom_commerce,
    secteur: row.secteur,
    ville: row.ville,
    ton: row.ton,
    public_cible: row.public_cible,
    coordonnees: safeJsonParse(row.coordonnees),
    created_at: row.created_at
  };
}

function exposeProject(row) {
  return {
    id: row.id,
    merchant_id: row.merchant_id,
    titre: row.titre,
    langue: row.langue,
    statut: row.statut,
    brief: safeJsonParse(row.brief_json, {}),
    created_at: row.created_at,
    updated_at: row.updated_at
  };
}

function exposeOrder(row) {
  return {
    id: row.id,
    project_id: row.project_id,
    template_id: row.template_id,
    statut: row.statut,
    moteur: row.moteur,
    tentative: row.tentative,
    audio_octets: row.audio_octets,
    proxy_octets: row.proxy_octets,
    rendu_octets: row.rendu_octets,
    qc: safeJsonParse(row.qc_json),
    edl: safeJsonParse(row.edl_final_json),
    sous_titres_vtt: row.sous_titres_vtt,
    score_asr: row.score_asr,
    created_at: row.created_at,
    updated_at: row.updated_at,
    purge_at: row.purge_at
  };
}

/* =====================================================
   NOTIFICATIONS IN-APP
===================================================== */

function exposeNotification(row) {
  return {
    id: row.id,
    type: row.type,
    payload: safeJsonParse(row.payload, {}),
    sent_at: row.envoye_at,
    read_at: row.lu_at,
    created_at: row.created_at
  };
}

async function handleNotificationCollection(request, env, user) {
  if (request.method !== "GET") {
    return json({
      error: "method_not_allowed"
    }, 405, { allow: "GET" });
  }

  const url = new URL(request.url);
  const rawLimit = url.searchParams.get("limit");
  const limit = rawLimit === null ? 20 : Number(rawLimit);
  const unreadOnly = url.searchParams.get("unread_only") ?? "false";

  if (
    !Number.isInteger(limit) ||
    limit < 1 ||
    limit > 50 ||
    !["true", "false"].includes(unreadOnly)
  ) {
    return json({
      error: "invalid_query_parameters",
      message: "limit must be 1-50 and unread_only must be true or false."
    }, 400);
  }

  const result = unreadOnly === "true"
    ? await env.DB.prepare(`
        SELECT id, type, payload, envoye_at, lu_at, created_at
        FROM notifications
        WHERE user_id = ? AND lu_at IS NULL
        ORDER BY created_at DESC
        LIMIT ?
      `).bind(user.id, limit).all()
    : await env.DB.prepare(`
        SELECT id, type, payload, envoye_at, lu_at, created_at
        FROM notifications
        WHERE user_id = ?
        ORDER BY created_at DESC
        LIMIT ?
      `).bind(user.id, limit).all();

  const data = (result.results ?? []).map(exposeNotification);

  return json({
    data,
    count: data.length,
    limit,
    unread_only: unreadOnly === "true"
  });
}

async function handleNotificationRead(request, env, user, notificationId) {
  if (request.method !== "PATCH") {
    return json({
      error: "method_not_allowed"
    }, 405, { allow: "PATCH" });
  }

  if (!/^[0-9a-f-]{36}$/i.test(notificationId)) {
    return json({ error: "invalid_notification_id" }, 400);
  }

  const existing = await env.DB.prepare(`
    SELECT id, lu_at
    FROM notifications
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `).bind(notificationId, user.id).first();

  if (!existing) {
    return json({ error: "notification_not_found" }, 404);
  }

  const alreadyRead = Boolean(existing.lu_at);

  await env.DB.prepare(`
    UPDATE notifications
    SET lu_at = COALESCE(
      lu_at,
      strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
    )
    WHERE id = ? AND user_id = ?
  `).bind(notificationId, user.id).run();

  const row = await env.DB.prepare(`
    SELECT id, type, payload, envoye_at, lu_at, created_at
    FROM notifications
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `).bind(notificationId, user.id).first();

  return json({
    data: exposeNotification(row),
    already_read: alreadyRead
  });
}

/* =====================================================
   CONFIGURATION ET SIGNATURE BACKBLAZE B2
===================================================== */

function getB2Config(env) {
  const required = [
    "B2_KEY_ID",
    "B2_APPLICATION_KEY",
    "B2_BUCKET",
    "B2_ENDPOINT",
    "B2_REGION"
  ];

  for (const name of required) {
    if (
      typeof env[name] !== "string" ||
      env[name].trim() === ""
    ) {
      throw new Error(
        `Missing storage configuration: ${name}`
      );
    }
  }

  const endpoint = new URL(env.B2_ENDPOINT);

  if (
    endpoint.protocol !== "https:" ||
    endpoint.hostname !==
      `s3.${env.B2_REGION}.backblazeb2.com` ||
    endpoint.pathname !== "/"
  ) {
    throw new Error("Invalid Backblaze endpoint configuration");
  }

  return {
    endpoint: endpoint.origin,
    bucket: env.B2_BUCKET,
    region: env.B2_REGION
  };
}

function getB2Client(env) {
  getB2Config(env);

  return new AwsClient({
    accessKeyId: env.B2_KEY_ID,
    secretAccessKey: env.B2_APPLICATION_KEY,
    service: "s3",
    region: env.B2_REGION,
    retries: 0
  });
}

function makeB2ObjectUrl(env, objectKey) {
  const config = getB2Config(env);

  const encodedKey = objectKey
    .split("/")
    .map(segment => encodeURIComponent(segment))
    .join("/");

  return new URL(
    `${config.endpoint}/${encodeURIComponent(config.bucket)}/${encodedKey}`
  );
}

/* =====================================================
   INVENTAIRE B2/D1 DES OBJETS ORPHELINS — AUDIT SEULEMENT
   - Route interne protégée par un bearer secret dédié.
   - Utilise une clé B2 distincte en lecture seule (B2_AUDIT_*).
   - Utilise l’opération S3 ListObjectsV2 uniquement sur B2_ORPHAN_AUDIT_PREFIX, par pages bornées.
   - Ne supprime aucun objet et ne modifie aucune ligne D1.
   - Les clés d'objets ne sont jamais renvoyées ni journalisées.
===================================================== */
function constantTimeStringEqual(a, b) {
  if (typeof a !== "string" || typeof b !== "string") return false;
  if (a.length !== b.length) return false;
  let difference = 0;
  for (let index = 0; index < a.length; index += 1) {
    difference |= a.charCodeAt(index) ^ b.charCodeAt(index);
  }
  return difference === 0;
}

function decodeB2XmlEntities(value) {
  return String(value).replace(/&(#x[0-9a-f]+|#\d+|amp|lt|gt|quot|apos);/gi, (match, entity) => {
    const lower = entity.toLowerCase();
    if (lower === "amp") return "&";
    if (lower === "lt") return "<";
    if (lower === "gt") return ">";
    if (lower === "quot") return '"';
    if (lower === "apos") return "'";
    try {
      const codePoint = lower.startsWith("#x")
        ? Number.parseInt(lower.slice(2), 16)
        : Number.parseInt(lower.slice(1), 10);
      return Number.isInteger(codePoint) && codePoint >= 0 && codePoint <= 0x10ffff
        ? String.fromCodePoint(codePoint)
        : match;
    } catch {
      return match;
    }
  });
}

function parseB2ListObjectsPage(xml) {
  if (typeof xml !== "string" || !/<ListBucketResult(?:\s|>)/i.test(xml)) {
    throw new Error("b2_inventory_response_invalid");
  }
  const truncatedMatch = xml.match(/<IsTruncated>\s*(true|false)\s*<\/IsTruncated>/i);
  if (!truncatedMatch) throw new Error("b2_inventory_truncation_flag_missing");

  const keys = [];
  for (const match of xml.matchAll(/<Contents(?:\s[^>]*)?>([\s\S]*?)<\/Contents>/gi)) {
    const keyMatch = match[1].match(/<Key>([\s\S]*?)<\/Key>/i);
    if (!keyMatch) throw new Error("b2_inventory_object_key_missing");
    keys.push(decodeB2XmlEntities(keyMatch[1]));
  }

  const tokenMatch = xml.match(/<NextContinuationToken>([\s\S]*?)<\/NextContinuationToken>/i);
  return {
    keys,
    truncated: truncatedMatch[1].toLowerCase() === "true",
    continuationToken: tokenMatch ? decodeB2XmlEntities(tokenMatch[1]) : null,
  };
}

function getB2OrphanAuditConfig(env) {
  const storage = getB2Config(env);
  for (const name of ["B2_AUDIT_KEY_ID", "B2_AUDIT_APPLICATION_KEY"]) {
    if (typeof env[name] !== "string" || !env[name].trim()) {
      throw new Error("b2_orphan_audit_credentials_missing");
    }
  }
  const prefix = env.B2_ORPHAN_AUDIT_PREFIX;
  if (
    typeof prefix !== "string" ||
    prefix.length < 3 || prefix.length > 512 ||
    !prefix.startsWith("u/") || !prefix.endsWith("/") ||
    prefix.includes("\\") || prefix.includes("?") || prefix.includes("#") ||
    prefix.includes("//") ||
    prefix.slice(0, -1).split("/").some(segment => !segment || segment === "." || segment === "..")
  ) {
    throw new Error("b2_orphan_audit_prefix_invalid");
  }
  const token = env.B2_ORPHAN_AUDIT_TOKEN;
  if (typeof token !== "string" || token.length < 32) {
    throw new Error("b2_orphan_audit_token_not_configured");
  }
  // Free Workers allows 50 subrequests per invocation. The audit issues one D1
  // query per batch of 50 keys plus a small number of B2 listing requests.
  // Cap at 1,500 objects to stay comfortably within that free-tier budget.
  const maxRaw = env.B2_ORPHAN_AUDIT_MAX_OBJECTS ?? "1500";
  const maxObjects = Number(maxRaw);
  if (!Number.isSafeInteger(maxObjects) || maxObjects < 1 || maxObjects > 1500) {
    throw new Error("b2_orphan_audit_max_objects_invalid");
  }
  return { storage, prefix, maxObjects };
}

async function auditB2OrphanObjects(env) {
  const config = getB2OrphanAuditConfig(env);
  const client = new AwsClient({
    accessKeyId: env.B2_AUDIT_KEY_ID,
    secretAccessKey: env.B2_AUDIT_APPLICATION_KEY,
    service: "s3",
    region: config.storage.region,
    retries: 0,
  });

  const summary = {
    inventory_complete: false,
    prefix: config.prefix,
    scanned_objects: 0,
    matched_d1_files: 0,
    orphan_count: 0,
    pages_scanned: 0,
    max_objects: config.maxObjects,
    audit_only: true,
    deletion_performed: false,
    error_code: null,
  };
  const seen = new Set();
  let continuationToken = null;

  while (true) {
    if (summary.scanned_objects >= config.maxObjects) {
      summary.error_code = "inventory_limit_reached";
      return summary;
    }
    const pageLimit = Math.min(1000, config.maxObjects - summary.scanned_objects);
    const url = new URL(`${config.storage.endpoint}/${encodeURIComponent(config.storage.bucket)}/`);
    url.searchParams.set("list-type", "2");
    url.searchParams.set("prefix", config.prefix);
    url.searchParams.set("max-keys", String(pageLimit));
    if (continuationToken) url.searchParams.set("continuation-token", continuationToken);

    const response = await client.fetch(url.toString(), {
      method: "GET",
      headers: { "x-amz-content-sha256": "UNSIGNED-PAYLOAD" },
      aws: { service: "s3", region: config.storage.region },
    });
    const xml = await response.text();
    if (!response.ok) {
      // Do not return provider response text: it may contain details not intended for clients.
      throw new Error(`b2_inventory_http_${response.status}`);
    }

    const page = parseB2ListObjectsPage(xml);
    summary.pages_scanned += 1;
    const pageKeys = [];
    for (const key of page.keys) {
      if (!isSafePurgeObjectKey(key, config.prefix)) {
        throw new Error("b2_inventory_key_outside_configured_prefix");
      }
      if (seen.has(key)) throw new Error("b2_inventory_duplicate_key");
      seen.add(key);
      pageKeys.push(key);
    }

    for (let offset = 0; offset < pageKeys.length; offset += 50) {
      const batchKeys = pageKeys.slice(offset, offset + 50);
      if (!batchKeys.length) continue;
      const placeholders = batchKeys.map(() => "?").join(", ");
      const result = await env.DB.prepare(
        `SELECT r2_key FROM files WHERE r2_key IN (${placeholders})`
      ).bind(...batchKeys).all();
      const knownKeys = new Set((result.results ?? []).map(row => String(row.r2_key)));
      for (const key of batchKeys) {
        summary.scanned_objects += 1;
        if (knownKeys.has(key)) summary.matched_d1_files += 1;
        else summary.orphan_count += 1;
      }
    }

    if (!page.truncated) {
      summary.inventory_complete = true;
      return summary;
    }
    if (!page.continuationToken) throw new Error("b2_inventory_continuation_token_missing");
    if (summary.scanned_objects >= config.maxObjects) {
      summary.error_code = "inventory_limit_reached";
      return summary;
    }
    continuationToken = page.continuationToken;
  }
}

function addDays(date, days) {
  const result = new Date(date);
  result.setUTCDate(result.getUTCDate() + days);
  return result.toISOString();
}

function isFinalRenderRole(role) {
  return ["rendu", "render", "final_render"].includes(
    String(role ?? "").trim().toLowerCase()
  );
}

function canonicalUploadRole(value) {
  const role = String(value ?? "").trim().toLowerCase();
  if (role === "render" || role === "final_render") return "rendu";
  return role;
}

function getUploadFileType(role, contentType) {
  const audioTypes = {
    "audio/webm": "webm",
    "audio/mp4": "m4a",
    "audio/aac": "aac",
    "audio/ogg": "ogg"
  };

  if (
    role === "audio" &&
    Object.hasOwn(audioTypes, contentType)
  ) {
    return {
      extension: audioTypes[contentType],
      maxBytes: MAX_AUDIO_BYTES
    };
  }

  if (
    role === "proxy" &&
    contentType === "video/mp4"
  ) {
    return {
      extension: "mp4",
      maxBytes: MAX_PROXY_BYTES
    };
  }

  if (
    role === "rendu" &&
    contentType === "video/mp4"
  ) {
    return {
      extension: "mp4",
      maxBytes: MAX_FINAL_RENDER_BYTES
    };
  }

  return null;
}

/* =====================================================
   AUTORISATION D'UNE COMMANDE POUR LES FICHIERS
===================================================== */

async function getOrderForUpload(env, orderId, userId) {
  return env.DB.prepare(`
    SELECT
      o.id,
      o.project_id,
      o.user_id,
      o.statut,
      p.langue,
      m.secteur
    FROM orders o
    JOIN projects p ON p.id = o.project_id
    JOIN merchants m ON m.id = p.merchant_id
    WHERE o.id = ?
      AND o.user_id = ?
      AND p.user_id = ?
      AND m.user_id = ?
    LIMIT 1
  `).bind(
    orderId,
    userId,
    userId,
    userId
  ).first();
}

/* =====================================================
   CRÉER UNE URL TEMPORAIRE D'ENVOI
===================================================== */

async function handleUploadSign(request, env, user, orderId) {
  const parsed = await readJsonBody(request);

  if (!parsed.ok) return parsed.response;

  const body = parsed.body;
  const roleInput = normalizeText(body.role, 20, true);
  const canonicalRole = roleInput.ok
    ? canonicalUploadRole(roleInput.value)
    : null;
  const role = {
    ok: roleInput.ok && ["audio", "proxy", "rendu"].includes(canonicalRole),
    value: canonicalRole
  };
  const contentType =
    normalizeText(body.content_type, 80, true);
  const sha256 = normalizeText(body.sha256, 64, true);
  const size = body.size_bytes;

  if (
    !role.ok ||
    !contentType.ok ||
    !/^[a-f0-9]{64}$/i.test(sha256.value ?? "") ||
    !Number.isSafeInteger(size) ||
    size <= 0
  ) {
    return json({
      error: "validation_failed",
      message: "Provide role, content_type, size_bytes and SHA-256."
    }, 400);
  }

  const fileType = getUploadFileType(
    role.value,
    contentType.value
  );

  if (!fileType) {
    return json({
      error: "unsupported_file_type"
    }, 415);
  }

  if (size > fileType.maxBytes) {
    return json({
      error: "file_too_large",
      max_bytes: fileType.maxBytes
    }, 413);
  }

  const order = await getOrderForUpload(
    env,
    orderId,
    user.id
  );

  if (!order) {
    return json({
      error: "order_not_found"
    }, 404);
  }

  const canUploadTemporaryMedia =
    ["audio", "proxy"].includes(role.value) && order.statut === "brouillon";
  const canUploadFinalRender =
    role.value === "rendu" &&
    ["rendu_local", "rendu_cloud_en_cours"].includes(order.statut);

  if (!canUploadTemporaryMedia && !canUploadFinalRender) {
    return json({
      error: "order_not_uploadable",
      message: role.value === "rendu"
        ? "Final-render uploads are allowed only while the order is in a rendering state."
        : "Audio and proxy uploads are allowed only for draft orders."
    }, 409);
  }

  try {
    const b2 = getB2Client(env);
    const config = getB2Config(env);

    const fileId = createUUIDv7();

    const objectKey =
      `u/${user.firebase_uid}/${order.project_id}/${order.id}/` +
      `${fileId}-${role.value}.${fileType.extension}`;

    const objectUrl = makeB2ObjectUrl(env, objectKey);

    objectUrl.searchParams.set(
      "X-Amz-Expires",
      String(UPLOAD_URL_TTL)
    );

    const requestHeaders = {
      "content-type": contentType.value,
      "x-amz-meta-sha256": sha256.value.toLowerCase()
    };

    const signed = await b2.sign(objectUrl.toString(), {
      method: "PUT",
      headers: requestHeaders,
      aws: {
        signQuery: true,
        service: "s3",
        region: config.region,
        allHeaders: true
      }
    });

    const requiredHeaders = {};

    for (const [name, value] of signed.headers.entries()) {
      const lowerName = name.toLowerCase();

      if (
        lowerName === "host" ||
        lowerName === "authorization"
      ) {
        continue;
      }

      requiredHeaders[name] = value;
    }

    // Do not start the 7-day retention clock when a URL is merely signed.
    // The real purge_at is calculated only after the order is marked "livre".
    const purgeAt = PENDING_PURGE_AT;

    await env.DB.prepare(`
      INSERT INTO files (
        id,
        order_id,
        r2_key,
        role,
        taille_octets,
        empreinte,
        uploaded_at,
        purge_at
      )
      VALUES (?, ?, ?, ?, ?, ?, NULL, ?)
    `).bind(
      fileId,
      order.id,
      objectKey,
      role.value,
      size,
      sha256.value.toLowerCase(),
      purgeAt
    ).run();

    return json({
      data: {
        file_id: fileId,
        order_id: order.id,
        role: role.value,
        upload_url: signed.url.toString(),
        expires_in: UPLOAD_URL_TTL,
        expires_at: new Date(
          Date.now() + UPLOAD_URL_TTL * 1000
        ).toISOString(),
        required_headers: requiredHeaders,
        max_bytes: fileType.maxBytes
      }
    }, 201);

  } catch (error) {
    console.error(
      "B2 signing failed:",
      error?.name ?? "StorageError"
    );

    return json({
      error: "storage_signing_failed",
      message: "The upload URL could not be prepared."
    }, 503);
  }
}

/* =====================================================
   CONFIRMER L'ENVOI — VÉRIFICATION D'INTÉGRITÉ
===================================================== */

async function handleUploadConfirm(request, env, user, orderId) {
  const parsed = await readJsonBody(request);

  if (!parsed.ok) return parsed.response;

  const fileId = normalizeText(
    parsed.body.file_id,
    36,
    true
  );

  if (
    !fileId.ok ||
    !/^[0-9a-f-]{36}$/i.test(fileId.value ?? "")
  ) {
    return json({ error: "invalid_file_id" }, 400);
  }

  const file = await env.DB.prepare(`
    SELECT
      f.id,
      f.order_id,
      f.r2_key,
      f.role,
      f.taille_octets,
      f.empreinte,
      f.uploaded_at,
      f.purge_at,
      o.statut AS order_status
    FROM files f
    JOIN orders o ON o.id = f.order_id
    WHERE f.id = ?
      AND f.order_id = ?
      AND o.user_id = ?
    LIMIT 1
  `).bind(
    fileId.value,
    orderId,
    user.id
  ).first();

  if (!file) {
    return json({ error: "file_not_found" }, 404);
  }

  const expectedBytes = Number(file.taille_octets);
  const expectedHash = String(file.empreinte ?? "").toLowerCase();
  const maxBytes = file.role === "audio"
    ? MAX_AUDIO_BYTES
    : file.role === "proxy"
      ? MAX_PROXY_BYTES
      : isFinalRenderRole(file.role)
        ? MAX_FINAL_RENDER_BYTES
        : 0;
  const finalRender = isFinalRenderRole(file.role);

  if (
    finalRender &&
    !["rendu_local", "rendu_cloud_en_cours", "livre"].includes(file.order_status)
  ) {
    return json({
      error: "final_render_order_state_invalid",
      message: "A final render may be confirmed only while rendering is active or after delivery."
    }, 409);
  }

  if (
    !Number.isSafeInteger(expectedBytes) ||
    expectedBytes <= 0 ||
    maxBytes <= 0 ||
    expectedBytes > maxBytes ||
    !/^[a-f0-9]{64}$/.test(expectedHash)
  ) {
    return json({
      error: "stored_file_metadata_invalid",
      message: "The stored file record has an invalid size, role, or SHA-256 value."
    }, 409);
  }

  try {
    const b2 = getB2Client(env);
    const objectUrl = makeB2ObjectUrl(env, file.r2_key);

    const response = await b2.fetch(objectUrl.toString(), {
      method: "GET",
      aws: {
        service: "s3",
        region: env.B2_REGION
      }
    });

    if (response.status !== 200) {
      let responseText = "";

      try {
        responseText = (await response.text()).slice(0, 4096);
      } catch {
        responseText = "";
      }

      const codeMatch =
        responseText.match(/<Code>\s*([^<]+)\s*<\/Code>/i) ||
        responseText.match(/"code"\s*:\s*"([^"]+)"/i);

      const messageMatch =
        responseText.match(/<Message>\s*([^<]+)\s*<\/Message>/i) ||
        responseText.match(/"message"\s*:\s*"([^"]+)"/i);

      const storageCode = codeMatch ? codeMatch[1] : null;
      const storageMessage = messageMatch ? messageMatch[1] : null;
      const requestId =
        response.headers.get("x-amz-request-id") ||
        response.headers.get("x-bz-request-id") ||
        response.headers.get("x-amz-id-2") ||
        null;

      console.error(
        "B2 full-object verification failed:",
        JSON.stringify({
          status: response.status,
          code: storageCode,
          requestId,
          fileId: file.id
        })
      );

      return json({
        error: "storage_verification_failed",
        storage_status: response.status,
        storage_code: storageCode,
        request_id: requestId,
        message: storageMessage || (
          response.status === 403
            ? "Backblaze denied reading the uploaded object. Check readFiles permission, bucket scope, and key prefix."
            : response.status === 404
              ? "Backblaze did not find the object at the expected key."
              : "Backblaze could not return the complete object for verification."
        )
      }, 502);
    }

    const declaredLengthHeader = response.headers.get("content-length");
    const declaredLength = declaredLengthHeader === null
      ? null
      : Number(declaredLengthHeader);

    if (
      declaredLength !== null &&
      (
        !Number.isSafeInteger(declaredLength) ||
        declaredLength !== expectedBytes
      )
    ) {
      if (response.body) {
        try {
          await response.body.cancel();
        } catch {
          // The response body is discarded.
        }
      }

      return json({
        error: "upload_integrity_failed",
        message: "The object's declared length does not match the requested upload size.",
        expected_size: expectedBytes,
        declared_size: Number.isFinite(declaredLength) ? declaredLength : null,
        verification_method: "GET_SHA256"
      }, 409);
    }

    const readResult = await readResponseBytesLimited(
      response,
      expectedBytes
    );

    if (!readResult.ok) {
      return json({
        error: "upload_integrity_failed",
        message: "The stored object exceeds the expected size; it was not confirmed.",
        expected_size: expectedBytes,
        actual_size_at_least: readResult.actual_at_least,
        verification_method: "GET_SHA256"
      }, 409);
    }

    const actualBytes = readResult.bytes.byteLength;

    if (actualBytes !== expectedBytes) {
      return json({
        error: "upload_integrity_failed",
        message: "The actual number of downloaded bytes does not match the expected size.",
        expected_size: expectedBytes,
        actual_size: actualBytes,
        verification_method: "GET_SHA256"
      }, 409);
    }

    const actualHash = await sha256Hex(readResult.bytes);
    const contentHashMatches = actualHash === expectedHash;

    const metadataHash = (
      response.headers.get("x-amz-meta-sha256") || ""
    ).toLowerCase();

    const metadataHashMatches = metadataHash === expectedHash;

    if (!contentHashMatches) {
      console.error(
        "B2 uploaded object SHA-256 mismatch:",
        JSON.stringify({
          fileId: file.id,
          expectedBytes,
          actualBytes,
          metadataHashMatches
        })
      );

      return json({
        error: "upload_integrity_failed",
        message: "SHA-256 calculated from the stored bytes does not match the expected SHA-256.",
        expected_size: expectedBytes,
        actual_size: actualBytes,
        content_sha256_matches: false,
        metadata_sha256_matches: metadataHashMatches,
        verification_method: "GET_SHA256"
      }, 409);
    }

    const confirmedAt = file.uploaded_at || new Date().toISOString();
    const firstConfirmation = !file.uploaded_at;
    const column = file.role === "audio"
      ? "audio_octets"
      : file.role === "proxy"
        ? "proxy_octets"
        : "rendu_octets";

    const statements = [
      env.DB.prepare(`
        UPDATE files
        SET uploaded_at = COALESCE(uploaded_at, ?)
        WHERE id = ? AND order_id = ?
      `).bind(confirmedAt, file.id, orderId),

      env.DB.prepare(`
        UPDATE orders
        SET ${column} = (
              SELECT COALESCE(SUM(taille_octets), 0)
              FROM files
              WHERE order_id = ?
                AND role = ?
                AND uploaded_at IS NOT NULL
            ),
            updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
        WHERE id = ? AND user_id = ?
      `).bind(orderId, file.role, orderId, user.id)
    ];

    let notificationId = null;

    if (firstConfirmation) {
      notificationId = createUUIDv7();

      const notificationType = finalRender
        ? "final_render_confirmed"
        : "media_received";
      const payload = {
        title: finalRender ? "Rendu final reçu" : "Fichier reçu",
        message: finalRender
          ? "Le rendu final a été reçu et son intégrité SHA-256 a été vérifiée."
          : file.role === "audio"
            ? "La piste audio a été reçue et son intégrité a été vérifiée."
            : "La vidéo proxy a été reçue et son intégrité a été vérifiée.",
        order_id: orderId,
        file_id: file.id,
        role: file.role,
        size_bytes: actualBytes,
        verification_method: "GET_SHA256",
        content_sha256_matches: true
      };

      statements.push(env.DB.prepare(`
        INSERT INTO notifications (id, user_id, type, payload)
        SELECT ?, ?, ?, ?
        WHERE NOT EXISTS (
          SELECT 1
          FROM notifications
          WHERE user_id = ?
            AND type = ?
            AND json_extract(payload, '$.file_id') = ?
        )
      `).bind(
        notificationId,
        user.id,
        notificationType,
        JSON.stringify(payload),
        user.id,
        notificationType,
        file.id
      ));
    }

    const batchResults = await env.DB.batch(statements);
    const notificationCreated = firstConfirmation &&
      Number(batchResults[2]?.meta?.changes ?? 0) > 0;

    // Audio + proxy confirmation advances a draft order to fichiers_recus.
    // A final render is delivered only after every signed final-render record
    // for this order has been independently confirmed against the B2 object.
    let lifecycleStatus = null;
    let lifecycleTransition = null;
    const confirmedRoles = await env.DB.prepare(`
      SELECT
        SUM(CASE WHEN role = 'audio' AND uploaded_at IS NOT NULL THEN 1 ELSE 0 END) AS audio_count,
        SUM(CASE WHEN role = 'proxy' AND uploaded_at IS NOT NULL THEN 1 ELSE 0 END) AS proxy_count,
        SUM(CASE WHEN LOWER(TRIM(COALESCE(role, ''))) IN ('rendu', 'render', 'final_render') AND uploaded_at IS NULL THEN 1 ELSE 0 END) AS pending_render_count
      FROM files
      WHERE order_id = ?
    `).bind(orderId).first();

    const currentOrder = await findOrderForUser(env, orderId, user.id);

    if (
      !finalRender &&
      currentOrder?.statut === "brouillon" &&
      Number(confirmedRoles?.audio_count ?? 0) > 0 &&
      Number(confirmedRoles?.proxy_count ?? 0) > 0
    ) {
      const transition = await transitionOrderStatus(
        env,
        orderId,
        user.id,
        "brouillon",
        "fichiers_recus",
        { source: "upload_confirmation" }
      );

      lifecycleTransition = {
        recorded: Boolean(transition.ok && transition.changed),
        code: transition.code ?? null
      };
      if (transition.ok && transition.changed) {
        lifecycleStatus = transition.status;
      } else {
        lifecycleStatus = (await findOrderForUser(env, orderId, user.id))?.statut ?? currentOrder?.statut ?? null;
      }
    } else if (
      finalRender &&
      ["rendu_local", "rendu_cloud_en_cours"].includes(currentOrder?.statut) &&
      Number(confirmedRoles?.pending_render_count ?? 0) === 0
    ) {
      const transition = await transitionOrderStatus(
        env,
        orderId,
        user.id,
        currentOrder.statut,
        "livre",
        { source: "final_render_upload_confirmation" }
      );

      lifecycleTransition = {
        recorded: Boolean(transition.ok && transition.changed),
        code: transition.code ?? null
      };
      if (transition.ok && transition.changed) {
        lifecycleStatus = transition.status;
      } else {
        lifecycleStatus = (await findOrderForUser(env, orderId, user.id))?.statut ?? currentOrder.statut;
      }
    } else {
      lifecycleStatus = currentOrder?.statut ?? null;
    }

    return json({
      confirmed: true,
      verification_method: "GET_SHA256",
      integrity: {
        size_matches: true,
        content_sha256_matches: true,
        metadata_sha256_matches: metadataHashMatches
      },
      notification_created: notificationCreated,
      lifecycle_transition: lifecycleTransition,
      order_status: lifecycleStatus,
      file: {
        id: file.id,
        order_id: file.order_id,
        role: file.role,
        size_bytes: actualBytes,
        uploaded_at: confirmedAt,
        purge_at: file.purge_at === PENDING_PURGE_AT ? null : file.purge_at,
        retention_status: finalRender
          ? "preserved_no_automatic_expiry_rule"
          : file.purge_at === PENDING_PURGE_AT
            ? "awaiting_lifecycle_event"
            : "scheduled"
      }
    });

  } catch (error) {
    console.error(
      "B2 upload confirmation failed:",
      error?.name ?? "StorageError"
    );

    return json({
      error: "upload_confirmation_failed",
      message: "The uploaded file could not be read and verified."
    }, 503);
  }
}

/* =====================================================
   SUPPRIMER UN FICHIER — ACTION UTILISATEUR
===================================================== */

async function handleUploadDelete(
  request,
  env,
  user,
  orderId,
  fileId
) {
  const file = await env.DB.prepare(`
    SELECT
      f.id,
      f.order_id,
      f.r2_key,
      f.role
    FROM files f
    JOIN orders o ON o.id = f.order_id
    WHERE f.id = ?
      AND f.order_id = ?
      AND o.user_id = ?
    LIMIT 1
  `).bind(
    fileId,
    orderId,
    user.id
  ).first();

  if (!file) {
    return json({
      error: "file_not_found"
    }, 404);
  }

  try {
    const b2 = getB2Client(env);

    const objectUrl = makeB2ObjectUrl(
      env,
      file.r2_key
    );

    const response = await b2.fetch(
      objectUrl.toString(),
      {
        method: "DELETE",
        aws: {
          service: "s3",
          region: env.B2_REGION
        }
      }
    );

    if (!response.ok) {
      console.error(
        "B2 delete failed:",
        JSON.stringify({
          status: response.status,
          fileId: file.id
        })
      );

      return json({
        error: "storage_delete_failed",
        storage_status: response.status
      }, 503);
    }

    await env.DB.prepare(`
      DELETE FROM files
      WHERE id = ? AND order_id = ?
    `).bind(
      fileId,
      orderId
    ).run();

    const total = await env.DB.prepare(`
      SELECT COALESCE(SUM(taille_octets), 0) AS total
      FROM files
      WHERE order_id = ?
        AND role = ?
        AND uploaded_at IS NOT NULL
    `).bind(
      orderId,
      file.role
    ).first();

    const column = file.role === "audio"
      ? "audio_octets"
      : "proxy_octets";

    await env.DB.prepare(`
      UPDATE orders
      SET ${column} = ?,
          updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
      WHERE id = ? AND user_id = ?
    `).bind(
      Number(total?.total ?? 0),
      orderId,
      user.id
    ).run();

    return json({
      deleted: true,
      file_id: fileId
    });

  } catch (error) {
    console.error(
      "B2 file deletion failed:",
      error?.name ?? "StorageError"
    );

    return json({
      error: "storage_delete_failed"
    }, 503);
  }
}

/* =====================================================
   Phase B (v0.8.0) - AJOUTS ADDITIFS 2.4 : rien d'existant n'est modifie.
   Lecture objet sur le bucket public d'assets (env.VV_ASSETS_BUCKET).
   Meme patron S3 signe que le coffre-fort (getB2Config/getB2Client).
   ===================================================== */

async function b2Get(env, key) {
  const bucket = env.VV_ASSETS_BUCKET;
  if (typeof bucket !== "string" || bucket.trim() === "") {
    return null;
  }
  const config = getB2Config(env);
  const client = getB2Client(env);
  const encodedKey = key
    .split("/")
    .map(segment => encodeURIComponent(segment))
    .join("/");
  const url = `${config.endpoint}/${encodeURIComponent(bucket)}/${encodedKey}`;
  const response = await client.fetch(url, { method: "GET" });
  if (!response.ok) {
    return null;
  }
  return {
    body: response.body,
    etag: response.headers.get("etag") ?? "",
    ctype: response.headers.get("content-type") ?? "application/octet-stream"
  };
}

const CACHE_MANIFEST = { "cache-control": "public, max-age=3600" };
const CACHE_IMMUTABLE = { "cache-control": "public, max-age=2592000, immutable" };

/* =====================================================
   Phase C (31/10/2026) — CATALOGUE AUDIO / BGM (additif)
   Distribution des musiques de fond par gabarit :
   - D1 audio_catalog (migration 0010, seed = 30 gabarits x matrice audio)
   - objets B2 audio/bgm/<secteur>/<T1..T5>/<categorie_audio>.m4a|mp3
     (contrat de televersement : audio/bgm/STRUCTURE.json sur le bucket)
   URL stable + Cache-Control immutable => mise en cache locale DEFINITIVE
   cote telephone (files/bgm), rejeu hors-ligne sans reseau.
   Cache bord Cloudflare : la cle ne porte pas Authorization (un morceau
   n'est pas une donnee par utilisateur ; l'acces reste authentifie).
   Coffre-fort intact : aucune route existante modifiee.
===================================================== */

const AUDIO_TRACK_PATTERN = /^musique_t[1-5]_[a-z0-9_]{3,64}$/;

async function b2GetMedia(env, objectKey, rangeHeader) {
  let config;
  try {
    config = getB2Config(env);
  } catch {
    return { status: 503, error: "storage_not_configured" };
  }
  const client = getB2Client(env);
  const encodedKey = objectKey
    .split("/")
    .map(segment => encodeURIComponent(segment))
    .join("/");
  const url = `${config.endpoint}/${encodeURIComponent(config.bucket)}/${encodedKey}`;
  const headers = {};
  if (
    typeof rangeHeader === "string" &&
    /^bytes=\d+-\d*$/.test(rangeHeader.trim())
  ) {
    headers.Range = rangeHeader.trim();
  }
  let response;
  try {
    response = await client.fetch(url, { method: "GET", headers });
  } catch {
    return { status: 502, error: "storage_upstream_unreachable" };
  }
  if (response.status === 404 || response.status === 403) {
    return { status: 404 };
  }
  if (response.status !== 200 && response.status !== 206) {
    return { status: 502, error: "storage_upstream_error" };
  }
  return {
    status: response.status,
    body: response.body,
    ctype:
      response.headers.get("content-type") ||
      "application/octet-stream",
    etag: response.headers.get("etag") || "",
    length: response.headers.get("content-length"),
    contentRange: response.headers.get("content-range")
  };
}

async function routeAudioCatalog(env) {
  const { results } = await env.DB.prepare(`
    SELECT a.categorie_audio, a.gabarit_id, a.secteur, a.format, a.genre,
           a.style, a.energie, a.bpm_min, a.bpm_max, a.duree_gabarit_s,
           a.statut, a.taille_octets,
           (SELECT 1 FROM bgm_library l
             WHERE l.categorie_audio = a.categorie_audio AND l.statut = 'EN_LIGNE'
             LIMIT 1) AS en_bibliotheque
    FROM audio_catalog a
    ORDER BY a.secteur, a.format
  `).all();

  const pistes = (results ?? []).map(row => ({
    categorie_audio: row.categorie_audio,
    gabarit_id: row.gabarit_id,
    secteur: row.secteur,
    format: row.format,
    genre: row.genre,
    style: row.style,
    energie: row.energie,
    bpm_min: row.bpm_min,
    bpm_max: row.bpm_max,
    duree_gabarit_s: row.duree_gabarit_s,
    disponible: row.statut === "EN_LIGNE" || row.en_bibliotheque === 1,
    taille_octets: row.taille_octets
  }));

  return json({ pistes, count: pistes.length }, 200, CACHE_MANIFEST);
}

async function routeAudioLibrary(url, env) {
  const secteur = url.searchParams.get("secteur");
  const format = url.searchParams.get("format");
  const limite = Math.min(
    200,
    Math.max(1, Number(url.searchParams.get("limit")) || 50)
  );
  const where = [];
  const binds = [];
  if (secteur) {
    where.push("secteur = ?");
    binds.push(secteur);
  }
  if (format) {
    where.push("format = ?");
    binds.push(format);
  }
  binds.push(limite);
  const { results } = await env.DB.prepare(`
    SELECT piste_id, categorie_audio, gabarit_id, secteur, format, variation,
           bpm, genre, origine, licence, duree_s, taille_octets, statut,
           sha256
    FROM bgm_library
    ${where.length ? "WHERE " + where.join(" AND ") : ""}
    ORDER BY secteur, format, variation
    LIMIT ?
  `).bind(...binds).all();

  const total = await env.DB
    .prepare("SELECT COUNT(*) AS n FROM bgm_library")
    .first();

  return json(
    {
      pistes: results ?? [],
      count: (results ?? []).length,
      total: total ? total.n : 0
    },
    200,
    CACHE_MANIFEST
  );
}

async function routeAudioTrack(request, env, categorie) {
  if (typeof categorie !== "string" || !AUDIO_TRACK_PATTERN.test(categorie)) {
    return json({ error: "unknown_track" }, 404);
  }

  // D42.21 — variation explicite ?v=N (1..20) : sélection parmi les 20 musiques
  // du gabarit (bgm_library). Sans ?v : comportement historique inchangé
  // (master titulaire prioritaire, sinon repli variation 1).
  const variationParam = new URL(request.url).searchParams.get("v");
  let variationDemandee = null;
  if (variationParam !== null) {
    const v = Number(variationParam);
    if (!Number.isInteger(v) || v < 1 || v > 20) {
      return json({ error: "invalid_variation" }, 400);
    }
    variationDemandee = v;
  }

  const cache = caches.default;
  const cacheKey = new Request(
    new URL(request.url).origin +
      "/api/v1/audio/track/" + categorie +
      (variationDemandee ? "?v=" + variationDemandee : "") +
      "&cv=" + AUDIO_CACHE_EPOCH
  );
  // Une requete Range (lecteur progressif) ne doit JAMAIS recevoir une reponse
  // complete mise en cache : le cache bord ne varie pas selon Range. On le
  // consulte (et on l'alimente) uniquement pour les GET pleins sans Range.
  const wantsRange = request.headers.get("range") !== null;
  if (!wantsRange) {
    try {
      const cached = await cache.match(cacheKey);
      if (cached) return cached;
    } catch {
      // Couche cache indisponible : on sert depuis B2, jamais de 500.
    }
  }

  const row = await env.DB.prepare(`
    SELECT object_key, object_key_mp3, statut
    FROM audio_catalog
    WHERE categorie_audio = ?
    LIMIT 1
  `).bind(categorie).first();
  if (!row) return json({ error: "unknown_track" }, 404);

  const range = request.headers.get("range") ?? undefined;
  let found;
  let usedKey;
  if (variationDemandee) {
    // Chemin variation : STRICTEMENT limité aux pistes EN_LIGNE de cette
    // catégorie (jamais de bascule silencieuse vers un autre gabarit).
    const variante = await env.DB.prepare(`
      SELECT object_key FROM bgm_library
      WHERE categorie_audio = ? AND variation = ? AND statut = 'EN_LIGNE'
      LIMIT 1
    `).bind(categorie, variationDemandee).first();
    if (!variante) {
      return json({ error: "variation_not_available" }, 404);
    }
    found = await b2GetMedia(env, variante.object_key, range);
    usedKey = variante.object_key;
    if (found.status === 503 || found.status === 502) {
      return json({ error: found.error }, found.status);
    }
    if (found.status !== 200 && found.status !== 206) {
      return json({ error: "track_not_uploaded" }, 404);
    }
  } else {
    found = await b2GetMedia(env, row.object_key, range);
    usedKey = row.object_key;
    if (found.status === 404) {
      found = await b2GetMedia(env, row.object_key_mp3, range);
      usedKey = row.object_key_mp3;
    }
    if (found.status === 404) {
      // Repli honnete : variation de la bibliotheque BGM (synthese CC0 etiquetee).
      // Un master humain depose sur le chemin titulaire garde la priorite.
      const variante = await env.DB.prepare(`
        SELECT object_key FROM bgm_library
        WHERE categorie_audio = ? AND statut = 'EN_LIGNE'
        ORDER BY variation
        LIMIT 1
      `).bind(categorie).first();
      if (variante) {
        found = await b2GetMedia(env, variante.object_key, range);
        usedKey = variante.object_key;
      }
    }
  }
  if (found.status === 503 || found.status === 502) {
    return json({ error: found.error }, found.status);
  }
  if (found.status !== 200 && found.status !== 206) {
    return json({ error: "track_not_uploaded" }, 404);
  }

  if (!variationDemandee && row.statut !== "EN_LIGNE") {
    await env.DB.prepare(`
      UPDATE audio_catalog
      SET statut = 'EN_LIGNE',
          object_key = ?,
          etag = ?,
          taille_octets = ?,
          en_ligne_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now'),
          updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
      WHERE categorie_audio = ?
    `).bind(
      usedKey,
      found.etag || null,
      found.status === 200 && found.length ? Number(found.length) : null,
      categorie
    ).run();
  }

  const headers = {
    "content-type": found.ctype,
    "cache-control": "public, max-age=2592000, immutable",
    "accept-ranges": "bytes"
  };
  if (found.etag) headers.etag = found.etag;
  if (found.length) headers["content-length"] = found.length;
  if (found.status === 206 && found.contentRange) {
    headers["content-range"] = found.contentRange;
  }

  const response = new Response(found.body, {
    status: found.status,
    headers
  });

  if (found.status === 200 && !wantsRange) {
    try {
      await cache.put(cacheKey, response.clone());
    } catch {
      // Le cache bord est un accelerateur, jamais une dependance.
    }
  }
  return response;
}

async function routeInsProfile(url, env) {           // GET /api/v1/ins/profile?fingerprint=
  const fp = url.searchParams.get("fingerprint") ?? "";
  if (fp.length < 16) return json({ error: "fingerprint requis" }, 400);
  const row = await env.DB.prepare(
    "SELECT device_class, portrait_strategy, r_th, c_th FROM device_profiles WHERE fingerprint=?1"
  ).bind(fp).first();
  return row ? json({ known: true, ...row }, 200, CACHE_MANIFEST)
             : json({ known: false }, 404, CACHE_MANIFEST);
}

async function routeManifest(url, env, canary) {     // GET /api/v1/templates/[canary/]manifest.json
  const key = canary ? "assets/templates/canary/manifest.json"
                     : "assets/templates/v1/manifest.json";
  const obj = await b2Get(env, key);
  if (obj) {
    return new Response(obj.body, { headers: { "content-type": "application/json", ...CACHE_MANIFEST, etag: obj.etag } });
  }
  /*
   * Audit D40 (A10) : l'objet B2 est absent depuis toujours (binding
   * VV_ASSETS_BUCKET manquant dans wrangler.jsonc) -> la route rendait 404
   * "manifeste absent" en production et le catalogue skins etait mort.
   * Repli : manifeste construit depuis D1 (templates actifs), vignettes =
   * visuels sectoriels publies sous assets/templates/v1/thumbs/.
   */
  try {
    const result = await env.DB.prepare(
      `SELECT id, secteur, langue, duree_cible_s
       FROM templates
       WHERE actif = 1
       ORDER BY secteur, langue, duree_cible_s
       LIMIT 500`
    ).all();
    const rows = result?.results ?? [];
    const origin = url.origin;
    const skins = rows.map((row) => ({
      id: row.id,
      name: `${row.secteur} · ${row.langue} · ${row.duree_cible_s}s`,
      sector: row.secteur,
      thumb: `${origin}/api/v1/assets/templates/v1/thumbs/sector_${row.secteur}.webp`
    }));
    return json(
      { version: canary ? "d1-canary-1" : "d1-live-1", min_app_version: "0.0.0", skins },
      200,
      CACHE_MANIFEST
    );
  } catch {
    return json({ error: "manifeste absent" }, 404);
  }
}

async function routeAsset(path, env) {               // GET /api/v1/assets/*  (immuable, 30 j)
  const key = "assets/" + path.replace(/^\/api\/v1\/assets\//, "");
  if (key.includes("..")) return json({ error: "non" }, 400);
  const obj = await b2Get(env, key);
  if (!obj) return json({ error: "absent" }, 404);
  return new Response(obj.body, { headers: { "content-type": obj.ctype, ...CACHE_IMMUTABLE, etag: obj.etag } });
}

async function routeTelemetry(req, env) {            // POST /api/v1/telemetry (batch <= 200)
  const { events = [] } = await req.json();
  const stmt = await env.DB.prepare(
    `INSERT INTO telemetry_events (app_version, device_class, event, gabarit_id, ok, duration_ms, cta_clicks, country, ts)
     VALUES (?1,?2,?3,?4,?5,?6,?7,?8,?9)`);
  for (const e of events.slice(0, 200))
    await stmt.bind(e.v ?? "", e.dc ?? "", e.e ?? "", e.g ?? "", e.ok ? 1 : 0,
                    e.ms ?? 0, e.cta ?? 0, e.co ?? "", e.ts ?? new Date().toISOString()).run();
  return json({ accepted: Math.min(events.length, 200) });
}

async function routeFlags(url, env) {                // GET /api/v1/flags?fingerprint=  (canary 10 %)
  const fp = url.searchParams.get("fingerprint") ?? "";
  const canary = (fp.charCodeAt(fp.length - 1) % 10) < 1;
  return json({ templates_channel: canary ? "canary" : "stable" }, 200, CACHE_MANIFEST);
}

/* =====================================================
   Phase B (v0.9.0) - AJOUTS ADDITIFS B4/B5/V7 (2.2, 2.4) :
   monetisation R1, consentements R4, parrainage R8, welcome grant.
   Rien d'existant n'est modifie ; HMAC via Web Crypto ; comparaison
   temporelle constante via constantTimeStringEqual (coffre-fort, 804).
   ===================================================== */

async function hmacSha256Hex(secret, body) {
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );
  const signature = await crypto.subtle.sign("HMAC", key, new TextEncoder().encode(body));
  return Array.from(new Uint8Array(signature))
    .map(byte => byte.toString(16).padStart(2, "0"))
    .join("");
}

async function recomputeEntitlements(env, merchantId) {
  const now = new Date().toISOString();
  const sub = await env.DB.prepare(
    "SELECT plan, status, renews_at FROM subscriptions WHERE merchant_id=?1"
  ).bind(merchantId).first();
  const active = !!sub && sub.status === "active" && (!sub.renews_at || sub.renews_at >= now);
  const fpRow = await env.DB.prepare(
    "SELECT signup_fingerprint fp FROM merchant_identity WHERE user_id=?1"
  ).bind(merchantId).first();
  const grant = fpRow && fpRow.fp ? await env.DB.prepare(
    `SELECT credits_total - credits_used credits_left,
            cloud_total - cloud_used cloud_left
     FROM welcome_grants WHERE fingerprint=?1`
  ).bind(fpRow.fp).first() : null;
  const credits = grant ? grant.credits_left : 0;

  let e = { watermark: 1, endcard_mention: 1, max_res: "720p", exports_limit: 0,
            fair_use: null, cloud_renders: 0, brand_kit: 0, cache_days: 3 };
  if (credits > 0) {
    e = { watermark: 0, endcard_mention: 1, max_res: "1080p", exports_limit: credits,
          fair_use: null, cloud_renders: grant.cloud_left, brand_kit: 0, cache_days: 3 };
  }
  if (active && sub.plan === "pass24h") {
    e = { watermark: 0, endcard_mention: 1, max_res: "1080p", exports_limit: 6,
          fair_use: null, cloud_renders: 1, brand_kit: 0, cache_days: 1 };
  }
  if (active && sub.plan === "pro") {
    e = { watermark: 0, endcard_mention: 1, max_res: "1080p", exports_limit: 9999,
          fair_use: 90, cloud_renders: 5, brand_kit: 1, cache_days: 14 };
  }
  if (active && sub.plan === "boutique") {
    e = { watermark: 0, endcard_mention: 0, max_res: "1080p", exports_limit: 200,
          fair_use: null, cloud_renders: 20, brand_kit: 1, cache_days: 30 };
  }
  await env.DB.prepare(
    `INSERT OR REPLACE INTO entitlements
       (merchant_id, watermark, endcard_mention, max_res, exports_limit,
        fair_use, cloud_renders, brand_kit, cache_days, updated_at)
     VALUES (?1,?2,?3,?4,?5,?6,?7,?8,?9,?10)`
  ).bind(merchantId, e.watermark, e.endcard_mention, e.max_res, e.exports_limit,
         e.fair_use, e.cloud_renders, e.brand_kit, e.cache_days, now).run();
}

// Grille tarifaire FINALE (contrat 9.1) : 3 forfaits stricts, aucun autre prix.
// Constante MODULE (audit D41) : partagee par le webhook interne, le checkout
// CinetPay et la notification instantanee — une seule source de verite.
const PLAN_GRID = { pass24h: 500, pro: 3000, boutique: 7500 };
const PLAN_DAYS = { pass24h: 1, pro: 30, boutique: 30 };

/** Ref de commande : compatible de la regex cliente ^[A-Z]{2,6}-[0-9a-f-]{6,36}$. */
function newBillingRef() {
  return "VV-" + crypto.randomUUID().replaceAll("-", "").slice(0, 13);
}

/**
 * Point UNIQUE de credit d'une commande payee (audit D41, F10) — appele par le
 * webhook interne HMAC ET par la notification CinetPay (apres verification
 * /v2/payment/check). Idempotent : une ref deja creditee (statut autre que
 * « pending ») retourne { duplicate: true } sans jamais re-crediter.
 * e = { ref, merchant_id?, amount, status, provider, plan, renews_at? }
 */
async function applyPaidOrder(env, e) {
  const existing = await env.DB.prepare(
    "SELECT id, status, merchant_id FROM billing_orders WHERE id=?1"
  ).bind(e.ref).first();
  if (existing && existing.status !== "pending") return { duplicate: true };
  // Checkout : le marchand est celui de la COMMANDE (source liee au JWT du
  // checkout), jamais celui du corps de notification.
  const merchantId = existing ? existing.merchant_id : e.merchant_id;
  if (typeof merchantId !== "string" || !merchantId) {
    return { error: "champs requis : ref, merchant_id" };
  }
  if (typeof e.plan !== "string" || !(e.plan in PLAN_GRID)) {
    return { error: "plan hors grille officielle" };
  }
  if (Number(e.amount) !== PLAN_GRID[e.plan]) {
    return { error: "montant hors grille officielle" };
  }
  const startedAt = new Date().toISOString();
  // C16 (bug revenu critique) : le prestataire envoie "paid" ; recomputeEntitlements
  // exige "active" (schema 0005). billing_orders conserve le statut brut.
  const CANCELED_STATES = new Set(["refunded", "canceled", "cancelled", "failed", "expired"]);
  const subStatus = CANCELED_STATES.has(String(e.status).toLowerCase()) ? "canceled" : "active";
  let renewsAt = typeof e.renews_at === "string" && e.renews_at ? e.renews_at : null;
  if (!renewsAt) {
    renewsAt = new Date(Date.now() + PLAN_DAYS[e.plan] * 86400000).toISOString();
  }
  await env.DB.batch([                                 // order + subscription, atomique
    env.DB.prepare(`INSERT INTO billing_orders (id, merchant_id, amount_fcfa, currency, status, provider, provider_ref, created_at)
                    VALUES (?1,?2,?3,'XOF',?4,?5,?6,?7)
                    ON CONFLICT(id) DO UPDATE SET status=excluded.status, provider=excluded.provider, provider_ref=excluded.provider_ref`)
        .bind(e.ref, merchantId, Number(e.amount), String(e.status), String(e.provider ?? ""), e.ref, startedAt),
    env.DB.prepare(`INSERT INTO subscriptions (merchant_id, plan, status, started_at, renews_at, provider, provider_ref)
                    VALUES (?1,?2,?3,?4,?5,?6,?7)
                    ON CONFLICT(merchant_id) DO UPDATE SET plan=?2, status=?3, renews_at=?5, provider_ref=?7`)
        .bind(merchantId, e.plan, subStatus, startedAt, renewsAt, String(e.provider ?? ""), e.ref),
  ]);
  await recomputeEntitlements(env, merchantId);
  await applyReferralRewards(env, merchantId);         // conversion + recompense R8
  return { ok: true };
}

async function routeBillingWebhook(req, env) {        // POST /api/v1/internal/billing/webhook
  const sig = req.headers.get("x-webhook-signature") ?? "";
  const body = await req.text();
  const secret = env.BILLING_WEBHOOK_SECRET;
  if (typeof secret !== "string" || secret.length < 32) {
    return json({ error: "not_found" }, 404);
  }
  const mac = await hmacSha256Hex(secret, body);       // Web Crypto
  if (!constantTimeStringEqual(mac, sig)) return json({ error: "signature invalide" }, 401);
  let e;
  try {
    e = JSON.parse(body);
  } catch {
    return json({ error: "corps invalide" }, 400);
  }
  if (!e || typeof e.ref !== "string" || !e.ref ||
      typeof e.merchant_id !== "string" || !e.merchant_id) {
    return json({ error: "champs requis : ref, merchant_id" }, 400);
  }
  // Audit D41 : le plan doit OBLIGATOIREMENT exister dans la grille officielle —
  // avant, un plan inconnu (ou absent) passait la validation conditionnelle et
  // creait un abonnement hors contrat (montant libre).
  if (typeof e.plan !== "string" || !(e.plan in PLAN_GRID)) {
    return json({ error: "plan hors grille officielle" }, 422);
  }
  if (Number(e.amount) !== PLAN_GRID[e.plan]) {
    return json({ error: "montant hors grille officielle" }, 422);
  }
  const res = await applyPaidOrder(env, e);
  if (res.duplicate) return json({ ok: true, duplicate: true });
  if (res.error) return json({ error: res.error }, 422);
  return json({ ok: true });
}

/**
 * POST /api/v1/billing/checkout (JWT JWKS) — audit D41 (F10, P1).
 * Avant : AUCUNE route de checkout ; le client Android construisait une URL
 * « sandbox-checkout.cinetpay.com » INEXISTANTE (hote jamais enregistre,
 * demontre) = bouton « Payer » sans effet reel possible. Desormais la commande
 * est creee ICI (la cle CinetPay est un SECRET serveur), la grille est imposee,
 * et le client recoit le payment_url heberge a ouvrir. Fournisseur non
 * configure = 501 honnete (« billing_not_configured »), jamais de faux succes.
 */
async function routeBillingCheckout(req, env, merchantId) {
  const body = await req.json().catch(() => null);
  const plan = typeof body?.plan === "string" ? body.plan : "";
  if (!(plan in PLAN_GRID)) return json({ error: "plan_hors_grille" }, 422);
  const apiKey = env.CINETPAY_API_KEY;
  const siteId = env.CINETPAY_SITE_ID;
  if (typeof apiKey !== "string" || !apiKey || typeof siteId !== "string" || !siteId) {
    return json({ error: "billing_not_configured" }, 501);
  }
  const ref = newBillingRef();
  const amount = PLAN_GRID[plan];
  // Commande « pending » : le marchand et le montant sont FIGES cote serveur
  // (la notification ne pourra pas crediter un autre compte ni un autre prix).
  await env.DB.prepare(
    `INSERT OR IGNORE INTO billing_orders (id, merchant_id, amount_fcfa, currency, status, provider, provider_ref, created_at)
     VALUES (?1,?2,?3,'XOF','pending','cinetpay',?4,?5)`
  ).bind(ref, merchantId, amount, ref, new Date().toISOString()).run();
  const origin = new URL(req.url).origin;
  const cp = await fetch("https://api-checkout.cinetpay.com/v2/payment", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      apikey: apiKey,
      site_id: siteId,
      transaction_id: ref,
      amount,
      currency: "XOF",
      description: "Vitrine Video — forfait " + plan,
      customer_id: merchantId,
      notify_url: origin + "/api/v1/billing/notify",
      return_url: origin + "/api/v1/billing/return",
      channels: "ALL",
      lang: "FR",
      metadata: JSON.stringify({ merchant_id: merchantId, plan }),
    }),
  });
  const cpBody = await cp.json().catch(() => null);
  const paymentUrl = cpBody?.data?.payment_url;
  if (!cp.ok || cpBody?.code !== 0 || typeof paymentUrl !== "string" || !paymentUrl) {
    await env.DB.prepare(
      "UPDATE billing_orders SET status='failed' WHERE id=?1 AND status='pending'"
    ).bind(ref).run();
    return json({ error: "provider_error", provider_message: String(cpBody?.message ?? cp.status) }, 502);
  }
  return json({ ok: true, ref, payment_url: paymentUrl, plan, amount, currency: "XOF" });
}

/**
 * POST /api/v1/billing/notify — notification instantanee CinetPay (audit D41).
 * Le corps n'est JAMAIS credite tel quel : transaction_id extrait, puis statut
 * et montant RE-VERIFIES aupres de CinetPay (/v2/payment/check, cle serveur),
 * puis reconcilies avec la commande « pending » creee au checkout (montant et
 * marchand figes). Idempotent via applyPaidOrder. Reponse 200 meme pour un
 * paiement non accepte (stoppe les retries du fournisseur) — sans credit.
 */
async function routeBillingNotify(req, env) {
  const raw = await req.text();
  let tid = "";
  try {
    const j = JSON.parse(raw);
    tid = String(j?.transaction_id ?? j?.metadata?.transaction_id ?? "");
  } catch { /* corps form-urlencoded possible */ }
  if (!tid) {
    tid = String(new URLSearchParams(raw).get("transaction_id") ?? "");
  }
  if (!tid) return json({ error: "transaction_id requis" }, 400);
  const apiKey = env.CINETPAY_API_KEY;
  const siteId = env.CINETPAY_SITE_ID;
  if (typeof apiKey !== "string" || !apiKey || typeof siteId !== "string" || !siteId) {
    return json({ error: "billing_not_configured" }, 501);
  }
  const order = await env.DB.prepare(
    "SELECT id, merchant_id, amount_fcfa, status FROM billing_orders WHERE id=?1"
  ).bind(tid).first();
  if (!order) return json({ error: "commande_inconnue" }, 404);
  const check = await fetch("https://api-checkout.cinetpay.com/v2/payment/check", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ apikey: apiKey, site_id: siteId, transaction_id: tid }),
  });
  const cb = await check.json().catch(() => null);
  if (!check.ok || cb?.code !== 0) return json({ error: "verification_echouee" }, 502);
  const status = String(cb?.data?.status ?? "").toUpperCase();
  if (status !== "ACCEPTED") {
    await env.DB.prepare(
      "UPDATE billing_orders SET status='failed' WHERE id=?1 AND status='pending'"
    ).bind(tid).run();
    return json({ ok: true, ignored: status || "statut_inconnu" });
  }
  const amountPrest = Number(cb?.data?.amount);
  if (!Number.isFinite(amountPrest) || amountPrest !== Number(order.amount_fcfa)) {
    return json({ error: "montant_incoherent" }, 422);
  }
  // Le plan est DERIVE du montant fige au checkout (la grille est injective :
  // 500→pass24h, 3000→pro, 7500→boutique) — aucun champ de plan venant du corps.
  const plan = Object.keys(PLAN_GRID).find((p) => PLAN_GRID[p] === Number(order.amount_fcfa));
  if (!plan) return json({ error: "montant_hors_grille" }, 422);
  const res = await applyPaidOrder(env, {
    ref: tid,
    amount: order.amount_fcfa,
    status: "paid",
    provider: "cinetpay",
    plan,
  });
  if (res.duplicate) return json({ ok: true, duplicate: true });
  if (res.error) return json({ error: res.error }, 422);
  return json({ ok: true });
}

async function routeMyEntitlements(env, merchantId) { // GET /api/v1/me/entitlements (JWT JWKS requis)
  const sub = await env.DB.prepare("SELECT plan, renews_at FROM subscriptions WHERE merchant_id=?1")
    .bind(merchantId).first();
  if (sub && sub.renews_at && sub.renews_at < new Date().toISOString())   // expiration PARESSEUSE
    await recomputeEntitlements(env, merchantId);                          // (Pass 24 h inclus, sans cron)
  const row = await env.DB.prepare(
    `SELECT watermark, endcard_mention, max_res, exports_limit, fair_use, cloud_renders, brand_kit, cache_days
     FROM entitlements WHERE merchant_id=?1`).bind(merchantId).first();
  const fp = await env.DB.prepare("SELECT signup_fingerprint fp FROM merchant_identity WHERE user_id=?1").bind(merchantId).first();
  const grant = fp && fp.fp ? await env.DB.prepare(
    `SELECT credits_total - credits_used credits_left, cloud_total - cloud_used cloud_left
     FROM welcome_grants WHERE fingerprint=?1`).bind(fp.fp).first() : null;
  return json({ ...(row ?? { watermark: 1, endcard_mention: 1, max_res: "720p", exports_limit: 0,
                             fair_use: null, cloud_renders: 0, brand_kit: 0, cache_days: 3 }),
                welcome_credits_left: grant ? grant.credits_left : 0,
                welcome_cloud_left: grant ? grant.cloud_left : 0 },
              200, { "cache-control": "private, max-age=3600" });
}

async function routeConsent(req, env, merchantId) {   // POST /api/v1/consents (batch, JWT JWKS)
  const { records = [] } = await req.json();
  const stmt = env.DB.prepare(`INSERT OR IGNORE INTO consent_records
    (id, merchant_id, project_id, scope, face_count, text_version, app_version, device_id, ts, revoked_at)
    VALUES (?1,?2,?3,?4,?5,?6,?7,?8,?9,?10)`);
  const cmds = records.slice(0, 50).map(r => stmt.bind(r.id, merchantId, r.pid, r.scope, r.faces ?? null,
    r.tv, r.av, r.did, r.ts, r.revoked ?? null));
  await env.DB.batch(cmds);                            // INSERT OR IGNORE = idempotent (rejeu offline)
  return json({ accepted: cmds.length });
}

const REF_WORDS = ["SHALOM","AKWABA","NOUMA","WAKA","ZOVI","KPACLIA","ADJA","HOUNA","SENA","MIFA"];
function newReferralCode() {                              // ex. SHALOM-842
  return REF_WORDS[Math.floor(Math.random()*REF_WORDS.length)] + "-" + (100+Math.floor(Math.random()*900));
}
async function ensureReferralCode(env, merchantId) {      // lazy backfill (comptes crees avant 0007)
  // 0009 : merchant_identity (cle = users.id). Avant ce correctif, la boucle
  // UPDATE merchants ne touchait aucune ligne (id incompatible) puis levait
  // "refcode_collision" => /me/referral repondait 500 pour tous les comptes.
  await env.DB.prepare(
    "INSERT OR IGNORE INTO merchant_identity (user_id) VALUES (?1)"
  ).bind(merchantId).run();
  const row = await env.DB.prepare(
    "SELECT referral_code FROM merchant_identity WHERE user_id=?1"
  ).bind(merchantId).first();
  if (row && row.referral_code) return row.referral_code;
  for (let i = 0; i < 12; i++) {                            // UNIQUE : 12 tentatives (espace 9 000 codes)
    const code = newReferralCode();
    await env.DB.prepare(
      "UPDATE merchant_identity SET referral_code=?1 WHERE user_id=?2 AND referral_code IS NULL"
    ).bind(code, merchantId).run();
    const check = await env.DB.prepare(
      "SELECT referral_code FROM merchant_identity WHERE user_id=?1"
    ).bind(merchantId).first();
    if (check && check.referral_code) return check.referral_code;
  }
  throw new Error("refcode_collision");
}

async function routeMyReferral(env, merchantId) {         // GET /api/v1/me/referral (JWT JWKS)
  const code = await ensureReferralCode(env, merchantId);
  const rows = await env.DB.prepare(
    `SELECT status, converted_at FROM referrals WHERE referrer_id=?1 ORDER BY id`).bind(merchantId).all();
  const converted = rows.results.filter(r => r.status === "converted").length;
  return json({ code, converted, target: 5,
                rewards: Math.floor(converted / 5),
                history: rows.results.slice(-20) }, 200, { "cache-control": "private, max-age=60" });
}

async function routeReferralClaim(req, env, merchantId) { // POST /api/v1/me/referral/claim { code, fingerprint }
  const { code = "", fingerprint = "" } = await req.json();
  const ref = await env.DB.prepare(
    "SELECT user_id AS id, signup_fingerprint FROM merchant_identity WHERE referral_code=?1"
  ).bind(code.trim().toUpperCase()).first();
  if (!ref || ref.id === merchantId) return json({ error: "code invalide" }, 404);       // anti auto-parrainage
  if (fingerprint && ref.signup_fingerprint === fingerprint) return json({ error: "même appareil" }, 409);
  await env.DB.prepare(`INSERT OR IGNORE INTO referrals (referrer_id, referred_id, status)
                        VALUES (?1,?2,'pending')`).bind(ref.id, merchantId).run();       // UNIQUE(referred_id)
  await env.DB.prepare(
    `INSERT INTO merchant_identity (user_id, referred_by) VALUES (?1,?2)
     ON CONFLICT(user_id) DO UPDATE SET
       referred_by=COALESCE(merchant_identity.referred_by, excluded.referred_by)`)
    .bind(merchantId, code.trim().toUpperCase()).run();
  return json({ ok: true });
}

async function applyReferralRewards(env, merchantId) {
  const upd = await env.DB.prepare(
    `UPDATE referrals SET status='converted', converted_at=?1
     WHERE referred_id=?2 AND status='pending'`).bind(new Date().toISOString(), merchantId).run();
  if (!upd.meta.changes) return;                          // pas de filleul ou deja converti
  const refRow = await env.DB.prepare("SELECT referrer_id FROM referrals WHERE referred_id=?1")
    .bind(merchantId).first();
  const counted = await env.DB.prepare(
    "SELECT COUNT(*) converted FROM referrals WHERE referrer_id=?1 AND status='converted'")
    .bind(refRow.referrer_id).first();
  const rewarded = await env.DB.prepare(
    "SELECT COUNT(*) rewards FROM referrals WHERE referrer_id=?1 AND reward_granted=1")
    .bind(refRow.referrer_id).first();
  const due = Math.floor(counted.converted / 5) - rewarded.rewards;   // paliers de 5 ; idempotent
  if (due <= 0) return;
  const pending = await env.DB.prepare(
    `SELECT id FROM referrals WHERE referrer_id=?1 AND status='converted' AND reward_granted=0
     ORDER BY converted_at LIMIT ?2`).bind(refRow.referrer_id, due).all();
  const cmds = [env.DB.prepare(
    "UPDATE subscriptions SET renews_at=date(COALESCE(renews_at,'now'),?1), source='referral' WHERE merchant_id=?2")
    .bind("+" + (30 * due) + " days", refRow.referrer_id)];
  for (const p of pending.results)
    cmds.push(env.DB.prepare("UPDATE referrals SET reward_granted=1 WHERE id=?1").bind(p.id));
  cmds.push(env.DB.prepare(`INSERT INTO subscriptions (merchant_id, plan, status, renews_at, provider, provider_ref, source)
    VALUES (?1,'pro','active',date('now','+30 days'),'referral','reward','referral')
    ON CONFLICT(merchant_id) DO UPDATE SET plan='pro', status='active', source='referral',
      renews_at=MAX(date(COALESCE(renews_at,'now'),date('now')), date('now','+30 days'))`)
    .bind(refRow.referrer_id));                           // parrain gratuit -> Pro offert 30 j
  await env.DB.batch(cmds);
  await recomputeEntitlements(env, refRow.referrer_id);
}

async function routeWelcomeGrant(req, env, merchantId) {  // POST /api/v1/me/welcome-grant { fingerprint }
  const { fingerprint = "" } = await req.json();
  if (fingerprint.length < 16) return json({ error: "fingerprint requis" }, 400);
  const existing = await env.DB.prepare(
    "SELECT credits_total, credits_used FROM welcome_grants WHERE fingerprint=?1").bind(fingerprint).first();
  if (existing)                                            // MEME telephone, autre compte Google :
    return json({ granted: false,                          // rien n'est reinitialise, rien n'est ajoute
                 credits_left: existing.credits_total - existing.credits_used }, 200);
  // C16 (anti-fraude) : spec 9.1 = credits « attribues une fois ». Le verrou par
  // empreinte seule permettait a UN compte de multiplier les appareils fictifs
  // (N empreintes => N x 3 credits). On refuse donc tout nouvel octroi des que le
  // compte est deja lie a une empreinte, en renvoyant son solde reel.
  const bound = await env.DB.prepare(
    "SELECT signup_fingerprint fp FROM merchant_identity WHERE user_id=?1").bind(merchantId).first();
  if (bound && bound.fp && bound.fp !== fingerprint) {
    const row = await env.DB.prepare(
      "SELECT credits_total, credits_used FROM welcome_grants WHERE fingerprint=?1").bind(bound.fp).first();
    return json({ granted: false,
                  credits_left: row ? row.credits_total - row.credits_used : 0,
                  reason: "already_granted" }, 200);
  }
  const referred = await env.DB.prepare("SELECT 1 x FROM referrals WHERE referred_id=?1").bind(merchantId).first();
  const total = referred ? 5 : 3;                          // 3 credits offerts, 5 si inscription parrainee (9.8)
  await env.DB.prepare(`INSERT OR IGNORE INTO welcome_grants
    (fingerprint, merchant_first_id, credits_total, credits_used, cloud_total, cloud_used, granted_at)
    VALUES (?1,?2,?3,0,1,0,?4)`).bind(fingerprint, merchantId, total, new Date().toISOString()).run();
  // 0009 : jointure marchande portee par merchant_identity (cle = users.id).
  // L'ancien UPDATE merchants ... WHERE id=users.id ne matchait jamais : merchants.id
  // est un UUID de PROFIL COMMERCE distinct => credits bienvenue invisibles serveur.
  await env.DB.prepare(
    `INSERT INTO merchant_identity (user_id, signup_fingerprint) VALUES (?1,?2)
     ON CONFLICT(user_id) DO UPDATE SET
       signup_fingerprint=COALESCE(merchant_identity.signup_fingerprint, excluded.signup_fingerprint)`)
    .bind(merchantId, fingerprint).run();
  return json({ granted: true, credits_total: total }, 200);
}

async function routeQuotaConsume(req, env, merchantId) {  // POST /api/v1/quota/consume (JWT JWKS)
  const { eventId = "", fingerprint = "", source = "", kind = "" } = await req.json();
  // Audit D41 : eventId est la PRIMARY KEY de quota_ledger (0005) — un eventId
  // vide entrait en collision GLOBALE (le 2e consommateur avec "" etait ignore
  // silencieusement, sa consommation jamais comptee) et permettait le rejeu
  // croise. Il est desormais requis.
  if (typeof eventId !== "string" || eventId.trim() === "") {
    return json({ error: "eventId requis (cle d'idempotence)" }, 400);
  }
  // Audit D41 : pour source=welcome, le serveur verifie que l'empreinte debitee
  // est bien celle liee au compte (merchant_identity). Avant, n'importe quel
  // fingerprint etait accepte — un client compromis pouvait decrementer les
  // credits d'un AUTRE appareil ou rejouer une empreinte non liee.
  if (source === "welcome") {
    if (typeof fingerprint !== "string" || fingerprint.length < 16) {
      return json({ error: "fingerprint requis pour source=welcome" }, 400);
    }
    // D42.8 (P1, mesure sur banc D1 local) : le controle n'etait applique que si
    // le compte AVAIT deja une ligne merchant_identity. Un compte sans liaison
    // (`lie` nul) passait donc sans controle et pouvait debiter la dotation de
    // bienvenue d'un AUTRE marchand en envoyant son empreinte. Reproduit : un
    // compte B jamais lie a porte les 3 credits de A a zero.
    // Regle : l'empreinte debitee doit appartenir au compte appelant —
    // soit par la liaison merchant_identity, soit par la propriete du grant.
    const lie = await env.DB.prepare(
      "SELECT signup_fingerprint fp FROM merchant_identity WHERE user_id=?1"
    ).bind(merchantId).first();
    if (lie && lie.fp) {
      if (lie.fp !== fingerprint) {
        return json({ error: "fingerprint non lie a ce compte" }, 403);
      }
    } else {
      // Compte non lie : seule une dotation dont il est le PREMIER titulaire
      // peut etre debitee (comptes anterieurs a la liaison 0009).
      const sien = await env.DB.prepare(
        "SELECT 1 x FROM welcome_grants WHERE fingerprint=?1 AND merchant_first_id=?2"
      ).bind(fingerprint, merchantId).first();
      if (!sien) {
        return json({ error: "fingerprint non lie a ce compte" }, 403);
      }
    }
  }
  const led = await env.DB.prepare(`INSERT OR IGNORE INTO quota_ledger
    (event_id, merchant_id, fingerprint, source, kind, ts) VALUES (?1,?2,?3,?4,?5,?6)`)
    .bind(eventId, merchantId, fingerprint, source, kind, new Date().toISOString()).run();
  if (!led.meta.changes) return json({ ok: true, dup: true });        // rejeu offline : compte une seule fois
  if (source === "welcome" && fingerprint)
    await env.DB.prepare(kind === "cloud"
      ? "UPDATE welcome_grants SET cloud_used=MIN(cloud_total,cloud_used+1) WHERE fingerprint=?1"
      : "UPDATE welcome_grants SET credits_used=MIN(credits_total,credits_used+1) WHERE fingerprint=?1")
      .bind(fingerprint).run();
  return json({ ok: true });
}

/* =====================================================
   PROFILS DE SANTÉ
===================================================== */

async function health(env) {
  try {
    await env.DB.prepare(
      "SELECT 1 AS ok"
    ).first();

    const result = await env.DB.prepare(`
      SELECT COUNT(*) AS total
      FROM sqlite_master
      WHERE type = 'table'
        AND name IN (
          'users',
          'merchants',
          'projects',
          'templates',
          'orders',
          'files',
          'quota_events',
          'notifications'
        )
    `).first();

    const count = Number(result?.total ?? 0);
    const ready = count === 8;

    return json({
      service: "vitrine-video-api",
      status: ready ? "ok" : "degraded",
      database: "connected",
      schema: ready ? "ready" : "incomplete",
      applicationTables: count,
      version: "0.9.0"
    }, ready ? 200 : 503);

  } catch {
    return json({
      service: "vitrine-video-api",
      status: "degraded",
      database: "unavailable"
    }, 503);
  }
}

/* =====================================================
   API DES COMMERCES
===================================================== */

async function handleMerchantCollection(request, env, user) {
  if (request.method === "GET") {
    const result = await env.DB.prepare(`
      SELECT
        id,
        nom_commerce,
        secteur,
        ville,
        ton,
        public_cible,
        coordonnees,
        created_at
      FROM merchants
      WHERE user_id = ?
      ORDER BY created_at DESC
      LIMIT 50
    `).bind(user.id).all();

    const data = (result.results ?? []).map(exposeMerchant);

    return json({
      data,
      count: data.length
    });
  }

  const parsed = await readJsonBody(request);

  if (!parsed.ok) return parsed.response;

  const body = parsed.body;

  const name = normalizeText(body.nom_commerce, 120, true);
  const sector = normalizeText(body.secteur, 80, true);
  const city = normalizeText(body.ville, 120);
  const target = normalizeText(body.public_cible, 300);
  const coordinates = normalizeCoordinates(body.coordonnees);

  const tone = body.ton === undefined
    ? { ok: true, value: "neutre" }
    : normalizeText(body.ton, 30, true);

  if (
    !name.ok ||
    !sector.ok ||
    !city.ok ||
    !target.ok ||
    !coordinates.ok ||
    !tone.ok ||
    !ALLOWED_TONES.includes(tone.value)
  ) {
    return json({
      error: "validation_failed"
    }, 400);
  }

  const id = createUUIDv7();

  await env.DB.prepare(`
    INSERT INTO merchants (
      id,
      user_id,
      nom_commerce,
      secteur,
      ville,
      ton,
      public_cible,
      coordonnees
    )
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `).bind(
    id,
    user.id,
    name.value,
    sector.value,
    city.value,
    tone.value,
    target.value,
    coordinates.value
      ? JSON.stringify(coordinates.value)
      : null
  ).run();

  const merchant = await env.DB.prepare(`
    SELECT
      id,
      nom_commerce,
      secteur,
      ville,
      ton,
      public_cible,
      coordonnees,
      created_at
    FROM merchants
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `).bind(
    id,
    user.id
  ).first();

  return json({
    data: exposeMerchant(merchant)
  }, 201);
}

async function handleSingleMerchant(request, env, user, id) {
  const existing = await env.DB.prepare(`
    SELECT
      id,
      nom_commerce,
      secteur,
      ville,
      ton,
      public_cible,
      coordonnees,
      created_at
    FROM merchants
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `).bind(
    id,
    user.id
  ).first();

  if (!existing) {
    return json({
      error: "merchant_not_found"
    }, 404);
  }

  if (request.method === "GET") {
    return json({
      data: exposeMerchant(existing)
    });
  }

  const parsed = await readJsonBody(request);

  if (!parsed.ok) return parsed.response;

  const body = parsed.body;
  const updates = [];

  for (const [field, max, required] of [
    ["nom_commerce", 120, true],
    ["secteur", 80, true],
    ["ville", 120, false],
    ["public_cible", 300, false]
  ]) {
    if (Object.hasOwn(body, field)) {
      const value = normalizeText(
        body[field],
        max,
        required
      );

      if (!value.ok) {
        return json({
          error: "validation_failed",
          field
        }, 400);
      }

      updates.push([field, value.value]);
    }
  }

  if (Object.hasOwn(body, "ton")) {
    const tone = normalizeText(body.ton, 30, true);

    if (!tone.ok || !ALLOWED_TONES.includes(tone.value)) {
      return json({
        error: "validation_failed",
        field: "ton"
      }, 400);
    }

    updates.push(["ton", tone.value]);
  }

  if (Object.hasOwn(body, "coordonnees")) {
    const coordinates = normalizeCoordinates(
      body.coordonnees
    );

    if (!coordinates.ok) {
      return json({
        error: "validation_failed",
        field: "coordonnees"
      }, 400);
    }

    updates.push([
      "coordonnees",
      coordinates.value
        ? JSON.stringify(coordinates.value)
        : null
    ]);
  }

  if (!updates.length) {
    return json({
      error: "no_changes"
    }, 400);
  }

  const assignments = updates.map(
    ([field]) => `${field} = ?`
  );

  const values = updates.map(([, value]) => value);

  await env.DB.prepare(`
    UPDATE merchants
    SET ${assignments.join(", ")}
    WHERE id = ? AND user_id = ?
  `).bind(
    ...values,
    id,
    user.id
  ).run();

  const updated = await env.DB.prepare(`
    SELECT
      id,
      nom_commerce,
      secteur,
      ville,
      ton,
      public_cible,
      coordonnees,
      created_at
    FROM merchants
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `).bind(
    id,
    user.id
  ).first();

  return json({
    data: exposeMerchant(updated)
  });
}

/* =====================================================
   API DES PROJETS
===================================================== */

async function handleProjectCollection(request, env, user) {
  if (request.method === "GET") {
    const result = await env.DB.prepare(`
      SELECT
        id,
        merchant_id,
        titre,
        langue,
        statut,
        brief_json,
        created_at,
        updated_at
      FROM projects
      WHERE user_id = ?
      ORDER BY updated_at DESC
      LIMIT 50
    `).bind(user.id).all();

    const data = (result.results ?? []).map(exposeProject);

    return json({
      data,
      count: data.length
    });
  }

  const parsed = await readJsonBody(request);

  if (!parsed.ok) return parsed.response;

  const body = parsed.body;

  const merchantId = normalizeText(
    body.merchant_id,
    36,
    true
  );

  const title = normalizeText(
    body.titre,
    120,
    true
  );

  const language = body.langue === undefined
    ? { ok: true, value: "fr" }
    : normalizeText(body.langue, 10, true);

  const brief = normalizeBrief(body.brief);

  if (
    !merchantId.ok ||
    !/^[0-9a-f-]{36}$/i.test(merchantId.value ?? "") ||
    !title.ok ||
    !language.ok ||
    !ALLOWED_LANGUAGES.includes(language.value) ||
    !brief.ok
  ) {
    return json({
      error: "validation_failed"
    }, 400);
  }

  const merchant = await env.DB.prepare(`
    SELECT id
    FROM merchants
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `).bind(
    merchantId.value,
    user.id
  ).first();

  if (!merchant) {
    return json({
      error: "merchant_not_found"
    }, 404);
  }

  const id = createUUIDv7();

  await env.DB.prepare(`
    INSERT INTO projects (
      id,
      merchant_id,
      user_id,
      titre,
      langue,
      statut,
      brief_json,
      updated_at
    )
    VALUES (
      ?, ?, ?, ?, ?, 'brouillon', ?,
      strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
    )
  `).bind(
    id,
    merchantId.value,
    user.id,
    title.value,
    language.value,
    JSON.stringify(brief.value)
  ).run();

  const project = await env.DB.prepare(`
    SELECT
      id,
      merchant_id,
      titre,
      langue,
      statut,
      brief_json,
      created_at,
      updated_at
    FROM projects
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `).bind(
    id,
    user.id
  ).first();

  return json({
    data: exposeProject(project)
  }, 201);
}

async function handleSingleProject(request, env, user, id) {
  const existing = await env.DB.prepare(`
    SELECT
      id,
      merchant_id,
      titre,
      langue,
      statut,
      brief_json,
      created_at,
      updated_at
    FROM projects
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `).bind(
    id,
    user.id
  ).first();

  if (!existing) {
    return json({
      error: "project_not_found"
    }, 404);
  }

  if (request.method === "GET") {
    return json({
      data: exposeProject(existing)
    });
  }

  const parsed = await readJsonBody(request);

  if (!parsed.ok) return parsed.response;

  const body = parsed.body;
  const updates = [];

  if (Object.hasOwn(body, "titre")) {
    const title = normalizeText(body.titre, 120, true);

    if (!title.ok) {
      return json({
        error: "validation_failed",
        field: "titre"
      }, 400);
    }

    updates.push(["titre", title.value]);
  }

  if (Object.hasOwn(body, "langue")) {
    const language = normalizeText(
      body.langue,
      10,
      true
    );

    if (
      !language.ok ||
      !ALLOWED_LANGUAGES.includes(language.value)
    ) {
      return json({
        error: "validation_failed",
        field: "langue"
      }, 400);
    }

    updates.push(["langue", language.value]);
  }

  if (Object.hasOwn(body, "brief")) {
    const brief = normalizeBrief(body.brief);

    if (!brief.ok) {
      return json({
        error: "validation_failed",
        field: "brief"
      }, 400);
    }

    updates.push([
      "brief_json",
      JSON.stringify(brief.value)
    ]);
  }

  if (!updates.length) {
    return json({
      error: "no_changes"
    }, 400);
  }

  const assignments = updates.map(
    ([field]) => `${field} = ?`
  );

  const values = updates.map(([, value]) => value);

  await env.DB.prepare(`
    UPDATE projects
    SET ${assignments.join(", ")},
        updated_at = strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
    WHERE id = ? AND user_id = ?
  `).bind(
    ...values,
    id,
    user.id
  ).run();

  const updated = await env.DB.prepare(`
    SELECT
      id,
      merchant_id,
      titre,
      langue,
      statut,
      brief_json,
      created_at,
      updated_at
    FROM projects
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `).bind(
    id,
    user.id
  ).first();

  return json({
    data: exposeProject(updated)
  });
}

/* =====================================================
   API DES COMMANDES
===================================================== */

async function findOrderByKey(env, key) {
  return env.DB.prepare(`
    SELECT
      id,
      project_id,
      user_id,
      template_id,
      statut,
      moteur,
      tentative,
      audio_octets,
      proxy_octets,
      rendu_octets,
      qc_json,
      edl_final_json,
      sous_titres_vtt,
      score_asr,
      created_at,
      updated_at,
      purge_at,
      idempotency_key
    FROM orders
    WHERE idempotency_key = ?
    LIMIT 1
  `).bind(key).first();
}

async function findOrderForUser(env, id, userId) {
  return env.DB.prepare(`
    SELECT
      id,
      project_id,
      user_id,
      template_id,
      statut,
      moteur,
      tentative,
      audio_octets,
      proxy_octets,
      rendu_octets,
      qc_json,
      edl_final_json,
      sous_titres_vtt,
      score_asr,
      created_at,
      updated_at,
      purge_at,
      idempotency_key
    FROM orders
    WHERE id = ? AND user_id = ?
    LIMIT 1
  `).bind(
    id,
    userId
  ).first();
}

async function handleOrderCollection(request, env, user) {
  if (request.method === "GET") {
    const result = await env.DB.prepare(`
      SELECT
        id,
        project_id,
        user_id,
        template_id,
        statut,
        moteur,
        tentative,
        audio_octets,
        proxy_octets,
        rendu_octets,
        qc_json,
        edl_final_json,
        sous_titres_vtt,
        score_asr,
        created_at,
        updated_at,
        purge_at,
        idempotency_key
      FROM orders
      WHERE user_id = ?
      ORDER BY created_at DESC
      LIMIT 50
    `).bind(user.id).all();

    const data = (result.results ?? []).map(exposeOrder);

    return json({
      data,
      count: data.length
    });
  }

  const parsed = await readJsonBody(request);

  if (!parsed.ok) return parsed.response;

  const body = parsed.body;

  const projectId = normalizeText(
    body.project_id,
    36,
    true
  );

  const templateId = normalizeText(
    body.template_id,
    100,
    true
  );

  const key = normalizeText(
    body.idempotency_key,
    128,
    true
  );

  if (
    !projectId.ok ||
    !/^[0-9a-f-]{36}$/i.test(projectId.value ?? "") ||
    !templateId.ok ||
    !/^[A-Za-z0-9._:-]{3,100}$/.test(templateId.value ?? "") ||
    !key.ok ||
    !/^[A-Za-z0-9._:-]{8,128}$/.test(key.value ?? "")
  ) {
    return json({
      error: "validation_failed"
    }, 400);
  }

  const prior = await findOrderByKey(env, key.value);

  if (prior) {
    if (
      prior.user_id !== user.id ||
      prior.project_id !== projectId.value ||
      prior.template_id !== templateId.value
    ) {
      return json({
        error: "idempotency_conflict"
      }, 409);
    }

    return json({
      data: exposeOrder(prior),
      idempotent_replay: true
    });
  }

  const project = await env.DB.prepare(`
    SELECT
      p.id,
      p.user_id,
      p.langue,
      m.secteur
    FROM projects p
    JOIN merchants m ON m.id = p.merchant_id
    WHERE p.id = ?
      AND p.user_id = ?
      AND m.user_id = ?
    LIMIT 1
  `).bind(
    projectId.value,
    user.id,
    user.id
  ).first();

  if (!project) {
    return json({
      error: "project_not_found"
    }, 404);
  }

  const template = await env.DB.prepare(`
    SELECT
      id,
      secteur,
      langue,
      duree_cible_s,
      edl_json,
      regles_qc_json,
      version
    FROM templates
    WHERE id = ? AND actif = 1
    LIMIT 1
  `).bind(templateId.value).first();

  if (!template) {
    return json({
      error: "template_not_found"
    }, 404);
  }

  if (
    template.secteur !== project.secteur ||
    template.langue !== project.langue
  ) {
    return json({
      error: "template_incompatible",
      message: "Template sector and language must match the project."
    }, 400);
  }

  const orderId = createUUIDv7();
  const month = new Date().toISOString().slice(0, 7);

  const quota = await env.DB.prepare(`
    SELECT COUNT(*) AS total
    FROM quota_events
    WHERE user_id = ?
      AND mois = ?
      AND type = 'commande_creee'
  `).bind(
    user.id,
    month
  ).first();

  const currentCount = Number(quota?.total ?? 0);

  try {
    await env.DB.batch([
      env.DB.prepare(`
        INSERT INTO orders (
          id,
          project_id,
          user_id,
          template_id,
          statut,
          moteur,
          tentative,
          idempotency_key
        )
        VALUES (?, ?, ?, ?, 'brouillon', NULL, 0, ?)
      `).bind(
        orderId,
        projectId.value,
        user.id,
        templateId.value,
        key.value
      ),

      env.DB.prepare(`
        INSERT INTO quota_events (
          id,
          user_id,
          ordre_id,
          type,
          avant,
          apres,
          mois
        )
        VALUES (?, ?, ?, 'commande_creee', ?, ?, ?)
      `).bind(
        createUUIDv7(),
        user.id,
        orderId,
        String(currentCount),
        String(currentCount + 1),
        month
      ),

      env.DB.prepare(`
        INSERT INTO notifications (id, user_id, type, payload)
        VALUES (?, ?, 'order_created', ?)
      `).bind(
        createUUIDv7(),
        user.id,
        JSON.stringify({
          title: "Commande créée",
          message: "Votre commande publicitaire est créée et attend ses fichiers média.",
          order_id: orderId,
          status: "brouillon"
        })
      )
    ]);
  } catch {
    const duplicate = await findOrderByKey(env, key.value);

    if (
      duplicate &&
      duplicate.user_id === user.id &&
      duplicate.project_id === projectId.value &&
      duplicate.template_id === templateId.value
    ) {
      return json({
        data: exposeOrder(duplicate),
        idempotent_replay: true
      });
    }

    if (duplicate) {
      return json({
        error: "idempotency_conflict"
      }, 409);
    }

    throw new Error("Order creation failed");
  }

  const created = await findOrderForUser(
    env,
    orderId,
    user.id
  );

  if (!created) {
    return json({
      error: "order_creation_failed"
    }, 503);
  }

  return json({
    data: exposeOrder(created),
    idempotent_replay: false,
    template: {
      id: template.id,
      secteur: template.secteur,
      langue: template.langue,
      duree_cible_s: template.duree_cible_s,
      version: template.version,
      edl: safeJsonParse(template.edl_json),
      regles_qc: safeJsonParse(template.regles_qc_json)
    }
  }, 201);
}

async function handleSingleOrder(request, env, user, orderId) {
  if (request.method !== "GET") {
    return json({
      error: "method_not_allowed"
    }, 405, { allow: "GET" });
  }

  const order = await findOrderForUser(
    env,
    orderId,
    user.id
  );

  if (!order) {
    return json({
      error: "order_not_found"
    }, 404);
  }

  return json({
    data: exposeOrder(order)
  });
}

/* =====================================================
   CYCLE DE VIE DES COMMANDES — ÉVÉNEMENTS HORODATÉS
===================================================== */

function isUuid(value) {
  return typeof value === "string" &&
    /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(value);
}

async function findOrderForLifecycle(env, orderId) {
  return env.DB.prepare(`
    SELECT
      id,
      user_id,
      statut,
      callback_ts,
      callback_nonce,
      created_at,
      updated_at,
      purge_at
    FROM orders
    WHERE id = ?
    LIMIT 1
  `).bind(orderId).first();
}

async function transitionOrderStatus(
  env,
  orderId,
  expectedUserId,
  expectedStatus,
  newStatus,
  options = {}
) {
  const source = options.source ?? "unknown";
  const providedEventId = options.eventId;
  const eventId = isUuid(providedEventId)
    ? providedEventId
    : createUUIDv7();

  const order = expectedUserId
    ? await findOrderForUser(env, orderId, expectedUserId)
    : await findOrderForLifecycle(env, orderId);

  if (!order) {
    return { ok: false, changed: false, code: "order_not_found" };
  }

  const currentStatus = String(order.statut ?? "").trim().toLowerCase();

  if (currentStatus !== expectedStatus) {
    return {
      ok: false,
      changed: false,
      code: "stale_status",
      current_status: currentStatus
    };
  }

  if (!ORDER_STATUS_TRANSITIONS[currentStatus]?.has(newStatus)) {
    return {
      ok: false,
      changed: false,
      code: "transition_not_allowed",
      current_status: currentStatus,
      requested_status: newStatus
    };
  }

  if (newStatus === "fichiers_recus") {
    const confirmedRoles = await env.DB.prepare(`
      SELECT
        SUM(CASE WHEN role = 'audio' AND uploaded_at IS NOT NULL THEN 1 ELSE 0 END) AS audio_count,
        SUM(CASE WHEN role = 'proxy' AND uploaded_at IS NOT NULL THEN 1 ELSE 0 END) AS proxy_count
      FROM files
      WHERE order_id = ?
    `).bind(orderId).first();

    if (
      Number(confirmedRoles?.audio_count ?? 0) < 1 ||
      Number(confirmedRoles?.proxy_count ?? 0) < 1
    ) {
      return {
        ok: false,
        changed: false,
        code: "required_uploads_not_confirmed"
      };
    }
  }

  // Reopening an echec/annule order is allowed only during the 72-hour retry window.
  if (currentStatus === "echec" || currentStatus === "annule") {
    const terminalEvent = await env.DB.prepare(`
      SELECT created_at
      FROM quota_events
      WHERE ordre_id = ?
        AND type = 'statut_change'
        AND LOWER(TRIM(COALESCE(apres, ''))) = ?
      ORDER BY created_at DESC
      LIMIT 1
    `).bind(orderId, currentStatus).first();

    const terminalAt = terminalEvent?.created_at
      ? Date.parse(terminalEvent.created_at)
      : NaN;

    if (!Number.isFinite(terminalAt)) {
      return {
        ok: false,
        changed: false,
        code: "retry_window_timestamp_missing"
      };
    }

    const age = Date.now() - terminalAt;

    if (age < 0 || age > FAILED_CANCELLED_RETENTION_MS) {
      return {
        ok: false,
        changed: false,
        code: "retry_window_expired"
      };
    }
  }

  // The server, not the caller, establishes event time for retention.
  const eventAt = new Date().toISOString();
  const eventMonth = eventAt.slice(0, 7);
  const terminal = newStatus === "echec" || newStatus === "annule";
  const orderPurgeAt = terminal
    ? new Date(Date.parse(eventAt) + FAILED_CANCELLED_RETENTION_MS).toISOString()
    : null;
  const callbackTimestamp = options.callbackTimestamp ?? null;
  const callbackNonce = options.callbackNonce ?? null;

  const orderUpdate = env.DB.prepare(`
    UPDATE orders
    SET statut = ?,
        updated_at = ?,
        purge_at = ?,
        callback_ts = COALESCE(?, callback_ts),
        callback_nonce = COALESCE(?, callback_nonce)
    WHERE id = ?
      AND statut = ?
      AND (? IS NULL OR callback_ts IS NULL OR callback_ts < ?)
  `).bind(
    newStatus,
    eventAt,
    orderPurgeAt,
    callbackTimestamp,
    callbackNonce,
    orderId,
    currentStatus,
    callbackTimestamp,
    callbackTimestamp
  );

  const eventInsert = callbackNonce !== null
    ? env.DB.prepare(`
        INSERT INTO quota_events (
          id, user_id, ordre_id, type, avant, apres, mois, created_at
        )
        SELECT ?, o.user_id, o.id, 'statut_change', ?, ?, ?, ?
        FROM orders o
        WHERE o.id = ?
          AND o.statut = ?
          AND o.updated_at = ?
          AND o.callback_nonce = ?
      `).bind(
        eventId,
        currentStatus,
        newStatus,
        eventMonth,
        eventAt,
        orderId,
        newStatus,
        eventAt,
        callbackNonce
      )
    : env.DB.prepare(`
        INSERT INTO quota_events (
          id, user_id, ordre_id, type, avant, apres, mois, created_at
        )
        SELECT ?, o.user_id, o.id, 'statut_change', ?, ?, ?, ?
        FROM orders o
        WHERE o.id = ?
          AND o.statut = ?
          AND o.updated_at = ?
      `).bind(
        eventId,
        currentStatus,
        newStatus,
        eventMonth,
        eventAt,
        orderId,
        newStatus,
        eventAt
      );

  const filePurgeUpdate = terminal
    ? env.DB.prepare(`
        UPDATE files
        SET purge_at = CASE
          WHEN LOWER(role) IN ('rendu', 'render', 'final_render')
               AND uploaded_at IS NULL
            THEN ?
          ELSE ?
        END
        WHERE order_id = ?
          AND EXISTS (
            SELECT 1 FROM orders o
            WHERE o.id = files.order_id
              AND o.statut = ?
              AND o.updated_at = ?
          )
      `).bind(
        PENDING_PURGE_AT,
        orderPurgeAt,
        orderId,
        newStatus,
        eventAt
      )
    : newStatus === "livre"
      ? env.DB.prepare(`
          UPDATE files
          SET purge_at = CASE
            WHEN LOWER(role) IN ('audio', 'proxy') AND uploaded_at IS NOT NULL
              THEN ?
            WHEN LOWER(role) IN ('audio', 'proxy') AND uploaded_at IS NULL
              THEN ?
            ELSE purge_at
          END
          WHERE order_id = ?
            AND EXISTS (
              SELECT 1 FROM orders o
              WHERE o.id = files.order_id
                AND o.statut = 'livre'
                AND o.updated_at = ?
            )
        `).bind(
          new Date(Date.parse(eventAt) + AUDIO_PROXY_RETENTION_MS).toISOString(),
          PENDING_PURGE_AT,
          orderId,
          eventAt
        )
      : env.DB.prepare(`
          UPDATE files
          SET purge_at = ?
          WHERE order_id = ?
            AND EXISTS (
              SELECT 1 FROM orders o
              WHERE o.id = files.order_id
                AND o.statut = ?
                AND o.updated_at = ?
            )
        `).bind(
          PENDING_PURGE_AT,
          orderId,
          newStatus,
          eventAt
        );

  const notificationPayload = JSON.stringify({
    title: "Statut de commande mis à jour",
    message: `La commande est passée à l’état « ${newStatus} ».`,
    order_id: orderId,
    status: newStatus,
    previous_status: currentStatus,
    source
  });

  const notificationInsert = env.DB.prepare(`
    INSERT INTO notifications (id, user_id, type, payload)
    SELECT ?, o.user_id, 'order_status_changed', ?
    FROM orders o
    WHERE o.id = ?
      AND o.statut = ?
      AND o.updated_at = ?
      AND EXISTS (
        SELECT 1 FROM quota_events q
        WHERE q.ordre_id = o.id
          AND q.type = 'statut_change'
          AND q.avant = ?
          AND q.apres = ?
          AND q.created_at = ?
      )
  `).bind(
    createUUIDv7(),
    notificationPayload,
    orderId,
    newStatus,
    eventAt,
    currentStatus,
    newStatus,
    eventAt
  );

  const results = await env.DB.batch([
    orderUpdate,
    eventInsert,
    filePurgeUpdate,
    notificationInsert
  ]);

  const updateCount = Number(results[0]?.meta?.changes ?? 0);
  const eventCount = Number(results[1]?.meta?.changes ?? 0);

  if (updateCount !== 1 || eventCount !== 1) {
    return {
      ok: false,
      changed: false,
      code: "transition_race_or_event_write_failed"
    };
  }

  return {
    ok: true,
    changed: true,
    order_id: orderId,
    previous_status: currentStatus,
    status: newStatus,
    event_at: eventAt,
    purge_at: orderPurgeAt,
    event_id: eventId
  };
}

async function handleOwnerOrderStatus(request, env, user, orderId) {
  if (request.method !== "POST") {
    return json({
      error: "method_not_allowed"
    }, 405, { allow: "POST" });
  }

  const parsed = await readJsonBody(request, 4096);
  if (!parsed.ok) return parsed.response;

  const expected = normalizeText(parsed.body.expected_status, 40, true);
  const next = normalizeText(parsed.body.new_status, 40, true);

  if (
    !expected.ok ||
    !next.ok ||
    !ORDER_STATUS_TRANSITIONS[expected.value] ||
    !OWNER_REPORTABLE_STATUSES.has(next.value)
  ) {
    return json({
      error: "invalid_status_transition_request"
    }, 400);
  }

  const result = await transitionOrderStatus(
    env,
    orderId,
    user.id,
    expected.value,
    next.value,
    { source: "authenticated_owner_app" }
  );

  if (!result.ok) {
    const status = result.code === "order_not_found"
      ? 404
      : result.code === "stale_status" ||
        result.code === "transition_not_allowed" ||
        result.code === "required_uploads_not_confirmed" ||
        result.code === "retry_window_expired" ||
        result.code === "retry_window_timestamp_missing"
        ? 409
        : 503;

    return json({ error: result.code, current_status: result.current_status }, status);
  }

  return json({
    data: {
      order_id: result.order_id,
      previous_status: result.previous_status,
      status: result.status,
      updated_at: result.event_at,
      purge_at: result.purge_at
    },
    status_event_recorded: true
  });
}

function constantTimeHexEqual(a, b) {
  if (typeof a !== "string" || typeof b !== "string") return false;

  const left = a.toLowerCase();
  const right = b.toLowerCase();

  if (left.length !== right.length) return false;

  let diff = 0;
  for (let index = 0; index < left.length; index += 1) {
    diff |= left.charCodeAt(index) ^ right.charCodeAt(index);
  }

  return diff === 0;
}

async function lifecycleHmacHex(secret, message) {
  const key = await crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(secret),
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );

  const signed = await crypto.subtle.sign(
    "HMAC",
    key,
    new TextEncoder().encode(message)
  );

  return Array.from(new Uint8Array(signed), byte =>
    byte.toString(16).padStart(2, "0")
  ).join("");
}

async function handleSignedLifecycleStatus(request, env) {
  if (
    typeof env.ORDER_LIFECYCLE_SECRET !== "string" ||
    env.ORDER_LIFECYCLE_SECRET.length < 32
  ) {
    return json({
      error: "internal_lifecycle_not_configured"
    }, 503);
  }

  const timestampHeader = request.headers.get("x-lifecycle-timestamp") ?? "";
  const signatureHeader = request.headers.get("x-lifecycle-signature") ?? "";

  if (!/^\d{10}$/.test(timestampHeader) || !/^[a-f0-9]{64}$/i.test(signatureHeader)) {
    return json({ error: "invalid_lifecycle_signature_headers" }, 401);
  }

  const requestTimestampMs = Number(timestampHeader) * 1000;

  if (
    !Number.isSafeInteger(requestTimestampMs) ||
    Math.abs(Date.now() - requestTimestampMs) > 5 * 60 * 1000
  ) {
    return json({ error: "lifecycle_timestamp_expired" }, 401);
  }

  const rawBody = await request.text();

  if (new TextEncoder().encode(rawBody).length > 4096) {
    return json({ error: "body_too_large" }, 413);
  }

  let body;

  try {
    body = JSON.parse(rawBody);
  } catch {
    return json({ error: "invalid_json" }, 400);
  }

  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return json({ error: "invalid_body" }, 400);
  }

  const orderId = body.order_id;
  const expectedStatus = body.expected_status;
  const newStatus = body.new_status;
  const eventId = body.event_id;

  if (
    !isUuid(orderId) ||
    !isUuid(eventId) ||
    typeof expectedStatus !== "string" ||
    typeof newStatus !== "string" ||
    !ORDER_STATUS_TRANSITIONS[expectedStatus]?.has(newStatus)
  ) {
    return json({ error: "invalid_lifecycle_event" }, 400);
  }

  let expectedSignature;

  try {
    expectedSignature = await lifecycleHmacHex(
      env.ORDER_LIFECYCLE_SECRET,
      `${timestampHeader}.${rawBody}`
    );
  } catch {
    return json({ error: "lifecycle_signature_verification_failed" }, 500);
  }

  if (!constantTimeHexEqual(signatureHeader, expectedSignature)) {
    return json({ error: "invalid_lifecycle_signature" }, 401);
  }

  const order = await findOrderForLifecycle(env, orderId);

  if (!order) {
    return json({ error: "order_not_found" }, 404);
  }

  if (order.callback_nonce === eventId) {
    return json({
      accepted: true,
      duplicate: true,
      status: order.statut
    });
  }

  if (order.callback_ts) {
    const lastTimestamp = Date.parse(order.callback_ts);

    if (
      Number.isFinite(lastTimestamp) &&
      requestTimestampMs <= lastTimestamp
    ) {
      return json({ error: "replayed_lifecycle_callback" }, 409);
    }
  }

  const usedNonce = await env.DB.prepare(`
    SELECT id FROM orders WHERE callback_nonce = ? LIMIT 1
  `).bind(eventId).first();

  if (usedNonce) {
    return json({ error: "lifecycle_event_id_already_used" }, 409);
  }

  const result = await transitionOrderStatus(
    env,
    orderId,
    null,
    expectedStatus,
    newStatus,
    {
      source: "signed_internal_callback",
      eventId,
      callbackTimestamp: new Date(requestTimestampMs).toISOString(),
      callbackNonce: eventId
    }
  );

  if (!result.ok) {
    const status = result.code === "order_not_found" ? 404 :
      result.code === "stale_status" ||
      result.code === "transition_not_allowed" ||
      result.code === "required_uploads_not_confirmed" ||
      result.code === "retry_window_expired" ||
      result.code === "retry_window_timestamp_missing"
        ? 409
        : 503;

    return json({ error: result.code, current_status: result.current_status }, status);
  }

  return json({ accepted: true, duplicate: false, data: result });
}

/* =====================================================
   REGISTRE PERSISTANT DE PURGE — AUDIT + EXÉCUTEUR VERROUILLÉ

   L'audit reste non destructif. L'exécuteur résumable est intégré mais exige
   deux indicateurs explicites absents de la configuration par défaut.
   Aucune suppression B2/D1 métier n'est possible sans ces deux validations.
===================================================== */
function makePurgeOperationId(scope, entityId, rule, expiresAt) {
  return `purge-v1:${scope}:${entityId}:${rule}:${expiresAt}`;
}

async function startPurgeAuditRun(env, runId, cutoff, cronExpression) {
  const startedAt = new Date().toISOString();

  await env.DB.prepare(`
    INSERT INTO purge_audit_runs (
      run_id, scheduled_at, cron_expression, mode,
      inventory_complete, candidate_count, operations_persisted,
      events_persisted, status, error_code, started_at,
      completed_at, report_summary_json
    ) VALUES (?, ?, ?, 'dry_run_no_deletion', 0, 0, 0, 0,
              'started', NULL, ?, NULL, '{}')
  `).bind(
    runId,
    cutoff,
    cronExpression ?? null,
    startedAt
  ).run();
}

async function persistPurgeOperationPlan(env, runId, plan, inventoryComplete) {
  if (!inventoryComplete) {
    return {
      operations_upserted: 0,
      events_inserted: 0,
      candidates_skipped_incomplete_inventory: plan.length
    };
  }

  let operationsUpserted = 0;
  let eventsInserted = 0;
  const now = new Date().toISOString();

  for (let offset = 0; offset < plan.length; offset += PURGE_LEDGER_BATCH_SIZE) {
    const chunk = plan.slice(offset, offset + PURGE_LEDGER_BATCH_SIZE);
    const statements = [];
    const operationStatementIndexes = [];
    const eventStatementIndexes = [];

    for (const item of chunk) {
      const scope = item.scope;
      const targetId = scope === 'file' ? item.file_id : item.order_id;
      const orderId = item.order_id ?? null;
      const fileId = item.file_id ?? null;
      const expectedStatus = item.expected_order_status ?? item.expected_status ?? null;
      const metadata = JSON.stringify(item);

      if (
        !['file', 'order'].includes(scope) ||
        typeof targetId !== 'string' || !targetId ||
        typeof item.operation_id !== 'string' || !item.operation_id ||
        typeof item.rule !== 'string' || !item.rule ||
        typeof item.expires_at !== 'string' || !item.expires_at
      ) {
        throw new Error('purge_ledger_candidate_validation_failed');
      }

      operationStatementIndexes.push(statements.length);
      statements.push(env.DB.prepare(`
        INSERT INTO purge_operations (
          operation_id, scope, target_id, order_id, file_id, role, rule,
          expected_order_status, retention_anchor, uploaded_at, expires_at,
          status, attempts, first_seen_at, last_seen_at, last_seen_run_id,
          metadata_json, created_at, updated_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                  'planned', 0, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(operation_id) DO UPDATE SET
          last_seen_at = excluded.last_seen_at,
          last_seen_run_id = excluded.last_seen_run_id,
          metadata_json = excluded.metadata_json,
          updated_at = excluded.updated_at
      `).bind(
        item.operation_id,
        scope,
        targetId,
        orderId,
        fileId,
        item.role ?? null,
        item.rule,
        expectedStatus,
        item.retention_anchor ?? null,
        item.uploaded_at ?? null,
        item.expires_at,
        now,
        now,
        runId,
        metadata,
        now,
        now
      ));

      eventStatementIndexes.push(statements.length);
      statements.push(env.DB.prepare(`
        INSERT INTO purge_operation_events (
          event_id, event_key, run_id, operation_id,
          event_type, from_status, to_status, error_code,
          details_json, created_at
        ) VALUES (?, ?, ?, ?, 'candidate_observed', NULL, NULL, NULL, ?, ?)
        ON CONFLICT(event_key) DO NOTHING
      `).bind(
        createUUIDv7(),
        `${runId}:${item.operation_id}:candidate_observed`,
        runId,
        item.operation_id,
        JSON.stringify({
          scope,
          target_id: targetId,
          order_id: orderId,
          rule: item.rule,
          expires_at: item.expires_at,
          inventory_complete: true,
          deletion_performed: false
        }),
        now
      ));
    }

    // Small batches limit D1 statement count and make partial failures safely
    // retryable: operation IDs and event keys are deterministic/idempotent.
    const results = await env.DB.batch(statements);
    for (const index of operationStatementIndexes) {
      operationsUpserted += Number(results[index]?.meta?.changes ?? 0);
    }
    for (const index of eventStatementIndexes) {
      eventsInserted += Number(results[index]?.meta?.changes ?? 0);
    }
  }

  return {
    operations_upserted: operationsUpserted,
    events_inserted: eventsInserted,
    candidates_skipped_incomplete_inventory: 0
  };
}

async function completePurgeAuditRun(env, runId, report) {
  const completedAt = new Date().toISOString();
  const result = await env.DB.prepare(`
    UPDATE purge_audit_runs
    SET inventory_complete = ?,
        candidate_count = ?,
        operations_persisted = ?,
        events_persisted = ?,
        status = 'completed',
        error_code = NULL,
        completed_at = ?,
        report_summary_json = ?
    WHERE run_id = ? AND status = 'started'
  `).bind(
    report.inventory_complete ? 1 : 0,
    report.candidate_count,
    report.operations_persisted,
    report.events_persisted,
    completedAt,
    JSON.stringify(report),
    runId
  ).run();

  if (Number(result?.meta?.changes ?? 0) !== 1) {
    throw new Error('purge_ledger_run_completion_failed');
  }
}

async function markPurgeAuditRunFailed(env, runId, error) {
  if (!env?.DB) return;
  const errorCode = String(error?.name ?? 'AuditError').slice(0, 80);

  await env.DB.prepare(`
    UPDATE purge_audit_runs
    SET status = 'failed', error_code = ?, completed_at = ?
    WHERE run_id = ? AND status = 'started'
  `).bind(errorCode, new Date().toISOString(), runId).run();
}

/* =====================================================
   AUDIT DE PURGE — MODE NON DESTRUCTIF

   Politique :
   - Audio/proxy confirmé : 7 jours après livraison.
   - Rendus finaux : aucune purge.
   - Commandes échouées/annulées : 72 heures après leur statut.
   - Aucune suppression réelle dans cette version.
===================================================== */

async function auditExpiredFiles(env, scheduledTime, cronExpression, runId = createUUIDv7()) {
  if (!env.DB) {
    throw new Error("D1 binding is unavailable for purge dry-run");
  }

  const scheduledMs = Number(scheduledTime);
  const nowMs = Number.isFinite(scheduledMs) && scheduledMs > 0
    ? scheduledMs
    : Date.now();

  const now = new Date(nowMs);

  if (!Number.isFinite(now.getTime())) {
    throw new Error("Invalid scheduled time for purge dry-run");
  }

  const cutoff = now.toISOString();
  await startPurgeAuditRun(env, runId, cutoff, cronExpression);
  const DAY_MS = 24 * 60 * 60 * 1000;
  const AUDIO_PROXY_RETENTION_MS = 7 * DAY_MS;
  const FAILED_CANCELLED_RETENTION_MS = 72 * 60 * 60 * 1000;
  const MAX_FILES_PER_AUDIT = 500;
  const MAX_ORDERS_PER_AUDIT = 250;

  const parseTimestamp = value => {
    if (typeof value !== "string" || !value.trim()) return null;

    const parsed = Date.parse(value);

    return Number.isFinite(parsed) ? parsed : null;
  };

  const ageMs = timestamp => {
    const parsed = parseTimestamp(timestamp);

    return parsed === null ? null : nowMs - parsed;
  };

  const terminalStatuses = new Set(["echec", "annule"]);
  const temporaryMediaRoles = new Set(["audio", "proxy"]);
  const renderRoles = new Set(["rendu", "render", "final_render"]);
  const knownFileRoles = new Set([
    "audio", "proxy", "srt", "rendu", "render", "final_render"
  ]);

  const totalFilesResult = await env.DB.prepare(
    "SELECT COUNT(*) AS total FROM files"
  ).first();

  const totalTerminalOrdersResult = await env.DB.prepare(`
    SELECT COUNT(*) AS total
    FROM orders
    WHERE statut IN ('echec', 'annule')
  `).first();

  const totalFiles = Number(totalFilesResult?.total ?? 0);
  const totalTerminalOrders = Number(totalTerminalOrdersResult?.total ?? 0);

  const filesResult = await env.DB.prepare(`
    SELECT
      f.id,
      f.order_id,
      f.role,
      f.taille_octets,
      f.uploaded_at,
      f.purge_at,
      o.statut AS order_status,
      o.created_at AS order_created_at,
      o.updated_at AS order_updated_at,
      (
        SELECT MAX(qe.created_at)
        FROM quota_events qe
        WHERE qe.ordre_id = o.id
          AND qe.type = 'statut_change'
          AND LOWER(TRIM(COALESCE(qe.apres, ''))) =
              LOWER(TRIM(COALESCE(o.statut, '')))
      ) AS status_entered_at,
      (
        SELECT COUNT(*)
        FROM files pending_render
        WHERE pending_render.order_id = o.id
          AND LOWER(TRIM(COALESCE(pending_render.role, ''))) IN ('rendu', 'render', 'final_render')
          AND pending_render.uploaded_at IS NULL
      ) AS unconfirmed_final_render_count,
      (
        SELECT COUNT(*)
        FROM files unknown_role
        WHERE unknown_role.order_id = o.id
          AND LOWER(TRIM(COALESCE(unknown_role.role, ''))) NOT IN ('audio', 'proxy', 'srt', 'rendu', 'render', 'final_render')
      ) AS unknown_role_count
    FROM files f
    INNER JOIN orders o ON o.id = f.order_id
    ORDER BY COALESCE(
      f.purge_at,
      f.uploaded_at,
      o.updated_at,
      o.created_at
    ) ASC, f.id ASC
    LIMIT ?
  `).bind(MAX_FILES_PER_AUDIT).all();

  const terminalOrdersResult = await env.DB.prepare(`
    SELECT
      o.id,
      o.statut,
      o.created_at,
      o.updated_at,
      (
        SELECT MAX(qe.created_at)
        FROM quota_events qe
        WHERE qe.ordre_id = o.id
          AND qe.type = 'statut_change'
          AND LOWER(TRIM(COALESCE(qe.apres, ''))) =
              LOWER(TRIM(COALESCE(o.statut, '')))
      ) AS status_entered_at,
      (
        SELECT COUNT(*)
        FROM files pending_render
        WHERE pending_render.order_id = o.id
          AND LOWER(TRIM(COALESCE(pending_render.role, ''))) IN ('rendu', 'render', 'final_render')
          AND pending_render.uploaded_at IS NULL
      ) AS unconfirmed_final_render_count,
      (
        SELECT COUNT(*)
        FROM files unknown_role
        WHERE unknown_role.order_id = o.id
          AND LOWER(TRIM(COALESCE(unknown_role.role, ''))) NOT IN ('audio', 'proxy', 'srt', 'rendu', 'render', 'final_render')
      ) AS unknown_role_count,
      (
        SELECT COUNT(*)
        FROM files associated_file
        WHERE associated_file.order_id = o.id
      ) AS associated_file_count
    FROM orders o
    WHERE o.statut IN ('echec', 'annule')
    ORDER BY COALESCE(o.updated_at, o.created_at) ASC, o.id ASC
    LIMIT ?
  `).bind(MAX_ORDERS_PER_AUDIT).all();

  const fileRows = filesResult.results ?? [];
  const terminalOrderRows = terminalOrdersResult.results ?? [];

  // An unknown role blocks every purge candidate for the same order,
  // including otherwise-expired audio/proxy on delivered orders.
  const ordersBlockedByUnknownRoles = new Set(
    fileRows
      .filter(row => Number(row.unknown_role_count ?? 0) > 0)
      .map(row => String(row.order_id))
  );

  const filesAuditTruncated = totalFiles > fileRows.length;
  const terminalOrdersAuditTruncated =
    totalTerminalOrders > terminalOrderRows.length;

  const fileAudits = [];
  const terminalOrderAudits = [];
  const lifecycleBlockers = [];
  const purgePlan = [];

  let eligibleAudioProxyCount = 0;
  let eligibleTerminalOrderCount = 0;
  let protectedRenderCount = 0;
  let unconfirmedUploadCount = 0;
  let missingStatusEventCount = 0;
  let invalidStatusEventTimeCount = 0;

  for (const row of terminalOrderRows) {
    const status = String(row.statut ?? "").trim().toLowerCase();
    const statusAt = row.status_entered_at ?? null;
    const age = ageMs(statusAt);
    const unconfirmedRenderCount = Number(row.unconfirmed_final_render_count ?? 0);
    const unknownRoleCount = Number(row.unknown_role_count ?? 0);

    let classification;
    let reason;
    let purgeExpiresAt = null;
    let purgeOperationId = null;

    if (!terminalStatuses.has(status)) {
      classification = "PROTECT_UNEXPECTED_STATUS";
      reason = "Status is not one of the supported terminal statuses.";
    } else if (!statusAt) {
      classification = "BLOCKED_NO_STATUS_CHANGE_EVENT";
      reason = "No quota_events statut_change timestamp for the current status.";
      missingStatusEventCount += 1;
    } else if (age === null || age < 0) {
      classification = "BLOCKED_INVALID_STATUS_TIMESTAMP";
      reason = "Current status event timestamp is invalid or in the future.";
      invalidStatusEventTimeCount += 1;
    } else if (age < FAILED_CANCELLED_RETENTION_MS) {
      classification = "RETAIN_72H_RETRY_WINDOW";
      reason = "The 72-hour retry window after failure/cancellation has not elapsed.";
    } else if (unconfirmedRenderCount > 0) {
      classification = "PROTECT_UNCONFIRMED_FINAL_RENDER";
      reason = "The order has a final render that is not uploaded/confirmed; all order-level deletion is blocked.";
    } else if (unknownRoleCount > 0) {
      classification = "PROTECT_UNKNOWN_FILE_ROLE";
      reason = "The order contains one or more files with an unknown role; order-level deletion is blocked.";
      ordersBlockedByUnknownRoles.add(String(row.id));
    } else {
      classification = "WOULD_PURGE_ORDER_AFTER_72H";
      reason = "Terminal status has persisted for at least 72 hours, all file roles are known, and no unconfirmed final render is attached; audit only.";
      eligibleTerminalOrderCount += 1;
      purgeExpiresAt = new Date(Date.parse(statusAt) + FAILED_CANCELLED_RETENTION_MS).toISOString();
      purgeOperationId = makePurgeOperationId("order", String(row.id), "terminal_72h", purgeExpiresAt);

      purgePlan.push({
        operation_id: purgeOperationId,
        idempotency_key: purgeOperationId,
        scope: "order",
        order_id: String(row.id),
        rule: "terminal_72h",
        expected_status: status,
        retention_anchor: statusAt,
        expires_at: purgeExpiresAt,
        associated_file_count_at_audit: Number(row.associated_file_count ?? 0),
        action_sequence: [
          "revalidate_current_order_status_and_status_event",
          "revalidate_no_unconfirmed_final_render",
          "revalidate_all_file_roles_are_known",
          "enumerate_current_B2_objects_without_logging_object_keys",
          "delete_each_B2_object_idempotently_and_accept_not_found_as_already_absent",
          "delete_D1_order_only_after_every_associated_B2_object_is_absent"
        ],
        execution_status: "DRY_RUN_CANDIDATE_ONLY",
        deletion_performed: false
      });
    }

    terminalOrderAudits.push({
      order_id: String(row.id),
      order_status: status,
      created_at: row.created_at ?? null,
      updated_at: row.updated_at ?? null,
      associated_file_count: Number(row.associated_file_count ?? 0),
      unconfirmed_final_render_count: unconfirmedRenderCount,
      unknown_role_count: unknownRoleCount,
      status_entered_at: statusAt,
      status_age_hours: age === null
        ? null
        : Math.round(age / (60 * 60 * 1000) * 100) / 100,
      classification,
      reason,
      purge_operation_id: purgeOperationId,
      proposed_expires_at: purgeExpiresAt,
      deletion_performed: false
    });
  }

  for (const row of fileRows) {
    const fileId = String(row.id);
    const orderId = String(row.order_id);
    const orderStatus = String(row.order_status ?? "").trim().toLowerCase();
    const role = String(row.role ?? "").trim().toLowerCase();
    const uploadedAt = row.uploaded_at ?? null;
    const uploadedAtMs = uploadedAt ? parseTimestamp(uploadedAt) : null;
    const statusAt = row.status_entered_at ?? null;
    const deliveryAtMs = statusAt ? parseTimestamp(statusAt) : null;
    const statusAge = ageMs(statusAt);
    const unconfirmedRenderCount = Number(row.unconfirmed_final_render_count ?? 0);
    const unknownRoleCount = Number(row.unknown_role_count ?? 0);

    let classification;
    let reason;
    let retentionAnchor = null;
    let expiresAt = null;
    let purgeOperationId = null;
    let purgeOperationScope = null;
    let purgeRule = null;

    if (renderRoles.has(role) && !uploadedAt) {
      protectedRenderCount += 1;
      classification = "PROTECT_FINAL_RENDER_NOT_CONFIRMED";
      reason = "Final render is not uploaded/confirmed; protect it and every associated order purge from deletion.";
    } else if (unconfirmedRenderCount > 0) {
      // This guard is order-wide and runs before BOTH the 72-hour and 7-day
      // rules, so a pending final render protects audio/proxy on delivered orders too.
      classification = "PROTECT_ORDER_HAS_UNCONFIRMED_FINAL_RENDER";
      reason = "A final render for this order is not uploaded/confirmed; all associated files are protected from every automatic purge rule.";
    } else if (unknownRoleCount > 0) {
      // A role we do not understand must block every associated file, not just
      // the unknown record itself; the retention policy for it is undefined.
      if (!knownFileRoles.has(role)) {
        classification = "PROTECT_UNKNOWN_FILE_ROLE";
        reason = "This file role is not covered by the retention policy; this file and every associated file are protected.";
      } else {
        classification = "PROTECT_ORDER_HAS_UNKNOWN_FILE_ROLE";
        reason = "The order contains a file role not covered by policy; all associated files are protected from automatic purge.";
      }
    } else if (terminalStatuses.has(orderStatus)) {
      // An unconfirmed final render protects the whole order, including audio/proxy.
      if (unconfirmedRenderCount > 0) {
        classification = "PROTECT_ORDER_HAS_UNCONFIRMED_FINAL_RENDER";
        reason = "A final render for this order is not uploaded/confirmed; no associated file may be purged through the 72-hour order rule.";
      } else if (unknownRoleCount > 0) {
        classification = "PROTECT_ORDER_HAS_UNKNOWN_FILE_ROLE";
        reason = "The order contains an unknown file role; protect all associated files from order-level purge.";
      } else if (!statusAt) {
        classification = "BLOCKED_NO_STATUS_CHANGE_EVENT";
        reason = "Failed/cancelled order has no timestamp for its current status; file is protected.";
        missingStatusEventCount += 1;
      } else if (statusAge === null || statusAge < 0) {
        classification = "BLOCKED_INVALID_STATUS_TIMESTAMP";
        reason = "Failed/cancelled order status timestamp is invalid or in the future.";
        invalidStatusEventTimeCount += 1;
      } else {
        retentionAnchor = statusAt;
        expiresAt = new Date(Date.parse(statusAt) + FAILED_CANCELLED_RETENTION_MS).toISOString();

        if (statusAge < FAILED_CANCELLED_RETENTION_MS) {
          classification = "PROTECT_72H_RETRY_WINDOW";
          reason = "File remains protected during the 72-hour retry window for its failed/cancelled order.";
        } else {
          classification = "WOULD_PURGE_WITH_TERMINAL_ORDER_AFTER_72H";
          reason = "Associated failed/cancelled order is older than 72 hours; order-scoped dry-run candidate only.";
          purgeOperationId = makePurgeOperationId("order", orderId, "terminal_72h", expiresAt);
          purgeOperationScope = "order";
          purgeRule = "terminal_72h";
        }
      }
    } else if (temporaryMediaRoles.has(role)) {
      if (orderStatus !== "livre") {
        classification = "PROTECT_NOT_DELIVERED";
        reason = "Audio/proxy retention starts only after the order is marked livre.";
      } else if (!uploadedAt) {
        classification = "PROTECT_UPLOAD_NOT_CONFIRMED";
        reason = "Upload is not confirmed; do not purge this record under the delivery rule.";
        unconfirmedUploadCount += 1;
      } else if (uploadedAtMs === null) {
        classification = "BLOCKED_INVALID_UPLOAD_TIMESTAMP";
        reason = "The confirmed-upload timestamp is invalid; protect this file.";
        invalidStatusEventTimeCount += 1;
      } else if (!statusAt) {
        classification = "BLOCKED_NO_DELIVERY_EVENT";
        reason = "No statut_change event records when this order entered livre.";
        missingStatusEventCount += 1;
      } else if (statusAge === null || statusAge < 0 || deliveryAtMs === null) {
        classification = "BLOCKED_INVALID_DELIVERY_TIMESTAMP";
        reason = "Delivery timestamp is invalid or in the future.";
        invalidStatusEventTimeCount += 1;
      } else if (uploadedAtMs > deliveryAtMs) {
        classification = "BLOCKED_UPLOAD_AFTER_DELIVERY_TIMESTAMP";
        reason = "The recorded upload confirmation is later than the delivery event; protect this file until lifecycle timestamps are reconciled.";
        invalidStatusEventTimeCount += 1;
      } else {
        retentionAnchor = statusAt;
        expiresAt = new Date(deliveryAtMs + AUDIO_PROXY_RETENTION_MS).toISOString();

        if (statusAge < AUDIO_PROXY_RETENTION_MS) {
          classification = "KEEP_AUDIO_PROXY_7D_AFTER_DELIVERY";
          reason = "Seven-day retention period after delivery has not elapsed.";
        } else {
          classification = "WOULD_PURGE_AUDIO_PROXY_AFTER_7D";
          reason = "Confirmed audio/proxy is at least seven days past delivery; audit only.";
          eligibleAudioProxyCount += 1;
          purgeOperationId = makePurgeOperationId("file", fileId, "audio_proxy_7d", expiresAt);
          purgeOperationScope = "file";
          purgeRule = "audio_proxy_7d";

          purgePlan.push({
            operation_id: purgeOperationId,
            idempotency_key: purgeOperationId,
            scope: "file",
            file_id: fileId,
            order_id: orderId,
            role,
            rule: purgeRule,
            expected_order_status: "livre",
            retention_anchor: statusAt,
            uploaded_at: uploadedAt,
            expires_at: expiresAt,
            action_sequence: [
              "revalidate_current_order_status_and_delivery_event",
              "revalidate_upload_is_confirmed_and_precedes_delivery",
              "delete_B2_object_idempotently_and_accept_not_found_as_already_absent",
              "delete_D1_file_row_only_after_B2_object_is_absent"
            ],
            execution_status: "DRY_RUN_CANDIDATE_ONLY",
            deletion_performed: false
          });
        }
      }
    } else if (renderRoles.has(role)) {
      protectedRenderCount += 1;
      classification = "PROTECT_CONFIRMED_FINAL_RENDER_RETENTION_UNDEFINED";
      reason = "The final render has no approved server-side expiry rule on active/delivered orders; preserve it.";
    } else {
      classification = "PROTECT_ROLE_NOT_COVERED_BY_POLICY";
      reason = "No automatic purge rule has been defined for this file role.";
    }

    fileAudits.push({
      file_id: fileId,
      order_id: orderId,
      storage_key_included: false,
      role,
      order_status: orderStatus,
      unconfirmed_final_render_count: unconfirmedRenderCount,
      unknown_role_count: unknownRoleCount,
      size_bytes: Number(row.taille_octets ?? 0),
      uploaded_at: uploadedAt,
      existing_purge_at_ignored: row.purge_at ?? null,
      retention_anchor: retentionAnchor,
      proposed_expires_at: expiresAt,
      purge_operation_id: purgeOperationId,
      purge_operation_scope: purgeOperationScope,
      purge_rule: purgeRule,
      classification,
      reason,
      deletion_performed: false
    });
  }

  if (missingStatusEventCount > 0) {
    lifecycleBlockers.push(
      `${missingStatusEventCount} record(s) lack a statut_change timestamp for the current delivery/failure/cancellation status; expiry cannot be calculated safely.`
    );
  }

  if (invalidStatusEventTimeCount > 0) {
    lifecycleBlockers.push(
      `${invalidStatusEventTimeCount} record(s) have an invalid, future, or contradictory lifecycle timestamp and are protected.`
    );
  }

  if (ordersBlockedByUnknownRoles.size > 0) {
    lifecycleBlockers.push(
      `${ordersBlockedByUnknownRoles.size} order(s) contain file roles not covered by policy; every associated file is protected from automatic purge.`
    );
  }

  lifecycleBlockers.push(
    "Status events are written by the protected order-status route, by signed internal callbacks, and automatically when audio plus proxy uploads are both confirmed. The Android client and any processing engine must call the correct route for their real lifecycle events; no remote rendering engine is integrated by this file alone."
  );

  lifecycleBlockers.push(
    "The authenticated upload-sign/confirm endpoints support final-render MP4 objects and verify the stored content SHA-256. The Android app and rendering pipeline must still call these routes in their actual end-to-end workflow; no rendering engine is integrated by this Worker alone. Unconfirmed final-render records remain protected from purge."
  );

  if (filesAuditTruncated) {
    lifecycleBlockers.push(
      `File audit is bounded to ${MAX_FILES_PER_AUDIT} rows and is truncated; this run is diagnostic only and cannot be treated as a complete inventory.`
    );
  }

  if (terminalOrdersAuditTruncated) {
    lifecycleBlockers.push(
      `Failed/cancelled order audit is bounded to ${MAX_ORDERS_PER_AUDIT} rows and is truncated; this run is diagnostic only.`
    );
  }

  const summary = {
    total_file_records: totalFiles,
    file_records_audited: fileRows.length,
    file_audit_truncated: filesAuditTruncated,
    failed_cancelled_orders_total: totalTerminalOrders,
    failed_cancelled_orders_audited: terminalOrderRows.length,
    failed_cancelled_orders_audit_truncated: terminalOrdersAuditTruncated,
    audio_proxy_records_would_purge_after_7d: eligibleAudioProxyCount,
    failed_cancelled_orders_would_purge_after_72h: eligibleTerminalOrderCount,
    final_render_records_protected: protectedRenderCount,
    unconfirmed_uploads_protected: unconfirmedUploadCount,
    missing_lifecycle_timestamp_records: missingStatusEventCount,
    invalid_lifecycle_timestamp_records: invalidStatusEventTimeCount,
    orders_blocked_by_unknown_roles: ordersBlockedByUnknownRoles.size,
    purge_plan_entries: purgePlan.length,
    purge_plan_file_entries: purgePlan.filter(item => item.scope === "file").length,
    purge_plan_order_entries: purgePlan.filter(item => item.scope === "order").length,
    purge_plan_complete_inventory: !filesAuditTruncated && !terminalOrdersAuditTruncated,
    lifecycle_blockers: lifecycleBlockers.length,
    objects_deleted: 0,
    database_rows_deleted: 0
  };

  const inventoryComplete = !filesAuditTruncated && !terminalOrdersAuditTruncated;
  const ledger = await persistPurgeOperationPlan(
    env,
    runId,
    purgePlan,
    inventoryComplete
  );

  summary.purge_ledger_inventory_complete = inventoryComplete;
  summary.purge_ledger_operations_upserted = ledger.operations_upserted;
  summary.purge_ledger_events_inserted = ledger.events_inserted;
  summary.purge_ledger_candidates_skipped_incomplete_inventory =
    ledger.candidates_skipped_incomplete_inventory;

  await completePurgeAuditRun(env, runId, {
    inventory_complete: inventoryComplete,
    candidate_count: purgePlan.length,
    operations_persisted: ledger.operations_upserted,
    events_persisted: ledger.events_inserted,
    report_summary: summary
  });

  return {
    job: "purge_audit",
    mode: "dry_run_no_deletion",
    deletion_enabled: false,
    scheduled_at: cutoff,
    cron: cronExpression ?? null,
    cutoff,
    policy: {
      audio_proxy: "Delete only after order status is livre, upload is confirmed, and 7 full days have elapsed since the recorded statut_change event entering livre.",
      failed_cancelled_orders: "Retain for 72 hours after a recorded statut_change event entering the current echec/annule status; then the order and its associated server-side file objects are purge candidates.",
      final_renders: "Never purge an unconfirmed final render. A pending final render blocks all order-level cleanup, including associated audio/proxy. Confirmed final renders on active/delivered orders are preserved; a failed/cancelled order may be purged after 72 hours only if it has no unconfirmed final render and no unknown file roles.",
      lifecycle_timestamp_source: "quota_events.created_at where type='statut_change' and apres equals the current order status.",
      legacy_purge_at: "files.purge_at is reported for diagnostics only and is not trusted as the retention anchor because it may have been set before upload confirmation.",
      idempotency: "Candidate operation IDs are deterministic from scope, target ID, rule and expiry timestamp. Complete-inventory candidates and per-run observation events are persisted idempotently. The separate executor is implemented but locked behind two explicit environment approvals and uses resumable ledger states.",
      storage_failure_handling: "The gated executor revalidates lifecycle state and the exact order-scoped key prefix, deletes exact private B2 objects first, confirms each is absent with signed HEAD, retains D1 business rows on storage failure, and retries from persistent ledger states. The feature is disabled unless both explicit approval environment values are present.",
      safety: "Audit only. No B2 object is deleted and no application/business row is updated or deleted. This audit writes only to the internal purge_audit_runs, purge_operations and purge_operation_events ledger tables. Incomplete inventories do not persist actionable candidate operations. Missing/invalid/contradictory lifecycle timestamps, pending final renders, and unknown roles protect affected files and orders."
    },
    lifecycle_readiness: {
      current_worker_writes_status_change_events: true,
      signed_internal_status_callback_available: true,
      authenticated_owner_status_route_available: true,
      confirmed_audio_proxy_pair_advances_to_files_recus: true,
      final_render_upload_confirm_supported: true,
      status: "READY_FOR_EVENT_SOURCE_INTEGRATION_AND_DRY_RUN_TESTS",
      internal_lifecycle_secret_configured: Boolean(env.ORDER_LIFECYCLE_SECRET),
      blockers: lifecycleBlockers
    },
    run_id: runId,
    purge_execution: {
      enabled: false,
      mode: "audit_only_with_persistent_ledger",
      real_b2_delete_calls: 0,
      application_d1_rows_updated_or_deleted_from_scheduled_handler: 0,
      ledger_d1_writes: {
        operations_upserted: ledger.operations_upserted,
        events_inserted: ledger.events_inserted,
        candidates_skipped_incomplete_inventory: ledger.candidates_skipped_incomplete_inventory
      },
      plan_complete_inventory: inventoryComplete,
      operation_id_scheme: "purge-v1:<scope>:<target-id>:<rule>:<expires-at>",
      operation_ledger_ready: true,
      operation_ledger_schema_version: PURGE_LEDGER_SCHEMA_VERSION,
      operation_ledger_note: "Persistent audit run, operation and event records are idempotent. A resumable B2-first executor with retry/backoff is implemented but is disabled by default and requires two explicit approval environment values. It must pass local isolated-object tests before any production activation.",
      candidate_operations: purgePlan
    },
    summary,
    file_records: fileAudits,
    failed_cancelled_orders: terminalOrderAudits
  };
}

/* =====================================================
   EXÉCUTEUR DE PURGE — PRÉPARÉ MAIS VERROUILLÉ PAR DÉFAUT

   Garde de sécurité double : PURGE_EXECUTION_ENABLED=true ET
   PURGE_EXECUTION_ACK=EXECUTE_PURGE_V1_AFTER_APPROVAL.
   Sans les deux paramètres explicites, aucun appel DELETE B2 ni aucune
   suppression D1 métier n'est exécuté par le gestionnaire planifié.
===================================================== */
function purgeExecutorIsEnabled(env) {
  return env?.PURGE_EXECUTION_ENABLED === "true" &&
    env?.PURGE_EXECUTION_ACK === "EXECUTE_PURGE_V1_AFTER_APPROVAL";
}

function purgeExecutorError(code, stage, retryable = true) {
  const error = new Error(code);
  error.name = "PurgeExecutionError";
  error.code = code;
  error.stage = stage;
  error.retryable = retryable;
  return error;
}

function purgeTimestampMs(value) {
  if (typeof value !== "string" || !value.trim()) return null;
  const valueMs = Date.parse(value);
  return Number.isFinite(valueMs) ? valueMs : null;
}

function isSafePurgeObjectKey(key, expectedPrefix) {
  if (
    typeof key !== "string" ||
    !key ||
    key.length > 1024 ||
    !key.startsWith(expectedPrefix) ||
    key.includes("\\") ||
    key.includes("?") ||
    key.includes("#")
  ) return false;

  const segments = key.split("/");
  return segments.every(segment => segment && segment !== "." && segment !== "..");
}

async function loadPurgeOrderContext(env, orderId) {
  const order = await env.DB.prepare(`
    SELECT
      o.id,
      o.user_id,
      o.project_id,
      o.statut,
      u.firebase_uid,
      (
        SELECT MAX(q.created_at)
        FROM quota_events q
        WHERE q.ordre_id = o.id
          AND q.type = 'statut_change'
          AND LOWER(TRIM(COALESCE(q.apres, ''))) =
              LOWER(TRIM(COALESCE(o.statut, '')))
      ) AS status_entered_at
    FROM orders o
    JOIN users u ON u.id = o.user_id
    WHERE o.id = ?
    LIMIT 1
  `).bind(orderId).first();

  if (!order) return null;

  const fileResult = await env.DB.prepare(`
    SELECT id, order_id, r2_key, role, taille_octets, empreinte, uploaded_at
    FROM files
    WHERE order_id = ?
    ORDER BY id
    LIMIT 51
  `).bind(orderId).all();

  return { order, files: fileResult.results ?? [] };
}

async function revalidatePurgeOperation(env, operation, nowIso, resumeFrom) {
  const scope = operation.scope;
  const orderId = operation.order_id ?? (scope === "order" ? operation.target_id : null);

  if (!orderId || !["file", "order"].includes(scope)) {
    return { ok: false, code: "operation_identity_invalid" };
  }

  const context = await loadPurgeOrderContext(env, orderId);
  if (!context) {
    if (resumeFrom === "db_cleanup_pending") {
      return { ok: true, alreadyCleaned: true, objects: [] };
    }
    return { ok: false, code: "target_order_missing" };
  }

  const { order, files } = context;
  if (files.length > PURGE_EXECUTOR_MAX_FILES_PER_ORDER) {
    return { ok: false, code: "order_file_inventory_over_limit" };
  }
  const status = String(order.statut ?? "").trim().toLowerCase();
  const statusAt = order.status_entered_at;
  const statusAtMs = purgeTimestampMs(statusAt);
  const nowMs = purgeTimestampMs(nowIso);
  const expiryMs = purgeTimestampMs(operation.expires_at);

  if (statusAtMs === null || nowMs === null || expiryMs === null || statusAtMs > nowMs) {
    return { ok: false, code: "lifecycle_timestamp_invalid" };
  }

  const roleOf = row => String(row.role ?? "").trim().toLowerCase();
  const renderRoles = new Set(["rendu", "render", "final_render"]);
  const knownRoles = new Set(["audio", "proxy", "srt", "rendu", "render", "final_render"]);
  const hasUnconfirmedRender = files.some(row => renderRoles.has(roleOf(row)) && !row.uploaded_at);
  const hasUnknownRole = files.some(row => !knownRoles.has(roleOf(row)));

  if (hasUnconfirmedRender) {
    return { ok: false, code: "order_has_unconfirmed_final_render" };
  }
  if (hasUnknownRole) {
    return { ok: false, code: "order_has_unknown_file_role" };
  }

  const expectedPrefix = `u/${order.firebase_uid}/${order.project_id}/${order.id}/`;
  const makeObject = row => {
    if (!isSafePurgeObjectKey(row.r2_key, expectedPrefix)) {
      return null;
    }
    return {
      key: row.r2_key,
      file_id: String(row.id),
      role: roleOf(row),
    };
  };

  if (scope === "order") {
    const expectedStatus = String(operation.expected_order_status ?? "").toLowerCase();
    if (!["echec", "annule"].includes(status) || status !== expectedStatus) {
      return { ok: false, code: "order_status_changed" };
    }
    if (statusAt !== operation.retention_anchor) {
      return { ok: false, code: "terminal_status_event_changed" };
    }

    const expectedExpiry = new Date(statusAtMs + FAILED_CANCELLED_RETENTION_MS).toISOString();
    if (operation.expires_at !== expectedExpiry || expiryMs > nowMs) {
      return { ok: false, code: "terminal_retention_not_expired_or_changed" };
    }

    const objects = [];
    const uniqueKeys = new Set();
    for (const file of files) {
      const object = makeObject(file);
      if (!object) return { ok: false, code: "b2_object_key_outside_order_prefix" };
      if (uniqueKeys.has(object.key)) return { ok: false, code: "duplicate_b2_object_key" };
      uniqueKeys.add(object.key);
      objects.push(object);
    }
    return { ok: true, objects, order, files };
  }

  const fileId = operation.file_id ?? operation.target_id;
  const file = files.find(row => String(row.id) === String(fileId));
  if (!file) {
    if (resumeFrom === "db_cleanup_pending") {
      return { ok: true, alreadyCleaned: true, objects: [] };
    }
    return { ok: false, code: "target_file_missing" };
  }

  const role = roleOf(file);
  if (!['audio', 'proxy'].includes(role) || role !== String(operation.role ?? "").trim().toLowerCase()) {
    return { ok: false, code: "temporary_media_role_changed" };
  }
  if (status !== "livre" || String(operation.expected_order_status ?? "") !== "livre") {
    return { ok: false, code: "delivery_status_changed" };
  }
  if (!file.uploaded_at) return { ok: false, code: "upload_not_confirmed" };
  const uploadedAtMs = purgeTimestampMs(file.uploaded_at);
  if (uploadedAtMs === null || uploadedAtMs > statusAtMs) {
    return { ok: false, code: "upload_timestamp_invalid_or_after_delivery" };
  }
  if (statusAt !== operation.retention_anchor) {
    return { ok: false, code: "delivery_event_changed" };
  }
  const expectedExpiry = new Date(statusAtMs + AUDIO_PROXY_RETENTION_MS).toISOString();
  if (operation.expires_at !== expectedExpiry || expiryMs > nowMs) {
    return { ok: false, code: "audio_proxy_retention_not_expired_or_changed" };
  }

  const object = makeObject(file);
  if (!object) return { ok: false, code: "b2_object_key_outside_order_prefix" };
  return { ok: true, objects: [object], order, files, selectedFile: file };
}

async function deleteB2ObjectAndVerifyAbsent(env, objectKey) {
  // objectKey was fetched from D1 and must already have passed the exact order-prefix check.
  const client = getB2Client(env);
  const url = makeB2ObjectUrl(env, objectKey);
  const aws = { service: "s3", region: env.B2_REGION };

  const deletion = await client.fetch(url.toString(), {
    method: "DELETE",
    aws,
  });
  try {
    if (deletion.body) await deletion.body.cancel();
  } catch {
    // The result is determined by the follow-up HEAD verification.
  }

  if (!deletion.ok && deletion.status !== 404) {
    throw purgeExecutorError(`b2_delete_http_${deletion.status}`, "b2_delete", true);
  }

  const verification = await client.fetch(url.toString(), {
    method: "HEAD",
    aws,
  });
  try {
    if (verification.body) await verification.body.cancel();
  } catch {
    // HEAD typically has no body; ignore cancellation errors.
  }

  if (verification.status === 404) return true;
  if (verification.ok) {
    throw purgeExecutorError("b2_object_still_present", "b2_verify", true);
  }
  throw purgeExecutorError(`b2_head_verify_http_${verification.status}`, "b2_verify", true);
}

async function recordPurgeExecutorEvent(env, input) {
  const eventTarget = input.details?.fileId ?? input.details?.targetId ?? "";
  const eventKey = `${input.runId}:${input.operationId}:${input.attempt}:${input.eventType}:${eventTarget}`;
  await env.DB.prepare(`
    INSERT INTO purge_operation_events (
      event_id, event_key, run_id, operation_id,
      event_type, from_status, to_status, error_code,
      details_json, created_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON CONFLICT(event_key) DO NOTHING
  `).bind(
    createUUIDv7(),
    eventKey,
    input.runId,
    input.operationId,
    input.eventType,
    input.fromStatus ?? null,
    input.toStatus ?? null,
    input.errorCode ?? null,
    JSON.stringify(input.details ?? {}),
    new Date().toISOString()
  ).run();
}

async function setPurgeOperationStatus(env, operation, status, details) {
  await env.DB.prepare(`
    UPDATE purge_operations
    SET status = ?,
        attempts = ?,
        last_error_stage = ?,
        last_error_code = ?,
        last_error_at = ?,
        next_attempt_at = ?,
        b2_deleted_at = CASE WHEN ? IS NOT NULL THEN ? ELSE b2_deleted_at END,
        db_cleaned_at = CASE WHEN ? IS NOT NULL THEN ? ELSE db_cleaned_at END,
        completed_at = CASE WHEN ? IS NOT NULL THEN ? ELSE completed_at END,
        updated_at = ?
    WHERE operation_id = ?
  `).bind(
    status,
    details.attempt,
    details.errorStage ?? null,
    details.errorCode ?? null,
    details.errorAt ?? null,
    details.nextAttemptAt ?? null,
    details.b2DeletedAt ?? null,
    details.b2DeletedAt ?? null,
    details.dbCleanedAt ?? null,
    details.dbCleanedAt ?? null,
    details.completedAt ?? null,
    details.completedAt ?? null,
    details.nowIso,
    operation.operation_id
  ).run();
}

async function claimPurgeOperation(env, operation, nowIso, nowMs) {
  const staleBefore = new Date(nowMs - PURGE_EXECUTOR_LEASE_MS).toISOString();
  const result = await env.DB.prepare(`
    UPDATE purge_operations
    SET status = 'revalidating',
        attempts = attempts + 1,
        updated_at = ?,
        next_attempt_at = NULL
    WHERE operation_id = ?
      AND status = ?
      AND (
        (status = 'revalidating' AND updated_at <= ?)
        OR
        (status <> 'revalidating' AND (next_attempt_at IS NULL OR next_attempt_at <= ?))
      )
  `).bind(
    nowIso,
    operation.operation_id,
    operation.status,
    staleBefore,
    nowIso
  ).run();

  if (Number(result?.meta?.changes ?? 0) !== 1) return { claimed: false };
  const row = await env.DB.prepare(`
    SELECT attempts FROM purge_operations WHERE operation_id = ? LIMIT 1
  `).bind(operation.operation_id).first();
  return { claimed: true, attempts: Number(row?.attempts ?? operation.attempts + 1) };
}

async function cleanupPurgeDatabaseTarget(env, operation, snapshot, objects, nowIso) {
  const fresh = await revalidatePurgeOperation(env, operation, nowIso, "db_cleanup_pending");
  if (fresh?.alreadyCleaned) return { ok: true, alreadyCleaned: true };
  if (!fresh?.ok) {
    throw purgeExecutorError(
      String(fresh?.code ?? "d1_cleanup_revalidation_failed"),
      "db_cleanup",
      false
    );
  }

  const keySet = rows => (rows ?? []).map(row => row.key).sort();
  const originalKeys = keySet(objects);
  const freshKeys = keySet(fresh.objects);
  if (originalKeys.length !== freshKeys.length || originalKeys.some((key, index) => key !== freshKeys[index])) {
    throw purgeExecutorError("b2_inventory_changed_before_d1_cleanup", "db_cleanup", false);
  }

  if (operation.scope === "order") {
    const statusAt = operation.retention_anchor;
    const expectedOrderId = String(operation.order_id ?? operation.target_id);
    // D1 meta.changes is based on SQLite total_changes and includes rows
    // removed by ON DELETE CASCADE. It may therefore be > 1 when the order
    // has associated files. Use DELETE ... RETURNING id to prove that this
    // statement removed the target order itself.
    const result = await env.DB.prepare(`
      DELETE FROM orders
      WHERE id = ?
        AND statut = ?
        AND EXISTS (
          SELECT 1 FROM quota_events q
          WHERE q.ordre_id = orders.id
            AND q.type = 'statut_change'
            AND LOWER(TRIM(COALESCE(q.apres, ''))) = LOWER(TRIM(orders.statut))
            AND q.created_at = ?
        )
        AND NOT EXISTS (
          SELECT 1 FROM files f
          WHERE f.order_id = orders.id
            AND LOWER(TRIM(COALESCE(f.role, ''))) IN ('rendu', 'render', 'final_render')
            AND f.uploaded_at IS NULL
        )
        AND NOT EXISTS (
          SELECT 1 FROM files f
          WHERE f.order_id = orders.id
            AND LOWER(TRIM(COALESCE(f.role, ''))) NOT IN ('audio', 'proxy', 'srt', 'rendu', 'render', 'final_render')
        )
      RETURNING id
    `).bind(
      expectedOrderId,
      operation.expected_order_status,
      statusAt
    ).all();

    const returnedRows = Array.isArray(result?.results) ? result.results : [];
    if (returnedRows.some(row => String(row?.id ?? '') === expectedOrderId)) {
      return { ok: true, alreadyCleaned: false };
    }

    const stillExists = await env.DB.prepare(
      "SELECT id FROM orders WHERE id = ? LIMIT 1"
    ).bind(expectedOrderId).first();
    if (!stillExists) return { ok: true, alreadyCleaned: true };
    throw purgeExecutorError("d1_order_delete_precondition_failed", "db_cleanup", false);
  }

  const file = fresh.selectedFile;
  if (!file) throw purgeExecutorError("d1_file_missing_before_cleanup", "db_cleanup", false);
  const column = String(file.role ?? "").trim().toLowerCase() === "audio"
    ? "audio_octets"
    : "proxy_octets";

  const results = await env.DB.batch([
    env.DB.prepare(`
      DELETE FROM files
      WHERE id = ?
        AND order_id = ?
        AND r2_key = ?
        AND role = ?
        AND uploaded_at = ?
        AND EXISTS (
          SELECT 1 FROM orders o
          WHERE o.id = files.order_id AND o.statut = 'livre'
            AND EXISTS (
              SELECT 1 FROM quota_events q
              WHERE q.ordre_id = o.id AND q.type = 'statut_change'
                AND LOWER(TRIM(COALESCE(q.apres, ''))) = 'livre'
                AND q.created_at = ?
            )
        )
        AND NOT EXISTS (
          SELECT 1 FROM files f
          WHERE f.order_id = files.order_id
            AND LOWER(TRIM(COALESCE(f.role, ''))) IN ('rendu', 'render', 'final_render')
            AND f.uploaded_at IS NULL
        )
        AND NOT EXISTS (
          SELECT 1 FROM files f
          WHERE f.order_id = files.order_id
            AND LOWER(TRIM(COALESCE(f.role, ''))) NOT IN ('audio', 'proxy', 'srt', 'rendu', 'render', 'final_render')
        )
    `).bind(file.id, file.order_id, file.r2_key, file.role, file.uploaded_at, operation.retention_anchor),
    env.DB.prepare(`
      UPDATE orders
      SET ${column} = (
            SELECT COALESCE(SUM(taille_octets), 0)
            FROM files
            WHERE order_id = ? AND role = ? AND uploaded_at IS NOT NULL
          ),
          updated_at = ?
      WHERE id = ?
    `).bind(file.order_id, file.role, nowIso, file.order_id),
  ]);

  if (Number(results?.[0]?.meta?.changes ?? 0) === 1) return { ok: true };

  const stillExists = await env.DB.prepare(
    "SELECT id FROM files WHERE id = ? AND order_id = ? LIMIT 1"
  ).bind(file.id, file.order_id).first();
  if (!stillExists) return { ok: true, alreadyCleaned: true };
  throw purgeExecutorError("d1_file_delete_precondition_failed", "db_cleanup", false);
}

async function runDuePurgeOperations(env, runId, nowMs = Date.now()) {
  if (!purgeExecutorIsEnabled(env)) {
    return {
      enabled: false,
      mode: "audit_only_with_persistent_ledger",
      reason: env?.PURGE_EXECUTION_ENABLED === "true"
        ? "second_approval_flag_missing"
        : "executor_disabled_by_default",
      operations_considered: 0,
      operations_completed: 0,
      operations_retryable: 0,
      operations_blocked: 0,
      b2_delete_calls: 0,
      application_d1_cleanup_operations_completed: 0,
    };
  }

  const nowIso = new Date(nowMs).toISOString();
  const staleBefore = new Date(nowMs - PURGE_EXECUTOR_LEASE_MS).toISOString();
  const auditRun = await env.DB.prepare(`
    SELECT status, inventory_complete
    FROM purge_audit_runs
    WHERE run_id = ?
    LIMIT 1
  `).bind(runId).first();

  if (!auditRun || auditRun.status !== "completed" || Number(auditRun.inventory_complete) !== 1) {
    return {
      enabled: true,
      mode: "executor_waiting_for_complete_inventory",
      operations_considered: 0,
      operations_completed: 0,
      operations_retryable: 0,
      operations_blocked: 0,
      b2_delete_calls: 0,
      application_d1_cleanup_operations_completed: 0,
    };
  }

  const result = await env.DB.prepare(`
    SELECT *
    FROM purge_operations
    WHERE expires_at <= ?
      AND (
        (
          status IN ('planned', 'retryable_error', 'b2_delete_pending', 'b2_deleted', 'db_cleanup_pending')
          AND (next_attempt_at IS NULL OR next_attempt_at <= ?)
        )
        OR (status = 'revalidating' AND updated_at <= ?)
      )
    ORDER BY expires_at ASC, created_at ASC
    LIMIT ?
  `).bind(
    nowIso,
    nowIso,
    staleBefore,
    PURGE_EXECUTOR_MAX_OPERATIONS_PER_RUN
  ).all();

  const operations = result.results ?? [];
  const summary = {
    enabled: true,
    mode: "gated_executor_with_resumable_ledger",
    operations_considered: operations.length,
    operations_completed: 0,
    operations_retryable: 0,
    operations_blocked: 0,
    operations_skipped: 0,
    b2_delete_calls: 0,
    application_d1_cleanup_operations_completed: 0,
    results: [],
  };

  // The cache is scoped to this scheduled invocation only; object keys are never logged.
  const confirmedAbsentKeys = new Set();

  const adapters = {
    claimOperation: (operation, at, atMs) => claimPurgeOperation(env, operation, at, atMs),
    revalidateOperation: (operation, at, resumeFrom) =>
      revalidatePurgeOperation(env, operation, at, resumeFrom),
    setOperationStatus: (operation, status, details) =>
      setPurgeOperationStatus(env, operation, status, details),
    recordEvent: input => recordPurgeExecutorEvent(env, input),
    deleteObject: async key => {
      summary.b2_delete_calls += 1;
      await deleteB2ObjectAndVerifyAbsent(env, key);
      confirmedAbsentKeys.add(key);
    },
    isObjectAbsent: async key => {
      // deleteB2ObjectAndVerifyAbsent includes a signed HEAD verification.
      // A second HEAD is intentionally unnecessary; the result is returned here
      // using an operation-local confirmation cache.
      return confirmedAbsentKeys.has(key);
    },
    cleanupDatabase: (operation, snapshot, objects, at) =>
      cleanupPurgeDatabaseTarget(env, operation, snapshot, objects, at),
  };

  // Only this run's exact-object checks can populate this cache. Keys are never logged.

  for (const operation of operations) {
    const outcome = await executePurgeOperation({
      enabled: true,
      operation,
      runId,
      nowMs,
      maxAttempts: PURGE_EXECUTOR_MAX_ATTEMPTS,
      adapters,
    });

    if (outcome.status === "completed") summary.operations_completed += 1;
    else if (outcome.status === "retryable_error") summary.operations_retryable += 1;
    else if (outcome.status === "blocked") summary.operations_blocked += 1;
    else summary.operations_skipped += 1;

    if (outcome.status === "completed" && !outcome.alreadyCleaned) {
      summary.application_d1_cleanup_operations_completed += 1;
    }
    summary.results.push({
      operation_id: operation.operation_id,
      status: outcome.status,
      reason: outcome.reason ?? null,
      error_code: outcome.errorCode ?? null,
      attempts: outcome.attempts ?? null,
      next_attempt_at: outcome.nextAttemptAt ?? null,
    });
  }

  return summary;
}


/* =====================================================
   ROUTEUR PRINCIPAL
===================================================== */

export default {
  async scheduled(controller, env) {
    const runId = createUUIDv7();

    try {
      const summary = await auditExpiredFiles(
        env,
        controller?.scheduledTime,
        controller?.cron,
        runId
      );

      console.log(
        "[vitrine-video-purge-dry-run]",
        JSON.stringify(summary)
      );

      const execution = await runDuePurgeOperations(
        env,
        runId,
        Number.isFinite(Number(controller?.scheduledTime)) && Number(controller?.scheduledTime) > 0
          ? Number(controller.scheduledTime)
          : Date.now()
      );
      console.log("[vitrine-video-purge-execution]", JSON.stringify(execution));
    } catch (error) {
      // Mark the durable run as failed when its row has already been created.
      // Re-running the audit is safe because operation IDs and event keys are
      // deterministic/idempotent; this code never deletes B2 or app D1 data.
      try {
        await markPurgeAuditRunFailed(env, runId, error);
      } catch {
        // Preserve the original error if the ledger itself is unavailable.
      }

      console.error(
        "[vitrine-video-purge-ledger-failure]",
        JSON.stringify({
          run_id: runId,
          error_name: error?.name ?? "AuditError"
        })
      );
      throw error;
    }
  },

  async fetch(request, env) {
    // Audit D40 (B7) : CORS — la cible PWA/iOS (D5) ne pouvait appeler l'API
    // depuis un navigateur (preflight OPTIONS -> 405, aucun en-tete ACAO).
    if (request.method === "OPTIONS") {
      return new Response(null, { status: 204, headers: CORS_HEADERS });
    }
    // Audit D40 (B8) : throttle conservateur 300 req/10 s/IP (best-effort par
    // isolate) — NAT-friendly (Afrique de l'Ouest), neutre pour l'app et la CI.
    const limited = throttleGuard(request);
    if (limited) return limited;
    const response = await handleFetch(request, env);
    return withCors(response);
  }
};

const CORS_HEADERS = Object.freeze({
  "access-control-allow-origin": "*",
  "access-control-allow-methods": "GET, POST, PATCH, DELETE, OPTIONS",
  "access-control-allow-headers": "Authorization, Content-Type, Range, X-Requested-With",
  "access-control-expose-headers": "Content-Length, Content-Range, ETag, Retry-After",
  "access-control-max-age": "86400"
});

function withCors(response) {
  if (!(response instanceof Response)) return response;
  const headers = new Headers(response.headers);
  headers.set("access-control-allow-origin", "*");
  headers.set("access-control-expose-headers", "Content-Length, Content-Range, ETag, Retry-After");
  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers
  });
}

const THROTTLE_WINDOW_MS = 10000;
const THROTTLE_MAX_REQUESTS = 300;
const throttleBuckets = new Map();

function throttleGuard(request) {
  const path = new URL(request.url).pathname;
  if (!path.startsWith("/api/")) return null;
  const ip = request.headers.get("cf-connecting-ip") ?? "inconnu";
  const now = Date.now();
  let bucket = throttleBuckets.get(ip);
  if (!bucket || now - bucket.start >= THROTTLE_WINDOW_MS) {
    if (throttleBuckets.size > 10000) throttleBuckets.clear();
    bucket = { start: now, count: 0 };
    throttleBuckets.set(ip, bucket);
  }
  bucket.count += 1;
  if (bucket.count > THROTTLE_MAX_REQUESTS) {
    const retryAfter = String(Math.max(1, Math.ceil((bucket.start + THROTTLE_WINDOW_MS - now) / 1000)));
    return json({ error: "rate_limited" }, 429, { "retry-after": retryAfter });
  }
  return null;
}

async function handleFetch(request, env) {
    const path = new URL(request.url).pathname;

    try {
      if (request.method === "GET" && path === "/") {
        return json({
          service: "vitrine-video-api",
          version: "0.9.0",
          status: "online",
          endpoints: [
            "/health",
            "/api/v1/me",
            "/api/v1/me/bootstrap",
            "/api/v1/templates",
            "/api/v1/merchants",
            "/api/v1/projects",
            "/api/v1/orders",
            "/api/v1/notifications",
            "/api/v1/notifications/{id}/read",
            "/api/v1/orders/{id}/uploads/sign",
            "/api/v1/orders/{id}/uploads/confirm",
            "/api/v1/orders/{id}/uploads/{fileId}"
          ]
        });
      }

      /* ----- Phase B (v0.8.0) : routes additives 2.4, coffre-fort intact ----- */
      if (request.method === "GET" && path === "/api/v1/ins/profile") {
        return routeInsProfile(new URL(request.url), env);
      }

      if (request.method === "GET" && path === "/api/v1/templates/manifest.json") {
        return routeManifest(new URL(request.url), env, false);
      }

      if (request.method === "GET" && path === "/api/v1/templates/canary/manifest.json") {
        return routeManifest(new URL(request.url), env, true);
      }

      if (request.method === "GET" && path.startsWith("/api/v1/assets/")) {
        return routeAsset(path, env);
      }

      if (request.method === "POST" && path === "/api/v1/telemetry") {
        return routeTelemetry(request, env);
      }

      if (request.method === "GET" && path === "/api/v1/flags") {
        return routeFlags(new URL(request.url), env);
      }

      /* ----- Phase B (v0.9.0) : routes additives B4/B5/V7, coffre-fort intact ----- */
      if (request.method === "POST" && path === "/api/v1/internal/billing/webhook") {
        return routeBillingWebhook(request, env);
      }

      if (request.method === "GET" && path === "/api/v1/me/entitlements") {
        const ru = await requireUser(request, env);
        if (!ru.ok) return ru.response;
        return routeMyEntitlements(env, ru.user.id);
      }

      if (request.method === "POST" && path === "/api/v1/consents") {
        const ru = await requireUser(request, env);
        if (!ru.ok) return ru.response;
        return routeConsent(request, env, ru.user.id);
      }

      if (request.method === "GET" && path === "/api/v1/me/referral") {
        const ru = await requireUser(request, env);
        if (!ru.ok) return ru.response;
        return routeMyReferral(env, ru.user.id);
      }

      if (request.method === "POST" && path === "/api/v1/me/referral/claim") {
        const ru = await requireUser(request, env);
        if (!ru.ok) return ru.response;
        return routeReferralClaim(request, env, ru.user.id);
      }

      if (request.method === "POST" && path === "/api/v1/me/welcome-grant") {
        const ru = await requireUser(request, env);
        if (!ru.ok) return ru.response;
        return routeWelcomeGrant(request, env, ru.user.id);
      }

      if (request.method === "POST" && path === "/api/v1/quota/consume") {
        const ru = await requireUser(request, env);
        if (!ru.ok) return ru.response;
        return routeQuotaConsume(request, env, ru.user.id);
      }

      /* ----- Phase D (audit D41) : paiements CinetPay réels, additif ----- */
      if (request.method === "POST" && path === "/api/v1/billing/checkout") {
        const ru = await requireUser(request, env);
        if (!ru.ok) return ru.response;
        return routeBillingCheckout(request, env, ru.user.id);
      }

      if (request.method === "POST" && path === "/api/v1/billing/notify") {
        return routeBillingNotify(request, env);
      }

      if (request.method === "GET" && path === "/api/v1/billing/return") {
        // Page de retour navigateur après paiement hébergé : jamais de cul-de-sac.
        return new Response(
          "<!doctype html><html lang=fr><meta charset=utf-8>" +
          "<meta name=viewport content='width=device-width,initial-scale=1'>" +
          "<title>Vitrine Video — Paiement</title>" +
          "<body style='font-family:sans-serif;background:#022358;color:#fff;" +
          "display:flex;align-items:center;justify-content:center;min-height:90vh'>" +
          "<div style='text-align:center;padding:24px'><h1 style='color:#F95C0F'>✓</h1>" +
          "<p>Tu peux fermer cette page et revenir dans l'application.<br>" +
          "<span lang=en>Payment received — you can close this page and return to the app.</span></p>" +
          "</div></body></html>",
          { headers: { "content-type": "text/html; charset=utf-8", "cache-control": "no-store" } }
        );
      }

      /* ----- Phase C (31/10/2026) : catalogue audio BGM, additif ----- */
      if (request.method === "GET" && path === "/api/v1/audio/catalog") {
        const ru = await requireUser(request, env);
        if (!ru.ok) return ru.response;
        return routeAudioCatalog(env);
      }

      if (request.method === "GET" && path === "/api/v1/audio/library") {
        const ru = await requireUser(request, env);
        if (!ru.ok) return ru.response;
        return routeAudioLibrary(new URL(request.url), env);
      }

      if (request.method === "GET" && path.startsWith("/api/v1/audio/track/")) {
        const ru = await requireUser(request, env);
        if (!ru.ok) return ru.response;
        const categorie = decodeURIComponent(
          path.slice("/api/v1/audio/track/".length)
        );
        return routeAudioTrack(request, env, categorie);
      }

      if (request.method === "GET" && path === "/health") {
        return health(env);
      }

      if (!env.DB) {
        return json({
          error: "database_unavailable"
        }, 503);
      }

      if (path === "/api/v1/internal/storage/orphan-audit") {
        if (request.method !== "POST") {
          return json({ error: "method_not_allowed" }, 405, { allow: "POST" });
        }
        const expectedToken = env.B2_ORPHAN_AUDIT_TOKEN;
        if (typeof expectedToken !== "string" || expectedToken.length < 32) {
          return json({ error: "not_found" }, 404);
        }
        const authorization = request.headers.get("Authorization") ?? "";
        const tokenMatch = authorization.match(/^Bearer\s+(\S+)$/i);
        if (!tokenMatch || !constantTimeStringEqual(tokenMatch[1], expectedToken)) {
          return json({ error: "unauthorized" }, 401);
        }
        try {
          const summary = await auditB2OrphanObjects(env);
          return json({ data: summary }, summary.inventory_complete ? 200 : 503);
        } catch (error) {
          console.error("[vitrine-video-b2-orphan-audit-failed]", JSON.stringify({
            error_name: error?.name ?? "AuditError",
            error_code: typeof error?.message === "string" && /^[a-z0-9_-]{3,80}$/i.test(error.message)
              ? error.message
              : "orphan_audit_failed",
          }));
          return json({ error: "orphan_audit_failed", inventory_complete: false }, 503);
        }
      }

      if (path === "/api/v1/internal/orders/status") {
        if (request.method !== "POST") {
          return json({
            error: "method_not_allowed"
          }, 405, { allow: "POST" });
        }

        return handleSignedLifecycleStatus(request, env);
      }

      const ownerOrderStatusMatch = path.match(
        /^\/api\/v1\/orders\/([0-9a-f-]{36})\/status$/i
      );

      if (ownerOrderStatusMatch) {
        if (request.method !== "POST") {
          return json({
            error: "method_not_allowed"
          }, 405, { allow: "POST" });
        }

        const auth = await requireUser(request, env);
        if (!auth.ok) return auth.response;

        return handleOwnerOrderStatus(
          request,
          env,
          auth.user,
          ownerOrderStatusMatch[1]
        );
      }

      if (
        path === "/api/v1/me/bootstrap" &&
        request.method === "POST"
      ) {
        const auth = await authenticate(request);

        if (!auth.ok) return auth.response;

        return bootstrapProfile(env, auth.payload);
      }

      if (
        path === "/api/v1/me" &&
        request.method === "GET"
      ) {
        const auth = await requireUser(request, env);

        if (!auth.ok) return auth.response;

        return json({
          authenticated: true,
          profile: {
            id: auth.user.id,
            email: auth.user.email,
            locale: auth.user.locale,
            status: auth.user.status,
            plan: auth.user.plan,
            createdAt: auth.user.created_at
          }
        });
      }

      if (
        path === "/api/v1/templates" &&
        request.method === "GET"
      ) {
        const result = await env.DB.prepare(`
          SELECT
            id,
            secteur,
            langue,
            duree_cible_s,
            version
          FROM templates
          WHERE actif = 1
          ORDER BY secteur, langue, duree_cible_s
          LIMIT 50
        `).all();

        const data = result.results ?? [];

        return json({
          data,
          count: data.length
        });
      }

      if (path === "/api/v1/notifications") {
        const auth = await requireUser(request, env);

        if (!auth.ok) return auth.response;

        return handleNotificationCollection(
          request,
          env,
          auth.user
        );
      }

      const notificationReadMatch = path.match(
        /^\/api\/v1\/notifications\/([0-9a-f-]{36})\/read$/i
      );

      if (notificationReadMatch) {
        const auth = await requireUser(request, env);

        if (!auth.ok) return auth.response;

        return handleNotificationRead(
          request,
          env,
          auth.user,
          notificationReadMatch[1]
        );
      }

      const collections = {
        "/api/v1/merchants": handleMerchantCollection,
        "/api/v1/projects": handleProjectCollection,
        "/api/v1/orders": handleOrderCollection
      };

      if (Object.hasOwn(collections, path)) {
        if (!["GET", "POST"].includes(request.method)) {
          return json({
            error: "method_not_allowed"
          }, 405, { allow: "GET, POST" });
        }

        const auth = await requireUser(request, env);

        if (!auth.ok) return auth.response;

        return collections[path](
          request,
          env,
          auth.user
        );
      }

      const uploadMatch = path.match(
        /^\/api\/v1\/orders\/([0-9a-f-]{36})\/uploads\/(sign|confirm)$/i
      );

      if (uploadMatch) {
        if (request.method !== "POST") {
          return json({
            error: "method_not_allowed"
          }, 405, { allow: "POST" });
        }

        const auth = await requireUser(request, env);

        if (!auth.ok) return auth.response;

        if (uploadMatch[2] === "sign") {
          return handleUploadSign(
            request,
            env,
            auth.user,
            uploadMatch[1]
          );
        }

        return handleUploadConfirm(
          request,
          env,
          auth.user,
          uploadMatch[1]
        );
      }

      const uploadDeleteMatch = path.match(
        /^\/api\/v1\/orders\/([0-9a-f-]{36})\/uploads\/([0-9a-f-]{36})$/i
      );

      if (uploadDeleteMatch) {
        if (request.method !== "DELETE") {
          return json({
            error: "method_not_allowed"
          }, 405, { allow: "DELETE" });
        }

        const auth = await requireUser(request, env);

        if (!auth.ok) return auth.response;

        return handleUploadDelete(
          request,
          env,
          auth.user,
          uploadDeleteMatch[1],
          uploadDeleteMatch[2]
        );
      }

      const singleResources = [
        ["merchants", handleSingleMerchant, ["GET", "PATCH"]],
        ["projects", handleSingleProject, ["GET", "PATCH"]],
        ["orders", handleSingleOrder, ["GET"]]
      ];

      for (const [resource, handler, methods] of singleResources) {
        const match = path.match(
          new RegExp(
            `^/api/v1/${resource}/([0-9a-f-]{36})$`,
            "i"
          )
        );

        if (!match) continue;

        if (!methods.includes(request.method)) {
          return json({
            error: "method_not_allowed"
          }, 405, {
            allow: methods.join(", ")
          });
        }

        const auth = await requireUser(request, env);

        if (!auth.ok) return auth.response;

        return handler(
          request,
          env,
          auth.user,
          match[1]
        );
      }

      if (
        !["GET", "POST", "PATCH", "DELETE"].includes(request.method)
      ) {
        return json({
          error: "method_not_allowed"
        }, 405);
      }

      return json({
        error: "not_found",
        message: "Route not found."
      }, 404);

    } catch (error) {
      console.error(
        "Unhandled API error:",
        error?.name ?? "UnknownError"
      );

      return json({
        error: "internal_error",
        message: "The request could not be completed."
      }, 500);
    }
}
