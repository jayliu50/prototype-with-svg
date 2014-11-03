

code = ''
darkness = 0
scale = 1
tray = 0
collate = false # do not collate
mode = false # single sheet
load = false # copy bed
copies = 0
timeRemaining = 0
sheetsRequired = 0
staple = 0

inputCode = (c) ->

  return if code.length > 4

  code += c
  Prototype.setText 'text-code', code

  if code.length == 4
    if code == '1505'
      Prototype.gotoState 'main'
    else
      Prototype.show 'text-error-msg'
      _.delay ( ->
        Prototype.hide 'text-error-msg'
        Prototype.clearText 'text-code'
      ), 2000
    code = ''

backCode = ->
  code = code[0..-2]
  Prototype.setText 'text-code', code


inputCopies = (c) ->
  if copies == 50
    copies = c
  else
    copies = copies * 10 + c

  copies = 50 if copies > 50
  # copies = 1 if copies <= 0
  Prototype.setText 'text-copies-count', copies

  # todo: handle other case
  setSheetsRequired copies
  setTimeRemaining sheetsRequired * 2

backCopies = ->
  copies = copies // 10
  # copies = 1 if copies <= 0
  Prototype.setText 'text-copies-count', copies

toggleLoad = ->
  load = !load
  if load
    Prototype.show 'toggle-at-feeder'
    Prototype.hide 'toggle-at-copybed'
  else
    Prototype.hide 'toggle-at-feeder'
    Prototype.show 'toggle-at-copybed'

toggleMode = ->
  mode = !mode
  setMode mode

setMode = (mode)->
  if mode
    Prototype.show 'toggle-at-packet'
    Prototype.hide 'toggle-at-single'
    Prototype.show 'Packet'
    Prototype.hide 'text-start_1_'

    Prototype.show 'toggle-at-copybed'
    load = false
    Prototype.show 'toggle-at-collate-no_2_'
    collate = false

  else
    Prototype.hide 'toggle-at-packet'
    Prototype.show 'toggle-at-single'
    Prototype.hide 'Packet'
    Prototype.show 'text-start_1_'

    Prototype.hide 'toggle-at-feeder'
    Prototype.hide 'toggle-at-copybed'
    Prototype.hide 'toggle-at-collate-yes_1_'
    Prototype.hide 'toggle-at-collate-no_2_'

toggleCollate = ->
  collate = !collate
  if collate
    Prototype.show 'toggle-at-collate-yes_1_'
    Prototype.hide 'toggle-at-collate-no_2_'
  else
    Prototype.hide 'toggle-at-collate-yes_1_'
    Prototype.show 'toggle-at-collate-no_2_'

cycleTray = (direction) ->

  if direction
    tray++
  else
    tray--
  tray = 0 if tray == 3
  tray = 2 if tray == -1

  switch tray
    when 0
      Prototype.setText 'text-tray', 'Tray A 8.5 &times; 11'
      setScale()
    when 1
      Prototype.setText 'text-tray', 'Tray B 11 &times; 17'
      setScale()
    when 2 then Prototype.setText 'text-tray', 'Tray C Custom'


adjustScale = (direction) ->
  if direction # scale up
    scale += .1
  else
    scale -= .1

  scale = .1 if scale < .1
  setScale()

setScale = ->
  width = 0

  if scale == 1
    width = null
  else
    switch tray
      when 0
        width = 8.5
        height = 11
      when 1
        width = 11
        height = 17
      when 2
        width = null
        height = null


  textScale = "#{scale * 100 // 1}%"
  if width?
    newWidth = width * scale
    newHeight = height * scale
    textScale += " #{newWidth.toFixed 1} &times; #{newHeight.toFixed 1}"

  Prototype.setText 'text-scale', textScale


adjustDarkness = (direction) ->
  if direction # darker
    darkness++
  else
    darkness--

  if darkness < 0
    Prototype.setText 'text-darkness', "Lighten #{darkness * -1}"
  else if darkness > 0
    Prototype.setText 'text-darkness', "Darken #{darkness}"
  else
    Prototype.setText 'text-darkness', 'Normal'

