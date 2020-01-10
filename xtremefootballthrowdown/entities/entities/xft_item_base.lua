AddCSLuaFile()

ENT.Type       = "anim"
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
	-- Builds the item's physics object
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
end

--
-- Sets the last owner of the item
--
function ENT:SetLastOwner(ent)
	self:SetNW2Entity("LastOwner", ent)
end

--
-- Returns the last owner of the item
--
function ENT:GetLastOwner()
	return self:GetNW2Entity "LastOwner"
end

--
-- Sets the last time the item was picked up
--
function ENT:SetLastPickup(time)
	self:SetNW2Float("LastPickup", time)
end

--
-- Returns the last time the item was picked up
--
function ENT:GetLastPickup()
	return self:GetNW2Float "LastPickup"
end