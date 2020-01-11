-------------
-- ConVars --
-------------

CreateConVar("xft_item_pickup_cooldown", 1, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_item_drop_cooldown", 1, FCVAR_NOTIFY + FCVAR_REPLICATED)

---------------
-- Callbacks --
---------------

function GM:OnPlayerPickedUpItem(pl, item)
end

function GM:OnPlayerDroppedItem(pl, item)
end

-----------
-- Hooks --
-----------

--
-- This will declare the ball to the gamemode
--
hook.Add("OnEntityCreated", "XFTBall", function(ent)
	if ent:GetClass() == "xft_item_ball" then GAMEMODE.Ball = ent end
end)

if SERVER then
	--
	-- This allows the player to drop their item
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

------------
-- Player --
------------

local meta = FindMetaTable "Player"

function meta:SetLastItemDrop(time)
	self:SetNW2Float("LastItemDrop", time)
end

function meta:GetLastItemDrop()
	return self:GetNW2Float "LastItemDrop"
end

function meta:SetLastItemPickup(time)
	self:SetNW2Float("LastItemPickup", time)
end

function meta:GetLastItemPickup()
	return self:GetNW2Float "LastItemPickup"
end

function meta:SetItem(ent)
	self:SetNW2Entity("Item", ent)
end

function meta:GetItem()
	return self:GetNW2Entity "Item"
end

if SERVER then
	function meta:PickupItem(ent)
		local item = self:GetItem()
		
		if IsValid(item) then return false end
	
		local owner = ent:GetOwner()
		
		if IsValid(owner) then return false end
		
		ent:SetOwner(self)
		ent:SetLastOwner(self)
		ent:SetParent(self, self:LookupAttachment(ent.Attachment))
		ent:SetLocalPos(ent.PosOffset)
		ent:SetLocalAngles(ent.AngOffset)
		
		self:SetItem(ent)
		self:SetLastItemPickup(CurTime())
		
		gamemode.Call("OnPlayerPickedUpItem", self, ent)
		
		return true
	end

	function meta:DropItem()
		local item = self:GetItem()
		
		if not IsValid(item) then return false end
		
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
		
		gamemode.Call("OnPlayerDroppedItem", self, item)
		
		return true
	end
end