local conf = {
	seq  = 'look_behind',
	time = .175,
}

---------------------------------------------------------------------------------------------------

hook.Add('CustomMove', 'look_behind', function(pl, mv)
	if pl:LookingBehind() then
		if !pl:ShouldLookBehind(mv) then
			pl:SetLookingBehind(false)
			pl:SetLookBehindEnd(CurTime())
		end
	else
		if pl:ShouldLookBehind(mv) then
			pl:SetLookingBehind(true)
			pl:SetLookBehindStart(CurTime())
		end
	end
end)

hook.Add('CustomView', 'look_behind', function(pl, view)
	local time = CurTime()
	local reltime, prog, dur

	if pl:LookingBehind() then
		reltime = pl:GetLookBehindStart()
		dur    = time - reltime
	else
		reltime = pl:GetLookBehindEnd()
		dur     = (reltime - time) + conf.time
	end
	
	prog = math.Clamp(dur / conf.time, 0, 1)
	
	if prog > 0 then
		local yaw = math.EaseInOut(prog, 0, 1) * prog * -179.99
		view.angles:RotateAroundAxis(Vector(0, 0, 1), yaw)
	end
end)

hook.Add('CustomActivity', 'look_behind', function(pl, vel, anim)
	local seq  = pl:LookupSequence(conf.seq)
	local time = CurTime()
	local reltime, prog, dur

	if pl:LookingBehind() then
		reltime = pl:GetLookBehindStart()
		dur     = time - reltime
	else
		reltime = pl:GetLookBehindEnd()
		dur     = (reltime - time) + conf.time
	end
	
	prog = math.Clamp(dur / conf.time, 0, 1)
	
	if prog > 0 then
		local weight = math.EaseInOut(prog, 0, 1)
		pl:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, seq, 0, true)
		pl:AnimSetGestureWeight(GESTURE_SLOT_CUSTOM, weight)
	end
end)

local meta = FindMetaTable 'Player'

function meta:SetLookBehindStart(time)
	self:SetNW2Float('look_behind_start', time)
end

function meta:GetLookBehindStart()
	return self:GetNW2Float 'look_behind_start'
end

function meta:SetLookBehindEnd(time)
	self:SetNW2Float('look_behind_end', time)
end

function meta:GetLookBehindEnd()
	return self:GetNW2Float 'look_behind_end'
end

function meta:SetLookingBehind(enable)
	self:SetNW2Bool('looking_behind', enable)
end

function meta:LookingBehind()
	return self:GetNW2Bool 'looking_behind'
end

function meta:IsLookingBehind()
	return self:LookingBehind()
end

function meta:ShouldLookBehind(mv)
	local rag     = self:GetRagdollEntity()
	local vel     = mv:GetVelocity()
	local ang     = mv:GetMoveAngles()
	local forward = (Angle(0, ang.y)):Forward()
	local speed   = (vel * Vector(1, 1)):Dot(forward)
	
	return !rag:IsValid() and self:Alive() and !self:Punching() and !self:ThrowingItem() and !self:AimingItem() and (mv:KeyDown(IN_RELOAD) or CurTime() < self:GetLookBehindStart() + conf.time * 2)
end