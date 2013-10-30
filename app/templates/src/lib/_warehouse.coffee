define(->
  Data = {}
  socket = window.socket

  Warehouse = {
    getAll: ->
      return Data

    # create方法用于新建model
    create: (name, data, isCollection) ->
      if isCollection is true
        new teambition.collections[name](data, {_boundToObjectId: undefined})
      else
        new teambition.models[name](data or {})

    # set方法用于初始化集合数据
    set: (name, _boundToObjectId, objectData) ->
      Data[name] or= {}
      _boundToObjectId = _boundToObjectId or 0
      Data[name][_boundToObjectId] =
        new teambition.collections[name](objectData, {
          synced: true
          _boundToObjectId: _boundToObjectId
        })

    # one方法用于获取全局唯一且确定的数据对象,如果对象不存在则初始化对象并返回
    one: (name, data) ->
      data or= {}
      Data[name] or= new teambition.models[name](data)

    # get方法用于获取确定存在的对象
    get: (name, _boundToObjectId, _modelId, options) ->
      _boundToObjectId or= 0
      collection = @_findOrCreate(name, _boundToObjectId, options)
      if _modelId
        Data[name][_boundToObjectId].get(_modelId)
      else
        collection

    # 查找指定的集合，若不存在，则创建一个并返回
    _findOrCreate: (name, _boundToObjectId, options) ->
      Data[name] or= {}
      collection = Data[name][_boundToObjectId]
      unless collection
        (options or= {})._boundToObjectId = _boundToObjectId
        collection = Data[name][_boundToObjectId] =
          new teambition.collections[name]([], options)
      return collection

    # request方法从现有的数据中抓值，如果数据不存在，则去服务器抓取
    # 三变量情况： arg1为name , arg2为集合定位Id , arg3为参数对象
    # 四变量情况： arg1为name , arg2为集合定位Id , arg3为模型Id , arg4为参数对象
    request: (arg1, arg2, arg3, arg4) ->
      # 如果最后一个参数不是对象, 则调用get
      if typeof(arguments[arguments.length - 1]) is 'object'
        options = arguments[arguments.length - 1]
      else
        return @get(arg1, arg2, arg3, arg4)
      # 初始化参数
      # 如果参数数量为4, 则查找模型
      if arguments.length is 4
        name = arguments[0]
        _boundToObjectId = arguments[1] or 0
        _modelId = arguments[2]
        # 如果参数数量为3，则查找集合
      else if arguments.length is 3
        name = arguments[0]
        _boundToObjectId = arguments[1] or 0
      else
        return options.error({message: 'arguments error'}, null)
      # 开始处理数据请求
      # 确保集合空间已经声明，并返回集合对象
      collection = @_findOrCreate(name, _boundToObjectId, options)
      # 模型请求
      if _modelId
        model = collection.get(_modelId)
        # 数据在本地
        if model
          options?.success?(model, true)
        else
          collection.fetchOne(_modelId, options)
        # 集合请求
      else
        if collection.synced
          options.beforeSend?(collection)
          options.success(collection, true)
        else
          orgSuccess = options.success
          options.success = (data, options) ->
            orgSuccess(collection)
          collection.fetch(options)

    fetchOne: (name, _modelId, options)->
      options.beforeSend?()
      socket.emit("read:#{name}", {_id: _modelId})
      socket.once("read:#{name}/#{_modelId}", (data) =>
        return options.error?(data.errorCode) if data.errorCode
        model = @create(name, data[name])
        options.success?(model)
      )
  }
)