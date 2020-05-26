ENT.Type = "anim"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "BrushModel")
	self:NetworkVar("Int", 0, "Points")
	self:NetworkVar("Int", 1, "Team")
end

function ENT:SharedInitialize()
	self:SetModel(self:GetBrushModel())
end
