'use strict'

class Profile extends Config
	constructor: ($stateProvider) ->
		$stateProvider.state 'app.profile',
			url: 'profile',
			templateUrl: 'profile/profile.html',
			controller: 'profileController as ctrl'
