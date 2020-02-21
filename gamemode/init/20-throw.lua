local conf = {
	aim = {
		time = .25,
		seq  = 'aim',
	},
	
	throw = {
		powertime = 1,
		acttime   = .3,
		time      = .2,
		seq       = 'throw',
	},
}

---------------------------------------------------------------------------------------------------

hook.Add('CustomView', 'aim', function(pl, view)
	local time = CurTime()
	local reltime, prog, dur

	if pl:AimingItem() or pl:ThrowingItem() then
		reltime = pl:GetItemAimStart()
		dur    = time - reltime
	else
		reltime = pl:GetItemAimEnd()
		dur     = (reltime - time) + conf.aim.time
	end
	
	prog = math.Clamp(dur / conf.aim.time, 0, 1)
	
	if prog > 0 then
		local ease    = math.EaseInOut(prog, 0, 1)
		local forward = ease * 75
		local right   = ease * 16
		local up      = ease * -4
		view.origin = view.origin + view.angles:Forward() * forward + view.angles:Right() * right + view.angles:Up() * up
	end
end)

hook.Add('CustomMove', 'aim', function(pl, mv)
	if pl:AimingItem() then
		if !pl:ShouldAimItem() then
			pl:SetAimingItem(false)
			pl:SetItemAimEnd(CurTime())
			
			if !mv:KeyDown(IN_ATTACK2) then
				pl:SetThrowingItem(true)
				pl:SetItemThrowStart(CurTime())
				pl:SetItemThrowEnd(CurTime() + conf.throw.time)
			end
		else
			mv:SetMaxSpeed(SPEED_STRAFE)
		end
	else
		if pl:ShouldAimItem() then
			pl:SetAimingItem(true)
			pl:SetItemAimStart(CurTime())
		end
	end
end)

hook.Add('CustomMove', 'throw', function(pl, mv)
	if pl:ThrowingItem() then
		if !pl:ShouldThrowItem() then
			local time    = CurTime()
			local endtime = pl:GetItemThrowEnd()
			
			pl:SetThrowingItem(false)
			
			if SERVER and time >= endtime then
				pl:ThrowItem()
			end
		else
			mv:SetMaxSpeed(SPEED_STRAFE)
		end
	end
end)

hook.Add('CustomActivity', 'aim', function(pl, vel, anim)
	local seq     = pl:LookupSequence(conf.aim.seq)
	local time    = CurTime()
	local endtime = pl:GetItemAimEnd()
	local reltime, prog, dur
	
	if pl:AimingItem() then
		if anim.act == ACT_XFT_IDLE then
			anim.act = ACT_HL2MP_IDLE_ANGRY_PELVIS_LEGS
		end
	end

	if pl:AimingItem() then
		reltime = pl:GetItemAimStart()
		dur    = time - reltime
	else
		reltime = pl:GetItemAimEnd()
		dur     = (reltime - time) + conf.aim.time
	end
	
	prog = math.Clamp(dur / conf.aim.time, 0, 1)
	
	if prog > 0 then
		local weight = math.EaseInOut(prog, 0, 1)
		pl:AddVCDSequenceToGestureSlot(GESTURE_SLOT_FLINCH, seq, 0, false)
		pl:AnimSetGestureWeight(GESTURE_SLOT_FLINCH, weight)
	end
end)

hook.Add('CustomActivity', 'throw', function(pl, seq, anim)
	local time    = CurTime()
	local endtime = pl:GetItemThrowEnd()
	
	if time < endtime + conf.throw.acttime then
		if anim.act == ACT_XFT_IDLE then
			anim.act = ACT_HL2MP_IDLE_ANGRY_PELVIS_LEGS
		end
	end

	if pl:ThrowingItem() then
		if !pl:ItemThrowAnim() then
			local seq   = pl:LookupSequence(conf.throw.seq)
			local power = pl:GetItemThrowPower()
			
			pl:SetItemThrowAnim(true)
			pl:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, seq, 0, true)
			-- pl:AnimSetGestureWeight(GESTURE_SLOT_VCD, power)
		end
	else
		if pl:ItemThrowAnim() then
			pl:SetItemThrowAnim(false)
		end
	end
end)

local meta = FindMetaTable 'Player'

function meta:SetAimingItem(enable)
	self:SetNW2Bool('aiming_item', enable)
end

function meta:AimingItem()
	return self:GetNW2Bool 'aiming_item'
end

function meta:SetThrowingItem(enable)
	self:SetNW2Bool('throwing_item', enable)
end

function meta:ThrowingItem()
	return self:GetNW2Bool 'throwing_item'
end

function meta:ShouldThrowItem()
	local item    = self:GetItem()
	local time    = CurTime()
	local endtime = self:GetItemThrowEnd()

	return self:Alive() and item:IsValid() and time < endtime
end

function meta:ShouldAimItem()
	local item    = self:GetItem()
	local time    = CurTime()
	local start   = self:GetItemAimStart()
	local endtime = self:GetItemAimEnd()

	return self:Alive() and item:IsValid() and !self:Punching() and !self:ThrowingItem() and ((self:KeyDown(IN_ATTACK2) and !self:KeyDown(IN_ATTACK) and time > endtime + conf.aim.time + .125) or time < start + conf.aim.time + .125)
end

function meta:SetItemAimEnd(time)
	self:SetNW2Float('item_aim_end', time)
end

function meta:GetItemAimEnd()
	return self:GetNW2Float 'item_aim_end'
end

function meta:SetItemAimStart(time)
	self:SetNW2Float('item_aim_start', time)
end

function meta:GetItemAimStart()
	return self:GetNW2Float 'item_aim_start'
end

function meta:SetItemThrowEnd(time)
	self:SetNW2Float('item_throw_end', time)
end

function meta:GetItemThrowEnd()
	return self:GetNW2Float 'item_throw_end'
end

function meta:SetItemThrowStart(time)
	self:SetNW2Float('item_throw_start', time)
end

function meta:GetItemThrowStart()
	return self:GetNW2Float 'item_throw_start'
end

function meta:SetItemThrowAnim(enable)
	self.itemthrowanim = tobool(enable)
end

function meta:ItemThrowAnim()
	self.itemthrowanim = self.itemthrowanim or false
	return self.itemthrowanim
end

function meta:GetItemThrowPower()
	local time    = CurTime()
	local start   = self:GetItemAimStart()
	local endtime = self:GetItemAimEnd()
	
	return math.Clamp(self:AimingItem() and (time - start) / conf.throw.powertime or math.min(time - start, endtime - start) / conf.throw.powertime, 0, 1)
end

if CLIENT then return end

function meta:ThrowItem()
	local item = self:GetItem()
	
	if !item:IsValid() then return end
	
	local phys  = item:GetPhysicsObject()
	local dir   = self:GetAimVector()
	local power = self:GetItemThrowPower()
	
	self:DropItem(true, true)
	
	timer.Simple(0, function()
		if phys and phys:IsValid() then
			phys:SetVelocity(dir * item.ThrowForce * power)
		end
	end)
	
	item:OnThrow(self)
end