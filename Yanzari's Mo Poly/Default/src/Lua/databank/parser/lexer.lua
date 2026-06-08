local Lexer = {}
local utf8 = require(".root./libs/utf8")
Lexer.__index = Lexer

local KeyWordList = {
	type_func_name_keyword = { 'authorization', 'binary', 'collation', 'concurrently', 'cross', 'current_schema', 'freeze', 'full', 'ilike', 'inner', 'is', 'isnull', 'join', 'left', 'like', 'natural', 'notnull', 'outer', 'overlaps', 'right', 'similar', 'tablesample', 'verbose' },
	col_name_keyword = { 'between', 'bigint', 'bit', 'boolean', 'char', 'character', 'coalesce', 'dec', 'decimal', 'exists', 'extract', 'float', 'greatest', 'grouping', 'inout', 'int', 'integer', 'interval', 'json', 'json_array', 'json_arrayagg', 'json_exists', 'json_object', 'json_objectagg', 'json_query', 'json_scalar', 'json_serialize', 'json_table', 'json_value', 'least', 'merge_action', 'national', 'nchar', 'none', 'normalize', 'nullif', 'numeric', 'out', 'overlay', 'position', 'precision', 'real', 'row', 'setof', 'smallint', 'substring', 'time', 'timestamp', 'treat', 'trim', 'values', 'varchar', 'xmlattributes', 'xmlconcat', 'xmlelement', 'xmlexists', 'xmlforest', 'xmlnamespaces', 'xmlparse', 'xmlpi', 'xmlroot', 'xmlserialize', 'xmltable' },
	reserved_keyword = { 'all', 'analyse', 'analyze', 'and', 'any', 'array', 'as', 'asc', 'asymmetric', 'both', 'case', 'cast', 'check', 'collate', 'column', 'constraint', 'create', 'current_catalog', 'current_date', 'current_role', 'current_time', 'current_timestamp', 'current_user', 'default', 'deferrable', 'desc', 'distinct', 'do', 'else', 'end', 'except', 'false', 'fetch', 'for', 'foreign', 'from', 'grant', 'group', 'having', 'in', 'initially', 'intersect', 'into', 'lateral', 'leading', 'limit', 'localtime', 'localtimestamp', 'not', 'null', 'offset', 'on', 'only', 'or', 'order', 'placing', 'primary', 'references', 'returning', 'select', 'session_user', 'some', 'symmetric', 'system_user', 'table', 'then', 'to', 'trailing', 'true', 'union', 'unique', 'user', 'using', 'variadic', 'when', 'where', 'window', 'with' },
	unreserved_keyword = { 'abort', 'absent', 'absolute', 'access', 'action', 'add', 'admin', 'after', 'aggregate', 'also', 'alter', 'always', 'asensitive', 'assertion', 'assignment', 'at', 'atomic', 'attach', 'attribute', 'backward', 'before', 'begin', 'breadth', 'by', 'cache', 'call', 'called', 'cascade', 'cascaded', 'catalog', 'chain', 'characteristics', 'checkpoint', 'class', 'close', 'cluster', 'columns', 'comment', 'comments', 'commit', 'committed', 'compression', 'conditional', 'configuration', 'conflict', 'connection', 'constraints', 'content', 'continue', 'conversion', 'copy', 'cost', 'csv', 'cube', 'current', 'cursor', 'cycle', 'data', 'database', 'day', 'deallocate', 'declare', 'defaults', 'deferred', 'definer', 'delete', 'delimiter', 'delimiters', 'depends', 'depth', 'detach', 'dictionary', 'disable', 'discard', 'document', 'domain', 'double', 'drop', 'each', 'empty', 'enable', 'encoding', 'encrypted', 'enforced', 'enum', 'error', 'escape', 'event', 'exclude', 'excluding', 'exclusive', 'execute', 'explain', 'expression', 'extension', 'external', 'family', 'filter', 'finalize', 'first', 'following', 'force', 'format', 'forward', 'function', 'functions', 'generated', 'global', 'granted', 'groups', 'handler', 'header', 'hold', 'hour', 'identity', 'if', 'immediate', 'immutable', 'implicit', 'import', 'include', 'including', 'increment', 'indent', 'index', 'indexes', 'inherit', 'inherits', 'inline', 'input', 'insensitive', 'insert', 'instead', 'invoker', 'isolation', 'keep', 'key', 'keys', 'label', 'language', 'large', 'last', 'leakproof', 'level', 'listen', 'load', 'local', 'location', 'lock', 'locked', 'logged', 'mapping', 'match', 'matched', 'materialized', 'maxvalue', 'merge', 'method', 'minute', 'minvalue', 'mode', 'month', 'move', 'name', 'names', 'nested', 'new', 'next', 'nfc', 'nfd', 'nfkc', 'nfkd', 'no', 'normalized', 'nothing', 'notify', 'nowait', 'nulls', 'object', 'objects', 'of', 'off', 'oids', 'old', 'omit', 'operator', 'option', 'options', 'ordinality', 'others', 'over', 'overriding', 'owned', 'owner', 'parallel', 'parameter', 'parser', 'partial', 'partition', 'passing', 'password', 'path', 'period', 'plan', 'plans', 'policy', 'preceding', 'prepare', 'prepared', 'preserve', 'prior', 'privileges', 'procedural', 'procedure', 'procedures', 'program', 'publication', 'quote', 'quotes', 'range', 'read', 'reassign', 'recursive', 'ref', 'referencing', 'refresh', 'reindex', 'relative', 'release', 'rename', 'repeatable', 'replace', 'replica', 'reset', 'restart', 'restrict', 'return', 'returns', 'revoke', 'role', 'rollback', 'rollup', 'routine', 'routines', 'rows', 'rule', 'savepoint', 'scalar', 'schema', 'schemas', 'scroll', 'search', 'second', 'security', 'sequence', 'sequences', 'serializable', 'server', 'session', 'set', 'sets', 'share', 'show', 'simple', 'skip', 'snapshot', 'source', 'sql', 'stable', 'standalone', 'start', 'statement', 'statistics', 'stdin', 'stdout', 'storage', 'stored', 'strict', 'string', 'strip', 'subscription', 'support', 'sysid', 'system', 'tables', 'tablespace', 'target', 'temp', 'template', 'temporary', 'text', 'ties', 'transaction', 'transform', 'trigger', 'truncate', 'trusted', 'type', 'types', 'uescape', 'unbounded', 'uncommitted', 'unconditional', 'unencrypted', 'unknown', 'unlisten', 'unlogged', 'until', 'update', 'vacuum', 'valid', 'validate', 'validator', 'value', 'varying', 'version', 'view', 'views', 'virtual', 'volatile', 'whitespace', 'within', 'without', 'work', 'wrapper', 'write', 'xml', 'year', 'yes', 'zone' }
}

