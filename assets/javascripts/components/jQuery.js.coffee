Alexandria.will.addComponent "bar:jQuery",
  getImpl: ->

    alxJq = {}
    callback = null
    status = null
    version = "latest"
    currentLocation = null

    jQueryCDNLocation = (version) -> "//ajax.googleapis.com/ajax/libs/jquery/#{version}/jquery.min.js"
    jQueryDefaultLocation = (version) -> Alexandria.path "jQuery", version

    defineAlxJq = ->
      alxJq[version] or= $.noConflict true
      callback alxJq[version] if status is "success"
      return

    jqLoader = ->
      args = arguments
      if typeof args[0] is "string"
        version = args[0]
        callback = args[1]
      else
        callback = arguments[0]

      currentLocation = jQueryCDNLocation version

      Alexandria.will.use("jquery-#{version}@#{currentLocation}") (_status) ->
        status = _status

        if status is "error"
          currentLocation = jQueryDefaultLocation version
          Alexandria.will.use("jquery-#{version}@#{currentLocation}") (_status) ->
            status = _status
            if status is "error"
              document.querySelector("script[data-willjs-id='jquery-#{version}']").remove()
              throw new Error "Impossivel carregar o jQuery"
            else
              status = _status
              return defineAlxJq()
        else
          return defineAlxJq()

    (moduleCallback) -> moduleCallback jqLoader
