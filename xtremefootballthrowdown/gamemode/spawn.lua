GM.SpawnPoints = GM.SpawnPoints or {}

--
-- This should make EFT maps compatible by replacing the old `info_player_` spawnpoints with the
-- new `xft_player_spawn` ones and changing the team slots
--
hook.Add("OnEntityCreated", "EFTSpawnPoints", function(ent)
	local class = ent:GetClass()

	if class:find "info_player_" then
		local spawn = ents.Create "xft_player_spawn"
		
		if IsValid(spawn) then
			timer.Simple(0, function()
				spawn:SetPos(ent:GetPos())
				spawn:SetAngles(ent:GetAngles())
				spawn:SetParent(ent:GetParent())

				if class == "info_player_blue" then
					spawn:SetSlot(2)
				elseif class == "info_player_red" then
					spawn:SetSlot(1)
				end
				
				spawn:Spawn()
			end)
		end
	end
end)

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

--
-- Adds a valid spawnpoint to the list of spawnpoints.
--
function GM:AddSpawnPoint(ent)
	table.insert(self.SpawnPoints, ent)
end

--
-- Removes a spawnpoint from the list of spawnpoints.
--
function GM:RemoveSpawnPoint(ent)
	table.RemoveByValue(self.SpawnPoints, ent)
end

--
-- Returns a list of all valid spawnpoints.
--
function GM:GetSpawnPoints()
	return self.SpawnPoints
end