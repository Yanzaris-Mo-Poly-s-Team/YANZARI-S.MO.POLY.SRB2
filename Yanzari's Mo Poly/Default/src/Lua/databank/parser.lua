local Parser = {}
local Transform = require(".root./libs/tbl_enum")

local KeyWordsTokens1 = {
	["TK_ABORT"] = 1,
	["TK_ACTION"] = 2,
	["TK_ADD"] = 3,
	["TK_AFTER"] = 4,
	["TK_ALL"] = 5,
	["TK_ALTER"] = 6,
	["TK_ALWAYS"] = 7,
	["TK_ANALYZE"] = 8,
	["TK_AND"] = 9,
	["TK_AS"] = 10,
	["TK_ASC"] = 11,
	["TK_ATTACH"] = 12,
	["TK_AUTOINCREMENT"] = 13,
	["TK_BEFORE"] = 14,
	["TK_BEGIN"] = 15,
	["TK_BETWEEN"] = 16,
	["TK_BY"] = 17,
	["TK_CASCADE"] = 18,
	["TK_CASE"] = 19,
	["TK_CAST"] = 20,
	["TK_CHECK"] = 21,
	["TK_COLLATE"] = 22,
	["TK_COLUMN"] = 23,
	["TK_COMMIT"] = 24,
	["TK_CONFLICT"] = 25,
	["TK_CONSTRAINT"] = 26,
	["TK_CREATE"] = 27,
	["TK_CROSS"] = 28,
	["TK_CURRENT"] = 29,
	["TK_CURRENT_DATE"] = 30,
	["TK_CURRENT_TIME"] = 31,
	["TK_CURRENT_TIMESTAMP"] = 32,
	["TK_DATABASE"] = 33,
	["TK_DEFAULT"] = 34,
	["TK_DEFERRABLE"] = 35,
	["TK_DEFERRED"] = 36,
	["TK_DELETE"] = 37,
	["TK_DESC"] = 38,
	["TK_DETACH"] = 39,
	["TK_DISTINCT"] = 40,
	["TK_DO"] = 41,
	["TK_DROP"] = 42,
	["TK_EACH"] = 43,
	["TK_ELSE"] = 44,
	["TK_END"] = 45,
	["TK_ESCAPE"] = 46,
	["TK_EXCEPT"] = 47,
	["TK_EXCLUDE"] = 48,
	["TK_EXCLUSIVE"] = 49,
	["TK_EXISTS"] = 50,
	["TK_EXPLAIN"] = 51,
	["TK_FAIL"] = 52,
	["TK_FILTER"] = 53,
	["TK_FIRST"] = 54,
	["TK_FOLLOWING"] = 55,
	["TK_FOR"] = 56,
	["TK_FOREIGN"] = 57,
	["TK_FROM"] = 58,
	["TK_FULL"] = 59,
	["TK_GENERATED"] = 60,
	["TK_GLOB"] = 61,
	["TK_GROUP"] = 62,
	["TK_GROUPS"] = 63,
	["TK_HAVING"] = 64,
	["TK_IF"] = 65,
	["TK_IGNORE"] = 66,
	["TK_IMMEDIATE"] = 67,
	["TK_IN"] = 68,
	["TK_INDEX"] = 69,
	["TK_INDEXED"] = 70,
	["TK_INITIALLY"] = 71,
	["TK_INNER"] = 72,
	["TK_INSERT"] = 73,
	["TK_INSTEAD"] = 74,
	["TK_INTERSECT"] = 75,
	["TK_INTO"] = 76,
	["TK_IS"] = 77,
	["TK_ISNULL"] = 78,
	["TK_JOIN"] = 79,
	["TK_KEY"] = 80,
	["TK_LAST"] = 81,
	["TK_LEFT"] = 82,
	["TK_LIKE"] = 83,
	["TK_LIMIT"] = 84,
	["TK_MATCH"] = 85,
	["TK_MATERIALIZED"] = 86,
	["TK_NATURAL"] = 87,
	["TK_NO"] = 88,
	["TK_NOT"] = 89,
	["TK_NOTHING"] = 90,
	["TK_NOTNULL"] = 91,
	["TK_NULL"] = 92,
	["TK_NULLS"] = 93,
	["TK_OF"] = 94,
	["TK_OFFSET"] = 95,
	["TK_ON"] = 96,
	["TK_OR"] = 97,
	["TK_ORDER"] = 98,
	["TK_OTHERS"] = 99,
	["TK_OUTER"] = 100,
	["TK_OVER"] = 101,
	["TK_PARTITION"] = 102,
	["TK_PLAN"] = 103,
	["TK_PRAGMA"] = 104,
	["TK_PRECEDING"] = 105,
	["TK_PRIMARY"] = 106,
	["TK_QUERY"] = 107,
	["TK_RAISE"] = 108,
	["TK_RANGE"] = 109,
	["TK_RECURSIVE"] = 110,
	["TK_REFERENCES"] = 111,
	["TK_REGEXP"] = 112,
	["TK_REINDEX"] = 113,
	["TK_RELEASE"] = 114,
	["TK_RENAME"] = 115,
	["TK_REPLACE"] = 116,
	["TK_RESTRICT"] = 117,
	["TK_RETURNING"] = 118,
	["TK_RIGHT"] = 119,
	["TK_ROLLBACK"] = 120,
	["TK_ROW"] = 121,
	["TK_ROWS"] = 122,
	["TK_SAVEPOINT"] = 123,
	["TK_SELECT"] = 124,
	["TK_SET"] = 125,
	["TK_TABLE"] = 126,
	["TK_TEMP"] = 127,
	["TK_TEMPORARY"] = 128,
	["TK_THEN"] = 129,
	["TK_TIES"] = 130,
	["TK_TO"] = 131,
	["TK_TRANSACTION"] = 132,
	["TK_TRIGGER"] = 133,
	["TK_UNBOUNDED"] = 134,
	["TK_UNION"] = 135,
	["TK_UNIQUE"] = 136,
	["TK_UPDATE"] = 137,
	["TK_USING"] = 138,
	["TK_VACUUM"] = 139,
	["TK_VALUES"] = 140,
	["TK_VIEW"] = 141,
	["TK_VIRTUAL"] = 142,
	["TK_WHEN"] = 143,
	["TK_WHERE"] = 144,
	["TK_WINDOW"] = 145,
	["TK_WITH"] = 146,
	["TK_WITHOUT"] = 147,
}

