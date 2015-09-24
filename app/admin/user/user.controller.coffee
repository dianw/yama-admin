'use strict'

class User extends Controller
	constructor: ($modal, $location, RestUserService, angularPopupBoxes) ->
		ctrl = @

		ctrl.searchParams = $location.search()
		ctrl.searchParams.hash = 0
		ctrl.page = page = 1

		@search = ->
			ctrl.searchParams.hash++;
			ctrl.searchParams.page = page - 1

			$location.search ctrl.searchParams

			# Load list on page loaded
			RestUserService.getList(ctrl.searchParams).then (users) ->
				ctrl.users = users
				ctrl.page = users.meta.number + 1

				addRole = (user) -> user.getList('roles').then (roles) -> user.roles = roles
				addRole user for user in users

		@search()

		@openForm = (user) ->
			modal = $modal.open
				templateUrl: 'admin/user/user.form.html'
				controller: 'userFormController as ctrl'
				size: 'md'
				resolve:
					user: -> user or {}

			modal.result.then (u) ->
				ctrl.searchParams.q = u.username
				ctrl.search()

		@changePasswd = (user) ->
			modal = $modal.open
				templateUrl: 'admin/user/user.passwd.html'
				controller: 'userChangePasswdFormController as ctrl'
				size: 'md'
				resolve:
					user: -> user

			modal.result.then -> ctrl.search()

		@addRole = (user) ->
			modal = $modal.open
				templateUrl: 'admin/user/user.role.html'
				controller: 'userEditRoleFormController as ctrl'
				size: 'md'
				resolve:
					user: -> user

			modal.result.then -> ctrl.search ctrl.searchParams

		# Open popup confirmation and delete user if user choose yes
		@remove = (user) ->
			angularPopupBoxes.confirm 'Are you sure want to delete this data?'
				.result.then ->
					user.remove().then ->  ctrl.search ctrl.searchParams

class UserForm extends Controller
	constructor: ($modalInstance, $validation, RestUserService, user) ->
		ctrl = @

		ctrl.roles = [];
		ctrl.user = user;

		if (user) then user.confirmPassword = user.password

		success = (u) -> $modalInstance.close(u)

		error = -> ctrl.error = true

		@submit = (user, form) ->
			$validation.validate(form).success ->
				ctrl.error = false;
				if (user.id) then user.put().then(success, error)
				else RestUserService.post(user).then(success, error)

class UserChangePasswdForm extends Controller
	constructor: ($modalInstance, $validation, user) ->
		user.password = ''
		ctrl = @
		ctrl.user = user

		@submit = (u, form) ->
			$validation.validate(form).success ->
				ctrl.error = false
				u.post('password').then (-> $modalInstance.close()), (-> ctrl.error = true)

class UserEditRoleForm extends Controller
	constructor: ($modalInstance, $cacheFactory, RestRoleService, user) ->
		ctrl = @
		ctrl.user = user;
		ctrl.roles = [];

		invalidateCache = -> $cacheFactory.get('$http').remove(user.one('roles').getRequestedUrl())

		@loadRoles = (search) -> RestRoleService.getList(q: search).then((roles) -> ctrl.roles = roles)

		@addRole = (role) -> user.one('roles', role.id).put().then(invalidateCache)

		@removeRole = (role) -> user.one('roles', role.id).remove().then(invalidateCache)

		@done = $modalInstance.close
