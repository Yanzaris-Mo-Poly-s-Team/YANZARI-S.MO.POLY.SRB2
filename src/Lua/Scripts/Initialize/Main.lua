----* Yanzari's Mo Poly
---* Some main functions
---* By Yanzari
local YMP = YanzMoPoly

local Hooks = {}
function YMP:EnableHook(custom,hook)
if not hook then return end
if not custom then return end
if not (Hooks[hook][custom] and Hooks[hook][custom]) then return end
Hooks[hook][custom].enabled = true
end

function YMP:DisableHook(custom,hook)
if not hook then return end
if not custom then return end
if not (Hooks[hook][custom] and Hooks[hook][custom]) then return end
Hooks[hook][custom].enabled = false
end

function YMP:DeleteHook(custom,hook)
if not hook then return end
if not custom then return end
if not (Hooks[hook][custom] and Hooks[hook][custom]) then return end
Hooks[hook][custom] = nil
end

function YMP:AddHook(custom,hook,func,extra)
if not hook then return end
if not custom then return end
if (Hooks[hook][custom] and Hooks[hook][custom]) then return end
if extra
Hooks[hook] = Hooks[hook] or {}
Hooks[hook][custom] = {func = func,extra = extra,enabled = true}
addHook(hook, function(...)
if Hooks[hook][custom] and Hooks[hook][custom].enabled == true
func(hook,extra,...)
end, extra)
else
Hooks[hook] = Hooks[hook] or {}
Hooks[hook][custom] = {func = func,enabled = true}
addHook(hook, function(...)
if Hooks[hook][custom] and Hooks[hook][custom].enabled == true
func(hook,...)
end)
end
end