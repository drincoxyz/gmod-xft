local conf = {
	x    = 0,
	y    = -315,
	w    = 3000,
	h    = 400,
	
	fade = {
		out = {
			time = .5,
		},
		
		_in = {
			time = .125,
		},
	},
	
	text = {
		font  = 'hud_respawn',
		text  = '#respawn_notice',
		col   = Color(220, 220, 220),
		delay = 1,
		rate  = 2,
		
		sec = {
			singular = '#respawn_notice_second',
			plural   = '#respawn_notice_seconds',
		},
	},
	
	panel = {
		col   = Color(0, 0, 0, 0),
		delay = .5,
		rate  = 2,
		
		grad = {
			left  = Material 'vgui/gradient-l',
			right = Material 'vgui/gradient-r',
		},
	},
}

conf.panel.h = conf.h
conf.panel.y = -conf.panel.h/2

language.Add('respawn_notice', {
	en = 'Respawning in %i %s...',
	fr = 'Le frai en %i %s...',
})

language.Add('respawn_notice_second', {
	en = 'second',
	fr = 'seconde',
})

language.Add('respawn_notice_seconds', {
	en = 'seconds',
	fr = 'secondes',
})

---------------------------------------------------------------------------------------------------

surface.CreateFont('hud_respawn', {
	font   = 'DAGGERSQUARE',
	size   = 1000,
	weight = 1000,
})

return function(pl, lerp)
	if pl:Spectating() then return end

	local time      = CurTime()
	local respawn   = pl:GetNextRespawn()
	local elapsed   = math.max(0, time - respawn)
	local remaining = math.max(0, respawn - time)
	local fadeout   = elapsed > 0 and elapsed <= conf.fade.out.time
	local fadein    = remaining > 0 and remaining <= conf.fade._in.time
	
	if fadeout or fadein then
		local alpha, prog = 300
		
		if fadein then
			prog = math.Clamp(1-(remaining/conf.fade._in.time), 0, 1)
		elseif fadeout then
			prog = math.Clamp(1-(elapsed/conf.fade.out.time), 0, 1)
		end
		
		alpha = alpha * prog
		
		cam.Start2D()
			draw.NoTexture()
			surface.SetDrawColor(255, 255, 255, alpha)
			surface.DrawRect(0, 0, ScrW(), ScrH())
		cam.End2D()
	end
	
	if remaining >= 0 then
		local duration = cvars.Number 'xft_respawn_time' - remaining
		local pos, ang = Vector(conf.x, conf.y), Angle(0, lerp, 0)

		cam.Start3D2D(pos, ang, .15, true)
			local panelw   = conf.w * math.EaseInOut(math.min(1, math.max(0, (duration - conf.panel.delay) * conf.panel.rate)), 1, 1)
			local panelx   = -panelw/2
			local text
			local panelcol
			local textcol
			
			if remaining > 1 then
				text = language.GetPhrase(conf.text.text):format(math.ceil(remaining), language.GetPhrase(conf.text.sec.plural))
			else
				text = language.GetPhrase(conf.text.text):format(math.ceil(remaining), language.GetPhrase(conf.text.sec.singular))
			end
			
			if remaining > 1/conf.text.rate then
				textcol = Color(conf.text.col.r, conf.text.col.g, conf.text.col.b, conf.text.col.a * math.EaseInOut(math.min(1, math.max(0, (duration - conf.text.delay) * conf.text.rate)), 1, 1))
			else
				textcol = Color(conf.text.col.r, conf.text.col.g, conf.text.col.b, conf.text.col.a * math.EaseInOut(math.min(1, math.max(0, remaining/(1/conf.text.rate))), 1, 1))
			end
			
			if remaining > 1/conf.panel.rate then
				panelcol = conf.panel.col
			else
				panelcol = Color(conf.panel.col.r, conf.panel.col.g, conf.panel.col.b, conf.panel.col.a * math.EaseInOut(math.min(1, math.max(0, remaining/(1/conf.panel.rate))), 1, 1))
			end
			
			draw.NoTexture()
			surface.SetDrawColor(panelcol)
			surface.DrawTexturedRect(panelx, conf.panel.y, panelw, conf.h)
			
			draw.SimpleText(text, conf.text.font, -lerp*2, 0, textcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End3D2D()
	end
end