fs = require("fs")
path = require("path")

exports.getFilesFor = (domain) ->
	filePath = path.normalize(__dirname + '/../'+domain)
	data = module.exports = {}
	files = fs.readdirSync(filePath)
	files.forEach (file) ->
		extension = path.extname(file)
		fileName = path.basename(file, extension)
		dataName = fileName.replace(/([a-zA-Z0-9]*)+/, "$1")

		# Check if file is a .js file. Since no other type is valid in our case
		return  if extension isnt ".js"
		filePath = filePath + "/" + fileName
		console.log "Adding express "+domain+ ": '" + dataName + "'"
		data[dataName] = require(filePath)
	data