local Uint64 = {}
Uint64.__index = Uint64

function Uint64:new(num)
	if type(num) == "string" then
		return Uint64.fromString(num)
	elseif type(num) == "number" then
		return Uint64.fromNumber(num)
	elseif type(num) == "table" and num.lo and num.hi then
		return Uint64.fromParts(num.lo, num.hi)
	else
		error("Uint64: type invalid for build")
	end
end

function Uint64.fromNumber(num)
	local lo = num & 0xFFFFFFFF
	local hi = 0
	return Uint64.fromParts(lo, hi)
end

function Uint64.fromString(s)
	s = s:gsub("^%s+", ""):gsub("%s+$", "")
	local base = 10
	if s:sub(1,2) == "0x" or s:sub(1,2) == "0X" then
		base = 16
		s = s:sub(3)
	elseif s:sub(1,1) == "0" and #s > 1 then
		base = 8
	end
	local lo = 0
	local hi = 0
	for i = 1, #s do
		local c = s:sub(i,i)
		local digit = tonumber(c, base)
		if not digit or digit >= base then
			error("Uint64.fromString: invalid char '" .. c .. "'")
		end
		lo = lo * base
		hi = hi * base
		lo = lo + digit
		if lo >= 4294967296 then
			hi = hi + math.floor(lo / 4294967296)
			lo = lo % 4294967296
		end
		hi = hi & 0xFFFFFFFF
	end
	return Uint64.fromParts(lo, hi)
end

function Uint64.fromParts(lo, hi)
	local self = setmetatable({}, Uint64)
	self.lo = lo & 0xFFFFFFFF
	self.hi = hi & 0xFFFFFFFF
	return self
end

function Uint64:toString()
	if self.hi == 0 then
		return tostring(self.lo)
	end
	local lo = self.lo
	local hi = self.hi
	local digits = {}
	while hi ~= 0 or lo >= 10 do
		local remainder
		hi, remainder = Uint64._div10(hi, lo)
		lo = remainder
		digits[#digits+1] = tostring(remainder)
	end
	digits[#digits+1] = tostring(lo)
	local result = ""
	for i = #digits, 1, -1 do
		result = result .. digits[i]
	end
	return result
end

function Uint64._div10(hi, lo)
	local qhi = math.floor(hi / 10)
	local rhi = hi % 10
	local combined = rhi * 4294967296 + lo
	local qlo = math.floor(combined / 10)
	local rlo = combined % 10
	return qhi + math.floor(qlo / 4294967296), rlo
end

function Uint64:toHex()
	return string.format("0x%08X%08X", self.hi, self.lo)
end

function Uint64:__tostring()
	return self:toString()
end

function Uint64:__add(other)
	other = Uint64:new(other)
	local lo = self.lo + other.lo
	local carry = 0
	if lo >= 4294967296 then
		lo = lo - 4294967296
		carry = 1
	end
	local hi = self.hi + other.hi + carry
	if hi >= 4294967296 then
		hi = hi - 4294967296
	end
	return Uint64.fromParts(lo, hi)
end

function Uint64:__sub(other)
	other = Uint64:new(other)
	local lo = self.lo - other.lo
	local borrow = 0
	if lo < 0 then
		lo = lo + 4294967296
		borrow = 1
	end
	local hi = self.hi - other.hi - borrow
	if hi < 0 then
		hi = hi + 4294967296
	end
	return Uint64.fromParts(lo, hi)
end

function Uint64:__mul(other)
	other = Uint64:new(other)
	local a = self.lo
	local b = self.hi
	local c = other.lo
	local d = other.hi

	local ac = a * c
	local ad = a * d
	local bc = b * c
	local bd = b * d

	local lo = ac & 0xFFFFFFFF
	local carry = math.floor(ac / 4294967296)

	lo = lo + (ad & 0xFFFFFFFF)
	carry = carry + math.floor(ad / 4294967296)
	lo = lo + (bc & 0xFFFFFFFF)
	carry = carry + math.floor(bc / 4294967296)

	lo = lo & 0xFFFFFFFF
	local hi = (bd + carry) & 0xFFFFFFFF

	return Uint64.fromParts(lo, hi)
end

function Uint64:__div(other)
	other = Uint64:new(other)
	if other:isZero() then
		error("Uint64: division by zero")
	end
	return self:_udivmod(other)
end

function Uint64:__mod(other)
	other = Uint64:new(other)
	if other:isZero() then
		error("Uint64: module by zero")
	end
	local _, rem = self:_udivmod(other)
	return rem
end

function Uint64:_udivmod(divisor)
	local dividend = self
	local quotient = Uint64.zero
	local remainder = Uint64.zero
	for i = 63, 0, -1 do
		remainder = remainder << 1
		if dividend:bit(i) == 1 then
			remainder.lo = remainder.lo | 1
		end
		if remainder >= divisor then
			remainder = remainder - divisor
			quotient = quotient | (Uint64.one << i)
		end
	end
	return quotient, remainder
end

function Uint64:__unm()
	return (Uint64.zero - self)
end

function Uint64:__eq(other)
	other = Uint64:new(other)
	return self.lo == other.lo and self.hi == other.hi
end

function Uint64:__lt(other)
	other = Uint64:new(other)
	if self.hi ~= other.hi then
		return self.hi < other.hi
	else
		return self.lo < other.lo
	end
end

function Uint64:__le(other)
	return self < other or self == other
end

function Uint64:__and(other)
	other = Uint64:new(other)
	return Uint64.fromParts(self.lo & other.lo, self.hi & other.hi)
end

function Uint64:__or(other)
	other = Uint64:new(other)
	return Uint64.fromParts(self.lo | other.lo, self.hi | other.hi)
end

function Uint64:__xor(other)
	other = Uint64:new(other)
	return Uint64.fromParts(self.lo ^^ other.lo, self.hi ^^ other.hi)
end

function Uint64:__not()
	return Uint64.fromParts(~self.lo & 0xFFFFFFFF, ~self.hi & 0xFFFFFFFF)
end

function Uint64:__shl(n)
	n = n & 0x3F
	if n == 0 then
		return self
	end
	local lo, hi
	if n < 32 then
		lo = (self.lo << n) & 0xFFFFFFFF
		hi = ((self.hi << n) | (self.lo >> (32 - n))) & 0xFFFFFFFF
	else
		lo = 0
		hi = (self.lo << (n - 32)) & 0xFFFFFFFF
	end
	return Uint64.fromParts(lo, hi)
end

function Uint64:__shr(n)
	n = n & 0x3F
	if n == 0 then
		return self
	end
	local lo, hi
	if n < 32 then
		lo = (self.lo >> n) | ((self.hi << (32 - n)) & 0xFFFFFFFF)
		hi = self.hi >> n
	else
		lo = self.hi >> (n - 32)
		hi = 0
	end
	return Uint64.fromParts(lo, hi)
end

function Uint64:bit(pos)
	pos = pos & 0x3F
	if pos < 32 then
		return (self.lo >> pos) & 1
	else
		return (self.hi >> (pos - 32)) & 1
	end
end

function Uint64:isZero()
	return self.lo == 0 and self.hi == 0
end

Uint64.zero = Uint64.fromParts(0, 0)
Uint64.one  = Uint64.fromParts(1, 0)

setmetatable(Uint64, {
	__call = function(_, ...)
		return Uint64:new(...)
	end
})

return Uint64