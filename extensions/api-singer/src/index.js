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

	// GET - Listar lives do singer logado com suas sessões e mensagens
	router.get('/', requireRole(['singer']), async (req, res, next) => {
		try {
			const schema = await getSchema();
			
			// Service para buscar lives do singer
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
			
			// Filtro para lives do singer logado
			let liveFilter = {
				singer: { _eq: req.accountability.user }
			};
			
			if (search) {
				liveFilter.name = {
					_contains: search
				};
			}

			// Buscar lives do singer
			const singerLives = await livesService.readByQuery({
				limit: parseInt(limit),
				offset: parseInt(offset),
				filter: liveFilter,
				fields: ['id', 'name', 'slug', 'status', 'date_event', 'is_public', 'reusable']
			});

			// Para cada live, buscar suas sessões e mensagens
			const livesWithSessions = await Promise.all(
				singerLives.map(async (live) => {
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

			logger.info('API Singer: Lista de lives do singer acessada', { 
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
			logger.error('Erro ao listar lives do singer:', error);
			next(error);
		}
	});

	// GET - Obter live específica do singer
	router.get('/:id', requireRole(['singer']), async (req, res, next) => {
		try {
			const schema = await getSchema();
			const livesService = new services.ItemsService('lives', {
				schema,
				accountability: req.accountability,
			});

			// Verificar se a live pertence ao singer logado
			const result = await livesService.readOne(req.params.id, {
				fields: ['id', 'name', 'slug', 'status', 'date_event', 'is_public', 'reusable', 'singer'],
				filter: {
					singer: { _eq: req.accountability.user }
				}
			});

			logger.info('API Singer: Live específica acessada', { 
				user: req.accountability?.user,
				live_id: req.params.id 
			});

			res.json({ data: result });
		} catch (error) {
			logger.error('Erro ao obter live do singer:', error);
			next(error);
		}
	});

	// POST - Criar nova live
	router.post('/', requireRole(['singer']), async (req, res, next) => {
		try {
			// Validação básica
			const { name, date_event } = req.body;
			if (!name || !date_event) {
				return res.status(400).json({
					error: 'Campos obrigatórios: name, date_event'
				});
			}

			const schema = await getSchema();
			const livesService = new services.ItemsService('lives', {
				schema,
				accountability: req.accountability,
			});

			const newLive = await livesService.createOne({
				name,
				date_event,
				singer: req.accountability.user,
				status: req.body.status || 'scheduled',
				is_public: req.body.is_public || false,
				reusable: req.body.reusable || false,
				slug: req.body.slug || name.toLowerCase().replace(/\s+/g, '-'),
				max_messages_per_client: req.body.max_messages_per_client || 10,
				comment_cooldown_seconds: req.body.comment_cooldown_seconds || 30,
				max_song_requests_per_client: req.body.max_song_requests_per_client || 5
			});

			logger.info('API Singer: Nova live criada', { 
				user: req.accountability.user,
				live_id: newLive 
			});

			res.status(201).json({ 
				data: newLive,
				message: 'Live criada com sucesso' 
			});
		} catch (error) {
			logger.error('Erro ao criar live:', error);
			next(error);
		}
	});

	// PUT - Atualizar live
	router.put('/:id', requireRole(['singer']), async (req, res, next) => {
		try {
			const schema = await getSchema();
			const livesService = new services.ItemsService('lives', {
				schema,
				accountability: req.accountability,
			});

			// Verificar se a live pertence ao singer
			const existingLive = await livesService.readOne(req.params.id, {
				fields: ['singer'],
				filter: {
					singer: { _eq: req.accountability.user }
				}
			});

			if (!existingLive) {
				return res.status(404).json({
					error: 'Live não encontrada ou não pertence ao singer'
				});
			}

			const allowedFields = ['name', 'date_event', 'status', 'is_public', 'reusable', 'max_messages_per_client', 'comment_cooldown_seconds', 'max_song_requests_per_client'];
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

			const updatedLive = await livesService.updateOne(req.params.id, updateData);

			logger.info('API Singer: Live atualizada', { 
				user: req.accountability.user,
				live_id: req.params.id,
				fields: Object.keys(updateData)
			});

			res.json({ 
				data: updatedLive,
				message: 'Live atualizada com sucesso' 
			});
		} catch (error) {
			logger.error('Erro ao atualizar live:', error);
			next(error);
		}
	});

	// DELETE - Remover live
	router.delete('/:id', requireRole(['singer']), async (req, res, next) => {
		try {
			const schema = await getSchema();
			const livesService = new services.ItemsService('lives', {
				schema,
				accountability: req.accountability,
			});

			// Verificar se a live pertence ao singer
			const existingLive = await livesService.readOne(req.params.id, {
				fields: ['singer'],
				filter: {
					singer: { _eq: req.accountability.user }
				}
			});

			if (!existingLive) {
				return res.status(404).json({
					error: 'Live não encontrada ou não pertence ao singer'
				});
			}

			await livesService.deleteOne(req.params.id);

			logger.info('API Singer: Live removida', { 
				user: req.accountability.user,
				live_id: req.params.id 
			});

			res.json({ 
				message: 'Live removida com sucesso' 
			});
		} catch (error) {
			logger.error('Erro ao remover live:', error);
			next(error);
		}
	});

	// Endpoint para estatísticas do singer
	router.get('/stats/overview', requireRole(['singer']), async (req, res, next) => {
		try {
			const schema = await getSchema();
			const livesService = new services.ItemsService('lives', {
				schema,
				accountability: req.accountability,
			});

			const messagesService = new services.ItemsService('messages', {
				schema,
				accountability: req.accountability,
			});

			const requestsService = new services.ItemsService('requests', {
				schema,
				accountability: req.accountability,
			});

			// Estatísticas das lives do singer
			const totalLives = await livesService.readByQuery({
				filter: { singer: { _eq: req.accountability.user } },
				aggregate: { count: '*' }
			});

			const activeLives = await livesService.readByQuery({
				filter: { 
					singer: { _eq: req.accountability.user },
					status: { _eq: 'active' }
				},
				aggregate: { count: '*' }
			});

			const publicLives = await livesService.readByQuery({
				filter: { 
					singer: { _eq: req.accountability.user },
					is_public: { _eq: true }
				},
				aggregate: { count: '*' }
			});

			// Buscar IDs das lives do singer para estatísticas de mensagens e requests
			const singerLives = await livesService.readByQuery({
				filter: { singer: { _eq: req.accountability.user } },
				fields: ['id']
			});

			const liveIds = singerLives.map(live => live.id);

			let totalMessages = [{ count: 0 }];
			let totalRequests = [{ count: 0 }];

			if (liveIds.length > 0) {
				totalMessages = await messagesService.readByQuery({
					filter: { live: { _in: liveIds } },
					aggregate: { count: '*' }
				});

				totalRequests = await requestsService.readByQuery({
					filter: { live: { _in: liveIds } },
					aggregate: { count: '*' }
				});
			}

			logger.info('API Singer: Estatísticas acessadas', { 
				user: req.accountability.user 
			});

			res.json({
				data: {
					total_lives: totalLives[0].count,
					active_lives: activeLives[0].count,
					public_lives: publicLives[0].count,
					total_messages: totalMessages[0].count,
					total_requests: totalRequests[0].count,
					generated_at: new Date().toISOString()
				}
			});
		} catch (error) {
			logger.error('Erro ao obter estatísticas do singer:', error);
			next(error);
		}
	});
});
