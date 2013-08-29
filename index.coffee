###
Module dependencies.
###
express = require("express")
controllers = require("./controllers/items")
http = require("http")
path = require("path")
app = express()


# all environments
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "jade"
app.use express.favicon()

app.use(express.logger('dev'))
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

# development only
app.use express.errorHandler()  if "development" is app.get("env")

app.get '/rest/:id', controllers.get
app.get '/rest', controllers.getAll
app.post '/rest', controllers.post
app.delete '/rest/:id', controllers.delete
app.put '/rest/:id', controllers.put

http.createServer(app).listen app.get("port"), ->
	console.log "Express server listening on port " + app.get("port")

module.exports = app
