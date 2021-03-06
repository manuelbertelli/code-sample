window.Alexandria or= {}

Alexandria.will = window.widgetsConfig

MODULES =
  Cookie: "bar:Cookie"
  Brands: "bar:Brands"
  Dropdown: "bar:Dropdown"
  BrandsSelector: "bar:BrandsSelector"
  jqLoader: "bar:jQuery"
  ContextTray: "bar:contextTray"
  Event: "bar:Event"
  EventTarget: "bar:EventTarget"
  Module: "bar:Module"

PATHS =
  "jQuery-1.9.1": "/jslibs/jquery-1.9.1.min.js"
  "jQuery-1.10.2": "/jslibs/jquery-1.10.2.min.js"

Alexandria.require = (modules, callback = null) ->
  return Alexandria.will.call MODULES[modules] if typeof modules is "string"

  if modules instanceof Array
    returnModules = []
    totalModules = modules.length - 1
    currentModule = 0

    loadModule = ->
      Alexandria.will.call(MODULES[modules[currentModule]]) (moduleClass) ->
        returnModules.push moduleClass
        unless currentModule is totalModules
          currentModule++
          loadModule()
        else
          callback.apply null, returnModules

    loadModule()

Alexandria.path = (name, version) -> PATHS["#{name}-#{version}"]
