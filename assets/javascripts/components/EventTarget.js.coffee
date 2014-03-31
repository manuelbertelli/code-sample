Alexandria.will.addComponent "bar:EventTarget",
  getImpl: ->

    getModule = (callback) ->

      Alexandria.require ["Event"], (Event) ->

        class EventTarget
          # PRIVATE
          addListener = (sType, fnListener) ->
            @eventhandlers[sType] = []  if typeof @eventhandlers[sType] is "undefined"
            @eventhandlers[sType][@eventhandlers[sType].length] = fnListener

          fire = (type, args = null) ->
            if typeof type is "string"
              oEvent = new Event type
            else
              oEvent = type

            oEvent.target = @
            unless typeof @eventhandlers[oEvent.type] is "undefined"
              i = 0

              while i < @eventhandlers[oEvent.type].length
                @eventhandlers[oEvent.type][i] oEvent, args
                i++
            
            oEvent.returnValue

          removeListener = (sType, fnListener) ->
            unless typeof @eventhandlers[sType] is "undefined"
              arrTemp = []
              i = 0

              while i < @eventhandlers[sType].length
                arrTemp[arrTemp.length] = @eventhandlers[sType][i]  unless @eventhandlers[sType][i] is fnListener
                i++
              @eventhandlers[sType] = arrTemp

          # STATIC
          @eventhandlers: {}
          @addEventListener: (type, listener) -> addListener.call @, type, listener
          @removeEventListener: (type, listener) -> removeListener.call @, type, listener
          @dispatchEvent: (event, args) -> fire.call @, event, args

          # INSTANCE
          constructor: (@eventhandlers = {}) ->
          addEventListener: (type, listener) -> addListener.call @, type, listener
          removeEventListener: (type, listener) -> removeListener.call @, type, listener
          dispatchEvent: (event, args) -> fire.call @, event, args

        callback EventTarget

    (callback) -> getModule callback
