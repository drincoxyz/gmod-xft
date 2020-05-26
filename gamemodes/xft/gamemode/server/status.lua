local meta = FindMetaTable "Player"

function meta:ApplyStatus(name, time)
	if !scripted_ents.Get("status_"..name) then return end
	if IsValid(self:GetStatus(name)) then return end

	local status = ents.Create("status_"..name)

	if !IsValid(status) then return end

	local time = tonumber(time) or status.Duration

	status:SetOwner(self)
	status:SetDuration(time)
	status:Spawn()

	hook.Add("Think", status, function(status)
	end)

	return status
end

function meta:PurgeStatus(name)
	local status = self:GetStatus()

	if !IsValid(status) then return end
	
	status:Remove()
end
