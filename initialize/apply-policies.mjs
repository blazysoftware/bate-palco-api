#!/usr/bin/env node
// Bate Palco • Apply Policies & Permissions (idempotente)
// - Cria/atualiza Policies: Public App, Client App, Singer App
// - Habilita App Access nas 3
// - Aplica permissões (read/write) por coleção
// - Cria roles Singer/Client e vincula às respectivas policies
// - Public App só cria permissões (sem role associada)

import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';

/* ------------ tiny .env loader ------------ */
(function loadEnv() {
  const p = path.resolve(process.cwd(), '.env');
  if (!fs.existsSync(p)) return;
  for (const line of fs.readFileSync(p, 'utf8').split(/\r?\n/)) {
    if (!line || line.trim().startsWith('#')) continue;
    const i = line.indexOf('=');
    if (i === -1) continue;
    const k = line.slice(0, i).trim();
    const v = line.slice(i + 1).trim();
    if (!(k in process.env)) process.env[k] = v;
  }
})();

/* ----------------- config ----------------- */
function normUrl(u) {
  let v = (u || '').trim();
  if (!/^https?:\/\//i.test(v)) v = 'http://' + v;
  try {
    const url = new URL(v.replace(/\/+$/, ''));
    if (url.hostname === 'localhost') url.hostname = '127.0.0.1';
    return url.toString().replace(/\/+$/, '');
  } catch { return v.replace(/\/+$/, ''); }
}
const SERVER = normUrl(process.env.PUBLIC_URL);
const ADMIN_EMAIL = process.env.ADMIN_EMAIL || '';
const ADMIN_PASSWORD = process.env.ADMIN_PASSWORD || '';
if (!SERVER || !ADMIN_EMAIL || !ADMIN_PASSWORD) {
  console.error('❌ Set PUBLIC_URL, ADMIN_EMAIL, ADMIN_PASSWORD no .env'); process.exit(1);
}

const DEBUG = String(process.env.DEBUG || '0') === '1';
const HTTP_TIMEOUT_MS = parseInt(process.env.HTTP_TIMEOUT_MS || '20000', 10);
const HTTP_RETRIES = parseInt(process.env.HTTP_RETRIES || '5', 10);
const HTTP_BACKOFF_MS = parseInt(process.env.HTTP_BACKOFF_MS || '600', 10);

const dbg = (...a) => { if (DEBUG) console.log('[DEBUG]', ...a); };
const delay = (ms) => new Promise((r) => setTimeout(r, ms));

/* --------------- http helpers --------------- */
async function fetchWithRetry(url, { method='GET', headers={}, body, timeout=HTTP_TIMEOUT_MS } = {}) {
  let lastErr;
  for (let attempt = 1; attempt <= HTTP_RETRIES; attempt++) {
    const controller = new AbortController();
    const t = setTimeout(() => controller.abort(`Timeout ${timeout}ms`), timeout);
    const started = Date.now();
    try {
      if (DEBUG) dbg(`${method} ${url}`, body ? { headers, body } : { headers });
      const res = await fetch(url, { method, headers, body: body ? JSON.stringify(body) : undefined, signal: controller.signal });
      const text = await res.text();
      let json = {};
      try { json = text ? JSON.parse(text) : {}; } catch {}
      if (DEBUG) dbg(`← ${res.status} ${method} ${url} ${Date.now()-started}ms`);
      if (res.ok) return json;
      if (res.status >= 500 || res.status === 429) {
        lastErr = new Error(`HTTP ${res.status} ${res.statusText} - ${text.slice(0, 300)}`);
        await delay(HTTP_BACKOFF_MS * Math.pow(2, attempt - 1));
        continue;
      }
      const err = new Error(`HTTP ${res.status} ${res.statusText} - ${text.slice(0, 800)}`);
      err.httpStatus = res.status; throw err;
    } catch (e) {
      lastErr = e;
      await delay(HTTP_BACKOFF_MS * Math.pow(2, attempt - 1));
    } finally { clearTimeout(t); }
  }
  throw lastErr || new Error('fetchWithRetry: unknown');
}
const apiPath = (p) => `${SERVER}/${String(p).replace(/^\/+/, '')}`;
const api = (p, token, { method='GET', body } = {}) =>
  fetchWithRetry(apiPath(p), {
    method,
    headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
    body
  });

/* --------------- directus helpers --------------- */
async function loginAdmin() {
  // If you provide a pre-created static admin token in .env as ADMIN_TOKEN,
  // prefer that — it avoids issues when the email/password account isn't full-admin.
  if (process.env.ADMIN_TOKEN) {
    dbg('Using ADMIN_TOKEN from env');
    return process.env.ADMIN_TOKEN;
  }

  const r = await api('/auth/login', null, { method: 'POST', body: { email: ADMIN_EMAIL, password: ADMIN_PASSWORD } });
  const token = r?.data?.access_token || r?.access_token;
  if (!token) throw new Error('Login failed');
  return token;
}
async function getPolicyByName(name, token) {
  const r = await api(`/policies?filter[name][_eq]=${encodeURIComponent(name)}&limit=1`, token);
  return r?.data?.[0] || null;
}
async function ensurePolicy(name, { app_access=false, admin_access=false, icon='policy', description }, token) {
  const ex = await getPolicyByName(name, token);
  if (ex) {
    if (ex.app_access !== app_access || ex.admin_access !== admin_access || ex.icon !== icon) {
      await api(`/policies/${ex.id}`, token, { method: 'PATCH', body: { app_access, admin_access, icon } });
    }
    return ex;
  }
  const c = await api('/policies', token, { method: 'POST', body: { name, app_access, admin_access, icon, description: description || name } });
  return c.data;
}
async function getRoleByName(name, token) {
  const r = await api(`/roles?filter[name][_eq]=${encodeURIComponent(name)}&limit=1`, token);
  return r?.data?.[0] || null;
}
async function ensureRole(name, description, token) {
  const ex = await getRoleByName(name, token);
  if (ex) return ex;
  const c = await api('/roles', token, { method: 'POST', body: { name, description } });
  return c.data;
}
async function linkRolePolicy(roleId, policyId, token) {
  const role = await api(`/roles/${roleId}`, token);
  const current = role?.data?.policies?.map(p => p.id) || [];
  if (!current.includes(policyId)) {
    try {
      // Use nested creation approach instead of direct array update
      await api(`/roles/${roleId}`, token, { 
        method: 'PATCH', 
        body: { 
          policies: {
            create: [
              {
                role: roleId,
                policy: {
                  id: policyId
                }
              }
            ],
            update: [],
            delete: []
          }
        }
      });
      dbg(`✅ Linked policy ${policyId} to role ${roleId} via nested creation`);
    } catch (e) {
      // Fallback: try the junction table approach
      if (e?.httpStatus === 403) {
        console.log(`⚠️  Nested creation failed, trying junction table approach...`);
        try {
          await api('/directus_policies', token, { 
            method: 'POST', 
            body: { role: roleId, policy: policyId } 
          });
          dbg(`✅ Linked policy ${policyId} to role ${roleId} via junction table`);
        } catch (e2) {
          const hint = [
            'Both nested creation and junction table approach failed.',
            'This suggests permissions issues with role-policy relations.',
            'Try creating a static admin token in Directus Admin UI → Settings → Tokens',
            `Role: ${roleId}, Policy: ${policyId}`
          ].join(' ');
          throw new Error(`${hint} — Nested: ${e.message}, Junction: ${e2.message}`);
        }
      } else {
        throw e;
      }
    }
  } else {
    dbg(`✅ Policy ${policyId} already linked to role ${roleId}`);
  }
}

async function findPermission({ policy, collection, action }, token) {
  const r = await api(`/permissions?filter[policy][_eq]=${policy}&filter[collection][_eq]=${collection}&filter[action][_eq]=${action}&limit=1`, token);
  return r?.data?.[0] || null;
}
async function upsertPermission(payload, token) {
  const ex = await findPermission(payload, token);
  if (ex) { await api(`/permissions/${ex.id}`, token, { method: 'PATCH', body: payload }); return ex.id; }
  const c = await api('/permissions', token, { method: 'POST', body: payload }); return c.data.id;
}

/* --------------- permissions matrix --------------- */
const MESSAGE_PUBLIC_FIELDS = [
  'id','live','session','sender_type','sender_name','content','sent_at',
  'reactions','visibility','is_super','linked_request'
];
const REQUEST_PUBLIC_FIELDS = [
  'id','live','session','song','status','requested_by','requested_at',
  'reactions','is_super','superchat_type','played_at','answered_at'
];
const SESSION_PUBLIC_FIELDS = ['id','live','status','started_at','ended_at','where_are_you'];

async function applyPublicPolicy(policyId, token) {
  await upsertPermission({ policy: policyId, collection: 'lives', action: 'read', fields: ['*'],
    permissions: { _and: [{ is_public: { _eq: true } }, { status: { _eq: 'online' } }] } }, token);
  await upsertPermission({ policy: policyId, collection: 'live_sessions', action: 'read', fields: SESSION_PUBLIC_FIELDS,
    permissions: { _and: [{ status: { _eq: 'active' } }, { 'live.is_public': { _eq: true } }, { 'live.status': { _eq: 'online' } }] } }, token);
  await upsertPermission({ policy: policyId, collection: 'messages', action: 'read', fields: MESSAGE_PUBLIC_FIELDS,
    permissions: { _and: [{ is_hidden: { _eq: false } }, { visibility: { _contains: 'public' } }] } }, token);
  await upsertPermission({ policy: policyId, collection: 'songs', action: 'read', fields: ['*'] }, token);
}

async function applyClientPolicy(policyId, token) {
  await upsertPermission({ policy: policyId, collection: 'lives', action: 'read', fields: ['*'],
    permissions: { _and: [{ is_public: { _eq: true } }, { status: { _eq: 'online' } }] } }, token);
  await upsertPermission({ policy: policyId, collection: 'live_sessions', action: 'read', fields: SESSION_PUBLIC_FIELDS,
    permissions: { _and: [{ status: { _eq: 'active' } }, { 'live.is_public': { _eq: true } }] } }, token);
  await upsertPermission({ policy: policyId, collection: 'messages', action: 'read', fields: ['*'],
    permissions: { _and: [{ is_hidden: { _eq: false } }, { visibility: { _contains: 'client' } }] } }, token);
  await upsertPermission({ policy: policyId, collection: 'songs', action: 'read', fields: ['*'] }, token);
  await upsertPermission({ policy: policyId, collection: 'messages', action: 'create', fields: ['*'],
    presets: { sender_type: 'client', is_hidden: false, visibility: ['public','client','singer'] } }, token);
  await upsertPermission({ policy: policyId, collection: 'messages', action: 'update', fields: ['*'],
    permissions: { sender_user: { _eq: '$CURRENT_USER' } } }, token);
  await upsertPermission({ policy: policyId, collection: 'requests', action: 'create', fields: ['*'], presets: { status: 'pending' } }, token);
  await upsertPermission({ policy: policyId, collection: 'requests', action: 'read', fields: ['*'],
    permissions: { 'live.is_public': { _eq: true } } }, token);
  await upsertPermission({ policy: policyId, collection: 'requests', action: 'update', fields: ['*'],
    permissions: { requested_user: { _eq: '$CURRENT_USER' } } }, token);
  await upsertPermission({ policy: policyId, collection: 'suggestions', action: 'create', fields: ['*'] }, token);
  await upsertPermission({ policy: policyId, collection: 'suggestions', action: 'read', fields: ['*'],
    permissions: { 'live.is_public': { _eq: true } } }, token);
}

async function applySingerPolicy(policyId, token) {
  for (const action of ['create','read','update','delete']) {
    await upsertPermission({ policy: policyId, collection: 'lives', action, fields: ['*'],
      permissions: action === 'create' ? {} : { singer: { _eq: '$CURRENT_USER' } },
      presets: action === 'create' ? { singer: '$CURRENT_USER' } : {} }, token);
  }
  for (const action of ['create','read','update','delete']) {
    await upsertPermission({ policy: policyId, collection: 'live_sessions', action, fields: ['*'],
      permissions: action === 'create' ? {} : { _or: [{ artist: { _eq: '$CURRENT_USER' } }, { 'live.singer': { _eq: '$CURRENT_USER' } }] },
      presets: action === 'create' ? { artist: '$CURRENT_USER' } : {} }, token);
  }
  for (const action of ['create','read','update','delete']) {
    await upsertPermission({ policy: policyId, collection: 'songs', action, fields: ['*'],
      permissions: action === 'create' ? {} : { owner: { _eq: '$CURRENT_USER' } },
      presets: action === 'create' ? { owner: '$CURRENT_USER' } : {} }, token);
  }
  for (const action of ['create','read','update','delete']) {
    await upsertPermission({ policy: policyId, collection: 'messages', action, fields: ['*'],
      permissions: action === 'create' ? {} : { 'live.singer': { _eq: '$CURRENT_USER' } },
      presets: action === 'create' ? { sender_type: 'artist', sender_user: '$CURRENT_USER', is_hidden: false } : {} }, token);
  }
  for (const action of ['create','read','update','delete']) {
    await upsertPermission({ policy: policyId, collection: 'requests', action, fields: ['*'],
      permissions: action === 'create' ? {} : { 'live.singer': { _eq: '$CURRENT_USER' } } }, token);
  }
  for (const action of ['create','read','update','delete']) {
    await upsertPermission({ policy: policyId, collection: 'suggestions', action, fields: ['*'],
      permissions: action === 'create' ? {} : { 'live.singer': { _eq: '$CURRENT_USER' } } }, token);
  }
  for (const action of ['create','read','update','delete']) {
    await upsertPermission({ policy: policyId, collection: 'themes', action, fields: ['*'],
      permissions: action === 'create' ? {} : { owner: { _eq: '$CURRENT_USER' } },
      presets: action === 'create' ? { owner: '$CURRENT_USER' } : {} }, token);
  }
}

/* -------------------- MAIN -------------------- */
(async () => {
  console.log('=== Bate Palco • Apply Policies & Roles ===');
  console.log(`Server: ${SERVER}`);
  console.log(`Admin:  ${ADMIN_EMAIL}\n`);

  const token = await loginAdmin();

  // Policies
  const publicPolicy = await ensurePolicy('Public App', { app_access: true, admin_access: false, icon: 'public' }, token);
  const clientPolicy = await ensurePolicy('Client App', { app_access: true, admin_access: false, icon: 'person' }, token);
  const singerPolicy = await ensurePolicy('Singer App', { app_access: true, admin_access: false, icon: 'mic' }, token);

  // Roles
  const clientRole = await ensureRole('Client', 'Authenticated client role', token);
  const singerRole = await ensureRole('Singer', 'Singer/artist role', token);

  // Vincula policies ↔ roles
  await linkRolePolicy(clientRole.id, clientPolicy.id, token);
  await linkRolePolicy(singerRole.id, singerPolicy.id, token);

  // Permissões
  await applyPublicPolicy(publicPolicy.id, token);
  await applyClientPolicy(clientPolicy.id, token);
  await applySingerPolicy(singerPolicy.id, token);

  console.log('✅ Policies, roles e permissões aplicadas (Public App / Client App / Singer App).');
})().catch((e) => {
  console.error('❌ Erro:', e?.message || e);
  if (DEBUG && e?.stack) console.error(e.stack);
  process.exit(1);
});
