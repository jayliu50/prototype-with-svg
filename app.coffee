

code = ''

inputCode = (c) ->

  code += c

  Prototype.setText 'text-code', code

  if code.length == 4
    if code == '1505'
      Prototype.gotoState 'main'
    else
      Prototype.show 'text-error-msg'
      _.delay ( ->
        Prototype.hide 'text-error-msg'
        code = ''
        Prototype.clearText 'text-code'
      ), 2000

backCode = ->
  code = code[0..-2]
  Prototype.setText 'text-code', code


copies = 0
inputCopies = (c) ->
  copies = copies * 10 + c
  copies = 50 if copies > 50
  # copies = 1 if copies <= 0
  Prototype.setText 'text-copies-count', copies

backCopies = ->
  copies = copies // 10
  # copies = 1 if copies <= 0
  Prototype.setText 'text-copies-count', copies

load = false # copy bed
toggleLoad = ->
  load = !load
  if load
    Prototype.show 'toggle-at-feeder'
    Prototype.hide 'toggle-at-copybed'
  else
    Prototype.hide 'toggle-at-feeder'
    Prototype.show 'toggle-at-copybed'


mode = false # single sheet
toggleMode = ->
  mode = !mode
  if mode
    Prototype.show 'toggle-at-packet'
    Prototype.hide 'toggle-at-single'
    Prototype.show 'Packet'
    Prototype.hide 'text-start'

    Prototype.show 'toggle-at-copybed'
    load = false
    Prototype.show 'toggle-at-collate-no'
    collate = false

  else
    Prototype.hide 'toggle-at-packet'
    Prototype.show 'toggle-at-single'
    Prototype.hide 'Packet'
    Prototype.show 'text-start'

    Prototype.hide 'toggle-at-feeder'
    Prototype.hide 'toggle-at-copybed'
    Prototype.hide 'toggle-at-collate-yes_1_'
    Prototype.hide 'toggle-at-collate-no'

collate = false # do not collate
toggleCollate = ->
  collate = !collate
  if collate
    Prototype.show 'toggle-at-collate-yes_1_'
    Prototype.hide 'toggle-at-collate-no'
  else
    Prototype.hide 'toggle-at-collate-yes_1_'
    Prototype.show 'toggle-at-collate-no'

tray = 0
cycleTray = (direction) ->
  switch tray
    when 0 then Prototype.setText 'text-tray', 'Tray A 8.5 &times; 11'
    when 1 then Prototype.setText 'text-tray', 'Tray B 11 &times; 17'
    when 2 then Prototype.setText 'text-tray', 'Tray C Custom'

  if direction
    tray++
  else
    tray--
  tray = 0 if tray == 3
  tray = 2 if tray == -1

scale = 1
cycleScale = (direction) ->
  switch

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
        'load-from': -> toggleLoad()
        'toggle-single-packet': -> toggleMode()
        'toggle-collate': -> toggleCollate()
        'tray-up': -> cycleTray(true)
        'tray-down': -> cycleTray(false)


proto = new Prototype(setup)