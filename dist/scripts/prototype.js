this.Prototype = (function() {
  var clear, customInit, font, hide, init, initialState, prepareDom, states, triggers;

  initialState = null;

  states = null;

  font = null;

  triggers = null;

  clear = [];

  hide = [];

  customInit = null;

  function Prototype(setup) {
    if (setup != null) {
      if (setup.view != null) {
        setup.initialState = 'default';
        setup.states = {
          "default": {
            view: setup.view
          }
        };
      }
      initialState = setup.initialState, states = setup.states, font = setup.font;
      Prototype.gotoState(initialState);
      customInit = setup.init;
    }
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
    _.each(triggers.click, function(value, key) {
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
    return $("#" + selector).css('visibility', 'visible').css('display', 'block');
  };

  Prototype.gotoState = function(state) {
    return $.get("" + states[state].view, function(data) {
      $(document.body).empty().append(data.documentElement);
      new prepareDom($('svg'), font);
      init(states[state]);
      Prototype.currentState = state;
      if (customInit != null) {
        customInit();
      }
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

  Prototype.listIds = function() {
    return _.map($('*[id]'), function(elem) {
      return $(elem).attr('id');
    });
  };


  /*
  Helper Classes
   */

  prepareDom = (function() {
    var TEXTTOKEN, computeFontSize, makeTextInput, prepareStyles, transferAllAttributes, translateSvgAttributesToCssText;

    TEXTTOKEN = 'HTMLINPUT-TEXT';

    function prepareDom(svg, font) {
      var groups, rectangles, stupidIdExp, stupidIds;
      new prepareStyles(svg, font);
      $('[id]').each(function() {
        var ids;
        ids = $('[id="' + this.id + '"]');
        if (ids.length > 1 && ids[0] === this) {
          console.warn('Multiple IDs #' + this.id);
        }
      });
      stupidIds = $("*[id$='_']");
      stupidIdExp = /([a-z0-9-]+)_[0-9]+_/ig;
      _.each(stupidIds, function(id) {
        var elem, match;
        elem = $(id);
        match = stupidIdExp.exec(elem.attr('id'));
        if (match != null) {
          elem.attr('id', match[1]);
        }
      });
      rectangles = $("rect[id^=" + TEXTTOKEN + "]");
      _.each(rectangles, function(rect) {
        var rectangle;
        rectangle = $(rect);
        return rectangle.after(makeTextInput(rectangle, rectangle.attr('id')));
      });
      groups = $("g[id^=" + TEXTTOKEN + "]");
      _.each(groups, function(group) {
        var rectangle, text, textInput;
        group = $(group);
        rectangle = group.find('rect');
        text = group.find('text');
        textInput = makeTextInput(rectangle, group.attr('id'), text);
        textInput.on('input', function(event) {
          if (event.target.value.length) {
            return text.hide();
          } else {
            return text.show();
          }
        });
        text.css('pointer-events', 'none');
        return rectangle.after(textInput);
      });
    }

    translateSvgAttributesToCssText = function(destination, source) {
      destination.attr('placeholder', source.text());
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

    makeTextInput = function(rectangle, id, styleModel) {
      var foreignObject, textInput;
      foreignObject = $(document.createElementNS('http://www.w3.org/2000/svg', 'foreignObject'));
      transferAllAttributes(foreignObject, rectangle);
      textInput = $("<input type='text' />").addClass('PROTO-dynamic').css('font-size', computeFontSize(rectangle));
      if (id != null) {
        textInput.attr('id', id.substring(TEXTTOKEN.length + 1));
      }
      if (rectangle.attr('width')) {
        textInput.css('width', (rectangle.attr('width')) + "px");
      }
      if (rectangle.attr('height')) {
        textInput.css('height', (rectangle.attr('height')) + "px");
      }
      if (styleModel != null) {
        if (styleModel.attr('font-family')) {
          textInput.css('font-family', "" + (styleModel.attr('font-family')));
        }
        if (styleModel.attr('font-size')) {
          textInput.css('font-size', "" + (styleModel.attr('font-size')));
        }
      }
      foreignObject.append(textInput);
      return foreignObject;
    };

    prepareStyles = (function() {
      var replaceFonts;

      function prepareStyles(svg, font) {
        var families, fontSizeExp, newStyle, styles, svgStyle, weights;
        families = font.families, weights = font.weights, styles = font.styles;
        svgStyle = svg.find('style').text();
        fontSizeExp = /(font-size:[\d\.]+)/gi;
        newStyle = svgStyle.replace(fontSizeExp, '$1px');
        newStyle = replaceFonts(newStyle, families, weights, styles);
        svg.find('style').text(newStyle);
      }

      replaceFonts = function(stylesheet, families, weights, styles) {
        var fontFamilyExp, rules;
        rules = _.without(stylesheet.split('\n'), '');
        fontFamilyExp = /font-family:'([a-z0-9]+)-([a-z0-9]+)';/i;
        rules = _.map(rules, function(rule) {
          var fontFamily, match;
          match = fontFamilyExp.exec(rule);
          fontFamily = "";
          if (match) {
            fontFamily = "font-family: " + families[match[1]] + ";";
            if (_.has(weights, match[2])) {
              fontFamily += "font-weight: " + match[2] + ";";
            }
            if (_.has(styles, match[2])) {
              fontFamily += "font-style: " + match[2] + ";";
            }
            return rule.replace(match[0], fontFamily);
          } else {
            return rule;
          }
        });
        return rules.join('\n');
      };

      return prepareStyles;

    })();

    return prepareDom;

  })();

  return Prototype;

})();
