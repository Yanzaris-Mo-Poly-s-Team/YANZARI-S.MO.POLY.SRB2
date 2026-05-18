local function FromEnum(tbl)
	local output = {}
	for k,v in pairs(tbl) do
		output[v] = k
	end
	return output
end
return FromEnum