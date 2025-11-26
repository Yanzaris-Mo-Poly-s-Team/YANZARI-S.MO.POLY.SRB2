----* Yanzari's Mo Poly
---* Main
---* By Yanzari

--~ Load from Lua 5.4
local load = YMP.Extern._Files["Libraries/load.lua"]:load
YMP.HookPrefix = "SRB2:Yanzari.Mo.Poly.V0.01."
if srb2p
YMP.Persona = {}
YMP.Persona.HookPrefix = "SRB2P:Yanzari.Mo.Poly.V0.01."
end

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

/*
YMP:FSM(statename, skinname, {
hook = "ThinkFrame",
init = function(p,hook)
--init
end
thinker = function(p,hook)
--thinker
end
exit = function(p,hook)
--exit
end
})
*/

function YMP:FSM(stn,skn,tbl)
if not tbl then return end
if not stn then return end
if not skn then return end
addHook(tbl.hook,function(...)
local player = YMP:GetPlayer()
local checker = 0
if YMP:CheckPlayer(p)==false then return end
if skins[player.skin].name == skn
if player.mo.state == stn and checker == 0
tbl.init(player,tbl.hook)
checker = 1
end
if player.mo.state == stn and checker == 1
tbl.thinker(player,tbl.hook)
end
if player.mo.state ~= stn and checker == 1
tbl.exit(player,tbl.hook)
checker = 0
end
end
end)
end

YMP:AddHook(YMP.HookPrefix.."Player.Config","ThinkFrame",function()
local player = YMP:GetPlayer()
if YMP:CheckPlayer(p)==false then return end
player.ymp = player.ymp or {}
player.ymp[player.skin] = player.ymp[player.skin] or {}
player.ymp[player.skin].config = player.ymp[player.skin].config or {}
player.ymp[player.skin].config[#skins[player.skin]] = player.ymp[player.skin].config[#skins[player.skin]] or {}
end)