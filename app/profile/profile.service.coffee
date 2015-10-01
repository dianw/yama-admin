'use strict'

class ProfilePictureService extends Factory
	constructor: (RestUserService, Upload, oauth) ->
		return {
			uploadPhoto: (file, progress, success, error) ->
				imageUrl = RestUserService.one('me').one('photo').getRequestedUrl();

				Upload.http(url: imageUrl, data: file, headers : 'Content-Type': file.type)
					.progress progress
					.success success
					.error error
			getPhotoUrl: ->
				RestUserService.one('me').one('photo').getRequestedUrl() + '?access_token=' + oauth.getAccessToken().access_token
		}
