class @Prototype

  initialState = null
  states = null
  triggers = null
  clear = []
  hide = []

  constructor: (setup) ->
    if setup?
      {initialState, states} = setup
      Prototype.gotoState initialState

    new prepareDom()

  class prepareDom
    TEXTTOKEN = 'HTMLINPUT-TEXT'

    translateSvgAttributesToCssText = (destination, source) ->
      destination.attr 'placeholder', source.text()
      destination

    transferAllAttributes = (destination, source) ->
      attributes = source.prop 'attributes'
      _.each attributes, (value) ->
        if value.name isnt 'id'
          destination.attr value.name, value.value

    computeFontSize = (rectangle) ->
      size = parseInt(rectangle.attr('height') * .6)
      "#{size}pt"

    makeTextarea = (rectangle, id, styleModel) ->
      foreignObject = $(document.createElementNS 'http://www.w3.org/2000/svg', 'foreignObject')
      transferAllAttributes foreignObject, rectangle

      textarea = $("<textarea />")
        .addClass 'PROTO-dynamic'
        .css('font-size', computeFontSize rectangle )

      textarea.attr('id', id.substring(TEXTTOKEN.length + 1)) if id?

      # infer styles from prototype rect
      if rectangle.attr 'width'
        textarea.css 'width', "#{rectangle.attr 'width'}px"
      if rectangle.attr 'height'
        textarea.css 'height', "#{rectangle.attr 'height'}px"

      # infer styles from placeholder text
      # todo: full implementation of placeholder styling required
      if styleModel?
        if styleModel.attr 'font-family'
          textarea.css 'font-family', "#{styleModel.attr 'font-family'}"
        if styleModel.attr 'font-size'
          textarea.css 'font-size', "#{styleModel.attr 'font-size'}"

      foreignObject.append textarea
      foreignObject

    rectangles = $("rect[id^=#{TEXTTOKEN}]")
    _.each rectangles, (rect) ->
      rectangle = $(rect)
      rectangle.after makeTextarea rectangle, rectangle.attr 'id'

    # handle text with placeholders
    groups = $("g[id^=#{TEXTTOKEN}]")
    _.each groups, (group) ->
      group = $(group)
      rectangle = group.find 'rect'
      text = group.find 'text'
      textarea = makeTextarea rectangle, group.attr('id'), text
      textarea.bind 'keyup', (event) ->
        if event.target.value.length
          text.hide()
        else
          text.show()

      text.css 'pointer-events', 'none'

      rectangle.after textarea

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
