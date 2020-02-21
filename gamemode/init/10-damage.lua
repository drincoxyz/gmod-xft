if CLIENT then return end

local conf = {
	regen = {
		cooldown = CreateConVar('xft_health_regen_cooldown', 5, FCVAR_REPLICATED + FCVAR_NOTIFY, 'delay before regenerating health again'):GetFloat(),
		amount   = 1,
		interval = .1,
	},
}

cvars.RemoveChangeCallback('xft_health_regen_cooldown', 'default')
cvars.AddChangeCallback('xft_health_regen_cooldown', function(cvar, old, new)
	conf.regen.cooldown = tonumber(new)
end, 'default')

---------------------------------------------------------------------------------------------------

function GM:EntityTakeDamage(ent, dmg)
	if ent:IsPlayer() then
		local timerid = ent:UserID()..'hpregen'
		
		timer.Create(timerid, conf.regen.cooldown, 1, function()
			if !ent:IsValid() or !ent:Alive() then return end
			
			local hp, maxhp = ent:Health(), ent:GetMaxHealth()
			
			if hp >= maxhp then return end
			
			timer.Create(timerid, conf.regen.interval, 0, function()
				if !ent:IsValid() or !ent:Alive() then return end
				
				local hp, maxhp = ent:Health(), ent:GetMaxHealth()
				
				if hp >= maxhp then
					timer.Remove(timerid)
				end
				
				ent:SetHealth(math.Clamp(hp + conf.regen.amount, 0, maxhp))
			end)
		end)
	end
end