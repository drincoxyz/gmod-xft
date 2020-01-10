AddCSLuaFile()

ENT.Type = "anim"

function ENT:Initialize()
	self:SetModel(self:GetBrushModel())
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	
	if SERVER then
		self:SetTrigger(true)
	else
		self:SetRenderBounds(self:GetCollisionBounds())
	end
	
	GAMEMODE:AddGoal(self)
end

function ENT:OnRemove()
	GAMEMODE:RemoveGoal(self)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:Touch(ent)
	print(ent)
end

function ENT:Draw()

end

--
-- Returns the team that owns this goal
--
function ENT:GetTeam()
	return cvars.Number "xft_team_"..self:GetSlot()
end

--
-- Returns the team slot of this goal
--
function ENT:GetSlot()
	return self:GetNW2Int "Slot"
end

--
-- Sets the team slot of this goal
--
function ENT:SetSlot(slot)
	self:SetNW2Int("Slot", slot)
end

--
-- Sets the brush model of this goal
--
function ENT:SetBrushModel(mdl)
	self:SetNW2String("BrushModel", mdl)
end

--
-- Returns the brush model of this goal
--
function ENT:GetBrushModel()
	return self:GetNW2String "BrushModel"
end