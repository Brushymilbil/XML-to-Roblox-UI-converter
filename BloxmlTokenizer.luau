local stringExtensions = require (script.Parent:WaitForChild("StringExtensions"))

local bloxTokenizer = {}
bloxTokenizer.__index = bloxTokenizer

--[[
TYPES:
 ATTRIBUTE_VALUE: 0
 IDENTIFIER: 1
 
 OPEN_TAG: 3
 CLOSE_TAG: 4
 FORWARD_SLASH: 5
 EQUAL: 6
]]

export type BloxmlToken = {
	CharacterSequence: string,
	TokenType: number,
}

export type BloxmlTokenizer =  typeof(setmetatable({} :: {
	sourceCode: {string},
	source: string,
	position: number,
	result: {BloxmlToken}
}, bloxTokenizer))

local function make_tkn(char: string, t: number): BloxmlToken
	return {
		CharacterSequence = char,
		TokenType = t,
	}
end

local function tokenize_attr(tokenizer_state: BloxmlTokenizer)
	tokenizer_state.position += 1--skip the "
	local start = tokenizer_state.position
	
	while tokenizer_state.position < #tokenizer_state.sourceCode and tokenizer_state.sourceCode[tokenizer_state.position] ~= '"' do 
		tokenizer_state.position += 1
	end
	
	local attr = string.sub(tokenizer_state.source, start, tokenizer_state.position - 1)--exclude the end "
	tokenizer_state.position += 1--discard end "
	
	table.insert(tokenizer_state.result, make_tkn(attr, 0))--insert new token
end

local function tokenize_identifier(tokenize_state: BloxmlTokenizer)
	local start = tokenize_state.position
	while tokenize_state.position < #tokenize_state.sourceCode and (stringExtensions.isalphanum(tokenize_state.sourceCode[tokenize_state.position]) or tokenize_state.sourceCode[tokenize_state.position] == '_') do
		tokenize_state.position += 1
	end
	
	local identifier = string.sub(tokenize_state.source, start, tokenize_state.position - 1)--skip whatever character ended the loop.
	table.insert(tokenize_state.result, make_tkn(identifier, 1))
end

local function discard_comment(tokenize_state: BloxmlTokenizer)
	local start = tokenize_state.position
	while tokenize_state.position < #tokenize_state.sourceCode and tokenize_state.sourceCode[tokenize_state.position] ~= '>' do
		tokenize_state.position += 1
	end
	
	--commenting is <! > now technically, but you can stil do <!-- -->, I am not going to enforce it.
	tokenize_state.position += 1 --skip the > sign.
end
--[[
  Hello
]]
function bloxTokenizer.new(source: string): BloxmlTokenizer
	assert(source and source ~= "", "Failed to create tokenizer, source was nil or empty.")
	
	return setmetatable({
		sourceCode = string.split(source, ""),
		source = source,
		result = {},
		position = 0,
	}, bloxTokenizer)
end

function bloxTokenizer:Tokenize()
	--reset the values
	self.result = {}
	self.position = 1
	
	while self.position < #self.sourceCode do
		--discard spaces
		--print(self.position, self.sourceCode[self.position])
		if stringExtensions.isspace(self.sourceCode[self.position]) then 
			self.position += 1 
			continue 
		end
		--multi character tokens (have own tokenize method)
		if self.sourceCode[self.position] == '"' then
			tokenize_attr(self)
		elseif stringExtensions.isalphanum(self.sourceCode[self.position]) or self.sourceCode[self.position] == '_' then
			tokenize_identifier(self)
			--single character tokens (all have same logic)
		elseif self.sourceCode[self.position] == '<' then
			if self.sourceCode[self.position + 1] == '!' then
				discard_comment(self)
				continue
			end
			
			table.insert(self.result, make_tkn(nil, 3))
			self.position += 1
		elseif self.sourceCode[self.position] == '>' then
			table.insert(self.result, make_tkn(nil, 4))
			self.position += 1
		elseif self.sourceCode[self.position] == '/' then
			table.insert(self.result, make_tkn(nil, 5))
			self.position += 1
		elseif self.sourceCode[self.position] == '=' then
			table.insert(self.result, make_tkn(nil, 6))
			self.position += 1
		else
			warn("Unknown token detected, token is discarded and tokenization continues: ", self.sourceCode[self.position])
			self.position += 1
		end
	end
	
	print("Tokenization Completed! Tokens available in BloxmlTokenizer.result!")
end

function bloxTokenizer:Dispose()
	table.clear(self.result)
	table.clear(self.sourceCode)
	table.clear(self)
end

return table.freeze(bloxTokenizer)
