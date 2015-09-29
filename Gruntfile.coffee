'use strict'

proxySnippet = require('grunt-connect-proxy/lib/utils').proxyRequest

module.exports = (grunt) ->

	# Time how long tasks take. Can help when optimizing build times
	require('time-grunt')(grunt)

	# Automatically load required Grunt tasks
	require('jit-grunt')(grunt,
		useminPrepare: 'grunt-usemin'
		configureProxies: 'grunt-connect-proxy'
		closureCompiler: 'grunt-closurecompiler'
	)

	# Configurable paths for the application
	appConfig =
		app: require('./bower.json').appPath or 'app'
		dist: 'dist'

	# Define the configuration for all the tasks
	grunt.initConfig

		# Project settings
		yama: appConfig,

		# Watches files for changes and runs tasks based on the changed files
		watch:
			bower:
				files: ['bower.json']
				tasks: ['wiredep']
			ngClassify:
				files: ['<%= yama.app %>/**/*.{coffee,litcoffee,coffee.md}']
				tasks: ['newer:ngClassify:app', 'newer:ngClassify:dev']
			coffee:
				files: ['.tmp/coffee/**/*.{coffee,litcoffee,coffee.md}']
				tasks: ['newer:coffee:dist', 'newer:injector']
			coffeeTest:
				files: ['test/spec/{,*/}*.{coffee,litcoffee,coffee.md}']
				tasks: ['newer:coffee:test', 'karma']
			styles:
				files: ['<%= yama.app %>/styles/**/*.css']
				tasks: ['newer:copy:styles', 'autoprefixer']
			gruntfile:
				files: ['Gruntfile.js']
			livereload:
				options:
					livereload: '<%= connect.options.livereload %>'
				files: [
					'<%= yama.app %>/**/*.html'
					'.tmp/styles/**/*.css'
					'.tmp/scripts/**/*.js'
					'<%= yama.app %>/images/**/*.{png,jpg,jpeg,gif,webp,svg}'
				]

		# The actual grunt server settings
		connect:
			options:
				port: 9000
				# Change this to '0.0.0.0' to access the server from outside.
				hostname: 'localhost'
				livereload: 35729
			proxies: [{
					context: '/'
					host: 'yama2.meruvian.org'
					port: 80
					headers:
						host: 'yama2.meruvian.org'
				}]
			livereload:
				options:
					open: true
					base: ['.tmp', appConfig.app]
					middleware: (connect) ->
						# Setup the proxy
						middlewares = [
							connect.static '.tmp'
							connect().use('/bower_components', connect.static './bower_components')
							connect.static appConfig.app
							proxySnippet
						]

						middlewares
			test:
				options:
					port: 9001
					middleware: (connect) -> [
							connect.static '.tmp'
							connect.static 'test',
							connect().use('/bower_components', connect.static './bower_components')
							connect.static appConfig.app
						]
			dist:
				options:
					open: true
					base: '<%= yama.dist %>'

		# Empties folders to start fresh
		clean:
			dist:
				files: [
					dot: true
					src: [
						'.tmp'
						'<%= yama.dist %>/{,*/}*'
						'!<%= yama.dist %>/.git{,*/}*'
					]
				]
			server: '.tmp'

		# Add vendor prefixed styles
		autoprefixer:
			options:
				browsers: ['last 1 version']
			server:
				options:
					map: true
				files: [{
					expand: true
					cwd: '.tmp/styles/'
					src: '{,*/}*.css'
					dest: '.tmp/styles/'
				}]
			dist:
				files: [{
					expand: true
					cwd: '.tmp/styles/'
					src: '{,*/}*.css'
					dest: '.tmp/styles/'
				}]

		# Automatically inject Bower components into the app
		wiredep:
			app:
				src: ['<%= yama.app %>/index.html']
				ignorePath:	/\.\.\//
			test:
				devDependencies: true
				src: '<%= karma.unit.configFile %>'
				ignorePath:	/\.\.\//
				fileTypes:
					coffee:
						block: /(([\s\t]*)#\s*?bower:\s*?(\S*))(\n|\r|.)*?(#\s*endbower)/gi
						detect:
							js: /'(.*\.js)'/gi
							coffee: /'(.*\.coffee)'/gi
						replace:
							js: '\'{{filePath}}\'',
							coffee: '\'{{filePath}}\''

		# Automatically inject scripts and styles into the app
		injector:
			options:
				ignorePath: ['.tmp', '<%= yama.app %>']
				addRootSlash: false
			local_dependencies:
				files:
					'<%= yama.app %>/index.html': [
						'.tmp/scripts/**/*.js'
						'!.tmp/scripts/app.js'
						'<%= yama.app %>/**/*.css'
					]

		ngClassify:
			options:
				appName: 'yamaAdminApp'
				provider:
					suffix: ''
			app:
				files: [{
						cwd: '<%= yama.app %>'
						src: ['**/*.coffee', '!**/config*.coffee']
						dest: '.tmp/coffee'
						expand: true
					}]
			dev:
				files: [{
						cwd: '<%= yama.app %>'
						src: '**/config*dev.coffee'
						dest: '.tmp/coffee'
						expand: true
					}]
			prod:
				files: [{
						cwd: '<%= yama.app %>'
						src: '**/config*prod.coffee'
						dest: '.tmp/coffee'
						expand: true
					}]

		# Compiles CoffeeScript to JavaScript
		coffee:
			options:
				sourceMap: true
				sourceRoot: ''
			dist:
				files: [{
					expand: true
					cwd: '.tmp/coffee'
					src: '**/*.coffee'
					dest: '.tmp/scripts'
					ext: '.js'
				}]
			test:
				files: [{
					expand: true,
					cwd: 'test/spec',
					src: '{,*/}*.coffee',
					dest: '.tmp/spec',
					ext: '.js'
				}]

		# Renames files for browser caching purposes
		filerev:
			dist:
				src: [
					'<%= yama.dist %>/scripts/{,*/}*.js'
					'<%= yama.dist %>/styles/{,*/}*.css'
					'<%= yama.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
					'<%= yama.dist %>/fonts/*'
				]

		# Reads HTML for usemin blocks to enable smart builds that automatically
		# concat, minify and revision files. Creates configurations in memory so
		# additional tasks can operate on them
		useminPrepare:
			html: '<%= yama.app %>/index.html'
			options:
				dest: '<%= yama.dist %>'
				flow:
					html:
						steps:
							js: ['concat']
							css: ['cssmin']
						post: {}

		# Performs rewrites based on filerev and the useminPrepare configuration
		usemin:
			html: ['<%= yama.dist %>/{,*/}*.html']
			css: ['<%= yama.dist %>/styles/{,*/}*.css']
			js: ['<%= yama.dist %>/scripts/{,*/}*.js']
			options:
				assetsDirs: [
					'<%= yama.dist %>'
					'<%= yama.dist %>/images'
					'<%= yama.dist %>/styles']
				patterns:
					js: [[/(images\/[^''""]*\.(png|jpg|jpeg|gif|webp|svg))/g, 'Replacing references to images']]

		# The following *-min tasks will produce minified files in the dist folder
		# By default, your `index.html`'s <!-- Usemin block --> will take care of
		# minification. These next options are pre-configured if you do not wish
		# to use the Usemin blocks.
		# cssmin: {
		#	 dist: {
		#		 files: {
		#			 '<%= yama.dist %>/styles/main.css': [
		#				 '.tmp/styles/{,*/}*.css'
		#			 ]
		#		 }
		#	 }
		# },
		# concat: {
		# 	dist: {
		# 	}
		# },

		imagemin:
			dist:
				files: [{
					expand: true
					cwd: '<%= yama.app %>/images'
					src: '{,*/}*.{png,jpg,jpeg,gif}'
					dest: '<%= yama.dist %>/images'
				}]

		svgmin:
			dist:
				files: [{
					expand: true
					cwd: '<%= yama.app %>/images'
					src: '{,*/}*.svg'
					dest: '<%= yama.dist %>/images'
				}]

		htmlmin:
			dist:
				options:
					collapseWhitespace: true
					conservativeCollapse: true
					collapseBooleanAttributes: true
					removeCommentsFromCDATA: true
				files: [{
					expand: true
					cwd: '<%= yama.dist %>'
					src: ['**/*.html']
					dest: '<%= yama.dist %>'
				}]

		closurecompiler:
			minify:
				files: [{
						expand: true
						cwd: '<%= yama.dist %>/scripts/'
						src: ['**/*.js']
						dest: '<%= yama.dist %>/scripts/'
					}]
				options:
					'compilation_level': 'SIMPLE_OPTIMIZATIONS'
					'max_processes': 5
					'language_in': 'ECMASCRIPT5'

		# Copies remaining files to places other tasks can use
		copy:
			dist:
				files:[{
						expand: true
						dot: true
						cwd: '<%= yama.app %>'
						dest: '<%= yama.dist %>'
						src: [
							'*.{ico,png,txt}'
							'.htaccess'
							'**/*.html'
							'images/{,*/}*.{webp}'
							'styles/fonts/{,*/}*.*']
					}
					{
						expand: true
						cwd: '.tmp/images'
						dest: '<%= yama.dist %>/images'
						src: ['generated/*']
					}
					{
						expand: true
						dot: true
						cwd: 'bower_components/bootstrap/dist'
						src: ['fonts/*.*']
						dest: '<%= yama.dist %>'
					}
					{
						expand: true
						dot: true
						cwd: 'bower_components/font-awesome'
						src: ['fonts/*.*']
						dest: '<%= yama.dist %>'
					}]
			styles:
				expand: true
				cwd: '<%= yama.app %>/styles'
				dest: '.tmp/styles/'
				src: '{,*/}*.css'

		# Run some tasks in parallel to speed up the build process
		concurrent:
			ngClassifyServer: ['ngClassify:app', 'ngClassify:dev']
			server: ['coffee:dist', 'copy:styles']
			test: ['coffee', 'copy:styles']
			ngClassifyDist: ['ngClassify:app', 'ngClassify:prod']
			dist: ['coffee', 'copy:styles', 'imagemin', 'svgmin']

		# Test settings
		karma:
			unit:
				configFile: 'test/karma.conf.coffee'
				singleRun: true

	grunt.registerTask 'serve', 'Compile then start a connect web server', (target) ->
		if (target == 'dist')
			grunt.task.run ['build', 'connect:dist:keepalive']

		grunt.task.run [
			'clean:server'
			'wiredep'
			'concurrent:ngClassifyServer'
			'concurrent:server'
			'injector'
			'autoprefixer:server'
			'configureProxies'
			'connect:livereload'
			'watch']

	grunt.registerTask 'server', 'DEPRECATED TASK. Use the "serve" task instead', (target) ->
		grunt.log.warn 'The `server` task has been deprecated. Use `grunt serve` to start a server.'
		grunt.task.run ['serve:' + target]

	grunt.registerTask 'test', [
		'clean:server'
		'wiredep'
		'concurrent:test'
		'autoprefixer'
		'connect:test'
		'karma']

	grunt.registerTask 'build', [
		'clean:dist'
		'wiredep'
		'useminPrepare'
		'concurrent:ngClassifyDist'
		'concurrent:dist'
		'injector'
		'autoprefixer'
		'concat'
		'copy:dist'
		'cssmin'
		'closurecompiler:minify'
		'filerev'
		'usemin'
		'htmlmin']

	grunt.registerTask 'default', [
		'test',
		'build']
