local DataBase = {}
local Cursor = {}
local Lexer = require("lexer.lua")
Cursor.__index = Cursor
function DataBase.Cursor(path)
	local self = setmetatable({},Cursor)
	return self
end
function Cursor:Execute(arg1,arg2)
	local numofreplaces = 0
	for k,v in ipairs(arg2) do
		v = v:gsub("'", "''")
		numofreplaces = numofreplaces + 1
	end
	local tokens = Lexer.New(arg1):Tokenize()
	local thisreplace = 1
	for k,v in ipairs(tokens) do
		if v.token == 6
		and v.text == "?"
		and numofreplaces ~= 0 then
			v = arg2[thisreplace]
			numofreplaces = numofreplaces - 1
			thisreplace = thisreplace + 1
		end
		continue
	end
	return
end
return DataBase