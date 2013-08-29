express = require("express")
app = express()
app.use "/", require("./libs/app")
port = process.env.APP_PORT or 13001
app.listen port, ->
	console.log "Listening on https://localhost:" + port
