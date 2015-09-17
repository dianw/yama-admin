'use strict'

class BackendRoute extends Config
	constructor: ($stateProvider) ->
		$stateProvider.state 'app.backend',
			url: 'backend',
			templateUrl: 'backend/backend.html',
			controller: 'backendController'
