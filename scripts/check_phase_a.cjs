#!/usr/bin/env node
'use strict';

/*
 * Vitrine Vidéo — Phase A integrated test runner
 *
 * Safety boundaries:
 * - Uses Wrangler local mode only; never runs `wrangler deploy` or D1 `--remote`.
 * - Serves the test Worker on a dynamically chosen 127.0.0.1 port.
 * - The only B2 object it creates/deletes is under
 *   u/__purge_executor_test__/... and the runner refuses other prefixes.
 * - Uses a temporary Wrangler environment and .dev.vars.<env> file; the original
 *   .dev.vars and wrangler config are never edited.
 * - Does not print .dev.vars or credential values.
 *
 * Run from the repository root: node scripts/check_phase_a.cjs
 */

const fs = require('node:fs');
const path = require('node:path');
const net = require('node:net');
const { spawn, spawnSync } = require('node:child_process');
const { randomUUID, createHash, createHmac } = require('node:crypto');

const ROOT = process.cwd();
const DEV_VARS_PATH = path.join(ROOT, '.dev.vars');
const SOURCE_PATH = path.join(ROOT, 'src', 'index.js');
const UNIT_TEST_PATH = path.join(ROOT, 'tests', 'purge-executor-core.test.mjs');
const SECURITY_TEST_PATH = path.join(ROOT, 'scripts', 'security-ci.mjs');
const EXPECTED_USER_ID = '02a16300-0000-7000-8000-000000000001';
const EXPECTED_MERCHANT_ID = '02a16300-0000-7000-8000-000000000002';
const EXPECTED_PROJECT_ID = '02a16300-0000-7000-8000-000000000003';
const TEST_FIREBASE_UID = '__purge_executor_test__';
const TEST_TEMPLATE_ID = 'commerce-fr-v1';
const TEST_PREFIX = 'u/__purge_executor_test__/';
const RETENTION_ANCHOR = '2026-10-17T07:05:00.000Z';
const RETENTION_EXPIRES = '2026-10-20T07:05:00.000Z';
const TEST_PAYLOAD = 'A4 purge correction integration fixture only.\r\n';

const checks = [];
const warnings = [];
let originalDevVars = null;
let worker = null;
let testOrderId = null;
let testFileId = null;
let testEventId = null;
let testObjectKey = null;
let testOperationId = null;
let b2ObjectMayExist = false;
let a4Completed = false;
let apiTestIds = { merchantId: null, projectId: null, extraMerchantIds: [], extraProjectIds: [], orderIds: [], userId: null };
let effectiveVars = {};
let testBaseUrl = null;
let b2Client = null;
let b2Config = null;
let phaseConfigPath = null;
let phaseVarsPath = null;
let phaseEnvName = null;

function record(group, name, ok, detail = '') {
  checks.push({ group, name, ok: Boolean(ok), detail: String(detail || '') });
  const label = ok ? '[PASS]' : '[FAIL]';
  console.log(`${label} ${group} — ${name}${detail ? ` : ${detail}` : ''}`);
}

function failCheck(group, name, error) {
  record(group, name, false, error && error.message ? error.message : String(error || 'échec non précisé'));
}

function redact(text) {
  let out = String(text || '');
  const values = new Set([
    process.env.B2_APPLICATION_KEY,
    process.env.FIREBASE_WEB_API_KEY,
    process.env.FIREBASE_TEST_A_PASSWORD,
    process.env.FIREBASE_TEST_B_PASSWORD,
    process.env.ORDER_LIFECYCLE_SECRET,
    effectiveVars.B2_APPLICATION_KEY,
    effectiveVars.FIREBASE_WEB_API_KEY,
    effectiveVars.FIREBASE_TEST_A_PASSWORD,
    effectiveVars.FIREBASE_TEST_B_PASSWORD,
    effectiveVars.ORDER_LIFECYCLE_SECRET,
  ].filter(v => typeof v === 'string' && v.length >= 6));
  for (const secret of values) out = out.split(secret).join('[REDACTED]');
  return out;
}

function parseDotEnv(content) {
  const result = {};
  for (const line of String(content || '').split(/\r?\n/)) {
    const m = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*?)\s*$/);
    if (!m || m[1].startsWith('#')) continue;
    let value = m[2];
    if ((value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }
    result[m[1]] = value;
  }
  return result;
}

function getVar(name) {
  const fromProcess = process.env[name];
  if (typeof fromProcess === 'string' && fromProcess !== '') return fromProcess;
  const fromFile = effectiveVars[name];
  return typeof fromFile === 'string' && fromFile !== '' ? fromFile : '';
}

function replaceDevVar(content, name, value) {
  const lines = String(content || '').split(/\r?\n/);
  let seen = false;
  const next = [];
  for (const line of lines) {
    const m = line.match(/^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=/);
    if (m && m[1] === name) {
      if (!seen) next.push(`${name}=${value}`);
      seen = true;
    } else {
      next.push(line);
    }
  }
  if (!seen) next.push(`${name}=${value}`);
  return next.join('\n').replace(/\n+$/, '\n');
}

function parseJsonc(text) {
  try { return JSON.parse(text); } catch {}
  let cleaned = '';
  let inString = false;
  let escaped = false;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    const next = text[i + 1];
    if (inString) {
      cleaned += ch;
      if (escaped) escaped = false;
      else if (ch === '\\') escaped = true;
      else if (ch === '"') inString = false;
      continue;
    }
    if (ch === '"') { inString = true; cleaned += ch; continue; }
    if (ch === '/' && next === '/') {
      while (i < text.length && text[i] !== '\n') { cleaned += ' '; i++; }
      if (i < text.length) cleaned += '\n';
      continue;
    }
    if (ch === '/' && next === '*') {
      cleaned += '  '; i += 2;
      while (i < text.length && !(text[i] === '*' && text[i + 1] === '/')) {
        cleaned += text[i] === '\n' ? '\n' : ' '; i++;
      }
      if (i < text.length) { cleaned += '  '; i++; }
      continue;
    }
    cleaned += ch;
  }
  // JSONC allows trailing commas. This replacement affects only punctuation outside strings.
  let noTrailing = '';
  inString = false; escaped = false;
  for (let i = 0; i < cleaned.length; i++) {
    const ch = cleaned[i];
    if (inString) {
      noTrailing += ch;
      if (escaped) escaped = false;
      else if (ch === '\\') escaped = true;
      else if (ch === '"') inString = false;
      continue;
    }
    if (ch === '"') { inString = true; noTrailing += ch; continue; }
    if (ch === ',') {
      let j = i + 1;
      while (j < cleaned.length && /\s/.test(cleaned[j])) j++;
      if (cleaned[j] === '}' || cleaned[j] === ']') continue;
    }
    noTrailing += ch;
  }
  return JSON.parse(noTrailing);
}

function prepareAlternateWranglerConfig(configText) {
  const configCandidates = ['wrangler.jsonc', 'wrangler.json', 'wrangler.config.jsonc'];
  const configName = configCandidates.find(name => fs.existsSync(path.join(ROOT, name)));
  if (!configName) throw new Error('wrangler.jsonc/wrangler.json introuvable. Le runner ne modifiera pas le fichier de configuration existant.');
  const configFile = path.join(ROOT, configName);
  const config = parseJsonc(configText);
  if (!config || typeof config !== 'object' || !config.name || !config.main) {
    throw new Error('configuration Wrangler JSONC invalide ou champs name/main absents');
  }
  phaseEnvName = `phasea-runner-${process.pid}`;
  phaseConfigPath = path.join(ROOT, `wrangler.${phaseEnvName}.jsonc`);
  phaseVarsPath = path.join(ROOT, `.dev.vars.${phaseEnvName}`);

  // Wrangler environments do not inherit bindings automatically, so copy the
  // known top-level Worker bindings/config into a temporary local-only env.
  const environment = {};
  const keys = [
    'name', 'main', 'compatibility_date', 'compatibility_flags', 'node_compat',
    'd1_databases', 'r2_buckets', 'kv_namespaces', 'durable_objects', 'services',
    'queues', 'analytics_engine_datasets', 'hyperdrive', 'browser', 'ai', 'vectorize',
    'assets', 'workflows', 'dispatch_namespaces', 'send_email', 'mtls_certificates',
    'ratelimits', 'unsafe', 'limits', 'tail_consumers', 'rules', 'build', 'secrets',
    'pipelines', 'text_blobs', 'data_blobs', 'wasm_modules', 'python_modules',
    'workers_dev', 'routes', 'placement', 'observability', 'version_metadata',
  ];
  for (const key of keys) {
    if (config[key] !== undefined) environment[key] = config[key];
  }
  environment.name = `${config.name}-${phaseEnvName}`;
  const vars = { ...(config.vars || {}) };
  delete vars.PURGE_EXECUTION_ENABLED;
  delete vars.PURGE_EXECUTION_ACK;
  if (Object.keys(vars).length) environment.vars = vars;
  else delete environment.vars;

  config.env = { ...(config.env || {}), [phaseEnvName]: environment };
  fs.writeFileSync(phaseConfigPath, JSON.stringify(config, null, 2) + '\n', 'utf8');
  return { configFile, phaseConfigPath, phaseVarsPath, phaseEnvName };
}