local Tokens1 = {
	["TK_EOF"]     = 0,
	["TK_STRING"]  = 1,
	["TK_NUMBER"]  = 2,
	["TK_FLOAT"]   = 3,
	["TK_BLOB"]    = 4,
	["TK_HEXA"]    = 5,
	["TK_KEYWORD"] = 6,
	["TK_ID"]      = 7,
	["TK_OPERATOR"]= 8,
	["TK_VAR"]     = 9,
	["TK_LP"]      = 10,
	["TK_RP"]      = 11,
	["TK_DOT"]     = 12,
	["TK_SEMI"]    = 13,
	["TK_COMMA"]   = 14,
	["TK_COMMAND"] = 15,
}

-- ---------------------------------------------------------------------------
-- Precedence table (SQLite3 expr grammar, low → high)
--
--  1  OR
--  2  AND
--  3  NOT  (unary, right-assoc – handled in nud)
--  4  IS  IS NOT  ISNULL  NOTNULL  NOT NULL
--         IN  LIKE  GLOB  MATCH  REGEXP  BETWEEN  (all same level in SQLite)
--  5  =  ==  !=  <>
--  6  <  >  <=  >=
--  7  &  |  <<  >>
--  8  +  -  (binary)
--  9  *  /  %
-- 10  ||  (string concatenation)
-- 11  ->  ->>  (JSON operators)
-- 12  COLLATE  (postfix, highest binary)
-- ---------------------------------------------------------------------------
local PREC = {
	OR      = 1,
	AND     = 2,
	-- level 4 keywords handled inline
	["="]   = 5,  ["=="]  = 5,
	["!="]  = 5,  ["<>"]  = 5,
	["<"]   = 6,  [">"]   = 6,
	["<="]  = 6,  [">="]  = 6,
	["&"]   = 7,  ["|"]   = 7,
	["<<"]  = 7,  [">>"]  = 7,
	["+"]   = 8,  ["-"]   = 8,
	["*"]   = 9,  ["/"]   = 9,  ["%"] = 9,
	["||"]  = 10,
	["->"]  = 11, ["->>"] = 11,
	COLLATE = 12,
}

-- level for IS / IN / LIKE / BETWEEN / REGEXP / GLOB / MATCH / NOT
local PREC_IS      = 4
local PREC_COLLATE = 12

-- ---------------------------------------------------------------------------
-- Parser boilerplate
-- ---------------------------------------------------------------------------
Parser.__index = Parser

function Parser.New(str)
	if not (str ~= "" and str ~= nil and type(str) == "table") then
		error("SQL <Parser> Error: Invalid Input")
	end
	local self   = setmetatable({}, Parser)
	self.tokens  = str
	self.current = str[1]
	self.next    = str[2]
	self.pos     = 1
	self.output  = {}
	return self
end

function Parser:Advance()
	if self.current == nil or self.current.token == 0 then
		self.current = nil
		self.next    = nil
	else
		self.pos     = self.pos + 1
		self.current = self.tokens[self.pos]
		self.next    = self.tokens[self.pos + 1]
	end
end

function Parser:Peek(offset)
	return self.tokens[self.pos + offset]
end

function Parser:IsEOF()
	return self.current == nil
end

function Parser:IsTheToken(tk, kw, tx)
	if self:IsEOF() then return false end
	local tok = Tokens1[tk]
	if tok == nil or self.current.token ~= tok then return false end
	if kw ~= nil then
		if self.current.keyword ~= kw then return false end
	end
	if tx ~= nil then
		if self.current.text ~= tx then return false end
	end
	return true
end

function Parser:IsKeyword(kw)
	return self:IsTheToken("TK_KEYWORD", kw, nil)
end

function Parser:IsID()
	return self:IsTheToken("TK_ID", nil, nil)
end

function Parser:IsOperator(tx)
	return self:IsTheToken("TK_OPERATOR", nil, tx)
end

-- Consume current token, error if it does not match expectations.
function Parser:Expect(tk, kw, tx)
	if not self:IsTheToken(tk, kw, tx) then
		local got_t = self.current and tostring(self.current.token) or "EOF"
		local got_x = self.current and tostring(self.current.text)  or "EOF"
		local want  = tk .. (kw and ("|"..kw) or "") .. (tx and ("|"..tx) or "")
		self:Error("Expected " .. want .. ", but got " .. got_t .. "|" .. got_x)
	end
	local saved = self.current
	self:Advance()
	return saved
end

function Parser:Error(tx)
	error("SQL <Parser> Error at pos " .. tostring(self.pos) .. ": " .. tx)
end

function Parser:Emit(tbl)
	table.insert(self.output, tbl)
end

-- ---------------------------------------------------------------------------
-- Helper: read a plain name (TK_ID or any keyword used as name)
-- SQLite allows many keywords as column/table names.
-- ---------------------------------------------------------------------------
local function parse_name(self)
	if self:IsEOF() then self:Error("Expected name, got EOF") end
	local t = self.current.text
	-- accept TK_ID or TK_KEYWORD (keywords-as-identifiers are common in SQLite)
	if self.current.token == Tokens1["TK_ID"]
	or self.current.token == Tokens1["TK_KEYWORD"] then
		self:Advance()
		return t
	end
	self:Error("Expected identifier, got " .. tostring(t))
end

