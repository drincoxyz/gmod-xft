local conf = {
	cooldown = 1,
}

---------------------------------------------------------------------------------------------------

hook.Add('CustomMove', 'item', function(pl, mv)
	local item = pl:GetItem()
	
	if item:IsValid() then
		local maxspeed = mv:GetMaxSpeed()
		
		mv:SetMaxSpeed(math.min(item.MaxSpeed, maxspeed))
	
		if SERVER and pl:ShouldDropItem() then
			pl:DropItem()
		end
	end
end)

-- note this is not networked automatically (must be called in a shared environment)
-- also removes the current ball entity if one exists
function GM:SetBall(ent)
	if SERVER then
		local ball = self:GetBall()
		
		if ball:IsValid() then
			ball:Remove()
		end
	end
	
	self.ball = ent
end

function GM:GetBall()
	self.ball = self.ball or NULL
	return self.ball
end

local meta = FindMetaTable 'Entity'

function meta:IsItem()
	self.isitem = self.isitem or false
	return self.isitem
end

function meta:IsBall()
	self.isball = self.isball or false
	return self.isball
end

local meta = FindMetaTable 'Player'

function meta:SetItem(ent)
	self:SetNW2Entity('item', ent)
end

function meta:GetItem()
	return self:GetNW2Entity 'item'
end

function meta:SetNextItemPickup(time)
	self:SetNW2Float('next_item_pickup', time)
end

function meta:GetNextItemPickup()
	return self:GetNW2Float 'next_item_pickup'
end

function meta:SetNextItemDrop(time)
	self:SetNW2Float('next_item_drop', time)
end

function meta:GetNextItemDrop()
	return self:GetNW2Float 'next_item_drop'
end

function meta:ShouldDropItem()
	local item = self:GetItem()
	local rag  = self:GetRagdollEntity()
	local time = CurTime()
	local drop = self:GetNextItemDrop()
	
	return item:IsValid() and !self:AimingItem() and !self:ThrowingItem() and (!self:Alive() or rag:IsValid() or (time >= drop and self:KeyDown(IN_USE)))
end

function meta:ShouldPickupItem(ent)
	local item   = self:GetItem()
	local rag    = self:GetRagdollEntity()
	local time   = CurTime()
	local pickup = self:GetNextItemPickup()
	
	return ent:IsItem() and !item:IsValid() and self:Alive() and !rag:IsValid() and time >= pickup and ent:AllowPickup(self)
end

if CLIENT then return end

function meta:PickupItem(ent)
	if !ent:IsValid() or !ent:IsItem() then return end
	
	local time   = CurTime()
	local teamid = self:Team()
	local attach = self:LookupAttachment 'anim_attachment_RH' or 0
	
	ent:SetOwner(self)
	ent:SetLastOwner(self)
	ent:SetLastTeam(teamid)
	ent:SetParent(self, attach)
	ent:SetLocalPos(ent.PosOffset)
	ent:SetLocalAngles(ent.AngOffset)
	
	self:SetItem(ent)
	self:SetNextItemDrop(time + conf.cooldown)
	
	ent:OnPickup(self)
end

function meta:DropItem(silent, novel)
	local item = self:GetItem()
	
	if !item:IsValid() then return end
	
	local time = CurTime()
	local phys = item:GetPhysicsObject()
	
	item:SetOwner(nil)
	item:SetParent(nil)
	
	self:SetItem(NULL)
	self:SetNextItemPickup(time + conf.cooldown)
	
	if phys and phys:IsValid() then
		local vel = self:GetVelocity()
		
		phys:Wake()
		
		if !novel then
			timer.Simple(0, function()
				if !item:IsValid() or !phys or !phys:IsValid() then return end
				
				phys:SetVelocity(vel)
			end)
		end
	end
	
	if !silent then
		item:OnDrop(self)
	end
end