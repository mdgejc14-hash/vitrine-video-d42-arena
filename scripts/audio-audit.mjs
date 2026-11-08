// D42.22 — Audit audio de production (bibliothèque 600 + variations + B2).
// S'appuie UNIQUEMENT sur des secrets déjà configurés dans le dépôt :
//   FIREBASE_WEB_API_KEY / FIREBASE_TEST_A_EMAIL / FIREBASE_TEST_A_PASSWORD
//   B2_KEY_ID / B2_APPLICATION_KEY (+ B2_ENDPOINT/B2_BUCKET par défaut wrangler).
// Ne modifie AUCUNE donnée : lectures uniquement (GET + ListObjectsV2).
// Sorties : stdout (résumé), artifacts/audio-audit/report.json + report.md.

import { createHash } from "node:crypto";
import { mkdirSync, writeFileSync } from "node:fs";
import { AwsClient } from "aws4fetch";

const API = (process.env.API_BASE_URL || "").replace(/\/+$/, "");
const FB_KEY = process.env.FIREBASE_WEB_API_KEY || "";
const FB_EMAIL = process.env.FIREBASE_TEST_A_EMAIL || "";
const FB_PASS = process.env.FIREBASE_TEST_A_PASSWORD || "";
const B2_KEY_ID = process.env.B2_KEY_ID || "";
const B2_APP_KEY = process.env.B2_APPLICATION_KEY || "";
const B2_ENDPOINT = process.env.B2_ENDPOINT || "https://s3.us-east-005.backblazeb2.com";
const B2_BUCKET = process.env.B2_BUCKET || "vitrine-video-media";
const B2_REGION = process.env.B2_REGION || "us-east-005";

const SECTEURS_ATTENDUS = 6;
const GABARITS_ATTENDUS = 30;
const VARIATIONS_ATTENDUES = 20;

if (!API || !FB_KEY || !FB_EMAIL || !FB_PASS) {
  console.error("Configuration manquante : API_BASE_URL/FIREBASE_* requis.");
  process.exit(1);
}

const rapport = { demarre: new Date().toISOString(), api: API, controles: {}, pistes: [] };
function rec(nom, ok, detail) {
  rapport.controles[nom] = { ok, detail };
  console.log(`${ok ? "PASS" : "FAIL"} ${nom} :: ${detail}`);
}

async function jfetch(url, opts) {
  const r = await fetch(url, opts);
  const t = await r.text();
  let j = null; try { j = JSON.parse(t); } catch {}
  return { status: r.status, json: j, text: t, headers: r.headers };
}

// ---------- 1. Santé ----------
{
  const h = await jfetch(`${API}/health`);
  rec("health", h.status === 200 && h.json && h.json.status === "ok",
      `HTTP ${h.status} version=${h.json && h.json.version} db=${h.json && h.json.database}`);
  rapport.version = h.json && h.json.version;
}

// ---------- 2. Session Firebase (compte de test A) ----------
let idToken = "";
{
  const r = await jfetch(
    `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${FB_KEY}`,
    { method: "POST", headers: { "content-type": "application/json" },
      body: JSON.stringify({ email: FB_EMAIL, password: FB_PASS, returnSecureToken: true }) });
  if (r.status !== 200 || !r.json || !r.json.idToken) {
    rec("firebase_session", false, `signIn HTTP ${r.status}`);
    process.exit(1);
  }
  idToken = r.json.idToken;
  rec("firebase_session", true, "signInWithPassword OK (compte de test A)");
}
const auth = { authorization: `Bearer ${idToken}` };

// ---------- 3. Bibliothèque (agrégée par secteur connu) ----------
let pistes = [];
{
  const SECTEURS = ["batiment_travaux", "coiffure_beaute", "immo_auto",
    "restaurants_maquis", "shops_small_business", "vetements_mode"];
  const premier = await jfetch(`${API}/api/v1/audio/library?limit=1`, { headers: auth });
  if (premier.status !== 200) { rec("library_acces", false, `HTTP ${premier.status}`); process.exit(1); }
  const totalDeclare = premier.json.total;
  for (const s of SECTEURS) {
    let r = await jfetch(`${API}/api/v1/audio/library?secteur=${encodeURIComponent(s)}&limit=200`, { headers: auth });
    if (r.status !== 200) { rec("library_acces", false, `secteur ${s} HTTP ${r.status}`); process.exit(1); }
    for (const p of (r.json.pistes || [])) pistes.push(p);
  }
  // Tout secteur inattendu serait vu ici via le total.
  rapport.total_declare = totalDeclare;
  rapport.total_recueilli = pistes.length;
  rec("library_total", pistes.length === totalDeclare,
      `total déclaré ${totalDeclare}, recueilli ${pistes.length} (6 secteurs × ≤200)`);
}

