'use strict'

class PasswdProfile extends Controller
	constructor: ($validation, angularPopupBoxes, RestUserService) ->
		ctrl = @
		ctrl.user = RestUserService.one('me')

		@submit = (user, form) ->
			$validation.validate(form).success ->
				ctrl.error = false
				user.post('password').then ((user) ->
					angularPopupBoxes.alert 'Update success'
					ctrl.user = user
					ctrl.confirmPassword = user.password),
				(-> ctrl.error = true)
