ENT.Type = "anim"

function ENT:SetupDataTables()
	self:NetworkVar("Int",   0, "Duration")
	self:NetworkVar("Float", 0, "StartTime")
	self:NetworkVar("Float", 1, "EndTime")
end

function ENT:GetElapsedTime()
	return CurTime() - self:GetStartTime()
end

function ENT:GetTimeLeft()
	return self:GetDuration() - self:GetElapsedTime()
end
