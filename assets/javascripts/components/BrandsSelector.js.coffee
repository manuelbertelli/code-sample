Alexandria.will.addComponent "bar:BrandsSelector",
  getImpl: ->

    jqVersion = "1.10.2"

    getModule = (callback) ->

      Alexandria.require ["Module", "Event", "EventTarget", "Brands", "Dropdown", "jqLoader"], (Module, Event, EventTarget, Brands, Dropdown, jqLoader) ->
        jqLoader jqVersion, ($) ->

          class BrandsSelector extends Module
            @include new EventTarget()

            dispatchReady = ->
              readyEvent = new Event()
              readyEvent.initEvent "ready", true
              @dispatchEvent readyEvent

            dispatchError = ->
              errorEvent = new Event()
              errorEvent.initEvent "error", true
              @dispatchEvent errorEvent, "Impossível resgatar as marcas do usuário. Usuário deslogado."

            listenDropdownChange = ->
              @dropdown.addEventListener "change", (e, brand) =>
                changeEvent = new Event()
                changeEvent.initEvent "change", true
                if @dispatchEvent changeEvent, brand
                  @brandsService.changeTo brand
                  window.location.reload()

            getBrands = (callback) ->
              if @brands?
                callback()
              else
                @brandsService.addEventListener "getAuthUserBrands", (e, @brands) => callback()

                @brandsService.addEventListener "getAuthUserBrands.error", (e, xhr) => error.call @ if dispatchError.call @

                @brandsService.getAuthUserBrands()

            ready = ->
              if dispatchReady.call @
                @current = @brandsService.getCurrent()
                @dropdown.setSelected @current if @current? and @current in @brands
                @brandsService.changeTo @dropdown.getSelected()

              listenDropdownChange.call @

            error = ->

            setDropdown = -> @dropdown = new Dropdown @brands, "(sem marcas)"

            constructor: (@options = {}) ->
              EventTarget.call @
              @brandsService = new Brands @options.brandsOptions
              @options.brands ?= null
              @brands = @options.brands

            init: ->
              getBrands.call @, =>
                setDropdown.call @
                ready.call @

            appendTo: (selector) -> @dropdown.appendTo selector
            getNode: -> @dropdown.getNode()

          callback BrandsSelector

    (callback) -> getModule callback
