routes = module.exports = (app, controllers, middleware) ->
	app.get '/rest/:id', controllers.fruits.get
	app.get '/rest', controllers.fruits.getAll
	app.post '/rest', controllers.fruits.post
	app.delete '/rest/:id', controllers.fruits.delete
	app.put '/rest/:id', controllers.fruits.put