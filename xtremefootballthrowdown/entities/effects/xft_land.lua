local refractMat  = Material "particle/particle_ring_refract_01"

local metalSounds = {
	"physics/metal/metal_grate_impact_hard1.wav",
	"physics/metal/metal_grate_impact_hard2.wav",
	"physics/metal/metal_grate_impact_hard3.wav",
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
		local part = emitter:Add(refractMat, pos) if part then
			part:SetAngles(norm:Angle())
			part:SetStartAlpha(255)
			part:SetEndAlpha(0)
			part:SetStartSize(0)
			part:SetEndSize(128)
			part:SetDieTime(.25)
			part:SetNextThink(CurTime())
			part:SetThinkFunction(function(p)
				refractMat:SetFloat("$refractamount", p:GetLifeTime() / .25)
				p:SetNextThink(CurTime())
			end)
		end
	end emitter:Finish()
	
	if surface == 3 then -- Metal
		sound.Play(metalSounds[math.random(#metalSounds)], pos, 75, math.Rand(95, 105), mag)
	end
end

function EFFECT:Render()
	return false
end

function EFFECT:Think()
	return false
end