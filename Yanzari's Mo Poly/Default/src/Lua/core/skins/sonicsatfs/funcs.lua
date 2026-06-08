local Sonic = {}
Sonic.Init = function(p,m)
	-- p : Player
	-- m : Mobj
	local ymp = {} -- ymp : YMPPlayer
	ymp.jump = false
	ymp.dropdash = {
		release = false,
		preparing = false
	}
	ymp.spindash = {
		releasing = 0,
		release = false,
		preparing = false
	}
	ymp.ride = false
	ymp.waiting = {
		first_frame = false,
		waiting = false
	}
	ymp.peelout = false
	ymp.powers = {
		nova = false,
		specialstage = false,
		hyper = false
	}
end
-- Kirby
if rawget(_G,"K_AddAbility") then
	local Parasol = function(checkflags, destroy, late, player)
		if(checkflags)
			if(player.kvars.ablstate)
				or(player.kvars.ablvar3)
				return AF_NOFLOAT|AF_NOSWIM|AF_NODROP|AF_NODUCK
			end
			return 0
		end
		if(destroy)
			return
		end
		if(late)
			return
		end
		print("Nothing")
	end
	K_AddAbility(Parasol, false, "YMP-PARASOL")
end
return Sonic