include      "shared.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

function ENT:PhysicsCollide(data, collider)
	self.BaseClass.PhysicsCollide(self, data, collider)

	if data.Speed < 200 then return end

	self:Explode(data)
end

function ENT:Explode(data)
	for i = 1, 3 do
		self:GibBreakClient(data.OurNewVelocity + VectorRand()*2 * data.Speed/4 - data.HitNormal * data.Speed/2)
	end

	self:EmitSound("physics/glass/glass_pottery_break"..math.random(3, 4)..".wav", 75, math.Rand(90, 95), 1, CHAN_ITEM)

	timer.Simple(0, function()
		self:Remove()
	end)

	if GAMEMODE:DebugEnabled() then
		debugoverlay.Sphere(self:GetPos(), 128, 5, Color(255, 255, 255, 50), false)
	end

	for i, ent in pairs(ents.FindInSphere(self:GetPos(), 128)) do
		if !IsValid(ent) or !ent:IsPlayer() or !ent:Alive() then continue end
		if util.TraceLine {start=self:GetPos(),endpos=ent:GetPos()+ent:OBBCenter(),mask = MASK_PLAYERSOLID_BRUSHONLY}.Hit then continue end

		ent:ApplyStatus("drunk", 12)
	end
end