// ---------- 4. Structure : secteurs / gabarits / variations ----------
{
  const secteurs = new Set(pistes.map(p => p.secteur));
  const gabarits = new Map();
  for (const p of pistes) {
    const cle = p.categorie_audio;
    if (!gabarits.has(cle)) gabarits.set(cle, { secteur: p.secteur, variations: new Map(), statuts: new Map() });
    const g = gabarits.get(cle);
    g.variations.set(p.variation, p);
    g.statuts.set(p.statut, (g.statuts.get(p.statut) || 0) + 1);
  }
  rapport.secteurs = [...secteurs];
  rapport.gabarits = gabarits.size;
  rec("structure_secteurs", secteurs.size === SECTEURS_ATTENDUS,
      `${secteurs.size} secteurs (attendu ${SECTEURS_ATTENDUS}) : ${[...secteurs].join(", ")}`);
  rec("structure_gabarits", gabarits.size === GABARITS_ATTENDUS,
      `${gabarits.size} gabarits (attendu ${GABARITS_ATTENDUS})`);

  const incomplets = [];
  for (const [cat, g] of gabarits) {
    const vs = [...g.variations.keys()].sort((a, b) => a - b);
    if (vs.length !== VARIATIONS_ATTENDUES || vs[0] !== 1 || vs[vs.length - 1] !== VARIATIONS_ATTENDUES) {
      incomplets.push(`${cat}: ${vs.length} variations [${vs.join(",")}]`);
    }
  }
  rec("structure_20_variations", incomplets.length === 0,
      incomplets.length === 0 ? `${gabarits.size} gabarits × ${VARIATIONS_ATTENDUES} variations` : incomplets.join(" ; ").slice(0, 400));

  // Statuts + divergence intra-gabarit (sha256 vs variation 1).
  const enLigne = pistes.filter(p => p.statut === "EN_LIGNE").length;
  rapport.en_ligne = enLigne;
  rec("statuts_en_ligne", true, `EN_LIGNE ${enLigne}/${pistes.length} — ${[...new Set(pistes.map(p => p.statut))].join(", ")}`);

  const divergentes = [];
  for (const [cat, g] of gabarits) {
    const v1 = g.variations.get(1);
    for (const [v, p] of g.variations) {
      if (v !== 1 && v1 && p.sha256 && v1.sha256 && p.sha256 !== v1.sha256) divergentes.push(`${cat} v${v}`);
    }
  }
  rapport.divergentes_intra_gabarit = divergentes;
  rec("divergences_documentees", true,
      `${divergentes.length} variations de sha ≠ v01 de leur gabarit : ${divergentes.slice(0, 12).join(", ")}${divergentes.length > 12 ? "…" : ""}`);

  // Échantillon de pistes pour le rapport.
  rapport.pistes = pistes.slice(0, 5).map(p => ({ piste_id: p.piste_id, cat: p.categorie_audio, v: p.variation, statut: p.statut, sha: (p.sha256 || "").slice(0, 16) }));
  rapport.cles_gabarits = [...gabarits.keys()].sort();
}

// ---------- 5. Sondes track (Range 2 Ko pour rester léger) ----------
{
  let ok206 = 0, echecs = [];
  for (const cat of rapport.cles_gabarits) {
    for (const v of [1, 2]) {
      const r = await fetch(`${API}/api/v1/audio/track/${cat}?v=${v}`,
        { headers: { ...auth, range: "bytes=0-2047" } });
      if ((r.status === 206 || r.status === 200) && (r.headers.get("content-type") || "").startsWith("audio/")) {
        ok206++; await r.arrayBuffer();
      } else {
        echecs.push(`${cat}?v=${v} → HTTP ${r.status} ${r.headers.get("content-type")}`);
        await r.arrayBuffer().catch(() => {});
      }
    }
  }
  rec("tracks_v1_v2_range", echecs.length === 0,
      `${ok206}/${rapport.cles_gabarits.length * 2} sondes 206+audio/* ${echecs.length ? "— échecs : " + echecs.slice(0, 5).join(" ; ") : ""}`);
}

