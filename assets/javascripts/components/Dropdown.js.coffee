Alexandria.will.addComponent "bar:Dropdown",
  getImpl: ->

    jqVersion = "1.10.2"

    getModule = (callback) ->

      Alexandria.require ["jqLoader", "EventTarget", "Module"], (jqLoader, EventTarget, Module) ->
        jqLoader jqVersion, ($) ->

          class Dropdown extends Module
            @include new EventTarget()

            STYLE = """
              .alx-dropdown .dropdown-menu { margin-top: 0; }
              .alx-dropdown .dropdown-menu li a {
                cursor: pointer;
                font-size: 14px;
                line-height: 20px;
              }
            """

            TEMPLATE = """
              <div class="dropdown-group alx-dropdown">
                <a class="btn">
                  <span class="name"></span>
                  <i class="icon-angle-down"></i>
                </a>
                <ul class="dropdown-menu"></ul>
              </div>
            """

            ITEM_TEMPLATE = "<li><a></a></li>"

            renderItem = (text) -> $(ITEM_TEMPLATE).find("a").text(text).end()
            add = (item) -> @getNode().find(".dropdown-menu").append item
            disable = -> @getNode().find(".btn").addClass "disabled"
            removeList = -> @getNode().find("ul").remove()
            removeIcon = -> @getNode().find("i").remove() 

            render = (items) ->
              if items
                add.call @, renderItem.call @, item for item in items
              else
                disable.call @
                removeList.call @
                removeIcon.call @

            bindEvents = ->
              @getNode().find("li a").click (e) =>
                e.preventDefault()
                @dispatchEvent "change", e.target.text
                
            setCurrent = (value) -> @getNode().find(".name").text value

            injectStyle = -> $("<style />").text(STYLE).appendTo "head"

            constructor: (@items, fallback = null) ->
              throw new Error "Items must be defined" unless items?

              if items?.length is 0
                @items = null
                setCurrent.call @, fallback if fallback?
              else
                @setSelected @items[0]

              EventTarget.call @
              render.call @, @items
              bindEvents.call @
              injectStyle.call @

            getNode: -> @node or= $ TEMPLATE
            appendTo: (selector) -> @getNode().appendTo selector

            setSelected: (value) ->
              @current = value
              setCurrent.call @, value

            getSelected: -> @current

          callback Dropdown

    (moduleCallback) -> getModule moduleCallback

  assets: [ "//assets.alexandria.abril.com.br/stylesheets/alx-ui.css" ]
