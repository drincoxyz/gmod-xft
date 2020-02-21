local conf = {
	x = 650,
	y = -400,
	
	name = {
		font = 'hud_item_name',
		col  = Color(220, 220, 220),
	},

	bar = {
		col = Color(0, 0, 0, 200),
		w = 2000,
		h = 300,
	},
	
	model = {
		x = 80,
		y = 40,
	},
}

conf.bar.x  = -conf.bar.w
conf.bar.y  = -conf.bar.h/2
conf.name.x = -conf.bar.w/2 - 32
conf.name.y = 0

surface.CreateFont('hud_item_name', {
	font   = 'DAGGERSQUARE',
	size   = 1000,
	weight = 1000,
})

language.Add('item_none', {
	en = 'No Item',
	fr = 'Aucune Objet',
})

---------------------------------------------------------------------------------------------------

return function(pl, lerp)
	if pl:Spectating() then return end

	local time     = RealTime()
	local item     = pl:GetItem()
	local itemname = language.GetPhrase(item.Name or '#item_none')
	local pos, ang = Vector(conf.x, conf.y), Angle(0, 45 + lerp, 0)
	
	cam.Start3D2D(pos, ang, .2, true)
		draw.NoTexture()
		surface.SetDrawColor(conf.bar.col)
		surface.DrawRect(conf.bar.x, conf.bar.y, conf.bar.w, conf.bar.h)

		draw.SimpleText(itemname, conf.name.font, conf.name.x - lerp * 2, conf.name.y, conf.name.col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	
	if item:IsValid() then
		local mins, maxs = item:GetCollisionBounds()
		local extra      = (maxs.x + maxs.y) * 2
		local itempos    = item:GetPos()
		local pos        = itempos + Vector(-256 - extra, conf.model.x + extra/4, conf.model.y + extra/4)

		cam.Start3D(pos, Angle(0, 0, 0), 70)
		cam.IgnoreZ(true)
			render.SetColorModulation(1, 1, 1)
			render.Model {
				-- pos = Vector(lerp > 0 and lerp/2 or lerp, lerp > 0 and -lerp/2 or -lerp/3),
				pos   = itempos + Vector(lerp > 0 and lerp/2 or lerp, lerp > 0 and -lerp/2 or -lerp/3),
				angle = Angle(0, RealTime() * 100 % 360, 0),
				model = item.Model,
			}
		cam.IgnoreZ(false)
		cam.End3D()
	end
end