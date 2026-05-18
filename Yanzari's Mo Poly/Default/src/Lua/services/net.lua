local Service = {}
local NetWorkVars = {}
local Object = {}
Object.__index = Object
addHook("NetVars", function(n)
	NetWorkVars = n(NetWorkVars)
end)
function Service.Add(v)
	local id = #NetWorkVars+1
	local self = {}
	NetWorkVars[id] = v
	function self:Set()
		NetWorkVars[id] = v
	end
	function self:Remove()
		NetWorkVars[id] = nil
	end
	return self
end
return Service