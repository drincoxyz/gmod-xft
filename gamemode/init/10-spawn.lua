local conf = {}

---------------------------------------------------------------------------------------------------

function GM:PlayerSpawn(pl)
	local clmdl   = pl:GetInfo 'cl_playermodel'
	local mdl     = player_manager.TranslatePlayerModel(clmdl)
	local teamid  = pl:Team()
	local teamcol = team.GetColor(teamid)
	local teamvec = teamcol:ToVector()
	local rag     = pl:GetRagdollEntity()
	
	pl:SetModel(mdl)
	pl:SetPlayerColor(teamvec)
	pl:SetCustomCollisionCheck(true)
	pl:SetJumpPower(200)
	
	if rag:IsValid() then
		rag:Remove()
	end
	
	if teamid == TEAM_SPECTATOR then
		pl:Spectate(OBS_MODE_ROAMING)
		pl:PhysicsDestroy()
	else
		pl:UnSpectate()
		pl:DropToFloor()
	end
end

function GM:PlayerInitialSpawn(pl)
	pl:SetAnimationModel 'models/xft_anm.mdl'

	if pl:IsBot() then
		timer.Simple(.25, function()
			gamemode.Call('PlayerRequestTeam', pl, team.BestAutoJoinTeam())
		end)
	else
		pl:SetTeam(TEAM_SPECTATOR)
	end
end

local meta = FindMetaTable 'Player'

function meta:Respawning()
	return !self:Alive() and CurTime() < self:GetNextRespawn()
end

function meta:SetNextRespawn(time)
	self:SetNW2Float('next_respawn', time)
end

function meta:GetNextRespawn()
	return self:GetNW2Float 'next_respawn'
end