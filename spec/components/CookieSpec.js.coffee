describe "Cookie", ->
  Cookie = null
  cookieName = "testCookie"
  cookieValue = "valor do cookie"
  cookieDomain = null

  beforeEach ->
    runs -> Alexandria.require ["Cookie"], (CookieModule) -> Cookie = CookieModule

    waitsFor -> Cookie
      ,
      "Cookie be loaded"

  describe "in my domain", ->
    beforeEach ->
      cookieDomain = ".alexandria.abril.com.br"

    it "should create a cookie", ->
      runs -> 
        Cookie.create cookieName, cookieValue, null, cookieDomain
        expect(Cookie.read cookieName).toEqual cookieValue

    it "should read a cookie", ->
      runs ->
        expect(Cookie.read cookieName).toEqual cookieValue

    it "should erase a cookie", ->
      runs ->
        Cookie.erase cookieName, cookieDomain
        expect(Cookie.read cookieName).toBeNull()

  describe "in another domain", ->
    beforeEach ->
      cookieDomain = ".anotherdomain.com.br"

    it "should not create a cookie", ->
      runs -> 
        Cookie.create cookieName, cookieValue, null, cookieDomain
        expect(Cookie.read cookieName).not.toEqual cookieValue
