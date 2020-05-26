include "shared.lua"

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:SharedInitialize()

	hook.Add("PrePlayerDraw", self, function(status, pl)
		if pl != status.Owner then return end

		return true
	end)

	hook.Add("CustomView", self, function(status, pl, view)
		if pl != status.Owner then return end

		local rag = pl:GetRagdollEntity()

		if IsValid(rag) then
			view.origin = rag:GetBonePosition(rag:LookupBone "ValveBiped.Bip01_Head1")
		end
	end)
end
