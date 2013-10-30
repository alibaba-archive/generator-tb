define([
  'backbone'
], (
  Backbone
) ->
  class Collection extends Backbone.Collection
    # The flag tells if the collection data has been ever fetched from socket.
    synced: false
    # Sorting strategy of the collection items.
    orderBy: 'latest-created'

    initialize: (models, options) ->
      expect(@name, 'collection name must be defined').to.be.ok
      @_boundToObjectId = options?._boundToObjectId
      if options?.boundToObjectType
        @boundToObjectType = options.boundToObjectType
      @listen() if @name is 'activities'

    # Implements Backbone.sync that fetch/persist models by web socket.
    sync: (method, collection, options) ->
      options.beforeSend?(collection)
      switch method
        when 'read'
          params = @getParams?(method, options) or {}
          params.count = @pageNum if @pageNum
          if @boundToObjectType
            params["_#{@boundToObjectType}Id"] =
              params._boundToObjectId or @_boundToObjectId
            nameSpace = "#{@name}/#{params["_#{@boundToObjectType}Id"]}"
          else
            nameSpace = "#{@name}"
          if collection.length and @synced and @pageNum
            maxData = collection.last().get?('created')
            params.maxDate = maxData if maxData

          params.all = true if @name is 'tasks'
          socket.emit("read:#{@name}", params)
          socket.once("read:#{nameSpace}", (data) =>
            if data.errorCode
              logger.error("error reading collection: #{@name} with error code: #{data.errorCode}")
              return options.error?(data.errorCode)
            @synced = true
            @hasMore = data[@name].length is @pageNum if @pageNum
            options.success?(data[@name])
            @listen()
          )
        when 'one'
          namespace = @getModelName()
          socket.emit("read:#{namespace}", {_id: options._modelId})
          socket.once("read:#{namespace}/#{options._modelId}", (data) =>
              return options.error?(data.errorCode) if data.errorCode
              @update(data[namespace])
              options.success?(@get(data[namespace]._id))
          )

    # Start listen to the socket broadcast on the appropriate channel determinated
    # by model name and bound-to-id.
    listen: ->
      namespace = @getModelName()
      if @_boundToObjectId
        nameSpace = "#{namespace}/#{@_boundToObjectId}"
      else
        nameSpace = "#{namespace}"
      socket.on(":new:#{nameSpace}", (data) =>
          @add(data)
      )
      socket.on(":remove:#{nameSpace}", (_id) =>
          targetModel = @get(_id)
          @remove(targetModel) if targetModel
      )

    last: ->
      if @length is 0 then {} else @at(@length - 1)

    getModelName: ->
      return @model::name

    # Retrieve the HTML escaped model data.
    escaped: ->
      @map((model) -> model.escaped())

    # Retrieve the HTML unescaped model data.
    unescaped: ->
      @map((model) -> model.unescaped())

    comparator: (model) ->
      if @orderBy is 'latest-created'
        return -(new Date(model.get('created'))).getTime()
      else if @orderBy is 'earliest-created'
        return (new Date(model.get('created'))).getTime()
      else if @orderBy is 'latest-updated'
        return -(new Date(model.get('updated'))).getTime()
      else if @orderBy is 'earliest-updated'
        return (new Date(model.get('updated'))).getTime()

    # Update the collection's data by delegating to Backbone.Collection::set.
    update: (data, options) ->
      options or= {}
      options.remove = false
      @set(data, options)

    # Fetch the rest of items that are not currently inside of the collection.
    loadMore: (options) ->
      options or= {}
      options.remove = false
      error = options.error or -> # fix BUG
      options.error = =>
        error.apply(@, arguments)
      @fetch(options)

    # Fetch the specified model and add it to this collection.
    fetchOne: (_modelId, options) ->
      options._modelId = _modelId
      @sync('one', @, options)

)
