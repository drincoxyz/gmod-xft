---------------
-- Functions --
---------------

function GM:GetFallDamage(pl, speed)
	local pos = pl:GetPos()
	local vel = pl:GetVelocity()
	local mag = math.Clamp(speed * .001, .25, 1)
	local mins, maxs = pl:GetCollisionBounds()
	local tr = util.TraceHull {
		start = pos,
		endpos = pos - vector_up * maxs.z,
		filter = pl,
		mins = mins,
		maxs = maxs,
		mask = MASK_PLAYERSOLID_BRUSHONLY,
	}
	
	pl:SetVelocity(vel - vel * mag * Vector(1.25, 1.25, 0))
	
	if tr.Hit then
		local effect = EffectData()
		local filter = RecipientFilter()
		
		effect:SetOrigin(pos)
		effect:SetMagnitude(mag)
		effect:SetNormal(tr.HitNormal)
		effect:SetSurfaceProp(tr.SurfaceProps)
		
		util.Effect("xft_land", effect, true, true)
	end

	pl:ViewPunch(Angle(math.min(speed * .0125, 45), 0, 0))

	return 0
end