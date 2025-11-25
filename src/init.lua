----* Yanzari Mo Poly
---* Made for GitHub, Together with the Community
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

YMP.Extern = YMP.Extern or {}
YMP.Extern._Files = YMP.Extern._Files or {}
local function Alert(txt)
  print("Yanzari's Mo Poly - Log: "..txt)
  return txt
end
Alert("Starting File Loading")
local function LoadTheFiles(path,type)
  if not type then return end
  local t = nil
  if type == "Script"
    t = "Script"
  elseif type == "Library"
    t = "Library"
  elseif type == "Modules"
    t = "Modules"
  end
  if not path then return end
  local file = nil
  Alert("~/lua/"..path.." It is being loaded.")
  if t
    file = loadfile(path)
    YMP.Extern._Files[t.."-_Yanzari-_-Mo-_-Poly_-"..path] = file
    file()
  else
    return
  end
  return file
end

--* Check the Version
--# To Do

--* Load the Files
--# To Do: Separate Script, Module, and Library Files
