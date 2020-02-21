AddCSLuaFile()

ENT.Type = 'anim'

function ENT:Touch(ent)
	local owner = self:GetOwner()
	owner:Touch(ent)
end

function ENT:Think()
	local owner = self:GetOwner()
	
	if SERVER and !owner:IsValid() then
		self:Remove()
	end
	
	self:NextThink(CurTime())
	
	return true
end

function ENT:Initialize()
	local owner = self:GetOwner()
	
	if !owner:IsValid() then
		self:Remove()
		return
	end
	
	self.Physics = owner.Physics
	self.Mass    = owner.Mass
	
	self:SetModel(owner.Model)
	self:SetParent(owner)
	self:SetLocalPos(Vector())
	self:SetLocalAngles(Angle())
	self:SetNoDraw(true)
	self:DrawShadow(false)
	
	if SERVER then
		owner.CreatePhysics(self)
		self:SetTrigger(true)
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_NEVER
end