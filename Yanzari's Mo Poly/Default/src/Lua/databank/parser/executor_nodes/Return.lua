/*
typedef struct Result
{
	Plan		plan;
	ResultType	result_type;
	Node	   *resconstantqual;
	Bitmapset  *relids;
} Result;
*/
local Return = {}
Return.__index = Return

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
	GATING = "Gating",
	SCAN = "Scan",
	JOIN = "Join",
	UPPER = "Upper",
	MINMAX = "MinMax",
	NULL = "Null"
}
function Return.new(tbl)
	local self = setmetatable({},Return)
	self.Plan = tbl.plan or nil
	self.result_type = RESULT_TYPE[tbl.result_type or "NULL"]
	self.resconstantqual = tbl.resconstantqual or nil
	self.Relids = tbl.relids or {}
	return self
end
return Return