-- ---------------------------------------------------------------------------
-- type-name  ::=  name+  [ ( signed-number )
--                         | ( signed-number , signed-number ) ]
-- ---------------------------------------------------------------------------
local function parse_type_name(self)
	local names = {}
	-- must have at least one name
	table.insert(names, parse_name(self))
	while (self:IsID() or self:IsKeyword(self.current and self.current.keyword or ""))
	    and not self:IsTheToken("TK_LP", nil, nil)
	    and not self:IsTheToken("TK_RP", nil, nil)
	    and not self:IsTheToken("TK_COMMA", nil, nil)
	    and not self:IsEOF() do
		-- next token is still a name-word and not a paren/comma
		-- safeguard: only consume if it looks like a name
		if self.current.token == Tokens1["TK_ID"]
		or self.current.token == Tokens1["TK_KEYWORD"] then
			table.insert(names, self.current.text)
			self:Advance()
		else
			break
		end
	end
	local precision, scale
	if self:IsTheToken("TK_LP", nil, nil) then
		self:Advance()
		-- signed-number
		local sign1 = ""
		if self:IsOperator("+") or self:IsOperator("-") then
			sign1 = self.current.text; self:Advance()
		end
		local n1 = self:Expect("TK_NUMBER", nil, nil)
		precision = sign1 .. n1.text
		if self:IsTheToken("TK_COMMA", nil, nil) then
			self:Advance()
			local sign2 = ""
			if self:IsOperator("+") or self:IsOperator("-") then
				sign2 = self.current.text; self:Advance()
			end
			local n2 = self:Expect("TK_NUMBER", nil, nil)
			scale = sign2 .. n2.text
		end
		self:Expect("TK_RP", nil, nil)
	end
	return { type = "TypeName", names = names, precision = precision, scale = scale }
end

-- ---------------------------------------------------------------------------
-- filter-clause  ::=  FILTER ( WHERE expr )
-- ---------------------------------------------------------------------------
local function parse_filter_clause(self, expr_fn)
	self:Expect("TK_KEYWORD", "TK_FILTER", nil)
	self:Expect("TK_LP", nil, nil)
	self:Expect("TK_KEYWORD", "TK_WHERE", nil)
	local e = expr_fn(self, 1)
	self:Expect("TK_RP", nil, nil)
	return { type = "FilterClause", where = e }
end

-- ---------------------------------------------------------------------------
-- frame-spec
--   ::= (RANGE|ROWS|GROUPS)
--       ( BETWEEN frame-bound AND frame-bound | frame-bound )
--       [ EXCLUDE (NO OTHERS | CURRENT ROW | GROUP | TIES) ]
--
-- frame-bound ::= UNBOUNDED PRECEDING
--               | CURRENT ROW
--               | expr PRECEDING
--               | expr FOLLOWING
--               | UNBOUNDED FOLLOWING
-- ---------------------------------------------------------------------------
local function parse_frame_bound(self, expr_fn)
	if self:IsKeyword("TK_UNBOUNDED") then
		self:Advance()
		if self:IsKeyword("TK_PRECEDING") then
			self:Advance()
			return { type = "FrameBound", kind = "UnboundedPreceding" }
		elseif self:IsKeyword("TK_FOLLOWING") then
			self:Advance()
			return { type = "FrameBound", kind = "UnboundedFollowing" }
		else
			self:Error("Expected PRECEDING or FOLLOWING after UNBOUNDED")
		end
	elseif self:IsKeyword("TK_CURRENT") then
		self:Advance()
		self:Expect("TK_KEYWORD", "TK_ROW", nil)
		return { type = "FrameBound", kind = "CurrentRow" }
	else
		local e = expr_fn(self, 1)
		if self:IsKeyword("TK_PRECEDING") then
			self:Advance()
			return { type = "FrameBound", kind = "ExprPreceding", expr = e }
		elseif self:IsKeyword("TK_FOLLOWING") then
			self:Advance()
			return { type = "FrameBound", kind = "ExprFollowing", expr = e }
		else
			self:Error("Expected PRECEDING or FOLLOWING after frame expression")
		end
	end
end

local function parse_frame_spec(self, expr_fn)
	local unit
	if self:IsKeyword("TK_RANGE") then
		unit = "RANGE"; self:Advance()
	elseif self:IsKeyword("TK_ROWS") then
		unit = "ROWS"; self:Advance()
	elseif self:IsKeyword("TK_GROUPS") then
		unit = "GROUPS"; self:Advance()
	else
		self:Error("Expected RANGE, ROWS or GROUPS in frame-spec")
	end

	local start_bound, end_bound
	if self:IsKeyword("TK_BETWEEN") then
		self:Advance()
		start_bound = parse_frame_bound(self, expr_fn)
		self:Expect("TK_KEYWORD", "TK_AND", nil)
		end_bound   = parse_frame_bound(self, expr_fn)
	else
		start_bound = parse_frame_bound(self, expr_fn)
	end

	local exclude
	if self:IsKeyword("TK_EXCLUDE") then
		self:Advance()
		if self:IsKeyword("TK_NO") then
			self:Advance()
			self:Expect("TK_KEYWORD", "TK_OTHERS", nil)
			exclude = "NoOthers"
		elseif self:IsKeyword("TK_CURRENT") then
			self:Advance()
			self:Expect("TK_KEYWORD", "TK_ROW", nil)
			exclude = "CurrentRow"
		elseif self:IsKeyword("TK_GROUP") then
			self:Advance()
			exclude = "Group"
		elseif self:IsKeyword("TK_TIES") then
			self:Advance()
			exclude = "Ties"
		else
			self:Error("Expected NO OTHERS, CURRENT ROW, GROUP or TIES after EXCLUDE")
		end
	end

	return { type = "FrameSpec", unit = unit,
	         start = start_bound, stop = end_bound, exclude = exclude }
end

-- ---------------------------------------------------------------------------
-- window-defn
--   ::= ( [base-window-name]
--          [PARTITION BY expr-list]
--          [ORDER BY ordering-term-list]
--          [frame-spec] )
-- ---------------------------------------------------------------------------
local function parse_ordering_term(self, expr_fn)
	local e = expr_fn(self, 1)
	local collation
	if self:IsKeyword("TK_COLLATE") then
		self:Advance()
		collation = parse_name(self)
	end
	local order
	if self:IsKeyword("TK_ASC") then
		order = "ASC"; self:Advance()
	elseif self:IsKeyword("TK_DESC") then
		order = "DESC"; self:Advance()
	end
	local nulls
	if self:IsKeyword("TK_NULLS") then
		self:Advance()
		if self:IsKeyword("TK_FIRST") then
			nulls = "FIRST"; self:Advance()
		elseif self:IsKeyword("TK_LAST") then
			nulls = "LAST"; self:Advance()
		else
			self:Error("Expected FIRST or LAST after NULLS")
		end
	end
	return { type = "OrderingTerm", expr = e, collation = collation,
	         order = order, nulls = nulls }
