'use strict'

class BasicProfile extends Controller
	constructor: ($validation, $rootScope, $timeout, angularPopupBoxes, RestUserService) ->
		ctrl = @

		RestUserService.one('me').get().then (user) ->
			ctrl.user = user
			ctrl.username = ctrl.user.username
			ctrl.email = ctrl.user.email

		success = (user) ->
			$rootScope.currentUser = user
			angularPopupBoxes.alert 'Update success'

		error = -> ctrl.error = true

		@submit = (user, form) ->
			$validation.validate(form).success ->
				ctrl.error = false;

				if user.id
					user.put().then success, error
				else
					RestUserService.post(user).then success, error
