AddCSLuaFile()

ENT.Type  = 'anim'
ENT.Name  = '#upgrade_base'
ENT.Color = Color(255, 255, 255)

function ENT:Initialize()
	local owner = self:GetOwner()
	
	if !owner:IsValid() or !owner:IsBall() then return end
	
	self:SetParent(owner)
	self:SetLocalPos(Vector())
	self:SetLocalAngles(Angle())
	self:OnInitialize(owner)
end

function ENT:SetStartTime(time)
	self:SetNW2Float('start', time)
end

function ENT:GetStartTime()
	return self:GetNW2Float 'start'
end

function ENT:GetEndTime(time)
	return self:GetStartTime() + self:GetDuration()
end

function ENT:SetDuration(time)
	self:SetNW2Float('duration', time)
end

function ENT:GetDuration()
	return self:GetNW2Float('duration', 5)
end

function ENT:Think()
	local owner   = self:GetOwner()
	local time    = CurTime()
	local endtime = self:GetEndTime()
	
	if time >= endtime or !owner:IsValid() then
		if SERVER then
			self:Remove()
		end
		
		return
	end

	self:NextThink(CurTime())

	return self:OnThink(owner)
end

function ENT:Draw()
end

----------------------------------------------------------------------------------

function ENT:OnInitialize(ball)
end

function ENT:OnRemove()
end

function ENT:OnThink(ball)
end