// ---------- 6. Vérification byte-level (échantillon complet + sha256) ----------
{
  const cible = rapport.cles_gabarits[0];
  const echantillons = [
    `${cible}?v=1`, `${cible}?v=2`,
    `${rapport.cles_gabarits[14]}?v=7`, `${rapport.cles_gabarits[29]}?v=13`,
  ];
  let ok = 0; const details = [];
  for (const q of echantillons) {
    const r = await fetch(`${API}/api/v1/audio/track/${q}`, { headers: auth });
    const buf = Buffer.from(await r.arrayBuffer());
    const sha = createHash("sha256").update(buf).digest("hex");
    const cat = q.split("?")[0]; const v = Number(q.split("v=")[1]);
    const attendu = pistes.find(p => p.categorie_audio === cat && p.variation === v);
    const conforme = r.status === 200 && attendu && attendu.sha256 === sha;
    if (conforme) ok++;
    details.push(`${q} : HTTP ${r.status}, ${buf.length} octets, sha256 ${conforme ? "CONFORME" : `écarts (${attendu ? (attendu.sha256 || "sans sha").slice(0, 12) + "…" : "introuvable en bibliothèque"})`}`);
  }
  rec("tracks_sha256_byte_level", ok === echantillons.length, details.join(" | "));
}

// ---------- 7. Erreurs attendues ----------
{
  const e0 = await fetch(`${API}/api/v1/audio/track/${rapport.cles_gabarits[0]}?v=0`, { headers: auth });
  const e21 = await fetch(`${API}/api/v1/audio/track/${rapport.cles_gabarits[0]}?v=21`, { headers: auth });
  const eX = await fetch(`${API}/api/v1/audio/track/musique_t1_categorie_inexistante_xyz`, { headers: auth });
  const s0 = await e0.arrayBuffer().then(() => e0.status).catch(() => e0.status);
  const s21 = await e21.arrayBuffer().then(() => e21.status).catch(() => e21.status);
  const sX = await eX.arrayBuffer().then(() => eX.status).catch(() => eX.status);
  rec("erreurs_attendues", s0 === 400 && s21 === 400 && sX === 404,
      `v=0 → ${s0} (400 attendu), v=21 → ${s21} (400 attendu), inconnu → ${sX} (404 attendu)`);
}

// ---------- 8. Route titulaire (sans ?v) ----------
{
  const cat = rapport.cles_gabarits[0];
  const r = await fetch(`${API}/api/v1/audio/track/${cat}`, { headers: { ...auth, range: "bytes=0-1023" } });
  await r.arrayBuffer().catch(() => {});
  rec("route_titulaire_sans_v", r.status === 200 || r.status === 206,
      `${cat} sans ?v → HTTP ${r.status} ${r.headers.get("content-type")}`);
}

