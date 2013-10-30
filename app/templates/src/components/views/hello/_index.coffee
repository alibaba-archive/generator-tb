define([
  'view'
  './templates/basic'
], (
  View
  BasicTemplate
) ->

  class HelloView extends View
    className: 'hello'
    events: {
      'click .go-to-bye-page': 'goToByePage'
    }

    initialize: (options) ->
      return false unless options.userModel
      @options = options
      @userModel = options.userModel
      @renderBasic()
      return this

    renderBasic: ->
      @$el.html(BasicTemplate(@userModel.toJSON()))
      return this

    goToByePage: ->
      window.router.navigate('bye', {trigger: true})
      return this
)