// Generated by CoffeeScript 1.9.2
var adjustDarkness, adjustScale, backCode, backCopies, code, collate, copies, copyPage, cycleStaple, cycleTray, darkness, inputCode, inputCopies, load, mode, pagesCached, proto, refreshInputCopies, resetAll, scale, setCopies, setMode, setPagesCached, setScale, setSheetsRequired, setSided, setStaple, setTimeRemaining, setup, sheetsRequired, sided, staple, startOrStopCopying, startTimer, timeRemaining, toggleCollate, toggleLoad, toggleMode, toggleSided, tray;

code = '';

darkness = 0;

scale = 1;

tray = 0;

collate = false;

mode = false;

load = false;

copies = 0;

timeRemaining = 0;

sheetsRequired = 0;

staple = 0;

inputCode = function(c) {
  if (code.length > 4) {
    return;
  }
  code += c;
  Prototype.setText('text-code', code);
  if (code.length === 4) {
    if (code === '1505') {
      Prototype.gotoState('main');
    } else {
      Prototype.show('text-error-msg');
      _.delay((function() {
        Prototype.hide('text-error-msg');
        return Prototype.clearText('text-code');
      }), 2000);
    }
    return code = '';
  }
};

backCode = function() {
  code = code.slice(0, -1);
  return Prototype.setText('text-code', code);
};

inputCopies = function(c) {
  if (copies === 50) {
    copies = c;
  } else {
    copies = copies * 10 + c;
  }
  if (copies > 50) {
    copies = 50;
  }
  return setCopies(copies);
};

setCopies = function(copies) {
  if (copies === 0) {
    Prototype.mask('button-1_1_');
  } else {
    Prototype.unmask('button-1_1_');
  }
  Prototype.setText('text-copies-count', copies);
  return refreshInputCopies();
};

refreshInputCopies = function() {
  setSheetsRequired(copies * (pagesCached ? pagesCached : 1));
  return setTimeRemaining(sheetsRequired * 2 * (pagesCached ? pagesCached : 1));
};

backCopies = function() {
  copies = Math.floor(copies / 10);
  return setCopies(copies);
};

toggleLoad = function() {
  load = !load;
  if (load) {
    Prototype.show('toggle-at-feeder');
    Prototype.hide('toggle-at-copybed');
    return Prototype.mask('button-2_1_');
  } else {
    Prototype.hide('toggle-at-feeder');
    Prototype.show('toggle-at-copybed');
    return Prototype.unmask('button-2_1_');
  }
};

toggleMode = function() {
  mode = !mode;
  setMode(mode);
  return setSided(0);
};

setMode = function(m) {
  mode = m;
  if (mode) {
    Prototype.show('toggle-at-packet');
    Prototype.hide('toggle-at-single');
    Prototype.show('Packet');
    Prototype.show('toggle-at-copybed');
    load = false;
    Prototype.show('toggle-at-collate-no_2_');
    return collate = false;
  } else {
    Prototype.hide('toggle-at-packet');
    Prototype.show('toggle-at-single');
    Prototype.hide('Packet');
    Prototype.hide('toggle-at-feeder');
    Prototype.hide('toggle-at-copybed');
    Prototype.hide('toggle-at-collate-yes_1_');
    return Prototype.hide('toggle-at-collate-no_2_');
  }
};

toggleCollate = function() {
  collate = !collate;
  if (collate) {
    Prototype.show('toggle-at-collate-yes_1_');
    return Prototype.hide('toggle-at-collate-no_2_');
  } else {
    Prototype.hide('toggle-at-collate-yes_1_');
    return Prototype.show('toggle-at-collate-no_2_');
  }
};

cycleTray = function(direction) {
  if (direction) {
    tray++;
  } else {
    tray--;
  }
  if (tray === 3) {
    tray = 0;
  }
  if (tray === -1) {
    tray = 2;
  }
  switch (tray) {
    case 0:
      Prototype.setText('text-tray', 'Tray A 8.5 &times; 11');
      return setScale();
    case 1:
      Prototype.setText('text-tray', 'Tray B 11 &times; 17');
      return setScale();
    case 2:
      return Prototype.setText('text-tray', 'Tray C Custom');
  }
};

