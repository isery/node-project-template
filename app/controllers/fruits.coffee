_ = require('lodash')
ResponseObject = require('../libs/responseobject')
ErrorObject = require('../libs/errorobject')
fruits = require('../models/fruits')



###*
	** @api {get} /fruits/ Get all fruits
	* @apiVersion 0.0.1
	* @apiName getAll
	*
	*
	* @apiDescription Get all fruits
	*
	* @apiSuccess {Array}	result requested data
	*
	* @apiExample Example usage:
	*		curl -X GET -H Content-Type: application/json"  http://localhost/fruits/
	*
	* @apiSuccessExample Success-Response:
	*     HTTP/1.1 200 OK
	*     {
	*       result: [
	*         {"id" : 1, "name":"apple"},
	*         {"id" : 2, "name":"banana"}
	*       ]
	*     }
	*
	* @apiError NoData No data available
	* @apiErrorExample Response (example):
	*     HTTP/1.1 400 Bad Request
	*     {
	*       "error": "NoData"
	*     }
###
exports.getAll = (request, response) ->
	result = fruits.getAll()
	if _.isEmpty(result)
		object = new ErrorObject('NoData')
		response.statusCode = 400
		return response.json object
	object = new ResponseObject(result)
	response.json object

###*
	** @api {get} /fruits/:id Get fruit
	* @apiVersion 0.0.1
	* @apiName get
	*
	* @apiDescription Get one fruit
	*
	* @apiParam {Number} id id of the fruit
	*
	* @apiSuccess {Array}	result	requested data
	*	@apiExample Example usage:
	*		curl -X GET -H Content-Type: application/json"  http://localhost/fruits/1
	*
	* @apiSuccessExample Success-Response:
	*     HTTP/1.1 200 OK
	*     {
	*       "result": [{"id" : 1, "name": "apple"}]
	*     }
	*
	* @apiError NoValidId The given ID is invalid
###
exports.get = (request, response) ->
	id = parseInt(request.params.id)
	if _.isNaN(id)
		object = new ErrorObject('NoValidId')
		response.statusCode = 400
		return response.json object
	result = fruits.get(id)
	object = new ResponseObject(result)
	response.json object


###*
	** @api {post} /fruits/ Create fruit
	* @apiVersion 0.0.1
	* @apiName	post
	*
	* @apiDescription	Create one fruit
	*
	* @apiParam	{String}	name name of the fruit
	*
	* @apiSuccess	{Array}	result	created fruit
	*
	* @apiExample Example usage:
	*		curl -X POST -H "Content-Type: application/json" -d '{"name":"coconut"}' http://localhost/fruits/
	*
	* @apiSuccessExample Success-Response:
	*     HTTP/1.1 200 OK
	*     {
	*       "result": [{"id" : 3, "name" : "coconut"}]
	*     }
	*
	* @apiError	InvalidParamsName	The given name is invalid
	* @apiErrorExample Response (example):
	*     HTTP/1.1 400 Bad Request
	*     {
	*       "error": "InvalidParamsName"
	*     }
###
exports.post = (request, response) ->
	unless request.body.hasOwnProperty("fruit")
		object = new ErrorObject('InvalidParamsName')
		response.statusCode = 400
		return response.json object
	fruit = fruits.create(request.body.fruit)
	object = new ResponseObject(fruit)
	response.json object

###*
	** @api {put} /fruits/:id Update fruit
	* @apiVersion 0.0.1
	* @apiName put
	*
	* @apiDescription Update one fruit
	*
	* @apiParam {Number}	id	id of the fruit
	* @apiParam {String}	name	name of the fruit
	*
	* @apiSuccess {Array}	result	updated fruit
	* @apiExample Example usage:
	*		curl -X PUT -H "Content-Type: application/json" -d '{"name":"pear"}' http://localhost/fruits/3
	*
	* @apiSuccessExample Success-Response:
	*     HTTP/1.1 200 OK
	*     {
	*       "result": [{"id" : 3, "name" : "pear"}}]
	*     }
	*
	*
	* @apiError InvalidParamsName The given name is invalid
	* @apiError InvalidParamsId The given ID is invalid
###
exports.put = (request, response) ->
	id = parseInt(request.params.id)
	unless request.body.hasOwnProperty("fruit")
		object = new ErrorObject('InvalidParamsName')
		response.statusCode = 400
		return response.json object
	if _.isNaN(id)
		object = new ErrorObject('InvalidParamsId')
		response.statusCode = 400
		return response.json object
	fruits.update(id, request.body.fruit)
	object = new ResponseObject(fruits.get(id))
	response.json object

###*
	** @api {delete} /fruits/:id Delete fruit
	* @apiVersion 0.0.1
	* @apiName delete
	*
	* @apiDescription Delete one fruit
	*
	* @apiParam {Number}	id id of the fruit
	*
	* @apiSuccess {Array}	result deleted fruit
	*	@apiExample Example usage:
	*		curl -X DELETE -H "Content-Type: application/json"  http://localhost/fruits/1
	*
	* @apiSuccessExample Success-Response:
	*     HTTP/1.1 200 OK
	*     {
	*       "result": [{"id" : 1}]
	*     }
	*
	* @apiError InvalidParamsId The given ID is invalid
###
exports.delete = (request, response) ->
	id = parseInt(request.params.id)
	if _.isNaN(id)
		object = new ErrorObject('InvalidParamsId')
		response.statusCode = 400
		return response.json object
	deletedFruit = fruits.delete(id)
	object = new ResponseObject(deletedFruit)
	response.json object