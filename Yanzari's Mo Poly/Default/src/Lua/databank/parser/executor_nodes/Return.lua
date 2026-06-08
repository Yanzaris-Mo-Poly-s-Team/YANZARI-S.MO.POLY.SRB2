local Plan = require("Plan")
/*
typedef struct Result
{
	Plan		plan;
	ResultType	result_type;
	Node	   *resconstantqual;
	Bitmapset  *relids;
} Result;
*/
local Result = {}
Result.__index = Result

/*
typedef enum ResultType
{
	RESULT_TYPE_GATING,
	RESULT_TYPE_SCAN,
	RESULT_TYPE_JOIN,
	RESULT_TYPE_UPPER,
	RESULT_TYPE_MINMAX
} ResultType;
*/
local RESULT_TYPE = {
	GATING = 0,
	SCAN = 1,
	JOIN = 2,
	UPPER = 3,
	MINMAX = 4,
	NULL = 5
}
function Result.new(tbl)
	local self = setmetatable({},Result)
	assert(tbl ~= nil)
	assert(tbl.plan~=nil)
	assert(getmetatable(tbl.plan) == Plan)
	self.plan = tbl.plan
	self.result_type = RESULT_TYPE[tbl.result_type or "NULL"]
	self.resconstantqual = tbl.resconstantqual or nil
	self.relids = tbl.relids or {}
	return self
end
return Result