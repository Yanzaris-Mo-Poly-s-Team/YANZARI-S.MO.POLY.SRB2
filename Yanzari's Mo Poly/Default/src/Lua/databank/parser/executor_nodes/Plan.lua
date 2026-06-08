/*
typedef struct Plan
{
	pg_node_attr(abstract, no_equal, no_query_jumble)

	NodeTag		type;

	int			disabled_nodes;
	Cost		startup_cost;
	Cost		total_cost;

	Cardinality plan_rows;
	int			plan_width;

	bool		parallel_aware;
	bool		parallel_safe;

	bool		async_capable;

	int			plan_node_id;
	List	   *targetlist;
	List	   *qual;
	struct Plan *lefttree;
	struct Plan *righttree;
	List	   *initPlan;

	Bitmapset  *extParam;
	Bitmapset  *allParam;
} Plan;
*/
local Plan = {}
Plan.__index = Plan
function Plan.new(tbl)
	local self = setmetatable({},Plan)
	assert(tbl ~= nil)
	
	self.node_attr = {
		"abstract",
		"no_equal",
		"no_query_jumble"
	}
	
	self.type = tbl.type or 0
	
	self.disabled_nodes = tbl.disabled_nodes or 0
	
	self.startup_cost = tbl.startup_cost or 0
	self.total_cost = tbl.total_cost or 0
	
	self.plan_rows = tbl.plan_rows or 0
	self.plan_width = tbl.plan_width or 0
	
	self.parallel_aware = tbl.parallel_aware or false
	self.parallel_safe = tbl.parallel_safe or false
	
	self.async_capable = tbl.async_capable or false -- coroutines
	
	self.plan_node_id = tbl.plan_node_id or 0
	self.targetlist = tbl.targetlist or {}
	self.qual = tbl.qual or {}
	self.lefttree = tbl.lefttree or nil
	self.righttree = tbl.righttree or nil
	self.initPlan = tbl.initPlan or {}
	
	self.extParam = tbl.extParam or {}
	self.allParam = tbl.allParam or {}
	return self
end