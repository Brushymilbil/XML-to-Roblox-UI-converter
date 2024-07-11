local bloxmlStarter = require(game.ReplicatedStorage:WaitForChild("BloxMl"):WaitForChild("BloXMLStarter"))
local backend = {
	["hello_Activated"] = function(sender: TextButton, obj : InputObject)
		warn("hello world!")
	end,
}

local source = [[
<TextButton Name = "HelloButton" Activated = "hello_Activated" Text = "Hello World!" TextScaled = "True" Font = "Ubuntu" 
BackgroundColor3 = "255, 255, 255" Size = "0, 200, 0, 50" Position = "0.5, 0, 0.5, 0">

 <UICorner CornerRadius = "0.1, 0"/>
 <UIStroke Color = "230, 230, 230" ApplyStrokeMode = "Border"/>
</TextButton>
]]

local objects = bloxmlStarter.load(source, backend)
objects[1].Parent = script.Parent
