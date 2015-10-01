'use strict'

class BasicProfile extends Config
	constructor: ($stateProvider) ->
		$stateProvider.state 'app.profile.basic',
			url: '/basic',
			templateUrl: 'profile/basic/basic.form.html',
			controller: 'basicProfileController as ctrl'
