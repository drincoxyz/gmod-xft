AddCSLuaFile()

ENT.Type        = 'anim'
ENT.Base        = 'base_item'
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.isball      = true
ENT.Name        = '#item_ball'
ENT.Scale       = .75
ENT.Mass        = 25
ENT.ThrowForce  = 1200
ENT.Model       = Model 'models/roller.mdl'
ENT.InModel     = ENT.Model
ENT.OutModel    = Model 'models/roller_spikes.mdl'
ENT.GlowMat     = Material 'sprites/physg_glow1'
ENT.HoloMat     = Material 'effects/combine_binocoverlay'
ENT.FlySound    = Sound 'weapons/physcannon/energy_sing_loop4.wav'
ENT.DefCol      = Color(75, 175, 175)
ENT.Physics     = SOLID_VPHYSICS
ENT.MaxSpeed    = 275

sound.Add {
	name   = 'ball_contract',
	volume = .3,
	level  = 75,
	pitch  = {95, 105},
	sound  = {
		Sound 'npc/roller/mine/rmine_blades_in1.wav',
		Sound 'npc/roller/mine/rmine_blades_in2.wav',
		Sound 'npc/roller/mine/rmine_blades_in3.wav',
	},
}

sound.Add {
	name   = 'ball_expand',
	volume = .3,
	level  = 75,
	pitch  = {95, 105},
	sound  = {
		Sound 'npc/roller/mine/rmine_blades_out1.wav',
		Sound 'npc/roller/mine/rmine_blades_out2.wav',
		Sound 'npc/roller/mine/rmine_blades_out3.wav',
	},
}

sound.Add {
	name   = 'ball_seek',
	volume = .5,
	level  = 75,
	pitch  = 100,
	sound  = Sound 'npc/roller/mine/combine_mine_active_loop1.wav',
}

sound.Add {
	name   = 'ball_purr',
	volume = .3,
	level  = 75,
	pitch  = 100,
	sound  = Sound 'npc/roller/mine/rmine_moveslow_loop1.wav',
}

sound.Add {
	name   = 'ball_bounce',
	volume = .5,
	level  = 75,
	pitch  = {100, 110},
	sound  = Sound 'npc/turret_floor/click1.wav',
}

if CLIENT then
	language.Add('item_ball', {
		en = 'The Ball',
		fr = 'Le Balle',
	})
end

function ENT:OnInitialize()
	GAMEMODE:SetBall(self)
	
	if CLIENT then
		self:SetFlySound(CreateSound(self, self.FlySound))
		self:Expand()
	end
end

function ENT:Upgrade(id)
	local upgrade = self:GetUpgrade()
	
	if upgrade:IsValid() then
		if upgrade:GetClass() == 'upgrade_'..id then return end
		upgrade:Remove()
	end

	local upgrade = ents.Create('upgrade_'..id)
	
	if !upgrade:IsValid() then return end
	
	upgrade:SetStartTime(CurTime())
	upgrade:SetOwner(self)
	upgrade:Spawn()
	
	self:SetUpgrade(upgrade)
end

function ENT:SetUpgrade(ent)
	self:SetNW2Entity('upgrade', ent)
end

function ENT:GetUpgrade()
	return self:GetNW2Entity 'upgrade'
end

function ENT:OnPickup(pl)
	self:Contract()
end

function ENT:OnDrop(pl)
	self:Expand()
end

function ENT:OnThrow(pl)
	self:Expand()
end

function ENT:OnTouch(ent)
	local class = ent:GetClass()
	
	if class == 'trigger_hurt' then
		self:Reset()
	end
end

function ENT:AllowPickup(pl)
	local stage = GAMEMODE:GetStage()
	return stage == STAGE_IN_ROUND and !self:Resetting()
end

function ENT:Draw()
	self:DrawGlow()
end

function ENT:DrawTranslucent()
	local owner = self:GetOwner()
	local lpl   = LocalPlayer()
	
	if owner == lpl then
		owner:DrawModel()
	end
	
	self:DrawModel()
