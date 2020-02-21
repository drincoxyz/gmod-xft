local conf = {
	duration = 1,
	
	anim = {
		cutoff = .7
	},
}

conf.anim.rate = (conf.duration)-(conf.duration-conf.anim.cutoff)

---------------------------------------------------------------------------------------------------

hook.Add('CustomMove', 'recover', function(pl, mv)
	if pl:Recovering() then
		if !pl:ShouldRecover() then
			pl:SetRecovering(false)
		else
			mv:SetMaxSpeed(0)
			mv:SetButtons(IN_DUCK)
		end
	end
end)

hook.Add('CustomActivity', 'recover', function(pl, vel, anim)
	if !pl:Recovering() then return end
	
	local time    = CurTime()
	local endtime = pl:GetRecoverEnd()
	local elapsed = time - endtime + conf.duration
	local cycle   = math.Clamp((elapsed / conf.duration) * conf.anim.rate, 0, conf.anim.cutoff)
	
	pl:SetCycle(cycle)
	anim.seq = pl:LookupSequence 'zombie_slump_rise_01'
end)

local meta = FindMetaTable 'Player'

function meta:SetRecovering(enable)
	self:SetNW2Bool('recovering', enable)
end

function meta:Recovering()
	return self:GetNW2Bool 'recovering'
end

function meta:IsRecovering()
	return self:Recovering()
end

function meta:SetRecoverEnd(time)
	self:SetNW2Float('recover_end', time)
end

function meta:GetRecoverEnd()
	return self:GetNW2Float 'recover_end'
end

function meta:ShouldRecover()
	return self:Alive() and CurTime() < self:GetRecoverEnd()
end

if CLIENT then return end

function meta:Recover()
	local rag = self:GetRagdollEntity()

	if rag:IsValid() then
		rag:Remove()
	end
	
	self:SetRecovering(true)
	self:SetRecoverEnd(CurTime() + conf.duration)
end