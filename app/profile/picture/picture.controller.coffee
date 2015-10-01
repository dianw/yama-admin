'use strict'

class PictureProfile extends Controller
	constructor: (ProfilePictureService) ->
		ctrl = @
		@photos = []
		@photos.push photoUrl: ProfilePictureService.getPhotoUrl()

		@upload = (file) ->
			ProfilePictureService.uploadPhoto file, (->),
				(-> ctrl.photos.shift();  ctrl.photos.push photoUrl: ProfilePictureService.getPhotoUrl() + '&cache=' + (new Date()).getTime())
