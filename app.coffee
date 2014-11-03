

code = ''
target = if Prototype.currentState == 'login' then 'text-code' else 'text-copies-count'

inputCode = (c) ->

  code += c

  Prototype.setText target, code

  if code.length == 4
    if code == '1505'
      target = 'text-copies-count'
      Prototype.gotoState 'main'
    else
      Prototype.show 'text-error-msg'
      _.delay ( ->
        Prototype.hide 'text-error-msg'
        code = ''
        Prototype.setText target, code
      ), 2000

backCode = ->
  code = code[0..-2]
  Prototype.setText target, code

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
      ]
      clear: [
        'text-copies-count'
      ]
      triggers:
        'log-off': -> Prototype.gotoState 'login'


proto = new Prototype(setup)