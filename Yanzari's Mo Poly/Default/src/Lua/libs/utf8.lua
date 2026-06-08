/* utf8
Implementation of Lua 5.3's utf8 library in pure Lua 5.2. Mainly intended for
use with OpenComputers, but can run in any Lua environment.

(The utf8.codes function is currently missing.)
*/

-- Set to true to use some functions from OpenComputers' unicode library.
-- These may behave slightly differently than those in Lua 5.3's utf8 library.
-- Leave it as false to use pure Lua implementations of all functions.
local USE_OC_UNICODE_LIB = false

local utf8 = {}

-- Source: Lua 5.3 Reference Manual, section 6.5
-- http://lua.org/manual/5.3/manual.html#pdf-utf8.charpattern
utf8.charpattern = "[\0-\x7F\xC2-\xF4][\x80-\xBF]*"

if checkArg == nil then
	-- Source: OpenComputers machine.lua
	-- http://github.com/MightyPirates/OpenComputers/blob/master-MC1.8/src/main/resources/assets/opencomputers/lua/machine.lua#L17
	local function checkArg(n, have, ...)
		have = type(have)
		local function check(want, ...)
			if not want then
				return false
			else
				return have == want or check(...)
			end
		end
		if not check(...) then
			local msg = string.format("bad argument #%d (%s expected, got %s)",
			                          n, table.concat({...}, " or "), have)
			error(msg, 3)
		end
	end
end

function utf8.codepoint(s, i, j)
	-- Check args and convert i and j to positive indices
	checkArg(1, s, "string")
	checkArg(2, i, "number", "nil")
	i = i or 1
	if i == 0 or i > #s or i < -#s then
		error("bad argument #2 to 'codepoint' (out of range)")
	end
	i = i < 0 and #s + 1 + i or i
	checkArg(3, j, "number", "nil")
	j = j or i
	if j == 0 or j > #s or j < -#s then
		error("bad argument #2 to 'codepoint' (out of range)")
	end
	j = j < 0 and #s + 1 + j or j
	
	-- Init vars used during decoding
	local subs = s:sub(i) -- Can't remove bytes after j, because the code point "inside" j needs to be fully decoded
	local points = {} -- Sequence of decoded code points
	local curpoint = -1 -- Temporary value of the code point currently being decoded
	local curlen = 1 -- Byte length of the current code point
	local bytesleft = 0 -- Number of continuation bytes left to read for this code point
	
	-- Decoding loop
	for pos, byte in ipairs(table.pack(subs:byte(1, #subs))) do
		if bytesleft == 0 then
			-- Start of new code point
			if byte < 0x80 then
				-- ASCII character, no decoding necessary
				curlen = 1
				table.insert(points, byte)
			elseif byte < 0xc0 then
				-- Out-of-place continuation byte, you shall not pass
				error("invalid UTF-8 code")
			elseif byte < 0xe0 then
				-- 2-byte code, first byte carries 5 bits
				curlen = 2
				curpoint = (byte - 0xc0) * 2^6
			elseif byte < 0xf0 then
				-- 3-byte code, first byte carries 4 bits
				curlen = 3
				curpoint = (byte - 0xe0) * 2^12
			elseif byte < 0xf5 then
				-- 4-byte code, first byte carries 3 bits
				curlen = 4
				curpoint = (byte - 0xf0) * 2^18
			else
				-- Invalid 4+-byte code, you shall not pass
				error("invalid UTF-8 code")
			end
			bytesleft = curlen - 1
		else
			-- Continuation of a multi-byte code point
			bytesleft = bytesleft - 1
			if byte < 0x80 or byte >= 0xc0 then
				-- Missing continuation byte, you shall not pass
				error("invalid UTF-8 code")
			
			end
			-- Process continuation byte
			curpoint = curpoint + (byte - 0x80) * 2^(6*bytesleft)
			
			if bytesleft == 0 then
				-- Checks and cleanup after last continuation byte
				if curpoint < 0x80
				or curlen > 2 and curpoint < 0x800
				or curlen > 3 and curpoint < 0x10000
				then
					-- Overlong encoding, you shall not pass
					error("invalid UTF-8 code")
				end
				
				table.insert(points, curpoint)
				curpoint = -1
				curlen = 1
			end
		end
	end
	return table.unpack(points)
end

if USE_OC_UNICODE_LIB then
	local unicode = require("unicode")
	utf8.char = unicode.char
	utf8.len = unicode.len
else
	-- Maps number of bytes in code to base of the start byte
	local startbytes = {
		0x00, -- 0b00000000
		0xc0, -- 0b11000000
		0xe0, -- 0b11100000
		0xf0, -- 0b11110000
	}
	
	function utf8.char(...)
		local points = {...}
		local bytes = {}
		
		for i, point in ipairs(points) do
			-- Check argument and determine number of bytes needed
			checkArg(i, point, "number")
			local nbytes
			if point < 0 or point > 0x10FFFF then
				error(("bad argument #%i to 'char' (value out of range)"):format(i))
			elseif point < 0x80 then
				nbytes = 1
			elseif point < 0x800 then
				nbytes = 2
			elseif point < 0x10000 then
				nbytes = 3
			else
				nbytes = 4
			end
			
			-- Insert start byte (which is the only byte for ASCII chars)
			table.insert(bytes, startbytes[nbytes] + math.floor(point / 2^(6*(nbytes-1))))
			-- Insert continuation bytes
			for i = nbytes-1, 1, -1 do
				point = point - math.floor(point / 2^(6*i)) * 2^(6*i)
				table.insert(bytes, 0x80 + math.floor(point / 2^(6*(i-1))))
			end
		end
		
		return string.char(table.unpack(bytes))
	end
	
	function utf8.len(s)
		local n = 0
		for match in s:gmatch(utf8.charpattern) do
			n = n + 1
		end
		return n
	end
end

function utf8.offset(s, n, i)
	checkArg(1, s, "string")
	checkArg(2, n, "number")
	checkArg(3, i, "number", "nil")
	i = i and (i < 0 and #s + 1 + i or i) or (n < 0 and #s + 1 or 1)
	if i == 0 or i > #s+1 or i < -#s then
		error("bad argument #3 to 'offset' (position out of range)")
	end
	
	local subs
	if n == 0 then
		for pstart, pend in s:gmatch("()" .. utf8.charpattern .. "()") do
			if i < pend then
				return pstart
			end
		end
		return nil
	else
		if s:byte(i) and s:byte(i) >= 0x80 and s:byte(i) < 0xc0 then
			error("initial position is a continuation byte")
		end
		
		if n > 0 then
			subs = s:sub(i)
			
			for pos in subs:gmatch("()" .. utf8.charpattern) do
				if n <= 1 then
					return i-1 + pos
				end
				n = n - 1
			end
			
			if n == 1 then
				return i + #subs
			else
				return nil
			end
		else
			subs = s:sub(1, i)
			
			local matches = {}
			
			for pos in subs:gmatch("()" .. utf8.charpattern) do
				table.insert(matches, pos)
			end
			
			if i == #s + 1 then
				table.insert(matches, "placeholder")
			end
			
			return matches[#matches + n]
		end
	end
end

return utf8