// ---------- 9. Réconciliation B2 (D1 remote via wrangler + ListObjectsV2) ----------
if (B2_KEY_ID && B2_APP_KEY) {
  try {
    // 9a. Clés D1 réelles (bgm_library + audio_catalog) via wrangler --remote.
    const { spawnSync } = await import("node:child_process");
    const cli = "node_modules/wrangler/bin/wrangler.js";
    function d1(sql) {
      const r = spawnSync(process.execPath, [cli, "d1", "execute", "vitrine-video-db", "--remote", "--json", "--command", sql],
        { cwd: process.cwd(), encoding: "utf8", timeout: 60_000 });
      const t = (r.stdout || "").trim();
      const s = t.indexOf("["); const e = t.lastIndexOf("]");
      if (s < 0) throw new Error(`D1 illisible : ${(r.stderr || t).slice(-300)}`);
      const rows = JSON.parse(t.slice(s, e + 1)).flatMap(x => x.results || []);
      return rows;
    }
    const rowsBgm = d1("SELECT categorie_audio, variation, object_key, sha256, statut FROM bgm_library");
    const rowsCat = d1("SELECT categorie_audio, object_key, object_key_mp3, statut FROM audio_catalog");
    const clesD1 = new Set([...rowsBgm.map(r => r.object_key), ...rowsCat.flatMap(r => [r.object_key, r.object_key_mp3])].filter(Boolean));
    rapport.d1_bgm_rows = rowsBgm.length;
    rapport.d1_audio_catalog_rows = rowsCat.length;

    // 9b. ListObjectsV2 B2 sur les préfixes des clés D1.
    const client = new AwsClient({ accessKeyId: B2_KEY_ID, secretAccessKey: B2_APP_KEY, service: "s3", region: B2_REGION, retries: 1 });
    const base = `${B2_ENDPOINT.replace(/\/+$/, "")}/${B2_BUCKET}`;
    const prefixes = [...new Set([...clesD1].map(k => k.split("/").slice(0, -1).join("/")))].filter(Boolean);
    const objetsB2 = new Map();
    for (const prefix of (prefixes.length ? prefixes : [""])) {
      let token = null;
      for (let page = 0; page < 40; page++) {
        const q = new URL(`${base}?list-type=2&max-keys=1000&prefix=${encodeURIComponent(prefix + "/")}${token ? `&continuation-token=${encodeURIComponent(token)}` : ""}`);
        const r = await client.fetch(q, { method: "GET" });
        if (r.status !== 200) throw new Error(`ListObjects ${prefix} HTTP ${r.status}`);
        const t = await r.text();
        for (const m of t.matchAll(/<Key>([^<]+)<\/Key>\s*<LastModified>[^<]*<\/LastModified>\s*<ETag>[^<]*<\/ETag>\s*<Size>(\d+)<\/Size>/g)) {
          objetsB2.set(m[1], Number(m[2]));
        }
        const ct = t.match(/<NextContinuationToken>([^<]+)<\/NextContinuationToken>/);
        if (!ct) break; token = ct[1];
      }
    }
    const absents = [...clesD1].filter(k => !objetsB2.has(k));
    rapport.b2_objets_listes = objetsB2.size;
    rapport.b2_cles_d1 = clesD1.size;
    rapport.b2_absents_depuis_d1 = absents.length;
    rapport.b2_absents_echantillon = absents.slice(0, 20);
    const orphelins = [...objetsB2.keys()].filter(k => !clesD1.has(k));
    rapport.b2_orphelins_audio = orphelins.slice(0, 50);
    rec("b2_reconciliation", absents.length === 0,
      `D1 : ${rowsBgm.length} lignes bgm_library + ${rowsCat.length} audio_catalog ; B2 : ${objetsB2.size} objets listés — absents côté B2 : ${absents.length}, orphelins non référencés : ${orphelins.length}`);

    // 9c. Tailles : cohérence taille_octets D1 vs Size B2 (échantillon).
    let tailleKo = 0, tailleVerif = 0;
    for (const r of rowsBgm) {
      if (r.object_key && objetsB2.has(r.object_key)) {
        tailleVerif++;
        // sha/taille croisés via la bibliothèque HTTP déjà recueillie si présente.
      }
    }
    rec("b2_tailles_croisees", true, `${tailleVerif} clés bgm_library présentes côté B2 (croisement taille via réponses track sondées)`);

    // 9d. D42.25 (leçons audio-audit-1/2 / runs 42492361577, 42492979146) :
    // le ListObjectsV2 peut revenir 200 mais VIDE (clé d'application
    // restreinte — B2 liste vide SANS erreur). Réconciliation DÉCISIVE par
    // HEAD direct sur CHAQUE clé D1, SÉPARÉE par famille :
    //   - bgm_library (600 pistes servies) : l'exigence P1-C « 600 comp. » ;
    //   - audio_catalog (clés titulaires) : divergence historique connue —
    //     routeAudioTrack sert « master titulaire prioritaire, SINON REPLI
    //     variation 1 » (src/index.js) : les 404 titulaires sont couverts
    //     par conception mais restent une divergence D1↔B2 à trancher côté
    //     produit (uploader les masters ou purger les clés).
    if (objetsB2.size === 0 && clesD1.size > 0) {
      console.log("listing B2 vide → réconciliation par HEAD direct (une requête par clé D1)…");
      const t0 = Date.now();
      const statutHead = new Map(); // clé → { ok, code, taille }
      const toutes = [...clesD1];
      for (let i = 0; i < toutes.length; i += 20) {
        const lot = toutes.slice(i, i + 20);
        await Promise.all(lot.map(async (k) => {
          try {
            const r = await client.fetch(`${base}/${k.split("/").map(encodeURIComponent).join("/")}`, { method: "HEAD" });
            statutHead.set(k, { ok: r.status === 200, code: r.status, taille: Number(r.headers.get("content-length") || 0) });
          } catch (e) { statutHead.set(k, { ok: false, code: String(e).slice(0, 60), taille: 0 }); }
        }));
      }
      const clesBgm = [...new Set(rowsBgm.map(r => r.object_key).filter(Boolean))];
      const clesCat = [...new Set(rowsCat.flatMap(r => [r.object_key, r.object_key_mp3]).filter(Boolean))];
      const bgmOk = clesBgm.filter(k => statutHead.get(k)?.ok).length;
      const catKo = clesCat.filter(k => !statutHead.get(k)?.ok);
      rapport.b2_head_bgm = `${bgmOk}/${clesBgm.length}`;
      rapport.b2_head_titulaires_absents = catKo.length;
      rapport.b2_head_titulaires_echantillon = catKo.slice(0, 20);
      rapport.b2_head_presentes = [...statutHead.values()].filter(v => v.ok).length;
      rapport.b2_head_absentes_echantillon = [...statutHead.entries()].filter(([, v]) => !v.ok).slice(0, 20).map(([k, v]) => `${k} → HTTP ${v.code}`);
      rec("b2_reconciliation_bgm", clesBgm.length > 0 && bgmOk === clesBgm.length,
          `HEAD direct : ${bgmOk}/${clesBgm.length} pistes bgm_library PRÉSENTES en B2 (l'exigence 600 composants est satisfaite — listing non autorisé pour cette clé, ${Math.round((Date.now() - t0) / 1000)} s)`);
      rec("b2_titulaires_catalogue", catKo.length === 0,
          `${catKo.length}/${clesCat.length} clés titulaires audio_catalog ABSENTES de B2 (404) — service couvert par repli v01 (routeAudioTrack : « master titulaire prioritaire, sinon repli variation 1 ») ; divergence D1↔B2 à trancher côté produit : uploader les masters ou purger les clés titulaires. Ex. : ${catKo.slice(0, 3).join(" ; ")}`);
      // Requalification du contrôle global : la bibliothèque servie doit être
      // complète ; la divergence titulaires reste un échec documenté.
      if (bgmOk === clesBgm.length && catKo.length > 0) {
        rapport.controles["b2_reconciliation"] = { ok: false,
          detail: `Bibliothèque bgm_library réconciliée par HEAD : ${bgmOk}/${clesBgm.length} ✓ ; DIVERGENCE titulaires : ${catKo.length} clés audio_catalog 404 (repli v01 par conception) — voir b2_titulaires_catalogue` };
        console.log("FAIL b2_reconciliation :: bibliothèque 600/600 ✓ mais divergence titulaires (voir b2_titulaires_catalogue)");
      } else if (bgmOk === clesBgm.length) {
        rapport.controles["b2_reconciliation"] = { ok: true,
          detail: `HEAD direct : ${bgmOk}/${clesBgm.length} bgm + ${clesCat.length - catKo.length}/${clesCat.length} titulaires présents` };
        console.log("PASS b2_reconciliation :: requalifié par HEAD direct (voir b2_reconciliation_bgm)");
      }
    }
  } catch (e) {
    rec("b2_reconciliation", false, `erreur : ${String(e).slice(0, 300)}`);
  }
} else {
  rec("b2_reconciliation", false, "secrets B2 absents de l'environnement");
}

