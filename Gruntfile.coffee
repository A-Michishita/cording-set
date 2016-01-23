module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'
  grunt.initConfig
    clean:
      deleteReleaseDir:
        src: 'release/'
    compass:
      dev:
        options:
          config:       'config.rb'
          environment:  'development'
          force:        true
      pro:
        options:
          config:       'config.rb'
          environment:  'production'
          force:        true
    coffee:
      default:
        files: [
          expand: true
          cwd:    'src/coffee/'
          src:    ['**/*.coffee']
          dest:   'bin/js/'
          ext:    '.js'
        ]
    concat:
      css:
        src: [
          'bin/css/**/*.css',
          '!bin/css/app.css'
        ],
        dest: 'bin/css/app.css'
      js:
        src: [
          'bin/js/**/*.js',
          '!bin/js/app.js'
        ],
        dest: 'bin/js/app.js'
    uglify:
      css:
        src:  'bin/css/app.css',
        dest: 'release/css/app.min.css'
      js:
        src:  'bin/js/app.js',
        dest: 'release/js/app.min.js'
    jade:
      default:
        files: [
          expand: true
          cwd:    "src/jade/"
          src:    "*.jade"
          dest:   "bin/"
          ext:    ".html"
        ]
    htmlmin:
      default:
        options:
          removeComments:               true
          removeCommentsFromCDATA:      true
          removeCDATASectionsFromCDATA: true
          collapseWhitespace:           true
          removeRedundantAttributes:    true
          removeOptionalTags:           true
        expand: true
        cwd:    'bin/'
        src:    ["**/*.html"]
        dest:   "release/"
    watch:
      coffee:
        files: "src/coffee/**/*.coffee"
        tasks: ["coffee:dev"]
      js:
        files: [
          "bin/js/**/*.js"
          "!bin/js/**/app.js"
        ]
        tasks: ["concat:js"]
      sass:
        files: "src/scss/**/*.scss"
        tasks: ["compass:dev"]
      css:
        files: [
          "bin/css/**/*.css"
          "!bin/css/**/app.css"
        ]
        tasks: ["concat:css"]
      jade:
        files: "src/jade/**/*.jade"
        tasks: ["jade:dev"]
    
    for t of pkg.devDependencies
      if t.substring(0, 6) is 'grunt-'
        grunt.loadNpmTasks t

    grunt.registerTask 'release', [
      'clean'
      'jade'
      'coffee'
      'compass:pro'
      'htmlmin'
      'concat'
      'uglify'
    ]
