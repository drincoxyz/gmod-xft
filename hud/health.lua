local conf = {
	w = 2000,
	h = 300,
	x = -600,
	y = -400,
	
	tick = {
		w    = 16,
		minh = 48,
		num  = 60,
		mod  = 1,
		rate = 1.5,
	},
	
	hp = {
		text = 'HP',
		font = 'hud_health_hp',
		col  = Color(220, 220, 220),
	},
	
	heart = {
		mat  = Material('hud/heart.png', 'smooth noclamp'),
		col  = Color(0, 0, 0, 200),
		size = 400,
	},
	
	bar = {
		h   = 16,
		col = Color(0, 0, 0, 200),
	},
}

conf.heart.y = -conf.heart.size/2
conf.heart.x = -conf.heart.size/2

conf.bar.x = conf.heart.x + conf.heart.size
conf.bar.y = -conf.bar.h/2
conf.bar.w = conf.w - conf.heart.size

conf.hp.x = conf.heart.x + (conf.heart.size/2) + 64
conf.hp.y = 0

conf.tick.ticks = {}
for i = 0, conf.tick.num do
	local prog = i / conf.tick.num
	table.insert(conf.tick.ticks, {
		x   = conf.bar.x + (conf.bar.w * prog) + 32,
		h   = conf.tick.minh + (conf.h * prog),
		col = HSVToColor(120 * prog, 1, 1)
	})
end

---------------------------------------------------------------------------------------------------

surface.CreateFont('hud_health_hp', {
	font   = 'DAGGERSQUARE',
	size   = 1000,
	weight = 1000,
})

return function(pl, lerp)
	if pl:Spectating() then return end

	local time     = RealTime()
	local hp       = pl:Health()
	local maxhp    = pl:GetMaxHealth()
	local hpratio  = math.Clamp(hp / maxhp, 0, 1)
	local pos, ang = Vector(conf.x, conf.y), Angle(0, -45 + lerp, 0)
	
	cam.Start3D2D(pos, ang, .2, true)
		draw.NoTexture()
		surface.SetDrawColor(conf.bar.col)
		surface.DrawRect(conf.bar.x, conf.bar.y, conf.bar.w, conf.bar.h)
		
		surface.SetDrawColor(conf.heart.col)
		surface.SetMaterial(conf.heart.mat)
		surface.DrawTexturedRect(conf.heart.x, conf.heart.y, conf.heart.size, conf.heart.size)
		
		draw.SimpleText(conf.hp.text, conf.hp.font, conf.hp.x - lerp * 2, conf.hp.y, conf.hp.col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		for i = 1, math.ceil((conf.tick.num + 1) * hpratio) do
			local tick = conf.tick.ticks[i]
			local h    = (math.abs(math.sin((time * conf.tick.rate) + i * conf.tick.mod)) * tick.h) + conf.tick.minh
			local y    = -h/2
			
			surface.SetDrawColor(tick.col)
			surface.DrawRect(tick.x - lerp * 2, y, conf.tick.w, h)
		end
	cam.End3D2D()
end