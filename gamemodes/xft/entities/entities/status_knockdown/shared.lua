ENT.Type      = "anim"
ENT.Base      = "status_base"
ENT.BaseClass = baseclass.Get(ENT.Base)

function ENT:SharedInitialize()
	hook.Add("Move", self, function(status, pl, mv)
		if pl != status.Owner then return end

		mv:SetForwardSpeed(0)
		mv:SetSideSpeed(0)
		mv:SetUpSpeed(0)
		mv:SetButtons(0)

		local rag = pl:GetRagdollEntity()

		if IsValid(rag) then
			mv:SetOrigin(rag:GetPos())
			mv:SetVelocity(rag:GetVelocity())
		end

		return true
	end)
end
