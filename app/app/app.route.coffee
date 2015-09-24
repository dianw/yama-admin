'use strict'

class App extends Config
	constructor: ($stateProvider) ->
		$stateProvider.state 'app',
			url: '/',
			templateUrl: 'app/app.html',
			controller: 'appController as ctrl'
