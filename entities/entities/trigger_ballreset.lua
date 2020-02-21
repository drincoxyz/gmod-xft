AddCSLuaFile()

ENT.Type  = 'anim'
ENT.Color = Color(255, 150, 0)
ENT.Icon  = Material 'icons/reset.png'
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:KeyValue(k, v)
	if k == 'model' then
		self:SetBrushModel(v)
	end
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

	local eyepos = lpl:EyePos()
	local pos    = self:NearestPoint(eyepos)
	local dist   = eyepos:Distance(pos)
	
	if dist > 2048 then return end
	
	local rat        = 1-(dist/2048)
	local pos        = self:GetPos()
	local mdl        = self:GetModel()
	local ang        = self:GetAngles()
	local col        = self.Color
	local time       = RealTime()
	local prog       = math.abs(math.sin((time+1) * 5))
	local eyeang     = EyeAngles()
	local center     = self:OBBCenter()
	local scale      = .25 + prog * .025
	local mins, maxs = self:GetCollisionBounds()
	
	mins, maxs = mins-center, maxs-center
	
	local size = (maxs.x+maxs.y)/2
	
	eyeang:RotateAroundAxis(eyeang:Up(), 180)
	eyeang:RotateAroundAxis(eyeang:Forward(), 90)
	eyeang:RotateAroundAxis(eyeang:Right(), 270)

	cam.IgnoreZ(true)
		render.SetStencilEnable(true, true)
		render.SetStencilReferenceValue(1)
		
		render.SetStencilCompareFunction(STENCIL_NEVER)
		render.SetStencilFailOperation(STENCIL_REPLACE)
		render.Model {
			pos   = pos,
			angle = ang,
			model = mdl,
		}
		
		col.a = (25 + prog * 50) * rat
		
		cam.Start2D()
			render.SetStencilCompareFunction(STENCIL_EQUAL)
			surface.SetDrawColor(col)
			surface.DrawRect(0, 0, ScrW(), ScrH())
		cam.End2D()
		
		render.SetStencilEnable(false)
		
		col.a = (150 + prog * 50) * rat
		
		render.SetMaterial(self.Icon)
		render.DrawSprite(center, size, size, col)
	cam.IgnoreZ(false)
end

function ENT:Touch(ent)
	if ent:IsPlayer() and ent:Alive() then
		local item = ent:GetItem()
		local ball = GAMEMODE:GetBall()
		
		if item == ball then
			ball:Reset()
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end