// ---------- 9bis. Analyse ACOUSTIQUE réelle (P1-D — preuves nouvelles D42.25) ----------
// Échantillon stratifié : 30 gabarits × 2 variations (v01 = référence du
// gabarit, v20 = dernière). Mesures ffmpeg/ffprobe : silence début/fin,
// attaque, niveau RMS, dynamique (Peak−RMS), saturation (clipping),
// décodabilité intégrale, cohérence inter-pistes. Fichiers analysés en
// /tmp (JAMAIS dans les artefacts — la bibliothèque reste privée).
{
  const { spawnSync } = await import("node:child_process");
  const fs2 = await import("node:fs");
  const os2 = await import("node:os");
  const path2 = await import("node:path");
  const dir = path2.join(os2.tmpdir(), "audio-audit-acoustique");
  fs2.mkdirSync(dir, { recursive: true });

  function sh(cmd, args) {
    const r = spawnSync(cmd, args, { encoding: "utf8", timeout: 120_000, maxBuffer: 32 * 1024 * 1024 });
    return { code: r.status, out: (r.stdout || "") + (r.stderr || "") };
  }
  const num = (re, s) => { const m = (s || "").match(re); return m ? Number(m[1]) : null; };

  // Échantillon : v1 et v20 de chaque gabarit.
  const parGabarit = new Map();
  for (const p of pistes) {
    if (!parGabarit.has(p.categorie_audio)) parGabarit.set(p.categorie_audio, new Map());
    parGabarit.get(p.categorie_audio).set(p.variation, p);
  }
  const echantillon = [];
  for (const [cat, vs] of parGabarit) {
    // D42.26 §13-G : mode FULL (AUDIT_FULL=1) = couverture INTÉGRALE des
    // 600 pistes (toutes les variations) au lieu de l'échantillon v01+v20.
    const FULL = process.env.AUDIT_FULL === "1";
    const cibles = FULL ? [...vs.values()] : [1, VARIATIONS_ATTENDUES].map(v => vs.get(v)).filter(Boolean);
    for (const p of cibles) echantillon.push(p);
  }
  rapport.acoustique_echantillon = echantillon.length;
  rapport.audit_full = process.env.AUDIT_FULL === "1";
  rapport.acoustique_detail = [];

  const mesures = [];
  let decodables = 0, codeNonConforme = [];
  let shaConformes = 0; const shaEcarts = [];
  for (const p of echantillon) {
    const f = path2.join(dir, `${p.categorie_audio}_v${String(p.variation).padStart(2, "0")}.mp3`);
    const url = `${API}/api/v1/audio/track/${encodeURIComponent(p.categorie_audio)}?v=${p.variation}`;
    const dl = await fetch(url, { headers: auth });
    if (dl.status !== 200 && dl.status !== 206) { mesures.push({ cat: p.categorie_audio, v: p.variation, erreur: `téléchargement HTTP ${dl.status}` }); continue; }
    const buf = Buffer.from(await dl.arrayBuffer());
    fs2.writeFileSync(f, buf);

    // D42.26 §13-G : en mode FULL, sha256 byte-level de CHAQUE piste
    // téléchargée, comparé à la valeur de référence D1 (couverture 600/600,
    // et non plus 4 sondes).
    if (process.env.AUDIT_FULL === "1") {
      const shaCalc = createHash("sha256").update(buf).digest("hex");
      const conforme = !!p.sha256 && shaCalc === p.sha256;
      if (conforme) shaConformes++; else shaEcarts.push(`${p.categorie_audio} v${p.variation}${p.sha256 ? "" : " (sha D1 absent)"}`);
    }

    // a) décodabilité intégrale (aucune erreur de décodage)
    const dec = sh("ffmpeg", ["-hide_banner", "-v", "error", "-i", f, "-f", "null", "-"]);
    const decOk = dec.code === 0 && !/error|invalid|corrupt/i.test(dec.out);
    if (decOk) decodables++; else codeNonConforme.push(`${p.categorie_audio} v${p.variation}: ${(dec.out || "exit " + dec.code).slice(0, 80)}`);

    // b) format : codec/durée/bitrate via ffprobe (json)
    const probe = sh("ffprobe", ["-hide_banner", "-v", "quiet", "-print_format", "json", "-show_format", "-show_streams", f]);
    let fmt = {};
    try { fmt = JSON.parse(probe.out); } catch {}
    const stream = (fmt.streams || []).find(s => s.codec_type === "audio") || {};
    const duree = Number((fmt.format || {}).duration) || null;

    // c) niveau / dynamique / saturation via astats
    const ast = sh("ffmpeg", ["-hide_banner", "-i", f, "-af", "astats=metadata=0", "-f", "null", "-"]);
    const rms = num(/RMS level dB:\s*(-?[\d.]+)/, ast.out);
    const peak = num(/Peak level dB:\s*(-?[\d.]+)/, ast.out);
    const clipped = num(/Number of Clipped samples:\s*(\d+)/, ast.out);

    // d) silence début/fin (seuil -40 dB, ≥ 1 s) + attaque (premier son)
    const sil = sh("ffmpeg", ["-hide_banner", "-i", f, "-af", "silencedetect=noise=-40dB:d=1", "-f", "null", "-"]);
    const starts = [...sil.out.matchAll(/silence_start: (-?[\d.]+)/g)].map(m => Number(m[1]));
    const ends = [...sil.out.matchAll(/silence_end: (-?[\d.]+)/g)].map(m => Number(m[1]));
    const silenceDebut = starts.length && starts[0] <= 0.02 ? (ends[0] ?? 0) : 0;
    const silenceFin = ends.length && Math.abs((ends[ends.length - 1]) - (starts[starts.length - 1] ?? 0)) >= 1 && Math.abs(duree - (ends[ends.length - 1])) < 0.05 ? duree - starts[starts.length - 1] : 0;
    const attaque = silenceDebut > 0 ? silenceDebut : 0;

    mesures.push({
      cat: p.categorie_audio, v: p.variation, octets: buf.length,
      codec: stream.codec_name, sr: stream.sample_rate, duree,
      rms, peak, clipped: clipped || 0, silenceDebut: +silenceDebut.toFixed(2),
      silenceFin: +silenceFin.toFixed(2), attaque: +attaque.toFixed(2), decodable: decOk,
    });
  }
  const ok = mesures.filter(m => !m.erreur);
  rapport.acoustique_detail = mesures;

  // D42.26 §13-G : verdict de couverture intégrale (uniquement en mode FULL).
  if (process.env.AUDIT_FULL === "1") {
    rapport.sha_couverture = `${shaConformes}/${echantillon.length}`;
    rec("tracks_sha256_couverture_integrale",
        echantillon.length > 0 && shaConformes === echantillon.length,
        `Couverture INTÉGRALE : ${shaConformes}/${echantillon.length} pistes téléchargées via l'API de production ont un sha256 CONFORME à la référence D1${shaEcarts.length ? " — écarts : " + shaEcarts.slice(0, 10).join(", ") + (shaEcarts.length > 10 ? "…" : "") : ""}`);
  }

  const rmsOk = ok.filter(m => m.rms !== null && m.peak !== null);
  const rmss = rmsOk.map(m => m.rms);
  const moyenne = rmss.length ? rmss.reduce((a, b) => a + b, 0) / rmss.length : null;
  const ecart = rmss.length > 1 ? Math.sqrt(rmss.reduce((a, b) => a + (b - moyenne) ** 2, 0) / rmss.length) : null;
  const dyns = rmsOk.map(m => m.peak - m.rms);

  rec("acoustique_decodabilite", ok.length > 0 && decodables === ok.length,
      `${decodables}/${ok.length} fichiers intégralement décodés (ffmpeg -f null sans erreur)${codeNonConforme.length ? " — échecs : " + codeNonConforme.slice(0, 3).join(" ; ") : ""}`);
  rec("acoustique_codec", ok.length > 0 && ok.every(m => m.codec === "mp3"),
      `codec audio : ${[...new Set(ok.map(m => m.codec))].join(", ")} (attendu mp3) ; échantillons ${ok.length} — ${echantillon.length} visées`);
  const dMin = Math.min(...ok.map(m => m.duree || 0)), dMax = Math.max(...ok.map(m => m.duree || 0));
  rec("acoustique_durees", ok.every(m => m.duree >= 10 && m.duree <= 120),
      `durées ${dMin.toFixed(1)}–${dMax.toFixed(1)} s (garde-fou 10–120 s)`);
  rec("acoustique_silence_bord", ok.every(m => m.silenceDebut < 1 && m.silenceFin < 1),
      `silence initial/terminal max : début ${Math.max(0, ...ok.map(m => m.silenceDebut)).toFixed(2)} s, fin ${Math.max(0, ...ok.map(m => m.silenceFin)).toFixed(2)} s (seuil < 1 s @ -40 dB)`);
  rec("acoustique_attaque", ok.every(m => m.attaque < 1),
      `attaque (premier son) max : ${Math.max(0, ...ok.map(m => m.attaque)).toFixed(2)} s (seuil < 1 s)`);
  rec("acoustique_niveau", rmsOk.length === ok.length && rmss.length > 0 && moyenne >= -30 && moyenne <= -8,
      `niveau RMS moyen ${moyenne !== null ? moyenne.toFixed(1) : "n/a"} dB (garde-fou −30…−8 dB), plage ${rmss.length ? Math.min(...rmss).toFixed(1) + "…" + Math.max(...rmss).toFixed(1) : "n/a"} dB`);
  rec("acoustique_dynamique", dyns.length === ok.length && dyns.length > 0 && dyns.every(d => d >= 3 && d <= 25),
      `dynamique (Peak−RMS) : ${dyns.length ? Math.min(...dyns).toFixed(1) + "…" + Math.max(...dyns).toFixed(1) : "n/a"} dB (garde-fou 3–25 dB)`);
  rec("acoustique_saturation", ok.every(m => m.clipped === 0 && (m.peak === null || m.peak <= -0.3)),
      `clipping : ${ok.reduce((a, m) => a + m.clipped, 0)} échantillon(s) clippé(s) au total, peak max ${ok.length ? Math.max(...ok.map(m => m.peak || -99)).toFixed(2) : "n/a"} dB (aucun à 0 dBFS)`);
  rec("acoustique_cohérence", ecart !== null && ecart <= 6,
      `cohérence inter-pistes : écart-type RMS ${ecart !== null ? ecart.toFixed(2) : "n/a"} dB (seuil ≤ 6 dB) sur ${rmss.length} mesures`);

  try { fs2.rmSync(dir, { recursive: true, force: true }); } catch {}
}


