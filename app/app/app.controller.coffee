'use strict'

class App extends Controller
	constructor: ($state, $rootScope, $timeout) ->
		ctrl = @
		# ProfilePictures.reloadPhoto();

		$state.go 'app.admin'
