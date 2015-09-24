'use strict'

class OauthInterceptor extends Factory
	constructor: ($rootScope, $q, AccessToken) ->
		return {
			request: ($config) ->
				if AccessToken.get() then $config.headers.Authorization = 'Bearer ' + AccessToken.get().access_token
				$config
			responseError: (rejection) ->
				if 401 == rejection.status then $rootScope.$broadcast 'oauth:unauthorized', rejection
				$q.reject rejection
		}

class OauthConfig extends Config
	constructor: ($httpProvider) ->
		$httpProvider.interceptors.push 'OauthInterceptor'
