local Binding = {}
local bindedobj = setmetatable({},{__mode="k"})
local old = type
rawset(_G,"type",function(v)
	if bindedobj[v]~=nil then
		return bindedobj[v]
	end
	return old(v)
end)
function Binding.Bind(obj,opt)
	local ud = newproxy(true)
	local mt = getmetatable(ud)
	if opt ~= nil and opt.type ~= nil then
		bindedobj[ud] = opt.type
	end
	local function Checking(name1,name2)
		if obj[name1] ~= nil then
			mt[name2] = function(self,...)
				return obj[name1](self,...)
			end
		end
	end
	Checking("__init__","__call")
	Checking("__newset__","__newindex")
	Checking("__set__","__usedindex")
	Checking("__get__","__index")
	
	Checking("__add__","__add")
	Checking("__sub__","__sub")
	Checking("__mul__","__mul")
	Checking("__div__","__div")
	Checking("__mod__","__mod")
	Checking("__pow__","__pow")
	Checking("__unm__","__unm")
	Checking("__len__","__len")
	
	Checking("__eq__","__eq")
	Checking("__lt__","__lt")
	Checking("__le__","__le")
	
	Checking("__and__","__and")
	Checking("__or__","__or")
	Checking("__xor__","__xor")
	Checking("__shl__","__shl")
	Checking("__shr__","__shr")
	Checking("__not__","__not")
	
	Checking("__concat__","__concat")
	Checking("__str__","__tostring")
	Checking("__gc__","__gc")
	mt.__metatable = false
	return ud
end
return Binding