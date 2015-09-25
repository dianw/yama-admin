'use strict'

class OauthConfig extends Config
	constructor: (oauthProvider) ->
		oauthProvider.configure
			site: 'http://yama2.meruvian.org'
			scope: 'read write'
			clientId: '97d0753a-98b6-47e1-9968-896922c578e1',
			redirectUri: 'http://localhost:9000'

class RestConfig extends Config
	constructor: (RestangularProvider) ->
		RestangularProvider.setBaseUrl '/api'
