--
-- This isn't an item, it's used by items to work around the issue of two triggers not being able
-- to touch each other
--

AddCSLuaFile()

ENT.Type = "anim"

function ENT:Initialize()
	local owner = self:GetOwner()
	
	if not IsValid(owner) then
		return timer.Simple(0, function()
			self:Remove()
		end)
	end
	
	self:SetPos(owner:GetPos())
	self:SetAngles(owner:GetAngles())
	self:SetParent(owner)
	self:SetModel(owner:GetModel())
	self:SetNoDraw(true)
	self:DrawShadow(false)
	self.Physics = owner.Physics
	
	if SERVER then
		owner.BuildPhysics(self)
		self:SetTrigger(true)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	end
end

function ENT:Think()
	if SERVER and not IsValid(self:GetOwner()) then
		self:Remove()
	end
	
	self:NextThink(CurTime())
	
	return true
end

function ENT:Touch(ent)
	self:GetOwner():Touch(ent)
end