local lexer = require("databank/lexer.lua")
local ToString = require("libs/tostring.lua")
local tokens = lexer.New([[
	CREATE TABLE users (
		id INTEGER,
		name TEXT,
		age INTEGER,
		balance FLOAT
	);
	SELECT * from users;
	\n
	\t
	\r
	0x10FF
	X'010203040506A0FF'
	'OMG
OMG'
]]):Tokenize()
print(ToString(tokens))
print(tostring(tokens[1].token))