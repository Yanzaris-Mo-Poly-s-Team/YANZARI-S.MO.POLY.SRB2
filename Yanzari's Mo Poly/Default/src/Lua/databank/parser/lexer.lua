local Lexer = {}
Lexer.__index = Lexer
local KeyWordList = {
	NonReserved = {
		ABORT = true,
		ABSOLUTE = true,
		ACCESS = true,
		ACTION = true,
		ADD = true,
		ADMIN = true,
		AFTER = true,
		AGGREGATE = true,
		ALSO = true,
		ALTER = true,
		ALWAYS = true,
		ASSERTION = true,
		ASSIGNMENT = true,
		AT = true,
		ATTACH = true,
		ATTRIBUTE = true,
		BACKWARD = true,
		BEFORE = true,
		BEGIN = true,
		BETWEEN = true,
		BIGINT = true,
		BIT = true,
		BOOLEAN = true,
		BY = true,
		CACHE = true,
		CALL = true,
		CALLED = true,
		CASCADE = true,
		CASCADED = true,
		CATALOG = true,
		CHAIN = true,
		CHAR = true,
		CHARACTER = true,
		CHARACTERISTICS = true,
		CHECKPOINT = true,
		CLASS = true,
		CLOSE = true,
		CLUSTER = true,
		COALESCE = true,
		COLUMNS = true,
		COMMENT = true,
		COMMENTS = true,
		COMMIT = true,
		COMMITTED = true,
		CONFIGURATION = true,
		CONNECTION = true,
		CONSTRAINTS = true,
		CONTENT = true,
		CONTINUE = true,
		CONVERSION = true,
		COPY = true,
		COST = true,
		CSV = true,
		CUBE = true,
		CURRENT = true,
		CURSOR = true,
		CYCLE = true,
		DATA = true,
		DATABASE = true,
		DAY = true,
		DEALLOCATE = true,
		DEC = true,
		DECIMAL = true,
		DECLARE = true,
		DEFAULTS = true,
		DEFERRED = true,
		DEFINER = true,
		DELETE = true,
		DELIMITER = true,
		DELIMITERS = true,
		DEPENDS = true,
		DETACH = true,
		DICTIONARY = true, -- Lzma?
		DISABLE = true,
		DISCARD = true,
		DOCUMENT = true,
		DOMAIN = true,
		DOUBLE = true,
		DROP = true,
		EACH = true,
		ENABLE = true,
		ENCODING = true,
		ENCRYPTED = true,
		ENUM = true,
		ESCAPE = true,
		EVENT = true,
		EXCLUDE = true,
		EXCLUDING = true,
		EXCLUSIVE = true,
		EXECUTE = true,
		EXISTS=true,
		EXPLAIN=true,
		EXTENSION=true,
		EXTERNAL=true,
		EXTRACT=true,
		FAMILY = true,
		FILTER = true,
		FIRST=true,
		FLOAT=true,
		FOLLOWING = true,
		FORCE = true,
		FORWARD = true,
		["FUNCTION"]=true,
		["FUNCTIONS"]=true,
		GENERATED=true,
		GLOBAL=true,
		GRANTED=true,
		GREATEST=true,
		GROUPING=true,
		GROUPS=true,
		HANDLER=true,
		HEADER=true,
		HOLD=true,
		HOUR=true,
		IDENTITY=true,
		["IF"]=true,
		IMMEDIATE=true,
		IMMUTABLE=true,
		IMPLICIT=true,
		IMPORT=true,
		INCLUDE=true,
		INCLUDING=true,
		INCREMENT=true,
		INDEX=true,INDEXES=true,
		INHERIT=true,INHERITS=true,
		INLINE=true,
		INOUT=true,
		INPUT=true,
		INSENSITIVE=true,
		INSERT=true,
		INSTEAD=true,
		INT=true,INTEGER=true,
		INTERVAL=true,
		INVOKER=true,
		ISOLATION=true,
		KEY=true,
		LABEL=true,
		LANGUAGE=true,
		LARGE=true,
		LAST=true,
		LEAKPROOF=true,
		LEAST=true,
		LEVEL=true,
		LISTEN=true,
		LOAD=true,
		LOCAL=true,
		LOCATION=true,
		LOCK=true,
		LOCKED=true,
		LOGGED=true,
		MAPPING=true,
		MATCH=true,
		MATERIALIZED=true,
		MAXVALUE=true,
		METHOD=true,
		MINUTE=true,
		MINVALUE=true,
		MODE=true,
		MONTH=true,
		MOVE=true,
		NAME=true,NAMES=true,
		NATIONAL=true,
		NCHAR=true,
		NEW=true,
		NEXT=true,
		NO=true,
		NONE=true,
		NOTHING=true,
		NOTIFY=true,
		NOWAIT=true,
		NULLIF=true,
		NULLS=true,
		NUMERIC=true,
		OBJECT=true,
		["OF"]=true,
		OFF=true,
		OIDS=true,
		OLD=true,
		OPERATOR=true,
		OPTION=true,OPTIONS=true,
		ORDINALITY=true,
		OTHERS=true,
		OUT=true,
		OVER=true,
		OVERLAY=true,
		OVERRIDING=true,
		OWNED=true,
		OWNER=true,
		PARALLEL=true,
		PARSER=true,
		PARTIAL=true,
		PARTITION=true,
		PASSING=true,
		PASSWORD=true,
		PLANS=true,
		POLICY=true,
		POSITION=true,
		PRECEDING=true,
		PRECISION=true,
		PREPARE=true,PREPARED=true,
		PRESERVE=true,
		PRIOR=true,
		PRIVILEGES=true,
		PROCEDURAL=true,PROCEDURE=true,PROCEDURES=true,
		PROGRAM=true,
		PUBLICATION=true,
		QUOTE=true,
		RANGE=true,
		READ=true,
		REAL=true,
		REASSIGN=true,
		RECHECK=true,
		RECURSIVE=true,
		REF=true,
		REFERENCING=true,
		REFRESH=true,
		REINDEX=true,
		RELATIVE=true,
		RELEASE=true,
		RENAME=true,
		REPEATABLE=true,
		REPLACE=true,
		REPLICA=true,
		RESET=true,
		RESTART=true,
		RESTRICT=true,
		RETURNS=true,
		REVOKE=true,
		ROLE=true,
		ROLLBACK=true,
		ROLLUP=true,
		ROUTINE=true,
		ROUTINES=true,
		ROW=true,ROWS=true,
		RULE=true,
		SAVEPOINT=true,
		SCHEMA=true,SCHEMAS=true,
		SCROLL=true,
		SEARCH=true,
		SECOND=true,
		SECURITY=true,
		SEQUENCE=true,
		SEQUENCES=true,
		SERIALIZABLE=true,
		SERVER=true,
		SESSION=true,
		SET=true,SETOF=true,SETS=true,
		SHARE=true,
		SHOW=true,
		SIMPLE=true,
		SKIP=true,
		SMALLINT=true,
		SNAPSHOT=true,
		SQL=true,
		STABLE=true,
		STANDALONE=true,
		START=true,
		STATEMENT=true,
		STATISTICS=true,
		STDIN=true,
		STDOUT=true,
		STORAGE=true,
		STORED=true,
		STRICT=true,
		STRIP=true,
		SUBSCRIPTION=true,
		SUBSTRING=true,
		SUPPORT=true,
		SYSID=true,
		SYSTEM=true,
		TABLES=true,
		TABLESPACE=true,
		TEMP=true,TEMPLATE=true,TEMPORARY=true,
		TEXT=true,
		TIES=true,
		TIME=true,
		TIMESTAMP=true,
		TRANSACTION=true,
		TRANSFORM=true,
		TREAT=true,
		TRIGGER=true,
		TRIM=true,
		TRUNCATE=true,
		TRUSTED=true,
		TYPE=true,TYPES=true,
		UNBOUNDED=true,
		UNCOMMITTED=true,
		UNENCRYPTED=true,
		UNKNOWN=true,
		UNLISTEN=true,
		UNLOGGED=true,
		["UNTIL"]=true,
		UPDATE=true,
		VACUUM=true,
		VALID=true,
		VALIDATE=true,
		VALIDATOR=true,
		VALUE=true,
		VALUES=true,
		VARCHAR=true,
		VARYING=true,
		["VERSION"]=true,
		VIEW=true,VIEWS=true,
		VOLATILE=true,
		WHITESPACE=true,
		WITHIN=true,
		WITHOUT=true,
		WORK=true,
		WRAPPER=true,
		WRITE=true,
		YMP=true,
		YEAR=true,
		YES=true,
		ZONE=true
	},
	Reserved = {
		ALL = true,
		ANALYSE = true,
		ANALYZE = true,
		AND = true,
		ANY = true,
		ARRAY = true,
		AS = true,
		ASC = true,
		ASYMMETRIC = true,
		AUTHORIZATION = true,
		BINARY = true,
		BOTH = true,
		CASE = true,
		CAST = true,
		CHECK = true,
		COLLATE = true,
		COLLATION = true,
		COLUMN = true,
		CONCURRENTLY = true,
		CONFLICT = true,
		CONSTRAINT = true,
		COS = true, -- Extra
		CREATE = true,
		CROSS = true,
		CURRENT_CATALOG = true,
		CURRENT_DATE = true,
		CURRENT_ROLE = true,
		CURRENT_SCHEMA = true,
		CURRENT_TIME = true,
		CURRENT_TIMESTAMP = true,
		CURRENT_USER = true,
		DEFAULT = true,
		DEFERRABLE = true,
		DESC = true,
		DISTINCT = true,
		["DO"] = true,
		["ELSE"] = true,
		["END"] = true,
		["EXCEPT"] = true,
		["FALSE"]=true,
		FETCH = true,
		["FOR"]=true,
		FOREIGN=true,
		FREEZE=true,
		["FROM"]=true,
		FULL=true,
		GRANT=true,
		GROUP=true,
		HAVING=true,
		ILIKE=true,
		["IN"]=true,
		INITIALLY=true,
		INNER=true,
		INTERSECT=true,
		INTO=true,
		["IS"]=true,["ISNULL"]=true,
		JOIN=true,
		LATERAL=true,
		LEADING=true,
		LEFT=true,
		LIKE=true,
		LIMIT=true,
		LOCALTIME=true,
		LOCALTIMESTAMP=true,
		NATURAL=true,
		["NOT"]=true,
		NOTNULL=true,
		NULL=true,
		OFFSET=true,
		["ON"]=true,
		ONLY=true,
		["OR"]=true,
		["ORDER"]=true,
		OUTER=true,
		OVERLAPS=true,
		PLACING=true,
		PRIMARY=true,
		REFERENCES=true,
		RETURNING=true,
		RIGHT=true,
		SELECT=true,
		SESSION_USER=true,
		SIMILAR=true,
		SIN=true, -- Extra
		SOME=true,
		SYMMETRIC=true,
		TABLE=true,
		TABLESAMPLE=true,
		TAN=true,
		THEN=true,
		TO=true,
		TRAILING=true,
		TRUE=true,
		UNION=true,
		UNIQUE=true,
		USER=true,
		USING=true,
		VARIADIC=true,
		VERBOSE=true,
		WHEN=true,
		WHERE=true,
		WINDOW=true,
		["WITH"]=true
	}
}
local TokenType = {
	["TEXT"]=true,
	["REAL"]=true,
	["INT"]=true,
	["HEX"]=true,
	["BLOB"]=true,
	["KEYWORD"]=true,
	["ID"]=true,
	["OPERATOR"]=true,
	["VAR"]=true,
	["LP"]=true,
	["RP"]=true,
	["LB"]=true,
	["RB"]=true,
	["DOT"]=true,
	["SEMI"]=true,
	["COMMA"]=true
}
local Whitespace={
	[" "]=false,
	["\t"]=false,
	["\n"]=true,
	["\r"]=true,
	["\f"]=false,
	["\v"]=false
}
function Lexer.new(str)
	local self = setmetatable({},Lexer)
	self.input = str
	self.current = str:sub(1,1)
	self.next = str:sub(2,2)
	self.pos = 1
	self.line = 1
	self.col = 1
	self.startbuffing = nil
	self.token = {}
	self.output = {}
	self.size = #str
	return self
