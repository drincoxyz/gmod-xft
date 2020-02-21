local conf = {
	cutoff   = 8,
	inactive = Color(125, 125, 125),

	reticle = {
		mat  = Material 'particle/particle_ring_wave_additive',
		col  = Color(255, 255, 255),
		size = 64,
	},
	
	pitch = {		
		mat    = Material 'particle/particle_ring_wave_additive',
		margin = 64,
		
		percent = {
			x = -350,
		},
		
		dot = {
			col = Color(75, 255, 75),
			rad = 8,
		},
	},
	
	throw = {		
		mat    = Material 'particle/particle_ring_wave_additive',
		margin = 64,
		
		percent = {
			x = 350,
		},
		
		col = {
			active = Color(225, 125, 225),
		},
	},
}

conf.reticle.x  = -conf.reticle.size/2
conf.reticle.y  = -conf.reticle.size/2

conf.pitch.size = conf.reticle.size + conf.pitch.margin
conf.pitch.x    = -conf.pitch.size/2
conf.pitch.y    = -conf.pitch.size/2

conf.throw.size = conf.reticle.size + conf.throw.margin
conf.throw.x    = -conf.throw.size/2
conf.throw.y    = -conf.throw.size/2

surface.CreateFont('aim_throw_percent', {
	font   = 'DAGGERSQUARE',
	size   = 1000,
	weight = 1000,
})

surface.CreateFont('aim_pitch', {
	font   = 'DAGGERSQUARE',
	size   = 1000,
	weight = 1000,
})


---------------------------------------------------------------------------------------------------

return function(pl)
	if !pl:AimingItem() and !pl:ThrowingItem() then return end
	
	local scrw, scrh = ScrW(), ScrH()

	cam.Start3D2D(Vector(), Angle(), 1, true)
		surface.SetMaterial(conf.reticle.mat)
		surface.SetDrawColor(conf.reticle.col)
		surface.DrawTexturedRect(conf.reticle.x, conf.reticle.y, conf.reticle.size, conf.reticle.size)
	cam.End3D2D()
	
	cam.Start3D2D(Vector(), Angle(), 1, true)
		local x, y  = (scrw/2) - conf.cutoff, (scrh/2) + (conf.pitch.size/2)
		local w, h  = (scrw/2) - (conf.pitch.size/2), (scrh/2) - (conf.pitch.size/2)
		local pitch = -(pl:EyeAngles().x/90)
		
		render.SetScissorRect(x, y, w, h, true)
			surface.SetMaterial(conf.pitch.mat)
			surface.SetDrawColor(conf.inactive)
			surface.DrawTexturedRect(conf.pitch.x, conf.pitch.y, conf.pitch.size, conf.pitch.size)
		render.SetScissorRect(0, 0, 0, 0, false)

		local x = (-(conf.pitch.size/2) + (conf.pitch.dot.rad*1.5))
		local y = (-(conf.pitch.size/2) + (conf.pitch.dot.rad))
		
		x = x * math.cos(math.abs(pitch) * math.pi/2) - conf.pitch.dot.rad
		y = y * math.sin(pitch * math.pi/2)
		
		draw.NoTexture()
		surface.DrawCircle(x, y, conf.pitch.dot.rad, 32, conf.pitch.dot.col)
	cam.End3D2D()
	
	cam.Start3D2D(Vector(), Angle(), .2, true)
		draw.SimpleText(math.ceil(pitch * 90)..'°', 'aim_pitch', conf.pitch.percent.x, 0, conf.pitch.dot.col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	
	cam.Start3D2D(Vector(), Angle(), 1, true)
		local x, y  = (scrw/2) + conf.cutoff, (scrh/2) + (conf.throw.size/2)
		local w, h  = (scrw/2) + (conf.throw.size/2), (scrh/2) - (conf.throw.size/2)
		local power = pl:GetItemThrowPower()
		
		render.SetScissorRect(x, y, w, h, true)
			surface.SetMaterial(conf.throw.mat)
			surface.SetDrawColor(conf.inactive)
			surface.DrawTexturedRect(conf.throw.x, conf.throw.y, conf.throw.size, conf.throw.size)
		render.SetScissorRect(0, 0, 0, 0, false)
		
		local hu,s,v = ColorToHSV(conf.throw.col.active)
		local col    = HSVToColor(hu, s, TimedSin(2, v - .1, v + .1, 0))
		
		render.SetScissorRect(x, y, w, h + conf.throw.size * (1-power), true)
			surface.SetMaterial(conf.throw.mat)
			surface.SetDrawColor(col)
			surface.DrawTexturedRect(conf.throw.x, conf.throw.y, conf.throw.size, conf.throw.size)
		render.SetScissorRect(0, 0, 0, 0, false)
	cam.End3D2D()
	
	cam.Start3D2D(Vector(), Angle(), .2, true)
		draw.SimpleText(string.format('%.i%%', power * 100), 'aim_throw_percent', conf.throw.percent.x, 0, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end