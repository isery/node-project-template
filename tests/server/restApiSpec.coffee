chai = require 'chai'
expect = chai.expect
request = require 'supertest'
server = require '../../index'
console.log server
newRequest = request server

describe 'Rest API', ->
	it 'get request to wrong url should return 404', ->
		newRequest.get('/ret').end (error,response) ->
			expect(response.statusCode).to.equal 404
	it 'get request to /rest should return a valid object', ->
		newRequest.get('/rest').end (error,response) ->
			expect(response.statusCode).to.equal 200
			expect(response.body).to.a 'Object'
			expect(response.body.result).to.have.length.above 0
			expect(response.body.success).to.be.true
			expect(response.body.message).to.exist
			expect(response.body.message).to.be.empty
	it 'get request to /rest/1 should return a valid object', ->
		newRequest.get('/rest/1').end (error,response) ->
			expect(response.statusCode).to.equal 200
			expect(response.body).to.a 'Object'
			expect(response.body.result).to.have.length.above 0
			expect(response.body.success).to.be.true
			expect(response.body.message).to.exist
			expect(response.body.message).to.be.empty
	it 'get request to /rest/a should not return a valid object', ->
		newRequest.get('/rest/a').end (error,response) ->
			expect(response.statusCode).to.equal 400
			expect(response.body).to.a 'Object'
			expect(response.body.result).to.be.empty
			expect(response.body.success).to.be.false
			expect(response.body.message).to.exist
			expect(response.body.message).to.not.be.empty
	it 'post request to /rest should return a success', ->
		newRequest.post('/rest').send({item:'third'}).end (error,response) ->
			expect(response.statusCode).to.equal 200
			expect(response.body).to.a 'Object'
			expect(response.body.result).to.be.empty
			expect(response.body.success).to.be.true
			expect(response.body.message).to.exist
			expect(response.body.message).to.be.empty
	it 'get request to /rest should return a valid object with the saved value', ->
		newRequest.get('/rest').end (error,response) ->
			expect(response.statusCode).to.equal 200
			expect(response.body).to.a 'Object'
			expect(response.body.result).to.include('third')
	it 'post request to /rest with wrong data should not return a valid object', ->
		newRequest.post('/rest').send({asdf:'third'}).end (error,response) ->
			expect(response.statusCode).to.equal 400
			expect(response.body).to.a 'Object'
			expect(response.body.result).to.be.empty
			expect(response.body.success).to.be.false
			expect(response.body.message).to.exist
			expect(response.body.message).to.not.be.empty
	it 'post request to /rest should return a success', ->
		newRequest.del('/rest/2').end (error,response) ->
			expect(response.statusCode).to.equal 200
			expect(response.body).to.a 'Object'
			expect(response.body.result).to.be.empty
			expect(response.body.success).to.be.true
			expect(response.body.message).to.exist
			expect(response.body.message).to.be.empty
	it 'get request to /rest should return a valid object but not with deleted value', ->
		newRequest.get('/rest').end (error,response) ->
			expect(response.statusCode).to.equal 200
			expect(response.body).to.a 'Object'
			expect(response.body.result).to.not.include('third')
	it 'put request to /rest/1 should return a success', ->
		newRequest.put('/rest/1').send({item:'replaced'}).end (error,response) ->
			expect(response.statusCode).to.equal 200
			expect(response.body).to.a 'Object'
			expect(response.body.result).to.be.empty
			expect(response.body.success).to.be.true
			expect(response.body.message).to.exist
			expect(response.body.message).to.be.empty
	it 'get request to /rest should return a valid object with the replaced value', ->
		newRequest.get('/rest').end (error,response) ->
			expect(response.statusCode).to.equal 200
			expect(response.body).to.a 'Object'
			expect(response.body.result).to.include('replaced')
			expect(response.body.result).to.not.include('second')