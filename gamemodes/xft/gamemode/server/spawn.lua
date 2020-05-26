function GM:PlayerSpawn(pl)
	local mdl = player_manager.TranslatePlayerModel(pl:GetInfo "cl_playermodel")

	pl:SetModel(mdl)

	local rag = pl:GetRagdollEntity()

	if IsValid(rag) then
		rag:Remove()
	end
end
