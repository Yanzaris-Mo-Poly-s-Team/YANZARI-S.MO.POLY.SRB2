----* Yanzari's Mo Poly
---* The Module for NetGames
---* By Yanzari

local Net = {}

for i=1,32
Net[i] = {}
Net[i].player = nil,
Net[i].database = {},
local db = Net[i].database
db.shield = 0,
db.rings = 0,
db.score = 0,
db.time = 0,
db.settings = {}
end

----~ Is it Netgame?
--^ returns boolean
function Net:Is()
if netgame then return true end
return false
end

----~ Send Netgame data to other people.
--^ returns nil
function Net:Send(player, target)
if not (player and player.valid and player.mo and player.mo.valid) then return end
if Net:Is()==false then return end
player.ymp = player.ymp or {}
player.ymp[player.skin] = player.ymp[player.skin] or {}
player.ymp[player.skin].config = player.ymp[player.skin].config or {}
player.ymp[player.skin].config[#skins[player.skin]] = player.ymp[player.skin].config[#skins[player.skin]] or {}
local ympconf = player.ymp[player.skin].config[#skins[player.skin]]
ympconf["Netgame"] = ympconf["Netgame"] or {}
ympconf["Netgame"]["Send"] = Net[#player]
Net[#player].player = player
ympconf["Netgame"]["Send"].player = player
if target and target.valid and target.mo and target.mo.valid
if target.ymp
if target.ymp[player.skin]
if target.ymp[player.skin].config
if target.ymp[player.skin].config[#skins[player.skin]]
local tympconf = target.ymp[player.skin].config[#skins[player.skin]]
tympconf["Netgame"] = tympconf["Netgame"] or {}
tympconf["Netgame"]["From "..player.name] = Net[#player]
tympconf["Netgame"]["From "..player.name].player = player
end
end
end
end
end
ympconf["Netgame"]["Send"] = nil
Net[#player].player = nil
return
end

return Net