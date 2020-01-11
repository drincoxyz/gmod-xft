-----------
-- Fonts --
-----------

surface.CreateFont("xft_health", {
	font = "DAGGERSQUARE",
	size = 72,
	weight = 500,
})

---------------
-- Variables --
---------------

GM.Lerped3D2DHUDAng = GM.Lerped3D2DHUDAng or Angle()
GM.Last3D2DHUDAng = GM.Last3D2DHUDAng or Angle()

local allowedHUD = {
	["CHudChat"] = true,
	["CHudMenu"] = true,
}

-----------
-- Hooks --
-----------

--
-- This calls DrawHUD3D2D when appropriate
--
hook.Add("PostDrawTranslucentRenderables", "DrawHUD3D2D", function(depth, sky)
	if depth or sky then return end
	gamemode.Call "DrawHUD3D2D"
end)

---------------
-- Functions --
---------------

function GM:HUDShouldDraw(element)
	return allowedHUD[element]
end

function GM:EyePos3D2D(right, up, forward)
	local pos = EyePos()
	local ang = EyeAngles()
	return pos + ang:Forward() * (forward or 1024) + ang:Right() * (right or 0) + ang:Up() * (up or 0)
end

function GM:EyeAngles3D2D()
	local ang = EyeAngles()
	ang:RotateAroundAxis(ang:Up(), 180)
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	return ang
end

function GM:GetLerped3D2DHUDAng()
	return self.Lerped3D2DHUDAng
end

function GM:DrawHUD3D2D()
	local pl = LocalPlayer()
	local obsEnt = pl:GetObserverTarget()
	local target = IsValid(obsEnt) and obsEnt or pl
	local ang = pl:EyeAngles()
	
	self.Lerped3D2DHUDAng = LerpAngle(FrameTime() * 3, self.Lerped3D2DHUDAng, self.Last3D2DHUDAng - ang)

	cam.Start3D(EyePos(), EyeAngles(), 90)
	cam.IgnoreZ(true)

	if target:GetObserverMode() == OBS_MODE_NONE then
		gamemode.Call("DrawHealth", target, target:Health(), target:GetMaxHealth())
	end
	
	cam.IgnoreZ(false)
	cam.End3D()
	
	self.Last3D2DHUDAng = ang
end

function GM:DrawHealth(pl, cur, max)
	local scrW, scrH = ScrW(), ScrH()
	local lerpedAng = self:GetLerped3D2DHUDAng()
	local pos, ang = self:EyePos3D2D(), self:EyeAngles3D2D()

	pos = pos + ang:Forward() * 400
	pos = pos + ang:Right() * 300
	
	ang:RotateAroundAxis(ang:Right(), 45 - math.Clamp(lerpedAng.y * 8, -35, 35))

	draw.NoTexture()

	cam.Start3D2D(pos, ang, .5)
		surface.SetDrawColor(Color(0, 0, 0, 250))
		surface.DrawRect(-300, -70, 600, 140)

		surface.SetDrawColor(Color(0, 255, 0, 255))
		surface.DrawRect(-285, -55, 570, 110)
	cam.End3D2D()
	
	local pos, ang = self:EyePos3D2D(), self:EyeAngles3D2D()

	pos = pos + ang:Forward() * 400
	pos = pos + ang:Right() * 300
	
	ang:RotateAroundAxis(ang:Right(), 45 - math.Clamp(lerpedAng.y * 8, -35, 35))
	
	pos = pos + ang:Up() * 32
	pos = pos - ang:Right() * 10
	pos = pos + ang:Forward() * 10
	
	cam.Start3D2D(pos, ang, 1)
		draw.SimpleText(cur.." HP", "xft_health", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	
	local pos, ang = self:EyePos3D2D(), self:EyeAngles3D2D()

	pos = pos + ang:Forward() * 400
	pos = pos + ang:Right() * 290
	
	ang:RotateAroundAxis(ang:Right(), 45 - math.Clamp(lerpedAng.y * 8, -35, 35))
	
	pos = pos - ang:Up() * 32
	pos = pos + ang:Right() * 20
	pos = pos + ang:Forward() * 10
	
	cam.Start3D2D(pos, ang, 1)
		draw.SimpleText(cur.." HP", "xft_health", 0, 0, Color(255, 255, 255, 15), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end