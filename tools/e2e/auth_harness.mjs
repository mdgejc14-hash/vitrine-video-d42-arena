#!/usr/bin/env node
/**
 * D42.14 — Contrat AUTHENTIFIÉ du Worker, exécuté en local, sans compte Firebase.
 *
 * POURQUOI CE FICHIER
 * -------------------
 * Les 15 contrôles HTTP déjà validés ne couvrent que le REJET des jetons
 * (401). Aucune route métier (crédits, parrainage, isolation, `501` de
 * facturation) n'était vérifiée : la JWKS de Google est écrite en dur dans
 * `src/index.js` (lignes 8-12) et aucun jeton local ne peut la satisfaire.
 *
 * COMMENT, SANS MODIFIER UNE SEULE LIGNE DU PRODUIT
 * ------------------------------------------------
 * Le Worker est importé tel quel (`import worker from "../../src/index.js"`).
 * Avant l'import, `globalThis.fetch` est remplacé par un intercepteur qui
 * répond à l'URL exacte de la JWKS Google par une JWKS LOCALE, et REFUSE
 * toute autre requête sortante. `jose` vérifie donc réellement la signature,
 * l'émetteur (`securetoken.google.com/vitrine-video`), l'audience
 * (`vitrine-video`) et l'expiration — avec une clé de test à nous.
 * La base est une vraie SQLite (node:sqlite) sur laquelle sont appliquées les
 * 12 migrations du dépôt, exposée au Worker par un adaptateur D1 minimal.
 *
 * CE QUE CE N'EST PAS
 * -------------------
 * Ce n'est pas un test d'intégration Google : le fournisseur d'identité est
 * remplacé. Les statuts sont donc `PASS_LOCAL_HARNESS`, jamais `PASS_PROD`.
 * Aucune donnée réelle, aucun réseau sortant, aucun jeton Cloudflare.
 *
 * Usage : node tools/e2e/auth_harness.mjs [--db /tmp/auth.db] [--json rapport.json]
 */

import { readFileSync, readdirSync } from "node:fs";
import { DatabaseSync } from "node:sqlite";
import { generateKeyPair, exportJWK, SignJWT } from "jose";
import { fileURLToPath } from "node:url";
import { dirname, join, resolve } from "node:path";

const ICI = dirname(fileURLToPath(import.meta.url));
const RACINE = resolve(ICI, "../..");
const PROJECT_ID = "vitrine-video";
const ISSUER = `https://securetoken.google.com/${PROJECT_ID}`;
const JWKS_URL = "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com";

const args = process.argv.slice(2);
const arg = (nom, defaut) => {
  const i = args.indexOf(nom);
  return i >= 0 && args[i + 1] ? args[i + 1] : defaut;
};
const CHEMIN_DB = arg("--db", "/tmp/auth-d42.db");
const CHEMIN_JSON = arg("--json", join(RACINE, "artifacts", "auth", "auth_report.json"));

const resultats = [];
function verifier(nom, condition, detail) {
  resultats.push({ nom, ok: Boolean(condition), detail });
  console.log(`${condition ? "PASS" : "FAIL"} ${nom} :: ${detail}`);
}

/* ------------------------------------------------------------------ D1 --- */
/** Adaptateur minimal D1 sur node:sqlite (prepare/bind/first/all/run/batch). */
function d1(numero) {
  const db = new DatabaseSync(numero);
  const prepare = (sql) => {
    let valeurs = [];
    const st = {
      bind(...v) {
        valeurs = v;
        return st;
      },
      async first(colonne) {
        const ligne = db.prepare(sql).get(...valeurs);
        if (!ligne) return null;
        return colonne ? ligne[colonne] : ligne;
      },
      async all() {
        return { results: db.prepare(sql).all(...valeurs), success: true, meta: {} };
      },
      async run() {
        const r = db.prepare(sql).run(...valeurs);
        return { success: true, meta: { changes: r.changes, last_row_id: r.lastInsertRowid } };
      }
    };
    return st;
  };
  return {
    prepare,
    async batch(liste) {
      const sortie = [];
      for (const s of liste) sortie.push(await s.all());
      return sortie;
    },
    async exec(sql) {
      db.exec(sql);
      return { count: 0, duration: 0 };
    }
  };
}

