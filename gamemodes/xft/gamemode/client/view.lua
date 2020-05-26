function GM:CalcView(pl, pos, ang, fov, znear, zfar)
	local mins, maxs = self:GetCameraHull()
	local dist       = self:GetCameraDistance()
	local view       = {
		origin       = pos,
		angles       = ang,
		fov          = fov,
		znear        = znear,
		zfar         = zfar,
		drawviewer   = true,
	}

	gamemode.Call("CustomView", pl, view)

	local rag = pl:GetRagdollEntity()

	if !pl:Alive() then
		if IsValid(rag) then
			view.origin = rag:GetBonePosition(rag:LookupBone "ValveBiped.Bip01_Head1")
		end
	end

	view.origin = util.TraceHull {
		start   = view.origin,
		endpos  = view.origin - view.angles:Forward() * dist,
		mask    = MASK_PLAYERSOLID_BRUSHONLY,
		mins    = mins,
		maxs    = maxs,
	}.HitPos

	return view
end

function GM:CustomView(pl, view)
end
