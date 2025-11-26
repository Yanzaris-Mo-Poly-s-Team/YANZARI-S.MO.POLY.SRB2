----* Yanzari's Mo Poly
---* The Module for NetGames
---* By Yanzari

local Net = {}

for i=1,32
Net[i] = {}
Net[i].player = {},
Net[i].database = {},
local db = Net[i].database
db.shield = 0,
db.rings = 0,
db.score = 0,
db.time = 0,
db.settings = {}
end

----~ Send Netgame data to other people.
--^ returns nil
Net.Send = function(player, target)
player.ymp = player.ymp or {}
player.ymp[player.skin] = player.ymp[player.skin] or {}
player.ymp[player.skin].config = player.ymp[player.skin].config or {}
player.ymp[player.skin].config[#skins[player.skin]] = player.ymp[player.skin].config[#skins[player.skin]] or {}
local ympconf = player.ymp[player.skin].config[#skins[player.skin]]
ympconf["Netgame"] = ympconf["Netgame"] or {}
ympconf["Netgame"]["Send"] = Net[#player]
ympconf["Netgame"]["Send"].player = player
ympconf["Netgame"]["Send"] = nil
return
end

return Net