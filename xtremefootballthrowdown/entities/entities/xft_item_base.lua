AddCSLuaFile()

ENT.Type       = "anim"
ENT.Name       = "Base"
ENT.Model      = "models/roller.mdl"
ENT.Physics    = SOLID_VPHYSICS
ENT.Mins       = Vector(-4, -4, -4)
ENT.Maxs       = Vector(4, 4, 4)
ENT.Radius     = 8
ENT.PosOffset  = Vector()
ENT.AngOffset  = Angle()
ENT.Attachment = "anim_attachment_RH"

function ENT:Initialize()
	self:DrawShadow(true)
	self:SetModel(self.Model)
	
	if SERVER then
		self:BuildPhysics()
	end
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	
	if SERVER then
		local trig = ents.Create "xft_item_trigger"
		
		if IsValid(trig) then
			trig:SetOwner(self)
			trig:Spawn()
		end
	end
end

function ENT:Touch(ent)
	local owner = self:GetOwner()

	if IsValid(owner) or not ent:IsPlayer() or not ent:Alive() then return end
	
	local lastDrop = ent:GetLastItemDrop()
	local time = CurTime()

	if time < lastDrop + cvars.Number "xft_item_pickup_cooldown" then return end
	
	ent:PickupItem(self)
end

if SERVER then
	--
	-- Name: ENT:BuildPhysics
	-- Desc: Builds the item's physics object.
	--
	function ENT:BuildPhysics()
		if self.Physics == SOLID_VPHYSICS then
			self:PhysicsInit(SOLID_VPHYSICS)
		end
		
		local phys = self:GetPhysicsObject()
		
		if IsValid(phys) then
			phys:Wake()
		end
	end
elseif CLIENT then
	--
	-- Name: ENT:GetTranslatedName
	-- Desc: Attempts to return the translated version of the item's name.
	--
	-- Return
	--
	-- [1] string - The item's translated name.
	--
	function ENT:GetTranslatedName()
		return GAMEMODE:GetPhrase(self.Name)
	end
end

--
-- Name: ENT:SetLastOwner
-- Desc: Sets the last player to own the item.
--
-- Arguments
--
-- [1] Player - Previous owner.
--
function ENT:SetLastOwner(pl)
	self:SetNW2Entity("xft_last_owner", pl)
end

--
-- Name: ENT:GetLastOwner
-- Desc: Returns the last player to own the item.
--
-- Returns
--
-- [1] Player - Previous owner.
--
function ENT:GetLastOwner()
	return self:GetNW2Entity "xft_last_owner"
end

--
-- Name: ENT:SetLastPickup
-- Desc: Sets the last time the item was picked up.
--
-- Arguments
--
-- [1] number - Last pickup time.
--
function ENT:SetLastPickup(time)
	self:SetNW2Float("xft_last_pickup", tonumber(time))
end

--
-- Name: ENT:GetLastPickup
-- Desc: Returns the last time the item was picked up.
--
-- Returns
--
-- [1] number - Last pickup time.
--
function ENT:GetLastPickup()
	return self:GetNW2Float "xft_last_pickup"
end