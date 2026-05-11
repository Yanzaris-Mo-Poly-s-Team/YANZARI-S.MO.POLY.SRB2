local function String(obj)
	if obj==nil then
		return "nil"
	end
	if type(obj)=="string" then
		return "\""..obj.."\""
	end
	if type(obj)=="number" then
		return tostring(obj)
	end
	if type(obj)=="boolean" then
		if obj==true then
			return "true"
		end
		return "false"
	end
	if type(obj)=="table" then
		local output = "{".."\n"
		local sep = ",".."\n"
		local pairs_test,var1,var2 = pairs(obj)
		if pairs_test ~= nil then
			for k,v in pairs_test, var1, var2 do
				if v ~= obj then
					output = output.."["..String(k).."] = "..String(v)..sep
				else
					output = output.."["..String(k).."] = self"..sep
				end
			end
		else
			return "{}"
		end
		return output:sub(1,#output-#sep).."\n".."}"
	end
	return type(obj)
end
return String