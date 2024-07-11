local converter = {}

function converter.ToVector3(t: string): Vector3?
	local nums = string.split(t, ",")
	if #nums ~= 3 then return nil end
	
	local x, y , z = tonumber(nums[1]), tonumber(nums[2]), tonumber(nums[3])
	return Vector3.new(x, y, z)
end

function converter.ToEnum(typename: string, value: string): Enum?
	local enumName = string.split(typename, ".")[2] -- eg: Enum.PartType.Block where [2] = PartType.
	if not Enum[enumName] then return nil end
	
	return Enum[enumName][value]
end

function converter.ToColor3(t: string): Color3?
	local nums = string.split(t, ",")
	if #nums ~= 3 then return nil end

	local r, g , b = tonumber(nums[1]), tonumber(nums[2]), tonumber(nums[3])	
	return Color3.fromRGB(r, g, b)
end

function converter.Toboolean(t: string): boolean
	return string.lower(t) == "true"
end

function converter.ToUDim2(t: string): UDim2?
	local nums = string.split(t, ",")
	if #nums ~= 4 then return nil end
	
	local xs, xo, ys, yo = tonumber(nums[1]), tonumber(nums[2]), tonumber(nums[3]), tonumber(nums[4])
	return UDim2.new(xs, xo, ys, yo)
end

function converter.ToUDim(t: string): UDim?
	local nums = string.split(t, ",")
	if #nums ~= 2 then return nil end
	
	local s, o = tonumber(nums[1]), tonumber(nums[2])
	return UDim.new(s, o)
end

--add to number for number functionality, required by loading algo
converter.Tonumber = tonumber
return table.freeze(converter)
