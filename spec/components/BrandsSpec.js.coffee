describe "Brands", ->
  beforeEach ->
    runs ->
      Alexandria.require ["Brands"], (BrandsModule) =>
        @Brands = BrandsModule

    waitsFor ->
        @Brands
      ,
      "Brands be loaded"

  describe "class", ->
    beforeEach ->
      runs ->
        @subject = @Brands

    sharedExamplesForClassModule()

    it "can be instantiated", ->
      expect(new @Brands()).toBeInstanceOf @Brands

  describe "instance", ->
    open = null

    beforeEach ->
      runs ->
        marcasService = "http://#{window.location.host}/spec/fixtures/marcas.json"
        @brands = new @Brands(marcasService: marcasService)
        @subject = @brands # used for sharedExample
        open = XMLHttpRequest.prototype.open
        XMLHttpRequest.prototype.open = ->
          arguments[1] = marcasService
          open.apply @, arguments

    afterEach ->
      runs ->
        XMLHttpRequest.prototype.open = open

    sharedExamplesForClassEventTarget()

    describe "when getting all brands from the authenticated user", ->
      it "should return all user Brands", ->
        eventTriggered = null
        loadedBrands = null

        runs ->
          @brands.addEventListener "getAuthUserBrands", (e, brands) ->
            eventTriggered = true
            loadedBrands = brands

        waitsFor ->
            @brands.getAuthUserBrands()
            loadedBrands
          ,
          "loadedBrands is defined"

        runs ->
          expect(eventTriggered).toBeTruthy()
          expect(loadedBrands).toEqual ["Marca1", "Marca2"]

    describe "when manipulating brands", ->
      it "should change and retrieve the current brand", ->
        runs ->
          oldBrand = @brands.getCurrent()
          newBrand = "nova marca"
          @brands.changeTo newBrand
          currentBrand = @brands.getCurrent()

          expect(currentBrand).not.toBe oldBrand
          expect(currentBrand).toBe newBrand