function mapB2ToDedicatedTestCredentials(original) {
  const vars = parseDotEnv(original);
  const testKeyId = vars.B2_ORPHAN_TEST_KEY_ID;
  const testApplicationKey = vars.B2_ORPHAN_TEST_APPLICATION_KEY;
  if (!testKeyId || !testApplicationKey) {
    throw new Error('clé B2 dédiée au test absente; refus de démarrer le Worker de purge');
  }
  let out = replaceDevVar(original, 'B2_KEY_ID', testKeyId);
  out = replaceDevVar(out, 'B2_APPLICATION_KEY', testApplicationKey);
  return out;
}

function makeDryRunDevVars(original) {
  let out = mapB2ToDedicatedTestCredentials(original);
  out = replaceDevVar(out, 'PURGE_EXECUTION_ENABLED', 'false');
  out = out.split(/\r?\n/).filter(line => !/^\s*PURGE_EXECUTION_ACK\s*=/.test(line)).join('\n');
  return out.replace(/\n+$/, '\n');
}

function makeEnabledDevVars(original) {
  let out = mapB2ToDedicatedTestCredentials(original);
  out = replaceDevVar(out, 'PURGE_EXECUTION_ENABLED', 'true');
  out = replaceDevVar(out, 'PURGE_EXECUTION_ACK', 'EXECUTE_PURGE_V1_AFTER_APPROVAL');
  return out.replace(/\n+$/, '\n');
}

function winQuote(value) {
  const s = String(value);
  if (/^[A-Za-z0-9_./:=+-]+$/.test(s)) return s;
  return `"${s.replace(/"/g, '""')}"`;
}

function runProcess(executable, args, options = {}) {
  const opts = {
    cwd: options.cwd || ROOT,
    encoding: 'utf8',
    timeout: options.timeout || 120000,
    input: options.input,
    env: options.env || process.env,
    windowsHide: true,
    maxBuffer: 8 * 1024 * 1024,
  };
  let result;
  if (process.platform === 'win32' && /\.(cmd|bat)$/i.test(executable)) {
    const commandLine = [executable, ...args.map(winQuote)].join(' ');
    result = spawnSync(process.env.ComSpec || 'cmd.exe', ['/d', '/s', '/c', commandLine], opts);
  } else {
    result = spawnSync(executable, args, opts);
  }
  return {
    status: result.status,
    signal: result.signal,
    error: result.error,
    stdout: result.stdout || '',
    stderr: result.stderr || '',
    output: `${result.stdout || ''}\n${result.stderr || ''}`,
  };
}

function getWranglerEntrypoint() {
  const candidates = [
    path.join(ROOT, 'node_modules', 'wrangler', 'bin', 'wrangler.js'),
    path.join(ROOT, 'node_modules', 'wrangler', 'bin', 'wrangler.mjs'),
  ];
  return candidates.find(p => fs.existsSync(p)) || null;
}

function wranglerSync(args, timeout = 60000) {
  const entry = getWranglerEntrypoint();
  if (entry) return runProcess(process.execPath, [entry, ...args], { timeout });
  if (process.platform === 'win32') return runProcess('npx.cmd', ['wrangler', ...args], { timeout });
  return runProcess('npx', ['wrangler', ...args], { timeout });
}

function extractJson(text) {
  const s = String(text || '');
  for (let start = 0; start < s.length; start++) {
    if (s[start] !== '{' && s[start] !== '[') continue;
    const stack = [];
    let inString = false;
    let escaped = false;
    for (let i = start; i < s.length; i++) {
      const ch = s[i];
      if (inString) {
        if (escaped) escaped = false;
        else if (ch === '\\') escaped = true;
        else if (ch === '"') inString = false;
        continue;
      }
      if (ch === '"') { inString = true; continue; }
      if (ch === '{' || ch === '[') stack.push(ch);
      else if (ch === '}' || ch === ']') {
        const want = ch === '}' ? '{' : '[';
        if (stack.pop() !== want) break;
        if (stack.length === 0) {
          try { return JSON.parse(s.slice(start, i + 1)); } catch { break; }
        }
      }
    }
  }
  return null;
}

function findResultRows(value) {
  if (!value) return null;
  if (Array.isArray(value)) {
    for (const item of value) {
      const found = findResultRows(item);
      if (found) return found;
    }
    return null;
  }
  if (typeof value === 'object') {
    if (Array.isArray(value.results)) return value.results;
    if (Array.isArray(value.result)) return value.result;
    for (const item of Object.values(value)) {
      const found = findResultRows(item);
      if (found) return found;
    }
  }
  return null;
}

function d1Command(sql, label = 'D1 local', timeout = 60000) {
  if (/--remote|wrangler\s+deploy/i.test(sql)) throw new Error('Refus de commande distante ou de déploiement.');
  const result = wranglerSync(['d1', 'execute', 'vitrine-video-db', '--local', '--json', '--command', sql], timeout);
  const safeOutput = redact(result.output);
  if (result.error || result.status !== 0) {
    throw new Error(`${label} a échoué (code ${result.status ?? 'inconnu'}). ${safeOutput.slice(-1800)}`);
  }
  return { output: result.output, parsed: extractJson(result.output) };
}

function d1Rows(sql, label = 'Requête D1') {
  const result = d1Command(sql, label);
  const rows = findResultRows(result.parsed);
  if (!rows) throw new Error(`${label} : impossible de décoder la sortie JSON de Wrangler. ${redact(result.output).slice(-1000)}`);
  return rows;
}

function d1Exec(sql, label = 'Écriture D1') {
  return d1Command(sql, label);
}

function sqlQuote(value) {
  return `'${String(value).replace(/'/g, "''")}'`;
}

function prepareLocalD1SchemaAndFixtures() {
  const migrations = [
    '0001_init.sql',
    '0002_query_indexes.sql',
    '0003_purge_operation_ledger.sql',
  ];
  for (const migration of migrations) {
    const filePath = path.join(ROOT, 'db', 'migrations', migration);
    if (!fs.existsSync(filePath)) throw new Error(`migration locale absente: ${migration}`);
    const result = wranglerSync([
      'd1', 'execute', 'vitrine-video-db', '--local', '--file', filePath,
    ], 90000);
    if (result.error || result.status !== 0) {
      throw new Error(`migration D1 locale ${migration} échouée: ${redact(result.output).slice(-1200)}`);
    }
  }

  // Reserved synthetic identity. These rows are created only in Wrangler's
  // local D1 and are never written to the remote database.
  d1Exec(
    `INSERT OR IGNORE INTO users (id, firebase_uid, email, status, plan)
     VALUES (${sqlQuote(EXPECTED_USER_ID)}, ${sqlQuote(TEST_FIREBASE_UID)},
             'phase-a-test@invalid.example', 'actif', 'gratuit');`,
    'Création de l’utilisateur synthétique D1 locale'
  );
  d1Exec(
    `INSERT OR IGNORE INTO merchants (id, user_id, nom_commerce, secteur, ville, ton, public_cible)
     VALUES (${sqlQuote(EXPECTED_MERCHANT_ID)}, ${sqlQuote(EXPECTED_USER_ID)},
             'Phase A synthetic merchant', 'commerce', 'Test local', 'neutre', 'Tests automatisés');`,
    'Création du commerce synthétique D1 locale'
  );
  d1Exec(
    `INSERT OR IGNORE INTO projects (id, merchant_id, user_id, titre, langue, statut, brief_json)
     VALUES (${sqlQuote(EXPECTED_PROJECT_ID)}, ${sqlQuote(EXPECTED_MERCHANT_ID)},
             ${sqlQuote(EXPECTED_USER_ID)}, 'Phase A synthetic project', 'fr', 'brouillon', '{}');`,
    'Création du projet synthétique D1 locale'
  );
  d1Exec(
    `INSERT OR IGNORE INTO templates (id, secteur, langue, duree_cible_s, edl_json, regles_qc_json, version, actif)
     VALUES (${sqlQuote(TEST_TEMPLATE_ID)}, 'commerce', 'fr', 30, '{}', '{}', 1, 1);`,
    'Création du modèle synthétique D1 locale'
  );

  const user = d1Rows(
    `SELECT id FROM users WHERE id=${sqlQuote(EXPECTED_USER_ID)}
     AND firebase_uid=${sqlQuote(TEST_FIREBASE_UID)} LIMIT 1;`,
    'Vérification du compte synthétique D1 local'
  );
  const merchant = d1Rows(
    `SELECT id FROM merchants WHERE id=${sqlQuote(EXPECTED_MERCHANT_ID)}
     AND user_id=${sqlQuote(EXPECTED_USER_ID)} LIMIT 1;`,
    'Vérification du commerce synthétique D1 local'
  );
  const project = d1Rows(
    `SELECT id FROM projects WHERE id=${sqlQuote(EXPECTED_PROJECT_ID)}
     AND merchant_id=${sqlQuote(EXPECTED_MERCHANT_ID)}
     AND user_id=${sqlQuote(EXPECTED_USER_ID)} LIMIT 1;`,
    'Vérification du projet synthétique D1 local'
  );
  const template = d1Rows(
    `SELECT id FROM templates WHERE id=${sqlQuote(TEST_TEMPLATE_ID)}
     AND secteur='commerce' AND langue='fr' AND actif=1 LIMIT 1;`,
    'Vérification du modèle synthétique D1 local'
  );
  if (user.length !== 1 || merchant.length !== 1 || project.length !== 1 || template.length !== 1) {
    throw new Error('la fixture synthétique D1 existe déjà sous une forme différente; aucune purge B2 ne sera tentée');
  }
}

