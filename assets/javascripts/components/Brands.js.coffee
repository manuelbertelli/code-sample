Alexandria.will.addComponent "bar:Brands",
  getImpl: ->

    jqVersion = "1.10.2"

    getModule = (callback) ->

      Alexandria.require ["Module", "Event", "EventTarget", "Cookie", "jqLoader"], (Module, Event, EventTarget, Cookie, jqLoader) ->
        jqLoader jqVersion, ($) ->

          class Brands extends Module
            @include new EventTarget()

            COOKIE_NAME = "alexandria_marca_selecionada"
            DOMAIN = ".alexandria.abril.com.br"
            MARCAS_SERVICE = "http://console-server.api.abril.com.br/marcas-do-usuario-autenticado"

            constructor: (@options) ->
              @options ?= {}
              @options.marcasService or= MARCAS_SERVICE
              EventTarget.call @

            getAuthUserBrands: (callback) ->
              $.ajax
                url: @options.marcasService
                success: (brands) => @dispatchEvent "getAuthUserBrands", brands
                xhrFields: withCredentials: true
                error: (xhr) => @dispatchEvent "getAuthUserBrands.error", xhr

            changeTo: (brand) ->
              current = Cookie.read COOKIE_NAME
              Cookie.create COOKIE_NAME, brand, null, DOMAIN unless current is brand

            getCurrent: -> Cookie.read COOKIE_NAME

          callback Brands

    (moduleCallback) -> getModule moduleCallback
