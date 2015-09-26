'use strict'

class Role extends Controller
	constructor: ($modal, $location, RestRoleService, angularPopupBoxes) ->
		ctrl = @

		ctrl.searchParams = $location.search()
		ctrl.searchParams.hash = 0
		ctrl.page = 1

		@search = ->
			ctrl.searchParams.hash++;
			ctrl.searchParams.page = ctrl.page - 1

			$location.search ctrl.searchParams

			# Load list on page loaded
			RestRoleService.getList(ctrl.searchParams).then (roles) ->
				ctrl.roles = roles
				ctrl.page = roles.meta.number + 1

		@search()

		@openForm = (role) ->
			modal = $modal.open
				templateUrl: 'admin/role/role.form.html'
				controller: 'roleFormController as ctrl'
				size: 'md'
				resolve:
					role: -> role or {}

			modal.result.then (r) ->
				ctrl.searchParams.q = r.name
				ctrl.search()

		# Open popup confirmation and delete user if user choose yes
		@remove = (role) ->
			angularPopupBoxes.confirm 'Are you sure want to delete this data?'
				.result.then ->
					role.remove().then ->  ctrl.search ctrl.searchParams

class RoleForm extends Controller
	constructor: ($modalInstance, $validation, RestRoleService, role) ->
		ctrl = @
		ctrl.role = role;

		success = (r) -> $modalInstance.close(r)

		error = -> ctrl.error = true

		@submit = (role, form) ->
			$validation.validate(form).success ->
				ctrl.error = false;
				if (role.id) then role.put().then(success, error)
				else RestRoleService.post(role).then(success, error)
