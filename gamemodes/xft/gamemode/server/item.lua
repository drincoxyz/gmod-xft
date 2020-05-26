local meta = FindMetaTable "Player"

function meta:PickupItem(item)
	if CurTime() < self:GetNextItemPickup() or IsValid(self:GetItem()) or !IsValid(item) or !string.find(item:GetClass(), "item_") then return false end

	item:SetOwner(self)
	item:SetParent(self, self:LookupAttachment "anim_attachment_RH")
	item:SetLocalPos(item.HoldPos)
	item:SetLocalAngles(item.HoldAng)

	self:SetItem(item)
	self:SetNextItemDrop(CurTime() + .5)

	local phys = item:GetPhysicsObject()

	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	return true
end

function meta:DropItem()
	if CurTime() < self:GetNextItemDrop() then return false end

	local item = self:GetItem()

	if !IsValid(item) then return false end

	local pos, ang = item:GetPos(), item:GetAngles()

	item:SetOwner()
	item:SetParent()
	
	self:SetItem()
	self:SetNextItemPickup(CurTime() + .5)

	local phys = item:GetPhysicsObject()

	if IsValid(phys) then
		phys:SetPos(pos)
		phys:SetAngles(ang)
		phys:EnableMotion(true)
		phys:Wake()
		phys:SetVelocity(self:GetVelocity())
	end

	return true
end
