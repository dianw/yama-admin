'use strict'

class Role extends Config
	constructor: ($stateProvider) ->
		$stateProvider.state 'app.admin.role',
			url: '/roles',
			templateUrl: 'admin/role/role.list.html',
			controller: 'roleController as ctrl'
