---------------
-- Variables --
---------------

GM.SpawnPoints = GM.SpawnPoints or {}

---------------
-- Functions --
---------------

function GM:PlayerInitialSpawn(pl)
	pl:SetTeam(TEAM_SPECTATE)
	pl:SetCustomCollisionCheck(true)
end

function GM:PlayerSpawn(pl)
	local id = pl:Team()
	local mdl = player_manager.TranslatePlayerModel(pl:GetInfo "cl_playermodel")
	local maxSpeed = cvars.Number "xft_max_speed"
	local col = team.GetColor(id)
	
	pl:SetJumpPower(200)
	pl:SetCanWalk(false)
	pl:AllowFlashlight(false)
	pl:SetModel(mdl)
	pl:SetPlayerColor(col:ToVector())
	
	if id == TEAM_SPECTATE then
		pl:Spectate(OBS_MODE_ROAMING)
	else
		local spawns = {}
		local slot = self:GetTeamSlot(id)
		
		for i, spawn in pairs(self:GetSpawnPoints()) do
			if spawn:GetSlot() == slot then
				table.insert(spawns, spawn)
			end
		end
		
		local spawn = spawns[math.random(#spawns)]
		
		pl:UnSpectate()
		
		if IsValid(spawn) then
			pl:SetPos(spawn:GetPos())
			pl:SetEyeAngles(spawn:GetAngles())
		end
	end
end

function GM:AddSpawnPoint(ent)
	table.insert(self.SpawnPoints, ent)
end

function GM:RemoveSpawnPoint(ent)
	table.RemoveByValue(self.SpawnPoints, ent)
end

function GM:GetSpawnPoints()
	return self.SpawnPoints
end