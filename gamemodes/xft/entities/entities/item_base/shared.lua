ENT.Type        = "anim"
ENT.Model       = "models/error.mdl"
ENT.Scale       = 1
ENT.SpawnEffect = true
ENT.StaticSpawn = true
ENT.TouchPickup = false
ENT.HoldPos     = Vector()
ENT.HoldAng     = Angle()

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetModelScale(self.Scale)

	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)

		local phys = self:GetPhysicsObject()

		if IsValid(phys) then
			phys:Wake()
			phys:EnableDrag(false)
			phys:SetDamping(0, 0)
		end

		self:SetTrigger(true)
	end

	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
end
