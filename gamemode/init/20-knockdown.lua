local conf = {
	ignore   = .5,
	immunity = 3,
}

---------------------------------------------------------------------------------------------------

hook.Add('CustomMove', 'knockdown', function(pl, mv)
	if pl:KnockedDown() then
		pl:SetKnockdownTraced(pl:WaterLevel() > 0 or util.TraceHull({start = pl:GetPos(), endpos = pl:GetPos() - vector_up * 16, mask = MASK_PLAYERSOLID_BRUSHONLY, mins = pl:OBBMins() * .9, maxs = pl:OBBMaxs() * Vector(.9, .9, .25)}, pl).Hit)
		
		if !pl:ShouldKnockdown() then			
			pl:SetKnockedDown(false)
			pl:SetNextKnockdown(CurTime() + conf.immunity)
			
			if SERVER then
				pl:Recover()
			end
		else
			mv:SetMaxSpeed(0)
			mv:SetButtons(IN_DUCK)
		end
	end
end)

hook.Add('CustomActivity', 'knockdown', function(pl, vel, anim)
	local time  = CurTime()
	local start = pl:GetKnockdownStart()
	
	if pl:KnockedDown() and time > start + .1 then
		anim.seq = pl:LookupSequence 'zombie_slump_rise_01'
		pl:SetCycle(0)	
	end
end)

local meta = FindMetaTable 'Player'

function meta:SetNextKnockdownHit(time)
	self:SetNW2Float('knockdown_hit', time) 
end

function meta:GetNextKnockdownHit()
	return self:GetNW2Float 'knockdown_hit'
end

function meta:SetNextKnockdown(time)
	self:SetNW2Float('next_knockdown', time) 
end

function meta:GetNextKnockdown()
	return self:GetNW2Float 'next_knockdown'
end

function meta:SetKnockdownDuration(time)
	self:SetNW2Float('knockdown_dur', time) 
end

function meta:GetKnockdownDuration()
	return self:GetNW2Float 'knockdown_dur'
end

function meta:SetKnockdownStart(time)
	self:SetNW2Float('knockdown_start', time) 
end

function meta:GetKnockdownStart()
	return self:GetNW2Float 'knockdown_start'
end

function meta:SetKnockdownEnd(time)
	self:SetNW2Float('knockdown_end', time) 
end

function meta:GetKnockdownEnd()
	return self:GetNW2Float 'knockdown_end'
end

function meta:SetKnockdownTraced(enable)
	self.knockdowntr = tobool(enable)
end

function meta:KnockdownTraced()
	return self.knockdowntr
end

function meta:ShouldKnockdown()
	return self:Alive() and (CurTime() < self:GetKnockdownEnd() or !self:KnockdownTraced())
end

function meta:IgnoreKnockdowns()
	return CurTime() < self:GetNextKnockdownHit()
end

function meta:KnockdownImmune()
	return self:KnockedDown() or self:Recovering() or CurTime() < self:GetKnockdownEnd() + conf.immunity
end

function meta:SetKnockedDown(enable)
	self:SetNW2Bool('knocked_down', enable)
end

function meta:KnockedDown()
	return self:GetNW2Bool 'knocked_down'
end

function meta:IsKnockedDown()
	return self:KnockedDown()
end

if CLIENT then return end

function meta:Knockdown(pl, time, dmg, vel)
	local pl     = pl or self
	local time   = time or 3
	local dmg    = dmg or 0
	local vel    = vel or pl:GetVelocity()
	local ignore = pl:IgnoreKnockdowns()
	
	if ignore then return false end
	
	local immune  = pl:KnockdownImmune()
	local curtime = CurTime()
	local rag     = pl:GetRagdollEntity()
	local dmginfo = DamageInfo()
	
	dmginfo:SetAttacker(self)
	dmginfo:SetDamage(dmg)
	
	pl:TakeDamageInfo(dmginfo)
	pl:SetNextKnockdownHit(curtime + conf.ignore)
	
	if rag:IsValid() then
		local phys = rag:GetPhysicsObject()
		local mass = phys:GetMass()
		
		if phys and phys:IsValid() then
			phys:Wake()
			phys:SetVelocity(vel * mass)
		end
	else
		pl:SetVelocity(vel)
	end
	
	if immune then return true end
	
	pl:SetKnockedDown(true)
	pl:SetKnockdownStart(curtime)
	pl:SetKnockdownEnd(curtime + time)
	pl:SetKnockdownDuration(time)
	
	if !rag:IsValid() then
		timer.Simple(0, function()
			pl:CreateRagdoll()
		end)
	end
	
	return true
end