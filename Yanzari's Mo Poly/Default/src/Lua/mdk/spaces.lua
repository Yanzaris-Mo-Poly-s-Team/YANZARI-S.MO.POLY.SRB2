local Binding = require("binding.lua")
local YMSP = {}
YMSP.spaces = 0
function YMSP.new(num)
	local self = {}
	self.flags = 0
	self.pub = {}
	self.pub.data = Binding.Bind({
		__get__ = function(s,k)
			return s[k]
		end,
		__set__ = function(s,k,v)
			return nil
		end,
		__str__ = function(s)
			return "ymp::ymkp::space"
		end
	},{
		type = "ymkp.space"
	})
	self.priv = {}
	self.id = num
	YMSP.spaces = YMSP.spaces + 1
	return self
end
return YMSP