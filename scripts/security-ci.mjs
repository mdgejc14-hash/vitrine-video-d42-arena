
import { randomUUID } from "node:crypto";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const BASE_URL = process.env.API_BASE_URL ?? "http://127.0.0.1:8788";
const failures = [];

const requiredSecrets = [
  "FIREBASE_WEB_API_KEY",
  "FIREBASE_TEST_A_EMAIL",
  "FIREBASE_TEST_A_PASSWORD",
  "FIREBASE_TEST_B_EMAIL",
  "FIREBASE_TEST_B_PASSWORD",
];

for (const name of requiredSecrets) {
  if (!process.env[name]) {
    console.error(`Configuration CI manquante : ${name}`);
    process.exit(1);
  }
}

function check(name, condition, detail = "") {
  if (condition) {
    console.log(`PASS ${name}`);
  } else {
    console.error(`FAIL ${name}${detail ? ` — ${detail}` : ""}`);
    failures.push(name);
  }
}

const RETRYABLE_NETWORK_CODES = new Set([
  "ECONNRESET",
  "ECONNREFUSED",
  "ETIMEDOUT",
]);

function getTransientNetworkCode(error) {
  let current = error;
  const seen = new Set();

  for (let depth = 0; current && depth < 6; depth++) {
    if (typeof current !== "object" || seen.has(current)) break;
    seen.add(current);

    if (
      typeof current.code === "string" &&
      RETRYABLE_NETWORK_CODES.has(current.code)
    ) {
      return current.code;
    }

    current = current.cause;
  }

  return null;
}

async function request(path, options = {}) {
  const headers = new Headers();

  if (options.token) {
    headers.set("Authorization", `Bearer ${options.token}`);
  }

  if (options.body !== undefined) {
    headers.set("Content-Type", "application/json; charset=utf-8");
  }

  const method = options.method ?? "GET";
  const retryEnabled = options.retryOnTransientNetwork === true;
  const maxAttempts = retryEnabled ? 3 : 1;
  let response;

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      response = await fetch(`${BASE_URL}${path}`, {
        method,
        headers,
        ...(options.body !== undefined
          ? { body: JSON.stringify(options.body) }
          : {}),
      });
      break;
    } catch (error) {
      const code = getTransientNetworkCode(error);

      if (!retryEnabled || !code || attempt >= maxAttempts) {
        if (retryEnabled && code) {
          throw new Error(
            `API_FETCH_FAILED method=${method} path=${path} cause=${code}`
          );
        }
        throw error;
      }

      const delayMs = 200 * attempt;
      console.warn(
        `[RETRY] ${method} ${path}: ${code}; ` +
        `tentative ${attempt + 1}/${maxAttempts}, attente ${delayMs} ms`
      );

      await new Promise(resolve => setTimeout(resolve, delayMs));
    }
  }

  const text = await response.text();
  let data = {};

  try {
    data = text ? JSON.parse(text) : {};
  } catch {
    data = { error: "invalid_json_response" };
  }

  return { status: response.status, data };
}

function requireStatus(label, result, expectedStatus) {
  if (result.status !== expectedStatus) {
    throw new Error(
      `${label}: HTTP ${result.status}, attendu ${expectedStatus}` +
      (result.data.error ? ` (${result.data.error})` : "")
    );
  }
  return result.data;
}

function checkError(name, result, status, error) {
  check(
    name,
    result.status === status && result.data.error === error,
    `HTTP ${result.status}, erreur ${result.data.error ?? "absente"}`
  );
}

async function signIn(email, password, label) {
  const key = encodeURIComponent(process.env.FIREBASE_WEB_API_KEY);

  const response = await fetch(
    `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${key}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        email,
        password,
        returnSecureToken: true,
      }),
    }
  );

  const data = await response.json().catch(() => ({}));

  if (!response.ok || !data.idToken || !data.localId) {
    throw new Error(
      `Authentification Firebase du compte ${label} impossible : ` +
      `HTTP ${response.status}. Vérifie les secrets du dépôt.`
    );
  }

  return { token: data.idToken, uid: data.localId };
}

async function bootstrap(token, label) {
  const result = await request("/api/v1/me/bootstrap", {
    method: "POST",
    token,
  });

  const data = requireStatus(`Initialisation locale ${label}`, result, 200);

  if (data.profile?.status !== "actif") {
    throw new Error(`Le profil local ${label} n'est pas actif.`);
  }
}