adjustScale = function(direction) {
  if (direction) {
    scale += .1;
  } else {
    scale -= .1;
  }
  if (scale < .1) {
    scale = .1;
  }
  return setScale();
};

setScale = function() {
  var height, newHeight, newWidth, textScale, width;
  width = 0;
  if (scale === 1) {
    width = null;
  } else {
    switch (tray) {
      case 0:
        width = 8.5;
        height = 11;
        break;
      case 1:
        width = 11;
        height = 17;
        break;
      case 2:
        width = null;
        height = null;
    }
  }
  textScale = (Math.floor(scale * 100 / 1)) + "%";
  if (width != null) {
    newWidth = width * scale;
    newHeight = height * scale;
    textScale += " " + (newWidth.toFixed(1)) + " &times; " + (newHeight.toFixed(1));
  }
  return Prototype.setText('text-scale', textScale);
};

adjustDarkness = function(direction) {
  if (direction) {
    darkness++;
  } else {
    darkness--;
  }
  if (darkness < 0) {
    return Prototype.setText('text-darkness', "Lighten " + (darkness * -1));
  } else if (darkness > 0) {
    return Prototype.setText('text-darkness', "Darken " + darkness);
  } else {
    return Prototype.setText('text-darkness', 'Normal');
  }
};

setTimeRemaining = function(t) {
  timeRemaining = t;
  if (timeRemaining === 0) {
    if (typeof startTimer !== "undefined" && startTimer !== null) {
      Prototype.setText('text-time-remaining', 'Done!');
      clearInterval(startTimer);
      startTimer === null;
      return _.delay((function() {
        Prototype.clearText('text-time-remaining');
        Prototype.show('text-start_1_');
        return Prototype.hide('text-stop');
      }), 2000);
    } else {
      return Prototype.clearText('text-time-remaining');
    }
  } else {
    return Prototype.setText('text-time-remaining', "Seconds remaining: " + timeRemaining);
  }
};

setSheetsRequired = function(s) {
  sheetsRequired = s;
  if (sheetsRequired === 0) {
    return Prototype.clearText('text-sheets-required');
  } else {
    return Prototype.setText('text-sheets-required', "Sheets Required: " + sheetsRequired);
  }
};

cycleStaple = function(direction) {
  if (direction) {
    staple++;
  } else {
    staple--;
  }
  if (staple === 3) {
    staple = 0;
  }
  if (staple === -1) {
    staple = 2;
  }
  return setStaple(staple);
};

setStaple = function(mode) {
  staple = mode;
  switch (mode) {
    case 0:
      return Prototype.setText('text-staple_2_', 'None');
    case 1:
      return Prototype.setText('text-staple_2_', 'Yes: Portrait');
    case 2:
      return Prototype.setText('text-staple_2_', 'Yes: Landscape');
  }
};

pagesCached = 0;

copyPage = function() {
  return setPagesCached(++pagesCached);
};

setPagesCached = function(pagesCached) {
  if (pagesCached === 0) {
    Prototype.mask('button-1_1_');
    Prototype.hide('text-pages-copied');
  } else {
    Prototype.show('text-pages-copied');
    Prototype.unmask('button-1_1_');
  }
  Prototype.setText('text-pages-copied', pagesCached + " Pages Copied");
  return refreshInputCopies();
};

startTimer = null;

startOrStopCopying = function() {
  if (startTimer != null) {
    Prototype.show('text-start_1_');
    Prototype.hide('text-stop');
    clearInterval(startTimer);
    return startTimer = null;
  } else {
    if (copies === 0) {
      return;
    }
    Prototype.show('text-stop');
    Prototype.hide('text-start_1_');
    return startTimer = setInterval((function() {
      return setTimeRemaining(--timeRemaining);
    }), 1000);
  }
};

sided = 0;

toggleSided = function(direction) {
  if (direction) {
    sided++;
  } else {
    sided--;
  }
  if (mode) {
    if (sided >= 4) {
      sided = 0;
    }
    if (sided < 0) {
      sided = 3;
    }
  } else {
    if (sided >= 2) {
      sided = 0;
    }
    if (sided < 0) {
      sided = 1;
    }
  }
  return setSided(sided);
};

