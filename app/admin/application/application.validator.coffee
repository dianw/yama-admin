'use strict'

class ApplicationValidator extends Config
	constructor: (validationSchemaProvider) ->
		validationSchemaProvider.set 'application',
			name:
				'validations': 'required'
				'validate-on': 'blur'
				'messages':
					'required':
						'error': 'Name cannot be blank'
						'success': 'Ok'
			website:
				'validations': 'url, required'
				'validate-on': 'blur'
				'messages':
					'required':
						'error': 'Site cannot be blank'
						'success': 'Ok'
					'url':
						'error': 'Not a valid URL'
						'success': 'Ok'
			redirect:
				'validations': 'url, required'
				'validate-on': 'blur'
				'messages':
					'required':
						'error': 'Site cannot be blank'
						'success': 'Ok'
					'url':
						'error': 'Not a valid URL'
						'success': 'Ok'