function runNodeTest(file) {
  const result = runProcess(process.execPath, ['--test', file], { timeout: 120000 });
  return { ...result, output: redact(result.output) };
}

function sleep(ms) { return new Promise(resolve => setTimeout(resolve, ms)); }

async function chooseFreePort() {
  return await new Promise((resolve, reject) => {
    const server = net.createServer();
    server.once('error', reject);
    server.listen(0, '127.0.0.1', () => {
      const addr = server.address();
      server.close(err => err ? reject(err) : resolve(addr.port));
    });
  });
}

function startWorker(port, configPath = phaseConfigPath, envName = phaseEnvName) {
  const entry = getWranglerEntrypoint();
  if (!entry) throw new Error('Wrangler local introuvable dans node_modules/wrangler. Installe les dépendances du projet puis relance.');
  const childEnv = { ...process.env };
  delete childEnv.PURGE_EXECUTION_ENABLED;
  delete childEnv.PURGE_EXECUTION_ACK;
  const child = spawn(process.execPath, [
    entry, 'dev', '--config', path.basename(configPath), '--env', envName,
    '--local', '--test-scheduled', '--ip', '127.0.0.1',
    '--port', String(port), '--show-interactive-dev-session=false',
  ], { cwd: ROOT, env: childEnv, stdio: ['ignore', 'pipe', 'pipe'], windowsHide: true });
  const state = { child, port, baseUrl: `http://127.0.0.1:${port}`, logs: '', exited: false, exitCode: null };
  const append = chunk => {
    state.logs += chunk.toString();
    if (state.logs.length > 4 * 1024 * 1024) state.logs = state.logs.slice(-4 * 1024 * 1024);
  };
  child.stdout.on('data', append);
  child.stderr.on('data', append);
  child.once('exit', (code) => { state.exited = true; state.exitCode = code; });
  return state;
}

async function stopWorker(state) {
  if (!state || !state.child || state.exited) return;
  try { state.child.kill('SIGTERM'); } catch {}
  if (process.platform === 'win32' && state.child.pid) {
    // Stop only the process tree spawned by this runner (never a pre-existing Worker).
    runProcess('taskkill', ['/PID', String(state.child.pid), '/T', '/F'], { timeout: 10000 });
  }
  await Promise.race([
    new Promise(resolve => state.child.once('exit', resolve)),
    sleep(8000),
  ]);
  worker = null;
}

async function waitForHealth(state, timeoutMs = 45000) {
  const until = Date.now() + timeoutMs;
  let lastError = 'pas encore de réponse';
  while (Date.now() < until) {
    if (state.exited) throw new Error(`Wrangler s'est arrêté (code ${state.exitCode}). ${redact(state.logs).slice(-1800)}`);
    try {
      const response = await fetch(`${state.baseUrl}/health`, { signal: AbortSignal.timeout(2500) });
      const data = await response.json().catch(() => ({}));
      if (response.ok && data.status === 'ok' && data.database === 'connected' && data.schema === 'ready' && data.applicationTables === 8) {
        return data;
      }
      lastError = `HTTP ${response.status}; état ${JSON.stringify({ status: data.status, database: data.database, schema: data.schema })}`;
    } catch (error) {
      lastError = error.message;
    }
    await sleep(500);
  }
  throw new Error(`Le Worker local n'est pas prêt: ${lastError}. ${redact(state.logs).slice(-1800)}`);
}

async function apiRequest(baseUrl, route, options = {}) {
  const headers = new Headers(options.headers || {});
  if (options.token) headers.set('Authorization', `Bearer ${options.token}`);
  let body;
  if (options.rawBody !== undefined) {
    if (!headers.has('Content-Type')) headers.set('Content-Type', 'application/json; charset=utf-8');
    body = options.rawBody;
  } else if (options.body !== undefined) {
    headers.set('Content-Type', 'application/json; charset=utf-8');
    body = JSON.stringify(options.body);
  }
  const response = await fetch(`${baseUrl}${route}`, {
    method: options.method || 'GET', headers, body,
    signal: AbortSignal.timeout(options.timeout || 20000),
  });
  const text = await response.text();
  let data = {};
  try { data = text ? JSON.parse(text) : {}; } catch { data = { invalid_json: true }; }
  return { status: response.status, data, raw: text };
}

async function signInFirebase(label) {
  const apiKey = getVar('FIREBASE_WEB_API_KEY');
  const email = getVar(`FIREBASE_TEST_${label}_EMAIL`);
  const password = getVar(`FIREBASE_TEST_${label}_PASSWORD`);
  if (!apiKey || !email || !password) throw new Error(`identifiants Firebase de test ${label} absents de l'environnement/.dev.vars`);
  const url = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${encodeURIComponent(apiKey)}`;
  const response = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password, returnSecureToken: true }),
    signal: AbortSignal.timeout(20000),
  });
  const data = await response.json().catch(() => ({}));
  if (!response.ok || !data.idToken || !data.localId) {
    throw new Error(`authentification Firebase du compte ${label} impossible (HTTP ${response.status}); valeur secrète masquée`);
  }
  return { token: data.idToken, uid: data.localId };
}

async function ensureBootstrap(baseUrl, account, label) {
  const result = await apiRequest(baseUrl, '/api/v1/me/bootstrap', { method: 'POST', token: account.token });
  if (result.status !== 200 || result.data.profile?.status !== 'actif') {
    throw new Error(`bootstrap du compte test ${label} a échoué (HTTP ${result.status}, ${result.data.error || 'contrat inattendu'})`);
  }
}

async function createApiWorkspace(baseUrl, account, label) {
  const suffix = randomUUID().slice(0, 8);
  const merchant = await apiRequest(baseUrl, '/api/v1/merchants', {
    method: 'POST', token: account.token,
    body: {
      nom_commerce: `Phase A ${label} ${suffix}`,
      secteur: 'commerce', ville: 'Test local Phase A', ton: 'neutre',
      public_cible: 'Tests d’intégration locaux',
    },
  });
  if (merchant.status !== 201 || !merchant.data.data?.id) {
    throw new Error(`création du commerce de test impossible (HTTP ${merchant.status}, ${merchant.data.error || 'contrat inattendu'})`);
  }
  apiTestIds.merchantId = merchant.data.data.id;
  const project = await apiRequest(baseUrl, '/api/v1/projects', {
    method: 'POST', token: account.token,
    body: {
      merchant_id: merchant.data.data.id,
      titre: `Phase A project ${suffix}`,
      langue: 'fr',
      brief: { produit_service: 'Fixture automatisée', description: 'Donnée de test locale uniquement' },
    },
  });
  if (project.status !== 201 || !project.data.data?.id) {
    throw new Error(`création du projet de test impossible (HTTP ${project.status}, ${project.data.error || 'contrat inattendu'})`);
  }
  apiTestIds.projectId = project.data.data.id;
  apiTestIds.userId = null;
  return { merchantId: merchant.data.data.id, projectId: project.data.data.id };
}

async function createApiOrder(baseUrl, account, projectId, label) {
  const idempotencyKey = `phase-a-${label}-${randomUUID()}`;
  const result = await apiRequest(baseUrl, '/api/v1/orders', {
    method: 'POST', token: account.token,
    body: { project_id: projectId, template_id: TEST_TEMPLATE_ID, idempotency_key: idempotencyKey },
  });
  if (result.status !== 201 || !result.data.data?.id) {
    throw new Error(`création de la commande de test impossible (HTTP ${result.status}, ${result.data.error || 'contrat inattendu'})`);
  }
  apiTestIds.orderIds.push(result.data.data.id);
  return result.data.data;
}

async function testSignedLifecycleCallback(baseUrl, account, workspace) {
  const secret = getVar('ORDER_LIFECYCLE_SECRET');
  if (!secret || secret.length < 32) throw new Error('ORDER_LIFECYCLE_SECRET absent ou trop court; test HMAC impossible');
  const order = await createApiOrder(baseUrl, account, workspace.projectId, 'signed-callback');
  const eventId = randomUUID();
  const body = JSON.stringify({ order_id: order.id, expected_status: 'brouillon', new_status: 'echec', event_id: eventId });
  const timestamp = String(Math.floor(Date.now() / 1000));
  const signature = createHmac('sha256', secret).update(`${timestamp}.${body}`).digest('hex');
  const route = '/api/v1/internal/orders/status';
  const bad = await apiRequest(baseUrl, route, {
    method: 'POST', rawBody: body,
    headers: { 'x-lifecycle-timestamp': timestamp, 'x-lifecycle-signature': '0'.repeat(64), 'Content-Type': 'application/json' },
  });
  if (bad.status !== 401 || bad.data.error !== 'invalid_lifecycle_signature') {
    throw new Error(`signature HMAC invalide non rejetée comme prévu (HTTP ${bad.status}, ${bad.data.error || 'erreur absente'})`);
  }
  const valid = await apiRequest(baseUrl, route, {
    method: 'POST', rawBody: body,
    headers: { 'x-lifecycle-timestamp': timestamp, 'x-lifecycle-signature': signature, 'Content-Type': 'application/json' },
  });
  if (valid.status !== 200 || valid.data.accepted !== true || valid.data.data?.status !== 'echec') {
    throw new Error(`signature HMAC valide refusée (HTTP ${valid.status}, ${valid.data.error || 'contrat inattendu'})`);
  }
  const replay = await apiRequest(baseUrl, route, {
    method: 'POST', rawBody: body,
    headers: { 'x-lifecycle-timestamp': timestamp, 'x-lifecycle-signature': signature, 'Content-Type': 'application/json' },
  });
  if (replay.status !== 200 || replay.data.duplicate !== true) {
    throw new Error(`le callback signé rejoué n'est pas idempotent (HTTP ${replay.status})`);
  }
  return order.id;
}

