'use strict'

class PictureProfile extends Config
	constructor: ($stateProvider) ->
		$stateProvider.state 'app.profile.picture',
			url: '/picture',
			templateUrl: 'profile/picture/picture.form.html',
			controller: 'pictureProfileController as ctrl'
