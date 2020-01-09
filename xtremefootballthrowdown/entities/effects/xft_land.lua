local refractMat = Material "particle/particle_ring_refract_01"

local dustSound = "ambient/machines/thumper_dust.wav"

local snowMat = Material "particle/snow"

local metalSounds = {
	"physics/metal/metal_grate_impact_hard1.wav",
	"physics/metal/metal_grate_impact_hard2.wav",
	"physics/metal/metal_grate_impact_hard3.wav",
}

local dirtSounds = {
	"physics/surfaces/sand_impact_bullet1.wav",
	"physics/surfaces/sand_impact_bullet2.wav",
	"physics/surfaces/sand_impact_bullet3.wav",
	"physics/surfaces/sand_impact_bullet4.wav",
}

local smokeMat  = {
	Material "particle/smokesprites_0001",
	Material "particle/smokesprites_0002",
	Material "particle/smokesprites_0003",
	Material "particle/smokesprites_0004",
	Material "particle/smokesprites_0005",
	Material "particle/smokesprites_0006",
}

function EFFECT:Init(data)
	local surface = data:GetSurfaceProp()
	local mag = data:GetMagnitude()
	local pos = data:GetOrigin()
	local norm = data:GetNormal()

	local emitter = ParticleEmitter(pos, true) if emitter then
		for i = 1, 3 do local part = emitter:Add(refractMat, pos) if part then
			part:SetAngles(norm:Angle())
			part:SetStartAlpha(255)
			part:SetEndAlpha(0)
			part:SetStartSize(8 * mag * (i - 1))
			part:SetEndSize(128 * mag * i)
			part:SetDieTime(.5 * mag)
			part:SetNextThink(CurTime())
			part:SetThinkFunction(function(p)
				refractMat:SetFloat("$refractamount", p:GetLifeTime() * mag * .5)
				p:SetNextThink(CurTime())
			end)
		end end
	end emitter:Finish()
	
	if surface == 3 then -- Metal
		sound.Play(metalSounds[math.random(#metalSounds)], pos, 75, math.Rand(95, 105), mag)
	elseif surface == 44 then -- Snow
		sound.Play(dirtSounds[math.random(#dirtSounds)], pos, 75, math.Rand(95, 105), mag)
		sound.Play(dustSound, pos, 75, math.Rand(130, 140), mag)
		
		local emitter = ParticleEmitter(pos, false) if emitter then
			for i = 1, 8 do local part = emitter:Add(snowMat, pos) if part then
				part:SetRoll(math.Rand(0, 360))
				part:SetRollDelta(math.Rand(-2, 2))
				part:SetStartAlpha(100)
				part:SetEndAlpha(0)
				part:SetStartSize(0)
				part:SetLighting(false)
				part:SetAirResistance(64)
				part:SetVelocity(Vector(math.Rand(128, -128), math.Rand(128, -128), math.Rand(72, 96)) * mag)
				part:SetEndSize(math.Rand(128, 146) * mag)
				part:SetDieTime(math.Rand(2, 3) * mag)
				part:SetNextThink(CurTime())
				part:SetGravity(-vector_up * math.Rand(150, 250))
				part:SetThinkFunction(function(p)
					p:SetStartSize(Lerp(FrameTime() * 5, p:GetStartSize(), 32 * mag))
					p:SetRollDelta(Lerp(FrameTime(), p:GetRollDelta(), 0))
					p:SetNextThink(CurTime())
				end)
			end end
		end emitter:Finish()
	elseif surface == 9 or surface == 12 then -- Dirt or Grass
		sound.Play(dirtSounds[math.random(#dirtSounds)], pos, 75, math.Rand(95, 105), mag)
		sound.Play(dustSound, pos, 75, math.Rand(130, 140), mag)
		
		local emitter = ParticleEmitter(pos, false) if emitter then
			for i = 1, 8 do local part = emitter:Add(smokeMat[math.random(#smokeMat - 1)], pos) if part then
				part:SetRoll(math.Rand(0, 360))
				part:SetRollDelta(math.Rand(-2, 2))
				part:SetStartAlpha(100)
				part:SetEndAlpha(0)
				part:SetStartSize(0)
				part:SetLighting(true)
				part:SetAirResistance(32)
				part:SetVelocity(Vector(math.Rand(64, -64), math.Rand(64, -64), math.Rand(48, 64)) * mag)
				part:SetEndSize(math.Rand(96, 128) * mag)
				part:SetDieTime(math.Rand(2, 3) * mag)
				part:SetNextThink(CurTime())
				part:SetGravity(-vector_up * 8)
				part:SetThinkFunction(function(p)
					p:SetStartSize(Lerp(FrameTime() * 15, p:GetStartSize(), 32 * mag))
					p:SetRollDelta(Lerp(FrameTime(), p:GetRollDelta(), 0))
					p:SetNextThink(CurTime())
				end)
			end end
		end emitter:Finish()
	end
end

function EFFECT:Render()
	return false
end

function EFFECT:Think()
	return false
end