async function testSignedUrlExpiry(baseUrl, account, workspace) {
  const order = await createApiOrder(baseUrl, account, workspace.projectId, 'signed-url-ttl');
  const signed = await apiRequest(baseUrl, `/api/v1/orders/${order.id}/uploads/sign`, {
    method: 'POST', token: account.token,
    body: { role: 'audio', content_type: 'audio/webm', sha256: 'a'.repeat(64), size_bytes: 1024 },
  });
  if (signed.status !== 201 || !signed.data.data?.upload_url) {
    throw new Error(`signature d'upload impossible (HTTP ${signed.status}, ${signed.data.error || 'contrat inattendu'})`);
  }
  const d = signed.data.data;
  const url = new URL(d.upload_url);
  const expires = url.searchParams.get('X-Amz-Expires');
  const signature = url.searchParams.get('X-Amz-Signature');
  const deltaMs = Date.parse(d.expires_at) - Date.now();
  if (Number(d.expires_in) !== 600 || expires !== '600' || !signature || !Number.isFinite(deltaMs) || deltaMs < 540000 || deltaMs > 660000) {
    throw new Error(`contrat d'expiration invalide (expires_in=${d.expires_in}, query=${expires}, delta_ms=${Number.isFinite(deltaMs) ? Math.round(deltaMs) : 'invalide'})`);
  }
  const rows = d1Rows(`SELECT COUNT(*) AS n FROM quota_events WHERE ordre_id=${sqlQuote(order.id)} AND type='commande_creee';`, 'Vérification quota commande signée');
  if (Number(rows[0]?.n) !== 1) throw new Error(`événement de quota commande attendu une fois, obtenu ${rows[0]?.n ?? 'illisible'}`);
  // The full signed URL is deliberately not printed or persisted by this runner.
  return order.id;
}

async function loadAwsClient() {
  try {
    const mod = await import('aws4fetch');
    return mod.AwsClient;
  } catch (error) {
    throw new Error(`dépendance aws4fetch non disponible dans le projet (${error.message})`);
  }
}

async function configureB2() {
  const required = [
    'B2_KEY_ID', 'B2_APPLICATION_KEY',
    'B2_ORPHAN_TEST_KEY_ID', 'B2_ORPHAN_TEST_APPLICATION_KEY',
    'B2_AUDIT_KEY_ID', 'B2_AUDIT_APPLICATION_KEY',
    'B2_ORPHAN_AUDIT_TOKEN', 'B2_ORPHAN_AUDIT_PREFIX',
    'B2_BUCKET', 'B2_ENDPOINT', 'B2_REGION',
  ];
  const missing = required.filter(k => !getVar(k));
  if (missing.length) throw new Error(`configuration B2 de test manquante dans .dev.vars: ${missing.join(', ')}`);

  const normalKeyId = getVar('B2_KEY_ID');
  const testKeyId = getVar('B2_ORPHAN_TEST_KEY_ID');
  const auditKeyId = getVar('B2_AUDIT_KEY_ID');
  const normalApplicationKey = getVar('B2_APPLICATION_KEY');
  const testApplicationKey = getVar('B2_ORPHAN_TEST_APPLICATION_KEY');
  const auditApplicationKey = getVar('B2_AUDIT_APPLICATION_KEY');
  if (new Set([normalKeyId, testKeyId, auditKeyId]).size !== 3 ||
      new Set([normalApplicationKey, testApplicationKey, auditApplicationKey]).size !== 3) {
    throw new Error('les clés B2 normale, de test et d’audit doivent être distinctes; aucun objet n’a été créé');
  }
  if (getVar('B2_ORPHAN_AUDIT_PREFIX') !== TEST_PREFIX ||
      getVar('B2_ORPHAN_AUDIT_TOKEN').length < 32) {
    throw new Error('préfixe ou jeton d’audit B2 de test invalide; aucun objet n’a été créé');
  }

  const endpoint = new URL(getVar('B2_ENDPOINT'));
  const region = getVar('B2_REGION');
  if (endpoint.protocol !== 'https:' || endpoint.hostname !== `s3.${region}.backblazeb2.com` || (endpoint.pathname !== '/' && endpoint.pathname !== '')) {
    throw new Error('endpoint B2 invalide; aucun appel de stockage effectué');
  }
  if (getVar('B2_BUCKET') !== 'vitrine-video-media') {
    throw new Error('bucket différent de vitrine-video-media; garde de sécurité A4 refusée');
  }
  const AwsClient = await loadAwsClient();
  b2Client = new AwsClient({
    accessKeyId: testKeyId,
    secretAccessKey: testApplicationKey,
    service: 's3', region, retries: 0,
  });
  b2Config = { endpoint: endpoint.origin, bucket: getVar('B2_BUCKET'), region };
}

function b2Url(objectKey) {
  if (!objectKey.startsWith(TEST_PREFIX)) throw new Error('Garde B2: clé hors du préfixe synthétique autorisé.');
  const encodedKey = objectKey.split('/').map(segment => encodeURIComponent(segment)).join('/');
  return `${b2Config.endpoint}/${encodeURIComponent(b2Config.bucket)}/${encodedKey}`;
}

async function b2Request(method, objectKey, payload) {
  const url = b2Url(objectKey);
  const init = { method, aws: { service: 's3', region: b2Config.region } };
  if (payload !== undefined) {
    init.headers = { 'content-type': 'text/plain', 'x-amz-meta-sha256': createHash('sha256').update(payload).digest('hex') };
    init.body = payload;
  }
  const response = await b2Client.fetch(url, init);
  try { if (response.body) await response.body.cancel(); } catch {}
  return response.status;
}

