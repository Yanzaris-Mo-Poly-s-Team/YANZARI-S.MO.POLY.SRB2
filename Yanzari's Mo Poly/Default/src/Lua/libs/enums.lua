/*
             Yanzari's Mo Poly
                -By Yanzari
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
enums.lua
*/
local Enums = {}
local function Create(...)
	local output = {}
	for k,v in ipairs({...})
		output[v] = k-1
	end
	return output
end
function Enums.To(...)
	local output = {}
	for k,v in ipairs({...})
		output[k] = v
	end
	return output
end
setmetatable(Enums,{__call=Create})
return Enums