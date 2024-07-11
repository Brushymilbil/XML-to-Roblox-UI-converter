# XML-to-Roblox-UI-converter
This is a simple converter that parses xml &amp; creates UI elements from it. It is handwritten so don't expect it to perform better than Auto - Generated ones these days...

**How to use:**

1. Move the modules somewhere the _client_ can access, because this is a _client sided_ module.
2. Make sure all of the modules are in one folder, or at least share the same parent.
3. load on the _client_.

**Tutorial:**

 basically, this is just xml but all of the tags have been replaced with ROBLOX UI types like TextButton etc...
 and all of the objects inside of other objects become children instead of editing the 'content' property like you'd see in XAML.
 if you don't know xml, then here is a simple format you can follow when creating elements:
 ```xml
   <typename Property = "value"/> <!-- for when your element does not have children -->
   <typename Property = "value">
     <!--children go here -->
   </typename>
 ```

**Formatting:**

in xml, everything is a string, so obviously, every supported data type has a specific format.
Below the formats of the currently supported types:

* UDim2:
  "xscale, xoffset, yscale, yoffset" - in this format, you need 4 numbers separated by comma's, each represents a component from UDim2. It is in the same order as the constructor parameters.
* UDim:
  "scale, offset" - same as UDim2, but with only 2 numbers, no more, no less, each represents a different component of a UDim. It is in the same order as the constructor parameters.
* Color3:
  "R, G, B" - same as UDim2, but with 3 numbers this time, each number needs to be a value in range 0 - 255.
* Enum:
  the name of the enum item, excluding the enum's name, eg: "Border" instead of "ApplyStrokeMode.Border".
* boolean:
  either True/true or False/false
* number:
  any character in range 0 - 9, the dot is also allowed.
* event listeners:
  the name of the event listener inside of the listeners dictionary.

**Usage:**

so you can actually just ignore the other modules, because they are just required internally but you can just use the BloxmlStarter.load() function, which calls all module's function and returns the result.
Obvisouly this will error if your xml is invalid (or a bug occurs).

example of a simple button that prints "clicked" when activated:
```luau
local starter = require (path to BloxmlStarter)
local listeners = {
  ["ButtonClick"] = function(sender, ...)
      print("Clicked!")
  end
}

local source = [[
<TextButton Name = "MyButton" Activated = "ButtonClick" Text = "Click me!" Position = "0.5, 0, 0.5, 0" Size = "0, 200, 0, 50" BackgroundColor3 = "255, 255, 255" TextScaled = "True">
  <UICorner CornerRadius = "0.1, 0"/>
  <UIStroke Color = "230, 230, 230" ApplyStrokeMode = "Border"/>
</TextButton>
]]

--the result is an array of UI elements, they aren't parented to any screen Gui by default.
local result = starter.load(source, listeners)
result[1] = --your screen gui
```

you can obviously also just call each module manually.
**comenting is supported btw, so you can use <!-- --> in your source, not that you would want to**

Thanks for reading!
