_ = require('lodash')
responseObject = require('../libs/responseObjectClass')
items = require('../models/items')


# GET /api/users
exports.getAll = (request, response) ->
	result = items.getAll()
	object = new responseObject(true,'',result)
	response.json object

# GET /api/users/1
exports.get = (request, response) ->
	id = parseInt(request.params.id)
	if _.isNaN(id)
		object = new responseObject(false,'Not a valid ID',[])
		response.statusCode = 400
		return response.json object
	result = items.get(id)
	object = new responseObject(true,'',result)
	response.json object

# POST /api/users
exports.post = (request, response) ->
	unless request.body.hasOwnProperty("item")
		object = new responseObject(false,'Not item sent',[])
		response.statusCode = 400
		return response.json object
	items.create(request.body.item)
	object = new responseObject(true,'',[])
	response.json object

# PUT /api/users/1
exports.put = (request, response) ->
	id = parseInt(request.params.id)
	unless request.body.hasOwnProperty("item")
		object = new responseObject(false,'Not item sent',[])
		response.statusCode = 400
		return response.json object
	items.update(id, request.body.item)
	object = new responseObject(true,'',[])
	response.json object

# DELETE /api/users/1
exports.delete = (request, response) ->
	id =  parseInt(request.params.id)
	if _.isNaN(id)
		object = new responseObject(false,'Not a valid id',[])
		response.statusCode = 400
		return response.json object
	items.delete(id)
	object = new responseObject(true,'',[])
	response.json object