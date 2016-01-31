module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'
  grunt.initConfig
    compassMultiple:
      dev:
        options:
          config:       'config.rb'
          environment:  'development'
          force:        true
          sassDir:      './src/scss/'
      pro:
        options:
          config:       'config.rb'
          environment:  'production'
          force:        true
          sassDir:      './src/scss/'
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
    autoprefixer:
      options:
        browsers: 'last 3 version'
      file:
        expand:   true
        flatten:  true
        src:      "bin/css/app.css"
        dest:     'bin/css/'
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
      release:
        src: 'release/'
    copy:
      font:
        cwd:  'bin/font'
        src:  '**/*.{eot,svg,ttf,woff,woff2}'
        dest: 'release/font'
        expand: true
    compress:
      default:
        options:
          archive:  "build/archive_#{new Date().getTime()}.zip"
          mode:     'zip'
        expand: true
        cwd:    './'
        src:    'release/**/*'
    watch:
      coffee:
        files: "src/coffee/**/*.coffee"
        tasks: ["parallelize:coffee:default"]
      js:
        files: [
          "bin/js/**/*.js"
          "!bin/js/**/app.js"
        ]
        tasks: ["parallelize:concat:js"]
      sass:
        files: "src/scss/**/*.scss"
        tasks: ["compassMutiple:dev"]
      css:
        files: [
          "bin/css/**/*.css"
          "!bin/css/**/app.css"
        ]
        tasks: ["parallelize:concat:css","autoprefixer"]
      jade:
        files: "src/jade/**/*.jade"
        tasks: ["parallelize:jade:default"]
      image:
        files: "src/img/**/*.{png,jpg,gif}"
        tasks: ["parallelize:image:dev"]
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
      coffee:   true
      concat:   true
      cssmin:   true
      uglify:   true
      jade:     true
      htmlmin:  true
      image:    true
      clean:    true
      copy:     true
      compress: true
      watch:    true
    
    for t of pkg.devDependencies
      if t.substring(0, 6) is 'grunt-'
        grunt.loadNpmTasks t

    grunt.registerTask 'default', ["browserSync:dev", "watch"]
    grunt.registerTask 'release', [
      'parallelize:clean:release'
      'parallelize:copy:font'
      'parallelize:jade:default'
      'parallelize:coffee:default'
      'compassMutiple:pro'
      'parallelize:htmlmin:default'
      'parallelize:concat:css'
      'parallelize:concat:js'
      'autoprefixer'
      'parallelize:uglify:default'
      'parallelize:cssmin:default'
      'parallelize:image:pro'
      'parallelize:compress:default'
      "browserSync:pro"
    ]
