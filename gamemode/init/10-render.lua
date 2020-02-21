if SERVER then return end

local conf = {
	plinfo = {
		font = 'player_info',
		h    = 16,
		
		circle = {
			bot = {
				col = Color(0, 100, 200),
			},
			
			outline = {
				col = Color(0, 0, 0, 175),
				size = 2,
			},
			
			friend = {
				col = Color(0, 255, 0),
			},
			
			frienemy = {
				col = Color(255, 50, 0),
			},
		}
	}
}

surface.CreateFont('player_info', {
	font   = 'DAGGERSQUARE',
	weight = 1000,
	size   = 1000,
})

---------------------------------------------------------------------------------------------------

function GM:PrePlayerDraw(pl)
	local rag = pl:GetRagdollEntity()
	local obs = pl:GetObserverTarget()

	if pl != obs and pl != LocalPlayer() then
		pl:DrawInfo()
	end
	
	if rag:IsValid() then
		return true
	end
end

local meta = FindMetaTable 'Player'

function meta:DrawInfo()
	local eyepos  = EyePos()
	local pos     = self:NearestPoint(eyepos)
	local distsqr = eyepos:DistToSqr(pos)
	
	if distsqr > 262144 then return end

	local lpl      = LocalPlayer()
	local myteamid = lpl:Team()
	local teamid   = self:Team()
	local nick     = self:Nick()
	local teamcol  = team.GetColor(teamid)
	local rag      = self:GetRagdollEntity()
	local ang, pos = EyeAngles()
	local maxs     = self:OBBMaxs()
	local friend   = self:GetFriendStatus()
	
	ang:RotateAroundAxis(ang:Up(), 180)
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	
	if rag:IsValid() then
		local bone = rag:LookupBone 'ValveBiped.Bip01_Head1' or 0
		pos = rag:GetBonePosition(bone) + vector_up * conf.plinfo.h
	else
		local bone = self:LookupBone 'ValveBiped.Bip01_Head1' or 0
		pos = self:GetBonePosition(bone) + vector_up * conf.plinfo.h
	end

	cam.Start3D2D(pos, ang, .04)
		draw.SimpleText(nick, conf.plinfo.font, 0, 0, teamcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
	
	if !rag:IsValid() then
		pos = self:GetPos() + vector_up
		
		if self:IsBot() then
			cam.Start3D2D(pos, Angle(), 1)
				draw.NoTexture()
				surface.DrawCircle(0, 0, maxs.x + conf.plinfo.circle.outline.size, 32, conf.plinfo.circle.outline.col)
				surface.DrawCircle(0, 0, maxs.x, 32, conf.plinfo.circle.bot.col)
			cam.End3D2D()
		elseif friend == 'friend' then
			cam.Start3D2D(pos, Angle(), 1)
				draw.NoTexture()
				surface.DrawCircle(0, 0, maxs.x + conf.plinfo.circle.outline.size, 32, conf.plinfo.circle.outline.col)
				
				if teamid == myteamid then
					surface.DrawCircle(0, 0, maxs.x, 32, conf.plinfo.circle.friend.col)
				else
					surface.DrawCircle(0, 0, maxs.x, 32, conf.plinfo.circle.frienemy.col)
				end
			cam.End3D2D()
		end
	end
end