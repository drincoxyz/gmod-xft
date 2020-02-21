local meta = FindMetaTable 'Player'

function meta:Spectating()
	return self:GetObserverMode() ~= OBS_MODE_NONE
end

function meta:IsSpectating()
	return self:Spectating()
end