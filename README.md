# bate-palco-api

API do projeto Bate Palco

## Descrição
O bate-palco-api é uma API desenvolvida para gerenciar e fornecer recursos para o projeto Bate Palco, uma plataforma voltada para cantores, músicos e organizadores de eventos. O objetivo é facilitar o cadastro, busca e gerenciamento de artistas, eventos e repertórios, promovendo a integração entre músicos e público.

## Funcionalidades
- Cadastro e autenticação de usuários
- Gerenciamento de artistas e bandas
- Cadastro de eventos e shows
- Gerenciamento de repertórios e músicas
- Busca e filtragem de eventos e artistas
- Integração com plataformas externas (em breve)

## Tecnologias Utilizadas
- Node.js
- Express.js
- PostgreSQL
- JWT para autenticação
- Outras dependências modernas do ecossistema JavaScript

## Como rodar o projeto
1. Instale as dependências:
	```bash
	npm install
	```

2. Configure as variáveis de ambiente no arquivo `.env` (exemplo disponível em `.env.example`).

3. Execute o script de inicialização (initialize) para preparar o ambiente:
	```bash
	npm run initialize
	```
	Esse comando realiza tarefas essenciais antes do build, como criação de tabelas no banco de dados, inserção de dados iniciais (seed) e outras configurações necessárias para o funcionamento do projeto.

4. Inicie o servidor de desenvolvimento:
	```bash
	npm run dev
	```

## Scripts úteis
- `npm run dev`: Inicia o servidor em modo desenvolvimento
- `npm run build`: Compila o projeto para produção
- `npm run start`: Inicia o servidor em modo produção

## Contribuição
Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests.

## Licença
Este projeto está sob a licença MIT.

---

Desenvolvido por Blazy Software.