end

function ENT:Think()
	if self:Resetting() then
		if !self:ShouldBeResetting() then
			self:SetResetting(false)
			
			if SERVER then
				local phys = self:GetPhysicsObject()

				self:Expand()
				
				if phys and phys:IsValid() then
					phys:EnableMotion(true)
					phys:Wake()
				end
			end
		end
	end
	
	if CLIENT then
		local speed     = self:GetVelocity():Length()
		local owner     = self:GetOwner()
		local patch     = self:GetFlySound()
		local lerpspeed = self:GetLerpSpeed()
		
		self:SetLerpSpeed(math.Approach(lerpspeed, speed, FrameTime() * 3500))

		if patch then
			if owner:IsValid() then
				patch:Stop()
			else
				patch:PlayEx(math.Clamp(lerpspeed/1000, 0.05, 0.9) ^ 0.5, 75 + math.Clamp(lerpspeed/1500, 0, 1) * 100)
			end
		end
	end
	
	if SERVER then
		local level = self:WaterLevel()
		
		if level > 2 then
			self:Reset()
		end
	end
	
	self:NextThink(CurTime())
	
	return true
end

function ENT:PhysicsCollide(data, phys)
	if 30 < data.Speed and 0.2 < data.DeltaTime then
		self:EmitSound 'ball_bounce'
	end
	
	local normal = data.OurOldVelocity:GetNormalized()
	phys:SetVelocityInstantaneous(data.Speed * 0.75 * (2 * data.HitNormal * data.HitNormal:Dot(normal * -1) + normal))
end

function ENT:GetBallColor()
	local owner = self:GetOwner()
	return owner:IsValid() and team.GetColor(owner:Team()) or self.DefCol
end

function ENT:DrawRing()
end

function ENT:DrawGlow()
	local time = CurTime()
	local pos  = self:GetPos()
	local size = TimedSin(.5, 48, 64, 0)

	-- cam.IgnoreZ(true)
		render.SetMaterial(self.GlowMat)
		render.DrawSprite(pos, size, size, self.DefCol)
	-- cam.IgnoreZ(false)
end

function ENT:SetLerpSpeed(speed)
	self.lerpspeed = speed
end

function ENT:GetLerpSpeed()
	self.lerpspeed = self.lerpspeed or 0
	return self.lerpspeed
end

function ENT:SetFlySound(patch)
	self.flysound = patch
end

function ENT:GetFlySound()
	return self.flysound
end

function ENT:Reset(quick)
	local phys  = self:GetPhysicsObject()
	local time  = CurTime()
	local owner = self:GetOwner()
	
	if owner:IsValid() then
		owner:DropItem()
	end
	
	self:SetPos(self:GetSpawnPos())
	
	if quick then
		if phys:IsValid() then
			phys:Wake()
		end
	else
		-- self:Contract()
		-- self:SetResetEnd(time + 3)
		-- self:SetResetting(true)
		
		if phys:IsValid() then
			-- phys:EnableMotion(false)
			phys:Wake()
		end
		
		GAMEMODE:Announce 'announcer_ball_reset'
	end
end

function ENT:SetResetEnd(time)
	self:SetNW2Float('reset_end', time)
end

function ENT:GetResetEnd()
	return self:GetNW2Float 'reset_end'
end

function ENT:SetResetting(enable)
	self:SetNW2Bool('resetting', enable)
end

function ENT:Resetting()
	return self:GetNW2Bool 'resetting'
end

function ENT:ShouldBeResetting()
	return CurTime() < self:GetResetEnd()
end

function ENT:Expand()
	self:SetModel(self.OutModel)
	self:EmitSound 'ball_expand'
	self:EmitSound 'ball_seek'
	self:StopSound 'ball_purr'
end

function ENT:Contract()
	self:SetModel(self.InModel)
	self:EmitSound 'ball_contract'
	self:StopSound 'ball_seek'
	self:EmitSound 'ball_purr'
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end