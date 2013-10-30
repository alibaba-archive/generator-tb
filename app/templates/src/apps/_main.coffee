require.config({
  paths: {
    'jquery': '../../bower_components/jquery/jquery'
    'underscore': '../../bower_components/underscore/underscore'
    'backbone': '../../bower_components/backbone/backbone'
    'mousetrap':'../../bower_components/mousetrap/mousetrap'

    'lib': '../../lib'
    'hotkey': '../../lib/hotkey'
    'warehouse': '../../lib/warehouse'
    'model': '../../lib/model'
    'collection': '../../lib/collection'
    'view': '../../lib/view'
    'collections': '../../components/collections'
    'models': '../../components/models'
    'views': '../../components/views'
    'templates': '../../templates'
  }
  shim: {
    'underscore': {
      exports: '_'
    }
    'backbone': {
      deps: ['jquery','underscore']
      exports: 'Backbone'
    }
  }
})

require([
  'jquery'
  'underscore'
  'backbone'
  'router'
  'models/user/index'
], (
  $
  _
  Backbone
  Router
  UserModel
) ->
  window.user = new UserModel({name: prompt('Who are you?')})
  window.router = (new Router).start()
)