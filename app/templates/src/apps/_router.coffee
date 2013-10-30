define([
  'backbone'
  'views/hello/index'
], (
  Backbone
  HelloView
) ->

  class Router extends Backbone.Router
    routes: {
      '': 'hello'
      'bye': 'bye'
    }

    hello: ->
      $('body').empty()
      (new HelloView({userModel: window.user})).render().$el.appendTo('body')
      return this

    bye: ->
      $('body').html('<h1>Bye</h1>')
      return this

    start: ->
      Backbone.history.start({pushState: true})
      return this

)