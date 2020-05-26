include      "shared.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

function ENT:Initialize()
	self:SetParent(self.Owner)
	self:SetLocalPos(Vector())
	self:SetLocalAngles(Angle())
	self:SetStartTime(CurTime())
	self:SetEndTime(CurTime() + self:GetDuration())
end

function ENT:Think()
	if !IsValid(self.Owner) or !self.Owner:Alive() or (self:GetDuration() > 0 and CurTime() >= self:GetEndTime()) then
		return self:Remove()
	end

	self:NextThink(CurTime())

	return true
end
