#!/usr/bin/env node
// Bate Palco • Complete Setup Interativo
// - Confirmação y/n para cada etapa
// - Drop database
// - Create database  
// - Initialize (bootstrap)
// - Start server
// - Apply snapshot
// - Apply policies
// - Apply data

import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { spawn, spawnSync } from 'node:child_process';
import { createInterface } from 'node:readline';

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

// Cores para output bonito
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m',
  white: '\x1b[37m',
  gray: '\x1b[90m'
};

function colorize(text, color) {
  return `${colors[color]}${text}${colors.reset}`;
}

function printHeader(title) {
  const line = '═'.repeat(60);
  console.log('');
  console.log(colorize(line, 'cyan'));
  console.log(colorize(`  🚀 ${title}`, 'bright'));
  console.log(colorize(line, 'cyan'));
  console.log('');
}

function printStep(step, title, description) {
  console.log(colorize(`${step} ${title}`, 'blue'));
  console.log(colorize(`   ${description}`, 'gray'));
}

function printSuccess(message) {
  console.log(colorize(`✅ ${message}`, 'green'));
}

function printError(message) {
  console.log(colorize(`❌ ${message}`, 'red'));
}

function printWarning(message) {
  console.log(colorize(`⚠️  ${message}`, 'yellow'));
}

function printInfo(message) {
  console.log(colorize(`ℹ️  ${message}`, 'cyan'));
}

function runScript(scriptName, env = {}) {
  return new Promise((resolve, reject) => {
    const cp = spawn('npm', ['run', scriptName], {
      stdio: 'inherit',
      env: { ...process.env, ...env }
    });
    cp.on('error', reject);
    cp.on('exit', (code) => {
      if (code === 0) resolve();
      else reject(new Error(`Script ${scriptName} falhou com código ${code}`));
    });
  });
}

function askQuestion(question) {
  const rl = createInterface({
    input: process.stdin,
    output: process.stdout
  });

  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      resolve(answer.toLowerCase().trim());
    });
  });
}

async function askYesNo(question, defaultValue = 'n') {
  const suffix = defaultValue === 'y' ? '[Y/n]' : '[y/N]';
  const answer = await askQuestion(`${colorize(question, 'bright')} ${colorize(suffix, 'cyan')}: `);
  
  if (answer === '') return defaultValue === 'y';
  return answer === 'y' || answer === 'yes';
}

function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function checkDirectusHealth(url) {
  try {
    const response = await fetch(`${url}/server/health`, {
      method: 'GET',
      timeout: 3000
    });
    return response.ok;
  } catch {
    return false;
  }
}

async function waitForDirectus() {
  const directusUrl = process.env.PUBLIC_URL || 'http://localhost:8055';
  const maxRetries = 36; // 3 minutos (5s * 36)
  const spinner = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
  let attempt = 0;
  
  printInfo(`Aguardando Directus estar online em ${colorize(directusUrl, 'cyan')}...`);

  while (attempt < maxRetries) {
    const spinnerChar = spinner[attempt % spinner.length];
    const elapsed = Math.floor(attempt * 5);
    process.stdout.write(`\r${colorize(spinnerChar, 'cyan')} Verificando saúde do Directus... ${colorize(`(${elapsed}s)`, 'gray')}   `);
    
    const isHealthy = await checkDirectusHealth(directusUrl);
    
    if (isHealthy) {
      process.stdout.write('\r' + ' '.repeat(60) + '\r');
      printSuccess(`Directus está online! (${elapsed}s)`);
      return true;
    }
    
    await delay(5000); // 5 segundos entre tentativas
    attempt++;
  }
  
  process.stdout.write('\r' + ' '.repeat(60) + '\r');
  printWarning('Timeout: Directus não ficou online em 3 minutos.');
  return false;
}

