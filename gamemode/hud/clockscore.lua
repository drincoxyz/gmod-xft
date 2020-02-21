local conf = {
	x = 0,
	y = 500,

	glow = {
		mat  = Material 'sprites/physg_glow1',
		size = 512,
	},

	clock = {
		font  = 'hud_clock',

		col = {
			bg = Color(0, 0, 0, 200),
			fg = Color(220, 220, 220),
		},
		
		shape = {
			{x = 0, y = -50},
			{x = 130, y = -50},
			{x = 120, y = 50},
			{x = 50, y = 50},
			{x = 45, y = 45},
			{x = 0, y = 45},
		},
		
		shapeinv = {
			{x = -130, y = -50},
			{x = 0, y = -50},
			{x = 0, y = 45},
			{x = -45, y = 45},
			{x = -50, y = 50},
			{x = -120, y = 50},
		},
	},
	
	side1 = {
		font = 'hud_score',
		
		shape = {
			{x = -130, y = -50},
			{x = -120, y = 50},
			{x = -210, y = 55},
			{x = -220, y = -40},
		},
	},
	
	side2 = {
		font = 'hud_score',
		
		shape = {
			{x = 130, y = -50},
			{x = 220, y = -40},
			{x = 210, y = 55},
			{x = 120, y = 50},
		},
	},
}

language.Add('clockscore_inround', {
	en = 'Time Left',
	fr = 'Temps Restant',
})

language.Add('clockscore_prematch', {
	en = 'Waiting',
	fr = 'Attendre',
})

language.Add('clockscore_preround', {
	en = 'Starting',
	fr = 'Début',
})

language.Add('clockscore_postround', {
	en = 'Touchdown!',
	fr = 'Atterrissage!',
})

---------------------------------------------------------------------------------------------------

surface.CreateFont('hud_clock', {
	font   = 'DAGGERSQUARE',
	size   = 1000,
	weight = 1000,
})

surface.CreateFont('hud_score', {
	font   = 'DAGGERSQUARE',
	size   = 1000,
	weight = 0,
})

surface.CreateFont('hud_stage', {
	font   = 'DAGGERSQUARE',
	size   = 100,
	weight = 1000,
})

return function(pl, lerp)
	local ang = Angle(0, lerp, 0)

	cam.Start3D2D(Vector(conf.x, conf.y), ang, 1, true)
		draw.NoTexture()
		surface.SetDrawColor(conf.clock.col.bg)
		surface.DrawPoly(conf.clock.shape)
		surface.DrawPoly(conf.clock.shapeinv)
	cam.End3D2D()
	
	cam.Start3D2D(Vector(conf.x, conf.y), ang, 1, true)
		local col = team.GetColor(TEAM_RED)
		
		col.a = 230
		
		draw.NoTexture()
		surface.SetDrawColor(col)
		surface.DrawPoly(conf.side1.shape)
		
		col.a = 255
		
		surface.SetMaterial(conf.glow.mat)
		surface.SetDrawColor(col)
		surface.DrawTexturedRect(-conf.glow.size/2 -175, -conf.glow.size/2, conf.glow.size, conf.glow.size)
		
		local col = team.GetColor(TEAM_BLUE)
		
		col.a = 230
		
		draw.NoTexture()
		surface.SetDrawColor(col)
		surface.DrawPoly(conf.side2.shape)
		
		col.a = 255
		
		surface.SetMaterial(conf.glow.mat)
		surface.SetDrawColor(col)
		surface.DrawTexturedRect(-conf.glow.size/2 + 175, -conf.glow.size/2, conf.glow.size, conf.glow.size)
	cam.End3D2D()
	
	cam.Start3D2D(Vector(conf.x, conf.y), ang, .4, true)
		local score  = team.GetScore(TEAM_RED)
		local col    = team.GetColor(TEAM_RED)
		local hu,s,v = ColorToHSV(col)
		
		col = HSVToColor(hu, s*.25, v)
		
		draw.SimpleText(score, conf.side1.font, -430-lerp*2, -10, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		local score  = team.GetScore(TEAM_BLUE)
		local col    = team.GetColor(TEAM_BLUE)
		local hu,s,v = ColorToHSV(col)
		
		col = HSVToColor(hu, s*.25, v)
		
		draw.SimpleText(score, conf.side1.font, 430-lerp*2, -10, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	
	cam.Start3D2D(Vector(conf.x, conf.y), ang, .3, true)
		local clock = math.ceil(GAMEMODE:GetClock())
		local min   = string.format('%02d', clock / 60 % 60)
		local sec   = string.format('%02d', clock % 60)
	
		draw.NoTexture()
		draw.SimpleText(sec, conf.clock.font, 30-lerp*2, -60, conf.clock.col.fg, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(min, conf.clock.font, -30-lerp*2, -60, conf.clock.col.fg, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.SimpleText(':', conf.clock.font, -lerp*2, -60, conf.clock.col.fg, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		local stage  = GAMEMODE:GetStage()
		local phrase = ''
	
		if stage == STAGE_PRE_MATCH then
			phrase = language.GetPhrase 'clockscore_prematch'
		elseif stage == STAGE_PRE_MATCH then
			phrase = language.GetPhrase 'clockscore_prematch'
		elseif stage == STAGE_PRE_ROUND then
			phrase = language.GetPhrase 'clockscore_preround'
		elseif stage == STAGE_IN_ROUND then
			phrase = language.GetPhrase 'clockscore_inround'
		elseif stage == STAGE_POST_ROUND then
			phrase = language.GetPhrase 'clockscore_postround'
		end
		
		draw.SimpleText(phrase, 'hud_stage', -lerp*2, 90, conf.clock.col.fg, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end