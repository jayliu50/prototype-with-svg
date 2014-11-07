## Introduction ##
Based on Tom Germeau's article that opened my mind about prototyping using Adobe Illustrator (or any SVG creator, for that matter): [How designers can create interactive prototypes with Illustrator](http://tomgermeau.com/2014/02/how-designers-can-create-interactive-prototypes-with-illustrator/)

## Known Issues ##
- Illustrator (CS5) sometimes increments the ID numerically without apparent reason, which is annoying
    + *Workaround*: Use a visual diff tool to see exactly how your SVG has changed. If the IDs are different, update that in code
- Can sometimes click on something that is not meant to be displayed
- It would be nice if there were some "headless" Javascript library that can automatically do some databinding.
- Can't clear the text of what shows up in Illustrator as "multi-line" text fields, the ones that are a `<g>` wrapped around a `<rect>` and a `<text>`.
    + *Workaround*: You are better off just hiding the entire `<g>` rather than trying to clear it
- Illustrator (CS5) does not export the text-anchor attribute, so dynamic text will usually have to be left-aligned to look good.
-