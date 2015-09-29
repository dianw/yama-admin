'use strict'

class Application extends Config
	constructor: ($stateProvider) ->
		$stateProvider.state 'app.admin.application',
			url: '/applications',
			templateUrl: 'admin/application/application.list.html',
			controller: 'applicationController as ctrl'
