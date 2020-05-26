local meta = FindMetaTable "Player"

function meta:GetStatus(name)	
	for i, status in pairs(self:GetStatuses()) do
		if status:GetClass() == "status_"..name then
			return status
		end
	end
end

function meta:GetStatuses()
	local statuses = {}

	for i, child in pairs(self:GetChildren()) do
		if string.find(child:GetClass(), "status_") then
			table.insert(statuses, child)
		end
	end

	return statuses
end
