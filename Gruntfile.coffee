module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'
  grunt.initConfig
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
    cssmin:
      default:
        expand: true
        cwd:    "bin/css/"
        src:    'app.css'
        dest:   'release/css/'
    uglify:
      default:
        src:  'bin/js/app.js',
        dest: 'release/js/app.js'
    jade:
      default:
        options:
          pretty: true
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
    
    image:
      dev:
        files: [
          expand: true
          cwd:    'src/img/'
          src:    ['**/*.{png,jpg,gif}']
          dest:   'bin/img/'
        ]
      pro:
        files: [
          expand: true
          cwd:    'src/img/'
          src:    ['**/*.{png,jpg,gif}']
          dest:   'release/img/'
        ]
    clean:
      deleteReleaseDir:
        src: 'release/'
    watch:
      coffee:
        files: "src/coffee/**/*.coffee"
        tasks: ["coffee"]
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
        tasks: ["jade"]
      image:
        files: "src/img/**/*.{png,jpg,gif}"
        tasks: ["image:dev"]
    browserSync:
      dev:
        bsFiles:
          src: 'bin/**/*'
        options:
          server: 'bin/'
          watchTask: true
      pro:
        bsFiles:
          src: 'release/**/*'
        options:
          server: 'release/'
    parallelize:
      options:
        processes: 4
      compass:  true
      coffee:   true
      concat:   true
      cssmin:   true
      uglify:   true
      jade:     true
      htmlmin:  true
      image:    true

    for t of pkg.devDependencies
      if t.substring(0, 6) is 'grunt-'
        grunt.loadNpmTasks t

    grunt.registerTask 'default', ["browserSync:dev", "watch"]
    grunt.registerTask 'release', [
      'clean'
      'jade'
      'coffee'
      'compass:pro'
      'htmlmin'
      'concat'
      'uglify'
      'cssmin'
      'image:pro'
      "browserSync:pro"
    ]
