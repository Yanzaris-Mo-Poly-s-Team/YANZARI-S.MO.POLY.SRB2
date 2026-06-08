-- Luau
local Vector3 = {}
local FRACUNIT = FRACUNIT or 65536
local abs = abs or math.abs
local FixedCeil = FixedCeil or math.ceil
local FixedFloor = FixedFloor or math.floor
local min = min or math.min
local max = max or math.max
local FixedSqrt = FixedSqrt or math.sqrt
local FixedInt = FixedInt or function(x)
	return x/FRACUNIT
end
local sign = function(x)
	if x==0 then
		return 0
	elseif x < 0 then
		return -1
	end
	return 1
end
local function fuzzyEq(a, b, epsilon)
	return a == b
		or abs(a - b) <= (abs(a) + 1) * epsilon
end

local function fuzzyEqVec(v1, v2, epsilon)
	return fuzzyEq(v1.X, v2.X, epsilon)
		and fuzzyEq(v1.Y, v2.Y, epsilon)
		and fuzzyEq(v1.Z, v2.Z, epsilon)
end
function Vector3.new(x,y,z)
	local meta = {}
	local self = {}
	self.X = x
	self.Y = y
	self.Z = z
	function self:GetMagnitude()
		return FixedInt(
					FixedFloor(
						FixedSqrt(
							((self.X*self.X + self.Y*self.Y + self.Z*self.Z)*FRACUNIT)
						)
					)
				)
	end
	function self:Abs()
		return Vector3.new(abs(self.X),abs(self.Y),abs(self.Z))
	end
	function self:Ceil()
		local func = FixedCeil
		return Vector3.new(func(self.X),func(self.Y),func(self.Z))
	end
	function self:Floor()
		local func = FixedFloor
		return Vector3.new(func(self.X),func(self.Y),func(self.Z))
	end
	function self:Sign()
		local func = sign
		return Vector3.new(func(self.X),func(self.Y),func(self.Z))
	end
	function self:Cross(other)
		local ay = self.Y
		local ax = self.X
		local az = self.Z
		local by = other.Y
		local bx = other.X
		local bz = other.Z
		return Vector3.new(
			ay * bz - az * by,
			az * bx - ax * bz,
			ax * by - ay * bx
		)
	end
	function self:Dot(other)
		local ay = self.Y
		local ax = self.X
		local az = self.Z
		local by = other.Y
		local bx = other.X
		local bz = other.Z
		return
			ax * bx +
			ay * by +
			az * bz
	end
	function self:FuzzyEq(other,epsilon)
		return fuzzyEqVec(self,other,epsilon)
	end
	function self:Min(other)
		local ay = self.Y
		local ax = self.X
		local az = self.Z
		local by = other.Y
		local bx = other.X
		local bz = other.Z
		return Vector3.new(
			min(ax,bx),
			min(ay,by),
			min(az,bz)
		)
	end
	function self:Max(other)
		local ay = self.Y
		local ax = self.X
		local az = self.Z
		local by = other.Y
		local bx = other.X
		local bz = other.Z
		return Vector3.new(
			max(ax,bx),
			max(ay,by),
			max(az,bz)
		)
	end
	-- Vector3 + Vector3
	function meta.__add(a,b)
		local ay = a.Y
		local ax = a.X
		local az = a.Z
		local by = b.Y
		local bx = b.X
		local bz = b.Z
		return Vector3.new(
			ax + bx,
			ay + by,
			az + bz
		)
	end
	-- Vector3 - Vector3
	function meta.__sub(a,b)
		local ay = a.Y
		local ax = a.X
		local az = a.Z
		local by = b.Y
		local bx = b.X
		local bz = b.Z
		return Vector3.new(
			ax - bx,
			ay - by,
			az - bz
		)
	end
	-- Vector3 / Vector3
	function meta.__div(a,b)
		if type(a) == "number" then
			return Vector3.new(
				a / (b.X),
				a / (b.Y),
				a / (b.Z)
			)
		elseif type(b) == "number" then
			return Vector3.new(
				(a.X) / b,
				(a.Y) / b,
				(a.Z) / b
			)
		end

		return Vector3.new(
			(a.X) / (b.X),
			(a.Y) / (b.Y),
			(a.Z) / (b.Z)
		)
	end
	-- Vector3 * Vector3
	function meta.__mul(a,b)
		if type(a) == "number" then
			return Vector3.new(
				a * (b.X),
				a * (b.Y),
				a * (b.Z)
			)
		elseif type(b) == "number" then
			return Vector3.new(
				(a.X) * b,
				(a.Y) * b,
				(a.Z) * b
			)
		end

		return Vector3.new(
			(a.X) * (b.X),
			(a.Y) * (b.Y),
			(a.Z) * (b.Z)
		)
	end
	-- Vector3 == Vector3
	function meta.__eq(a,b)
		return a.X == b.X and a.Y == b.Y and a.Z == b.Z
	end
	function meta.__unm(a)
		local ay = a.Y
		local ax = a.X
		local az = a.Z
		return Vector3.new(
			0-ax,
			0-ay,
			0-az
		)
	end
	setmetatable(self, meta)
	return self
end
return Vector3