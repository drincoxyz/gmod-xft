local conf = {
	dist    = 100,
	padding = 8,
	
	respawn = {
		time = 1,
		fov  = 30, -- shouldn't be larger than 79 (100 is the max allowed FOV by fov_desired)
		
		fade = {
			time = 1,
		},
	}
}

conf.maxs = conf.padding * Vector(1, 1, 1)
conf.mins = -conf.maxs

---------------------------------------------------------------------------------------------------

function GM:CalcView(pl, pos, ang, fov)
	local view = {
		origin = pos,
		angles = ang,
		fov    = fov,
	}

	if !pl:Spectating() then
		gamemode.Call('DefaultView', pl, view)
	end
	
	return view
end

function GM:DefaultView(pl, view)
	local rag     = pl:GetRagdollEntity()
	local time    = CurTime()
	local respawn = pl:GetNextRespawn()
	local elapsed = time - respawn

	if elapsed >= 0 then
		if elapsed <= conf.respawn.time then
			local prog = math.Clamp(1-(elapsed/conf.respawn.time), 0, 1)
			local fov  = view.fov + math.sin(math.EaseInOut(prog, 1, 0) * 4 * math.pi) * conf.respawn.fov
			
			view.fov = fov
		end
	end
	
	if rag:IsValid() then
		local ragpos = rag:GetPos()
		view.origin = ragpos + vector_up * conf.padding
	end
	
	local oldorigin = view.origin
	
	gamemode.Call('CustomView', pl, view)
		
	local tr = util.TraceHull {
		start  = oldorigin,
		endpos = view.origin - view.angles:Forward() * conf.dist,
		mins   = conf.mins,
		maxs   = conf.maxs,
		mask   = MASK_BLOCKLOS,
	}

	view.drawviewer = true
	view.origin     = tr.HitPos
end

function GM:CustomView(pl, view)
end