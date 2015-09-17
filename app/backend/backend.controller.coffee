'use strict'

class Backend extends Controller
	constructor: ($scope) ->
		$scope.menus = [
			{ menu: 'Home', icon: 'home', ref: 'app.backend.dashboard' }
			{ menu: 'User', icon: 'person', ref: 'app.backend.user' }
			{ menu: 'Role', icon: 'supervisor_account', ref: 'app.backend.role' }
		]
