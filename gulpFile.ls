require! <[
  gulp 
  gulp-livescript
  gulp-jade
  gulp-stylus
  gulp-concat
  gulp-filter
  gulp-karma
  gulp-run
  gulp-if 
  gulp-plumber
]>

js = <[
  bower_components/angular/angular.js
  bower_components/angular-mocks/angular-mocks.js
  bower_components/textAngular/dist/textAngular-sanitize.min.js
  bower_components/textAngular/dist/textAngular.min.js
  bower_components/lodash/dist/lodash.min.js
  bower_components/socket.io-client/socket.io.js
  src/js/* 
]>

css = <[
  bower_components/semantic/build/packaged/css/semantic.css
  bower_components/textAngular/dist
  src/css/*
]>

p = -> plumber = gulp-plumber errorHandler : -> console.log it 

filter = (k) -> gulp-filter ({path}) -> 
  if k is "test" then true else 
    not /test/ig.test path and not /mock/ig.test path

gulp.task "build:html" ->  
  gulp.src "src/html/*" .pipe p! .pipe gulp-jade! .pipe gulp.dest "public"

gulp.task "build:css" ->
  gulp.src css .pipe p! 
    .pipe gulp-if /.styl/ gulp-stylus!
    .pipe gulp-concat "style.css"
    .pipe gulp.dest "public/css"

gulp.task "build:js" ->
  gulp.src js .pipe p!
    .pipe filter!
    .pipe gulp-if /.ls/, gulp-livescript!
    .pipe gulp-concat "app.js"
    .pipe gulp.dest "public/js"

gulp.task "test" ->
  gulp.src js .pipe p!
    .pipe filter "test"
    .pipe gulp-if /.ls/, gulp-livescript!
    .pipe gulp-concat "test.js"
    .pipe gulp.dest ".tmp"
    .pipe gulp-karma(
      configFile : "karma.conf.ls"
      action     : "run"
    )

gulp.task "build" <[ build:html build:css build:js ]>

gulp.task "watch" -> 
  gulp.watch <[ src/js/*   ]> <[ build:js   ]>
  gulp.watch <[ src/css/*  ]> <[ build:css  ]>
  gulp.watch <[ src/html/* ]> <[ build:html ]>

gulp.task "serve" ->
  gulp.src "server.ls" .pipe gulp-livescript! .pipe gulp-run "node"
  console.log "Note Taker is being served at localhost"

gulp.task "default" <[ build serve ]>