end

local function parse_window_defn(self, expr_fn)
	-- opening paren already consumed by caller (over-clause)
	local base_name
	-- base-window-name is an ID (not a keyword) that isn't immediately followed
	-- by PARTITION/ORDER/ROWS/RANGE/GROUPS/RP
	if self:IsID()
	and not self:IsKeyword("TK_PARTITION")
	and not self:IsKeyword("TK_ORDER")
	and not self:IsKeyword("TK_RANGE")
	and not self:IsKeyword("TK_ROWS")
	and not self:IsKeyword("TK_GROUPS")
	and not self:IsTheToken("TK_RP", nil, nil) then
		base_name = self.current.text; self:Advance()
	end

	local partition
	if self:IsKeyword("TK_PARTITION") then
		self:Advance()
		self:Expect("TK_KEYWORD", "TK_BY", nil)
		partition = {}
		table.insert(partition, expr_fn(self, 1))
		while self:IsTheToken("TK_COMMA", nil, nil) do
			self:Advance()
			table.insert(partition, expr_fn(self, 1))
		end
	end

	local order_by
	if self:IsKeyword("TK_ORDER") then
		self:Advance()
		self:Expect("TK_KEYWORD", "TK_BY", nil)
		order_by = {}
		table.insert(order_by, parse_ordering_term(self, expr_fn))
		while self:IsTheToken("TK_COMMA", nil, nil) do
			self:Advance()
			table.insert(order_by, parse_ordering_term(self, expr_fn))
		end
	end

	local frame
	if self:IsKeyword("TK_RANGE")
	or self:IsKeyword("TK_ROWS")
	or self:IsKeyword("TK_GROUPS") then
		frame = parse_frame_spec(self, expr_fn)
	end

	self:Expect("TK_RP", nil, nil)

	return { type = "WindowDefn", base = base_name,
	         partition = partition, order_by = order_by, frame = frame }
end

-- ---------------------------------------------------------------------------
-- over-clause  ::=  OVER  ( window-name | window-defn )
-- ---------------------------------------------------------------------------
local function parse_over_clause(self, expr_fn)
	self:Expect("TK_KEYWORD", "TK_OVER", nil)
	if self:IsTheToken("TK_LP", nil, nil) then
		self:Advance()
		return { type = "OverClause", defn = parse_window_defn(self, expr_fn) }
	else
		local name = parse_name(self)
		return { type = "OverClause", name = name }
	end
end

-- ---------------------------------------------------------------------------
-- Function-call argument list
--   function-arguments ::= *
--                        | [DISTINCT] expr (, expr)*
--                        | (empty)
-- ---------------------------------------------------------------------------
local function parse_function_args(self, expr_fn)
	-- We are already past the opening LP
	if self:IsTheToken("TK_RP", nil, nil) then
		-- zero args
		self:Advance()
		return { distinct = false, star = false, args = {} }
	end

	if self:IsOperator("*") then
		-- e.g.  count(*)
		self:Advance()
		self:Expect("TK_RP", nil, nil)
		return { distinct = false, star = true, args = {} }
	end

	local distinct = false
	if self:IsKeyword("TK_DISTINCT") then
		distinct = true; self:Advance()
	end

	local args = {}
	table.insert(args, expr_fn(self, 1))
	while self:IsTheToken("TK_COMMA", nil, nil) do
		self:Advance()
		table.insert(args, expr_fn(self, 1))
	end
	self:Expect("TK_RP", nil, nil)
	return { distinct = distinct, star = false, args = args }
end

-- ---------------------------------------------------------------------------
-- CASE expression
--   CASE [base-expr] (WHEN expr THEN expr)+ [ELSE expr] END
-- ---------------------------------------------------------------------------
local function parse_case_expr(self, expr_fn)
	self:Expect("TK_KEYWORD", "TK_CASE", nil)
	local base
	if not self:IsKeyword("TK_WHEN") then
		base = expr_fn(self, 1)
	end
	local whens = {}
	while self:IsKeyword("TK_WHEN") do
		self:Advance()
		local cond = expr_fn(self, 1)
		self:Expect("TK_KEYWORD", "TK_THEN", nil)
		local result = expr_fn(self, 1)
		table.insert(whens, { cond = cond, result = result })
	end
	if #whens == 0 then
		self:Error("CASE must have at least one WHEN clause")
	end
	local else_expr
	if self:IsKeyword("TK_ELSE") then
		self:Advance()
		else_expr = expr_fn(self, 1)
	end
	self:Expect("TK_KEYWORD", "TK_END", nil)
	return { type = "CaseExpr", base = base, whens = whens, else_expr = else_expr }
end

-- ---------------------------------------------------------------------------
-- RAISE function
--   RAISE ( IGNORE | FAIL , msg | ABORT , msg | ROLLBACK , msg )
-- ---------------------------------------------------------------------------
local function parse_raise(self)
	self:Expect("TK_KEYWORD", "TK_RAISE", nil)
	self:Expect("TK_LP", nil, nil)
	local action
	if self:IsKeyword("TK_IGNORE") then
		action = "IGNORE"; self:Advance()
		self:Expect("TK_RP", nil, nil)
		return { type = "Raise", action = action }
	elseif self:IsKeyword("TK_ABORT") then
		action = "ABORT"; self:Advance()
	elseif self:IsKeyword("TK_FAIL") then
		action = "FAIL"; self:Advance()
	elseif self:IsKeyword("TK_ROLLBACK") then
		action = "ROLLBACK"; self:Advance()
	else
		self:Error("Expected IGNORE, ABORT, FAIL or ROLLBACK in RAISE()")
	end
	self:Expect("TK_COMMA", nil, nil)
	local msg = self:Expect("TK_STRING", nil, nil)
	self:Expect("TK_RP", nil, nil)
	return { type = "Raise", action = action, message = msg.text }
