define([
  'backbone'
  'hotkey'
], (
  Backbone
  Hotkey
  LoadingTemplate
) ->

  class BaseView extends Backbone.View
    # Keyboard shortcuts hash that binds to the view.
    hotkeys: {}
    # Routes handlers that are cared by the view.
    routes: {}

    setupHotKey: ->
      Hotkey.add(this)
      return this

    reset: ->
      @dataModels = _.toArray(arguments)

    # Request sub view using
    requestSubView: (viewName, options) ->
      # create request view using passed options
      viewConstructor = teambition.views[viewName]
      if viewConstructor
        subView = new viewConstructor(options)

        # bind a pointer of this view on created sub view
        subView.parentView or= this

        subView.setupHotKey?()
        subView.guideView?(500) if teambition.guideView

        # store the sub view in an array for later access
        # basically designed for recursively remove
        @subViews or= []
        @subViews.push(subView)
        return subView
      else
        console.error(viewName) #TEST
        options.onError?(viewName)

    # Remove all sub views of current view
    removeSubViews: (excludeList...) ->
      return unless @subViews
      excludeList.unshift(@subViews)
      toRemove = _.without.apply(_, excludeList)
      while toRemove.length > 0
        toRemove.pop().remove()
      excludeList.shift()
      @subViews = excludeList
      return this

    # Handle when view is detached from DOM.
    remove: (options) ->
      return this unless @$el
      options or= {}
      @removeSubViews()

      # Cleanup toolset events.
      if @toolEvents
        @undelegateEventsOnElement(@$toolset)
        delete @$toolset

      # Deactivate the hot keys.
      Hotkey.remove(this)

      # Deregister from responsive list
      @deregisterAsResponsive()

      # Remove view element from DOM and plug out all listeners.
      @$el?.remove()
      @stopListening() unless options.keepListen
      _.each(@, (value, key) =>
        @[key] = null
      )
      return this

    # register the view to be a responsive one and get an event on window resize
    registerAsResponsive: ->
      APP.responsiveViews[@cid] = this
      return this

    deregisterAsResponsive: ->
      delete APP.responsiveViews[@cid]

    # Determin whether the view's elements is still in dom
    detached: ->
      domEl = @$el.get(0)
      # Prefered getElementById which has better performance
      # than document position compare.
      if domEl.id
        not document.getElementById(domEl.id)
      else
        not $.contains(document, domEl)

    # Delegate events on any specified element, use with caution.
    # @param events The events hash
    # @param el The DOM element to delegate events to.
    delegateEventsOnElement: (events, el) ->
      el and this.$el = el
      retval = Backbone.View.prototype.delegateEvents.apply(this, arguments)
      el and this.$el = $(this.el)
      return retval

    # Undelegate events on the specified elements.
    # @param el The DOM element to remove events from.
    undelegateEventsOnElement: (el) ->
      el and this.$el = el
      retval = Backbone.View.prototype.undelegateEvents.apply(this, arguments)
      el and this.$el = $(this.el)
      return retval

)
