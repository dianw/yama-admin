'use strict'

class PasswdProfile extends Config
	constructor: ($stateProvider) ->
		$stateProvider.state 'app.profile.passwd',
			url: '/passwd',
			templateUrl: 'profile/passwd/passwd.form.html',
			controller: 'passwdProfileController as ctrl'
