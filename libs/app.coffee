app = module.exports = require("./express")
fileLoader = require("./fileLoader")

# An Array with all Mongoose Model Objects
models = fileLoader.getFilesFor('models')

# Require all available controllers
controllers = fileLoader.getFilesFor('controllers')

# Require all available middlewares
middlewares = fileLoader.getFilesFor('middlewares')

routes = require("./routes")
routes(app, controllers, middlewares)