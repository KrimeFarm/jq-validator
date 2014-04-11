module.exports = (grunt) ->
  grunt.initConfig

    pkg: grunt.file.readJSON("package.json")

    # Compile CoffeeScript + Plugins
    coffee:
      compile:
        files:
          "dist/jq-validator.js": ["coffeescript/jq-validator.coffee"]

    # Uglify javascript files
    uglify:
      options:
        mangle: false
      my_target:
        files:
          "dist/jq-validator.min.js": ["dist/jq-validator.js"]

    # Watch files changes and compile what it needs to be
    # compiled.
    watch:
      coffee:
        options:
          livereload: true
        files: ["coffeescript/*.*"]
        tasks: ["coffee"]

  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-uglify"

  # The main build task
  grunt.registerTask "build", [
    "coffee"
    "uglify"
  ]

  # Build and watch for changes
  grunt.registerTask "default", [
    "build"
    "watch"
  ]

  return