end

-- ---------------------------------------------------------------------------
-- IN clause rhs parse  (used as postfix)
--   expr IN ( expr-list )
--   expr IN ( select-stmt )
--   expr IN [schema-name .] table-name
--   expr IN [schema-name .] table-function ( args )
-- ---------------------------------------------------------------------------
local function parse_in_rhs(self, expr_fn, parse_select_fn)
	if self:IsTheToken("TK_LP", nil, nil) then
		self:Advance()
		-- if next is SELECT or WITH → subquery
		if self:IsKeyword("TK_SELECT") or self:IsKeyword("TK_WITH") then
			local sub = parse_select_fn(self)
			self:Expect("TK_RP", nil, nil)
			return { kind = "Subquery", select = sub }
		elseif self:IsTheToken("TK_RP", nil, nil) then
			-- empty list
			self:Advance()
			return { kind = "ExprList", exprs = {} }
		else
			local exprs = {}
			table.insert(exprs, expr_fn(self, 1))
			while self:IsTheToken("TK_COMMA", nil, nil) do
				self:Advance()
				table.insert(exprs, expr_fn(self, 1))
			end
			self:Expect("TK_RP", nil, nil)
			return { kind = "ExprList", exprs = exprs }
		end
	else
		-- [schema .] table-or-function
		local a = parse_name(self)
		local b, c
		if self:IsTheToken("TK_DOT", nil, nil) then
			self:Advance()
			b = parse_name(self)
			if self:IsTheToken("TK_DOT", nil, nil) then
				self:Advance()
				c = parse_name(self)
			end
		end
		if self:IsTheToken("TK_LP", nil, nil) then
			-- table-valued function
			self:Advance()
			local args = {}
			if not self:IsTheToken("TK_RP", nil, nil) then
				table.insert(args, expr_fn(self, 1))
				while self:IsTheToken("TK_COMMA", nil, nil) do
					self:Advance()
					table.insert(args, expr_fn(self, 1))
				end
			end
			self:Expect("TK_RP", nil, nil)
			return { kind = "TableFunction", schema = c and a or nil,
			         name = c and b or (b and b or a),
			         tail = c, args = args }
		end
		if c then
			return { kind = "Table", schema = a, name = b }
		elseif b then
			return { kind = "Table", schema = a, name = b }
		else
			return { kind = "Table", schema = nil, name = a }
		end
	end
end

-- ---------------------------------------------------------------------------
-- NUD (null-denotation) = prefix / literal / grouped expression
-- ---------------------------------------------------------------------------
-- Forward declaration – expr_fn is passed down so recursive calls work even
-- before the function is defined.
local function nud(self, expr_fn, parse_select_fn)
	local cur = self.current

	-- Numeric literals
	if cur.token == Tokens1["TK_NUMBER"] then
		self:Advance()
		return { type = "Integer", value = cur.text }

	elseif cur.token == Tokens1["TK_FLOAT"] then
		self:Advance()
		return { type = "Float", value = cur.text }

	elseif cur.token == Tokens1["TK_HEXA"] then
		self:Advance()
		return { type = "Hexadecimal", value = cur.text }

	-- String literal
	elseif cur.token == Tokens1["TK_STRING"] then
		self:Advance()
		return { type = "String", value = cur.text }

	-- Blob literal  X'...'
	elseif cur.token == Tokens1["TK_BLOB"] then
		self:Advance()
		return { type = "Blob", value = cur.text }

	-- Bind parameters  ?  ?NNN  :name  @name  $name
	elseif cur.token == Tokens1["TK_VAR"] then
		self:Advance()
		return { type = "BindParam", value = cur.text }

	-- Unary + (no-op in SQLite but syntactically valid)
	elseif cur.token == Tokens1["TK_OPERATOR"] and cur.text == "+" then
		self:Advance()
		return { type = "UnaryOp", op = "+", expr = expr_fn(self, 9) }  -- same prec as unary minus

	-- Unary -
	elseif cur.token == Tokens1["TK_OPERATOR"] and cur.text == "-" then
		self:Advance()
		return { type = "UnaryOp", op = "-", expr = expr_fn(self, 9) }

	-- Bitwise NOT  ~
	elseif cur.token == Tokens1["TK_OPERATOR"] and cur.text == "~" then
		self:Advance()
		return { type = "UnaryOp", op = "~", expr = expr_fn(self, 9) }

	-- Keyword literals and prefix keywords
	elseif cur.token == Tokens1["TK_KEYWORD"] then
		local kw = cur.keyword

		if kw == "TK_NULL" then
			self:Advance()
			return { type = "Null" }

		elseif kw == "TK_CURRENT_TIME" then
			self:Advance()
			return { type = "CurrentTime" }

		elseif kw == "TK_CURRENT_DATE" then
			self:Advance()
			return { type = "CurrentDate" }

		elseif kw == "TK_CURRENT_TIMESTAMP" then
			self:Advance()
			return { type = "CurrentTimestamp" }

		-- NOT: unary NOT (prec 3) – also kicks off NOT IN / NOT LIKE / NOT GLOB /
		--      NOT MATCH / NOT REGEXP / NOT BETWEEN inside LED, but as a prefix
		--      it is just logical NOT.
		elseif kw == "TK_NOT" then
			self:Advance()
			-- NOT NULL literal (bare keyword NULL)
			if self:IsKeyword("TK_NULL") then
				self:Advance()
				return { type = "UnaryOp", op = "NOT", expr = { type = "Null" } }
			end
			return { type = "UnaryOp", op = "NOT", expr = expr_fn(self, 3) }

		-- EXISTS ( select )
		elseif kw == "TK_EXISTS" then
			self:Advance()
			self:Expect("TK_LP", nil, nil)
			local sub = parse_select_fn(self)
			self:Expect("TK_RP", nil, nil)
			return { type = "Exists", select = sub }

		-- CAST ( expr AS type-name )
		elseif kw == "TK_CAST" then
			self:Advance()
			self:Expect("TK_LP", nil, nil)
			local e  = expr_fn(self, 1)
			self:Expect("TK_KEYWORD", "TK_AS", nil)
			local tn = parse_type_name(self)
			self:Expect("TK_RP", nil, nil)
			return { type = "Cast", expr = e, type_name = tn }

		-- CASE [expr] WHEN … END
		elseif kw == "TK_CASE" then
			return parse_case_expr(self, expr_fn)

		-- RAISE ( … )
		elseif kw == "TK_RAISE" then
			return parse_raise(self)

		else
			-- fall through to identifier handling below
		end
	end

	-- Identifier (column / table.column / schema.table.column / function call)
	if cur.token == Tokens1["TK_ID"]
	or (cur.token == Tokens1["TK_KEYWORD"]) then
		-- Many keywords are used as identifiers in SQLite (e.g. REPLACE, IGNORE …)
		-- We accept them here as names if we didn't handle them as keywords above.
		local name1 = cur.text
		self:Advance()

		-- Is this a function call?
		if self:IsTheToken("TK_LP", nil, nil) then
			self:Advance()
			local fa = parse_function_args(self, expr_fn)
			local node = {
				type     = "FunctionCall",
				name     = name1,
				distinct = fa.distinct,
				star     = fa.star,
				args     = fa.args,
			}
			-- optional FILTER clause
			if self:IsKeyword("TK_FILTER") then
				node.filter = parse_filter_clause(self, expr_fn)
			end
			-- optional OVER clause (window function)
			if self:IsKeyword("TK_OVER") then
				node.over = parse_over_clause(self, expr_fn)
			end
			return node
		end

		-- schema.table.column  or  table.column  or  bare column
		if self:IsTheToken("TK_DOT", nil, nil) then
			self:Advance()
			local name2 = parse_name(self)
			if self:IsTheToken("TK_DOT", nil, nil) then
				self:Advance()
				local name3 = parse_name(self)
				return { type = "ColumnRef",
				         schema = name1, table = name2, column = name3 }
			end
			return { type = "ColumnRef", schema = nil, table = name1, column = name2 }
		end

		return { type = "ColumnRef", schema = nil, table = nil, column = name1 }
	end

	-- Grouped expression  ( expr )  or  ( expr-list )  or  ( select )
	if cur.token == Tokens1["TK_LP"] then
		self:Advance()
		if self:IsKeyword("TK_SELECT") or self:IsKeyword("TK_WITH") then
			local sub = parse_select_fn(self)
			self:Expect("TK_RP", nil, nil)
			return { type = "ScalarSubquery", select = sub }
		end
		local e = expr_fn(self, 1)
		if self:IsTheToken("TK_COMMA", nil, nil) then
			-- expr-list  ( e , e , … )
			local list = { e }
			while self:IsTheToken("TK_COMMA", nil, nil) do
				self:Advance()
				table.insert(list, expr_fn(self, 1))
			end
			self:Expect("TK_RP", nil, nil)
			return { type = "ExprList", exprs = list }
		end
		self:Expect("TK_RP", nil, nil)
		return e
	end

	-- TRUE / FALSE (bare identifiers in SQLite grammar)
	if cur.token == Tokens1["TK_ID"] then
		local up = cur.text:upper()
		if up == "TRUE" then
			self:Advance(); return { type = "True" }
		elseif up == "FALSE" then
			self:Advance(); return { type = "False" }
		end
	end

	self:Error("Unexpected token in expression: " .. tostring(cur.text))
