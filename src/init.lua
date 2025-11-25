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
local function LoadTheFile(path,type)
  if not type then return end
  local t = nil
  if type == "Script"
    t = "Script"
  elseif type == "Library"
    t = "Library"
  elseif type == "Module"
    t = "Module"
  end
  if not path then return end
  local file = nil
  Alert("~/lua/"..path.." It is being loaded.")
  if t
    file = loadfile(path)
    YMP.Extern._Files[t.."_-YMP-_"..path] = file
    file()
  else
    return
  end
  return file
end

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
local Files = {
  ["Modules"] = {
    ["placeholder.lua"] = "Module",
  }
  ["Librarys"] = {
    ["placeholder.lua"] = "Library",
  }
  ["Scripts"] = {
    ["placeholder.lua"] = "Script",
  }
}
local FileLoad = function(tbl)
for dirname,dirval in pairs(tbl)
  if dirname and type(dirname) == "string"
  if dirval and type(dirval) == "table"
    FileLoad(dirname)
  elseif dirval and type(dirval) == "string"
    LoadTheFile(dirname,type)
  elseif dirval and type(dirval) ~= "string" and type(dirval) ~= "table"
    Alert("Sorry, you only define tables and strings.")
    return
  end
  end
end
end

FileLoad(Files)
YMP._Loaded = true
YMP._LoadState = YMP.Constant:Get("YMPIF_LOADED")
