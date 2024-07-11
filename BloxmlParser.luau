local BloxmlTokenizer = require (script.Parent:WaitForChild("BloXMLTokenizer"))

local bloxmlparser = {}
bloxmlparser.__index = bloxmlparser

export type xml_Container = {
	typename: string,
	properties: {[string]: string},
	children: {xml_Container},
}

export type BloxmlParser = typeof(setmetatable({} :: {
	sourceTokens: {BloxmlToken},
	result: {xml_Container},
	position: number,
}, bloxmlparser))

local function parse_tag(bloxmlparser: BloxmlParser): xml_Container
	assert(bloxmlparser.sourceTokens[bloxmlparser.position].TokenType == 3, "A tag must start with a '<'!")
	bloxmlparser.position += 1 --skip the '<'
	
	assert(bloxmlparser.sourceTokens[bloxmlparser.position].TokenType == 1, "Expected identifier for type name!")
	local typename = bloxmlparser.sourceTokens[bloxmlparser.position].CharacterSequence
	bloxmlparser.position += 1 --type name already handled, skip to next token
	
	local kvps = {}
	while bloxmlparser.sourceTokens[bloxmlparser.position].TokenType == 1 do
		local identifier = bloxmlparser.sourceTokens[bloxmlparser.position].CharacterSequence
		bloxmlparser.position += 1--skip identifier, already handled
		
		assert(bloxmlparser.sourceTokens[bloxmlparser.position].TokenType == 6, "Expected '=' after attribute name!")
		bloxmlparser.position += 1--skip equal sign
		
		assert(bloxmlparser.sourceTokens[bloxmlparser.position].TokenType == 0, "Expected attribute value after '='!")
		local attr_val = bloxmlparser.sourceTokens[bloxmlparser.position].CharacterSequence
		bloxmlparser.position += 1--go to next identifier
		
		kvps[identifier] = attr_val--save value as kvp
	end
	
	--broken out of loop, current sign is either '/' or '>'.
	if bloxmlparser.sourceTokens[bloxmlparser.position].TokenType == 5 then
		bloxmlparser.position += 2 --skip / and >
		return {typename = typename, properties = kvps, children = {}} --forwardslash -> no children, cuz empty tag.
	end
	
	--container tag, there are children, skip closing brace and recursively parse children.
	bloxmlparser.position += 1
	local children = {}
	while bloxmlparser.sourceTokens[bloxmlparser.position].TokenType == 3 and bloxmlparser.sourceTokens[bloxmlparser.position + 1].TokenType ~= 5 do
		table.insert(children, parse_tag(bloxmlparser))
	end
	
	bloxmlparser.position += 4 --one for the <, one for the /, one for the typename, & one for the >.
	return {typename = typename, properties = kvps, children = children}
end

function bloxmlparser.new(tokens: {BloxmlToken}): BloxmlParser
	return setmetatable({
		result = {},
		sourceTokens = tokens,
		position = 1,
	}, bloxmlparser)
end

function bloxmlparser:Parse()
	self.position = 1
	self.result = {}
	
	while self.position < #self.sourceTokens do
		table.insert(self.result, parse_tag(self))
	end
	
	print("Parsing complete! result is available in BloXMLParser.result!")
end

function bloxmlparser:Dispose()
	table.clear(self.result)
	table.clear(self.sourceTokens)
	table.clear(self)
end

return table.freeze(bloxmlparser)
