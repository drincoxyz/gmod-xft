local conf = {
	respawn = CreateConVar('xft_respawn_time', 5, FCVAR_REPLICATED + FCVAR_NOTIFY, 'delay before respawning'):GetFloat(),
}

cvars.RemoveChangeCallback('xft_respawn_time', 'default')
cvars.AddChangeCallback('xft_respawn_time', function(cvar, old, new)
	conf.respawn   = tonumber(new)
	conf.fade.hold = tonumber(new) - conf.fade.delay
end, 'default')

---------------------------------------------------------------------------------------------------

function GM:PlayerDeathSound()
	return true
end

function GM:CanPlayerSuicide(pl)
	return !pl:Spectating()
end

function GM:DoPlayerDeath(pl, attacker, dmg)
	local rag = pl:GetRagdollEntity()
	
	pl:AddDeaths(1)
	
	if !rag:IsValid() then
		pl:CreateRagdoll()
	end
end

function GM:PostPlayerDeath(pl)
	local time = CurTime()

	pl:SetNextRespawn(time + conf.respawn)
end

function GM:PlayerDeathThink(pl)
	local time    = CurTime()
	local respawn = pl:GetNextRespawn()
	
	if time >= respawn then
		local rag = pl:GetRagdollEntity()
		
		if rag:IsValid() then
			rag:Remove()
		else
			pl:Spawn()
		end
	end

	return false
end