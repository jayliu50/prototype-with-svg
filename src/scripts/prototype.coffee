class @Prototype

  initialState = null
  states = null
  font = null
  triggers = null
  clear = []
  hide = []
  customInit = null

  constructor: (setup) ->
    if setup?
      if setup.view?
        setup.initialState = 'default'
        setup.states =
          default:
            view: setup.view
      {initialState, states, font} = setup
      Prototype.gotoState initialState

      customInit = setup.init

  init = (state)->
    {view, clear, hide, hints, triggers, initialize} = state

    _.each clear, (selector) ->
      Prototype.clearText selector

    _.each initialize, (text, selector) ->
      Prototype.setText selector, text

    _.each triggers.click, (value, key) ->
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

  # todo: implement support for params list or fluent syntax
  # todo: implement recursive?
  @hide: (selector) ->
    $("##{selector}").css 'visibility', 'hidden'    # should probably check for existence first

  # todo: implement support for params list or fluent syntax
  # todo: implement recursive?
  @show: (selector) ->
    $("##{selector}").css('visibility', 'visible').css('display', 'block')   # should probably check for existence first

  @gotoState: (state) ->
    $.get "#{states[state].view}", (data) ->
      $(document.body).empty().append data.documentElement
      new prepareDom($('svg'), font)
      init(states[state])
      Prototype.currentState = state
      customInit() if customInit?
      return

  @currentState: null

  @mask: (selector) ->
      $("##{selector}").css 'color', 'white'
      $("##{selector}").css 'opacity', 1

  @unmask: (selector) ->
      $("##{selector}").css 'color', null
      $("##{selector}").css 'opacity', 0

  @listIds: () ->
    _.map $('*[id]'), (elem) ->
      return $(elem).attr 'id'

  ###
  Helper Classes
  ###

  class prepareDom
    TEXTTOKEN = 'HTMLINPUT-TEXT'

    constructor: (svg, font) ->
      new prepareStyles(svg, font)

      # Warning Duplicate IDs
      $('[id]').each ->
        ids = $('[id="' + @id + '"]')
        if ids.length > 1 and ids[0] == this
          console.warn 'Multiple IDs #' + @id
        return

      # fix the stupid illustrator's tendency to add _#_
      # todo: should probably still check for id collision though
      stupidIds = $("*[id$='_']")
      stupidIdExp = /([a-z0-9-]+)_[0-9]+_/ig
      _.each stupidIds, (id) ->
        elem = $(id)

        match = stupidIdExp.exec elem.attr 'id'
        if match?
          elem.attr 'id', match[1]

        return

      rectangles = $("rect[id^=#{TEXTTOKEN}]")
      _.each rectangles, (rect) ->
        rectangle = $(rect)
        rectangle.after makeTextInput rectangle, rectangle.attr 'id'

      # handle text with placeholders
      groups = $("g[id^=#{TEXTTOKEN}]")
      _.each groups, (group) ->
        group = $(group)
        rectangle = group.find 'rect'
        text = group.find 'text'
        textInput = makeTextInput rectangle, group.attr('id'), text
        textInput.on 'input', (event) ->
          if event.target.value.length
            text.hide()
          else
            text.show()

        text.css 'pointer-events', 'none'

        rectangle.after textInput


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

    makeTextInput = (rectangle, id, styleModel) ->
      foreignObject = $(document.createElementNS 'http://www.w3.org/2000/svg', 'foreignObject')
      transferAllAttributes foreignObject, rectangle

      textInput = $("<input type='text' />")
        .addClass 'PROTO-dynamic'
        .css('font-size', computeFontSize rectangle )

      textInput.attr('id', id.substring(TEXTTOKEN.length + 1)) if id?

      # infer styles from prototype rect
      if rectangle.attr 'width'
        textInput.css 'width', "#{rectangle.attr 'width'}px"
      if rectangle.attr 'height'
        textInput.css 'height', "#{rectangle.attr 'height'}px"
      # todo: also infer how much padding should be put in, based on the positioning of the text

      # todo: implement the creation of values instead of placeholder text

      # infer styles from placeholder text
      # todo: full implementation of placeholder styling required
      if styleModel?
        if styleModel.attr 'font-family'
          textInput.css 'font-family', "#{styleModel.attr 'font-family'}"
        if styleModel.attr 'font-size'
          textInput.css 'font-size', "#{styleModel.attr 'font-size'}"

      foreignObject.append textInput
      foreignObject

    class prepareStyles
      constructor: (svg, font) ->
        {families, weights, styles} = font

        # css processing (because silly Illustrator doesn't know how to write <style> elements properly)
        svgStyle = svg.find('style').text()
        fontSizeExp = /(font-size:[\d\.]+)/gi
        newStyle = svgStyle.replace fontSizeExp, '$1px'

        newStyle = replaceFonts newStyle, families, weights, styles

        svg.find('style').text newStyle

      replaceFonts = (stylesheet, families, weights, styles) ->
        rules = _.without (stylesheet.split '\n'), ''
        fontFamilyExp = /font-family:'([a-z0-9]+)-([a-z0-9]+)';/i #have to assume that hyphens are not allowed in font names
        rules = _.map rules, (rule) ->
          match = fontFamilyExp.exec rule
          fontFamily = ""
          if match
            # replace font name
            fontFamily = """font-family: #{families[match[1]]};"""
            if _.has weights, match[2]
              fontFamily += """font-weight: #{match[2]};"""

            if _.has styles, match[2]
              fontFamily += """font-style: #{match[2]};"""

            rule.replace match[0], fontFamily
          else
            rule

        rules.join '\n'