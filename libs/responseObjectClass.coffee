class ResponseObject
	constructor: (success, message, result) ->
		@success = success
		@message = message
		@result = result

module.exports = ResponseObject