async function createPurgeFixture() {
  const check = d1Rows(
    `SELECT u.id AS user_id, u.firebase_uid, p.id AS project_id FROM users u JOIN projects p ON p.user_id=u.id WHERE u.id=${sqlQuote(EXPECTED_USER_ID)} AND p.id=${sqlQuote(EXPECTED_PROJECT_ID)} AND u.firebase_uid=${sqlQuote(TEST_FIREBASE_UID)} LIMIT 1;`,
    'Vérification du compte/projet synthétiques de purge'
  );
  if (check.length !== 1) {
    throw new Error('pré-requis D1 absent ou incohérent: utilisateur/projet __purge_executor_test__. Le runner ne crée pas de comptes applicatifs supplémentaires automatiquement.');
  }
  const template = d1Rows(`SELECT id FROM templates WHERE id=${sqlQuote(TEST_TEMPLATE_ID)} AND actif=1 LIMIT 1;`, 'Vérification du modèle de purge');
  if (template.length !== 1) throw new Error(`modèle actif ${TEST_TEMPLATE_ID} absent en D1 locale`);

  testOrderId = randomUUID().toLowerCase();
  testFileId = randomUUID().toLowerCase();
  testEventId = randomUUID().toLowerCase();
  const bytes = Buffer.from(TEST_PAYLOAD, 'utf8');
  const hash = createHash('sha256').update(bytes).digest('hex');
  const expires = RETENTION_EXPIRES;
  testObjectKey = `${TEST_PREFIX}${EXPECTED_PROJECT_ID}/${testOrderId}/purge-phase-a-e2e.srt`;
  if (!testObjectKey.startsWith(TEST_PREFIX)) throw new Error('Garde de préfixe B2 violée.');

  d1Exec(`INSERT INTO orders (id, project_id, user_id, template_id, statut, created_at, updated_at, idempotency_key) VALUES (${sqlQuote(testOrderId)}, ${sqlQuote(EXPECTED_PROJECT_ID)}, ${sqlQuote(EXPECTED_USER_ID)}, ${sqlQuote(TEST_TEMPLATE_ID)}, 'echec', ${sqlQuote(RETENTION_ANCHOR)}, ${sqlQuote(RETENTION_ANCHOR)}, ${sqlQuote(`phase-a-e2e-${testOrderId}`)});`, 'Insertion D1 de la commande synthétique');
  d1Exec(`INSERT INTO quota_events (id, user_id, ordre_id, type, avant, apres, mois, created_at) VALUES (${sqlQuote(testEventId)}, ${sqlQuote(EXPECTED_USER_ID)}, ${sqlQuote(testOrderId)}, 'statut_change', 'brouillon', 'echec', '2026-10', ${sqlQuote(RETENTION_ANCHOR)});`, 'Insertion D1 de l’événement de statut synthétique');
  d1Exec(`INSERT INTO files (id, order_id, r2_key, role, taille_octets, empreinte, uploaded_at, purge_at) VALUES (${sqlQuote(testFileId)}, ${sqlQuote(testOrderId)}, ${sqlQuote(testObjectKey)}, 'srt', ${bytes.length}, ${sqlQuote(hash)}, ${sqlQuote(RETENTION_ANCHOR)}, ${sqlQuote(expires)});`, 'Insertion D1 du fichier synthétique');

  b2ObjectMayExist = true; // keep cleanup armed if a network error makes PUT outcome ambiguous
  const putStatus = await b2Request('PUT', testObjectKey, bytes);
  b2ObjectMayExist = putStatus >= 200 && putStatus < 300;
  if (!b2ObjectMayExist) {
    if (putStatus >= 400 && putStatus < 500) b2ObjectMayExist = false;
    throw new Error(`création de l'objet B2 synthétique refusée (HTTP ${putStatus}); vérifie le droit de la clé de test sur ${TEST_PREFIX}`);
  }
  const headStatus = await b2Request('HEAD', testObjectKey);
  if (headStatus !== 200) throw new Error(`HEAD pré-purge attendu 200, obtenu HTTP ${headStatus}`);

  const seeded = d1Rows(`SELECT CASE WHEN EXISTS (SELECT 1 FROM orders WHERE id=${sqlQuote(testOrderId)} AND statut='echec') AND EXISTS (SELECT 1 FROM files WHERE id=${sqlQuote(testFileId)} AND order_id=${sqlQuote(testOrderId)}) AND EXISTS (SELECT 1 FROM quota_events WHERE id=${sqlQuote(testEventId)} AND ordre_id=${sqlQuote(testOrderId)}) THEN 'FIXTURE_READY' ELSE 'FIXTURE_INVALID' END AS result;`, 'Vérification du scénario D1 synthétique');
  if (seeded[0]?.result !== 'FIXTURE_READY') throw new Error('le scénario synthétique D1 ne satisfait pas les préconditions de purge');
  testOperationId = `purge-v1:order:${testOrderId}:terminal_72h:${expires}`;
  return { bytes, hash, operationId: testOperationId };
}

async function triggerScheduled(baseUrl) {
  const response = await fetch(`${baseUrl}/cdn-cgi/local/scheduled?format=json`, {
    method: 'GET', signal: AbortSignal.timeout(90000),
  });
  const body = await response.text();
  if (!response.ok) throw new Error(`déclenchement local du scheduled handler: HTTP ${response.status}; ${redact(body).slice(0, 800)}`);
  return { status: response.status, body };
}

function parseExecutionLogs(logs) {
  const matches = [...String(logs || '').matchAll(/\[vitrine-video-purge-execution\]\s*(\{[^\r\n]*\})/g)];
  const parsed = [];
  for (const m of matches) {
    try { parsed.push(JSON.parse(m[1])); } catch {}
  }
  return parsed;
}

async function verifyDryRun(fixture) {
  const run = d1Rows(`SELECT CASE WHEN status='completed' AND inventory_complete=1 AND json_extract(report_summary_json, '$.report_summary.objects_deleted')=0 AND json_extract(report_summary_json, '$.report_summary.database_rows_deleted')=0 THEN 'DRY_RUN_OK' ELSE 'DRY_RUN_FAIL' END AS result FROM purge_audit_runs ORDER BY started_at DESC LIMIT 1;`, 'Assertion du rapport de rétention à blanc');
  if (run[0]?.result !== 'DRY_RUN_OK') throw new Error(`rapport de dry-run incomplet ou potentiellement destructif (${run[0]?.result || 'aucune ligne'})`);
  const rows = d1Rows(`SELECT CASE WHEN EXISTS (SELECT 1 FROM orders WHERE id=${sqlQuote(testOrderId)}) AND EXISTS (SELECT 1 FROM files WHERE id=${sqlQuote(testFileId)}) THEN 'FIXTURE_PRESERVED' ELSE 'FIXTURE_CHANGED' END AS result;`, 'Vérification non-destructive D1');
  if (rows[0]?.result !== 'FIXTURE_PRESERVED') throw new Error('le dry-run a changé des lignes applicatives de la fixture');
  const head = await b2Request('HEAD', testObjectKey);
  if (head !== 200) throw new Error(`l'objet B2 a changé pendant le dry-run (HEAD HTTP ${head})`);
  const output = redact(worker?.logs || '');
  const leaks = /X-Amz-Signature\s*=|AWSAccessKeyId\s*=|upload_url\s*[:=]\s*https?:\/\//i.test(output);
  if (leaks) throw new Error('une URL signée ou une signature semble apparaître dans les logs du Worker local');
  const executions = parseExecutionLogs(output);
  const disabled = [...executions].reverse().find(x => x.enabled === false);
  if (!disabled || Number(disabled.b2_delete_calls) !== 0 || Number(disabled.application_d1_cleanup_operations_completed) !== 0) {
    throw new Error('les logs ne prouvent pas que l’exécuteur est resté désactivé pendant le dry-run');
  }
  return { output };
}

async function verifyA4Execution(fixture) {
  const rows = d1Rows(`SELECT status, attempts, db_cleaned_at FROM purge_operations WHERE operation_id=${sqlQuote(fixture.operationId)} LIMIT 1;`, 'Vérification du registre de purge A4');
  const op = rows[0];
  if (!op || op.status !== 'completed') throw new Error(`opération de purge non completed (${op?.status || 'absente'})`);
  if (Number(op.attempts) !== 1) throw new Error(`compteur attempts attendu 1, obtenu ${op.attempts}`);
  if (!op.db_cleaned_at) throw new Error('db_cleaned_at absent malgré le statut completed');

  const details = d1Rows(`SELECT CASE WHEN EXISTS (SELECT 1 FROM purge_operation_events WHERE operation_id=${sqlQuote(fixture.operationId)} AND event_type='operation_completed' AND json_extract(details_json, '$.databaseTargetRemoved')=1 AND json_extract(details_json, '$.alreadyCleaned')=0) THEN 'TARGET_REMOVED_OK' ELSE 'TARGET_REMOVED_BAD' END AS result;`, 'Vérification des détails de suppression D1 A4');
  if (details[0]?.result !== 'TARGET_REMOVED_OK') throw new Error('databaseTargetRemoved=true et alreadyCleaned=false non prouvés dans l’événement operation_completed');

  const absent = d1Rows(`SELECT CASE WHEN NOT EXISTS (SELECT 1 FROM orders WHERE id=${sqlQuote(testOrderId)}) AND NOT EXISTS (SELECT 1 FROM files WHERE id=${sqlQuote(testFileId)}) THEN 'D1_ROWS_ABSENT' ELSE 'D1_ROWS_PRESENT' END AS result;`, 'Vérification de la suppression en cascade A4');
  if (absent[0]?.result !== 'D1_ROWS_ABSENT') throw new Error('la commande ou son fichier associé existe encore en D1 locale');

  const head = await b2Request('HEAD', testObjectKey);
  if (head !== 404) throw new Error(`objet B2 encore présent ou non vérifiable après purge (HEAD HTTP ${head})`);
  b2ObjectMayExist = false;

  const executionLogs = parseExecutionLogs(worker?.logs || '');
  const summary = [...executionLogs].reverse().find(x => x.enabled === true && x.mode === 'gated_executor_with_resumable_ledger');
  if (!summary) throw new Error('résumé [vitrine-video-purge-execution] activé introuvable dans les logs du Worker local');
  if (Number(summary.operations_completed) !== 1 || Number(summary.b2_delete_calls) !== 1 || Number(summary.application_d1_cleanup_operations_completed) !== 1) {
    throw new Error(`compteurs A4 inattendus: operations_completed=${summary.operations_completed}, b2_delete_calls=${summary.b2_delete_calls}, application_d1_cleanup_operations_completed=${summary.application_d1_cleanup_operations_completed}`);
  }
  const logText = redact(worker?.logs || '');
  if (testObjectKey && logText.includes(testObjectKey)) throw new Error('la clé objet du test apparaît dans les logs; contrôle de masquage échoué');
  return { summary };
}

