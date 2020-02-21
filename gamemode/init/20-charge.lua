local conf = {
	tr = {
		mins = -Vector(14, 14, 14),
		maxs = Vector(14, 14, 14),
	}
}

conf.tr.dist = (conf.tr.maxs.x + conf.tr.maxs.y)

sound.Add({
	name   = 'charge',
	sound  = 'npc/antlion_guard/shove1.wav',
	level  = 75,
	pitch  = {-95, 105},
	volume = 1,
})

---------------------------------------------------------------------------------------------------

hook.Add('CustomMove', 'charge', function(pl, mv)
	if pl:Charging() then
		if !pl:ShouldCharge(mv) then
			pl:SetCharging(false)
			pl:SetChargeEnd(CurTime())
		elseif SERVER then
			local tr = pl:ChargeTrace()
			local vel = mv:GetVelocity()
			
			if tr.Hit then				
				if pl:Knockdown(tr.Entity, 3, 5, (vel * Vector(1.25, 1.25)) + vector_up * 300) then
					local ang = pl:GetRenderAngles()
					local data = EffectData()
					
					data:SetOrigin(tr.HitPos)
					data:SetNormal(ang:Forward())
					data:SetMagnitude(3)
				
					util.Effect('blood_spurt', data, true, true)
					pl:ViewPunch(Angle(-45, 0, 0))
					pl:EmitSound 'charge'
				end
			end
		end
	else
		if pl:ShouldCharge(mv) then
			pl:SetCharging(true)
			pl:SetChargeStart(CurTime())
		end
	end
end)

hook.Add('CustomActivity', 'charge', function(pl, vel, anim)
	if pl:Charging() then
		anim.act = ACT_HL2MP_RUN_CHARGING
	end
end)

local meta = FindMetaTable 'Player'

function meta:SetCharging(enable)
	self:SetNW2Bool('charging', enable)
end

function meta:Charging()
	return self:GetNW2Bool 'charging'
end

function meta:IsCharging()
	return self:Charging()
end

function meta:SetChargeStart(time)
	self:SetNW2Float('charge_start', time)
end

function meta:GetChargeStart()
	return self:GetNW2Float 'charge_start'
end

function meta:SetChargeEnd(time)
	self:SetNW2Float('charge_end', time)
end

function meta:GetChargeEnd()
	return self:GetNW2Float 'charge_end'
end

function meta:ChargeTrace()
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

function meta:ShouldCharge(mv)
	local vel     = mv:GetVelocity()
	local ang     = mv:GetMoveAngles()
	local rag     = self:GetRagdollEntity()
	local forward = (Angle(0, ang.y)):Forward()
	local speed   = (vel * Vector(1, 1)):Dot(forward)
	
	return self:Alive() and !rag:IsValid() and !self:KnockedDown() and !self:Recovering() and !self:LookingBehind() and self:OnGround() and speed >= SPEED_CHARGE and mv:KeyDown(IN_FORWARD)
end