define([
  'view'
  'warehouse'
  './templates/basic'
], (
  View
  Warehouse
  BasicTemplate
) ->
  class <%= ViewName %> extends View
    viewName: '<%= viewName %>'
    className: '<%= slugName %>'

    events: {

    }

    initialize: (options) ->
      @options = _.extend({}, options)
      @renderBasic()
      return this

    renderBasic: ->
      @$el.html(BasicTemplate())
      return this
)