local Plan = require("Plan")
/*
typedef struct Scan
{
	pg_node_attr(abstract)

	Plan		plan;
	Index		scanrelid;
} Scan;
*/
local Scan = {}
Scan.__index = Scan
function Scan.new(tbl)
	local self = setmetatable({},Scan)
	assert(tbl ~= nil)
	assert(tbl.plan~=nil)
	assert(getmetatable(tbl.plan) == Plan)
	self.plan = tbl.plan
	self.node_attr = {
		"abstract"
	}
	assert(tbl.scanrelid ~= nil)
	self.scanrelid = tbl.scanrelid or 0
	return self
end
return Scan