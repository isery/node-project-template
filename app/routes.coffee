routes = module.exports = (app, controllers, middleware) ->
	app.get '/rest/:id', controllers.items.get
	app.get '/rest', controllers.items.getAll
	app.post '/rest', controllers.items.post
	app.delete '/rest/:id', controllers.items.delete
	app.put '/rest/:id', controllers.items.put