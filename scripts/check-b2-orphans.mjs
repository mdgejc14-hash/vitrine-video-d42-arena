import { randomUUID } from "node:crypto";
import { readFileSync } from "node:fs";
import path from "node:path";
import { spawnSync } from "node:child_process";
import { AwsClient } from "aws4fetch";

const ROOT = process.cwd();
const TEST_PREFIX = "u/__purge_executor_test__/";
const API_BASE_URL = (process.env.API_BASE_URL || "").replace(/\/+$/, "");
const TIMEOUT_MS = 30_000;

function fail(message) { throw new Error(message); }
function readVars(filePath) {
  const result = {};
  const content = readFileSync(filePath, "utf8");
  for (const line of content.split(/\r?\n/)) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) continue;
    const index = trimmed.indexOf("=");
    if (index < 1) continue;
    const name = trimmed.slice(0, index).trim();
    let value = trimmed.slice(index + 1).trim();
    if (value.length >= 2 && ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'")))) value = value.slice(1, -1);
    result[name] = value;
  }
  return result;
}
function wranglerD1Query(sql) {
  const cli = path.join(ROOT, "node_modules", "wrangler", "bin", "wrangler.js");
  const result = spawnSync(process.execPath, [cli, "d1", "execute", "vitrine-video-db", "--local", "--json", "--command", sql], {
    cwd: ROOT, encoding: "utf8", timeout: TIMEOUT_MS, windowsHide: true,
  });
  if (result.error || result.status !== 0) {
    const detail = [result.error?.message, result.stderr?.trim(), result.stdout?.trim()].filter(Boolean).join("\n").slice(-1200);
    fail(`Lecture D1 locale échouée${detail ? ` :\n${detail}` : "."}`);
  }
  const text = (result.stdout || "").trim();
  let parsed;
  try { parsed = JSON.parse(text); }
  catch {
    const start = text.indexOf("["); const end = text.lastIndexOf("]");
    if (start < 0 || end <= start) fail("Réponse JSON Wrangler non reconnue.");
    try { parsed = JSON.parse(text.slice(start, end + 1)); } catch { fail("Réponse JSON Wrangler invalide."); }
  }
  const results = Array.isArray(parsed) ? parsed : [parsed];
  if (results.some(entry => entry?.success === false)) fail("Wrangler signale un échec de requête D1 locale.");
  return results.flatMap(entry => Array.isArray(entry?.results) ? entry.results : []);
}
function makeClient(keyId, applicationKey, region) {
  return new AwsClient({ accessKeyId: keyId, secretAccessKey: applicationKey, service: "s3", region, retries: 0 });
}
function bucketBase(endpoint, bucket) {
  return `${endpoint.replace(/\/+$/, "")}/${encodeURIComponent(bucket)}`;
}
function objectUrl(endpoint, bucket, key) {
  return `${bucketBase(endpoint, bucket)}/${key.split("/").map(part => encodeURIComponent(part)).join("/")}`;
}
async function callWorkerAudit(baseUrl, token) {
  const response = await fetch(`${baseUrl}/api/v1/internal/storage/orphan-audit`, {
    method: "POST",
    headers: { authorization: `Bearer ${token}`, "content-type": "application/json" },
    body: "{}",
    signal: AbortSignal.timeout(60_000),
  });
  const body = await response.json().catch(() => ({}));
  if (!response.ok || !body?.data || body.data.inventory_complete !== true || body.data.audit_only !== true || body.data.deletion_performed !== false) {
    const code = typeof body?.data?.error_code === "string" ? body.data.error_code : (body?.error || `http_${response.status}`);
    fail(`L'audit B2/D1 du Worker n'a pas fourni un inventaire complet (${code}). Vérifie la clé B2 en lecture seule, le préfixe et le jeton local.`);
  }
  for (const field of ["scanned_objects", "matched_d1_files", "orphan_count", "pages_scanned"]) {
    if (!Number.isSafeInteger(body.data[field]) || body.data[field] < 0) fail(`Réponse d'audit invalide : ${field}.`);
  }
  if (body.data.prefix !== TEST_PREFIX) fail("L'audit Worker ne se limite pas au préfixe de test autorisé.");
  return body.data;
}
async function main() {
  const varsPath = path.join(ROOT, ".dev.vars");
  let vars;
  try { vars = readVars(varsPath); } catch { fail("Fichier .dev.vars absent ou illisible; aucun objet n'a été créé."); }
  const required = [
    "B2_ORPHAN_TEST_KEY_ID", "B2_ORPHAN_TEST_APPLICATION_KEY",
    "B2_AUDIT_KEY_ID", "B2_AUDIT_APPLICATION_KEY", "B2_ORPHAN_AUDIT_TOKEN",
    "B2_ORPHAN_AUDIT_PREFIX", "B2_BUCKET", "B2_ENDPOINT", "B2_REGION",
  ];
  for (const name of required) if (!vars[name]) fail(`Variable ${name} manquante dans .dev.vars; aucun objet n'a été créé.`);
  if (!API_BASE_URL || !/^http:\/\/127\.0\.0\.1:\d+$/.test(API_BASE_URL)) fail("API_BASE_URL doit pointer vers le Worker Wrangler local (127.0.0.1); aucun objet n'a été créé.");
  if (vars.B2_BUCKET !== "vitrine-video-media") fail("B2_BUCKET ne correspond pas au bucket attendu; aucun objet n'a été créé.");
  if (vars.B2_ORPHAN_AUDIT_PREFIX !== TEST_PREFIX) fail("B2_ORPHAN_AUDIT_PREFIX doit être exactement u/__purge_executor_test__/ pour ce test local.");
  const endpoint = new URL(vars.B2_ENDPOINT);
  if (endpoint.protocol !== "https:" || endpoint.hostname !== `s3.${vars.B2_REGION}.backblazeb2.com` || (endpoint.pathname !== "/" && endpoint.pathname !== "")) {
    fail("B2_ENDPOINT/B2_REGION ne correspondent pas à l'endpoint S3 B2 attendu.");
  }
  const writer = makeClient(vars.B2_ORPHAN_TEST_KEY_ID, vars.B2_ORPHAN_TEST_APPLICATION_KEY, vars.B2_REGION);
  const nonce = randomUUID();
  const objectKey = `${TEST_PREFIX}a5-orphan-audit/${nonce}/intentional-orphan.txt`;
  const sqlKey = objectKey.replace(/'/g, "''");
  const payload = Buffer.from(`A5_ORPHAN_AUDIT_PROBE:${nonce}\n`, "utf8");
  let uploadAttempted = false;
  let orphanDetected = false;
  let primaryError = null;
  let cleanupError = null;
  let baseline = null;
  try {
    if (wranglerD1Query(`SELECT id FROM files WHERE r2_key = '${sqlKey}' LIMIT 1;`).length) fail("La clé aléatoire apparaît déjà dans D1; arrêt préventif.");
    baseline = await callWorkerAudit(API_BASE_URL, vars.B2_ORPHAN_AUDIT_TOKEN);
    uploadAttempted = true;
    const put = await writer.fetch(objectUrl(vars.B2_ENDPOINT, vars.B2_BUCKET, objectKey), {
      method: "PUT", headers: { "content-type": "text/plain; charset=utf-8" }, body: payload,
      aws: { service: "s3", region: vars.B2_REGION },
    });
    if (!put.ok) fail(`Écriture du probe B2 refusée (HTTP ${put.status}).`);
    const after = await callWorkerAudit(API_BASE_URL, vars.B2_ORPHAN_AUDIT_TOKEN);
    const rows = wranglerD1Query(`SELECT id FROM files WHERE r2_key = '${sqlKey}' LIMIT 1;`);
    orphanDetected = rows.length === 0 && after.orphan_count === baseline.orphan_count + 1 && after.scanned_objects === baseline.scanned_objects + 1;
    if (!orphanDetected) fail("Le Worker n'a pas détecté précisément le probe comme un objet B2 sans ligne files dans D1.");
  } catch (error) { primaryError = error; }
  finally {
    if (uploadAttempted) {
      try {
        const deletion = await writer.fetch(objectUrl(vars.B2_ENDPOINT, vars.B2_BUCKET, objectKey), { method: "DELETE", aws: { service: "s3", region: vars.B2_REGION } });
        if (!deletion.ok && deletion.status !== 404) throw new Error(`Suppression du probe refusée (HTTP ${deletion.status}).`);
        const head = await writer.fetch(objectUrl(vars.B2_ENDPOINT, vars.B2_BUCKET, objectKey), { method: "HEAD", aws: { service: "s3", region: vars.B2_REGION } });
        if (head.status !== 404) throw new Error(`Vérification de suppression du probe non concluante (HTTP ${head.status}).`);
      } catch (error) { cleanupError = error; }
    }
  }
  if (primaryError) {
    console.error(`[FAIL] A5 B2/D1 Worker inventory E2E — ${primaryError.message}`);
    if (cleanupError) console.error(`[FAIL] Nettoyage du probe — ${cleanupError.message}`);
    process.exitCode = 1; return;
  }
  if (cleanupError) {
    console.error(`[FAIL] Nettoyage du probe — ${cleanupError.message}`);
    console.error("Le probe reste limité au préfixe de test; vérifie son absence avant de relancer.");
    process.exitCode = 1; return;
  }
  try {
    const afterCleanup = await callWorkerAudit(API_BASE_URL, vars.B2_ORPHAN_AUDIT_TOKEN);
    if (!baseline || afterCleanup.orphan_count !== baseline.orphan_count || afterCleanup.scanned_objects !== baseline.scanned_objects) fail("L'inventaire après nettoyage ne revient pas à l'état initial; vérifier le préfixe de test.");
  } catch (error) {
    console.error(`[FAIL] Vérification après nettoyage — ${error.message}`);
    process.exitCode = 1; return;
  }
  if (!orphanDetected) { console.error("[FAIL] A5 B2/D1 Worker inventory E2E — preuve de détection absente."); process.exitCode = 1; return; }
  process.stdout.write("[PASS] A5 B2/D1 Worker inventory E2E — route interne détecte le probe B2 absent de D1; inventaire complet; probe supprimé et état initial restauré.\n", () => process.exit(0));
}
main().catch(error => { console.error(`[FAIL] A5 B2/D1 Worker inventory E2E — ${error?.message || String(error)}`); process.exitCode = 1; });
