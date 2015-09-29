'use strict'

class RestApplicationService extends Factory
	constructor: (Restangular) -> return Restangular.service 'applications'
