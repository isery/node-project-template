module.exports = function(grunt) {

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		env: {
			options: {
				//Shared Options Hash
			},
			dev: {
				NODE_ENV: 'development',
				PORT: 3000
			},
			deploy: {
				NODE_ENV: 'production',
				PORT: 3000
			},
			test: {
				NODE_ENV: 'test',
				PORT: 3000
			}
		},
		coffeelint: {
			options: {
				'no_tabs': {
					'level': 'ignore'
				},
				'indentation': {
					'level': 'ignore'
				}
				,
				'max_line_length': {
					'level': 'ignore'
				}
			},
			app: ['app.coffee', 'lib/*.coffee', 'test/**/*.coffee', 'controller/**/*.coffee', 'public/**/*.coffee']
		},
		karma: {
			unit: {
				configFile: 'config/karma.coffee',
				singleRun: true
			}
		},
		requirejs: {
			compile: {
				options: {
					baseUrl: "./public/js/",
					name: "main",
					mainConfigFile: "./config/requirejs.js",
					out: "./public/js/optimized.js"
				}
			}
		},
		copy: {
				deployJavascript: {
					files: [
						{src: ['public/js/optimized.js'], dest: 'public/js/main.js', filter: 'isFile'}
					]
				},
				devJavascript: {
					files: [
						{src: ['config/requirejs.js'], dest: 'public/js/main.js', filter: 'isFile'}
					]
				}
		},
		concat: {
				cssToMain: {
					src: ['public/css/dev/**/*.less'],
					dest: 'public/css/main.less'
				}
		},
		watch: {
			files: ['app.coffee', 'lib/*.coffee', 'test/**/*.coffee', 'controller/**/*.coffee','public/**/*.coffee', 'public/css/dev/**/*.css'],
			tasks: ['coffeelint', 'mochaTest', 'concat:cssToMain', 'coffee']
		},
		coffee: {
				compile_lib: {
					expand: true,
					flatten: true,
					cwd: 'lib/',
					src: ['*.coffee'],
					dest: 'lib/',
					ext: '.js'
				},
			compile_controller: {
				expand: true,
				flatten: true,
				cwd: 'controller/',
				src: ['*.coffee'],
				dest: 'controller/',
				ext: '.js'
			},
			compile_config : {
				files: {
					'config/requirejs.js': 'config/requirejs.coffee'
				}
			}
		},
		clean: ["lib/*.js", "controller/*.js", 'config/*.js', 'app.js'],
		mochaTest: {
			files: ['test/**/*.coffee', 'test/**/*.coffee']
		},
		mochaTestConfig: {
			options: {
				reporter: 'nyan',
				compilers: 'coffee-script',
				timeout: '3000'
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-requirejs');
	grunt.loadNpmTasks('grunt-coffeelint');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-mocha-test');
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-env');
	grunt.loadNpmTasks('grunt-contrib-copy');
	grunt.loadNpmTasks('grunt-karma');
	grunt.loadNpmTasks('grunt-contrib-concat');
	grunt.loadNpmTasks('grunt-contrib-clean');

	grunt.registerTask('filewatch', ['watch']);
	grunt.registerTask('test', ['env:test', 'coffeelint', 'coffee', 'mochaTest', 'karma']);
	grunt.registerTask('deploy', ['env:deploy','coffee', 'requirejs', 'concat:cssToMain', 'copy:deployJavascript']);
	grunt.registerTask('dev', ['env:dev', 'coffee', 'copy:devJavascript', 'concat:cssToMain']);
	grunt.registerTask('default', ['env:test', 'coffeelint','coffee',  'mochaTest', 'karma']);
};