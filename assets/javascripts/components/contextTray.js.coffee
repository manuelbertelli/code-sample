###

  Usage:

    Alexandria.module("ContextTray")({
      "plugins": ["brands"],            // Default. Lista de plugins a exibir na bandeja.
      "brands":
        names: ["Alexandria"]           // Opcional. Lista de marcas para exibir. (serah carregado por ajax se ausente)
        onChange: function (brand) {}
    });

###

Alexandria.will.addComponent "bar:contextTray",

  getImpl: ->

    jqVersion = "1.10.2"

    getModule = (callback) ->

      Alexandria.require ["jqLoader"], (jqLoader) ->
        jqLoader jqVersion, ($) ->

          class ContextTray
            STYLE = """
              .alx-context-tray {
                background-color: #EEE;
                padding: 5px 20px;
                display: none;
              }
              .alx-context-tray .wrapper {
                display: inline-block;
                width: 220px;
                margin-left: 10px;
              }
              .alx-context-tray .wrapper:first-child { margin-left: 0;}
              .alx-context-tray .wrapper .dropdown-group { display: block; }
              .alx-context-tray .wrapper .btn { text-align: left; }
              .alx-context-tray .wrapper .btn i {
                float: right;
                margin-top: 3px;
              }
            """
            TEMPLATE = """<div class="alx-context-tray"></div>"""
            node = null
            brandsPluginSetup = (options = null) ->
              Alexandria.require ["BrandsSelector"], (BrandsSelector) ->
                bs = new BrandsSelector options
                bs.addEventListener "ready", (e) -> ContextTray.append bs.getNode()
                bs.addEventListener "error", (e, msg) -> ContextTray.hideWhenNone()
                bs.addEventListener "change", options.onChange if options?.onChange?
                bs.init()

            plugins = brands: brandsPluginSetup
            defaultOptions = -> plugins: ["brands"]
            getNode = -> node or= $ TEMPLATE
            injectStyle = -> $("<style />").text(STYLE).appendTo "head"

            constructor: (options) ->
              throw "Invalid parameter received" if typeof options isnt "object"
              options = $.extend defaultOptions(), options
              options.selector and= $ options.selector
              throw "None or many elements with that selector" if options.selector is null or options.selector.length isnt 1

              if (options.plugins or []).length
                plugins[pluginName]? options?[pluginName] for pluginName in options.plugins
                ContextTray.appendTo options.selector

            @appendTo: (selector) ->
              injectStyle()
              $(selector).append getNode()

            @append: (elements) ->
              contextTrayNode = getNode().filter(".alx-context-tray")

              contextTrayNode.append elements
              contextTrayNode.show()

            @hideWhenNone: -> getNode().hide() unless getNode().contents().length

          callback ContextTray

    (moduleCallback) -> getModule moduleCallback
