class @Prototype

  initialState = null
  states = null
  triggers = null
  clear = []
  hide = []

  TEXTTOKEN = 'HTMLINPUT-TEXT'

  constructor: (setup) ->
    {initialState, states} = setup

    Prototype.gotoState initialState

  translateSvgAttributesToCss = (destination, source) ->
    if source.attr 'width'
      destination.css('width', "#{source.attr('width')}px")
    if source.attr 'height'
      destination.css('height', "#{source.attr('height')}px")
    destination

  transferAllAttributes = (destination, source) ->
    attributes = source.prop 'attributes'
    _.each attributes, (value) ->
      if value.name isnt 'id'
        destination.attr value.name, value.value

  computeFontSize = (rectangle) ->
    size = parseInt(rectangle.attr('height') * .6)
    "#{size}pt"

  init = (state)->
    {view, clear, hide, hints, triggers, initialize} = state

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

    _.each hints, (value, key) ->
      $('body').attr "title", value # todo: implement fully

      # oops, svg doesn't support this, I don't think
      # $("##{key}")
      #   .attr 'title', value

    rectangles = $("rect[id^=#{TEXTTOKEN}]")
    _.each rectangles, (rect) ->

      rectangle = $(rect)

      foreignObject = $(document.createElementNS 'http://www.w3.org/2000/svg', 'foreignObject')
      transferAllAttributes foreignObject, rectangle

      foreignObject.append translateSvgAttributesToCss $("<textarea />").addClass('dynamic').attr('id', rectangle.attr('id').substring(TEXTTOKEN.length + 1)).css('font-size', computeFontSize(rectangle)), rectangle
      rectangle.after foreignObject

    return

  ###
  Static Methods
  ###

  ###
  # Sets the text of an element
  # @param {string} selector CSS selector
  # @param {string} text The new text to be displayed
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

  @mask: (selector) ->
      $("##{selector}").css 'color', 'white'
      $("##{selector}").css 'opacity', 1

  @unmask: (selector) ->
      $("##{selector}").css 'color', null
      $("##{selector}").css 'opacity', 0
