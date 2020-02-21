AddCSLuaFile()

ENT.Type       = 'anim'
ENT.Name       = '#item_base'
ENT.Scale      = 1
ENT.isitem     = true
ENT.Model      = Model 'models/props_junk/watermelon01.mdl'
ENT.Physics    = SOLID_VPHYSICS
ENT.MaxSpeed   = 200
ENT.Mass       = 75
ENT.ThrowForce = 1000
ENT.PosOffset  = Vector()
ENT.AngOffset  = Angle()

function ENT:CreatePhysics()
	if self.Physics == SOLID_VPHYSICS then
		self:PhysicsInit(self.Physics)
	end

	local phys = self:GetPhysicsObject()
	
	if phys and phys:IsValid() then
		phys:SetMass(self.Mass)
	end
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	self:Activate()
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetModelScale(self.Scale)
	self:SetSpawnPos(self:GetPos())
	
	if SERVER then
		self:CreatePhysics()

		local ent  = ents.Create 'trigger_item'
		local phys = self:GetPhysicsObject()

		if ent:IsValid() then
			ent:SetOwner(self)
			ent:Spawn()
		end
		
		if phys and phys:IsValid() then
			phys:EnableMotion(true)
			phys:EnableDrag(false)
			phys:SetDamping(0, 0.25)
			phys:Wake()
		end
	end
	
	self:OnInitialize()
end

function ENT:Touch(ent)
	local owner = self:GetOwner()
	
	if !owner:IsValid() and ent:IsPlayer() and ent:ShouldPickupItem(self) then
		ent:PickupItem(self)
	end
	
	self:OnTouch(ent)
end

----------------------------------------------------------

function ENT:OnInitialize()
end

function ENT:OnTouch()
end

function ENT:AllowPickup(pl)
	return true
end

function ENT:SetLastTeam(id)
	self:SetNW2Int('last_team', id)
end

function ENT:LastTeam()
	return self:GetNW2Int 'last_team'
end

function ENT:SetLastOwner(ent)
	self:SetNW2Entity('last_owner', ent)
end

function ENT:GetLastOwner()
	return self:GetNW2Entity 'last_owner'
end

function ENT:SetSpawnPos(pos)
	self:SetNW2Vector('spawn_pos', pos)
end

function ENT:GetSpawnPos()
	return self:GetNW2Vector 'spawn_pos'
end

function ENT:OnPickup(pl)
end

function ENT:OnDrop(pl)
end

function ENT:OnThrow(pl)
end