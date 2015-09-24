'use strict'

class RestUserService extends Factory
	constructor: (Restangular) -> return Restangular.service 'users'
