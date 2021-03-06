'use strict'

class YamaApp extends App
	constructor: ->
		return [
			'angular-loading-bar'
			'angularPopupBoxes'
			'ngAnimate'
			'ngCookies'
			'ngFileUpload'
			'ngResource'
			'ngRoute'
			'ngSanitize'
			'ngTouch'
			'oauth'
			'restangular'
			'ui.bootstrap'
			'ui.router'
			'ui.select'
			'validation'
			'validation.rule'
			'validation.schema'
		]

class UrlConfig extends Config
	constructor: ($locationProvider, $urlRouterProvider, $urlMatcherFactoryProvider) ->
		$locationProvider.hashPrefix '!'
		$urlRouterProvider.otherwise '/'
		$urlMatcherFactoryProvider.strictMode false

class RestConfig extends Config
	constructor: (RestangularProvider) ->
		RestangularProvider.setDefaultHttpFields cache: false

		RestangularProvider.addResponseInterceptor (data, operation) ->
			if operation == 'getList' and angular.isObject data
				extractedData = angular.copy data.content, extractedData
				delete data.content
				extractedData.meta = data
			else
				extractedData = data

			extractedData

class ValidationConfig extends Config
	constructor: ($validationProvider) ->
		$validationProvider.showSuccessMessage = false;

		$validationProvider.invalidCallback = (element) ->
			$(element).parents('.form-group:first').addClass('has-error')

		$validationProvider.validCallback = (element) ->
			$(element).parents('.form-group:first').removeClass('has-error')

		$validationProvider.setExpression
			match: (value, scope, element, attrs, param) -> value == $(param).val()
			alphanumeric: /^[a-z0-9]+$/i

		$validationProvider.setErrorHTML (msg) -> '<p class=\"text-danger\">' + msg + '</p>'
		$validationProvider.setSuccessHTML (msg) -> '<p class=\"text-success\">' + msg + '</p>'

class UserValidation extends Run
	constructor: ($validation, RestUserService) ->
		$validation.setExpression
			userexist: (value, scope, element, attrs, param) ->
				return true if attrs.exclude == value
				RestUserService.one(value).get().then ((user) -> !user), (-> true)

class UiSelectConfig extends Config
	constructor: (uiSelectConfig) ->
		uiSelectConfig.theme = 'bootstrap'
		uiSelectConfig.resetSearchInput = true

class ActivateOauth extends Run
	constructor: ($rootScope, oauth, RestUserService) ->
		$rootScope.$state = {}

		if !oauth.isAuthorized() then oauth.login()
		else
			if !$rootScope.currentUser
				RestUserService.one('me').get().then (user) ->
					$rootScope.currentUser = user

		$rootScope.$on 'oauth:unauthorized', ->
			oauth.login()

		$rootScope.$on 'oauth:logout', ->
			oauth.login()

		$rootScope.$on '$stateChangeStart', (event, toState, toParams) ->
			if !oauth.isAuthorized()
				event.preventDefault()

				$rootScope.$state.toState = toState
				$rootScope.$state.toState.params = toParams

				oauth.login()

class ImgLiquid extends Directive
	constructor: ($timeout) ->
		return {
			restrict: 'A'
			link: (scope, element, attr) ->
				element.height(element.width())

				$timeout ->
					element.imgLiquid fill: true, horizontalAlign: 'center', verticalAlign: '50%'
		}
