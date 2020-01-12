--
-- Init
--

AddCSLuaFile()

--
-- Resources
--

--
-- Phrases
--

if CLIENT then
	GAMEMODE:SetPhrase("item.ball", "en", "Ball")
	GAMEMODE:SetPhrase("item.ball", "fr", "Ballon")
end

--
-- Fonts
--

if CLIENT then
	surface.CreateFont("xft_ball_indicator", {
		font = "DAGGERSQUARE",
		size = 128,
	})
end

--
-- Variables
--

ENT.Type    = "anim"
ENT.Name    = "item.ball"
ENT.Base    = "xft_item_base"
ENT.Model   = "models/roller.mdl"
ENT.Scale   = .75
ENT.Physics = SOLID_VPHYSICS

--
-- Functions
--

if SERVER then
	--
	-- Name: ENT:Reset
	-- Desc: Resets the ball to its spawn position.
	--
	function ENT:Reset()
		local owner = self:GetOwner()
		local data = EffectData()
	
		if IsValid(owner) then
			owner:DropItem()
		end
	
		data:SetOrigin(self:GetPos())
		self:SetPos(self:GetSpawnPos())
		
		timer.Simple(0, function()
			local phys = self:GetPhysicsObject()
			
			if IsValid(phys) then
				phys:SetVelocity(Vector())
			end
		end)
		
		util.Effect("xft_ball_reset", data)
		GAMEMODE:Announce "ballreset"
	end
elseif CLIENT then
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
end