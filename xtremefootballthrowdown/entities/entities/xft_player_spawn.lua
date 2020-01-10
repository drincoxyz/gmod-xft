ENT.Type = "point"
ENT.Slot = 0

function ENT:Initialize()
	GAMEMODE:AddSpawnPoint(self)
end

function ENT:OnRemove()
	GAMEMODE:RemoveSpawnPoint(self)
end

--
-- Returns the team that owns this spawnpoint.
--
function ENT:GetTeam()
	return cvars.Number "xft_team_"..self:GetSlot()
end

--
-- Returns the team slot of this spawnpoint.
--
function ENT:GetSlot()
	return self.Slot
end

--
-- Sets the team slot of this spawnpoint.
--
function ENT:SetSlot(slot)
	self.Slot = math.floor(tonumber(slot))
end