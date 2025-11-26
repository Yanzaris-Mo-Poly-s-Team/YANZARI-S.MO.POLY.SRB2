----* Yanzari's Mo Poly
---* Main
---* By Yanzari

--~ Load from Lua 5.4
local load = YMP.Extern._Files["Libraries/load.lua"]:load
YMP.HookPrefix = "SRB2:Yanzari.Mo.Poly.V0.01."
YMP.Persona = {}
YMP.Persona.HookPrefix = "SRB2P:Yanzari.Mo.Poly.V0.01."

function YMP:GetPlayer()
for player in players.iterate
return player
end
end

function YMP:GetServer()
return server
end

function YMP:CheckPlayer(p)
if (p and p.valid and p.mo and p.mo.valid) then
return true
end
return false
end

YMP:AddHook(YMP.HookPrefix.."Player.Config","ThinkFrame",function()
local player = YMP:GetPlayer()
if YMP:CheckPlayer(p)==false then return end
player.ymp = player.ymp or {}
player.ymp[player.skin] = player.ymp[player.skin] or {}
player.ymp[player.skin].config = player.ymp[player.skin].config or {}
player.ymp[player.skin].config[#skins[player.skin]] = player.ymp[player.skin].config[#skins[player.skin]] or {}
end)