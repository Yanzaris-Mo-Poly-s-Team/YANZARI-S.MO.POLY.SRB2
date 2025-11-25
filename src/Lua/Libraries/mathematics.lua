----* Yanzari's Mo Poly
---* A Mathematics Library.
---* By Yanzari
local Math = {}

----~ It simply returns the sin of "fixed".
--^ returns a fixed value
Math:FixedSin = function(fixed)
return sin(fixed/FRACUNIT)*FRACUNIT
end

----~ It simply returns the cos of "fixed".
--^ returns a fixed value
Math:FixedCos = function(fixed)
return cos(fixed/FRACUNIT)*FRACUNIT
end

----~ It simply returns the asin of "fixed".
--^ returns a fixed value
Math:FixedASin = function(fixed)
return asin(fixed/FRACUNIT)*FRACUNIT
end

----~ It simply returns the acos of "fixed".
--^ returns a fixed value
Math:FixedACos = function(fixed)
return acos(fixed/FRACUNIT)*FRACUNIT
end

----~ returns the smaller fixed value between v1 and v2.
--^ returns a fixed value
Math:FixedMin = function(v1, v2)
return min(v1/FRACUNIT,v2/FRACUNIT)*FRACUNIT
end

----~ returns the larger fixed value between v1 and v2.
--^ returns a fixed value
Math:FixedMax = function(v1, v2)
return max(v1/FRACUNIT,v2/FRACUNIT)*FRACUNIT
end

----~ returns the larger fixed value between v1 and v2.
--^ returns a fixed value
Math:FixedPow = function(v1, v2)
return max(v1/FRACUNIT,v2/FRACUNIT)*FRACUNIT
end

----~ returns the absolute value of v1
--^ returns a fixed value
Math:FixedAbs = function(v1)
return abs(v1/FRACUNIT)*FRACUNIT
end

----~ returns the sign of v1
--^ returns a fixed value
Math:FixedSign = function(v1)
local sign = 0
if v1~=nil and type(v1) == "number" and v1 >= 0
sign = 1
elseif v1~=nil and type(v1) == "number" and v1 < 0
sign = -1
end
return sign
end

----~ returns to itself
return Math