end

-- ---------------------------------------------------------------------------
-- LED (left-denotation) = infix / postfix  continuation
-- Returns nil if there is nothing at this precedence level.
-- ---------------------------------------------------------------------------
local function led(self, left, op_text, op_prec, expr_fn, parse_select_fn)
	-- Plain binary operators (from PREC table)
	local bin_prec = PREC[op_text]
	if bin_prec and bin_prec == op_prec then
		self:Advance()
		local right = expr_fn(self, bin_prec + 1)
		return { type = "BinaryOp", op = op_text, left = left, right = right }
	end

	-- OR
	if op_text == "OR" then
		self:Advance()
		local right = expr_fn(self, PREC.OR + 1)
		return { type = "BinaryOp", op = "OR", left = left, right = right }
	end

	-- AND
	if op_text == "AND" then
		self:Advance()
		local right = expr_fn(self, PREC.AND + 1)
		return { type = "BinaryOp", op = "AND", left = left, right = right }
	end

	-- COLLATE name   (postfix, highest precedence)
	if op_text == "COLLATE" then
		self:Advance()
		local cname = parse_name(self)
		return { type = "Collate", expr = left, collation = cname }
	end

	-- ISNULL / NOTNULL (postfix, no operand)
	if op_text == "ISNULL" then
		self:Advance()
		return { type = "IsNull", expr = left }
	end
	if op_text == "NOTNULL" then
		self:Advance()
		return { type = "NotNull", expr = left }
	end

	-- IS  /  IS NOT  /  IS DISTINCT FROM  /  IS NOT DISTINCT FROM
	if op_text == "IS" then
		self:Advance()
		local not_flag = false
		if self:IsKeyword("TK_NOT") then
			not_flag = true; self:Advance()
		end
		-- IS [NOT] DISTINCT FROM
		if self:IsID() and self.current.text:upper() == "DISTINCT" then
			self:Advance()
			self:Expect("TK_KEYWORD", "TK_FROM", nil)
			local right = expr_fn(self, PREC_IS + 1)
			return { type = "IsDistinctFrom", not_flag = not_flag,
			         left = left, right = right }
		end
		local right = expr_fn(self, PREC_IS + 1)
		if not_flag then
			return { type = "IsNot", left = left, right = right }
		end
		return { type = "Is", left = left, right = right }
	end

	-- NOT IN / NOT LIKE / NOT GLOB / NOT MATCH / NOT REGEXP / NOT BETWEEN
	if op_text == "NOT" then
		self:Advance()
		local next_kw = self.current and self.current.keyword or ""
		local next_tx = self.current and self.current.text:upper() or ""

		if next_kw == "TK_IN" then
			self:Advance()
			local rhs = parse_in_rhs(self, expr_fn, parse_select_fn)
			return { type = "NotIn", left = left, rhs = rhs }

		elseif next_kw == "TK_LIKE" then
			self:Advance()
			local right = expr_fn(self, PREC_IS + 1)
			local escape
			if self:IsKeyword("TK_ESCAPE") then
				self:Advance(); escape = expr_fn(self, PREC_IS + 1)
			end
			return { type = "NotLike", left = left, right = right, escape = escape }

		elseif next_kw == "TK_GLOB" then
			self:Advance()
			local right = expr_fn(self, PREC_IS + 1)
			return { type = "NotGlob", left = left, right = right }

		elseif next_kw == "TK_MATCH" then
			self:Advance()
			local right = expr_fn(self, PREC_IS + 1)
			return { type = "NotMatch", left = left, right = right }

		elseif next_kw == "TK_REGEXP" then
			self:Advance()
			local right = expr_fn(self, PREC_IS + 1)
			return { type = "NotRegexp", left = left, right = right }

		elseif next_kw == "TK_BETWEEN" then
			self:Advance()
			local lo = expr_fn(self, PREC_IS + 1)
			self:Expect("TK_KEYWORD", "TK_AND", nil)
			local hi = expr_fn(self, PREC_IS + 1)
			return { type = "NotBetween", expr = left, lo = lo, hi = hi }

		else
			self:Error("Expected IN/LIKE/GLOB/MATCH/REGEXP/BETWEEN after NOT in expression")
		end
	end

	-- IN
	if op_text == "IN" then
		self:Advance()
		local rhs = parse_in_rhs(self, expr_fn, parse_select_fn)
		return { type = "In", left = left, rhs = rhs }
	end

	-- LIKE [ESCAPE]
	if op_text == "LIKE" then
		self:Advance()
		local right = expr_fn(self, PREC_IS + 1)
		local escape
		if self:IsKeyword("TK_ESCAPE") then
			self:Advance(); escape = expr_fn(self, PREC_IS + 1)
		end
		return { type = "Like", left = left, right = right, escape = escape }
	end

	-- GLOB
	if op_text == "GLOB" then
		self:Advance()
		local right = expr_fn(self, PREC_IS + 1)
		return { type = "Glob", left = left, right = right }
	end

	-- MATCH
	if op_text == "MATCH" then
		self:Advance()
		local right = expr_fn(self, PREC_IS + 1)
		return { type = "Match", left = left, right = right }
	end

	-- REGEXP
	if op_text == "REGEXP" then
		self:Advance()
		local right = expr_fn(self, PREC_IS + 1)
		return { type = "Regexp", left = left, right = right }
	end

	-- BETWEEN lo AND hi
	if op_text == "BETWEEN" then
		self:Advance()
		local lo = expr_fn(self, PREC_IS + 1)
		self:Expect("TK_KEYWORD", "TK_AND", nil)
		local hi = expr_fn(self, PREC_IS + 1)
		return { type = "Between", expr = left, lo = lo, hi = hi }
	end

	return nil  -- nothing consumed
