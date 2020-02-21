local conf = {
	streak = {
		mat    = 'effects/blood_core',
		die    = 1,
		num    = 10,	
		size   = {4, 6},
		len    = 32,
		grav   = vector_up * -800,
		speed  = {200, 400},
		spread = 32,
	},
	
	splash = {
		mat   = 'effects/blood_core',
		die   = 2,
		size  = 16,
		sound = 'blood_spurt_splat',
	},
}

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

function EFFECT:Init()
end