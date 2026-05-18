-- nothing
local Binding = require("mdk/binding.lua")
local Ops = {}
Ops.ops = "HEHE"
Ops.rich = "RICH"
local Userdata = Binding.Bind({
	__get__ = function(s,k)
		return Ops[k]
	end,
	__str__ = function(s)
		return "<Binded Object>"
	end
},{
	type = "Binded"
})