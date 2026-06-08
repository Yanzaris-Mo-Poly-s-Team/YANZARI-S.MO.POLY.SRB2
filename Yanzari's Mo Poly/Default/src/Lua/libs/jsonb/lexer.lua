local TokenType = {
	["STRING"]=true,
	["NUMBER"]=true,
	["FLOAT"]=true,
	["ID"]=true,
	["OPERATOR"]=true,
	["LCB"]=true,
	["RCB"]=true,
	["LSB"]=true,
	["RSB"]=true,
	["COLON"]=true,
	["COMMA"]=true
}
local Whitespace={
	[" "]=false,
	["\t"]=false,
	["\n"]=true,
	["\r"]=true,
	["\f"]=false
}
local Lexer = {}
Lexer.__index = Lexer
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
	error("JsonB <Lexer> Error: '"..str.."' At "..self:IsEOF() and "EOS" or ("Col: "..self.col..", Line: "..self.line)..".")
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
function Lexer:BoundaryMatch(str,options)
	options = options or {left=true,right=true}
	local v0 = self.pos+#str-1
	local v1 = self.input:sub(self.pos,v0)==str
	local v2 = self.input:sub(v0 + 1,v0 + 1)
	local v3 = self.input:sub(self.pos-1,self.pos-1)
	if options.left==true and (Whitespace[v2]==true
	or v2=="" or v2==nil) then
		if options.right==true and (Whitespace[v3]==true
		or v3=="" or v3==nil) then
			return v1
		elseif options.right==false then
			return v1
		end
		return false
	elseif options.left==false then
		if options.right==true and (Whitespace[v3]==true
		or v3=="" or v3==nil) then
			return v1
		elseif options.right==false then
			return v1
		end
		return false
	end
	return false
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
function Lexer:Emit(type)
	if TokenType[type] ~= true then
		self:Error("This Type Don't Exists: "..type)
	end
	local ref = self.token
	self.token = {}
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
	self.startbuffing = nil
	return
end

-- Object
function Lexer:Object()
	if self:Match("{") then
		self:Insert()
		self:Emit("RCB")
	end
	if self:Match("}") then
		self:Insert()
		self:Emit("LCB")
	end
	return true
end

-- Array
function Lexer:Array()
	if self:Match("[") then
		self:Insert()
		self:Emit("RSB")
	end
	if self:Match("]") then
		self:Insert()
		self:Emit("LSB")
	end
	return true
end

-- Special Chars
function Lexer:SpecialChars()
	if self:Match(":") then
		self:Insert()
		self:Emit("COLON")
	end
	if self:Match(",") then
		self:Insert()
		self:Emit("COMMA")
	end
	return true
end