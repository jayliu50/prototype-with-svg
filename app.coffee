

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
        Prototype.setText 'text-code', code
      ), 2000

backCode = ->
  code = code[0..-2]
  Prototype.setText 'text-code', code

setup =
  initialState: 'login'
  clear: [
    'text-code'
  ]
  hide: [
    'text-error-msg'
  ]
  states:
    login: "Copy Machine Export-01.svg"
    main:  "Copy Machine Export-02.svg"
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


proto = new Prototype(setup)