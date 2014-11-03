class @Prototype

  initialState = null
  states = null
  triggers = null

  constructor: (setup) ->
    {initialState, states, triggers} = setup
    @gotoState(initialState)

  init = (triggers) ->
    _.each triggers, (value, key) ->

      # todo: should probably check to see that each value is a function
      $("##{key}").on "click", value
      return

    return

  gotoState: (state) ->
    $.get states[state], (data) ->
      $(document.body).empty()
      $(document.body).append data.documentElement
      init(triggers)
      return