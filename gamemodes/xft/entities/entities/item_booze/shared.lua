ENT.Type        = "anim"
ENT.Base        = "item_base"
ENT.BaseClass   = baseclass.Get(ENT.Base)
ENT.Model       = "models/props_junk/garbage_glassbottle001a.mdl"
ENT.Scale       = 1.5

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	if SERVER then
		self:PrecacheGibs()
	end
end
