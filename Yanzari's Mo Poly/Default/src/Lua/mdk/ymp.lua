local Binding = require("binding.lua")
local YMSP = require("spaces.lua")
local YMKP = {}
function YMKP:AlocateSpace(spacename)
	local space = YMSP.new(YMSP.spaces+1)
	if type(spacename) == "string" then
		space.priv.name = spacename
	end
	return space.pub.data
end
function YMKP:AlocateSpace(spacename)
	local space = YMSP.new(YMSP.spaces+1)
	if type(spacename) == "string" then
		space.priv.name = spacename
	end
	return space.pub.data
end
return YMKP