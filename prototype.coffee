class @Prototype

  initialState = null
  states = null
  triggers = null
  clear = []
  hide = []

  constructor: (setup) ->
    {initialState, states} = setup

    Prototype.gotoState initialState

  init = (state)->
    {view, clear, hide, triggers, initialize} = state

    _.each clear, (selector) ->
      Prototype.clearText selector

    _.each initialize, (text, selector) ->
      Prototype.setText selector, text

    _.each triggers, (value, key) ->
      # todo: should probably check to see that each value is a function
      $("##{key}")
        .on "click", value
        .css 'cursor', 'pointer'
      return

    _.each hide, (selector) ->
      Prototype.hide selector

    return

  ###
  Static Methods
  ###
  @setText: (selector, text) ->
    text = '&nbsp' if !text? || text == "" # never let the string go to the empty string because the text will get reflowed
    element = $("##{selector}")[0]

    if element?
      element.innerHTML = text
    else
      console.warn "setText: there is no id #{selector}"

  @clearText = (selector) ->
    Prototype.setText selector, ''

  @hide: (selector) ->
    $("##{selector}").css 'visibility', 'hidden'    # should probably check for existence first

  @show: (selector) ->
    $("##{selector}").css 'visibility', 'visible'   # should probably check for existence first

  @gotoState: (state) ->
    $.get "views/#{states[state].view}", (data) ->
      $(document.body).empty()
      $(document.body).append data.documentElement
      init(states[state])
      Prototype.currentState = state
      return

  @currentState: null