setSided = function(sided) {
  if (mode) {
    switch (sided) {
      case 0:
        return Prototype.setText('text-sides', 'Single &dash; Single');
      case 1:
        return Prototype.setText('text-sides', 'Single &dash; Double');
      case 2:
        return Prototype.setText('text-sides', 'Double &dash; Single');
      case 3:
        return Prototype.setText('text-sides', 'Double &dash; Double');
    }
  } else {
    switch (sided) {
      case 0:
        return Prototype.setText('text-sides', 'Single Sided');
      case 1:
        return Prototype.setText('text-sides', 'Double Sided');
    }
  }
};

resetAll = function() {
  if (startTimer) {
    clearInterval(startTimer);
    startTimer = null;
  }
  darkness = 0;
  scale = 1;
  tray = 0;
  collate = false;
  mode = false;
  setMode(mode);
  load = false;
  copies = 0;
  setTimeRemaining(0);
  setSheetsRequired(0);
  setStaple(0);
  setPagesCached(0);
  setSided(0);
  Prototype.setText('text-darkness', 'Normal');
  Prototype.setText('text-scale', '100%');
  Prototype.setText('text-tray', 'Tray A 8.5 &times; 11');
  return Prototype.clearText('text-copies-count');
};

resetAll();

setup = {
  initialState: 'login',
  states: {
    login: {
      view: "Copy Machine Export-01.svg",
      hide: ['text-error-msg'],
      clear: ['text-code'],
      hints: {
        'numpad': 'Pssst! The access code is 1505'
      },
      triggers: {
        num0_1_: function() {
          return inputCode('0');
        },
        num1_1_: function() {
          return inputCode('1');
        },
        num2_1_: function() {
          return inputCode('2');
        },
        num3_1_: function() {
          return inputCode('3');
        },
        num4_1_: function() {
          return inputCode('4');
        },
        num5_1_: function() {
          return inputCode('5');
        },
        num6_1_: function() {
          return inputCode('6');
        },
        num7_1_: function() {
          return inputCode('7');
        },
        num8_1_: function() {
          return inputCode('8');
        },
        num9_1_: function() {
          return inputCode('9');
        },
        numback_1_: function() {
          return backCode();
        }
      }
    },
    main: {
      view: "Copy Machine Export-02.svg",
      hide: ['toggle-at-packet', 'toggle-at-feeder', 'toggle-at-collate-yes_1_', 'Packet', 'text-pages-copied', 'text-stop'],
      clear: ['text-copies-count', 'text-time-remaining', 'text-sheets-required'],
      triggers: {
        num0_1_: function() {
          return inputCopies(0);
        },
        num1_1_: function() {
          return inputCopies(1);
        },
        num2_1_: function() {
          return inputCopies(2);
        },
        num3_1_: function() {
          return inputCopies(3);
        },
        num4_1_: function() {
          return inputCopies(4);
        },
        num5_1_: function() {
          return inputCopies(5);
        },
        num6_1_: function() {
          return inputCopies(6);
        },
        num7_1_: function() {
          return inputCopies(7);
        },
        num8_1_: function() {
          return inputCopies(8);
        },
        num9_1_: function() {
          return inputCopies(9);
        },
        numback_1_: function() {
          return backCopies();
        },
        'log-off': function() {
          return Prototype.gotoState('login');
        },
        'load-from_2_': function() {
          return toggleLoad();
        },
        'toggle-single-packet': function() {
          return toggleMode();
        },
        'toggle-collate': function() {
          return toggleCollate();
        },
        'tray-up': function() {
          return cycleTray(true);
        },
        'tray-down': function() {
          return cycleTray(false);
        },
        'scale-up': function() {
          return adjustScale(true);
        },
        'scale-down': function() {
          return adjustScale(false);
        },
        'darkness-up': function() {
          return adjustDarkness(true);
        },
        'darkness-down': function() {
          return adjustDarkness(false);
        },
        'reset-all_2_': function() {
          return resetAll();
        },
        'staple-up': function() {
          return cycleStaple(true);
        },
        'staple-down': function() {
          return cycleStaple(false);
        },
        'sides-up': function() {
          return toggleSided(true);
        },
        'sides-down': function() {
          return toggleSided(false);
        },
        'button-2_1_': function() {
          return copyPage();
        },
        'button-1_1_': function() {
          return startOrStopCopying();
        }
      }
    }
  }
};

proto = new Prototype(setup);
