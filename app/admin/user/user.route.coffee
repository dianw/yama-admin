'use strict'

class User extends Config
	constructor: ($stateProvider) ->
		$stateProvider.state 'app.admin.user',
			url: '/users',
			templateUrl: 'admin/user/user.list.html',
			controller: 'userController as ctrl'
