----* Yanzari Mo Poly
---* Together with the Community
---* init.lua: Made to Initialize the Files
---* By Yanzari

--~ The Archive begins.

print("Loading Yanzari's Mo Poly: Made By Yanzari & Community")

if YanzMoPoly ~= nil --~ Do you already have a Yanzari's Mo Poly?
  print("Sorry: Yanzari Mo Poly is already activated, please remove this Yanzari Mo Poly.")
  return
end
rawset(_G,"YanzMoPoly",{})
local YMP = YanzMoPoly
YMP._Loaded = false
YMP._Version = "v0.1"
YMP._LoadState = 0
YMP.Constant = {}
function YMP.Constant:Add(tbl,pf)
  for k,v in pairs(tbl)
  if k and v
  if YMP.Constant[pf.."_"..string.upper(k)] then return end
  YMP.Constant[pf.."_"..string.upper(k)] = v
  end
  end
end
function YMP.Constant:Get(n)
  if not YMP.Constant[n] then return end
  return YMP.Constant[n]
end
YMP.Constant:Add({
  ["FIRE"] = BT_ATTACK
},"BT")
YMP.Constant:Add({
  ["Loading"] = 2,
  ["Loaded"] = 4
},"YMPIF")
YMP._LoadState = YMP.Constant:Get("YMPIF_LOADED")
YMP.Extern = YMP.Extern or {}
YMP.Extern._Files = YMP.Extern._Files or {}
local function Alert(txt)
  print("Yanzari's Mo Poly - Log: "..txt)
  return txt
end
Alert("Starting File Loading")

--* Check the Version
YMP._Is_Debugged_SRB2Version = false
if VERSION >= 202 and SUBVERSION >= 15
  Alert("This version is supported.")
  if debug and debug.getlocal and type(debug.getlocal) == "function"
    YMP._Is_Debugged_SRB2Version = true
  end
else
  return
end

--* Load the Files
local AddFile = function(path)
local file = loadfile(path)
YMP.Extern._Files[path] = file
file()
end
AddFile("Libraries/load.lua")
AddFile("Libraries/mathematics.lua")
AddFile("Libraries/hud.lua")
AddFile("Modules/debug.lua")
AddFile("Modules/net.lua")
YMP._Loaded = true
YMP._LoadState = YMP.Constant:Get("YMPIF_LOADED")