end

-- ---------------------------------------------------------------------------
-- current_op_and_prec: given current token, return (op_text, prec) or nil
-- ---------------------------------------------------------------------------
local function current_op_and_prec(self)
	if self:IsEOF() then return nil, nil end
	local cur  = self.current
	local text = cur.text
	local kw   = cur.keyword

	-- Plain operator tokens
	if cur.token == Tokens1["TK_OPERATOR"] then
		local p = PREC[text]
		if p then return text, p end
		return nil, nil
	end

	-- Keyword operators
	if cur.token == Tokens1["TK_KEYWORD"] then
		if kw == "TK_OR"      then return "OR",      PREC.OR      end
		if kw == "TK_AND"     then return "AND",     PREC.AND     end
		if kw == "TK_NOT"     then return "NOT",     PREC_IS      end  -- infix NOT (NOT IN / NOT LIKE …)
		if kw == "TK_IS"      then return "IS",      PREC_IS      end
		if kw == "TK_IN"      then return "IN",      PREC_IS      end
		if kw == "TK_LIKE"    then return "LIKE",    PREC_IS      end
		if kw == "TK_GLOB"    then return "GLOB",    PREC_IS      end
		if kw == "TK_MATCH"   then return "MATCH",   PREC_IS      end
		if kw == "TK_REGEXP"  then return "REGEXP",  PREC_IS      end
		if kw == "TK_BETWEEN" then return "BETWEEN", PREC_IS      end
		if kw == "TK_ISNULL"  then return "ISNULL",  PREC_IS      end
		if kw == "TK_NOTNULL" then return "NOTNULL", PREC_IS      end
		if kw == "TK_COLLATE" then return "COLLATE", PREC_COLLATE end
	end

	-- ID-as-operator: ISNULL NOTNULL (some tokenisers emit these as TK_ID)
	if cur.token == Tokens1["TK_ID"] then
		local up = text:upper()
		if up == "ISNULL"  then return "ISNULL",  PREC_IS      end
		if up == "NOTNULL" then return "NOTNULL",  PREC_IS     end
	end

	return nil, nil
end

-- ---------------------------------------------------------------------------
-- Main Pratt expression parser
--   min_prec: caller's right-binding power (start at 1 for a full expression)
-- ---------------------------------------------------------------------------
local parse_expr  -- forward
parse_expr = function(self, min_prec, parse_select_fn)
	-- provide a trivial stub when no select parser is supplied
	parse_select_fn = parse_select_fn or function(s)
		s:Error("Subquery not supported in this context")
	end

	local left = nud(self, function(s, mp)
		return parse_expr(s, mp, parse_select_fn)
	end, parse_select_fn)

	while true do
		local op_text, op_prec = current_op_and_prec(self)
		if not op_text or op_prec < min_prec then
			break
		end

		local new_left = led(self, left, op_text, op_prec,
			function(s, mp) return parse_expr(s, mp, parse_select_fn) end,
			parse_select_fn)

		if new_left == nil then
			-- led did not recognise this op at this precedence → stop
			break
		end
		left = new_left
	end

	return left
end

