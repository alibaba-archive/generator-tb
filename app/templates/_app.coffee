###
Module dependencies.
###

express = require('express')
http = require('http')
path = require('path')
_ = require('underscore')
colors = require('colors')
i18nMiddleware = require('i18n-middleware')


###
Custom the logger
###

customLog = (tokens, req, res) ->
  status = res.statusCode
  color = 32

  if status is 200
    return

  if status >= 500
    color = 31
  else if status >= 400
    color = 33
  else color = 36  if status >= 300

  return '\u001b[90m' + req.method + ' ' + req.originalUrl + ' ' + '\u001b[' +
  color + 'm' + res.statusCode + ' \u001b[90m' + (new Date - req._startTime) +
  'ms' + '\u001b[0m'

###
Setup i18n
###

i18nOptions = {
  locales: ['en', 'zh']
  force: true
  tmp: path.join(__dirname, 'tmp/i18n')
}

i18nOptionsForLess = _.extend(_.clone(i18nOptions), {
  grepExts: /(\.css)$/
  testExts: ['.css']
  src: path.join(__dirname, 'public')
  tmp: path.join(__dirname, 'public')
})


###
Setup the server app
###

app = express()

# Basic Configuration
app.configure(->
  app.set('port', process.env.PORT or 5001)
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.logger(customLog))
  app.use(express.cookieParser())
)

# configurations for development environment
app.configure('development', ->
  app.use express.errorHandler()
  sourceDir = path.join __dirname, 'src'
  publicDir = path.join __dirname, 'public'

  baseOptions =
    src: sourceDir
    dest: publicDir

  coffeeOptions = _.extend({
    sourceMap: true
  }, baseOptions)
  LessOptions = baseOptions
  dotOptions = _.extend(
    extension: 'html'
    compress: true
    amd: true
    baseOptions
  )

  # Convert Less First
  app.use(require('less-middleware')(LessOptions))

  app.use(require('i18n-middleware')(i18nOptionsForLess))

  app.use(require('i18n-middleware')(i18nOptions))

  app.use (req, res, next) ->
    coffeeOptions.dest = path.join(publicDir, req.locale)
    coffeeOptions.src = path.join(i18nOptions.tmp, req.locale)
    require('connect-coffee-script')(coffeeOptions)(req, res, next)

  app.use (req, res, next) ->
    dotOptions.dest = path.join(publicDir, req.locale)
    dotOptions.src = path.join(i18nOptions.tmp, req.locale)
    require('dot-middleware')(dotOptions)(req, res, next)

  # Setup the main static as middleware output directory
  app.use (req, res, next) ->
    express.static(publicDir + "/#{req.locale}")(req, res, next)

  app.use(express.static(publicDir))

  # Setup a second static as fallback for the rest of files requests
  # that are not caught by the above middlewares, in source directory.
  app.use(express.static(sourceDir))
)

# configuration for production environment
app.configure 'production', ->
  app.use(i18nMiddleware.guessLanguage(i18nOptions))

# configuration for build environment, development only
app.configure 'build', ->
  app.use(i18nMiddleware.guessLanguage(i18nOptions))
  app.use(express.static(path.join(__dirname, 'build')))

# configuration for ga environment
app.configure 'ga', ->
  app.use(i18nMiddleware.guessLanguage(i18nOptions))

# routes
app.get('*', require('./routes').index)


###
Start server
###

http.createServer(app).listen(app.get('port'), ->
  env = process.env.NODE_ENV
  env = if env? then env[0].toUpperCase() + env[1..] else 'Development'
  console.log(
    "#{env}".bold.cyan +
    "<%= appName %> listening on port #{app.get('port')}"
  )
)