async function mustCall(label, path, options, expectedStatus = 200) {
  const result = await request(path, options);
  return requireStatus(label, result, expectedStatus);
}

/*
 * Ce script est destiné à une base D1 locale éphémère créée par CI.
 * Les fichiers ci-dessous sont des lignes synthétiques sans objet B2 réel.
 * Les contrôles inter-comptes doivent les refuser avant tout appel au stockage.
 */
function seedLocalTestFiles(orderId) {
  if (!/^[0-9a-f-]{36}$/i.test(orderId)) {
    throw new Error("Identifiant de commande de test invalide.");
  }

  const audioId = randomUUID();
  const proxyId = randomUUID();
  const hash = "a".repeat(64);
  const purgeAt = "2099-01-01T00:00:00.000Z";

  const sql = `
    INSERT INTO files
      (id, order_id, r2_key, role, taille_octets,
       empreinte, uploaded_at, purge_at)
    VALUES
      ('${audioId}', '${orderId}', 'ci-never-uploaded/${audioId}',
       'audio', 1024, '${hash}', NULL, '${purgeAt}'),
      ('${proxyId}', '${orderId}', 'ci-never-uploaded/${proxyId}',
       'proxy', 1024, '${hash}', NULL, '${purgeAt}');
  `;

  const wranglerCli = fileURLToPath(
    new URL("../node_modules/wrangler/bin/wrangler.js", import.meta.url)
  );

  const result = spawnSync(
    process.execPath,
    [
      wranglerCli,
      "d1",
      "execute",
      "vitrine-video-db",
      "--local",
      "--command",
      sql,
    ],
    {
      encoding: "utf8",
      timeout: 30000,
      windowsHide: true,
      cwd: process.cwd(),
    }
  );

  if (result.error || result.status !== 0) {
    const detail = [
      result.error ? `spawn error: ${result.error.message}` : "",
      result.status !== null && result.status !== undefined
        ? `exit code: ${result.status}`
        : "",
      result.stderr?.trim() ? `stderr:\n${result.stderr.trim()}` : "",
      result.stdout?.trim() ? `stdout:\n${result.stdout.trim()}` : "",
    ].filter(Boolean).join("\n");

    throw new Error(
      "Impossible de préparer les fichiers synthétiques dans D1 local.\n" +
      (detail || "Aucun détail renvoyé par Wrangler.")
    );
  }

  return [audioId, proxyId];
}

