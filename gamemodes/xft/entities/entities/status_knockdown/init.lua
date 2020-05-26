include      "shared.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:SharedInitialize()
	self.Owner:CreateRagdoll()
end

function ENT:OnRemove()
	self.BaseClass.OnRemove(self)

	if !IsValid(self.Owner) then return end

	local rag = self.Owner:GetRagdollEntity()

	if IsValid(rag) then
		rag:Remove()
	end
end
