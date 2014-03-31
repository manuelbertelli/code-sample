widgetsConfig.configure (config) ->
  config.addDomain "bar",
    "//#{window.location.host}/public/javascripts/will/components"
    true
  return
