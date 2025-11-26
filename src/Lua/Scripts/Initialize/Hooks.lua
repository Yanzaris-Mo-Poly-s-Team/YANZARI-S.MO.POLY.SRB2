----* Yanzari's Mo Poly
---* Only hook functions.
---* By Yanzari
local YMP = YanzMoPoly
local Hooks = {}

----~ activates a hook.
--^ returns nil.
function YMP:EnableHook(custom,hook)
if not hook then return end
if not custom then return end
if not (Hooks[hook][custom] and Hooks[hook][custom]) then return end
Hooks[hook][custom].enabled = true
end

----~ Returns whether the hook is enabled or not.
--^ returns boolean.
function YMP:EnabledHook(custom,hook)
if not hook then return false end
if not custom then return false end
if not (Hooks[hook][custom] and Hooks[hook][custom]) then return false end
return Hooks[hook][custom].enabled
end

----~ Disables a hook.
--^ returns nil.
function YMP:DisableHook(custom,hook)
if not hook then return end
if not custom then return end
if not (Hooks[hook][custom] and Hooks[hook][custom]) then return end
Hooks[hook][custom].enabled = false
end

----~ Delete a hook.
--^ returns nil.
function YMP:DeleteHook(custom,hook)
if not hook then return end
if not custom then return end
if not (Hooks[hook][custom] and Hooks[hook][custom]) then return end
Hooks[hook][custom] = nil
end

----~ Delete a hook.
--^ returns a hook_t.
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
return Hooks[hook][custom]
end