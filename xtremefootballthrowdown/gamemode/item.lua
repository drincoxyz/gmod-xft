--
-- Functions
--

--
-- Name: GM:SetBall
-- Desc: Sets the global ball entity.
--
-- Arguments
--
-- [1] Entity - The ball.
--
function GM:SetBall(ent)
	SetGlobalEntity("xft_ball", ent)
end

--
-- Name: GM:GetBall
-- Desc: Returns the global ball entity.
--
-- Arguments
--
-- [1] Entity - The ball.
--
function GM:GetBall()
	return GetGlobalEntity "xft_ball"
end

--
-- Name: GM:SetItemPickupCooldown
-- Desc: Sets the cooldown for picking up items.
--
-- Arguments
--
-- [1] number - Cooldown time, in seconds.
--
function GM:SetItemPickupCooldown(time)
	SetGlobalFloat("xft_item_pickup_cooldown", tonumber(time))
end

--
-- Name: GM:GetItemPickupCooldown
-- Desc: Returns the cooldown for picking up items.
--
-- Returns
--
-- [1] number - Cooldown time, in seconds.
--
function GM:GetItemPickupCooldown()
	return GetGlobalFloat "xft_item_pickup_cooldown"
end

--
-- Name: GM:SetItemDropCooldown
-- Desc: Sets the cooldown for dropping items.
--
-- Arguments
--
-- [1] number - Cooldown time, in seconds.
--
function GM:SetItemDropCooldown(time)
	SetGlobalFloat("xft_item_drop_cooldown", tonumber(time))
end

--
-- Name: GM:GetItemDropCooldown
-- Desc: Returns the cooldown for dropping items.
--
-- Returns
--
-- [1] number - Cooldown time, in seconds.
--
function GM:GetItemDropCooldown()
	return GetGlobalFloat "xft_item_drop_cooldown"
end

--
-- ConVars
--

GM:SetItemPickupCooldown(CreateConVar("xft_item_pickup_cooldown", 1, FCVAR_NOTIFY + FCVAR_REPLICATED):GetFloat())
GM:SetItemDropCooldown(CreateConVar("xft_item_drop_cooldown", 1, FCVAR_NOTIFY + FCVAR_REPLICATED):GetFloat())

--
-- Callbacks
--

--
-- Name: GM:OnPlayerPickedUpItem
-- Desc: Called when a player picks up an item.
--
-- Arguments
--
-- [1] Player - Player that picked up the item.
-- [2] Entity - The item that was picked up.
--
function GM:OnPlayerPickedUpItem(pl, item)
end

--
-- Name: GM:OnPlayerDroppedItem
-- Desc: Called when a player drops an item.
--
-- Arguments
--
-- [1] Player - Player that dropped the item.
-- [2] Entity - The item that was dropped.
--
function GM:OnPlayerDroppedItem(pl, item)
end

--
-- Hooks
--

if SERVER then
	hook.Add("PlayerDeath", "xft_drop_item", function(pl)
		local item = pl:GetItem()
		
		if IsValid(item) then
			pl:DropItem()
		end
	end)

	hook.Add("OnEntityCreated", "xft_ball", function(ent)
		if ent:GetClass() == "xft_item_ball" then GAMEMODE:SetBall(ent) end
	end)

	hook.Add("Move", "xft_item_drop", function(pl, mv)
		local item = pl:GetItem()
		
		if not IsValid(item) then return end
		
		local lastPickup = pl:GetLastItemPickup()
		local time = CurTime()
		
		if time < lastPickup + GAMEMODE:GetItemDropCooldown() or not mv:KeyDown(IN_USE) then return end
		
		pl:DropItem()
	end)
end

--
-- Player
--

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
	--
	-- Name: Player:PickupItem
	-- Desc: Attempts to make the player pick up an item.
	--
	-- Arguments
	--
	-- [1] Entity - The item.
	--
	-- Returns
	--
	-- [1] boolean - Player successfully picked up the item. Can be false if the player is already carrying
	--               an item, or the item is already being carried.
	--
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

	--
	-- Name: Player:DropItem
	-- Desc: Attempts to make the player drop their current item.
	--
	-- Returns
	--
	-- [1] boolean - Player successfully dropped their item. Can be false if the player isn't carrying an item.
	--
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

--
-- Entity
--

local meta = FindMetaTable "Entity"

function meta:IsItem()
	return scripted_ents.IsBasedOn(self, "xft_item_base")
end

function meta:IsBall()
	return self:GetClass() == "xft_item_ball"
end