local KeyWordSets = {}
for cat, list in pairs(KeyWordList) do
	KeyWordSets[cat] = {}
	for _, word in ipairs(list) do
		KeyWordSets[cat][word] = true
	end
end

local Whitespace = { [" "] = true, ["\t"] = true, ["\n"] = true, ["\r"] = true, ["\f"] = true, ["\v"] = true }
local NonNewlineWhitespace = { [" "] = true, ["\t"] = true, ["\f"] = true, ["\v"] = true }

local SelfChars = {
	[","] = "COMMA", ["("] = "LP", [")"] = "RP", ["["] = "LB", ["]"] = "RB",
	["."] = "DOT", [";"] = "SEMI", [":"] = "COLON",
	["|"] = "Op", ["+"] = "Op", ["-"] = "Op", ["*"] = "Op",
	["/"] = "Op", ["%"] = "Op", ["^"] = "Op", ["<"] = "Op", [">"] = "Op", ["="] = "Op",
}

local OperatorChars = {
	["~"]=true, ["!"]=true, ["@"]=true, ["#"]=true, ["^"]=true, ["&"]=true,
	["|"]=true, ["`"]=true, ["?"]=true, ["+"]=true, ["-"]=true, ["*"]=true,
	["/"]=true, ["%"]=true, ["<"]=true, [">"]=true, ["="]=true,
}

local HexaValid, OctalValid, NumberValid, BinaryValid = {}, {}, {}, { ["0"]=true, ["1"]=true }
for i = 0, 9 do
	NumberValid[tostring(i)] = true
	HexaValid[tostring(i)] = true
	if i < 8 then OctalValid[tostring(i)] = true end
end
for _, c in ipairs({"A","B","C","D","E","F","a","b","c","d","e","f"}) do HexaValid[c] = true end

local function isIdentStart(c) return c:match("[%a_\128-\255]") ~= nil end
local function isIdentCont(c)  return c:match("[%w_\128-\255%$]") ~= nil end
local function isDolqStart(c)  return c:match("[%a_\128-\255]") ~= nil end
local function isDolqCont(c)   return c:match("[%w_\128-\255]") ~= nil end

