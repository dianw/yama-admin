'use strict'

class OauthConfig extends Config
	constructor: (oauthProvider) ->
		oauthProvider.configure
			site: 'http://yama2.meruvian.org'
			scope: 'read write'
			clientId: 'ca4bde63-9a81-4202-b869-69041f5d9217',
			redirectUri: 'http://dianw.github.io/yama-admin'

class RestConfig extends Config
	constructor: (RestangularProvider) ->
		RestangularProvider.setBaseUrl 'http://yama2.meruvian.org/api'
