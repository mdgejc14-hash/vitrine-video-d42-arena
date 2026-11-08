import { writeFileSync } from "node:fs";

// D42.26 §13-C — QUALIFICATION DU PARRAINAGE (intégration réelle, comptes de test A/B)
// Lecture des routes + scénarios de claim entre les deux comptes de TEST
// dédiés (aucune donnée utilisateur réel — mêmes comptes que api-security).
// Sortie : contrôles PASS/FAIL + artefact JSON. Aucune valeur de secret
// n'est jamais imprimée.
const API = (process.env.API_BASE_URL || "").replace(/\/+$/, "");
const FB_KEY = process.env.FIREBASE_WEB_API_KEY || "";
const EMAIL_A = process.env.FIREBASE_TEST_A_EMAIL || "";
const PASS_A = process.env.FIREBASE_TEST_A_PASSWORD || "";
const EMAIL_B = process.env.FIREBASE_TEST_B_EMAIL || "";
const PASS_B = process.env.FIREBASE_TEST_B_PASSWORD || "";

if (!API || !FB_KEY || !EMAIL_A || !PASS_A || !EMAIL_B || !PASS_B) {
  console.error("Configuration manquante : API_BASE_URL/FIREBASE_TEST_A*/FIREBASE_TEST_B* requis.");
  process.exit(1);
}

const rapport = { demarre: new Date().toISOString(), api: API, controles: {} };
function rec(nom, ok, detail) {
  rapport.controles[nom] = { ok, detail };
  console.log(`${ok ? "PASS" : "FAIL"} ${nom} :: ${detail}`);
}

async function jfetch(url, opts) {
  const r = await fetch(url, opts);
  const t = await r.text();
  let j = null; try { j = JSON.parse(t); } catch {}
  return { status: r.status, json: j, text: t };
}

async function signIn(email, password) {
  const r = await jfetch(
    `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${FB_KEY}`,
    { method: "POST", headers: { "content-type": "application/json" },
      body: JSON.stringify({ email, password, returnSecureToken: true }) });
  return { ok: r.status === 200 && !!r.json?.idToken, token: r.json?.idToken || "", status: r.status };
}

const auth = (t) => ({ authorization: `Bearer ${t}`, "content-type": "application/json" });
const claim = (t, code, fingerprint) =>
  jfetch(`${API}/api/v1/me/referral/claim`,
    { method: "POST", headers: auth(t), body: JSON.stringify({ code, ...(fingerprint ? { fingerprint } : {}) }) });
const myReferral = (t) => jfetch(`${API}/api/v1/me/referral`, { headers: auth(t) });

// ---------- 1. Sessions des deux comptes de test ----------
const sA = await signIn(EMAIL_A, PASS_A);
const sB = await signIn(EMAIL_B, PASS_B);
rec("sessions_comptes_test", sA.ok && sB.ok,
    `comptes A et B signés (Firebase REST) — HTTP ${sA.status}/${sB.status}`);
if (!sA.ok || !sB.ok) { console.log("=== ABANDON (sessions) ==="); process.exit(1); }

// ---------- 2. Codes de parrainage : création, format, unicité ----------
let codeA = "", codeB = "";
{
  const rA = await myReferral(sA.token);
  const rB = await myReferral(sB.token);
  codeA = rA.json?.code || "";
  codeB = rB.json?.code || "";
  // Format réel (src/index.js) : MOT-NNN (ex. SHALOM-842) — 10 mots × 900.
  const RE_CODE = /^[A-Z]+-[0-9]{3}$/;
  const structureA = rA.status === 200 && typeof codeA === "string" && RE_CODE.test(codeA);
  const structureB = rB.status === 200 && typeof codeB === "string" && RE_CODE.test(codeB);
  rec("referral_code_cree", structureA && structureB,
      `GET /me/referral A→${rA.status}, B→${rB.status} ; codes au format attendu (valeurs non imprimées)`);
  rec("referral_code_unique", structureA && structureB && codeA !== codeB,
      `codes A et B distincts (unicité en base)`);
  rec("referral_payload_complet", !!(rA.json && typeof rA.json.converted === "number"
      && typeof rA.json.target === "number" && Array.isArray(rA.json.history)),
      `charge utile : code/converted/target/rewards/history présents (target=${rA.json?.target})`);
}

