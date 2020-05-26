local meta = FindMetaTable "Player"

function meta:GetRagdollEntity()
	return self:GetNW2Entity "m_eRagdoll"
end