function Lexer.new(str)
	local self = setmetatable({}, Lexer)
	self.input = str
	self.pos = 1
	self.line = 1
	self.col = 1
	self.current = str:sub(1, 1)
	self.next = str:sub(2, 2)
	self.startbuffing = nil
	self.token = {}
	self.output = {}
	self.size = #str
	return self
end

function Lexer:IsEOF()
	return self.pos > self.size
end

function Lexer:Error(str)
	error("SQL <Lexer> Error: '" .. str .. "' At " .. (self:IsEOF() and "EOS" or ("Col: "..self.col..", Line: "..self.line)) .. ".")
end

function Lexer:Advance(offset)
	offset = offset or 1
	for _ = 1, offset do
		if self.current == '\n' then
			self.line = self.line + 1
			self.col = 1
		else
			self.col = self.col + 1
		end
		self.pos = self.pos + 1
		self.current = self.input:sub(self.pos, self.pos)
		self.next = self.input:sub(self.pos + 1, self.pos + 1)
	end
	return true
end

function Lexer:Peek(offset, limit)
	offset = offset or 1
	return self.input:sub(self.pos + offset, limit and self.pos + limit or self.pos + offset)
end

function Lexer:Match(str)
	return self.input:sub(self.pos, self.pos + #str - 1) == str
end

function Lexer:MatchI(str)
	return self.input:sub(self.pos, self.pos + #str - 1):lower() == str:lower()
end

function Lexer:Insert(c)
	table.insert(self.token, c or self.current)
	self.startbuffing = self.startbuffing or { line = self.line, col = self.col }
end

function Lexer:Emit(type, data)
	local t = {
		type = type,
		token = #self.token > 0 and table.concat(self.token) or nil,
		start = self.startbuffing,
		data = data,
	}
	table.insert(self.output, t)
	self.token = {}
	self.startbuffing = nil
end

function Lexer:IsHexa()   return HexaValid[self.current] == true end
function Lexer:IsOctal()  return OctalValid[self.current] == true end
function Lexer:IsNumber(c) return NumberValid[c or self.current] == true end
function Lexer:IsBinary(c) return BinaryValid[c or self.current] == true end

function Lexer:SkipWhitespace()
	while not self:IsEOF() and Whitespace[self.current] do
		self:Advance()
	end
end

function Lexer:SkipLineComment()
	if self:Match("--") then
		self:Advance(2)
		while not self:IsEOF() and self.current ~= "\n" and self.current ~= "\r" do
			self:Advance()
		end
		return true
	end
	return false
end

function Lexer:Comment()
	if self:Match("/*") then
		local nested = 1
		self:Advance(2)
		while true do
			if self:IsEOF() then self:Error("unterminated /* comment") end
			if self:Match("*/") then
				nested = nested - 1
				self:Advance(2)
				if nested == 0 then break end
			elseif self:Match("/*") then
				nested = nested + 1
				self:Advance(2)
			else
				self:Advance()
			end
		end
		return true
	elseif self:Match("--") then
		self:Advance(2)
		while not self:IsEOF() and self.current ~= "\n" and self.current ~= "\r" do
			self:Advance()
		end
		return true
	end
	return false
end

function Lexer:QuoteContinue()
	local saved_pos   = self.pos
	local saved_line  = self.line
	local saved_col   = self.col
	local saved_cur   = self.current
	local saved_nxt   = self.next

	local saw_newline = false
	while not self:IsEOF() do
		if NonNewlineWhitespace[self.current] then
			self:Advance()
		elseif self:Match("--") then
			self:Advance(2)
			while not self:IsEOF() and self.current ~= "\n" and self.current ~= "\r" do
				self:Advance()
			end
		elseif self.current == "\n" or self.current == "\r" then
			saw_newline = true
			self:Advance()
		else
			break
		end
	end

	if saw_newline and self.current == "'" then
		self:Advance()
		return true
	end

	self.pos     = saved_pos
	self.line    = saved_line
	self.col     = saved_col
	self.current = saved_cur
	self.next    = saved_nxt
	return false
end

function Lexer:UnicodeEscapeString()
	self:Advance(3)

	local raw_tokens = {}

	while true do
		if self:IsEOF() then self:Error("unterminated quoted string") end
		if self:Match("''") then
			table.insert(raw_tokens, { type = "LITERAL_QUOTE" })
			self:Advance(2)
		elseif self.current == "'" then
			self:Advance()
			break
		else
			table.insert(raw_tokens, { type = "CHAR", char = self.current })
			self:Advance()
		end
	end

	while self:QuoteContinue() do
		while true do
			if self:IsEOF() then self:Error("unterminated quoted string") end
			if self:Match("''") then
				table.insert(raw_tokens, { type = "LITERAL_QUOTE" })
				self:Advance(2)
			elseif self.current == "'" then
				self:Advance()
				break
			else
				table.insert(raw_tokens, { type = "CHAR", char = self.current })
				self:Advance()
			end
		end
	end

	local escape = "\\"
	local saved = { pos = self.pos, current = self.current, next = self.next, line = self.line, col = self.col }

	while Whitespace[self.current] do self:Advance() end

	if self:MatchI("UESCAPE") then
		self:Advance(7)
		while Whitespace[self.current] do self:Advance() end
		if self.current ~= "'" then self:Error("expected UESCAPE character") end
		self:Advance()
		if self:IsEOF() then self:Error("expected UESCAPE character") end
		local newescape = self.current
		self:Advance()
		if self.current ~= "'" then self:Error("invalid UESCAPE") end
		self:Advance()
		if utf8.len(newescape) ~= 1 then self:Error("UESCAPE must be a single character") end
		if HexaValid[newescape] or newescape == "+" or newescape == "'" or newescape == '"' or Whitespace[newescape] then
			self:Error("invalid UESCAPE character")
		end
		escape = newescape
	else
		self.pos = saved.pos; self.current = saved.current; self.next = saved.next
		self.line = saved.line; self.col = saved.col
	end

	local idx = 1
	local n = #raw_tokens
	while idx <= n do
		local t = raw_tokens[idx]
		if t.type == "LITERAL_QUOTE" then
			self:Insert("'")
			idx = idx + 1
		elseif t.type == "CHAR" and t.char == escape then
			if idx + 1 <= n and raw_tokens[idx + 1].type == "CHAR" and raw_tokens[idx + 1].char == escape then
				self:Insert(escape)
				idx = idx + 2
			else
				idx = idx + 1
				if idx > n then self:Error("invalid Unicode escape") end
				local is_plus = false
				if raw_tokens[idx].type == "CHAR" and raw_tokens[idx].char == "+" then
					is_plus = true
					idx = idx + 1
				end
				local count = is_plus and 6 or 4
				local hex_buf = {}
				for _ = 1, count do
					if idx > n then self:Error("invalid Unicode escape") end
					local ht = raw_tokens[idx]
					if ht.type ~= "CHAR" or not HexaValid[ht.char] then self:Error("invalid Unicode escape") end
					table.insert(hex_buf, ht.char)
					idx = idx + 1
				end
				local cp = tonumber(table.concat(hex_buf), 16)
				if cp > 0x10FFFF or (cp >= 0xD800 and cp <= 0xDFFF) then
					self:Error("invalid Unicode escape value")
				end
				self:Insert(utf8.char(cp))
			end
		else
			self:Insert(t.char)
			idx = idx + 1
		end
	end

	self:Emit("SCONST")
	return true
end

function Lexer:UnicodeEscapeIdentifier()
	self:Advance(3)

	if self:IsEOF() then self:Error("unterminated quoted identifier") end

	while true do
		if self:IsEOF() then self:Error("unterminated quoted identifier") end
		if self:Match('""') then
			self:Insert('"')
			self:Advance(2)
		elseif self.current == '"' then
			self:Advance()
			break
		else
			self:Insert()
			self:Advance()
		end
	end

	if #self.token == 0 then self:Error("zero-length delimited identifier") end

	local escape = "\\"
	local saved = { pos = self.pos, current = self.current, next = self.next, line = self.line, col = self.col }

	while Whitespace[self.current] do self:Advance() end

	if self:MatchI("UESCAPE") then
		self:Advance(7)
		while Whitespace[self.current] do self:Advance() end
		if self.current ~= "'" then self:Error("expected UESCAPE character") end
		self:Advance()
		if self:IsEOF() then self:Error("expected UESCAPE character") end
		local newescape = self.current
		self:Advance()
		if self.current ~= "'" then self:Error("invalid UESCAPE") end
		self:Advance()
		if utf8.len(newescape) ~= 1 then self:Error("UESCAPE must be a single character") end
		if HexaValid[newescape] or newescape == "+" or newescape == "'" or newescape == '"' or Whitespace[newescape] then
			self:Error("invalid UESCAPE character")
		end
		escape = newescape
	else
		self.pos = saved.pos; self.current = saved.current; self.next = saved.next
		self.line = saved.line; self.col = saved.col
	end

	self:Emit("UIDENT", { escape = escape })
	return true
end

function Lexer:String()
	local c = self.current
	local c2 = self.next

	if (c == "U" or c == "u") and c2 == "&" then
		local c3 = self.input:sub(self.pos + 2, self.pos + 2)
		if c3 == "'" then
			return self:UnicodeEscapeString()
		elseif c3 == '"' then
			return self:UnicodeEscapeIdentifier()
		else
			local word = { c }
			self:Advance()
			while not self:IsEOF() and isIdentCont(self.current) do
				table.insert(word, self.current)
				self:Advance()
			end
			local raw = table.concat(word)
			local low = raw:lower()
			local cat
			if KeyWordSets.reserved_keyword[low] then cat = 0
			elseif KeyWordSets.unreserved_keyword[low] then cat = 1
			elseif KeyWordSets.col_name_keyword[low] then cat = 2
			elseif KeyWordSets.type_func_name_keyword[low] then cat = 3
			end
			self.token = { low }
			self.startbuffing = { line = self.line, col = self.col }
			if cat ~= nil then
				self:Emit("KEYWORD", cat)
			else
				self:Emit("ID", { quoted = false })
			end
			return true
		end
	end

	if c == "'" then
		self:Advance()
		while true do
			if self:IsEOF() then self:Error("unterminated quoted string") end
			if self:Match("''") then
				self:Insert("'")
				self:Advance(2)
			elseif self.current == "'" then
				self:Advance()
				if self:QuoteContinue() then
				else
					break
				end
			else
				self:Insert()
				self:Advance()
			end
		end
		self:Emit("SCONST")
		return true
	end

	if (c == "N" or c == "n") and c2 == "'" then
		self:Advance()
		self:Advance()
		while true do
			if self:IsEOF() then self:Error("unterminated quoted string") end
			if self:Match("''") then
				self:Insert("'")
				self:Advance(2)
			elseif self.current == "'" then
				self:Advance()
				if self:QuoteContinue() then
				else
					break
				end
			else
				self:Insert()
				self:Advance()
			end
		end
		self:Emit("SCONST", { national = true })
		return true
	end

	if (c == "E" or c == "e") and c2 == "'" then
		self:Advance(2)
		while true do
			if self:IsEOF() then self:Error("unterminated quoted string") end
			if self:Match("''") then
				self:Insert("'")
				self:Advance(2)
			elseif self.current == "'" then
				self:Advance()
				if self:QuoteContinue() then
				else
					break
				end
			elseif self:Match("\\") then
				self:Advance()
				if self:IsEOF() then
					self:Insert("\\")
				else
					local n = self.current
					if     n == "b" then self:Insert("\b"); self:Advance()
					elseif n == "f" then self:Insert("\f"); self:Advance()
					elseif n == "n" then self:Insert("\n"); self:Advance()
					elseif n == "r" then self:Insert("\r"); self:Advance()
					elseif n == "t" then self:Insert("\t"); self:Advance()
					elseif n == "v" then self:Insert("\v"); self:Advance()
					elseif n == "\\" then self:Insert("\\"); self:Advance()
					elseif n == "'" then self:Insert("'"); self:Advance()
					elseif n == '"' then self:Insert('"'); self:Advance()
					elseif n == "x" then
						self:Advance()
						local hexbuf = {}
						if self:IsHexa() then
							table.insert(hexbuf, self.current); self:Advance()
							if self:IsHexa() then table.insert(hexbuf, self.current); self:Advance() end
						else
							self:Error("invalid hexadecimal escape sequence")
						end
						self:Insert(string.char(tonumber(table.concat(hexbuf), 16)))
					elseif n == "u" then
						self:Advance()
						local hexbuf = {}
						for _ = 1, 4 do
							if not self:IsHexa() then self:Error("invalid Unicode escape") end
							table.insert(hexbuf, self.current); self:Advance()
						end
						local cp = tonumber(table.concat(hexbuf), 16)
						if cp >= 0xD800 and cp <= 0xDBFF then
							if not self:Match("\\u") and not self:Match("\\U") then
								self:Error("invalid Unicode surrogate pair")
							end
							self:Advance(2)
							local hexbuf2 = {}
							for _ = 1, 4 do
								if not self:IsHexa() then self:Error("invalid Unicode surrogate pair") end
								table.insert(hexbuf2, self.current); self:Advance()
							end
							local cp2 = tonumber(table.concat(hexbuf2), 16)
							if cp2 < 0xDC00 or cp2 > 0xDFFF then self:Error("invalid Unicode surrogate pair") end
							cp = 0x10000 + (cp - 0xD800) * 0x400 + (cp2 - 0xDC00)
						elseif cp >= 0xDC00 and cp <= 0xDFFF then
							self:Error("invalid Unicode surrogate pair")
						end
						self:Insert(utf8.char(cp))
					elseif n == "U" then
						self:Advance()
						local hexbuf = {}
						for _ = 1, 8 do
							if not self:IsHexa() then self:Error("invalid Unicode escape") end
							table.insert(hexbuf, self.current); self:Advance()
						end
						local cp = tonumber(table.concat(hexbuf), 16)
						if cp > 0x10FFFF or (cp >= 0xD800 and cp <= 0xDFFF) then
							self:Error("invalid Unicode escape value")
						end
						self:Insert(utf8.char(cp))
					else
						if OctalValid[n] then
							local octbuf = { n }; self:Advance()
							if self:IsOctal() then table.insert(octbuf, self.current); self:Advance()
								if self:IsOctal() then table.insert(octbuf, self.current); self:Advance() end
							end
							self:Insert(string.char(tonumber(table.concat(octbuf), 8)))
						else
							self:Insert(n); self:Advance()
						end
					end
				end
			else
				self:Insert()
				self:Advance()
			end
		end
		self:Emit("SCONST")
		return true
	end

	if (c == "B" or c == "b") and c2 == "'" then
		self:Advance(2)
		local buf = {}
		while true do
			if self:IsEOF() then self:Error("unterminated bit string literal") end
			if self.current == "'" then
				self:Advance()
				if self:QuoteContinue() then
				else
					break
				end
			else
				table.insert(buf, self.current)
				self:Advance()
			end
		end
		self:Insert("b" .. table.concat(buf))
		self:Emit("BCONST")
		return true
	end

	if (c == "X" or c == "x") and c2 == "'" then
		self:Advance(2)
		local buf = {}
		while true do
			if self:IsEOF() then self:Error("unterminated hexadecimal string literal") end
			if self.current == "'" then
				self:Advance()
				if self:QuoteContinue() then
				else
					break
				end
			else
				table.insert(buf, self.current)
				self:Advance()
			end
		end
		self:Insert("x" .. table.concat(buf))
		self:Emit("XCONST")
		return true
	end

	if c == "$" then
		if c2 == "$" or isDolqStart(c2) then
			local tag = { "$" }
			self:Advance()
			while not self:IsEOF() and self.current ~= "$" do
				if not isDolqCont(self.current) then self:Error("invalid dollar-quote tag") end
				table.insert(tag, self.current)
				self:Advance()
			end
			if self:IsEOF() then self:Error("unterminated dollar-quoted string") end
			table.insert(tag, "$")
			self:Advance()
			local tag_str = table.concat(tag)

			while true do
				if self:IsEOF() then self:Error("unterminated dollar-quoted string") end
				if self:Match(tag_str) then
					self:Advance(#tag_str)
					break
				end
				self:Insert()
				self:Advance()
			end
			self:Emit("SCONST", { tag = tag_str })
			return true
		end
	end

	return false
end

function Lexer:NumberLogic()
	local under = false
	while true do
		if self.current == "_" then
			if under then self:Error("invalid use of underscore in numeric constant") end
			if not self:IsNumber(self.input:sub(self.pos - 1, self.pos - 1)) then
				self:Error("invalid use of underscore in numeric constant")
			end
			self:Advance()
			if not self:IsNumber() then self:Error("invalid use of underscore in numeric constant") end
			under = true
		elseif self:IsNumber() then
			self:Insert()
			self:Advance()
			under = false
		else
			break
		end
	end
end

function Lexer:Number()
	if self:Match("0x") or self:Match("0X") then
		local prefix = self.input:sub(self.pos, self.pos + 1)
		if not HexaValid[self.input:sub(self.pos + 2, self.pos + 2)] and self.input:sub(self.pos + 2, self.pos + 2) ~= "_" then
			self:Error("invalid hexadecimal integer")
		end
		self:Insert(); self:Advance()
		self:Insert(); self:Advance()
		if self.current == "_" then self:Error("invalid use of underscore in numeric constant") end
		if not self:IsHexa() then self:Error("invalid hexadecimal integer") end
		while self:IsHexa() or self.current == "_" do
			if self.current == "_" then
				self:Advance()
				if not self:IsHexa() then self:Error("invalid use of underscore in numeric constant") end
			else
				self:Insert(); self:Advance()
			end
		end
		if isIdentStart(self.current) or self:IsNumber() then
			self:Error("trailing junk after numeric literal")
		end
		self:Emit("ICONST", { base = 16 })
		return true
	end

	if self:Match("0o") or self:Match("0O") then
		if not OctalValid[self.input:sub(self.pos + 2, self.pos + 2)] and self.input:sub(self.pos + 2, self.pos + 2) ~= "_" then
			self:Error("invalid octal integer")
		end
		self:Insert(); self:Advance()
		self:Insert(); self:Advance()
		if self.current == "_" then self:Error("invalid use of underscore in numeric constant") end
		if not self:IsOctal() then self:Error("invalid octal integer") end
		while self:IsOctal() or self.current == "_" do
			if self.current == "_" then
				self:Advance()
				if not self:IsOctal() then self:Error("invalid use of underscore in numeric constant") end
			else
				self:Insert(); self:Advance()
			end
		end
		if isIdentStart(self.current) or self:IsNumber() then
			self:Error("trailing junk after numeric literal")
		end
		self:Emit("ICONST", { base = 8 })
		return true
	end

	if self:Match("0b") or self:Match("0B") then
		if not self:IsBinary(self.input:sub(self.pos + 2, self.pos + 2)) and self.input:sub(self.pos + 2, self.pos + 2) ~= "_" then
			self:Error("invalid binary integer")
		end
		self:Insert(); self:Advance()
		self:Insert(); self:Advance()
		if self.current == "_" then self:Error("invalid use of underscore in numeric constant") end
		if not self:IsBinary() then self:Error("invalid binary integer") end
		while self:IsBinary() or self.current == "_" do
			if self.current == "_" then
				self:Advance()
				if not self:IsBinary() then self:Error("invalid use of underscore in numeric constant") end
			else
				self:Insert(); self:Advance()
			end
		end
		if isIdentStart(self.current) or self:IsNumber() then
			self:Error("trailing junk after numeric literal")
		end
		self:Emit("ICONST", { base = 2 })
		return true
	end

	local isReal = false

	if self.current == "." and self:IsNumber(self.next) then
		isReal = true
		self:Insert(); self:Advance()
		self:NumberLogic()
	elseif self:IsNumber() then
		self:NumberLogic()

		if self.current == "." then
			if self.next == "." then
				if isIdentStart(self.next) or self:IsNumber(self.next) then
					self:Error("trailing junk after numeric literal")
				end
				self:Emit("ICONST", { base = 10 })
				return true
			end
			isReal = true
			self:Insert(); self:Advance()
			if self:IsNumber() then self:NumberLogic() end
		end
	else
		return false
	end

	if self.current == "e" or self.current == "E" then
		local enext = self.next
		if enext == "-" or enext == "+" then
			local enextnext = self.input:sub(self.pos + 2, self.pos + 2)
			if not self:IsNumber(enextnext) then
				self:Error("trailing junk after numeric literal")
			end
		elseif not self:IsNumber(enext) then
			self:Error("trailing junk after numeric literal")
		end
		isReal = true
		self:Insert(); self:Advance()
		if self.current == "-" or self.current == "+" then
			self:Insert(); self:Advance()
		end
		if not self:IsNumber() then self:Error("invalid exponent") end
		self:NumberLogic()
	end

	if isIdentStart(self.current) then
		self:Error("trailing junk after numeric literal")
	end

	self:Emit(isReal and "FCONST" or "ICONST", isReal and nil or { base = 10 })
	return true
end

function Lexer:Ident()
	if not isIdentStart(self.current) then return false end

	while not self:IsEOF() and isIdentCont(self.current) do
		self:Insert()
		self:Advance()
	end

	local word = table.concat(self.token)
	local low = word:lower()

	local cat
	if KeyWordSets.reserved_keyword[low] then cat = 0
	elseif KeyWordSets.unreserved_keyword[low] then cat = 1
	elseif KeyWordSets.col_name_keyword[low] then cat = 2
	elseif KeyWordSets.type_func_name_keyword[low] then cat = 3
	end

	self.token = { low }
	if cat ~= nil then
		self:Emit("KEYWORD", cat)
	else
		self:Emit("ID", { quoted = false })
	end
	return true
end

function Lexer:Param()
	if self.current ~= "$" then return false end
	local next1 = self.next
	if not self:IsNumber(next1) then return false end

	self:Advance()
	while self:IsNumber() do
		self:Insert()
		self:Advance()
	end

	if isIdentStart(self.current) then
		self:Error("trailing junk after parameter")
	end

	self:Emit("PARAM")
	return true
end

function Lexer:Operator()
	if not OperatorChars[self.current] then return false end

	local characters = {}
	local p = self.pos
	while p <= self.size do
		local c = self.input:sub(p, p)
		if not OperatorChars[c] then break end
		if self.input:sub(p, p + 1) == "--" or self.input:sub(p, p + 1) == "/*" then break end
		table.insert(characters, c)
		p = p + 1
	end

	local yyleng = #characters
	local nchars = yyleng

	if nchars > 1 and (characters[nchars] == "+" or characters[nchars] == "-") then
		local found = false
		for ic = nchars - 1, 1, -1 do
			local c = characters[ic]
			if c == "~" or c == "!" or c == "@" or c == "#" or c == "^" or
			   c == "&" or c == "|" or c == "`" or c == "?" or c == "%" then
				found = true
				break
			end
		end
		if not found then
			while nchars > 1 and (characters[nchars] == "+" or characters[nchars] == "-") do
				nchars = nchars - 1
			end
		end
	end

	if nchars >= 64 then self:Error("operator too long") end

	for i = 1, nchars do
		self:Insert(characters[i])
		self:Advance()
	end

	if nchars < yyleng then
		if nchars == 1 then
			local sc = characters[1]
			local stype = SelfChars[sc]
			if stype then
				if stype == "Op" then
					self:Emit("Op")
				else
					self:Emit(stype)
				end
				return true
			end
		end
		if nchars == 2 then
			local op = characters[1] .. characters[2]
			if op == "=>" then self:Emit("EQUALS_GREATER"); return true end
			if op == ">=" then self:Emit("GREATER_EQUALS"); return true end
			if op == "<=" then self:Emit("LESS_EQUALS"); return true end
			if op == "<>" then self:Emit("NOT_EQUALS"); return true end
			if op == "!=" then self:Emit("NOT_EQUALS"); return true end
			if op == "->" then self:Emit("RIGHT_ARROW"); return true end
		end
	end

	self:Emit("Op")
	return true
end

function Lexer:SpecialOperator()
	if self:Match("::") then self:Insert("::"); self:Advance(2); self:Emit("TYPECAST"); return true end
	if self:Match(":=") then self:Insert(":="); self:Advance(2); self:Emit("COLON_EQUALS"); return true end
	if self:Match("=>") then self:Insert("=>"); self:Advance(2); self:Emit("EQUALS_GREATER"); return true end
	if self:Match("..") then self:Insert(".."); self:Advance(2); self:Emit("DOT_DOT"); return true end
	if self:Match(">=") then self:Insert(">="); self:Advance(2); self:Emit("GREATER_EQUALS"); return true end
	if self:Match("<=") then self:Insert("<="); self:Advance(2); self:Emit("LESS_EQUALS"); return true end
	if self:Match("<>") then self:Insert("<>"); self:Advance(2); self:Emit("NOT_EQUALS"); return true end
	if self:Match("!=") then self:Insert("!="); self:Advance(2); self:Emit("NOT_EQUALS"); return true end
	if self:Match("->") then self:Insert("->"); self:Advance(2); self:Emit("RIGHT_ARROW"); return true end
	return false
end

function Lexer:QuotedIdentifier()
	if self.current ~= '"' then return false end
	self:Advance()

	while true do
		if self:IsEOF() then self:Error("unterminated quoted identifier") end
		if self:Match('""') then
			self:Insert('"')
			self:Advance(2)
		elseif self.current == '"' then
			self:Advance()
			break
		else
			self:Insert()
			self:Advance()
		end
	end

	if #self.token == 0 then self:Error("zero-length delimited identifier") end
	self:Emit("ID", { quoted = true })
	return true
end

function Lexer:Tokenize()
	while not self:IsEOF() do
		while not self:IsEOF() and (Whitespace[self.current] or self:Match("--") or self:Match("/*")) do
			if Whitespace[self.current] then
				self:SkipWhitespace()
			elseif self:Match("--") then
				self:Comment()
			elseif self:Match("/*") then
				self:Comment()
			end
		end
		if self:IsEOF() then break end

		if self:String() then
		elseif self:Number() then
		elseif self:Param() then
		elseif self:Ident() then
		elseif self:QuotedIdentifier() then
		elseif self:SpecialOperator() then
		elseif self:Operator() then
		else
			local c = self.current
			local stype = SelfChars[c]
			if stype then
				self:Insert()
				self:Advance()
				if stype == "Op" then
					self:Emit("Op")
				else
					self:Emit(stype)
				end
			else
				self:Error("syntax error, unexpected character: " .. tostring(c))
			end
		end
	end

	return self.output
end

return Lexer