// ---------- 3. Anti-fraude ----------
{
  const self = await claim(sA.token, codeA, "");
  rec("anti_auto_parrainage", self.status === 404,
      `claim de son PROPRE code → HTTP ${self.status} (404 attendu : « code invalide »)`);
  const sansJwt = await jfetch(`${API}/api/v1/me/referral/claim`,
    { method: "POST", headers: { "content-type": "application/json" }, body: JSON.stringify({ code: codeB }) });
  rec("claim_sans_auth_refuse", sansJwt.status === 401,
      `claim sans jeton → HTTP ${sansJwt.status} (401 attendu)`);
  const sansJwtGet = await jfetch(`${API}/api/v1/me/referral`, { headers: {} });
  rec("referral_sans_auth_refuse", sansJwtGet.status === 401,
      `GET /me/referral sans jeton → HTTP ${sansJwtGet.status} (401 attendu)`);
  const codeInconnu = await claim(sA.token, "ZZZZZZ", "");
  rec("code_inconnu_refuse", codeInconnu.status === 404,
      `claim d'un code inexistant → HTTP ${codeInconnu.status} (404 attendu)`);
}

// ---------- 4. Parcours nominal A parraine-par B (comptes de test) ----------
{
  const avant = await myReferral(sB.token);
  const nAvant = (avant.json?.history || []).length;
  const c1 = await claim(sA.token, codeB, "");
  rec("claim_nominal", c1.status === 200 && c1.json?.ok === true,
      `A claim le code de B → HTTP ${c1.status}, ok=${c1.json?.ok}`);
  const apres = await myReferral(sB.token);
  const nApres = (apres.json?.history || []).length;
  const entree = (apres.json?.history || []).some(h => h.status === "pending");
  rec("attribution_parrain", nApres === nAvant + 1 && entree,
      `côté B : historique ${nAvant} → ${nApres} entrée(s), statut pending présent`);
  // anti-doublon : re-claim du même code → pas de 2e entrée
  const c2 = await claim(sA.token, codeB, "");
  const apres2 = await myReferral(sB.token);
  const nApres2 = (apres2.json?.history || []).length;
  rec("anti_doublon_reclaim", c2.status === 200 && nApres2 === nApres,
      `re-claim du même code → HTTP ${c2.status}, historique stable (${nApres2} = pas de doublon)`);
  // l'auto-parrainage de B reste interdit APRÈS le claim
  const selfB = await claim(sB.token, codeB, "");
  rec("anti_auto_parrainage_b", selfB.status === 404,
      `B claim son propre code → HTTP ${selfB.status} (404 attendu)`);
}

// ---------- 5. Isolation : le code de A reste lisible par A seul ----------
{
  const rA = await myReferral(sA.token);
  const rB = await myReferral(sB.token);
  rec("isolation_historiques",
      Array.isArray(rA.json?.history) && Array.isArray(rB.json?.history)
      && rA.json.code === codeA && rB.json.code === codeB,
      `chaque compte ne voit QUE son propre code/historique (A: ${rA.json?.history?.length} entrée(s), B: ${rB.json?.history?.length})`);
}

// ---------- Bilan ----------
rapport.termine = new Date().toISOString();
const controles = Object.values(rapport.controles);
const pass = controles.filter(c => c.ok).length;
rapport.bilan = { pass, total: controles.length };
writeFileSync("rapport-parrainage.json", JSON.stringify(rapport, null, 2));
console.log("=== QUALIFICATION PARRAINAGE TERMINÉE ===");
console.log(`${pass} PASS / ${controles.length - pass} FAIL`);
process.exit(pass === controles.length ? 0 : 1);
