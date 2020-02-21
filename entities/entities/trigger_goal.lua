AddCSLuaFile()

if CLIENT then
	language.Add('goal_indicator', {
		en = 'GOAL!',
		fr = 'BUT!',
	})
	
	surface.CreateFont('goal_indicator', {
		font   = 'DAGGERSQUARE',
		size   = 1000,
		weight = 1000,
	})
end

ENT.Type        = 'anim'
ENT.Icon        = Material 'icons/flag.png'
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

SCORE_TOUCH = 1
SCORE_THROW = 2

function ENT:KeyValue(k, v)
	if k == 'model' then
		self:SetBrushModel(v)
	elseif k == 'teamid' then
		self:SetTeam(v)
	elseif k == 'scoretype' then
		self:SetScoreType(v)
	end
end

function ENT:Touch(ent)
	local stage = GAMEMODE:GetStage()
	
	if stage != STAGE_IN_ROUND then return end
	
	local ball = GAMEMODE:GetBall()
	
	if !ball:IsValid() then return end
	
	local teamid = ball:LastTeam()
	
	if teamid == myteamid then return end
	
	local scoretype = self:GetScoreType()
	
	if ent:IsPlayer() then
		if bit.band(scoretype, SCORE_TOUCH) != SCORE_TOUCH then return end
		
		local teamid   = ent:Team()
		local myteamid = self:Team()
		
		if teamid == myteamid then return end
		
		local item = ent:GetItem()
		
		if item != ball then return end
	elseif ent == ball then
		if bit.band(scoretype, SCORE_THROW) != SCORE_THROW then return end
	end
	
	timer.Simple(1, function()
		if self:SlowedDown() then
			game.SetTimeScale(1)
			self:SetSlowedDown(false)
		end
	end)
	
	team.AddScore(teamid, 1)
	
	GAMEMODE:EndRound()
end

function ENT:SetTeam(id)
	self:SetNW2Int('team', id)
end

function ENT:Team()
	return self:GetNW2Int('team', TEAM_RED)
end

function ENT:SetScoreType(type)
	self:SetNW2Int('score_type', type)
end

function ENT:GetScoreType()
	return self:GetNW2Int 'score_type'
end

function ENT:SetBrushModel(mdl)
	self:SetNW2String('brush_model', mdl)
end

function ENT:GetBrushModel()
	return self:GetNW2String 'brush_model'
end

function ENT:Initialize()
	local mdl = self:GetBrushModel()

	self:SetModel(mdl)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	
	if SERVER then
		self:SetTrigger(true)
	end
	
	if CLIENT then
		local mins, maxs = self:GetCollisionBounds()
		self:SetRenderBounds(mins, maxs)
	end
end

function ENT:Draw()
	local stage = GAMEMODE:GetStage()
	
	if stage != STAGE_IN_ROUND then return end

	local ball = GAMEMODE:GetBall()
	
	if !ball:IsValid() then return end
	
	local owner = ball:GetOwner()
	local lpl   = LocalPlayer()
	
	if owner != lpl then return end
	
	local teamid   = owner:Team()
	local myteamid = self:Team()
	
	if teamid == myteamid then return end
	
	local col        = team.GetColor(myteamid)
	local time       = RealTime()
	local prog       = math.abs(math.sin(time * 5))
	local eyeang     = EyeAngles()
	local center     = self:OBBCenter()
	local mins, maxs = self:GetCollisionBounds()
	
	mins, maxs = mins-center, maxs-center
	
	local size = (maxs.x+maxs.y)/2
	
	eyeang:RotateAroundAxis(eyeang:Up(), 180)
	eyeang:RotateAroundAxis(eyeang:Forward(), 90)
	eyeang:RotateAroundAxis(eyeang:Right(), 270)
	
	cam.IgnoreZ(true)
		col.a = 25 + prog * 50

		render.SetStencilEnable(true, true)
		render.SetStencilReferenceValue(1)
		
		render.SetStencilCompareFunction(STENCIL_NEVER)
		render.SetStencilFailOperation(STENCIL_REPLACE)
		
		self:DrawModel()
		
		cam.Start2D()
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			surface.SetDrawColor(col)
			surface.DrawRect(0, 0, ScrW(), ScrH())
		cam.End2D()
		
		render.SetStencilEnable(false)
	
		col.a = (150 + prog * 50)

		render.SetMaterial(self.Icon)
		render.DrawSprite(center + vector_up * (maxs.z+size), size, size, col)
	cam.IgnoreZ(false)
end

function ENT:Think()
	local stage = GAMEMODE:GetStage()
	
	if stage != STAGE_IN_ROUND then return end

	if SERVER then
		local ball = GAMEMODE:GetBall()
		
		if ball:IsValid() then
			local slowed   = self:SlowedDown()
			local teamid   = ball:LastTeam()
			local myteamid = self:Team()
			local vel      = ball:GetVelocity()
			local speedsqr = vel:LengthSqr()
			local owner    = ball:GetOwner()
			
			if owner:IsValid() or speedsqr >= 20000 then 
				if teamid != myteamid then
					local ballpos = ball:GetPos()
					local pos     = self:OBBCenter()
					local tr      = util.TraceLine {
						start  = pos,
						endpos = ballpos,
						mask   = MASK_PLAYERSOLID_BRUSHONLY,
						filter = self,
					}
					
					if !tr.Hit then
						local dist = pos:Distance(ballpos)
						
						if dist <= 300 then
							if !slowed then
								game.SetTimeScale(.4)
								self:SetSlowedDown(true)
							end
						else
							if slowed then
								game.SetTimeScale(1)
								self:SetSlowedDown(false)
							end
						end
					else
						if slowed then
							game.SetTimeScale(1)
							self:SetSlowedDown(false)
						end
					end
				else
					if slowed then
						game.SetTimeScale(1)
						self:SetSlowedDown(false)
					end
				end
			else
				if slowed then
					game.SetTimeScale(1)
					self:SetSlowedDown(false)
				end
			end
		end
	end
end

function ENT:SetSlowedDown(enable)
	self.sloweddown = tobool(enable)
end

function ENT:SlowedDown()
	self.sloweddown = self.sloweddown or false
	return self.sloweddown
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end