CreateConVar("xft_item_pickup_cooldown", 1, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_item_drop_cooldown", 1, FCVAR_NOTIFY + FCVAR_REPLICATED)

if SERVER then
	--
	-- Allows the player to drop their item
	--
	hook.Add("Move", "XFTItemDrop", function(pl, mv)
		local item = pl:GetItem()
		
		if not IsValid(item) then return end
		
		local lastPickup = pl:GetLastItemPickup()
		local time = CurTime()
		
		if time < lastPickup + cvars.Number "xft_item_drop_cooldown" or not mv:KeyDown(IN_USE) then return end
		
		pl:DropItem()
	end)
end

local meta = FindMetaTable "Player"

if SERVER then
	--
	-- Makes the player pick up a given item
	--
	function meta:PickupItem(ent)
		local owner = ent:GetOwner()
		
		if IsValid(owner) then return end
		
		ent:SetOwner(self)
		ent:SetLastOwner(self)
		ent:SetParent(self, self:LookupAttachment(ent.Attachment))
		ent:SetLocalPos(ent.PosOffset)
		ent:SetLocalAngles(ent.AngOffset)
		
		self:SetItem(ent)
		self:SetLastItemPickup(CurTime())
	end
	
	--
	-- Makes the player drop their item
	--
	function meta:DropItem()
		local item = self:GetItem()
		
		if not IsValid(item) then return end
		
		item:SetOwner(nil)
		item:SetParent(nil)
		
		self:SetItem(nil)
		self:SetLastItemDrop(CurTime())
		
		local vel = self:GetVelocity()
		
		timer.Simple(0, function()
			if not IsValid(self) then return end
			
			local phys = item:GetPhysicsObject()
			
			if not IsValid(phys) then return end
			
			phys:Wake()
			phys:SetVelocity(vel)
		end)
	end
end

--
-- Sets the last time the player dropped an item
--
function meta:SetLastItemDrop(time)
	self:SetNW2Float("LastItemDrop", time)
end

--
-- Returns the last time the player dropped an item
--
function meta:GetLastItemDrop()
	return self:GetNW2Float "LastItemDrop"
end

--
-- Sets the last time the player picked up an item
--
function meta:SetLastItemPickup(time)
	self:SetNW2Float("LastItemPickup", time)
end

--
-- Returns the last time the player picked up an item
--
function meta:GetLastItemPickup()
	return self:GetNW2Float "LastItemPickup"
end

--
-- Sets the item the player is carrying
--
function meta:SetItem(ent)
	self:SetNW2Entity("Item", ent)
end

--
-- Returns the item the player is carrying
--
function meta:GetItem()
	return self:GetNW2Entity "Item"
end