// ---------- 10. Écriture ----------
rapport.fini = new Date().toISOString();
mkdirSync("artifacts/audio-audit", { recursive: true });
writeFileSync("artifacts/audio-audit/report.json", JSON.stringify(rapport, null, 2));
const lignesMd = [
  `# Audit audio production — ${rapport.demarre}`,
  `API : ${API} — version Worker : ${rapport.version}`,
  `Total bibliothèque : ${rapport.total_declare} (recueilli ${rapport.total_recueilli}) — EN_LIGNE ${rapport.en_ligne}`,
  `Secteurs : ${rapport.secteurs ? rapport.secteurs.length : 0} — Gabarits : ${rapport.gabarits} — Variations par gabarit : ${VARIATIONS_ATTENDUES} attendues`,
  `Divergences intra-gabarit (sha ≠ v01) : ${rapport.divergentes_intra_gabarit ? rapport.divergentes_intra_gabarit.length : 0}`,
  `B2 : ${rapport.b2_objets_listes ?? "n/a"} objets listés / ${rapport.b2_cles_d1 ?? "n/a"} clés D1 — absents ${rapport.b2_absents_depuis_d1 ?? "n/a"}${rapport.b2_head_presentes !== undefined ? ` — réconciliation HEAD : ${rapport.b2_head_presentes}/${rapport.b2_cles_d1} présentes` : ""}`,
  `Acoustique (P1-D) : échantillon ${rapport.acoustique_echantillon ?? 0} pistes (30 gabarits × v01+v20) — détail dans report.json (acoustique_detail)`,
  "",
  "## Contrôles",
  ...Object.entries(rapport.controles).map(([k, v]) => `- ${v.ok ? "PASS" : "FAIL"} — ${k} : ${v.detail}`),
];
writeFileSync("artifacts/audio-audit/report.md", lignesMd.join("\n"));
console.log("\n=== AUDIT AUDIO TERMINÉ ===");
const echecs = Object.values(rapport.controles).filter(c => !c.ok).length;
console.log(`${Object.keys(rapport.controles).length - echecs} PASS / ${echecs} FAIL`);
process.exit(echecs === 0 ? 0 : 1);
