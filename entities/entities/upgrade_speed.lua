AddCSLuaFile()

if CLIENT then
	language.Add('upgrade_speed', {
		en = 'Speed',
		fr = 'Rapide',
	})
end

sound.Add {
	name   = 'upgrade_speed',
	volume = 1,
	level  = 80,
	pitch  = {95, 105},
	sound  = 'upgrade/speed.ogg',
}

ENT.Type  = 'anim'
ENT.Base  = 'base_upgrade'
ENT.Name  = '#upgrade_speed'
ENT.Color = Color(255, 255, 255)

function ENT:OnInitialize(ball)
	if SERVER then
		self:EmitSound 'upgrade_speed'
	end
end

function ENT:OnRemove()
end

function ENT:OnThink(ball)
end