async function main() {
  console.log("=== VITRINE VIDEO : TESTS API EN ENVIRONNEMENT LOCAL ===");

  const healthResult = await request("/health");
  const health = requireStatus("Santé API", healthResult, 200);

  if (
    health.status !== "ok" ||
    health.database !== "connected" ||
    health.schema !== "ready" ||
    health.applicationTables !== 8
  ) {
    throw new Error("Le Worker local ou son schéma D1 n'est pas prêt.");
  }

  console.log("PASS Santé API, D1 connectée, 8 tables détectées");

  const [a, b] = await Promise.all([
    signIn(
      process.env.FIREBASE_TEST_A_EMAIL,
      process.env.FIREBASE_TEST_A_PASSWORD,
      "A"
    ),
    signIn(
      process.env.FIREBASE_TEST_B_EMAIL,
      process.env.FIREBASE_TEST_B_PASSWORD,
      "B"
    ),
  ]);

  if (a.uid === b.uid) {
    throw new Error("Les comptes Firebase A et B doivent être distincts.");
  }

  await Promise.all([
    bootstrap(a.token, "A"),
    bootstrap(b.token, "B"),
  ]);

  check("Les comptes Firebase A et B sont distincts", a.uid !== b.uid);

  // Authentification sans jeton et jeton invalide.
  checkError(
    "Profil sans jeton refusé",
    await request("/api/v1/me"),
    401,
    "unauthorized"
  );

  checkError(
    "Profil avec jeton invalide refusé",
    await request("/api/v1/me", {
      token: "invalid.test.token",
    }),
    401,
    "unauthorized"
  );

  // La CI doit initialiser ce modèle actif avant de lancer le script.
  const templates = await mustCall(
    "Lecture modèles",
    "/api/v1/templates",
    {},
    200
  );

  if (!templates.data?.some(
    (template) => template.id === "ci-commerce-fr-v1"
  )) {
    throw new Error(
      "Modèle de test absent. Le workflow doit semer ci-commerce-fr-v1 " +
      "dans D1 locale avant le lancement des tests."
    );
  }

  // Créer un commerce, un projet et une commande appartenant à A.
  const merchant = await mustCall(
    "Création du commerce A",
    "/api/v1/merchants",
    {
      method: "POST",
      token: a.token,
      body: {
        nom_commerce: `CI Test A ${randomUUID().slice(0, 8)}`,
        secteur: "commerce",
        ville: "Test CI",
        ton: "neutre",
        public_cible: "Tests automatisés",
      },
    },
    201
  );

  const project = await mustCall(
    "Création du projet A",
    "/api/v1/projects",
    {
      method: "POST",
      token: a.token,
      body: {
        merchant_id: merchant.data.id,
        titre: `CI Project A ${randomUUID().slice(0, 8)}`,
        langue: "fr",
        brief: {
          produit_service: "Test d'isolation API",
          description: "Projet de test local uniquement",
        },
      },
    },
    201
  );

  const orderBody = {
    project_id: project.data.id,
    template_id: "ci-commerce-fr-v1",
    idempotency_key: `ci-${randomUUID()}`,
  };

  const firstOrder = await mustCall(
    "Création de commande A",
    "/api/v1/orders",
    { method: "POST", token: a.token, body: orderBody },
    201
  );

  check(
    "La nouvelle commande est en brouillon",
    firstOrder.data.statut === "brouillon"
  );

  const replay = await request("/api/v1/orders", {
    method: "POST",
    token: a.token,
    body: orderBody,
  });

  check(
    "Idempotence : même commande retournée",
    replay.status === 200 &&
      replay.data.idempotent_replay === true &&
      replay.data.data?.id === firstOrder.data.id
  );

  const orderId = firstOrder.data.id;
  const merchantId = merchant.data.id;
  const projectId = project.data.id;

  // Ressources directes : B doit recevoir les erreurs not-found.
  checkError(
    "B ne peut pas lire le commerce A",
    await request(`/api/v1/merchants/${merchantId}`, { token: b.token }),
    404,
    "merchant_not_found"
  );

  checkError(
    "B ne peut pas lire le projet A",
    await request(`/api/v1/projects/${projectId}`, { token: b.token }),
    404,
    "project_not_found"
  );

  checkError(
    "B ne peut pas lire la commande A",
    await request(`/api/v1/orders/${orderId}`, { token: b.token }),
    404,
    "order_not_found"
  );

  // Modifications croisées : les propriétaires ne doivent pas être modifiés.
  checkError(
    "B ne peut pas modifier le commerce A",
    await request(`/api/v1/merchants/${merchantId}`, {
      method: "PATCH",
      token: b.token,
      body: { nom_commerce: "MODIFICATION INTERDITE" },
    }),
    404,
    "merchant_not_found"
  );

  checkError(
    "B ne peut pas modifier le projet A",
    await request(`/api/v1/projects/${projectId}`, {
      method: "PATCH",
      token: b.token,
      body: { titre: "MODIFICATION INTERDITE" },
    }),
    404,
    "project_not_found"
  );

  // Collections : les ressources A ne doivent pas apparaître pour B.
  const merchantsB = await mustCall(
    "Liste commerces B",
    "/api/v1/merchants",
    { token: b.token }
  );

  const projectsB = await mustCall(
    "Liste projets B",
    "/api/v1/projects",
    { token: b.token }
  );

  const ordersB = await mustCall(
    "Liste commandes B",
    "/api/v1/orders",
    { token: b.token }
  );

  check(
    "La collection B ne révèle pas le commerce A",
    !merchantsB.data.some((row) => row.id === merchantId)
  );

  check(
    "La collection B ne révèle pas le projet A",
    !projectsB.data.some((row) => row.id === projectId)
  );

  check(
    "La collection B ne révèle pas la commande A",
    !ordersB.data.some((row) => row.id === orderId)
  );

  // Notifications : la création de commande génère une notification chez A.
  const notificationsA = await mustCall(
    "Notifications A",
    "/api/v1/notifications?limit=50",
    { token: a.token }
  );

  const notificationsB = await mustCall(
    "Notifications B",
    "/api/v1/notifications?limit=50",
    { token: b.token }
  );

  check(
    "La collection de notifications B ne révèle aucune notification A",
    !notificationsA.data.some((notification) =>
      notificationsB.data.some((other) => other.id === notification.id)
    )
  );

  if (notificationsA.data.length > 0) {
    const notificationId = notificationsA.data[0].id;

    checkError(
      "B ne peut pas marquer comme lue une notification A",
      await request(`/api/v1/notifications/${notificationId}/read`, {
        method: "PATCH",
        token: b.token,
      }),
      404,
      "notification_not_found"
    );
  } else {
    check("Notification A disponible pour le test", false);
  }

  // Upload : le compte B ne doit pas pouvoir obtenir une signature pour A.
  const uploadBody = {
    role: "audio",
    content_type: "audio/webm",
    sha256: "a".repeat(64),
    size_bytes: 1024,
  };

  checkError(
    "B ne peut pas signer un upload pour la commande A",
    await request(`/api/v1/orders/${orderId}/uploads/sign`, {
      method: "POST",
      token: b.token,
      body: uploadBody,
    }),
    404,
    "order_not_found"
  );

  checkError(
    "Un rôle inconnu est rejeté",
    await request(`/api/v1/orders/${orderId}/uploads/sign`, {
      method: "POST",
      token: a.token,
      body: { ...uploadBody, role: "invalid_test_role" },
    }),
    400,
    "validation_failed"
  );

  checkError(
    "Un type MIME audio non autorisé est rejeté",
    await request(`/api/v1/orders/${orderId}/uploads/sign`, {
      method: "POST",
      token: a.token,
      body: { ...uploadBody, content_type: "audio/mpeg" },
    }),
    415,
    "unsupported_file_type"
  );

  // Fichiers synthétiques en D1 locale : aucun objet B2 n'existe.
  const testFileIds = seedLocalTestFiles(orderId);

  for (const fileId of testFileIds) {
    checkError(
      `B ne peut pas confirmer le fichier A (${fileId})`,
      await request(`/api/v1/orders/${orderId}/uploads/confirm`, {
        method: "POST",
        token: b.token,
        body: { file_id: fileId },
        retryOnTransientNetwork: true,
      }),
      404,
      "file_not_found"
    );

    checkError(
      `B ne peut pas supprimer le fichier A (${fileId})`,
      await request(`/api/v1/orders/${orderId}/uploads/${fileId}`, {
        method: "DELETE",
        token: b.token,
      }),
      404,
      "file_not_found"
    );
  }

  // Cycle de vie : B ne doit pas pouvoir changer le statut de la commande A.
  checkError(
    "B ne peut pas changer le statut de la commande A",
    await request(`/api/v1/orders/${orderId}/status`, {
      method: "POST",
      token: b.token,
      body: {
        expected_status: "brouillon",
        new_status: "echec",
      },
    }),
    404,
    "order_not_found"
  );

  const orderAfter = await mustCall(
    "Relire la commande A",
    `/api/v1/orders/${orderId}`,
    { token: a.token }
  );

  check(
    "Le statut de A est resté brouillon",
    orderAfter.data.statut === "brouillon"
  );

  // ÉTAPE 7 : notification de changement de statut.
  // Cette commande est synthétique et n'existe que dans la D1 locale de CI.
  const statusBody = {
    expected_status: "brouillon",
    new_status: "echec",
  };

  const statusChange = await request(
    `/api/v1/orders/${orderId}/status`,
    {
      method: "POST",
      token: a.token,
      body: statusBody,
    }
  );

  check(
    "Transition de statut enregistrée",
    statusChange.status === 200 &&
      statusChange.data.status_event_recorded === true &&
      statusChange.data.data?.previous_status === "brouillon" &&
      statusChange.data.data?.status === "echec",
    `HTTP ${statusChange.status}, erreur ${statusChange.data.error ?? "absente"}`
  );

  const statusNotifications = await request(
    "/api/v1/notifications?limit=50",
    { token: a.token }
  );

  const matchingStatusNotifications = (
    statusNotifications.data.data ?? []
  ).filter(
    (notification) =>
      notification.type === "order_status_changed" &&
      notification.payload?.order_id === orderId
  );

  check(
    "Une notification est créée pour la transition",
    statusNotifications.status === 200 &&
      matchingStatusNotifications.length === 1 &&
      matchingStatusNotifications[0].payload.previous_status === "brouillon" &&
      matchingStatusNotifications[0].payload.status === "echec"
  );

  // Répéter la transition avec l'ancien statut ne doit pas créer de notification.
  const staleRetry = await request(
    `/api/v1/orders/${orderId}/status`,
    {
      method: "POST",
      token: a.token,
      body: statusBody,
    }
  );

  check(
    "Une transition répétée avec un ancien statut est rejetée",
    staleRetry.status === 409 &&
      staleRetry.data.error === "stale_status",
    `HTTP ${staleRetry.status}, erreur ${staleRetry.data.error ?? "absente"}`
  );

  const notificationsAfterRetry = await request(
    "/api/v1/notifications?limit=50",
    { token: a.token }
  );

  const matchingAfterRetry = (
    notificationsAfterRetry.data.data ?? []
  ).filter(
    (notification) =>
      notification.type === "order_status_changed" &&
      notification.payload?.order_id === orderId
  );

  check(
    "La répétition ne crée pas de notification supplémentaire",
    notificationsAfterRetry.status === 200 &&
      matchingAfterRetry.length === 1
  );

  // C16 (audit final, migration 0009) : identite marchande. Avant ce correctif,
  // signup_fingerprint/referral_code etaient lus dans `merchants` (id = UUID de
  // profil commerce) alors que les routes mobiles passent users.id : les credits
  // de bienvenue etaient invisibles serveur et /me/referral repondait 500.
  const fingerprintB = `fp-ci-${randomUUID()}`;
  const grantB = await mustCall("Octroi de bienvenue (B)", "/api/v1/me/welcome-grant", {
    method: "POST",
    token: b.token,
    body: { fingerprint: fingerprintB },
  });
  check("Bienvenue : 3 crédits octroyés", grantB.granted === true && grantB.credits_total === 3);

  const entB1 = await mustCall("Droits après octroi (B)", "/api/v1/me/entitlements", { token: b.token });
  check("Droits voient les 3 crédits (merchant_identity 0009)", entB1.welcome_credits_left === 3);

  await mustCall("Consommation d'un crédit (B)", "/api/v1/quota/consume", {
    method: "POST",
    token: b.token,
    body: {
      eventId: `ev-ci-${randomUUID()}`,
      fingerprint: fingerprintB,
      source: "welcome",
      kind: "export",
    },
  });

  const entB2 = await mustCall("Droits après consommation (B)", "/api/v1/me/entitlements", { token: b.token });
  check("Décompte strict 3 -> 2 (jamais négatif)", entB2.welcome_credits_left === 2);

  // Audit D41 : durcissement quota/consume — eventId requis (PRIMARY KEY de
  // quota_ledger : un "" vide entrait en collision GLOBALE) et empreinte
  // vérifiée contre merchant_identity (un client compromis ne peut plus
  // décrémenter les crédits d'un AUTRE appareil).
  const emptyEvent = await request("/api/v1/quota/consume", {
    method: "POST",
    token: b.token,
    body: { eventId: "", fingerprint: fingerprintB, source: "welcome", kind: "export" },
  });
  check("Quota : eventId vide refusé (400) — collision PK globale", emptyEvent.status === 400);

  const wrongFingerprint = await request("/api/v1/quota/consume", {
    method: "POST",
    token: b.token,
    body: {
      eventId: `ev-ci-${randomUUID()}`,
      fingerprint: `fp-ci-${randomUUID()}`,
      source: "welcome",
      kind: "export",
    },
  });
  check(
    "Quota : empreinte non liée au compte refusée (403) — isolation des crédits",
    wrongFingerprint.status === 403
  );

  const entB3 = await mustCall("Droits après attaques quota (B)", "/api/v1/me/entitlements", { token: b.token });
  check("Quota : tentatives refusées n'ont rien décrémenté (toujours 2)", entB3.welcome_credits_left === 2);

  const replayGrant = await mustCall("Re-octroi même empreinte (B)", "/api/v1/me/welcome-grant", {
    method: "POST",
    token: b.token,
    body: { fingerprint: fingerprintB },
  });
  check("Empreinte appareil : octroi unique (D13)", replayGrant.granted === false);

  // Anti-fraude : UN compte ne peut pas multiplier les octrois en changeant
  // d'empreinte appareil (spec 9.1 « attribués une fois »).
  const otherDevice = await mustCall("Octroi sur autre empreinte (B)", "/api/v1/me/welcome-grant", {
    method: "POST",
    token: b.token,
    body: { fingerprint: `fp-ci-${randomUUID()}` },
  });
  check(
    "Un compte = un seul octroi de bienvenue (anti multi-appareils)",
    otherDevice.granted === false && otherDevice.reason === "already_granted"
  );

  const refB = await mustCall("Code de parrainage (B)", "/api/v1/me/referral", { token: b.token });
  check("Parrainage : code serveur renvoyé (était HTTP 500 avant 0009)", typeof refB.code === "string" && refB.code.length >= 3);

  await testAudioCatalog(b.token);

  await testBillingWebhook();

  await testBillingCheckout(b.token);

  if (failures.length > 0) {
    console.error(`\nECHEC : ${failures.length} contrôle(s) à corriger.`);
    process.exitCode = 1;
  } else {
    console.log("\nPASS : tous les contrôles de sécurité CI ont réussi.");
  }
}


