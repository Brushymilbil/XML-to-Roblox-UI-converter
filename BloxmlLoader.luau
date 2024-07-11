local bloxmlParser = require (script.Parent:WaitForChild("BloXMLParser"))
local StringConverter = require (script.Parent:WaitForChild("StringConverter"))

local bloxmlloader = {}
bloxmlloader.__index = bloxmlloader

export type BloxmlLoader = typeof(setmetatable({} :: {
	containers: {xml_Container},
	backend: {[string]: (...any) -> ()}?
}, bloxmlloader))

local function load_container(container: xml_Container, listeners: {[string]: (...any) -> ()}): GuiObject
	local success, err:Instance = pcall(Instance.new, container.typename)
	assert(success, "Failed to load bloXML, type not found: "..tostring(err))
	assert(err:IsA("GuiObject") or err:IsA("UIBase"), "Failed to load bloXML, cannot create instances which are not Gui Elements or Modifiers.")
	
	for key, value in pairs(container.properties) do
		local typen = typeof(err[key])
		if typen == "RBXScriptSignal" then
			assert(listeners[value], "Event listener not found!")
			local targetfn = listeners[value]
			err[key]:Connect(function(...) targetfn(err, ...) end)
			
			continue
		elseif typen == "string" then
			err[key] = value
			continue
		elseif typen == "EnumItem" then
			err[key] = StringConverter.ToEnum(tostring(err[key]), value)
			continue
		end
		
		local converterFn = StringConverter["To"..typen]
		assert(converterFn, "Converter not found for type: "..typen)
		
		local iresult = converterFn(value)
		assert(iresult, "Failed to convert string rep, result was nil")
		
		err[key] = iresult
	end
	
	for _, child in ipairs(container.children) do
		local ui = load_container(child, listeners)
		ui.Parent = err
	end
	
	return err
end

function bloxmlloader.new(parsed_containers: {xml_Container}, listeners: {[string]: (...any) -> ()}?): BloxmlLoader
	return setmetatable({
		containers = parsed_containers,
		backend = listeners or {},
	}, bloxmlloader)
end

function bloxmlloader:GetResult(): {GuiObject}
	local result = {}
	
	for _, container in ipairs(self.containers) do
		table.insert(result, load_container(container, self.backend))
	end
	
	print("Component loaded successfully!")
	return result
end

function bloxmlloader:Dispose()
	table.clear(self.containers)
	table.clear(self.backend)
	table.clear(self)
end

return table.freeze(bloxmlloader)
