window.sharedExamplesForClassModule = ->
  describe "(inherited Module)", ->
    beforeEach ->
      class Teste
        @classProperty: true
        @classMethod: ->
        constructor: (@instanceProperty = true) -> 
        instanceMethod: ->

      @subject.extend Teste
      @subject.include new Teste()

    it "should extend another class", ->
      expect(@subject.classProperty).toBeDefined()
      expect(@subject.classProperty).toBeTruthy()
      expect(@subject.classMethod).toBeFunction()

    it "should include another object", ->
      testInstance = new @subject()
      expect(testInstance.instanceProperty).toBeDefined()
      expect(testInstance.instanceProperty).toBeTruthy()
      expect(testInstance.instanceMethod).toBeFunction()
