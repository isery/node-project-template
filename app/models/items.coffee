items = ['first', 'second']

exports.get = (id) ->
	items[id]

exports.getAll = () ->
	items

exports.create = (data) ->
	items.push data

exports.update = (id, data) ->
	items[id] = data

exports.delete = (id) ->
	items.splice id, 1

