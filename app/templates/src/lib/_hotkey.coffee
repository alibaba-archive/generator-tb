define([
  'underscore'
  'mousetrap'
], (
  _
  Mousetrap
) ->
  # 封装 Mousetrap.js
  # 各View绑定的快捷键事件hash存储在其$el的data('hotkeys')中，$el.remove()后自动失效
  # 如果View不存在$el，则存在$('body')中
  $body = $('body').data('hotkeys', {})

  # 快捷键栈hash，栈是一个数组，存储绑定了快捷键的View的$el
  keyHash = {}

  noop = ->

  Mousetrap.stopCallback = (e, element, combo) ->
    return false if combo is 'esc'
    return element.tagName is 'INPUT' or element.tagName is 'SELECT' or element.tagName is 'TEXTAREA' or (element.contentEditable and element.contentEditable is 'true')

  handlerProxy = (e, keys) ->
    $target = keyHash[keys][0]
    while not $target.data('hotkeys')
      keyHash[keys].shift() # 若$el.remove()，$target不存在，则读取下一个
      $target = keyHash[keys][0] # 最后一个$target为$body，一直存在

    handler = $target.data('hotkeys')[keys]
    if handler
      handler(e, keys)
    else if $target is $body # handler不存在且查到$body，则unbind快捷键
      Mousetrap.unbind(keys)

  hotkey = {
    add: (context) ->
      return this unless context or context.hotkeys
      hotkeys = _.clone(context.hotkeys)
      $target = context.$el or $body
      _.each(context.preventHotkeys, (key) ->
        hotkeys[key] = noop # 屏蔽快捷键
      )
      _.each(hotkeys, (handler, keys) ->
        # 解决类似window(modal)快捷键冲突，子视图快捷键已存在，则忽略父视图快捷键
        return if context.currentView?.hotkeys?[keys]
        unless _.isFunction(handler)
          handler = context[handler]
        if handler and _.isFunction(handler)
          handler = _.bind(handler, context)
          keys = keys.split('|') # 同一事件绑定多个快捷键使用‘|’分隔
          _.each(keys, (key) ->
            hotkeys[key] = handler
            Mousetrap.bind(key, handlerProxy)
            keyHash[key] or= [$body]
            unless $target is $body
              keyHash[key] = _.without(keyHash[key], $target) # 移除栈区重复对象
              keyHash[key].unshift($target)
          )
        else delete hotkeys[keys]
      )
      if $target is $body
        _.extend($body.data('hotkeys'), hotkeys)
      else
        $target.data('hotkeys', hotkeys)
      return this

    remove: (context, keysList...) ->
      return this unless context
      removeAll = not keysList.length
      $target = context.$el or $body
      hotkeys = $target.data('hotkeys')
      if removeAll
        keysList = _.keys(context.hotkeys or {})
      if hotkeys
        _.each(keysList, (key) ->
          delete hotkeys[key]
          if removeAll and not $target is $body
            keyHash[key] = _.without(keyHash[key], $target)
        )
      return this

    reset: ->
      Mousetrap.reset()
      $body.data('hotkeys', {})
      keyHash = {}
      return this
  }
)