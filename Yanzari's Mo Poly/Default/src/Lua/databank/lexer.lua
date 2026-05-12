/*
             Yanzari's Mo Poly
                -By Yanzari
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-
lexer.lua
*/
local Lexer = {}
local KeyWordsTokens = {
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
	["TK_WITHOUT"] = 147
}
local Tokens = {
	-- types
	["TK_EOF"] = 0,
	["TK_STRING"] = 1,
	["TK_NUMBER"] = 2,
	["TK_FLOAT"] = 3,
	["TK_BLOB"] = 4,
	["TK_HEXA"] = 5,
	["TK_KEYWORD"] = 6,
	["TK_ID"] = 7,
	["TK_OPERATOR"] = 8,
	["TK_VAR"] = 9,
	
	-- parens
	["TK_LP"] = 10,
	["TK_RP"] = 11,
	
	-- misc
	["TK_DOT"] = 12,
	["TK_SEMI"] = 13,
	["TK_COMMA"] = 14,
	["TK_COMMAND"] = 15 -- new
}
function Lexer.New(str)
	if not (str ~= ""
	and str ~= nil
	and type(str) == "string") then
		error("SQL <Lexer> Error: Invalid Input")
	end
	local self = setmetatable({},{__index=Lexer})
	self.tokens = {}
	self.line = 1
	self.col = 1
	self.pos = 1
	self.current = string.sub(str,self.pos,self.pos)
	self.next = string.sub(str,self.pos+1,self.pos+1)
	self.inp = str
	self.token = {}
	return self
end
function Lexer:Emit(tk,arg1,arg2)
	local token = Tokens[tk]
	if tk == "TK_KEYWORD" then
		local keywordname = "TK_"..string.upper(arg1)
		table.insert(self.tokens,{token=token,keyword=KeyWordsTokens[keywordname],text=arg2})
		return
	end
	if arg1 ~= nil then
		table.insert(self.tokens,{token=token,text=arg1})
		return
	end
	table.insert(self.tokens,{token=token})
	return
end
function Lexer:Error(tx)
	error("SQL <Lexer> Error at '"..self.line.."|"..self.col.."': "..tx)
	return
end
function Lexer:Flush()
	local result = table.concat(self.token,"")
	self.token = {}
	return result
