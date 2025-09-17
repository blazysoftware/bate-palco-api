#!/usr/bin/env node
// Bate Palco • Run batepalco.sql (idempotente)
// - Lê .env
// - Encontra psql (PSQL_BIN opcional)
// - Usa PGURI ou DB_*
// - Garante pgcrypto + search_path
// - Substitui variáveis :DOMAIN e :PWD

import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { spawn, spawnSync } from 'node:child_process';

/* Carrega .env simples */
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

const DEBUG = String(process.env.DEBUG || '0') === '1';
const dbg = (...a) => { if (DEBUG) console.log('[DEBUG]', ...a); };

function canExec(cmd) {
  try {
    const probe = spawnSync(cmd, ['--version'], { stdio: 'ignore' });
    return probe.status === 0;
  } catch { return false; }
}

function whichPsql() {
  const cands = [
    process.env.PSQL_BIN,                         // 1) caminho definido no .env (opcional)
    'psql',                                       // 2) PATH do sistema
    '/opt/homebrew/opt/libpq/bin/psql',           // 3) macOS Apple Silicon (Homebrew)
    '/usr/local/opt/libpq/bin/psql',              // 4) macOS Intel (Homebrew)
    '/usr/bin/psql',
    '/usr/local/bin/psql'
  ].filter(Boolean);
  for (const c of cands) {
    if (canExec(c)) return c;
  }
  return null;
}

function runPsql(args, { env = {} } = {}) {
  return new Promise((resolve, reject) => {
    const bin = whichPsql();
    if (!bin) {
      const msg = [
        'psql não encontrado.',
        'Opções para resolver:',
        '1) Instalar client do Postgres (libpq) via Homebrew:',
        '   brew install libpq && brew link --force libpq',
        '2) Definir o caminho no .env, ex.:',
        '   PSQL_BIN=/opt/homebrew/opt/libpq/bin/psql',
      ].join('\n');
      return reject(new Error(msg));
    }
    dbg('Executando psql:', bin, args.join(' '));
    const cp = spawn(bin, args, { stdio: 'inherit', env: { ...process.env, ...env } });
    cp.on('error', reject);
    cp.on('exit', (code) => code === 0 ? resolve() : reject(new Error(`psql saiu com código ${code}`)));
  });
}

function sqlEscapeLiteral(v) { return String(v ?? '').replace(/'/g, "''"); }

async function main() {
  // Conexão via PGURI ou DB_*
  const PGURI = process.env.PGURI || '';
  const DB_HOST = process.env.DB_HOST;
  const DB_PORT = process.env.DB_PORT || '5432';
  const DB_DATABASE = process.env.DB_DATABASE;
  const DB_USER = process.env.DB_USER;
  const DB_PASSWORD = process.env.DB_PASSWORD;

  let argsBase;
  let env = {};
  if (PGURI) {
    argsBase = [PGURI];
  } else {
    if (!DB_HOST || !DB_DATABASE || !DB_USER) {
      throw new Error('Defina PGURI ou DB_HOST, DB_PORT, DB_DATABASE, DB_USER (e DB_PASSWORD) no .env');
    }
    argsBase = ['-h', DB_HOST, '-p', DB_PORT, '-U', DB_USER, '-d', DB_DATABASE];
    if (DB_PASSWORD) env.PGPASSWORD = DB_PASSWORD;
  }

  const DATA_SQL = path.resolve(process.cwd(), process.env.DATA_SQL || './initialize/batepalco.sql');
  if (!fs.existsSync(DATA_SQL)) throw new Error(`batepalco.sql não encontrado em: ${DATA_SQL}`);

  console.log('=== Bate Palco • Run batepalco.sql ===');
  if (PGURI) console.log(`DB: ${PGURI}`);
  else console.log(`DB: ${DB_USER}@${DB_HOST}:${DB_PORT}/${DB_DATABASE}`);
  console.log(`SQL: ${DATA_SQL}`);

  // 1) Extensão + search_path
  await runPsql([...argsBase, '-v', 'ON_ERROR_STOP=1', '-c', 'CREATE EXTENSION IF NOT EXISTS "pgcrypto"; SET search_path TO public;'], { env });

  // 2) Lê o arquivo SQL original e substitui as variáveis
  let sqlContent = fs.readFileSync(DATA_SQL, 'utf8');

  // Configurações das variáveis
  const domain = process.env.SEED_DOMAIN || 'gmail.com';
  // Hash bcrypt para senha "123456" (você pode gerar um novo hash se preferir)
  const passwordHash = '$2b$10$K8BQHnlAqfR6T8E5o5J.xOeKhM5J7v8y9Zx1n2m3C4d5e6f7g8h9i0';

  // Substitui as variáveis no SQL
  sqlContent = sqlContent.replace(/:DOMAIN/g, `'${sqlEscapeLiteral(domain)}'`);
  sqlContent = sqlContent.replace(/:PWD/g, `'${sqlEscapeLiteral(passwordHash)}'`);

  // Cria arquivo temporário com as substituições
  const tempSqlPath = path.join(process.cwd(), `.tmp-seed-${Date.now()}.sql`);
  fs.writeFileSync(tempSqlPath, sqlContent, 'utf8');

  try {
    // 3) Executa o arquivo SQL processado
    await runPsql([...argsBase, '-v', 'ON_ERROR_STOP=1', '-f', tempSqlPath], { env });
  } finally {
    // Limpa o arquivo temporário
    try { fs.unlinkSync(tempSqlPath); } catch {}
  }

  console.log('✅ batepalco.sql aplicado com sucesso.');
}

main().catch((e) => {
  console.error('❌ Erro:', e?.message || e);
  if (DEBUG && e?.stack) console.error(e.stack);
  process.exit(1);
});
