Alexandria.will.addComponent "bar:Cookie",
  getImpl: ->

    class Cookie
      @create: (name, value, days, domain) ->
        value = encodeURIComponent value
        if days
          date = new Date()
          date.setTime date.getTime() + (days * 24 * 60 * 60 * 1000)
          expires = "; expires=" + date.toGMTString()
        else
          expires = ""
        scope = if domain then "; domain=#{domain}" else ""
        document.cookie = "#{name}=#{value}#{expires}; path=/#{scope}"
        return

      @read: (name) ->
        nameEQ = name + "="
        ca = document.cookie.split(";")
        i = 0

        while i < ca.length
          c = ca[i]
          c = c.substring(1, c.length)  while c.charAt(0) is " "
          return decodeURIComponent c.substring(nameEQ.length, c.length)  if c.indexOf(nameEQ) is 0
          i++
        null

      @erase: (name, domain) -> Cookie.create name, "", -1, domain

    (callback) -> callback Cookie
