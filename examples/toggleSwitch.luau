local bloxmlStarter = require(game.ReplicatedStorage:WaitForChild("BloxMl"):WaitForChild("BloXMLStarter"))
local ts = game:GetService("TweenService")

local info = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local linfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)

local toggled = false
local backend = {
	["Toggle_Activated"] = function(sender: TextButton, obj : InputObject)
		local goal = toggled and {Position = UDim2.fromScale(0, 0)} or {Position = UDim2.fromScale(0.583, 0)}
		local bgg = toggled and {BackgroundColor3 = Color3.new(1, 1, 1)} or {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}
		
		local st = ts:Create(sender, info, goal)
		local bgt = ts:Create(sender.Parent, linfo, bgg)
		
		st:Play()
		bgt:Play()
		
		st.Completed:Wait()
		toggled = not toggled
	end,
}

local source = [[
<!--this is a comment, and should be skipped!-->
<Frame Name = "ToggleSwitch" Size = "0, 96, 0, 73" Position = "0.5, 0, 0.5, 0" BackgroundColor3 = "255, 255, 255">
  <UIAspectRatioConstraint AspectRatio = "2.3"/>
  <UICorner CornerRadius = "0.5, 0"/>
  <UIStroke ApplyStrokeMode = "Border" Color = "173, 173, 173"/>
  
  <TextButton Name = "Toggle" Activated = "Toggle_Activated"  BackgroundColor3 = "255, 255, 255" Size = "0.5, 0, 0.95, 0" Text = " ">
  	 <UIAspectRatioConstraint />
  	 <UICorner CornerRadius = "1, 0"/>
  	 <UIStroke ApplyStrokeMode = "Border" Color = "230, 230, 230"/>
  </TextButton>
</Frame>
]]

local objects = bloxmlStarter.load(source, backend)
objects[1].Parent = script.Parent
