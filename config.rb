sass_dir = "src/scss"
coffeescripts_dir = "src/coffee"
images_dir = (environment != :development) ? "release/img" : "bin/img"
css_dir = "bin/css"
javascripts_dir = "bin/js"
output_style = (environment != :development) ? :compressed : :expanded
line_comments = (environment != :development) ?  false : true
