local conf = {
	part = {
		mat    = 'effects/blood_core',
		die    = 1,
		num    = 10,	
		size   = {4, 6},
		len    = 32,
		grav   = vector_up * -800,
		speed  = {200, 400},
		spread = 32,
	},
	
	splat = {
		mat   = 'effects/blood_core',
		die   = 2,
		size  = 16,
		sound = 'blood_spurt_splat',
	}
}

conf.part.vel = Vector(1, 1, 1)

sound.Add {
	name   = 'blood_spurt_splat',
	pitch  = {100, 160},
	volume = .4,
	level  = 65,
	sound  = {
		'physics/flesh/flesh_squishy_impact_hard1.wav',
		'physics/flesh/flesh_squishy_impact_hard2.wav',
		'physics/flesh/flesh_squishy_impact_hard3.wav',
		'physics/flesh/flesh_squishy_impact_hard4.wav',
	},
}

---------------------------------------------------------------------------------------------------

function EFFECT:Init(data)
	local dir = data:GetNormal()
	local pos = data:GetOrigin()
	local mag = data:GetMagnitude()
	local ang = dir:Angle()
	local emit = ParticleEmitter(pos, false)
	
	pos = pos + dir * 32
	
	if emit then
		for i = 1, math.floor(conf.part.num + conf.part.num * mag * .5) do
			local part = emit:Add(conf.part.mat, pos)
			
			if part then
				part:SetAngles(ang)
				part:SetColor(125, 0, 0)
				part:SetStartAlpha(255)
				part:SetEndAlpha(0)
				part:SetCollide(true)
				part:SetDieTime(conf.part.die)
				part:SetStartSize(math.random(conf.part.size[1], conf.part.size[2]) * mag)
				part:SetEndSize(0)
				part:SetGravity(conf.part.grav)
				part:SetVelocity(dir * conf.part.vel * math.random(conf.part.speed[1], conf.part.speed[2]) * mag + VectorRand() * conf.part.spread)
				part:SetCollideCallback(function(part, pos, dir)
					local emit = ParticleEmitter(pos, true)
					
					sound.Play(conf.splat.sound, pos)
					
					if emit then
						local part = emit:Add(conf.splat.mat, pos)
						
						if part then
							part:SetColor(125, 0, 0)
							part:SetStartAlpha(255)
							part:SetEndAlpha(0)
							part:SetDieTime(conf.splat.die)
							part:SetAngles(dir:Angle())
							part:SetStartSize(conf.splat.size * mag)
							part:SetEndSize(conf.splat.size * mag)
						end
						
						emit:Finish()
					end
				end)
			end
		end
		
		emit:Finish()
	end
end

function EFFECT:Render()
end