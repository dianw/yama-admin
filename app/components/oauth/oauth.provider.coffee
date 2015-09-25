'use strict'

class Oauth extends Provider
	constructor: ->
		$rootScope = null
		$timeout = null
		Endpoint = null
		AccessToken = null
		Storage = null
		config = null

		defaultConfig =
			clientId: ''
			redirectUri: location.protocol + '//' + location.host
			site: location.protocol + '//' + location.host
			authorizePath: '/oauth/authorize'
			tokenPath: '/oauth/token'
			responseType: 'token'
			state: null
			scope: null
			storage: 'sessionStorage'

		setup = ($injector) ->
			$rootScope = $injector.get '$rootScope'
			$timeout = $injector.get '$timeout'
			Endpoint = $injector.get 'Endpoint'
			AccessToken = $injector.get 'AccessToken'
			Storage = $injector.get 'Storage'

			Storage.use config.storage
			Endpoint.set config
			AccessToken.set config

			$rootScope.$on 'oauth:expired', ->
				AccessToken.destroy();

		@configure = (params) ->
			if !(params instanceof Object) then throw new TypeError 'Config must be object'

			config = angular.extend {}, defaultConfig, params

		@login = ->
			AccessToken.destroy()
			Endpoint.redirect()

		@logout = ->
			AccessToken.destroy()
			$timeout (-> $rootScope.$broadcast 'oauth:logout'), 500

		@isAuthorized =  -> !(AccessToken.get() == null or AccessToken.expired())

		@getAccessToken = -> AccessToken.get()

		@isExpired = -> AccessToken.expired()

		@$get = ['$injector', ($injector) ->
			setup $injector

			login: this.login
			logout: this.logout
			isAuthorized: this.isAuthorized
			getAccessToken: this.getAccessToken
			isExpired: this.isExpired
		]