/**
 * Phase C (31/10/2026) : catalogue BGM — routes /api/v1/audio/*.
 * Le catalogue doit exposer exactement les 30 pistes des gabarits (auth requise).
 * La route morceau dépend de l'approvisionnement B2 : 200 (en ligne),
 * 404 track_not_uploaded (dossier en place, fichier absent) ou
 * 503 storage_not_configured (CI sans secret B2) — les trois sont des états
 * honnêtes ; l'injection de chemin et le défaut d'auth doivent toujours échouer.
 */
async function testAudioCatalog(token) {
  const noAuth = await request("/api/v1/audio/catalog");
  checkError("Catalogue audio : sans jeton refusé (401)", noAuth, 401, "unauthorized");

  const catalog = await mustCall("Catalogue audio (30 pistes)", "/api/v1/audio/catalog", { token });
  check(
    "Catalogue audio : exactement 30 pistes (6 secteurs × T1–T5)",
    catalog.count === 30 && Array.isArray(catalog.pistes) && catalog.pistes.length === 30
  );
  const t1vetements = catalog.pistes.find((p) => p.categorie_audio === "musique_t1_vetements_mode");
  check(
    "Catalogue audio : métadonnées gabarit présentes (BPM 100–112, genre, format)",
    Boolean(t1vetements) &&
      t1vetements.bpm_min === 100 &&
      t1vetements.bpm_max === 112 &&
      typeof t1vetements.genre === "string" && t1vetements.genre.length > 0 &&
      t1vetements.format === "T1" &&
      typeof t1vetements.disponible === "boolean"
  );
  const secteurs = new Set(catalog.pistes.map((p) => p.secteur));
  check("Catalogue audio : 6 secteurs couverts", secteurs.size === 6);

  const libNoAuth = await request("/api/v1/audio/library");
  checkError("Bibliothèque BGM : sans jeton refusée (401)", libNoAuth, 401, "unauthorized");

  const lib = await mustCall("Bibliothèque BGM (600 pistes)", "/api/v1/audio/library?limit=200", { token });
  check(
    "Bibliothèque BGM : 600 pistes, synthèse CC0 ÉTIQUETÉE (aucun master humain inventé)",
    lib.total === 600 &&
      lib.pistes.every((p) => p.origine === "synthese_procedurale_v1" && p.licence === "CC0-1.0")
  );

  const libSecteur = await mustCall(
    "Bibliothèque BGM par secteur",
    "/api/v1/audio/library?secteur=vetements_mode&limit=200",
    { token }
  );
  check("Bibliothèque BGM : 100 pistes par secteur (6 secteurs × 100)", libSecteur.count === 100);

  check(
    "Catalogue audio : piste marquée disponible via bibliothèque",
    t1vetements !== undefined && t1vetements.disponible === true
  );

  const trackNoAuth = await request("/api/v1/audio/track/musique_t1_vetements_mode");
  checkError("Morceau : sans jeton refusé (401)", trackNoAuth, 401, "unauthorized");

  const unknown = await request("/api/v1/audio/track/musique_t9_inconnu", { token });
  checkError("Morceau : catégorie inconnue refusée (404)", unknown, 404, "unknown_track");

  const traversal = await request(
    "/api/v1/audio/track/" + encodeURIComponent("../../merchants"),
    { token }
  );
  checkError("Morceau : injection de chemin refusée (404)", traversal, 404, "unknown_track");

  // État d'approvisionnement : 200 (piste téléversée), 404 track_not_uploaded
  // (structure B2 en place, fichier absent) ou 503 storage_not_configured
  // (environnement sans secret B2). Toute autre réponse est un défaut.
  const trackResponse = await fetch(`${BASE_URL}/api/v1/audio/track/musique_t1_vetements_mode`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  const trackStatus = trackResponse.status;
  if (trackStatus === 200) {
    const cacheControl = trackResponse.headers.get("cache-control") ?? "";
    check(
      "Morceau en ligne : stream + cache définitif (immutable, 30 j) + Range accepté",
      cacheControl.includes("immutable") &&
        cacheControl.includes("max-age=2592000") &&
        trackResponse.headers.get("accept-ranges") === "bytes" &&
        (trackResponse.headers.get("content-type") ?? "").startsWith("audio/")
    );
    await trackResponse.body?.cancel();
  } else {
    const data = await trackResponse.json().catch(() => ({}));
    check(
      "Morceau : état d'approvisionnement honnête (404 track_not_uploaded ou 503 storage_not_configured)",
      (trackStatus === 404 && data.error === "track_not_uploaded") ||
        (trackStatus === 503 && data.error === "storage_not_configured"),
      `HTTP ${trackStatus} ${JSON.stringify(data)}`
    );
  }
}

/**
 * C16 (audit final) : webhook de facturation — signature HMAC obligatoire,
 * replay IDEMPOTENT (200 duplicate:true, jamais de double credit), montant
 * hors grille officielle refuse (422), corps malformed refuse (400).
 * SKIP honnete si BILLING_WEBHOOK_SECRET absent (run local sans .dev.vars).
 */
async function testBillingWebhook() {
  const secret = process.env.BILLING_WEBHOOK_SECRET;
  if (!secret) {
    console.log("SKIP webhook billing : BILLING_WEBHOOK_SECRET absent");
    return;
  }
  const { createHmac } = await import("node:crypto");
  const sign = (body) => createHmac("sha256", secret).update(body).digest("hex");
  const post = async (body, signature) => {
    const response = await fetch(`${BASE_URL}/api/v1/internal/billing/webhook`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-webhook-signature": signature,
      },
      body,
    });
    let data = {};
    try {
      data = await response.json();
    } catch {
      data = {};
    }
    return { status: response.status, data };
  };

  const ref = `VV-${randomUUID()}`;
  const payload = JSON.stringify({
    ref,
    merchant_id: `mer-${randomUUID()}`,
    plan: "pass24h",
    amount: 500,
    status: "paid",
    provider: "cinetpay",
    renews_at: null,
  });

  const badSig = await post(payload, "0".repeat(64));
  check("Webhook billing : signature invalide refusée (401)", badSig.status === 401);

  const malformed = "{ ceci n\'est pas du JSON";
  const badBody = await post(malformed, sign(malformed));
  check("Webhook billing : corps malformed refusé (400)", badBody.status === 400);

  const horsGrille = JSON.stringify({ ...JSON.parse(payload), ref: `VV-${randomUUID()}`, amount: 1 });
  const badAmount = await post(horsGrille, sign(horsGrille));
  check("Webhook billing : montant hors grille officielle refusé (422)", badAmount.status === 422);

  // Audit D41 : avant, un plan INCONNU (ou absent) passait la validation
  // conditionnelle et créait un abonnement hors contrat à montant libre.
  const unknownPlan = JSON.stringify({
    ...JSON.parse(payload),
    ref: `VV-${randomUUID()}`,
    plan: "enterprise",
    amount: 1,
  });
  const badPlan = await post(unknownPlan, sign(unknownPlan));
  check("Webhook billing : plan inconnu refusé (422) — grille stricte 3 forfaits", badPlan.status === 422);

  const planAbsent = JSON.stringify({
    ref: `VV-${randomUUID()}`,
    merchant_id: `mer-${randomUUID()}`,
    amount: 500,
    status: "paid",
    provider: "cinetpay",
  });
  const missingPlan = await post(planAbsent, sign(planAbsent));
  check("Webhook billing : plan absent refusé (422)", missingPlan.status === 422);

  const ok = await post(payload, sign(payload));
  check("Webhook billing : achat Pass 24 h (500 FCFA) validé", ok.status === 200 && ok.data.ok === true);

  const replay = await post(payload, sign(payload));
  check(
    "Webhook billing : replay signé idempotent (200 duplicate, zéro double crédit)",
    replay.status === 200 && replay.data.duplicate === true
  );
}

