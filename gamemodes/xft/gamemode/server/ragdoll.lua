local meta = FindMetaTable "Player"

function meta:CreateRagdoll()
	local rag = self:GetRagdollEntity()

	if IsValid(rag) then
		rag:Remove()
	end

	local rag = ents.Create "prop_ragdoll"

	if !IsValid(rag) then return end
	
	rag:SetOwner(self)
	rag:SetPos(self:GetPos())
	rag:SetModel(self:GetModel())
	rag:SetAngles(self:GetAngles())

	rag:Spawn()

	local phys = rag:GetPhysicsObject()

	if IsValid(phys) then
		phys:SetVelocity(self:GetVelocity() * 10)
		phys:EnableDrag(false)
		phys:SetDamping(0, 0)
		phys:Wake()
	end

	self:SetNW2Entity("m_eRagdoll", rag)
	
	return rag
end
