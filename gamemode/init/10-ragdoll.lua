if CLIENT then return end

local conf = {}

---------------------------------------------------------------------------------------------------

function GM:CreateEntityRagdoll(ent, rag)
	rag:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
end