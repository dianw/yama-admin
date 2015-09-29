'use strict'

class Admin extends Controller
	constructor: ($state) ->
		@menus = [
			{ menu: 'Users', icon: 'user', ref: 'app.admin.user' }
			{ menu: 'Roles', icon: 'users', ref: 'app.admin.role' }
			{ menu: 'Applications', icon: 'desktop', ref: 'app.admin.application' }
		]

		@state = $state

		@state.go @menus[0].ref
