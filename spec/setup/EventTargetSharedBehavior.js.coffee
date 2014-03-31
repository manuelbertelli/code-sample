window.sharedExamplesForClassEventTarget = ->
  describe "(inherited EventTarget)", ->
    eventTeste = "teste"
    eventTriggered = null
    onEventTeste = (e) -> eventTriggered = true

    it "should have an event dispatcher", ->
      expect(@subject.dispatchEvent).toBeFunction()

    it "should have an event listener", ->
      expect(@subject.addEventListener).toBeFunction()

    it "should have an event remover", ->
      expect(@subject.removeEventListener).toBeFunction()

    it "should add an event listener", ->
      @subject.addEventListener eventTeste, onEventTeste
      @subject.dispatchEvent eventTeste
      expect(eventTriggered).toBeTruthy()
    
    it "should remove an event listener", ->
      @subject.addEventListener eventTeste, onEventTeste
      @subject.dispatchEvent eventTeste
      expect(eventTriggered).toBeTruthy()

      eventTriggered = false
      @subject.removeEventListener eventTeste, onEventTeste
      @subject.dispatchEvent eventTeste
      expect(eventTriggered).toBeFalsy()

    it "should dispatch an event", ->
      @subject.addEventListener eventTeste, onEventTeste
      @subject.dispatchEvent eventTeste
      expect(eventTriggered).toBeTruthy()
