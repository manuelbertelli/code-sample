Alexandria.will.addComponent "bar:Event",
  getImpl: ->

    getModule = (callback) ->

      class Event
        constructor: (@type = null, @target = null, @currentTarget = null, @eventPhase = null, @bubbles = null, @cancelable = false, @timeStamp = null, @returnValue = true) ->

        initEvent: (sType, bCancelable = false) ->
          @type = sType
          @cancelable = bCancelable
          @timeStamp = (new Date()).getTime()

        preventDefault: -> @returnValue = false if @cancelable

        getEventDispatchReturn: -> eventDispatchReturn

      callback Event

    (callback) -> getModule callback
