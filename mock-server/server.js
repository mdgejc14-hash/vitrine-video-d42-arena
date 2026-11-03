#!/usr/bin/env node
/**
 * VV Mock/Staging local (VV Remote QA s2/s6) — Node.js PUR, zero dependance.
 * Roles : mock Firebase Auth (/auth), Cloudflare Workers (/api),
 * Backblaze B2 (/storage), serveur authority C10 (/authority).
 * Ports : 3200 = HTTP plain (emulateur 10.0.2.2:3200, flavor qa UNIQUEMENT),
 *         3000 = HTTPS si certs/ fournis (operateur humain), sinon non ouvert.
 * Tarifs = source de verite app (Plan enum) : 500 / 3000 / 7500 FCFA.
 * JAMAIS exposer sur Internet ; aucune donnee de production.
 */
const http = require('http');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

const DATA = path.join(__dirname, 'data');
const UPLOADS = path.join(DATA, 'uploads');
fs.mkdirSync(UPLOADS, { recursive: true });

const state = {
  users: [],
  grants: {},        // fingerprint -> { granted, credits_total, at }
  installations: [], // C10 authority
  files: [],
};

const PLANS = [
  { id: 'pass24h', name: 'Pass 24 h', price_fcfa: 500, renew_days: null },
  { id: 'pro', name: 'Pro', price_fcfa: 3000, renew_days: 30 },
  { id: 'boutique', name: 'Boutique', price_fcfa: 7500, renew_days: 30 },
];

function json(res, code, body) {
  const payload = JSON.stringify(body);
  res.writeHead(code, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Authorization, Content-Type',
    'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
  });
  res.end(payload);
}

function body(req) {
  return new Promise((resolve) => {
    let raw = '';
    req.on('data', (c) => { raw += c; if (raw.length > 5e6) req.destroy(); });
    req.on('end', () => {
      try { resolve(JSON.parse(raw || '{}')); } catch { resolve({}); }
    });
  });
}

function token(payload) {
  const head = Buffer.from(JSON.stringify({ alg: 'HS256', typ: 'JWT' })).toString('base64url');
  const bodyB64 = Buffer.from(JSON.stringify(payload)).toString('base64url');
  const sig = crypto.createHmac('sha256', 'vv-mock-secret-local').update(head + '.' + bodyB64).digest('base64url');
  return head + '.' + bodyB64 + '.' + sig;
}

const routes = [];
function route(method, pattern, handler) { routes.push({ method, pattern, handler }); }

// ---- health ----
route('GET', /^\/health$/, (req, res) => json(res, 200, {
  status: 'OK', service: 'VV Mock Staging', ts: new Date().toISOString(),
  plans: PLANS.map((p) => p.price_fcfa),
}));

// ---- auth (mock Firebase : SSO sans telephone) ----
route('POST', /^\/auth\/signup$/, async (req, res) => {
  const b = await body(req);
  if (!b.email) return json(res, 400, { error: 'email requis' });
  if (state.users.find((u) => u.email === b.email)) return json(res, 400, { error: 'existe deja' });
  const user = { id: crypto.randomUUID(), email: b.email, createdAt: new Date().toISOString() };
  state.users.push(user);
  json(res, 201, { user, token: token({ uid: user.id, email: user.email }) });
});
route('POST', /^\/auth\/signin$/, async (req, res) => {
  const b = await body(req);
  const user = state.users.find((u) => u.email === b.email);
  if (!user) return json(res, 401, { error: 'identifiants invalides' });
  json(res, 200, { user, token: token({ uid: user.id, email: user.email }) });
});

// ---- welcome-grant (authority credits bienvenue, une fois par empreinte) ----
route('POST', /^\/api\/v1\/me\/welcome-grant$/, async (req, res) => {
  const b = await body(req);
  const fp = b.fingerprint || 'inconnu';
  if (state.grants[fp]) {
    return json(res, 200, { granted: false, credits_total: state.grants[fp].credits_total, already: true });
  }
  state.grants[fp] = { granted: true, credits_total: 3, at: new Date().toISOString() };
  json(res, 200, { granted: true, credits_total: 3 });
});

// ---- api (mock Workers) ----
route('GET', /^\/api\/v1\/pricing\/uemoa$/, (req, res) => json(res, 200, {
  currency: 'XOF', parity_bceao_fcfa_per_eur: 655.957, plans: PLANS,
}));

// ---- storage (mock B2) ----
route('POST', /^\/storage\/upload$/, async (req, res) => {
  const b = await body(req);
  const id = crypto.randomUUID();
  const name = (b.name || 'upload.bin').replace(/[^\w.-]/g, '_');
  fs.writeFileSync(path.join(UPLOADS, id + '_' + name), Buffer.from(b.base64 || '', 'base64'));
  state.files.push({ id, name, at: new Date().toISOString() });
  json(res, 201, { id, url: 'mock://storage/' + id + '_' + name });
});
route('GET', /^\/storage\/files$/, (req, res) => json(res, 200, { files: state.files }));

// ---- authority C10 (reset / install / verify) ----
route('POST', /^\/authority\/reset$/, async (req, res) => {
  const b = await body(req);
  if (!b.appId || !b.userId || !b.deviceId) return json(res, 400, { error: 'appId, userId, deviceId requis' });
  const resetToken = crypto.randomUUID();
  state.installations.push({
    id: crypto.randomUUID(), appId: b.appId, userId: b.userId, deviceId: b.deviceId,
    resetToken, status: 'RESET_PENDING', timestamp: new Date().toISOString(),
  });
  json(res, 200, { success: true, resetToken });
});
route('POST', /^\/authority\/install$/, async (req, res) => {
  const b = await body(req);
  const entry = state.installations.find((i) =>
    i.appId === b.appId && i.userId === b.userId && i.deviceId === b.deviceId &&
    i.resetToken === b.resetToken && i.status === 'RESET_PENDING');
  if (!entry) return json(res, 400, { error: 'reset introuvable ou deja utilise' });
  entry.status = 'INSTALLED';
  entry.installationTimestamp = new Date().toISOString();
  json(res, 200, { success: true, installationId: entry.id, status: 'INSTALLED' });
});
route('GET', /^\/authority\/verify$/, (req, res, url) => {
  const q = url.searchParams;
  const list = state.installations.filter((i) =>
    i.appId === q.get('appId') && i.userId === q.get('userId') && i.deviceId === q.get('deviceId'));
  const last = list.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp))[0];
  if (!last) return json(res, 404, { error: 'aucune installation' });
  json(res, 200, { success: true, isValid: last.status === 'INSTALLED', installation: last });
});

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, 'http://localhost');
  if (req.method === 'OPTIONS') return json(res, 204, {});
  for (const r of routes) {
    if (r.method === req.method && r.pattern.test(url.pathname)) {
      try { return await r.handler(req, res, url); } catch (e) {
        return json(res, 500, { error: String(e && e.message || e) });
      }
    }
  }
  json(res, 404, { error: 'route inconnue', path: url.pathname });
});

const PORT_HTTP = Number(process.env.VV_MOCK_PORT || 3200);
server.listen(PORT_HTTP, '0.0.0.0', () => {
  console.log('VV Mock staging HTTP sur :' + PORT_HTTP);
});
