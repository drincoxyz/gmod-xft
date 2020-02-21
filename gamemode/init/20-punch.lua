local conf = {
	time     = .3,
	cooldown = .5,
	seq      = 'punch',
	acttime  = .3,
	
	sound = {
		swing = 'punch_swing',
		hit   = 'punch_hit',
	},

	tr = {
		mins = -Vector(14, 14, 14),
		maxs = Vector(14, 14, 14),
	}
}

conf.tr.dist = (conf.tr.maxs.x + conf.tr.maxs.y)

sound.Add({
	name   = 'punch_swing',
	level  = 75,
	pitch  = {95, 105},
	volume = 1,
	sound  = {
		'npc/fast_zombie/claw_miss1.wav',
		'npc/fast_zombie/claw_miss2.wav',
	},
})

sound.Add({
	name   = 'punch_hit',
	level  = 75,
	pitch  = {95, 105},
	volume = 1,
	sound  = {
		'physics/body/body_medium_impact_hard4.wav',
		'physics/body/body_medium_impact_hard5.wav',
		'physics/body/body_medium_impact_hard6.wav',
	},
})

---------------------------------------------------------------------------------------------------

hook.Add('CustomMove', 'punch', function(pl, mv)
	if pl:Punching() then
		mv:SetMaxSpeed(SPEED_STRAFE)
	
		if !pl:ShouldPunch(mv) then
			local time    = CurTime()
			local endtime = pl:GetPunchEnd()
			
			pl:SetPunching(false)
			
			if SERVER and time >= endtime then
				local tr = pl:PunchTrace()
				
				if tr.Hit then
					local ang  = pl:GetRenderAngles()
					local dir  = ang:Forward()
					local data = EffectData()
					
					data:SetOrigin(tr.HitPos)
					data:SetNormal(ang:Forward())
					data:SetMagnitude(1)
					
					util.Effect('blood_spurt', data, true, true)
					
					pl:Knockdown(tr.Entity, 2, 5, dir * 512)
					pl:ViewPunch(Angle(10, 10, 0))
					
					tr.Entity:ViewPunch(Angle(-20, 0, 0))
					tr.Entity:EmitSound(conf.sound.hit)
				end
			end
		end
	else
		if mv:KeyPressed(IN_ATTACK) and pl:CanPunch(mv) then
			pl:SetPunching(true)
			pl:SetPunchEnd(CurTime() + conf.time)
			pl:SetNextPunch(CurTime() + conf.time + conf.cooldown)
			
			if SERVER then
				pl:EmitSound(conf.sound.swing)
			end
		end
	end
end)

hook.Add('CustomActivity', 'punch', function(pl, vel, anim)
	local time    = CurTime()
	local endtime = pl:GetPunchEnd()
	
	if time < endtime + conf.acttime then
		if anim.act == ACT_XFT_IDLE then
			anim.act = ACT_HL2MP_IDLE_ANGRY_PELVIS_LEGS
		end
	end

	if pl:Punching() then
		if !pl:PunchAnim() then
			local seq = pl:LookupSequence(conf.seq)
			
			pl:SetPunchAnim(true)
			pl:AddVCDSequenceToGestureSlot(0, seq, 0, true)
		end
	else
		if pl:PunchAnim() then
			pl:SetPunchAnim(false)
		end
	end
end)

local meta = FindMetaTable 'Player'

function meta:SetPunching(enable)
	self:SetNW2Bool('punching', enable)
end

function meta:Punching()
	return self:GetNW2Bool 'punching'
end

function meta:SetPunchAnim(enable)
	self.punchanim = tobool(enable)
end

function meta:PunchAnim()
	self.punchanim = self.punchanim or false
	return self.punchanim
end

function meta:IsPunching()
	return self:Punching()
end

function meta:SetPunchEnd(time)
	self:SetNW2Float('punch_end', time)
end

function meta:GetPunchEnd()
	return self:GetNW2Float 'punch_end'
end

function meta:SetNextPunch(time)
	self:SetNW2Float('next_punch', time)
end

function meta:GetNextPunch()
	return self:GetNW2Float 'next_punch'
end

function meta:PunchTrace()
	local teamid = self:Team()
	local pos    = self:GetPos()
	local ang    = self:GetRenderAngles()
	local center = pos + self:OBBCenter()

	return util.TraceHull {
		start       = center,
		endpos      = center + ang:Forward() * conf.tr.dist,
		mins        = conf.tr.mins,
		maxs        = conf.tr.maxs,
		ignoreworld = true,
		
		filter = function(ent)
			return ent:IsValid() and ent:IsPlayer() and ent:Alive() and ent:Team() != teamid
		end,
	}
end

function meta:CanPunch(mv)
	local rag    = self:GetRagdollEntity()
	local next   = self:GetNextPunch()
	local aimend = self:GetItemAimEnd()
	local time   = CurTime()
	
	return self:Alive() and !rag:IsValid() and !self:ThrowingItem() and !self:AimingItem() and time >= next and time >= aimend + FrameTime()
end

function meta:ShouldPunch(mv)
	local time    = CurTime()
	local endtime = self:GetPunchEnd()
	local rag     = self:GetRagdollEntity()
	
	return self:Alive() and !rag:IsValid() and time < endtime
end