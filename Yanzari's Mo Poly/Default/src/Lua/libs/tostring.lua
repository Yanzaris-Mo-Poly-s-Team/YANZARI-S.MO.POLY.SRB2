local function String(obj, level, indent)
	level = level or 0
	indent = indent or "    "

	if obj == nil then
		return "nil"
	end

	local obj_type = type(obj)
	if obj_type == "string" then
		return "\"" .. obj .. "\""
	elseif obj_type == "number" then
		return tostring(obj)
	elseif obj_type == "boolean" then
		return obj and "true" or "false"
	elseif obj_type == "table" then
		local first = next(obj)
		if first == nil then
			return "{}"
		end

		local current_indent = string.rep(indent, level + 1)
		local close_indent   = string.rep(indent, level)

		local output = "{\n"
		for k, v in pairs(obj) do
			output = output .. current_indent ..
					 "[" .. String(k, level + 1, indent) .. "] = "
			if v == obj then
				output = output .. "self"
			else
				output = output .. String(v, level + 1, indent)
			end
			output = output .. ",\n"
		end

		output = output:sub(1, -3) .. "\n" .. close_indent .. "}"
		return output
	else
		return obj_type
	end
end

return String