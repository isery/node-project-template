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
				},
				'max_line_length': {
					'level': 'ignore'
				}
			},
			app: ['index.coffee', 'libs/*.coffee', 'tests/**/*.coffee', 'controllers/**/*.coffee', 'public/**/*.coffee', 'models/**/*.coffee' , 'middlewares/**/*.coffee']
		},
		karma: {
			single: {
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
				production: {
					files: [
						{src: ['public/js/optimized.js'], dest: 'public/js/main.js', filter: 'isFile'}
					]
				},
				development: {
					files: [
						{src: ['config/requirejs.js'], dest: 'public/js/main.js', filter: 'isFile'}
					]
				}
		},
		concat: {
				allLessFilesToOneMain: {
					src: ['public/css/dev/**/*.less'],
					dest: 'public/css/main.less'
				}
		},
		coffee: {
				compile_libs: {
					expand: true,
					flatten: true,
					cwd: 'libs/',
					src: ['*.coffee'],
					dest: 'libs/',
					ext: '.js'
				},
			compile_controllers: {
				expand: true,
				flatten: true,
				cwd: 'controllers/',
				src: ['*.coffee'],
				dest: 'controllers/',
				ext: '.js'
			},
			compile_models: {
				expand: true,
				flatten: true,
				cwd: 'models/',
				src: ['*.coffee'],
				dest: 'models/',
				ext: '.js'
			},
			compile_config : {
				files: {
					'config/requirejs.js': 'config/requirejs.coffee'
				}
			},
			compile_index : {
				files: {
					'index.js': 'index.coffee'
				}
			}
		},
		clean: {
			allJavascriptFiles: [
				'libs/*.js',
				'controllers/*.js',
				'config/*.js',
				'index.js',
				'models/*.js',
				'public/js/**/*.js',
				'!public/js/vendor/*.js'
			]
		},
		mochaTest: {
			allServerTests: {
				options: {
					reporter: 'nyan',
					compilers: 'coffee-script',
					timeout: '3000'
				},
				src: ['tests/server/**/*.coffee']
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
			files: ['index.coffee', 'libs/*.coffee', 'tests/**/*.coffee', 'controllers/**/*.coffee','public/**/*.coffee', 'public/css/dev/**/*.less', 'models/**/*.coffee', 'middlewares/**/*.coffee'],
			tasks: ['coffeelint',  'coffee', 'mochaTest', 'concat:allLessFilesToOneMain','less:development']
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

	grunt.registerTask('test', ['env:development', 'coffeelint', 'coffee', 'mochaTest']);
	grunt.registerTask('production', ['env:production','coffee','copy:development', 'requirejs', 'copy:production', 'concat:allLessFilesToOneMain', 'less:production']);
	grunt.registerTask('development', ['env:development', 'coffee', 'copy:development', 'concat:allLessFilesToOneMain', 'less:development']);
	grunt.registerTask('default', ['test', 'development',  'watch', 'clean']);
};