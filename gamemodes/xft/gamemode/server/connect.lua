function GM:PlayerDisconnected(pl)
	local rag = pl:GetRagdollEntity()

	if IsValid(rag) then
		rag:Remove()
	end
end
