// Generated by CoffeeScript 1.8.0
this.Prototype = (function() {
  var clear, hide, init, initialState, states, triggers;

  initialState = null;

  states = null;

  triggers = null;

  clear = [];

  hide = [];

  function Prototype(setup) {
    initialState = setup.initialState, states = setup.states;
    Prototype.gotoState(initialState);
  }

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