/**
 * Audit D41 (F10) : checkout CinetPay créé côté SERVEUR + notification vérifiée.
 * En CI, les clés CinetPay sont absentes : l'état honnête attendu est 501
 * « billing_not_configured » (jamais de faux succès, jamais d'URL inventée).
 * Les refus de validation (plan hors grille, anonyme, corps invalide) doivent
 * fonctionner MÊME sans clés — la grille et l'auth ne dépendent pas du fournisseur.
 */
async function testBillingCheckout(token) {
  const notConfigured = await request("/api/v1/billing/checkout", {
    method: "POST",
    token,
    body: { plan: "pro" },
  });
  check(
    "Checkout : fournisseur non configuré = 501 honnête (pas de faux succès)",
    notConfigured.status === 501 && notConfigured.data.error === "billing_not_configured",
    `HTTP ${notConfigured.status}`
  );

  const badPlan = await request("/api/v1/billing/checkout", {
    method: "POST",
    token,
    body: { plan: "enterprise" },
  });
  check("Checkout : plan hors grille refusé (422)", badPlan.status === 422);

  const anonymous = await request("/api/v1/billing/checkout", {
    method: "POST",
    body: { plan: "pro" },
  });
  check(
    "Checkout : anonyme refusé (401/403) — autorité JWT",
    anonymous.status === 401 || anonymous.status === 403,
    `HTTP ${anonymous.status}`
  );

  const notifyEmpty = await request("/api/v1/billing/notify", {
    method: "POST",
    body: {},
  });
  check("CinetPay notify : corps sans transaction_id refusé (400)", notifyEmpty.status === 400);

  const notifyUnknown = await request("/api/v1/billing/notify", {
    method: "POST",
    body: { transaction_id: `VV-${randomUUID()}` },
  });
  check(
    "CinetPay notify : sans clés/Commande inconnue, jamais de crédit (501/404)",
    notifyUnknown.status === 501 || notifyUnknown.status === 404,
    `HTTP ${notifyUnknown.status}`
  );

  const notifyNoAuth = await request("/api/v1/billing/notify", {
    method: "GET",
  });
  check("CinetPay notify : méthode inattendue non créditante", notifyNoAuth.status >= 400);
}

main().catch((error) => {
  // Ne jamais afficher les jetons, mots de passe ni la clé Firebase.
  console.error(`Tests CI interrompus : ${error.message}`);
  process.exitCode = 1;
});
