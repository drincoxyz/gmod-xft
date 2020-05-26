ENT.Type      = "anim"
ENT.Base      = "status_base"
ENT.BaseClass = baseclass.Get(ENT.Base)

function ENT:SharedInitialize()
	self.Owner:SetDSP(16)

	hook.Add("CustomMove", self, function(status, pl, mv)
		if pl != status.Owner then return end

		local fac = self:GetDrunkFactor()

		mv:SetMoveAngles(mv:GetMoveAngles() + Angle(0, TimedCos(.125, 0, 60, 0)*fac, 0))
	end)
end

function ENT:Think()
	local override = self.BaseClass.Think(self)

	if self:GetTimeLeft() < 2 and !self.m_bResetDSP then
		self.Owner:SetDSP(0)
		self.m_bResetDSP = true
	end

	return override
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	if !IsValid(self.Owner) then return end

	self.Owner:SetDSP(0)
end

function ENT:GetDrunkFactor()
	local elapsed = self:GetElapsedTime()
	local dur     = self:GetDuration()
	return math.EaseInOut(math.Clamp(elapsed / 2, 0, 1), 1, 1) - math.EaseInOut(math.Clamp(((elapsed - dur) / 4) + 1, 0, 1), 1, 1)
end
