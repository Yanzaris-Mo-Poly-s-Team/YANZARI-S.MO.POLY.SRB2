local lexer = require("databank/parser/lexer")
local ToStr = require("libs/tostring")
local SQL = [[
	CREATE DOMAIN name AS data_type
	CONSTRAINT constraint_name
		CHECK (expression)
	CREATE DATABASE name
]]
local tokens = lexer.new(SQL):Tokenize()
print(ToStr(tokens))