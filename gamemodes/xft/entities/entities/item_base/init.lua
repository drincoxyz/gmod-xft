include      "shared.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

function ENT:Touch(ent)
	if IsValid(self.Owner) or !ent:IsPlayer() or !ent:Alive() or IsValid(ent:GetItem()) or !(self.TouchPickup or ent:KeyDown(IN_USE)) then return end

	ent:PickupItem(self)
end

function ENT:Think()
	if IsValid(self.Owner) and self.Owner:KeyPressed(IN_USE) then
		self.Owner:DropItem()
	end

	self:NextThink(CurTime())

	return true
end