setTimeRemaining = (t) ->
  timeRemaining = t
  if timeRemaining == 0
    Prototype.clearText 'text-time-remaining'
  else
    Prototype.setText 'text-time-remaining', "Seconds remaining: #{timeRemaining}"

setSheetsRequired = (s) ->
  sheetsRequired = s
  if sheetsRequired == 0
    Prototype.clearText 'text-sheets-required'
  else
    Prototype.setText 'text-sheets-required', "Sheets Required: #{sheetsRequired}"


cycleStaple = (direction) ->
  if direction
    staple++
  else
    staple--

  staple = 0 if staple == 3
  staple = 2 if staple == -1

  setStaple staple

setStaple = (mode) ->
  staple = mode

  switch mode
    when 0 then Prototype.setText 'text-staple_2_', 'None'
    when 1 then Prototype.setText 'text-staple_2_', 'Yes: Portrait'
    when 2 then Prototype.setText 'text-staple_2_', 'Yes: Landscape'

resetAll = ->
  darkness = 0
  scale = 1
  tray = 0
  collate = false # do not collate
  mode = false # single sheet
  setMode mode
  load = false # copy bed
  copies = 0
  timeRemaining = 0
  setTimeRemaining()
  sheetsRequired = 0
  setSheetsRequired()
  setStaple 0

  Prototype.setText 'text-darkness', 'Normal'
  Prototype.setText 'text-scale', '100%'
  Prototype.setText 'text-tray', 'Tray A 8.5 &times; 11'
  Prototype.clearText 'text-copies-count'

resetAll()

setup =
  # initialState: 'login'
  initialState: 'main'

  states:
    login:
      view: "Copy Machine Export-01.svg"
      hide: [
        'text-error-msg'
      ]
      clear: [
        'text-code'
      ]
      triggers:
        num0_1_: -> inputCode('0')
        num1_1_: -> inputCode('1')
        num2_1_: -> inputCode('2')
        num3_1_: -> inputCode('3')
        num4_1_: -> inputCode('4')
        num5_1_: -> inputCode('5')
        num6_1_: -> inputCode('6')
        num7_1_: -> inputCode('7')
        num8_1_: -> inputCode('8')
        num9_1_: -> inputCode('9')
        numback_1_: -> backCode()
    main:
      view: "Copy Machine Export-02.svg"
      hide: [
        'toggle-at-packet'
        'toggle-at-feeder'
        'toggle-at-collate-yes_1_'
        'Packet'
      ]
      clear:[
        'text-copies-count'
        'text-time-remaining'
        'text-sheets-required'
      ]
      triggers:
        num0_1_: -> inputCopies(0)
        num1_1_: -> inputCopies(1)
        num2_1_: -> inputCopies(2)
        num3_1_: -> inputCopies(3)
        num4_1_: -> inputCopies(4)
        num5_1_: -> inputCopies(5)
        num6_1_: -> inputCopies(6)
        num7_1_: -> inputCopies(7)
        num8_1_: -> inputCopies(8)
        num9_1_: -> inputCopies(9)
        numback_1_: -> backCopies()
        'log-off': -> Prototype.gotoState 'login'
        'load-from_2_': -> toggleLoad()
        'toggle-single-packet': -> toggleMode()
        'toggle-collate': -> toggleCollate()
        'tray-up': -> cycleTray(true)
        'tray-down': -> cycleTray(false)
        'scale-up': -> adjustScale(true)
        'scale-down': -> adjustScale(false)
        'darkness-up': -> adjustDarkness(true)
        'darkness-down': -> adjustDarkness(false)
        'reset-all_2_': -> resetAll()
        'staple-up': -> cycleStaple(true)
        'staple-down': -> cycleStaple(false)


proto = new Prototype(setup)