'use strict'

class App extends Controller
	constructor: ($state) ->
		@menus = [
			{ menu: 'Admin', icon: 'gears', ref: 'app.admin' }
		]

		@state = $state

		$state.go 'app.admin'
