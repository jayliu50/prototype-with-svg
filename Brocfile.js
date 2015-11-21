var filterCoffeeScript = require('broccoli-coffee')
var compass = require('broccoli-compass')
var pickFiles = require('broccoli-static-compiler')
var mergeTrees = require('broccoli-merge-trees')
var findBowerTrees = require('broccoli-bower')
var removeTrees = require('broccoli-file-remover')
var concatenate = require('broccoli-concat')
var uglify = require('broccoli-uglify-js')

removeTrees('dist', {
  files: '**.*'
})

var app = 'src'

var coffee = pickFiles(app, {
  srcDir: 'scripts',
  files: ['**/*.coffee'],
  destDir: ''
})

var scripts = filterCoffeeScript(coffee, {
  bare: true
})

scripts = concatenate(scripts, {
  inputFiles: ['**/*.js'],
  outputFile: '/scripts/prototype.js'
})

var styles = pickFiles(app, {
  srcDir: 'styles',
  files: ['**/*.scss'],
  destDir: ''
})

// not sure why stupid compass copies the scss files out to the dist. oh well.
var appCss = compass(styles, {
  outputStyle: 'expanded',
  sassDir: '.',
  require: ['toolkit'],
  cssDir: 'styles'
})


var bower = mergeTrees(findBowerTrees())

bower = pickFiles(bower, {
  srcDir: '/',
  destDir: 'bower'
})

// var vendor = pickFiles(app, {
//   srcDir: '/scripts/vendor',
//   files: ['**/*.js'],
//   destDir: 'scripts/vendor'
// })

// bower = uglify(bower, {
//   mangle: false
// })


var appJs = mergeTrees([scripts, bower]) // todo: merge vendor stuff into appJs if applicable

var appHtml = pickFiles(app, {
  srcDir: '',
  files: ['**/*.html'],
  destDir: ''
})


module.exports = mergeTrees([appJs, appHtml, appCss])
