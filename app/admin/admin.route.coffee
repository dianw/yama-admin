'use strict'

class Admin extends Config
	constructor: ($stateProvider) ->
		$stateProvider.state 'app.admin',
			url: 'admin',
			templateUrl: 'admin/admin.html',
			controller: 'adminController as ctrl'
