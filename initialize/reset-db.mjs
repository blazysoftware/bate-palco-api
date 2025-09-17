#!/usr/bin/env node
// Bate Palco • Reset Database
// - Conecta na base postgres
// - Bloqueia conexões na batepalco_test
// - Termina sessões ativas
// - Dropa e recria a database

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
    process.env.PSQL_BIN,
    'psql',
    '/opt/homebrew/opt/libpq/bin/psql',
    '/usr/local/opt/libpq/bin/psql',
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

async function main() {
  // Conexão via PGURI ou DB_*
  const PGURI = process.env.PGURI || '';
  const DB_HOST = process.env.DB_HOST;
  const DB_PORT = process.env.DB_PORT || '5432';
  const DB_DATABASE = process.env.DB_DATABASE;
  const DB_USER = process.env.DB_USER;
  const DB_PASSWORD = process.env.DB_PASSWORD;

  let env = {};
  let argsToPostgres;
  
  if (PGURI) {
    // Substitui o nome da database por 'postgres' na URI
    const postgresUri = PGURI.replace(/\/[^/]+(\?|$)/, '/postgres$1');
    argsToPostgres = [postgresUri];
  } else {
    if (!DB_HOST || !DB_USER) {
      throw new Error('Defina PGURI ou DB_HOST, DB_PORT, DB_USER (e DB_PASSWORD) no .env');
    }
    argsToPostgres = ['-h', DB_HOST, '-p', DB_PORT, '-U', DB_USER, '-d', 'postgres'];
    if (DB_PASSWORD) env.PGPASSWORD = DB_PASSWORD;
  }

  const targetDb = DB_DATABASE || 'batepalco_test';

  console.log('=== Bate Palco • Reset Database ===');
  if (PGURI) console.log(`DB: ${PGURI} -> postgres`);
  else console.log(`DB: ${DB_USER}@${DB_HOST}:${DB_PORT}/postgres`);
  console.log(`Target: ${targetDb}`);
  console.log('');

  // Confirmar ação destrutiva
  console.log('⚠️  ATENÇÃO: Este comando irá DESTRUIR todos os dados da database!');
  console.log(`   Database: ${targetDb}`);
  console.log('');
  
  if (process.env.FORCE !== '1') {
    console.log('Para confirmar, execute:');
    console.log(`   FORCE=1 npm run reset-db`);
    console.log('');
    process.exit(1);
  }

  console.log('🔄 Iniciando reset...');

  // Passo 1: Bloquear conexões
  console.log('1️⃣  Bloqueando conexões...');
  await runPsql([...argsToPostgres, '-c', `ALTER DATABASE ${targetDb} WITH ALLOW_CONNECTIONS false;`], { env });
  
  // Passo 2: Revogar permissões
  console.log('2️⃣  Revogando permissões...');
  await runPsql([...argsToPostgres, '-c', `REVOKE CONNECT ON DATABASE ${targetDb} FROM PUBLIC;`], { env });

  // Passo 3: Terminar sessões ativas
  console.log('3️⃣  Terminando sessões ativas...');
  const terminateSql = `
    SELECT pg_terminate_backend(pid)
    FROM pg_stat_activity
    WHERE datname = '${targetDb}'
      AND pid <> pg_backend_pid();
  `;
  await runPsql([...argsToPostgres, '-c', terminateSql], { env });

  // Passo 4: Dropar database
  console.log('4️⃣  Dropando database...');
  await runPsql([...argsToPostgres, '-c', `DROP DATABASE ${targetDb};`], { env });

  // Passo 5: Recriar database
  console.log('5️⃣  Recriando database...');
  await runPsql([...argsToPostgres, '-c', `CREATE DATABASE ${targetDb};`], { env });

  console.log('✅ Database resetada com sucesso!');
  console.log('');
  console.log('Próximos passos:');
  console.log('1) npm run bootstrap  # para aplicar schema');
  console.log('2) npm run data       # para popular dados demo');
}

main().catch((e) => {
  console.error('❌ Erro:', e?.message || e);
  if (DEBUG && e?.stack) console.error(e.stack);
  process.exit(1);
});