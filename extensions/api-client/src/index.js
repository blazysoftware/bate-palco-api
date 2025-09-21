import { defineEndpoint } from '@directus/extensions-sdk';

export default defineEndpoint((router, context) => {
	const { services, database, getSchema, logger } = context;

	function requireRole(allowedRoles) {
		return (req, res, next) => {
			if (!req.accountability?.user) {
				return res.status(401).json({ error: 'Autenticação necessária' });
			}
			
			if (!allowedRoles.includes(req.accountability.role)) {
				return res.status(403).json({ 
					error: `Acesso negado. Roles permitidas: ${allowedRoles.join(', ')}` 
				});
			}
			
			next();
		};
	}

	// GET - Listar sessões públicas com suas mensagens
	router.get('/', async (req, res, next) => {
		try {
			const schema = await getSchema();
			
			// Service para buscar lives públicas
			const livesService = new services.ItemsService('lives', {
				schema,
				accountability: req.accountability,
			});

			// Service para buscar sessões das lives
			const liveSessionsService = new services.ItemsService('live_sessions', {
				schema,
				accountability: req.accountability,
			});

			// Service para buscar mensagens das sessões
			const messagesService = new services.ItemsService('messages', {
				schema,
				accountability: req.accountability,
			});

			const { limit = 10, offset = 0, search } = req.query;
			
			// Filtro para lives públicas
			let liveFilter = {
				is_public: { _eq: true }
			};
			
			if (search) {
				liveFilter.name = {
					_contains: search
				};
			}

			// Buscar lives públicas
			const publicLives = await livesService.readByQuery({
				limit: parseInt(limit),
				offset: parseInt(offset),
				filter: liveFilter,
				fields: ['id', 'name', 'slug', 'status', 'date_event', 'singer.id', 'singer.first_name', 'singer.stage_name']
			});

			// Para cada live, buscar suas sessões e mensagens
			const livesWithSessions = await Promise.all(
				publicLives.map(async (live) => {
					// Buscar sessões da live
					const sessions = await liveSessionsService.readByQuery({
						filter: { live: { _eq: live.id } },
						fields: ['id', 'name', 'status', 'started_at', 'ended_at', 'artist.id', 'artist.first_name', 'artist.stage_name']
					});

					// Para cada sessão, buscar suas mensagens
					const sessionsWithMessages = await Promise.all(
						sessions.map(async (session) => {
							const messages = await messagesService.readByQuery({
								filter: { 
									session: { _eq: session.id },
									is_hidden: { _neq: true }
								},
								fields: ['id', 'sender_name', 'sender_user.id', 'sender_user.first_name', 'sender_user.stage_name', 'content', 'sent_at', 'is_super'],
								sort: ['sent_at']
							});

							return {
								...session,
								messages
							};
						})
					);

					return {
						...live,
						sessions: sessionsWithMessages
					};
				})
			);

			logger.info('API Custom: Lista de sessões públicas acessada', { 
				user: req.accountability?.user,
				count: livesWithSessions.length 
			});

			res.json({
				data: livesWithSessions,
				meta: {
					limit: parseInt(limit),
					offset: parseInt(offset),
					total_count: livesWithSessions.length
				}
			});
		} catch (error) {
			logger.error('Erro ao listar sessões públicas:', error);
			next(error);
		}
	});

	// GET - Obter item específico
	router.get('/:id', async (req, res, next) => {
		try {
			const schema = await getSchema();
			const itemsService = new services.ItemsService('directus_users', {
				schema,
				accountability: req.accountability,
			});

			const result = await itemsService.readOne(req.params.id, {
				fields: ['id', 'first_name', 'last_name', 'email', 'status', 'role']
			});

			logger.info('API Custom: Usuário específico acessado', { 
				user: req.accountability?.user,
				target_user: req.params.id 
			});

			res.json({ data: result });
		} catch (error) {
			logger.error('Erro ao obter usuário:', error);
			next(error);
		}
	});

	// POST - Criar novo item
	router.post('/', requireRole(['admin']), async (req, res, next) => {
		try {
			// Verificar autenticação
			if (!req.accountability?.user) {
				return res.status(401).json({ 
					error: 'Acesso negado. Autenticação necessária.' 
				});
			}

			// Validação básica
			const { first_name, last_name, email } = req.body;
			if (!first_name || !last_name || !email) {
				return res.status(400).json({
					error: 'Campos obrigatórios: first_name, last_name, email'
				});
			}

			const schema = await getSchema();
			const usersService = new services.UsersService({
				schema,
				accountability: req.accountability,
			});

			const newUser = await usersService.createOne({
				first_name,
				last_name,
				email,
				status: 'invited',
				role: req.body.role || null
			});

			logger.info('API Custom: Novo usuário criado', { 
				user: req.accountability.user,
				new_user: newUser 
			});

			res.status(201).json({ 
				data: newUser,
				message: 'Usuário criado com sucesso' 
			});
		} catch (error) {
			logger.error('Erro ao criar usuário:', error);
			next(error);
		}
	});

	// PUT - Atualizar item
	router.put('/:id', requireRole(['admin', 'editor']), async (req, res, next) => {
		try {
			if (!req.accountability?.user) {
				return res.status(401).json({ 
					error: 'Acesso negado. Autenticação necessária.' 
				});
			}

			const schema = await getSchema();
			const usersService = new services.UsersService({
				schema,
				accountability: req.accountability,
			});

			const allowedFields = ['first_name', 'last_name', 'status'];
			const updateData = {};
			
			for (const field of allowedFields) {
				if (req.body[field] !== undefined) {
					updateData[field] = req.body[field];
				}
			}

			if (Object.keys(updateData).length === 0) {
				return res.status(400).json({
					error: 'Nenhum campo válido para atualização fornecido'
				});
			}

			const updatedUser = await usersService.updateOne(req.params.id, updateData);

			logger.info('API Custom: Usuário atualizado', { 
				user: req.accountability.user,
				updated_user: req.params.id,
				fields: Object.keys(updateData)
			});

			res.json({ 
				data: updatedUser,
				message: 'Usuário atualizado com sucesso' 
			});
		} catch (error) {
			logger.error('Erro ao atualizar usuário:', error);
			next(error);
		}
	});

	// DELETE - Remover item
	router.delete('/:id', async (req, res, next) => {
		try {
			if (!req.accountability?.user) {
				return res.status(401).json({ 
					error: 'Acesso negado. Autenticação necessária.' 
				});
			}

			const schema = await getSchema();
			const usersService = new services.UsersService({
				schema,
				accountability: req.accountability,
			});

			await usersService.deleteOne(req.params.id);

			logger.info('API Custom: Usuário removido', { 
				user: req.accountability.user,
				deleted_user: req.params.id 
			});

			res.json({ 
				message: 'Usuário removido com sucesso' 
			});
		} catch (error) {
			logger.error('Erro ao remover usuário:', error);
			next(error);
		}
	});

	// Endpoint customizado para estatísticas
	router.get('/stats/overview', async (req, res, next) => {
		try {
			if (!req.accountability?.user) {
				return res.status(401).json({ 
					error: 'Acesso negado. Autenticação necessária.' 
				});
			}

			const schema = await getSchema();
			const itemsService = new services.ItemsService('directus_users', {
				schema,
				accountability: req.accountability,
			});

			const totalUsers = await itemsService.readByQuery({
				aggregate: { count: '*' }
			});

			const activeUsers = await itemsService.readByQuery({
				filter: { status: { _eq: 'active' } },
				aggregate: { count: '*' }
			});

			const invitedUsers = await itemsService.readByQuery({
				filter: { status: { _eq: 'invited' } },
				aggregate: { count: '*' }
			});

			logger.info('API Custom: Estatísticas acessadas', { 
				user: req.accountability.user 
			});

			res.json({
				data: {
					total_users: totalUsers[0].count,
					active_users: activeUsers[0].count,
					invited_users: invitedUsers[0].count,
					generated_at: new Date().toISOString()
				}
			});
		} catch (error) {
			logger.error('Erro ao obter estatísticas:', error);
			next(error);
		}
	});
});
