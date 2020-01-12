ENT.Type = "brush"

function ENT:Initialize()
	self:SetModel(self:GetBrushModel())
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
end

function ENT:KeyValue(key, val)
	if key == "model" then
		self:SetBrushModel(mdl)
	end
end

function ENT:OnRemove()
end

function ENT:Touch(ent)
	if ent:IsBall() then
		ent:Reset()
	end
end

--
-- Sets the brush model of this goal
--
function ENT:SetBrushModel(mdl)
	self.BrushModel = tostring(mdl)
end

--
-- Returns the brush model of this goal
--
function ENT:GetBrushModel()
	return self.BrushModel
end