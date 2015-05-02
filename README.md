# Introduction #
A small framework for turning a series of SVG files into a clickable prototype.

Check out the full kitchen sink on [CodePen](http://codepen.io/cyanos/full/EjjvaL), to see what this library is capable of.

[Example](http://jayliu50.github.io/prototype-with-svg). *Hint: the access code is 1505*

# Features #
- Supports going between multiple svg "pages"

# Example Prototyping Workflow #

## 1. Prepare SVG in Adobe Illustrator ##

### Create an artboard for each view ###
*Basically:* follow the instructions from the excellent article [How designers can create interactive prototypes with Illustrator](http://tomgermeau.com/2014/02/how-designers-can-create-interactive-prototypes-with-illustrator/) -- See the heading Preparing your Illustrator document

### Create Visual Elements of Prototype ###
- Everything that will need to change will need a valid [CSS Class Name](http://stackoverflow.com/questions/448981/what-characters-are-valid-in-css-class-names-selectors)
- Overlay everything on top of each other.

### Create Hotspots ###
- Create hotspots above all the  (fill: white, no stroke)
- Name these hotspots with a valid [CSS Class Name](http://stackoverflow.com/questions/448981/what-characters-are-valid-in-css-class-names-selectors)
- *Suggestion:* Create a new layer containing all the hotspots that floats above all your other visual elements, to ensure that they are the top-most layer.

The following is a screenshot of what I have in Illustrator for the copy machine example given.
![The Layers of my Adobe Illustrator file](https://raw.githubusercontent.com/jayliu50/prototype-with-svg/master/example/illustrator/layers.png).


### Export ###
Choose Save a Copy -> Save as type SVG ->

I export from Illustrator to SVG using these settings

![Adobe Illustrator Export Settings](https://raw.githubusercontent.com/jayliu50/prototype-with-svg/master/readme-img/export-to-svg-settings.png)

## 2. Code ##

## Usage ##
```javascript
new Prototype(setup)
```

Where `setup` is an object containing two keys: `initialState` and `states`.

Each object in `states` can have the following keys:

#### view ####
String of the SVG file representing the current state's view

Example: `"Copy Machine Export-01.svg"`


#### hide ####
Array of all the IDs of elements to hide when the view is loaded

Example: `[ 'text-error-msg' ]`

#### clear ####
Array of all the IDs of elements containing text to clear when the view is loaded

Example: `[ 'text-code' ]`

#### hints ####
Object where the keys are the IDs of elements, and the values are the corresponding hover text to be displayed.

Example: `'numpad': 'Pssst! The access code is 1505'`

#### triggers ####
Object where the keys are the IDs of the elements, and the values are the functions that should be called when the element is pressed:

Example: `'numpad_0': function () { inputCode('0'); }`

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
- Can't clear the text of what shows up in Illustrator as "multi-line" text fields, the ones that are a `<g>` wrapped around a `<rect>` and a `<text>`.
    + *Workaround*: You are better off just hiding the entire `<g>` rather than trying to clear it
- Illustrator (CS5) does not export the text-anchor attribute. That means  text that will change in length at runtime will usually have to be left-aligned to look good.

# Next Steps #
- Well, fix some of those known issues. They really suck.
- Consideration of integrating other Javascript libraries (d3? angular? react? rivets?, snap.js?) into the mix for greater leverage and expressability.
- Add unit testing

# Acknowledgments #
Based on Tom Germeau's article that opened my mind about prototyping using Adobe Illustrator (or any SVG editor): [How designers can create interactive prototypes with Illustrator](http://tomgermeau.com/2014/02/how-designers-can-create-interactive-prototypes-with-illustrator/)

Typeface used in example is [Norwester by Jamie Wilson](http://jamiewilson.io/norwester/)
