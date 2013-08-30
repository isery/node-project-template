fs = require("fs")
path = require("path")

module.exports = (basedir, allowedExtension) ->
	return (domain) ->
		filePath = path.normalize(basedir + '/' + domain)
		data = module.exports = {}
		files = fs.readdirSync(filePath)
		files.forEach (file) ->
			extension = path.extname(file)
			fileName = path.basename(file, extension)

			# Check if file is a .js file. Since no other type is valid in our case
			return  if extension isnt ".#{allowedExtension}"
			filePath = filePath + "/" + fileName
			console.log "Adding express #{domain} #{fileName} #{extension}"
			data[fileName] = require(filePath)
		data