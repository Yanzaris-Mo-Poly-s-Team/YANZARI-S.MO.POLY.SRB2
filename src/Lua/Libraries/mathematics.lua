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