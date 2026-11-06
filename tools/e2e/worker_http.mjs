#!/usr/bin/env node
/**
 * Pont HTTP LOCAL pour `scripts/security-ci.mjs` — D42.14.
 *
 * Problème : la suite de sécurité (69 contrôles) exige un Worker joignable par
 * HTTP et des jetons obtenus auprès de `identitytoolkit.googleapis.com`, donc un
 * projet Firebase. Nous n'en avons pas.
 *
 * Solution : ce processus
 *   1. importe le VRAI `src/index.js` ;
 *   2. remplace la JWKS Google par une clé RSA LOCALE (`/tmp/d42-idp/cle.pem`) ;
 *   3. sert ce Worker sur http://127.0.0.1:8790 avec une SQLite issue des
 *      12 migrations (adaptateur D1 minimal) ;
 *   4. n'accepte AUCUNE sortie réseau : toute requête sortante est refusée.
 *
 * Le fournisseur d'identité reste simulé (côté client : idp_preload.mjs) ;
 * le serveur, la vérification JWT et la base sont réels.
 * Statut produit : PASS_LOCAL_HARNESS — jamais PASS_PROD.
 */
import { createServer } from "node:http";
import { readFileSync, readdirSync, mkdirSync, existsSync, writeFileSync, unlinkSync } from "node:fs";
import { join, dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { DatabaseSync } from "node:sqlite";
import { generateKeyPair, exportPKCS8, exportJWK, importPKCS8 } from "jose";

const ICI = dirname(fileURLToPath(import.meta.url));
const RACINE = resolve(ICI, "../..");
const DOSSIER_IDP = "/tmp/d42-idp";
const CHEMIN_DB = process.env.DB_PATH || "/tmp/d42-security.db";
const PORT = Number(process.env.PORT_BRIDGE || 8790);

/* --------------------------------------------------------------- clé IdP --- */
mkdirSync(DOSSIER_IDP, { recursive: true });
const cheminCle = join(DOSSIER_IDP, "cle.pem");
if (!existsSync(cheminCle)) {
  // extractable:true — sinon jose refuse exportPKCS8 (mesuré : CryptoKey is not extractable)
  const paire = await generateKeyPair("RS256", { extractable: true });
  writeFileSync(cheminCle, await exportPKCS8(paire.privateKey), { mode: 0o600 });
}
const clePrivee = await importPKCS8(readFileSync(cheminCle, "utf8"), "RS256");
void clePrivee; // la clé sert via idp_preload.mjs ; ici on ne garde que la publique
const { createPublicKey } = await import("node:crypto");
const publique = createPublicKey({ key: readFileSync(cheminCle, "utf8"), format: "pem" });
const jwkPublic = await exportJWK(publique);
jwkPublic.kid = "cle-locale-d42";
jwkPublic.alg = "RS256";
jwkPublic.use = "sig";
const jwks = { keys: [jwkPublic] };

/* --------------------------------------------- API Cache (Workers) simulée --- */
// Le runtime Workers expose `caches` ; Node non. Sans ce substitut, les routes
// qui lisent un cache renvoient « caches is not defined » (mesuré : route
// /api/v1/audio/track, HTTP 500 bridge_exception). Cache en mémoire, par nom.
if (!globalThis.caches) {
  const magasins = new Map();
  const cle = (r) => (typeof r === "string" ? r : r.url);
  const magasin = (nom) => {
    if (!magasins.has(nom)) {
      const m = new Map();
      magasins.set(nom, {
        async match(r) { const v = m.get(cle(r)); return v ? v.clone() : undefined; },
        async put(r, rep) { m.set(cle(r), rep.clone()); },
        async delete(r) { return m.delete(cle(r)); }
      });
    }
    return magasins.get(nom);
  };
  globalThis.caches = {
    default: magasin("default"),
    async open(nom) { return magasin(nom); }
  };
}

/* ---------------------------------------------- interception réseau totale --- */
const fetchOrigine = globalThis.fetch;
globalThis.fetch = async (entree, init) => {
  const url = typeof entree === "string" ? entree : entree.url;
  if (url.startsWith("https://www.googleapis.com/service_accounts/v1/jwk/")) {
    return new Response(JSON.stringify(jwks), { status: 200, headers: { "content-type": "application/json" } });
  }
  throw new Error(`Sortie réseau REFUSÉE par le pont : ${url}`);
};

/* --------------------------------------------------------------------- D1 --- */
// Adaptateur D1 minimal sur node:sqlite.
// PIÈGE (mesuré) : le Worker lit `results[i].meta.changes` après un batch()
// pour détecter une course de transition — sans cette métadonnée, il renvoie
// HTTP 503 transition_race_or_event_write_failed. `__executer()` la fournit.
function d1(chemin) {
  const db = new DatabaseSync(chemin);
  const prepare = (sql) => {
    let v = [];
    const st = {
      bind(...args) { v = args; return st; },
      async first(col) { const l = db.prepare(sql).get(...v); return !l ? null : (col ? l[col] : l); },
      async all() { return { results: db.prepare(sql).all(...v), success: true, meta: {} }; },
      async run() {
        const r = db.prepare(sql).run(...v);
        return { success: true, meta: { changes: r.changes, last_row_id: r.lastInsertRowid } };
      },
      __executer() {
        if (/^\s*(select|with)/i.test(sql)) {
          return { results: db.prepare(sql).all(...v), changes: 0, last_row_id: 0 };
        }
        const r = db.prepare(sql).run(...v);
        return { results: [], changes: r.changes, last_row_id: r.lastInsertRowid };
      }
    };
    return st;
  };
  return {
    prepare,
    async batch(liste) {
      const sortie = [];
      for (const s of liste) {
        const r = s.__executer
          ? s.__executer()
          : { results: (await s.all()).results, changes: 0, last_row_id: 0 };
        sortie.push({ results: r.results, success: true, meta: { changes: r.changes, last_row_id: r.last_row_id } });
      }
      return sortie;
    },
    async exec(sql) { db.exec(sql); return { count: 0, duration: 0 }; }
  };
}

// D42_KEEP_DB=1 : réutilise la base SQLite du wrangler local (celle que
// security-ci.mjs alimente lui-même par `wrangler d1 execute`). Sinon le pont
// repart d'une base neuve et les deux processus ne voient pas la même.
const CONSERVER = process.env.D42_KEEP_DB === "1";
if (!CONSERVER) {
  if (existsSync(CHEMIN_DB)) unlinkSync(CHEMIN_DB);
  const base = new DatabaseSync(CHEMIN_DB);
  const fichiers = readdirSync(join(RACINE, "db/migrations")).filter((f) => f.endsWith(".sql")).sort();
  for (const f of fichiers) base.exec(readFileSync(join(RACINE, "db/migrations", f), "utf8"));
  // Gabarit CI-only, identique à .github/workflows/api-security-tests.yml
  base.exec(`INSERT OR REPLACE INTO templates
    (id, secteur, langue, duree_cible_s, edl_json, regles_qc_json, version, actif)
    VALUES ('ci-commerce-fr-v1', 'commerce', 'fr', 30, '{}', '{}', 1, 1);`);
  base.close();
  console.log(`[pont] ${fichiers.length} migrations appliquées sur ${CHEMIN_DB}`);
}

const { default: worker } = await import(join(RACINE, "src/index.js"));
const env = {
  DB: d1(CHEMIN_DB),
  ENVIRONMENT: "pont-local-d42",
  BILLING_WEBHOOK_SECRET: process.env.BILLING_WEBHOOK_SECRET || "secret-de-banc-non-sensible"
};
const ctx = { waitUntil() {}, passThroughOnException() {} };
const sansCorps = new Set(["GET", "HEAD"]);

const serveur = createServer(async (req, res) => {
  const morceaux = [];
  for await (const m of req) morceaux.push(m);
  const corps = morceaux.length ? Buffer.concat(morceaux) : undefined;
  const entetes = new Headers();
  for (const [k, v] of Object.entries(req.headers)) {
    if (k === "host" || k === "connection" || k === "content-length") continue;
    entetes.set(k, Array.isArray(v) ? v.join(",") : v);
  }
  const methode = (req.method || "GET").toUpperCase();
  const requete = new Request(`https://api.test.local${req.url}`, {
    method: methode,
    headers: entetes,
    body: sansCorps.has(methode) ? undefined : corps
  });
  try {
    const reponse = await worker.fetch(requete, env, ctx);
    const buf = Buffer.from(await reponse.arrayBuffer());
    res.writeHead(reponse.status, Object.fromEntries(reponse.headers));
    res.end(buf);
  } catch (e) {
    console.error("[pont] erreur worker:", e.message);
    res.writeHead(500, { "content-type": "application/json" });
    res.end(JSON.stringify({ error: "bridge_exception", detail: String(e.message).slice(0, 120) }));
  }
});

serveur.listen(PORT, "127.0.0.1", () => {
  console.log(`[pont] Worker local sur http://127.0.0.1:${PORT} (sorties réseau: 0)`);
  process.on("SIGTERM", () => { serveur.close(); process.exit(0); });
});
