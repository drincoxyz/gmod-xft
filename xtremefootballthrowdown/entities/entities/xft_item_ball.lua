AddCSLuaFile()

if CLIENT then
	GAMEMODE:SetPhrase("item.ball", "en", "Ball")
	GAMEMODE:SetPhrase("item.ball", "fr", "Ballon")
	
	surface.CreateFont("xft_ball_indicator", {
		font = "DAGGERSQUARE",
		wiehgt = 500,
		size = 128,
	})
end

ENT.Type    = "anim"
ENT.Name    = "item.ball"
ENT.Base    = "xft_item_base"
ENT.Model   = "models/roller.mdl"
ENT.Scale   = .75
ENT.Physics = SOLID_VPHYSICS

function ENT:Draw()
	local pl = LocalPlayer()
	local plPos = pl:GetPos()
	local pos = self:GetPos()

	self:DrawModel()
	
	if plPos:Distance(pos) > 512 or util.TraceLine {start = EyePos(), endpos = pos, mask = MASK_PLAYERSOLID_BRUSHONLY}.Hit then
		self:DrawIndicator()
	end
end

--
-- Name: ENT:DrawIndicator
-- Desc: Draws the ball indicator.
--
function ENT:DrawIndicator()
	local ang = GAMEMODE:EyeAngles3D2D()
	local mins, maxs = self:GetCollisionBounds()
	local pos = self:GetPos() + vector_up * maxs.z * 4
	local size = .25 + math.sin(CurTime() * 5 % math.pi) / 8
	
	cam.IgnoreZ(true)
	cam.Start3D2D(pos, ang, size)
	
	draw.SimpleText(string.upper(self:GetTranslatedName()).."!", "xft_ball_indicator", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	cam.End3D2D()
	cam.IgnoreZ(false)
end