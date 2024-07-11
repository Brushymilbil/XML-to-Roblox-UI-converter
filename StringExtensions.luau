local module = {}

function module.isdigit(char: string): boolean
	local byte = char:byte()
	return byte >= 48 and byte <= 57
end

function module.isspace(char: string): boolean
	local byte = char:byte()
	return byte == 32 or (byte >= 9 and byte <= 13)
end

function module.isalpha(char: string):boolean
	local byte = char:byte()
	return (byte >= 65 and byte <= 90) or (byte >= 97 and byte <= 122)
end

function module.isalphanum(char: string)
	return module.isalpha(char) or module.isdigit(char)
end

return table.freeze(module)
