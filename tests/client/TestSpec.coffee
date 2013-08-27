define ["jquery", "chai"], ($, chai) ->
	describe "just checking", ->
		it "works for jQuery", ->
			chai.expect($).to.a "function"