async function main() {
  printHeader('BATE PALCO • SETUP INTERATIVO');
  
  const targetDb = process.env.DB_DATABASE || 'batepalco_test';
  
  printWarning('Setup completo da aplicação Bate Palco');
  console.log(`   Database: ${colorize(targetDb, 'yellow')}`);
  console.log(`   Ambiente: ${colorize(process.env.NODE_ENV || 'development', 'cyan')}`);
  console.log('');

  try {
    // Etapa 1: Drop Database
    console.log('');
    printStep('1️⃣', 'DROP DATABASE', 'Remove a database existente (DESTRUTIVO!)');
    const shouldDropDb = await askYesNo('Dropar a database existente?');
    
    if (shouldDropDb) {
      console.log('');
      printInfo('Dropando database...');
      await runScript('reset-db', { FORCE: '1' });
      printSuccess('Database dropada!');
    } else {
      printInfo('Drop database pulado.');
    }

    // Etapa 2: Create Database
    console.log('');
    printStep('2️⃣', 'CREATE DATABASE', 'Cria uma nova database limpa');
    const shouldCreateDb = await askYesNo('Criar nova database?', shouldDropDb ? 'y' : 'n');
    
    if (shouldCreateDb && !shouldDropDb) {
      console.log('');
      printInfo('Criando database...');
      await runScript('reset-db', { FORCE: '1', CREATE_ONLY: '1' });
      printSuccess('Database criada!');
    } else if (shouldCreateDb) {
      printInfo('Database já foi criada no passo anterior.');
    } else {
      printInfo('Criação de database pulada.');
    }

    // Etapa 3: Initialize (Bootstrap)
    console.log('');
    printStep('3️⃣', 'INITIALIZE', 'Aplica estrutura básica do Directus (bootstrap)');
    printWarning('   Certifique-se de que o servidor está PARADO!');
    const shouldInitialize = await askYesNo('Executar bootstrap?', 'y');
    
    if (shouldInitialize) {
      console.log('');
      printInfo('Executando bootstrap...');
      await runScript('initialize');
      printSuccess('Bootstrap concluído!');
    } else {
      printInfo('Bootstrap pulado.');
    }

    // Etapa 4: Start Server
    console.log('');
    printStep('4️⃣', 'START SERVER', 'Aguarda o servidor Directus estar online');
    printInfo('   Execute: docker-compose up -d  ou  npm run dev');
    const shouldWaitServer = await askYesNo('Aguardar servidor online?', 'y');
    
    if (shouldWaitServer) {
      console.log('');
      const serverOnline = await waitForDirectus();
      if (!serverOnline) {
        const continueAnyway = await askYesNo('Servidor não respondeu. Continuar mesmo assim?');
        if (!continueAnyway) {
          printError('Setup cancelado. Inicie o servidor e execute novamente.');
          process.exit(1);
        }
      }
    } else {
      printInfo('Aguardar servidor pulado.');
    }

    // Etapa 5: Apply Snapshot
    console.log('');
    printStep('5️⃣', 'APPLY SNAPSHOT', 'Aplica schema customizado (batepalco.yaml)');
    const shouldSnapshot = await askYesNo('Aplicar snapshot do schema?', 'y');
    
    if (shouldSnapshot) {
      console.log('');
      printInfo('Aplicando snapshot...');
      await runScript('snapshot:apply');
      printSuccess('Snapshot aplicado!');
    } else {
      printInfo('Snapshot pulado.');
    }

    // Etapa 6: Apply Policies
    console.log('');
    printStep('6️⃣', 'APPLY POLICIES', 'Configura permissões e políticas de acesso');
    const shouldPolicies = await askYesNo('Aplicar políticas?', 'y');
    
    if (shouldPolicies) {
      console.log('');
      printInfo('Aplicando políticas...');
      await runScript('policies');
      printSuccess('Políticas aplicadas!');
    } else {
      printInfo('Políticas puladas.');
    }

    // Etapa 7: Apply Data
    console.log('');
    printStep('7️⃣', 'APPLY DATA', 'Popula com dados demo (usuários, músicas, lives)');
    const shouldData = await askYesNo('Popular com dados demo?', 'y');
    
    if (shouldData) {
      console.log('');
      printInfo('Populando dados demo...');
      await runScript('data');
      printSuccess('Dados demo populados!');
    } else {
      printInfo('Dados demo pulados.');
    }

    // Setup completo
    console.log('');
    printHeader('🎉 SETUP CONCLUÍDO!');
    
    console.log(colorize('📋 Resumo das etapas executadas:', 'bright'));
    console.log(`   ${shouldDropDb ? '✅' : '⏭️'} Drop Database`);
    console.log(`   ${shouldCreateDb ? '✅' : '⏭️'} Create Database`);
    console.log(`   ${shouldInitialize ? '✅' : '⏭️'} Initialize (Bootstrap)`);
    console.log(`   ${shouldWaitServer ? '✅' : '⏭️'} Start Server`);
    console.log(`   ${shouldSnapshot ? '✅' : '⏭️'} Apply Snapshot`);
    console.log(`   ${shouldPolicies ? '✅' : '⏭️'} Apply Policies`);
    console.log(`   ${shouldData ? '✅' : '⏭️'} Apply Data`);
    console.log('');
    
    console.log(colorize('🔗 Links úteis:', 'bright'));
    console.log(`   ${colorize('Admin:', 'cyan')} http://localhost:8055`);
    console.log(`   ${colorize('API:', 'cyan')} http://localhost:8055/items/songs`);
    console.log(`   ${colorize('Health:', 'cyan')} http://localhost:8055/server/health`);
    console.log('');
    
    if (shouldData) {
      console.log(colorize('👥 Usuários criados:', 'bright'));
      console.log(`   ${colorize('Cantores:', 'cyan')} singer1@gmail.com ... singer20@gmail.com`);
      console.log(`   ${colorize('Clientes:', 'cyan')} client1@gmail.com ... client100@gmail.com`);
      console.log(`   ${colorize('Senha:', 'cyan')} 123456`);
      console.log('');
    }

  } catch (error) {
    console.log('');
    printError(`Falha no setup: ${error.message}`);
    console.log('');
    
    if (DEBUG && error.stack) {
      console.log(colorize('Stack trace:', 'red'));
      console.log(error.stack);
    }
    
    console.log('');
    printInfo('Comandos para execução manual:');
    console.log(`   ${colorize('1.', 'yellow')} npm run reset-db`);
    console.log(`   ${colorize('2.', 'yellow')} npm run initialize`);
    console.log(`   ${colorize('3.', 'yellow')} docker-compose up -d`);
    console.log(`   ${colorize('4.', 'yellow')} npm run snapshot:apply`);
    console.log(`   ${colorize('5.', 'yellow')} npm run policies`);
    console.log(`   ${colorize('6.', 'yellow')} npm run data`);
    console.log('');
    
    process.exit(1);
  }
}

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('');
  printWarning('Setup interrompido pelo usuário.');
  process.exit(0);
});

main();