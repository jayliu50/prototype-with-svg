



setup =
  initialState: 'login'
  states:
    login: "Copy Machine Export-01.svg"
    main:  "Copy Machine Export-02.svg"
  triggers:
    num8_1_: ->
      alert "and it's still working"
      return

proto = new Prototype(setup)