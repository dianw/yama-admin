'use strict'

class Application extends Controller
	constructor: ($modal, $location, RestApplicationService, angularPopupBoxes) ->
		ctrl = @

		ctrl.searchParams = $location.search()
		ctrl.searchParams.hash = 0
		ctrl.page = 1

		@search = ->
			ctrl.searchParams.hash++;
			ctrl.searchParams.page = ctrl.page - 1

			$location.search ctrl.searchParams

			# Load list on page loaded
			RestApplicationService.getList(ctrl.searchParams).then (applications) ->
				ctrl.applications = applications
				ctrl.page = applications.meta.number + 1

		@search()

		@openForm = (application, changeSecret) ->
			modal = $modal.open
				templateUrl: 'admin/application/application.form.html'
				controller: 'applicationFormController as ctrl'
				size: 'md'
				resolve:
					application: -> application
					changeSecret: -> changeSecret

			modal.result.then (r) ->
				ctrl.searchParams.q = r.name
				ctrl.search()

		# Open popup confirmation and delete user if user choose yes
		@remove = (application) ->
			angularPopupBoxes.confirm 'Are you sure want to delete this data?'
				.result.then ->
					application.remove().then ->  ctrl.search ctrl.searchParams

class ApplicationForm extends Controller
	constructor: ($modalInstance, $validation, RestApplicationService, application, changeSecret) ->
		ctrl = @
		ctrl.changeSecret = changeSecret || false;

		if application
			application.redirectUri = application.registeredRedirectUris[0]
			ctrl.application = application

		success = (a) -> $modalInstance.close(a)

		error = -> ctrl.error = true

		@submit = (application, form) ->
			$validation.validate(form).success ->
				application.registeredRedirectUris = []
				application.registeredRedirectUris.push application.redirectUri

				ctrl.error = false;

				if (application.id) then application.put().then(success, error)
				else RestApplicationService.post(application).then(success, error)

		@generateSecret = (application) ->
			application.post('secret').then(((a) -> ctrl.application.secret = a.secret), error)
