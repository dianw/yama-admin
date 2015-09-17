'use strict'

class App extends Controller
	constructor: ($state) ->
		$state.go('app.backend');
