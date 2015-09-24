'use strict'

class RestRoleService extends Factory
	constructor: (Restangular) -> return Restangular.service 'roles'
