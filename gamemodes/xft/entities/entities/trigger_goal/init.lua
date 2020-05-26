include      "shared.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

function ENT:KeyValue(k, v)
	if k == "model" then
		self:SetBrushModel(v)
	elseif k == "teamid" then
		self:SetTeam(v)
	elseif k == "points" then
		self:SetPoints(v)
	end
end

function ENT:Initialize()
	self:SharedInitialize()
	self:SetTrigger(true)
end