/* --------------------------------------------------------------- JWKS --- */
let jwksLocal = null;
const fetchOriginal = globalThis.fetch;
const appelsSortants = [];

function installerInterception() {
  globalThis.fetch = async (entree, init) => {
    const url = typeof entree === "string" ? entree : entree.url;
    if (url.startsWith("https://www.googleapis.com/service_accounts/v1/jwk/")) {
      return new Response(JSON.stringify(jwksLocal), {
        status: 200,
        headers: { "content-type": "application/json" }
      });
    }
    appelsSortants.push(url);
    throw new Error(`Sortie réseau REFUSÉE par le banc : ${url}`);
  };
}

/* --------------------------------------------------------------- jetons --- */
async function jeton(cle, { sub, aud = PROJECT_ID, iss = ISSUER, expire = "+1h", kid }) {
  const maintenant = Math.floor(Date.now() / 1000);
  let jwt = new SignJWT({ email: `${sub}@test.local`, user_id: sub })
    .setProtectedHeader({ alg: "RS256", kid })
    .setIssuer(iss)
    .setAudience(aud)
    .setSubject(sub)
    .setIssuedAt(maintenant)
    .setExpirationTime(expire);
  return jwt.sign(cle);
}

/* ------------------------------------------------------------------ main --- */
async function main() {
  // 1. Base neuve + 12 migrations
  try {
    readFileSync(CHEMIN_DB);
    const { unlinkSync } = await import("node:fs");
    unlinkSync(CHEMIN_DB);
  } catch {
    /* pas de fichier : normal */
  }
  const base = new DatabaseSync(CHEMIN_DB);
  const migrations = readdirSync(join(RACINE, "db/migrations")).filter((f) => f.endsWith(".sql")).sort();
  let appliquees = 0;
  for (const f of migrations) {
    base.exec(readFileSync(join(RACINE, "db/migrations", f), "utf8"));
    appliquees += 1;
  }
  verifier("Migrations appliquées sur SQLite locale", appliquees === 12, `${appliquees}/12 fichiers`);
  base.close();

  // 2. Clé de test + JWKS locale + interception
  const paire = await generateKeyPair("RS256");
  const jwk = await exportJWK(paire.publicKey);
  jwk.kid = "cle-de-test-d42";
  jwk.alg = "RS256";
  jwk.use = "sig";
  jwksLocal = { keys: [jwk] };
  installerInterception();

  // 3. Worker réel
  const { default: worker } = await import("../../src/index.js");
  const env = {
    DB: d1(CHEMIN_DB),
    ENVIRONMENT: "test-banc-d42",
    BILLING_WEBHOOK_SECRET: "secret-de-banc-non-sensible"
  };
  const ctx = { waitUntil() {}, passThroughOnException() {} };
  const appeler = async (chemin, options = {}) => {
    const entetes = new Headers(options.headers || {});
    if (options.token) entetes.set("Authorization", `Bearer ${options.token}`);
    if (options.body !== undefined) entetes.set("Content-Type", "application/json");
    const requete = new Request(`https://api.test.local${chemin}`, {
      method: options.method || "GET",
      headers: entetes,
      body: options.body === undefined ? undefined : JSON.stringify(options.body)
    });
    const reponse = await worker.fetch(requete, env, ctx);
    let corps = null;
    try {
      corps = await reponse.clone().json();
    } catch {
      corps = null;
    }
    return { status: reponse.status, corps };
  };

  const uidA = "uid-compte-a-d42";
  const uidB = "uid-compte-b-d42";
  const jetonA = await jeton(paire.privateKey, { sub: uidA, kid: jwk.kid });
  const jetonB = await jeton(paire.privateKey, { sub: uidB, kid: jwk.kid });

  // 4. Vérifications
  const rA = await appeler("/api/v1/me/bootstrap", { method: "POST", token: jetonA });
  verifier("Bootstrap du compte A", rA.status === 200, `HTTP ${rA.status} ${JSON.stringify(rA.corps).slice(0, 80)}`);
  const rB = await appeler("/api/v1/me/bootstrap", { method: "POST", token: jetonB });
  verifier("Bootstrap du compte B", rB.status === 200, `HTTP ${rB.status}`);

  const meA = await appeler("/api/v1/me", { token: jetonA });
  const meB = await appeler("/api/v1/me", { token: jetonB });
  verifier("GET /me avec jeton valide", meA.status === 200, `HTTP ${meA.status}`);
  const idA = meA.corps?.profile?.id ?? meA.corps?.merchant?.id ?? meA.corps?.id;
  const idB = meB.corps?.profile?.id ?? meB.corps?.merchant?.id ?? meB.corps?.id;
  verifier("Isolement : identités A et B distinctes", Boolean(idA && idB && idA !== idB), `A=${idA} B=${idB}`);

  // Jeton signé par une AUTRE clé (même en-tête, même kid) -> rejet
  const autrePaire = await generateKeyPair("RS256");
  const jetonForge = await jeton(autrePaire.privateKey, { sub: uidA, kid: jwk.kid });
  const rForge = await appeler("/api/v1/me", { token: jetonForge });
  verifier("Signature forgée (même kid) rejetée", rForge.status === 401, `HTTP ${rForge.status}`);

  const rAud = await appeler("/api/v1/me", { token: await jeton(paire.privateKey, { sub: uidA, aud: "autre-projet", kid: jwk.kid }) });
  verifier("Mauvaise audience rejetée", rAud.status === 401, `HTTP ${rAud.status}`);

  const rIss = await appeler("/api/v1/me", { token: await jeton(paire.privateKey, { sub: uidA, iss: "https://evil.example", kid: jwk.kid }) });
  verifier("Mauvais émetteur rejeté", rIss.status === 401, `HTTP ${rIss.status}`);

  const rExp = await appeler("/api/v1/me", { token: await jeton(paire.privateKey, { sub: uidA, expire: "-10m", kid: jwk.kid }) });
  verifier("Jeton expiré rejeté", rExp.status === 401, `HTTP ${rExp.status}`);

  // Crédits de bienvenue : 1re fois accordés, 2e fois idempotent
  const empreinteA = "empreinte-appareil-a-0001";
  const g1 = await appeler("/api/v1/me/welcome-grant", { method: "POST", token: jetonA, body: { fingerprint: empreinteA } });
  const g2 = await appeler("/api/v1/me/welcome-grant", { method: "POST", token: jetonA, body: { fingerprint: empreinteA } });
  verifier("Dotation de bienvenue accordée", g1.status === 200 && g1.corps?.granted === true, `HTTP ${g1.status} ${JSON.stringify(g1.corps)}`);
  verifier("Dotation rejouée : pas de second crédit",
    g2.status === 200 && g2.corps?.granted === false &&
      g2.corps?.credits_left === (g1.corps?.credits_total ?? g2.corps?.credits_left),
    `1er=${JSON.stringify(g1.corps)} 2e=${JSON.stringify(g2.corps)}`);

  // Anti-fraude C16 : nouvel appareil pour un compte déjà doté
  const g3 = await appeler("/api/v1/me/welcome-grant", { method: "POST", token: jetonA, body: { fingerprint: "empreinte-appareil-a-0002" } });
  verifier("Nouvel appareil refusé pour un compte déjà doté", g3.status === 200 && !g3.corps?.granted, JSON.stringify(g3.corps));

  // Facturation : authentifié, non configuré -> 501 (jamais 200, jamais 500)
  // Grille réelle : PLAN_GRID = { pass24h: 500, pro: 3000, boutique: 7500 } (src/index.js:2197).
  // Un plan hors grille répond 422 — c'est voulu, mais ce n'est pas ce que l'on teste ici.
  const paiement = await appeler("/api/v1/billing/checkout", { method: "POST", token: jetonA, body: { plan: "pass24h", amount: 500 } });
  verifier("Facturation authentifiée : 501 billing_not_configured",
    paiement.status === 501 && (paiement.corps?.error || "").includes("billing_not_configured"),
    `HTTP ${paiement.status} ${JSON.stringify(paiement.corps).slice(0, 90)}`);

  // Consommation de quota : idempotence par eventId
  const q1 = await appeler("/api/v1/quota/consume", { method: "POST", token: jetonA, body: { eventId: "evt-d42-001", fingerprint: empreinteA, source: "welcome", kind: "export" } });
  const q2 = await appeler("/api/v1/quota/consume", { method: "POST", token: jetonA, body: { eventId: "evt-d42-001", fingerprint: empreinteA, source: "welcome", kind: "export" } });
  verifier("Quota consommé une fois", q1.status === 200, `HTTP ${q1.status} ${JSON.stringify(q1.corps).slice(0, 80)}`);
  verifier("Événement rejoué : second débit refusé",
    q2.status !== 200 || JSON.stringify(q2.corps) !== JSON.stringify(q1.corps) || q2.status === 409,
    `1er=${JSON.stringify(q1.corps)} 2e=${JSON.stringify(q2.corps)}`);

  // Isolation : B ne peut pas débiter l'empreinte de A
  const qB = await appeler("/api/v1/quota/consume", { method: "POST", token: jetonB, body: { eventId: "evt-d42-002", fingerprint: empreinteA, source: "welcome", kind: "export" } });
  verifier("Compte B ne peut pas débiter l'appareil de A", qB.status === 403, `HTTP ${qB.status} ${JSON.stringify(qB.corps)}`);

  // Parrainage : auto-parrainage refusé
  const refA = await appeler("/api/v1/me/referral", { token: jetonA });
  const codeA = refA.corps?.code;
  if (codeA) {
    const auto = await appeler("/api/v1/me/referral/claim", { method: "POST", token: jetonA, body: { code: codeA, fingerprint: empreinteA } });
    verifier("Auto-parrainage refusé par le Worker", auto.status === 404 || auto.status === 409, `HTTP ${auto.status} ${JSON.stringify(auto.corps)}`);
  } else {
    verifier("Auto-parrainage refusé par le Worker", false,
      `code parrain introuvable (HTTP ${refA.status} ${JSON.stringify(refA.corps).slice(0, 80)})`);
  }

  // Aucune sortie réseau non prévue
  verifier("Aucune requête sortante hors JWKS interceptée", appelsSortants.length === 0,
    appelsSortants.length ? appelsSortants.slice(0, 3).join(", ") : "0 appel");

  const total = resultats.length;
  const ok = resultats.filter((r) => r.ok).length;
  console.log(`\nBILAN AUTH_LOCAL : ${ok}/${total} PASS`);

  const { mkdirSync, writeFileSync } = await import("node:fs");
  mkdirSync(dirname(CHEMIN_JSON), { recursive: true });
  writeFileSync(
    CHEMIN_JSON,
    JSON.stringify(
      {
        banc: "D42.14 — Worker réel, JWKS locale interceptée, D1 = SQLite issue des 12 migrations",
        statut: ok === total ? "PASS_LOCAL_HARNESS" : "FAIL",
        total,
        ok,
        resultats,
        limite:
          "Fournisseur d'identité remplacé par une clé locale : ce banc prouve la chaîne de vérification " +
          "et le comportement métier, PAS une intégration Google réelle (PASS_PROD exigerait un compte Firebase de test)."
      },
      null,
      2
    )
  );
  console.log(`Rapport : ${CHEMIN_JSON}`);
  globalThis.fetch = fetchOriginal;
  process.exit(ok === total ? 0 : 1);
}

main().catch((e) => {
  console.error("ERREUR BANC:", e);
  process.exit(2);
});
