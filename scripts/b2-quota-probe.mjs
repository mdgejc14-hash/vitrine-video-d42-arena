// D42.26 — SONDE QUOTA B2 : distingue « quota Class B épuisé » (les pistes
// qui passaient échouent AUSSI maintenant, erreur track_not_uploaded) d'un
// défaut de données (variation_not_available sur les mêmes pistes qu'hier).
const API = (process.env.API_BASE_URL || "").replace(/\/+$/, "");
const FB_KEY = process.env.FIREBASE_WEB_API_KEY || "";
const EMAIL_A = process.env.FIREBASE_TEST_A_EMAIL || "";
const PASS_A = process.env.FIREBASE_TEST_A_PASSWORD || "";

if (!API || !FB_KEY || !EMAIL_A || !PASS_A) { console.error("config manquante"); process.exit(1); }

const r = await fetch(
  `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${FB_KEY}`,
  { method: "POST", headers: { "content-type": "application/json" },
    body: JSON.stringify({ email: EMAIL_A, password: PASS_A, returnSecureToken: true }) });
const tok = (await r.json())?.idToken;
if (!tok) { console.error("signIn échoué"); process.exit(1); }
const auth = { authorization: `Bearer ${tok}` };

// 3 pistes qui répondaient 200 au run FULL (17:46-18:00) + 3 qui faisaient 404.
const CIBLES = [
  ["musique_t1_batiment_travaux", 3, "OK-au-run-FULL"],
  ["musique_t2_coiffure_beaute", 5, "OK-au-run-FULL"],
  ["musique_t3_immo_auto", 9, "OK-au-run-FULL"],
  ["musique_t3_restaurants_maquis", 1, "404-au-run-FULL"],
  ["musique_t1_shops_small_business", 1, "404-au-run-FULL"],
  ["musique_t5_vetements_mode", 1, "404-au-run-FULL"],
];

let ok = 0;
for (const [cat, v, attendu] of CIBLES) {
  const res = await fetch(`${API}/api/v1/audio/track/${encodeURIComponent(cat)}?v=${v}`, { headers: auth });
  const corps = await res.text();
  const extrait = corps.slice(0, 120).replace(/\s+/g, " ");
  if (res.status === 200 || res.status === 206) ok++;
  console.log(`${res.status} | ${cat}?v=${v} (${attendu}) | ${extrait}`);
}
console.log(`=== SONDE : ${ok}/${CIBLES.length} pistes servies ===`);
console.log(ok === 0
  ? "VERDICT PROBABLE : quota B2 Class B quotidien ÉPUISÉ (même les pistes qui passaient refusent) — se réinitialise à 00:00 UTC."
  : ok === CIBLES.length
    ? "VERDICT : service rétabli (quota réinitialisé ou hypothèse fausse — les 404 d'hier étaient un autre phénomène)."
    : "VERDICT MIXTE : les anciennes OK passent, les anciennes 404 échouent → problème de DONNÉES sur ces pistes précises (à investiguer).");
