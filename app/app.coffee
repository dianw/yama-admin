'use strict'

class YamaApp extends App
	constructor: ->
		return [
			'ngAnimate',
			'ngCookies',
			'ngResource',
			'ngRoute',
			'ngSanitize',
			'ngTouch',
			'ngMaterial',
			'ui.router'
		]

class Config extends Config
	constructor: ($urlRouterProvider) ->
		$urlRouterProvider.otherwise '/'
