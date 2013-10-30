define([
  'backbone'
  'underscore'
  'warehouse'
], (
  Backbone
  _
  Warehouse
) ->
  class BaseModel extends Backbone.Model
    idAttribute: '_id'

    initialize: ->
      @listen() if @id
      return this

    # Note: Call this method to retrieved data to be displayed as is in HTML.
    unescaped: ->
      recursive = (obj) ->
        _.each(obj, (val, key) ->
          if _.isString(val)
            obj[key] = _.unescape(val)
          else if _.isObject(val)
            recursive(val)
        )
        return obj
      return recursive(_.clone(@attributes));

    sync: (method, model, options) ->
      options.beforeSend?(model)
      switch method
        when 'create'
          if @getParams and @getParams(method, options)?.instanceOf?(Object)
            params = @getParams?(method, options)
          else
            params = @toJSON()
          params.cid = @cid
          params._projectId = options._projectId if options._projectId
          params._organizationId = options._organizationId if options._organizationId
          socket.emit("create:#{@name}", params)
          socket.once("create:#{@name}/#{@cid}", (data) =>
            if data.errorCode
              options.error?(data.errorCode)
              return false
            options.success?(data[@name])
            @listen()
          )

        when 'update', 'patch'
          if @getParams and @getParams(method, options)
            changes = @getParams?(method, options)
          else
            changes = if method is 'patch' then options.attrs else @changed
          changes._id = model.id
          socket.emit("update:#{@name}", changes)
          socket.once("update:#{@name}/#{@id}", (data) =>
            return options.error?(data.errorCode) if data.errorCode
            options.success?(data[@name])
          )

        when 'delete'
          socket.emit("delete:#{@name}", {_id: @id})
          socket.once("delete:#{@name}/#{model.id}", (data) =>
            return options.error?(data.errorCode) if data.errorCode
            options.success?(data[@name])
          )
      return this

    hasRight: ->
      if @get('hasRight') in [0, 1, 2]
        return @get('hasRight')
      else if (_projectId = @get('_projectId'))
        projectModel = Warehouse.get('project', null, _projectId)
        if projectModel.get?('hasRight') in [0, 1, 2]
          return projectModel.get('hasRight')
        else
          return 0
      else
        return 0

    listen: ->
      socket.on(":change:#{@name}/#{@id}", (changes) =>
        @set(changes)
      )
      return this

)