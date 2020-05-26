include "shared.lua"

function ENT:Initialize()
	self:SharedInitialize()
	self:SetRenderBounds(self:GetCollisionBounds())
end
