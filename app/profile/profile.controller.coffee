'use strict'

class Profile extends Controller
	constructor: ($state) ->
		@menus = [
			{ menu: 'Basic', icon: 'user', ref: 'app.profile.basic' }
			{ menu: 'Password', icon: 'key', ref: 'app.profile.passwd' }
			{ menu: 'Profile Picture', icon: 'camera-retro', ref: 'app.profile.picture' }
		]

		@state = $state

		@state.go @menus[0].ref if $state.current.name == 'app.profile'
