include      "shared.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

function ENT:Initialize()
	self:SharedInitialize()
end
