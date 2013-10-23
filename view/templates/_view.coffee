define([
  'view'
  'warehouse'
  'templates/<%= templatesDir %>/basic'
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
      @options = options or {}
      @renderBasic()
      return this

    renderBasic: ->
      @$el.html(BasicTemplate())
      return this
)