async function verifyRepeatIsIdempotent(baseUrl, fixture, firstAttempts) {
  await triggerScheduled(baseUrl);
  const rows = d1Rows(`SELECT status, attempts FROM purge_operations WHERE operation_id=${sqlQuote(fixture.operationId)} LIMIT 1;`, 'Vérification du verrou/idempotence A5');
  if (!rows[0] || rows[0].status !== 'completed' || Number(rows[0].attempts) !== Number(firstAttempts)) {
    throw new Error(`une nouvelle exécution a modifié l’opération terminée: status=${rows[0]?.status}, attempts=${rows[0]?.attempts}`);
  }
  const absent = await b2Request('HEAD', testObjectKey);
  if (absent !== 404) throw new Error(`l’objet supprimé est réapparu après une répétition (HTTP ${absent})`);
}

async function cleanupApiFixtures() {
  const ids = [...new Set(apiTestIds.orderIds.filter(Boolean))];
  for (const id of ids) {
    try { d1Exec(`DELETE FROM files WHERE order_id=${sqlQuote(id)};`, 'Nettoyage fichier API de test'); } catch {}
    try { d1Exec(`DELETE FROM quota_events WHERE ordre_id=${sqlQuote(id)};`, 'Nettoyage quota API de test'); } catch {}
    try { d1Exec(`DELETE FROM notifications WHERE json_extract(payload, '$.order_id')=${sqlQuote(id)};`, 'Nettoyage notification API de test'); } catch {}
    try { d1Exec(`DELETE FROM orders WHERE id=${sqlQuote(id)};`, 'Nettoyage commande API de test'); } catch {}
  }
  for (const projectId of [...new Set([apiTestIds.projectId, ...apiTestIds.extraProjectIds].filter(Boolean))]) {
    try { d1Exec(`DELETE FROM projects WHERE id=${sqlQuote(projectId)};`, 'Nettoyage projet API de test'); } catch {}
  }
  for (const merchantId of [...new Set([apiTestIds.merchantId, ...apiTestIds.extraMerchantIds].filter(Boolean))]) {
    try { d1Exec(`DELETE FROM merchants WHERE id=${sqlQuote(merchantId)};`, 'Nettoyage commerce API de test'); } catch {}
  }
}

async function cleanupPurgeFixture() {
  // Delete only the random fixture created by this runner. Preserve completed
  // ledger evidence; remove an incomplete fixture's own planned operation so
  // it cannot become a stale due candidate on the next local run.
  if (!a4Completed && testOperationId) {
    try { d1Exec(`DELETE FROM purge_operation_events WHERE operation_id=${sqlQuote(testOperationId)};`, 'Nettoyage des événements du scénario de purge incomplet'); } catch {}
    try { d1Exec(`DELETE FROM purge_operations WHERE operation_id=${sqlQuote(testOperationId)};`, 'Nettoyage de l’opération de purge locale incomplète'); } catch {}
  }
  if (b2ObjectMayExist && testObjectKey && b2Client && b2Config) {
    try {
      const status = await b2Request('DELETE', testObjectKey);
      if (status === 404 || (status >= 200 && status < 300)) b2ObjectMayExist = false;
    } catch {}
  }
  if (testOrderId) {
    try { d1Exec(`DELETE FROM orders WHERE id=${sqlQuote(testOrderId)};`, 'Nettoyage de la commande synthétique locale'); } catch {}
  }
  if (testFileId) {
    try { d1Exec(`DELETE FROM files WHERE id=${sqlQuote(testFileId)};`, 'Nettoyage du fichier synthétique local'); } catch {}
  }
  if (testEventId) {
    try { d1Exec(`DELETE FROM quota_events WHERE id=${sqlQuote(testEventId)};`, 'Nettoyage de l’événement synthétique local'); } catch {}
  }
}

