----* Yanzari's Mo Poly
---* A Hud Library.
---* By Yanzari
local Lib = {}
local huds = {}

----~ Adds a custom HUD.
--^ returns a hud_t
Lib:Add = function(custom,hud,func)
if (huds[hud] and huds[hud][custom]) then return end
huds[hud] = huds[hud] or {}
huds[hud][custom] = {func = func,enabled = true}
addHook("HUD",function(...)
if huds[hud][custom] ~= nil
if huds[hud][custom].enabled == true
func(...)
end
end,hud)
return huds[hud][custom]
end

----~ Disable a custom HUD.
--^ returns nil
Lib:Disable = function(custom,hud)
if not (huds[hud] and huds[hud][custom]) then return end
huds[hud][custom].enabled = false
end

----~ Enable a custom HUD.
--^ returns nil
Lib:Enable = function(custom,hud)
if not (huds[hud] and huds[hud][custom]) then return end
huds[hud][custom].enabled = true
end

----~ Returns whether Custom HUD is enabled.
--^ returns boolean
Lib:Enabled = function(custom,hud)
if not (huds[hud] and huds[hud][custom]) then return false end
return huds[hud][custom].enabled
end

----~ Remove a custom HUD.
--^ returns nil
Lib:Delete = function(custom,hud)
if not (huds[hud] and huds[hud][custom]) then return end
huds[hud][custom].enabled = false
huds[hud][custom] = nil
end

return Lib