end
function Lexer:IsEOF()
	if self.pos > self.size then
		return true
	end
	return false
end
function Lexer:Error(str)
	error("SQL <Lexer> Error: '"..str.."' At "..self:IsEOF() and "EOS" or ("Col: "..self.col..", Line: "..self.line)..".")
	return
end
function Lexer:Advance(offset)
	offset = offset or 1
	if Whitespace[self.current]==true then
		self.pos = self.pos+offset
		self.current = self.input:sub(self.pos,self.pos)
		self.next = self.input:sub(self.pos+1,self.pos+1)
		self.line = self.line + 1
		self.col = 1
	else
		self.pos = self.pos+offset
		self.current = self.input:sub(self.pos,self.pos)
		self.next = self.input:sub(self.pos+1,self.pos+1)
		self.col = self.col + 1
	end
end
function Lexer:Peek(offset,limit)
	offset = offset or 1
	return self.input:sub(self.pos+offset,limit and self.pos+limit or self.pos+offset)
end
function Lexer:BackPeek(offset,limit)
	offset = offset or 1
	return self.input:sub(self.pos-offset,limit and self.pos-limit or self.pos-offset)
end
function Lexer:Match(str)
	return self.input:sub(self.pos,self.pos+#str-1)==str
end
function Lexer:Insert(c)
	table.insert(self.token,c or self.current)
	self.startbuffing = self.startbuffing or {
		line = self.line,
		col = self.col
	}
	return
end
function Lexer:InsertPeek(limit)
	table.insert(self.token,self.input:sub(self.pos,self.pos+limit))
	self.startbuffing = self.startbuffing or {
		line = self.line,
		col = self.col
	}
	return
end
function Lexer:Emit(type,isreserved)
	if TokenType[type] ~= true then
		self:Error("This Type Don't Exists: "..type)
	end
	local ref = self.token
	self.token = {}
	if isreserved==true then
		if ref~=nil then
			table.insert(self.output,{
				type = type,
				reserved=true,
				token = table.concat(ref),
				start = self.startbuffing
			})
		else
			table.insert(self.output,{
				type = type,
				reserved=true,
				start = self.startbuffing
			})
		end
	elseif isreserved==false then
		if ref~=nil then
			table.insert(self.output,{
				type = type,
				reserved=false,
				token = table.concat(ref),
				start = self.startbuffing
			})
		else
			table.insert(self.output,{
				type = type,
				reserved=false,
				start = self.startbuffing
			})
		end
	else
		if ref~=nil then
			table.insert(self.output,{
				type = type,
				token = table.concat(ref),
				start = self.startbuffing
			})
		else
			table.insert(self.output,{
				type = type,
				start = self.startbuffing
			})
		end
	end
	self.startbuffing = nil
	return
end
function Lexer:IsHexa()
	local valid = {
		["A"]=true,
		["B"]=true,
		["C"]=true,
		["D"]=true,
		["E"]=true,
		["F"]=true,
		["a"]=true,
		["b"]=true,
		["c"]=true,
		["d"]=true,
		["e"]=true,
		["f"]=true,
		["0"]=true,
		["1"]=true,
		["2"]=true,
		["3"]=true,
		["4"]=true,
		["5"]=true,
		["6"]=true,
		["7"]=true,
		["8"]=true,
		["9"]=true
	}
	if valid[self.current]==true then
		return true
	end
	return false
end
function Lexer:IsOctal()
	local valid = {
		["0"]=true,
		["1"]=true,
		["2"]=true,
		["3"]=true,
		["4"]=true,
		["5"]=true,
		["6"]=true,
		["7"]=true
	}
	if valid[self.current]==true then
		return true
	end
	return false
end
function Lexer:String()
	if self:Match("'") then
		self:Advance(2)
		while true do
			if self:IsEOF() then self:Error("Untermined String") end
			if self:Match("''") then
				self:Insert("'")
				self:Advance(2)
			end
			if self:Match("'") then
				self:Advance()
				break
			end
			self:Insert()
			self:Advance()
		end
		self:Emit("TEXT")
		return
	elseif self:Match("$") then
		self:Advance()
		local tag = {}
		while true do
			if self:IsEOF() then self:Error("Untermined String") end
			if self:Match("$") then
				table.insert(tag,"$")
				self:Advance()
				break
			end
			table.insert(tag,self.current)
			self:Advance()
		end
		while true do
			if self:IsEOF() then self:Error("Untermined String") end
			if self:Match("$") then
				self:Advance()
				break
			end
			self:Insert()
			self:Advance()
		end
		local tag_str = table.concat(tag)
		if self:Match(tag_str)==false then
			self:Error("Invalid Tag")
			return
		end
		self:Emit("TEXT")
		return
	elseif self:Match("E'")
	or self:Match("e'") then
		self:Advance(2)
		while true do
			if self:IsEOF() then self:Error("Untermined String") end
			if self:Match("''") then
				self:Insert("'")
				self:Advance(2)
				continue
			end
			if self:Match("'") then
				self:Advance()
				break
			end
			if self:Match("\\") then
				if self.next=="b" then
					self:Insert("\b")
					self:Advance()
				elseif self.next=="f" then
					self:Insert("\f")
					self:Advance()
				elseif self.next=="n" then
					self:Insert("\n")
					self:Advance()
				elseif self.next=="r" then
					self:Insert("\r")
					self:Advance()
				elseif self.next=="t" then
					self:Insert("\t")
					self:Advance()
				elseif self.next=="x" then
					local hexanumber = {}
					if self:IsHexa() then
						table.insert(hexanumber,self.current)
						self:Advance()
						if self:IsHexa() then
							table.insert(hexanumber,self.current)
							self:Advance()
						end
					else
						self:Error("Invalid Command")
					end
					self:Insert(tostring(tonumber(hexanumber,16)))
					self:Advance()
				else
					local hexanumber = {}
					if self:IsOctal() then
						table.insert(hexanumber,self.current)
						self:Advance()
						if self:IsOctal() then
							table.insert(hexanumber,self.current)
							self:Advance()
							if self:IsOctal() then
								table.insert(hexanumber,self.current)
								self:Advance()
							end
						end
					else
						self:Error("Invalid Command")
					end
					self:Insert(tostring(tonumber(hexanumber,8)))
					self:Advance()
				end
				continue
			end
			self:Insert()
			self:Advance()
		end
		self:Emit("TEXT")
		return
	end
end

return Lexer