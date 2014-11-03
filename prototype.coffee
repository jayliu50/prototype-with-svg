class @Prototype

  initialState = null
  states = null
  triggers = null
  clear = []
  hide = []

  constructor: (setup) ->
    {initialState, states, triggers, clear, hide} = setup

    Prototype.gotoState initialState

  init = ->
    _.each clear, (selector) ->
      Prototype.setText selector, ""

    _.each triggers, (value, key) ->
      # todo: should probably check to see that each value is a function
      $("##{key}").on "click", value
      return

    _.each hide, (selector) ->
      Prototype.hide selector

    return

  ###
  Static Methods
  ###
  @setText: (selector, text) ->
    $("##{selector}")[0].innerHTML = text # should probably check for existence first

  @hide: (selector) ->
    $("##{selector}").css 'visibility', 'hidden'    # should probably check for existence first

  @show: (selector) ->
    $("##{selector}").css 'visibility', 'visible'   # should probably check for existence first

  @gotoState: (state) ->
    $.get "views/#{states[state]}", (data) ->
      $(document.body).empty()
      $(document.body).append data.documentElement
      init()
      return
