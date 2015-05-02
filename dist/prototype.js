// Generated by CoffeeScript 1.9.2
this.Prototype = (function() {
  var clear, hide, init, initialState, prepareDom, states, triggers;

  initialState = null;

  states = null;

  triggers = null;

  clear = [];

  hide = [];

  function Prototype(setup) {
    if (setup != null) {
      initialState = setup.initialState, states = setup.states;
      Prototype.gotoState(initialState);
    }
    new prepareDom();
  }

  prepareDom = (function() {
    var TEXTTOKEN, computeFontSize, makeRectangle, rectangles, transferAllAttributes, translateSvgAttributesToCss;

    function prepareDom() {}

    TEXTTOKEN = 'HTMLINPUT-TEXT';

    translateSvgAttributesToCss = function(destination, source) {
      if (source.attr('width')) {
        destination.css('width', (source.attr('width')) + "px");
      }
      if (source.attr('height')) {
        destination.css('height', (source.attr('height')) + "px");
      }
      return destination;
    };

    transferAllAttributes = function(destination, source) {
      var attributes;
      attributes = source.prop('attributes');
      return _.each(attributes, function(value) {
        if (value.name !== 'id') {
          return destination.attr(value.name, value.value);
        }
      });
    };

    computeFontSize = function(rectangle) {
      var size;
      size = parseInt(rectangle.attr('height') * .6);
      return size + "pt";
    };

    makeRectangle = function(rectangle) {
      var foreignObject;
      foreignObject = $(document.createElementNS('http://www.w3.org/2000/svg', 'foreignObject'));
      transferAllAttributes(foreignObject, rectangle);
      foreignObject.append(translateSvgAttributesToCss($("<textarea />").addClass('dynamic').attr('id', rectangle.attr('id').substring(TEXTTOKEN.length + 1)).css('font-size', computeFontSize(rectangle)), rectangle));
      return foreignObject;
    };

    rectangles = $("rect[id^=" + TEXTTOKEN + "]");

    _.each(rectangles, function(rect) {
      var rectangle;
      rectangle = $(rect);
      return rectangle.after(makeRectangle(rectangle));
    });

    return prepareDom;

  })();

  init = function(state) {
    var hints, initialize, view;
    view = state.view, clear = state.clear, hide = state.hide, hints = state.hints, triggers = state.triggers, initialize = state.initialize;
    _.each(clear, function(selector) {
      return Prototype.clearText(selector);
    });
    _.each(initialize, function(text, selector) {
      return Prototype.setText(selector, text);
    });
    _.each(triggers, function(value, key) {
      $("#" + key).on("click", value).css('cursor', 'pointer');
    });
    _.each(hide, function(selector) {
      return Prototype.hide(selector);
    });
    _.each(hints, function(value, key) {
      return $('body').attr("title", value);
    });
  };


  /*
  Static Methods
   */


  /*
   * Sets the text of an element
   * @param {string} selector CSS selector
   * @param {string} text The new text to be displayed
   */

  Prototype.setText = function(selector, text) {
    var element;
    if ((text == null) || text === "") {
      text = '&nbsp';
    }
    element = $("#" + selector)[0];
    if (element != null) {
      return element.innerHTML = text;
    } else {
      return console.warn("setText: there is no id " + selector);
    }
  };

  Prototype.clearText = function(selector) {
    return Prototype.setText(selector, '');
  };

  Prototype.hide = function(selector) {
    return $("#" + selector).css('visibility', 'hidden');
  };

  Prototype.show = function(selector) {
    return $("#" + selector).css('visibility', 'visible');
  };

  Prototype.gotoState = function(state) {
    return $.get("views/" + states[state].view, function(data) {
      $(document.body).empty();
      $(document.body).append(data.documentElement);
      init(states[state]);
      Prototype.currentState = state;
    });
  };

  Prototype.currentState = null;

  Prototype.mask = function(selector) {
    $("#" + selector).css('color', 'white');
    return $("#" + selector).css('opacity', 1);
  };

  Prototype.unmask = function(selector) {
    $("#" + selector).css('color', null);
    return $("#" + selector).css('opacity', 0);
  };

  return Prototype;

})();
