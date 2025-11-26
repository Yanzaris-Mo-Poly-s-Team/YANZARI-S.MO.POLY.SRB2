----* Yanzari's Mo Poly
---* Creating Classes
---* By Yanzari
local YMP = YanzMoPoly
local Classes = {}

YMP.Class = {}
function YMP.Class:Add(name)
if Classes[name] then return end
Classes[name] = {}
return Classes[name]
end

function YMP.Class:Get(name)
if not Classes[name] then return end
return Classes[name]
end

function YMP.Class:Remove(name)
if not Classes[name] then return end
Classes[name] = nil
end