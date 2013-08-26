module.exports = function(grunt) {

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		env: {
			options: {
				//Shared Options Hash
			},
			development: {
				NODE_ENV: 'development',
				PORT: 3000
			},
			production: {
				NODE_ENV: 'production',
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
			},
			app: ['index.coffee', 'lib/*.coffee', 'test/**/*.coffee', 'controller/**/*.coffee', 'public/**/*.coffee']
		},
		karma: {
			unit: {
				configFile: 'config/karma.coffee',
				singleRun: true
			},
			watch: {
				configFile: 'config/karma.coffee',
				singleRun: false
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
					'config/config.js': 'config/config.coffee',
					'config/requirejs.js': 'config/requirejs.coffee'
				}
			},
			compile_app : {
				files: {
					'index.js': 'index.coffee'
				}
			}
		},
		clean: {
			all: [
				'lib/*.js',
				'controller/*.js',
				'config/*.js',
				'index.js',
				'public/js/**/*.js',
				'!public/js/main.js',
				'!public/js/optimized.js',
				'!public/js/vendor/*.js'
			]
		},
		mochaTest: {
			files: ['test/**/*.coffee', 'test/**/*.coffee']
		},
		mochaTestConfig: {
			options: {
				reporter: 'nyan',
				compilers: 'coffee-script',
				timeout: '3000'
			}
		},
		less: {
			development: {
				files: {
					"public/css/main.css": "public/css/main.less"
				}
			},
			production: {
				options: {
					yuicompress: true
				},
				files: {
					"public/css/main.css": "public/css/main.less"
				}
			}
		},
		watch: {
			files: ['index.coffee', 'lib/*.coffee', 'test/**/*.coffee', 'controller/**/*.coffee','public/**/*.coffee', 'public/css/dev/**/*.less'],
			tasks: ['coffeelint', 'mochaTest', 'concat:cssToMain','less:development', 'coffee', 'karma:unit']
		}
	});

	grunt.loadNpmTasks('grunt-contrib-less');
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

	grunt.registerTask('test', ['env:development', 'coffeelint', 'coffee', 'mochaTest', 'karma:unit']);
	grunt.registerTask('production', ['env:production','coffee', 'requirejs', 'copy:deployJavascript', 'concat:cssToMain', 'less:production']);
	grunt.registerTask('development', ['env:development', 'coffee', 'copy:devJavascript', 'concat:cssToMain', 'less:development']);
	grunt.registerTask('default', ['test', 'development',  'watch', 'clean']);
};