-- ---------------------------------------------------------------------------
-- Expose parse_expr on the Parser instance so statements can call it.
-- ---------------------------------------------------------------------------
local select_stmt
function Parser:ParseExpr(min_prec)
	return parse_expr(self, min_prec or 1, select_stmt)
end

local parse_stmt
local parse_with_stmt
---------
-- cte --
---------

local function common_table_expression(self)
	local output = {type="CTE"}
	output.tablename = parse_name(self)
	local function value_row(s)
		s:Expect("TK_LP", nil, nil)
		local row = {}
		while true do
			if s:IsEOF() then s:Error("Unterminated Common Names") end
			table.insert(row, parse_name(s))
			-- It advances if it's a comma.
			if s:IsTheToken("TK_COMMA", nil, nil) then
				-- It explicitly advances; look right down here at chatgpt and prove to me that it doesn't.
				s:Advance()
			else
				break
			end
		end
		s:Expect("TK_RP", nil, nil)
		return row
	end
	if self:IsTheToken("TK_LP") then
		output.names = value_row(self)
	end
	self:Expect("TK_KEYWORD","TK_AS")
	output.materialized = nil
	if self:IsKeyword("TK_NOT") then
		output.materialized = false
		self:Expect("TK_KEYWORD","TK_NOT")
		self:Expect("TK_KEYWORD","TK_MATERIALIZED")
	end
	if self:IsKeyword("TK_MATERIALIZED") then
		output.materialized = true
		self:Expect("TK_KEYWORD","TK_MATERIALIZED")
	end
	self:Expect("TK_LP", nil, nil)
	if self:IsKeyword("TK_VALUES") then
		output.stmt = values_clause(self)
	else
		output.stmt = parse_with_stmt(self)
		-- This only parses SELECT/INSERT/UPDATE/DELETE statements, not WITH statements.
	end
	self:Expect("TK_RP", nil, nil)
	return output
end

local function cte_group(self)
	local ctes = {}
	repeat
		table.insert(ctes, common_table_expression(self))

		if self:IsTheToken("TK_COMMA") then
			self:Advance()
		else
			break
		end
	until false
	return ctes
end

------------
-- clause --
------------

local function values_clause(self)
	local output = { type = "Values", rows = {} }
	self:Expect("TK_KEYWORD", "TK_VALUES", nil)

	local function value_row(s)
		s:Expect("TK_LP", nil, nil)
		local row = {}
		while true do
			if s:IsEOF() then s:Error("Unterminated VALUES row") end
			table.insert(row, parse_expr(s, 1))
			if s:IsTheToken("TK_COMMA", nil, nil) then
				s:Advance()
				s:Advance()
			else
				break
			end
		end
		s:Expect("TK_RP", nil, nil)
		return row
	end

	table.insert(output.rows, value_row(self))

	while self:IsTheToken("TK_COMMA", nil, nil) do
		local nx = self.next
		if nx and nx.token == Tokens1["TK_LP"] then
			self:Advance()
			table.insert(output.rows, value_row(self))
		else
			break
		end
	end

	self:Emit(output)
end

function with_clause(self)
	local output = {type="With",recursive=false}
	self:Expect("TK_KEYWORD", "TK_WITH", nil)
	if self:IsKeyword("TK_RECURSIVE") then
		output.recursive = true
		self:Expect("TK_KEYWORD", "TK_RECURSIVE", nil)
	end
	local ctes = {}
	while true do
		if self:IsEOF() then break end
		if self.next.token == Tokens1["TK_COMMA"] then
			table.insert(ctes,cte_group(self))
			self:Expect("TK_ID")
		else
			table.insert(ctes,cte_group(self))
			self:Expect("TK_ID")
			break
		end
	end
	output.with = parse_with_stmt(self)
	return output
end

----------
-- stmt --
----------

function select_stmt(self)
	local output = {type="SelectStmt"}
	if self:IsKeyword("TK_WITH") then
		output.with = with_clause(self)
	end
	if self:IsKeyword("TK_WITH") then
		output.values = values_clause(self)
	end
	--parse_ordering_term(self,self.ParseExpr)
	
	return output
end

local function attach_stmt(self)
	local output = { type = "AttachStmt" }
	self:Expect("TK_KEYWORD", "TK_ATTACH", nil)
	self:Expect("TK_KEYWORD", "TK_DATABASE", nil)
	local expr
	expr = self:ParseExpr(nil)
	self:Expect("TK_KEYWORD", "TK_AS", nil)
	local schema_name = self.current.text
	self:Expect("TK_ID")
	
	output.schema = schema_name
	output.expr = expr
	
	self:Emit(output)
end

local function explain_stmt(self, parse_stmt_fn)
	local output = { type = "ExplainStmt" }
	self:Expect("TK_KEYWORD", "TK_EXPLAIN", nil)
	if self:IsKeyword("TK_QUERY") then
		self:Advance()
		self:Expect("TK_KEYWORD", "TK_PLAN", nil)
		output.mode = "query_plan"
	else
		output.mode = "explain"
	end
	output.stmt = parse_stmt_fn(self)
	self:Emit(output)
end

function parse_with_stmt(self)
	if self:IsKeyword("TK_SELECT") then
		select_stmt(self)
	elseif self:IsKeyword("TK_INSERT") then
		insert_stmt(self)
	elseif self:IsKeyword("TK_DELETE") then
		delete_stmt(self)
	elseif self:IsKeyword("TK_UPDATE") then
		update_stmt(self)
	else
		self:Error("Invalid Statement for With")
	end
end

function parse_stmt(self)
	if self:IsKeyword("TK_SELECT") then
		select_stmt(self)
	elseif self:IsKeyword("TK_INSERT") then
		insert_stmt(self)
	elseif self:IsKeyword("TK_DELETE") then
		delete_stmt(self)
	elseif self:IsKeyword("TK_UPDATE") then
		update_stmt(self)
	elseif self:IsKeyword("TK_ATTACH") then
		attach_stmt(self)
	elseif self:IsKeyword("TK_DETACH") then
		detach_stmt(self)
	elseif self:IsKeyword("TK_COMMIT")
	or self:IsKeyword("TK_END") then
		commit_stmt(self)
	end
end

return Parser