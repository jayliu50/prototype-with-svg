# Introduction #
A small framework for turning a series of SVG files into a clickable prototype.

# Features #
Check out the full kitchen sink on [CodePen](http://codepen.io/cyanos/full/EjjvaL) or this [example prototype of a copy machine interface](http://jayliu50.github.io/prototype-with-svg) to see what this library is capable of. *Hint: the access code is 1505*

- Supports going between multiple SVG "screens"
- Converts rectangles that are named with a special token into HTML input fields
- Collection of helper functions that make coding somewhat less repetitive

# Example Prototyping Workflow #

## 1. Prepare SVG (Adobe Illustrator) ##
*The following instructions are optimized for Adobe Illustrator, but you can use any program that edits SVG*

### Create an Artboard for each view ###
*Basically:* follow the instructions from the excellent article [How designers can create interactive prototypes with Illustrator](http://tomgermeau.com/2014/02/how-designers-can-create-interactive-prototypes-with-illustrator/) -- See the heading Preparing your Illustrator document

### Create Visual Elements of Prototype ###
- Everything you want to add functionality to later will need a valid [CSS Class Name](http://stackoverflow.com/questions/448981/what-characters-are-valid-in-css-class-names-selectors).
- Overlay everything on top of each other.

### Add Special Names to Unlock Functionality ###
*See [this CodePen](http://codepen.io/cyanos/full/EjjvaL) for all examples*

- Rectangles named with `HTMLINPUT-TEXT-[input-id]` turn into a `<input type="text">` with the id `input-id`

### Create Hotspots ###
- Create hotspots above all the  (fill: white, no stroke)
- Name these hotspots with a valid [CSS Class Name](http://stackoverflow.com/questions/448981/what-characters-are-valid-in-css-class-names-selectors)
- *Suggestion:* Create a new layer containing all the hotspots that floats above all your other visual elements, to ensure that they are all the top-most layer.

The following is a screenshot of what I have in Illustrator for the copy machine example given: [The Layers of my Adobe Illustrator file](https://raw.githubusercontent.com/jayliu50/prototype-with-svg/master/example/illustrator/layers.png).

### Export ###
Choose Save a Copy -> Save as type SVG -> I use [these settings](https://raw.githubusercontent.com/jayliu50/prototype-with-svg/master/readme-img/export-to-svg-settings.png)

## 2. Code ##
See the `example` folder for [the source code (CoffeeScript)](example/app.coffee) for the [copy machine prototype](http://jayliu50.github.io/prototype-with-svg).

1. Import `prototype.js` and `prototype.css` from the `dist` folder into your project.
2. Call `new Prototype(setup)` in your code. The optional parameter `setup` is an object containing two keys: `initialState` and `states` (see Configuration, below).

### Configuration ###
Protoype-with-svg provides a naive implementation of a state machine, so that it can support transitioning between one SVG and another. Each object in `states` can have the following keys:

#### view | string ####
The name of the SVG file representing the current state's view

Example: `"Copy Machine Export-01.svg"`

#### hide | array(string) ####
All the IDs of elements to hide when the state is loaded.

Example: `[ 'text-error-msg' ]`

#### clear | array(string) ####
All the IDs of elements containing text to clear when the state is loaded

Example: `[ 'text-code' ]`

#### hints | object(string, string) ####
This holds all of the tooltips. This should be an object where the keys are the IDs of elements, and the values are the corresponding tooltip text to be displayed.

Example: `'numpad': 'Pssst! The access code is 1505'`

#### triggers | object(string, function) ####
This holds all of the click events of your prototype. This should be an object where the keys are the IDs of the elements, and the values are the functions that should be called when the element is clicked:

Example: `'numpad_0': function () { inputCode('0'); }` this will call `inputCode('0')` when `numpad_0` is clicked

## Helper Functions ##
*This to be written about later, but here is a list of them so you can at least see what they are in `prototype.coffee|js`*

- setText
- clearText
- hide
- show
- gotoState
- mask
- unmask

## 3. Run ##

You will need some sort of HTTP server to see your prototype in action. I personally use npm's `http-server`, but many other options abound, such as `python -m SimpleHTTPServer`

## About the Example Code ##
It's written in CoffeeScript, but you can refer to the Javascript output as well.

# Known Issues #
- Illustrator (CS5) sometimes increments the ID numerically, appending `_1_` etc., without apparent reason, which is annoying.
    + *Workaround*: Use a visual diff tool to see exactly how your SVG has changed. If the IDs are different, update that in code.
- Can sometimes click on something that is not meant to be displayed. I think this is because there are still events attached that should not be there.
- It would be nice if there were some "headless" Javascript library that can automatically do some databinding.
- Can't yet clear the text of what shows up in Illustrator as "multi-line" text fields, the ones that are a `<g>` wrapped around a `<rect>` and a `<text>`.
    + *Workaround*: You are better off just hiding the entire `<g>` rather than trying to clear it
- Illustrator (CS5) does not export the text-anchor attribute. That means  text that will change in length at runtime will usually have to be left-aligned to look good.

# Next Steps #
- Well, fix some of those known issues. They really suck.
- Consideration of integrating other Javascript libraries (d3? angular? react? rivets?, snap.js?) into the mix for greater leverage and expressability.
- Add unit testing
- Improve deployment and dependencies (Yeoman? bower? jQuery plugin? requirejs?)
- Make the examples and documentation prettier and more complete.
- Let me know what functionality should be added!

# Acknowledgments #
Based on Tom Germeau's article that opened my mind about prototyping using Adobe Illustrator (or any SVG editor): [How designers can create interactive prototypes with Illustrator](http://tomgermeau.com/2014/02/how-designers-can-create-interactive-prototypes-with-illustrator/)

Typeface used in example is [Norwester by Jamie Wilson](http://jamiewilson.io/norwester/)
