'use strict'

class App extends Controller
	constructor: ($state, oauth, Restangular) ->
		@menus = [
			{ menu: 'Admin', icon: 'gears', ref: 'app.admin' }
		]

		service = Restangular.service '../auth'

		@logout = ->
			service.one('logout').get().then ->
				oauth.logout()

		@state = $state

		$state.go 'app.admin'

