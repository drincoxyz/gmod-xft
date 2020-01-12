local refMat = Material "xft/effects/refract_circle"

sound.Add {
	name = "xft.misc.ball.reset",
	sound = "weapons/physcannon/energy_sing_explosion2.wav",
	pitch = {95, 105},
	volume = 1,
	level = 85,
}

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter(pos, false)

	if not emitter then return end

	local part = emitter:Add(refMat, pos) if part then
		part:SetStartSize(512)
		part:SetEndSize(0)
		part:SetStartAlpha(0)
		part:SetEndAlpha(255)
		part:SetDieTime(.25)
		part:SetNextThink(CurTime())
		part:SetThinkFunction(function(p)
			local total = p:GetDieTime()
			local dur = part:GetLifeTime()
			
			refMat:SetFloat("$refractamount", dur / total)
			refMat:Recompute()
			part:SetNextThink(CurTime())
		end)
	end

	timer.Simple(.125, function()
		util.ScreenShake(pos, 5, 10, 1, 1024)
		sound.Play("xft.misc.ball.reset", pos)
	
		local part = emitter:Add(refMat, pos) if part then
			part:SetStartSize(0)
			part:SetEndSize(512)
			part:SetStartAlpha(255)
			part:SetEndAlpha(0)
			part:SetDieTime(.5)
			part:SetNextThink(CurTime())
			part:SetThinkFunction(function(p)
				local total = p:GetDieTime()
				local dur = part:GetLifeTime()
				
				refMat:SetFloat("$refractamount", dur / total)
				refMat:Recompute()
				part:SetNextThink(CurTime())
			end)
		end
		
		emitter:Finish()
	end)
end

function EFFECT:Think()
end

function EFFECT:Render()
end