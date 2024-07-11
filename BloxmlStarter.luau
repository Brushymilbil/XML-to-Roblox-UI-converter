local bloxmlTokenizer = require (script.Parent:WaitForChild("BloXMLTokenizer"))
local bloxmlParser = require (script.Parent:WaitForChild("BloXMLParser"))
local bloxmlLoader = require (script.Parent:WaitForChild("BloXMLLoader"))

local bloxmlstarter = {}

function bloxmlstarter.load(source: string, backend: {[string]: (...any) -> ()}?): {GuiObject}
	local tkn = bloxmlTokenizer.new(source)
	tkn:Tokenize()
	
	local prsr = bloxmlParser.new(tkn.result)
	prsr:Parse()
	tkn:Dispose()
	
	local objectLoader = bloxmlLoader.new(prsr.result, backend)
	local result = objectLoader:GetResult()
	
	prsr:Dispose()
	objectLoader:Dispose()
	
	print("Element with given BloXML description loaded successfully!")
	return result
end

return bloxmlstarter
