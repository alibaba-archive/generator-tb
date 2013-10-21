define([
  'view'
  'warehouse'
  './template/basic'
], (
  View
  Warehouse
  BasicTemplate
) ->
  class <%= viewName %> extends View
    viewName: '<%= viewName %>'
    tagName: 'div'
    className: '<%= fileName %>-view'

    events: {
    }

    initialize: (options) ->
      @options = options
      @renderBasic()
      return this

    renderBasic: ->
      @$el.html(BasicTemplate())
      return this
)