async function main() {
  console.log('=== VITRINE VIDÉO — RUNNER GLOBAL PHASE A (LOCAL ONLY) ===');
  console.log(`Répertoire : ${ROOT}`);
  console.log('Garde active : Wrangler --local; aucun déploiement; aucune D1 distante.');

  if (!fs.existsSync(SOURCE_PATH)) {
    record('PRÉREQUIS', 'Racine du projet', false, 'src/index.js absent; lancer depuis la racine du dépôt.');
    finish();
    return;
  }
  const source = fs.readFileSync(SOURCE_PATH, 'utf8');
  const devVarsExists = fs.existsSync(DEV_VARS_PATH);
  originalDevVars = devVarsExists ? fs.readFileSync(DEV_VARS_PATH, 'utf8') : null;
  effectiveVars = { ...parseDotEnv(originalDevVars || ''), ...process.env };
  // Process environment entries should be used only when explicitly set; no values are printed.

  const syntax = runProcess(process.execPath, ['--input-type=module', '--check'], { input: source, timeout: 30000 });
  record('PRÉREQUIS', 'Syntaxe du Worker', syntax.status === 0, syntax.status === 0 ? 'src/index.js valide' : redact(syntax.output).slice(-900));

  const unit = runNodeTest(UNIT_TEST_PATH);
  record('PRÉREQUIS', 'Tests unitaires de purge', unit.status === 0, unit.status === 0 ? 'suite purge-executor-core exécutée avec succès' : unit.output.slice(-1600));

  const fixedDelete = /DELETE\s+FROM\s+orders[\s\S]{0,1600}RETURNING\s+id/i.test(source) && /returnedRows\.some\(row\s*=>\s*String\(row\?\.id/.test(source);
  record('A4', 'Correctif D1 DELETE ... RETURNING id', fixedDelete, fixedDelete ? 'le code confirme la suppression de la commande malgré ON DELETE CASCADE' : 'correctif requis avant tout test de purge réelle');

  if (syntax.status !== 0 || unit.status !== 0 || !fixedDelete) {
    const reason = 'préconditions de sécurité échouées (syntaxe Worker, tests unitaires ou correctif D1); aucune création de fixture ni suppression B2 ne sera tentée';
    failCheck('A1', 'Logs et rétention dry-run', new Error(reason));
    failCheck('A3', 'Signatures, confirmation/suppression média et erreurs d’auth', new Error(reason));
    failCheck('A4', 'Purge E2E D1/B2', new Error(reason));
    failCheck('A5', 'Expiration URL signée, orphelins, verrous et quotas', new Error(reason));
    finish();
    return;
  }

  if (!devVarsExists) {
    record('A1', 'Logs et rétention dry-run', false, '.dev.vars absent; aucun Worker d’intégration démarré.');
    record('A3', 'Signatures, confirmation/suppression média et erreurs d’auth', false, '.dev.vars absent ou configuration locale indisponible.');
    record('A4', 'Purge E2E D1/B2', false, '.dev.vars absent; scénario B2 non créé.');
    record('A5', 'Expiration URL signée, orphelins, verrous et quotas', false, '.dev.vars absent; contrôles E2E incomplets.');
    finish();
    return;
  }

  try {
    const configName = ['wrangler.jsonc', 'wrangler.json', 'wrangler.config.jsonc'].find(name => fs.existsSync(path.join(ROOT, name)));
    if (!configName) throw new Error('Wrangler JSONC introuvable; aucun fichier de configuration ne sera modifié.');
    prepareAlternateWranglerConfig(fs.readFileSync(path.join(ROOT, configName), 'utf8'));
  } catch (error) {
    for (const tempPath of [phaseVarsPath, phaseConfigPath]) { try { if (tempPath && fs.existsSync(tempPath)) fs.unlinkSync(tempPath); } catch {} }
    record('PRÉREQUIS', 'Configuration Wrangler temporaire isolée', false, error.message);
    record('A1', 'Logs et rétention dry-run', false, 'impossible de démarrer un Worker d’intégration isolé');
    record('A3', 'Sécurité et contrats API', false, 'impossible de démarrer un Worker d’intégration isolé');
    record('A4', 'Purge E2E D1/B2', false, 'impossible de démarrer un Worker d’intégration isolé');
    record('A5', 'Observabilité et média', false, 'impossible de démarrer un Worker d’intégration isolé');
    finish();
    return;
  }

  // Initialize only Wrangler local D1, then create/verify the reserved test fixture.
  try {
    prepareLocalD1SchemaAndFixtures();
    record('PRÉREQUIS', 'Schéma et fixture réservée D1 locale', true, 'migrations 0001–0003 appliquées; compte, commerce, projet et modèle synthétiques vérifiés');
  } catch (error) {
    record('PRÉREQUIS', 'Schéma et fixture réservée D1 locale', false, redact(error.message).slice(-1800));
    for (const group of ['A1', 'A3', 'A4', 'A5']) {
      failCheck(group, 'Intégration locale non démarrée', new Error('préparation D1 locale échouée; aucun objet B2 créé'));
    }
    finish();
    return;
  }

  // Seed the additional API-security template. This writes to local D1 only.
  d1Exec(`INSERT OR IGNORE INTO templates (id, secteur, langue, duree_cible_s, edl_json, regles_qc_json, version, actif) VALUES ('ci-commerce-fr-v1', 'commerce', 'fr', 30, '{}', '{}', 1, 1);`, 'Préparation du modèle CI en D1 locale');

  let fixture = null;
  let dryWorker = null;
  let activeWorker = null;
  let accountA = null;
  let workspace = null;
  let phaseA1Pass = false;
  let phaseA3Pass = false;
  let phaseA4Pass = false;
  let phaseA5TtlPass = false;
  let phaseA5LockPass = false;
  let phaseA5QuotaPass = false;
  let phaseA5OrphanPass = false;

  try {
    await configureB2();
    if (!fixedDelete) throw new Error('le source ne contient pas le correctif DELETE ... RETURNING id; arrêt de la purge E2E.');

    fixture = await createPurgeFixture();
    record('A4', 'Création fixture D1 + objet B2 de test', true, 'commande, événement de statut, fichier et objet sous le préfixe test dédié');

    // Phase 1: launch a local Worker with the purge executor forced OFF.
    fs.writeFileSync(phaseVarsPath, makeDryRunDevVars(originalDevVars), 'utf8');
    const dryPort = await chooseFreePort();
    dryWorker = startWorker(dryPort, phaseConfigPath, phaseEnvName);
    worker = dryWorker;
    testBaseUrl = dryWorker.baseUrl;
    const health = await waitForHealth(dryWorker);
    record('PRÉREQUIS', 'Worker local et D1 prêts', true, `version ${health.version}, port local ${dryPort}`);

    // A1: scheduled audit runs, but no B2 or business-row deletion is permitted.
    await triggerScheduled(testBaseUrl);
    await sleep(500);
    await verifyDryRun(fixture);
    record('A1', 'Dry-run de rétention sans suppression', true, 'audit completed; inventory complete; objets et lignes métier inchangés');
    record('A1', 'Masquage des URL/signatures dans les logs', true, 'aucune URL signée ni clé de test dans les logs du dry-run');
    phaseA1Pass = true;

    // A3/A5 API integration tests require dedicated Firebase test accounts.
    const requiredAuth = ['FIREBASE_WEB_API_KEY', 'FIREBASE_TEST_A_EMAIL', 'FIREBASE_TEST_A_PASSWORD', 'FIREBASE_TEST_B_EMAIL', 'FIREBASE_TEST_B_PASSWORD'];
    const missingAuth = requiredAuth.filter(k => !getVar(k));
    let securityOutput = '';
    if (missingAuth.length) {
      failCheck('A3', 'Contrats API/auth et isolation média', new Error(`tests non exécutés: variables de comptes de test manquantes (${missingAuth.join(', ')}); aucune valeur secrète affichée`));
      failCheck('A3', 'Signature HMAC du callback interne', new Error('test non exécuté faute de comptes Firebase de test'));
    } else {
      // Snapshot only the existing synthetic CI namespace so records created by
      // security-ci.mjs can be removed without touching pre-existing user rows.
      const priorCiMerchants = new Set(d1Rows("SELECT id FROM merchants WHERE nom_commerce LIKE 'CI Test A %';", 'Instantané des commerces CI préexistants').map(row => String(row.id)));
      const priorCiProjects = new Set(d1Rows("SELECT id FROM projects WHERE titre LIKE 'CI Project A %';", 'Instantané des projets CI préexistants').map(row => String(row.id)));
      const secEnv = { ...process.env, ...effectiveVars, API_BASE_URL: testBaseUrl };
      const sec = runProcess(process.execPath, [SECURITY_TEST_PATH], { env: secEnv, timeout: 180000 });
      // Capture fixtures even when the security script fails partway through.
      try {
        apiTestIds.extraMerchantIds = d1Rows("SELECT id FROM merchants WHERE nom_commerce LIKE 'CI Test A %';", 'Capture des commerces CI créés').map(row => String(row.id)).filter(id => !priorCiMerchants.has(id));
        apiTestIds.extraProjectIds = d1Rows("SELECT id FROM projects WHERE titre LIKE 'CI Project A %';", 'Capture des projets CI créés').map(row => String(row.id)).filter(id => !priorCiProjects.has(id));
        for (const projectId of apiTestIds.extraProjectIds) {
          const createdOrders = d1Rows(`SELECT id FROM orders WHERE project_id=${sqlQuote(projectId)};`, 'Capture des commandes CI créées');
          apiTestIds.orderIds.push(...createdOrders.map(row => String(row.id)));
        }
      } catch (error) {
        warnings.push(`certaines fixtures de security-ci n'ont pas pu être recensées pour nettoyage : ${error.message}`);
      }
      securityOutput = redact(sec.output);
      record('A3', 'Contrats API/auth, commandes idempotentes et isolation confirmation/suppression média', sec.status === 0, sec.status === 0 ? 'scripts/security-ci.mjs a réussi sur le Worker local' : securityOutput.slice(-1800));
      phaseA3Pass = sec.status === 0;
      try {
        accountA = await signInFirebase('A');
        await ensureBootstrap(testBaseUrl, accountA, 'A');
        workspace = await createApiWorkspace(testBaseUrl, accountA, 'A3/A5');
        const callbackOrderId = await testSignedLifecycleCallback(testBaseUrl, accountA, workspace);
        record('A3', 'Signature HMAC valide/invalide et rejeu', true, `callback signé validé, signature incorrecte rejetée; fixture ${callbackOrderId} locale`);
      } catch (error) {
        failCheck('A3', 'Signature HMAC valide/invalide et rejeu', error);
        phaseA3Pass = false;
      }
    }

    // A5: signed URL TTL and quota persistence are runtime checks when Firebase test credentials exist.
    if (accountA && workspace) {
      try {
        const uploadOrderId = await testSignedUrlExpiry(testBaseUrl, accountA, workspace);
        phaseA5TtlPass = true;
        phaseA5QuotaPass = true;
        record('A5', 'Expiration de l’URL signée', true, 'X-Amz-Expires=600, signature présente et expires_at proche de 10 minutes');
        record('A5', 'Événement de quota à la création', true, `une seule ligne commande_creee pour la commande ${uploadOrderId}`);
      } catch (error) {
        failCheck('A5', 'Expiration de l’URL signée et persistance quota', error);
      }
    } else {
      failCheck('A5', 'Expiration de l’URL signée', new Error('test non exécuté: compte Firebase A ou espace local indisponible'));
      failCheck('A5', 'Événement de quota à la création', new Error('test non exécuté: compte Firebase A ou espace local indisponible'));
    }

    // Before enabling deletion, prove that no other eligible operation exists.
    // The executor processes a global queue (up to three operations per run),
    // not a caller-supplied operation ID. If anything else is due, do NOT enable it.
    const gateNow = new Date().toISOString();
    const staleBefore = new Date(Date.now() - 10 * 60 * 1000).toISOString();
    const otherDueRows = d1Rows(`SELECT COUNT(*) AS n FROM purge_operations WHERE operation_id<>${sqlQuote(fixture.operationId)} AND expires_at<=${sqlQuote(gateNow)} AND (((status IN ('planned','retryable_error','b2_delete_pending','b2_deleted','db_cleanup_pending')) AND (next_attempt_at IS NULL OR next_attempt_at<=${sqlQuote(gateNow)})) OR (status='revalidating' AND updated_at<=${sqlQuote(staleBefore)}));`, 'Garde anti-exécution des autres opérations dues');
    const otherDueCount = Number(otherDueRows[0]?.n ?? NaN);

    // Stop the dry-run Worker before enabling the gated executor.
    await stopWorker(dryWorker);
    dryWorker = null;

    if (!Number.isFinite(otherDueCount) || otherDueCount !== 0) {
      const reason = `refus de sécurité : ${Number.isFinite(otherDueCount) ? otherDueCount : 'nombre inconnu'} autre(s) opération(s) due(s) dans le registre local; l’exécuteur global ne sera pas activé pour éviter de supprimer des objets hors fixture`;
      failCheck('A4', 'Garde empêchant la purge de toute autre opération', new Error(reason));
      failCheck('A4', 'Purge E2E : completed + B2 absent + nettoyage D1 réel', new Error('non exécutée car le registre contient des opérations dues hors fixture'));
      failCheck('A5', 'Verrou/idempotence d’une opération terminée', new Error('non exécuté car la garde anti-purge a refusé l’activation globale'));
    } else {
      // Only our synthetic order is eligible; flags live in a temporary
      // environment-specific file, never in the project's .dev.vars.
      fs.writeFileSync(phaseVarsPath, makeEnabledDevVars(originalDevVars), 'utf8');
      const activePort = await chooseFreePort();
      activeWorker = startWorker(activePort, phaseConfigPath, phaseEnvName);
      worker = activeWorker;
      testBaseUrl = activeWorker.baseUrl;
      await waitForHealth(activeWorker);
      await triggerScheduled(testBaseUrl);
      await sleep(500);
      await verifyA4Execution(fixture);
      record('A4', 'Purge E2E : completed + B2 absent + nettoyage D1 réel', true, 'operations_completed=1; b2_delete_calls=1; application_d1_cleanup_operations_completed=1');
      record('A4', 'databaseTargetRemoved=true et alreadyCleaned=false', true, 'valeurs confirmées dans operation_completed');
      phaseA4Pass = true;
      a4Completed = true;

      // Repeating a schedule must not re-run the completed operation.
      try {
        await verifyRepeatIsIdempotent(testBaseUrl, fixture, 1);
        phaseA5LockPass = true;
        record('A5', 'Verrou/idempotence d’une opération terminée', true, 'le rejeu ne réincrémente pas attempts et l’objet reste absent');
      } catch (error) {
        failCheck('A5', 'Verrou/idempotence d’une opération terminée', error);
      }
    }

    // Keep the application-code gate: a standalone script must not make a missing
    // Worker feature look implemented. The next check proves B2/D1 inventory mechanics.
    const hasWorkerInventory = /ListObjectsV2|listObjectsV2|list-type=2|ListBucket/i.test(source);
    record(
      'A5',
      'Mécanisme d’inventaire B2/D1 présent dans le Worker',
      hasWorkerInventory,
      hasWorkerInventory
        ? 'code de listing B2 détecté; le contrôle fonctionnel séparé reste nécessaire'
        : 'src/index.js ne contient toujours aucun mécanisme d’inventaire B2/D1; le test utilitaire seul ne suffit pas à fermer A5'
    );

    const orphanAuditPath = path.join(ROOT, 'scripts', 'check-b2-orphans.mjs');
    const orphanAudit = fs.existsSync(orphanAuditPath)
      ? require('node:child_process').spawnSync(
          process.execPath,
          [orphanAuditPath],
          { cwd: ROOT, env: { ...process.env, ...effectiveVars, API_BASE_URL: testBaseUrl }, encoding: 'utf8', timeout: 120000, windowsHide: true }
        )
      : null;
    const orphanOutput = [
      orphanAudit?.stdout,
      orphanAudit?.stderr,
      orphanAudit?.error?.message,
    ].filter(Boolean).join('\n').trim();
    const orphanE2EPass = Boolean(
      orphanAudit && orphanAudit.status === 0 &&
      /\[PASS\]\s+A5\s+B2\/D1\s+Worker\s+inventory\s+E2E/i.test(orphanOutput)
    );
    phaseA5OrphanPass = hasWorkerInventory && orphanE2EPass;
    const orphanDetails = orphanE2EPass
      ? (orphanOutput.split(/\r?\n/).find(line => /\[PASS\]\s+A5\s+B2\/D1\s+Worker\s+inventory\s+E2E/i.test(line)) || 'objet orphelin détecté par ListObjectsV2 puis comparé à D1')
      : (orphanOutput.slice(-1600) || 'script scripts/check-b2-orphans.mjs absent ou non exécuté');
    record('A5', 'Test E2E réel B2/D1 de détection d’un objet orphelin', orphanE2EPass, orphanDetails);

  } catch (error) {
    const detail = redact(error && error.stack ? error.stack : error && error.message ? error.message : String(error)).slice(-2200);
    if (!checks.some(c => c.group === 'A1')) failCheck('A1', 'Logs et rétention dry-run', error);
    if (!checks.some(c => c.group === 'A3')) failCheck('A3', 'Contrats API/signatures/auth', error);
    if (!checks.some(c => c.group === 'A4' && /Purge E2E/.test(c.name))) failCheck('A4', 'Purge E2E D1/B2', error);
    if (!checks.some(c => c.group === 'A5')) failCheck('A5', 'Expiration URL signée, orphelins, verrous et quotas', error);
    warnings.push(detail);
  } finally {
    // Stop only Workers launched by this runner before removing temporary environment files.
    try { await stopWorker(activeWorker); } catch {}
    try { await stopWorker(dryWorker); } catch {}
    worker = null;
    // .dev.vars is never edited. Remove the dedicated temporary env/config files.
    for (const tempPath of [phaseVarsPath, phaseConfigPath]) {
      try { if (tempPath && fs.existsSync(tempPath)) fs.unlinkSync(tempPath); }
      catch (error) { warnings.push(`fichier temporaire à supprimer manuellement (${path.basename(tempPath)}): ${error.message}`); }
    }
    await cleanupApiFixtures();
    await cleanupPurgeFixture();
  }

  // Combined group-level matrix, with every sub-check visible above.
  const groupPass = group => {
    const subset = checks.filter(c => c.group === group);
    return subset.length > 0 && subset.every(c => c.ok);
  };
  record('MATRICE', 'A1 — Logs & rétention', groupPass('A1'), groupPass('A1') ? 'complet' : 'au moins un contrôle A1 en échec');
  record('MATRICE', 'A3 — Sécurité & contrats API', groupPass('A3'), groupPass('A3') ? 'complet' : 'au moins un contrôle A3 en échec/non exécuté');
  record('MATRICE', 'A4 — Purge D1/B2', groupPass('A4'), groupPass('A4') ? 'E2E validé' : 'purge E2E non entièrement validée');
  record('MATRICE', 'A5 — Observabilité & média', groupPass('A5'), groupPass('A5') ? 'complet' : 'au moins un contrôle A5 en échec/non exécuté');

  if (warnings.length) {
    console.log('\n=== DÉTAILS / AVERTISSEMENTS ===');
    for (const w of warnings) console.log(`- ${redact(w).slice(0, 2200)}`);
  }
  finish();
}

function finish() {
  console.log('\n=== MATRICE FINALE PHASE A ===');
  for (const group of ['A1', 'A3', 'A4', 'A5']) {
    const subset = checks.filter(c => c.group === group);
    const ok = subset.length > 0 && subset.every(c => c.ok);
    console.log(`${ok ? '[PASS]' : '[FAIL]'} ${group} (${subset.filter(c => c.ok).length}/${subset.length} contrôles PASS)`);
    for (const c of subset) console.log(`  ${c.ok ? '[PASS]' : '[FAIL]'} ${c.name}${c.detail ? ` — ${c.detail}` : ''}`);
  }
  const failed = checks.filter(c => !c.ok);
  console.log(`\nBILAN : ${checks.length - failed.length}/${checks.length} contrôles PASS; ${failed.length} FAIL.`);
  if (failed.length === 0) {
    console.log('PHASE A : tous les contrôles inclus dans ce runner sont PASS. Revue et approbation humaines encore requises avant scellement du backend.');
    process.exitCode = 0;
  } else {
    console.log('PHASE A : NON CLOSE — corriger uniquement les contrôles FAIL et relancer le même runner.');
    process.exitCode = 1;
  }
}

main().catch(async error => {
  console.error(`[FAIL] Runner global interrompu — ${redact(error && error.stack ? error.stack : error.message || String(error)).slice(-2400)}`);
  try { if (worker) await stopWorker(worker); } catch {}
  for (const tempPath of [phaseVarsPath, phaseConfigPath]) { try { if (tempPath && fs.existsSync(tempPath)) fs.unlinkSync(tempPath); } catch {} }
  try { await cleanupApiFixtures(); } catch {}
  try { await cleanupPurgeFixture(); } catch {}
  process.exitCode = 1;
});