end
function Lexer:InsertToken(tkn)
	self.token[#self.token+1] = tkn
end
function Lexer:EOF()
	if (self.pos > #self.inp) then
		return true
	end
	return false
end
function Lexer:Advance()
	if self.current == "\n" then
		self.line = self.line + 1
		self.col = 1
		self.pos = self.pos + 1
		if self:EOF()==true then
			self.current = ""
			self.next = ""
		else
			self.current = string.sub(self.inp,self.pos,self.pos)
			self.next = string.sub(self.inp,self.pos+1,self.pos+1)
		end
	else
		self.pos = self.pos + 1
		self.col = self.col + 1
		self.current = string.sub(self.inp,self.pos,self.pos)
		self.next = string.sub(self.inp,self.pos+1,self.pos+1)
		if self:EOF()==true then
			self.current = ""
			self.next = ""
		else
			self.current = string.sub(self.inp,self.pos,self.pos)
			self.next = string.sub(self.inp,self.pos+1,self.pos+1)
		end
	end
end
function Lexer:WhiteSpace()
	if (self.current == "\n"
	or self.current == "\t"
	or self.current == "\r"
	or self.current == " ") then
		return true
	end
	return false
end
function Lexer:JumpWhiteSpace()
	if (self.current == "\n"
	or self.current == "\t"
	or self.current == "\r"
	or self.current == " ") then
		self:Advance()
		return true
	end
	return false
end
function Lexer:Alphabetic()
	if self:EOF()==true then return false end
	if (string.byte(string.upper(self.current)) >= string.byte("A")
	and string.byte(string.upper(self.current)) <= string.byte("Z")) or self.current == "_" or
	(string.byte(string.upper(self.current)) >= 127) then
		return true
	end
	return false
end
function Lexer:Numeric()
	if self:EOF()==true then return false end
	if (string.byte(string.upper(self.current)) >= string.byte("0")
	and string.byte(string.upper(self.current)) <= string.byte("9")) then
		return true
	end
	return false
end
function Lexer:IsHexadecimal()
	if self:EOF()==true then return false end
	if (string.byte(string.upper(self.current)) >= string.byte("0")
	and string.byte(string.upper(self.current)) <= string.byte("9"))
	or (string.byte(string.upper(self.current)) >= string.byte("A")
	and string.byte(string.upper(self.current)) <= string.byte("F")) then
		return true
	end
	return false
end
function Lexer:OnlyAlphabetic()
	if self:EOF()==true then return false end
	if (string.byte(string.upper(self.current)) >= string.byte("A")
	and string.byte(string.upper(self.current)) <= string.byte("Z")) then
		return true
	end
	return false
end
function Lexer:String()
	if self.current == "'" then
		self:Advance()
		while true do
			if (self:EOF()) then
				self:Error("UnTermined String")
				break
			end
			if self.current == "'" then
				if self.next == "'" then
					self:InsertToken("'")
					self:Advance()
					self:Advance()
				else
					break
				end
			end
			self:InsertToken(self.current)
			self:Advance()
		end
		self:Advance()
		self:Emit("TK_STRING",self:Flush())
		return true
	end
	return false
end
function Lexer:Comment()
	-- Here we've implemented nested comments.
	
	-- It is recommended not to use this for compatibility reasons,
	-- because the original SQL does not support it,
	-- but we do support it here.
	local symbol = nil
	if (self.current == "-"
	and self.next == "-") then
		symbol = "s"
	end
	if (self.current == "/"
	and self.next == "*") then
		symbol = "l"
	end
	if (self.current == "*"
	and self.next == "/") then
		self:Error("Comment depth corrupted")
		return false
	end
	if symbol == nil then
		return false
	end
	self:Advance() -- - or /
	self:Advance() -- - or *
	
	local depth = 1
	
	if symbol == "s" then
		while true do
			if self:EOF() == true then
				break
			end
			if self.current == "\n" then
				self:Advance() -- \n
				return true
			end
			self:Advance()
		end
		return true
	end
	
	while true do
		if (self:EOF()) then
			self:Error("UnTermined Comment")
			break
		end
		
		if self.current == "/"
		and self.next == "*" then
			depth = depth + 1
			self:Advance() -- /
			self:Advance() -- *
		elseif self.current == "*"
		and self.next == "/" then
			depth = depth - 1
			self:Advance() -- *
			self:Advance() -- /
			if depth == 0 then
				break
			end
		else
			self:Advance()
		end
	end
	return true
end
function Lexer:Operator()
	if self.current == "-"
	and self.next == ">" then
		self:InsertToken(self.current)
		self:Advance()
		if self.next == ">" then
			self:InsertToken(self.current)
			self:Advance()
		end
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	
	if self.current == "<"
	and self.next == ">" then
		self:InsertToken(self.current)
		self:Advance()
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == ">"
	and self.next == "=" then
		self:InsertToken(self.current)
		self:Advance()
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "<"
	and self.next == "=" then
		self:InsertToken(self.current)
		self:Advance()
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "="
	and self.next == "=" then
		self:InsertToken(self.current)
		self:Advance()
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "<"
	and self.next == "<" then
		self:InsertToken(self.current)
		self:Advance()
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == ">"
	and self.next == ">" then
		self:InsertToken(self.current)
		self:Advance()
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "!"
	and self.next == "=" then
		self:InsertToken(self.current)
		self:Advance()
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "|"
	and self.next == "|" then
		self:InsertToken(self.current)
		self:Advance()
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	
	-- bitwise
	if self.current == "&" then
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "|" then
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "~" then
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	-- Operators
	if self.current == "+" then
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "-" then
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "*" then
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "/" then
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == ">" then
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "<" then
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	if self.current == "%" then
		self:InsertToken(self.current)
		self:Advance()
		self:Emit("TK_OPERATOR",self:Flush())
		return true
	end
	-- Paren
	if self.current == "(" then
		self:InsertToken(self.current)
		self:Advance()
		self:Flush()
		self:Emit("TK_LP")
		return true
	end
	if self.current == ")" then
		self:InsertToken(self.current)
		self:Advance()
		self:Flush()
		self:Emit("TK_RP")
		return true
	end
	-- misc
	if self.current == "." then
		self:InsertToken(self.current)
		self:Advance()
		self:Flush()
		self:Emit("TK_DOT")
		return true
	end
	if self.current == ";" then
		self:InsertToken(self.current)
		self:Advance()
		self:Flush()
		self:Emit("TK_SEMI")
		return true
	end
	if self.current == "," then
		self:InsertToken(self.current)
		self:Advance()
		self:Flush()
		self:Emit("TK_COMMA")
		return true
	end
	return false
end
function Lexer:Hexadecimal()
	-- Why does this only work with "0x"? Why not "1x"?
	if self.current == "0"
	and (self.next == "x"
	or self.next == "X") then
		self:Advance()
		self:Advance()
		if self:IsHexadecimal()==true then
			while true do
				if self:EOF() then break end
				if self:WhiteSpace() then break end
				if self:IsHexadecimal()==false then self:Error("Invalid Hexadecimal") end
				self:InsertToken(self.current)
				self:Advance()
			end
		else
			-- Why have "0x" only?
			self:Error("Invalid Hexadecimal")
		end
		-- VDBE is the one who resolves this.
		self:Emit("TK_HEXA",tonumber(self:Flush()))
		return true
	end
	return false
end
function Lexer:Blob()
	if (self.current == "x"
	or self.current == "X")
	and self.next == "'" then
		self:Advance()
		self:Advance()
		local count = 0
		while true do
			if self.current=="'" then break end
			if self:EOF() then self:Error("Invalid Blob") end
			if self:IsHexadecimal()==false then self:Error("Invalid Blob") end
			self:InsertToken(self.current)
			self:Advance()
			count = count + 1
		end
		if self.next=="'" then
			self:Error("Invalid Blob")
		end
		if (count % 2) ~= 0 then
			-- I would treat it as character + 0, but that makes it incompatible with sqlite3,
			-- so I'll just throw an error.
			self:Error("Odd length in blob")
		end
		local function tobytes(s)
			local bytes = {}
			for i = 1, #s, 2 do
				local par = s:sub(i, i+1)
				local value = tonumber(par, 16)
				if value == nil then
					self:Error("Invalid hexadecimal byte")
				end
				table.insert(bytes, value)
			end
			return bytes
		end
		self:Advance()
		
		local result = tobytes(self:Flush())
		self:Emit("TK_BLOB",result)
		return true
	end
	return false
end
function Lexer:Number()
	local function exp()
		if self.current == "e" or self.current == "E" then
			self:InsertToken(self.current)
			self:Advance()
			if self.current == "-"
			or self.current == "+" then
				self:InsertToken(self.current)
				self:Advance()
			end
			if self:Numeric() == true then
				while true do
					if self:Numeric()~=true then break end
					self:InsertToken(self.current)
					self:Advance()
				end
			else
				self:Error("Invalid Exponent")
			end
			return true
		end
		return false
	end
	if self:Numeric()~=true then
		if self.current == "." then
			self:InsertToken(self.current)
			self:Advance()
			if self:Numeric()==true then
				while true do
					if self:Numeric()~=true then break end
					self:InsertToken(self.current)
					self:Advance()
				end
			else
				self:Flush()
				self:Emit("TK_DOT")
				return true
			end
			exp()
			self:Emit("TK_FLOAT",self:Flush())
			return true
		end
		return false
	end
	while true do
		if self:Numeric()~=true then break end
		self:InsertToken(self.current)
		self:Advance()
	end
	local a_exp = exp()
	if a_exp == true and self.current == "." then
		self:Error("Invalid Float")
	end
	if a_exp == false and self.current == "." then
		self:InsertToken(self.current)
		self:Advance()
		if self:Numeric()==true then -- self:NextNumeric is Wrong
			while true do
				if self:Numeric()~=true then break end
				self:InsertToken(self.current)
				self:Advance()
			end
			exp()
		end
		self:Emit("TK_FLOAT",self:Flush())
		return true
	end
	if a_exp == false then
		self:Emit("TK_NUMBER",self:Flush())
	else
		self:Emit("TK_FLOAT",self:Flush())
	end
	return true
end
function Lexer:Keyword()
	return self:Identifier()
end
function Lexer:SpecialCommands()
	-- Special Commands
	-- SQL Original does not support
	if self.current ~= "\\" then
		return false
	end
	self:Advance()
	if self:OnlyAlphabetic() then
		if self.current == "x"
		or self.current == "X" then
			self:InsertToken(self.current)
			self:Advance()
			if (string.byte(self.current) >= string.byte("0")
			and string.byte(self.current) <= string.byte("9")) or
			(string.byte(self.current) >= string.byte("A")
			and string.byte(self.current) <= string.byte("F")) or
			(string.byte(self.current) >= string.byte("a")
			and string.byte(self.current) <= string.byte("f"))then
				self:InsertToken(self.current)
				self:Advance()
			else
				self:Error("Invalid Command")
			end
			if (string.byte(self.current) >= string.byte("0")
			and string.byte(self.current) <= string.byte("9")) or
			(string.byte(self.current) >= string.byte("A")
			and string.byte(self.current) <= string.byte("F")) or
			(string.byte(self.current) >= string.byte("a")
			and string.byte(self.current) <= string.byte("f"))then
				self:InsertToken(self.current)
			else
				self:Error("Invalid Command")
			end
		elseif self.current == "u"
		or self.current == "U" then
			self:InsertToken(self.current)
			self:Advance()
			if (string.byte(self.current) >= string.byte("0")
			and string.byte(self.current) <= string.byte("9")) or
			(string.byte(self.current) >= string.byte("A")
			and string.byte(self.current) <= string.byte("F")) or
			(string.byte(self.current) >= string.byte("a")
			and string.byte(self.current) <= string.byte("f"))then
				self:InsertToken(self.current)
				self:Advance()
			else
				self:Error("Invalid Command")
			end
			if (string.byte(self.current) >= string.byte("0")
			and string.byte(self.current) <= string.byte("9")) or
			(string.byte(self.current) >= string.byte("A")
			and string.byte(self.current) <= string.byte("F")) or
			(string.byte(self.current) >= string.byte("a")
			and string.byte(self.current) <= string.byte("f"))then
				self:InsertToken(self.current)
				self:Advance()
			else
				self:Error("Invalid Command")
			end
			if (string.byte(self.current) >= string.byte("0")
			and string.byte(self.current) <= string.byte("9")) or
			(string.byte(self.current) >= string.byte("A")
			and string.byte(self.current) <= string.byte("F")) or
			(string.byte(self.current) >= string.byte("a")
			and string.byte(self.current) <= string.byte("f"))then
				self:InsertToken(self.current)
				self:Advance()
			else
				self:Error("Invalid Command")
			end
			if (string.byte(self.current) >= string.byte("0")
			and string.byte(self.current) <= string.byte("9")) or
			(string.byte(self.current) >= string.byte("A")
			and string.byte(self.current) <= string.byte("F")) or
			(string.byte(self.current) >= string.byte("a")
			and string.byte(self.current) <= string.byte("f"))then
				self:InsertToken(self.current)
			else
				self:Error("Invalid Command")
			end
		else
			self:InsertToken(self.current)
		end
	elseif self.current == "\\" then
		self:InsertToken("\\")
	elseif self.current == '"' then
		self:InsertToken('"')
	elseif self.current == "'" then
		self:InsertToken("'")
	elseif self.current == "n" then
		self:Advance()
		return true
	elseif self.current == "r" then
		self:Advance()
		return true
	elseif self.current == "t" then
		self:Advance()
		return true
	else
		self:Error("Invalid Command")
	end
	self:Advance()
	self:Emit("TK_COMMAND",self:Flush())
	return true
end
function Lexer:Identifier()
	if self:Alphabetic() then
		while true do
			if self:Alphabetic() or self:Numeric() or self.current == "$" then
				self:InsertToken(self.current)
				self:Advance()
			else
				break
			end
		end
		local text = self:Flush()
		local upper = string.upper(text)
		if KeyWordsTokens["TK_"..upper] then
			self:Emit("TK_KEYWORD", upper, text)
		else
			self:Emit("TK_ID", text)
		end
		return true
	end

	if self.current == "[" then
		self:Advance()
		while true do
			if self:EOF() then
				self:Error("Unterminated bracketed identifier")
			end
			if self.current == "]" then
				self:Advance()
				break
			end
			self:InsertToken(self.current)
			self:Advance()
		end
		self:Emit("TK_ID", self:Flush())
		return true
	end

	if self.current == '"' then
		self:Advance()
		while true do
			if self:EOF() then
				self:Error("Unterminated double‑quoted identifier")
			end
			if self.current == '"' then
				if self.next == '"' then
					self:InsertToken('"')
					self:Advance()
					self:Advance()
				else
					self:Advance()
					break
				end
			else
				self:InsertToken(self.current)
				self:Advance()
			end
		end
		self:Emit("TK_ID", self:Flush())
		return true
	end

	if self.current == '`' then
		self:Advance()
		while true do
			if self:EOF() then
				self:Error("Unterminated grave‑accent identifier")
			end
			if self.current == '`' then
				if self.next == '`' then
					self:InsertToken('`')
					self:Advance()
					self:Advance()
				else
					self:Advance()
					break
				end
			else
				self:InsertToken(self.current)
				self:Advance()
			end
		end
		self:Emit("TK_ID", self:Flush())
		return true
	end

	return false
end
function Lexer:Variable()
	if self.current == "?" then
		self:InsertToken(self.current)
		self:Advance()
		while self:Numeric() do
			self:InsertToken(self.current)
			self:Advance()
		end
		self:Emit("TK_VAR", self:Flush())
		return true
	end

	local prefix = self.current
	if prefix ~= "$" and prefix ~= "@" and prefix ~= ":" then
		return false
	end

	self:InsertToken(prefix)
	self:Advance()

	local hasName = false
	while true do
		if self:EOF() then break end
		if self:Alphabetic() or self:Numeric() or self.current == "$" then
			self:InsertToken(self.current)
			self:Advance()
			hasName = true
		elseif self.current == ":" and self.next == ":" then
			self:InsertToken(":")
			self:InsertToken(":")
			self:Advance()
			self:Advance()
			hasName = true
		else
			break
		end
	end

	if not hasName then
		self:Error("Invalid variable name after '" .. prefix .. "'")
	end

	if self.current == "(" then
		self:InsertToken("(")
		self:Advance()
		local parenContent = false
		while not self:EOF() and self.current ~= ")" do
			if self:WhiteSpace() then
				self:Error("Unexpected whitespace inside variable parentheses")
			end
			self:InsertToken(self.current)
			self:Advance()
			parenContent = true
		end
		if not parenContent then
			self:Error("Empty variable parentheses")
		end
		if self:EOF() or self.current ~= ")" then
			self:Error("Unterminated variable parentheses")
		end
		self:InsertToken(")")
		self:Advance()
	end

	self:Emit("TK_VAR", self:Flush())
	return true
end
function Lexer:Tokenize()
	while true do
	if self:EOF()==true then break end
		if self:String()~=true
		and self:Comment()~=true
		and self:SpecialCommands()~=true
		and self:Variable()~=true
		and self:Hexadecimal()~=true
		and self:Blob()~=true
		and self:Number()~=true
		and self:Keyword()~=true
		and self:Operator()~=true
		and self:JumpWhiteSpace()~=true then
			self:Error("Unexpected character")
		end
	end
	self:Emit("TK_EOF")
	return self.tokens
end
return Lexer