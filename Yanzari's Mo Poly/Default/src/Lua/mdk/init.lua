local API = require("ymp")
local Userdata = Binding.Bind({
	__get__ = function(s,k)
		return YMKP[k]
	end,
	__str__ = function(s)
		return "ymp::ymkp"
	end
},{
	type = "ymkp"
})