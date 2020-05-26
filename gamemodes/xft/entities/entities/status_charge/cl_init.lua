include "shared.lua"

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:SharedInitialize()
end
