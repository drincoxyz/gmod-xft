AddCSLuaFile()

ENT.Type    = "anim"
ENT.Base    = "xft_item_base"
ENT.Model   = "models/roller.mdl"
ENT.Scale   = .75
ENT.Physics = SOLID_VPHYSICS

function ENT:Draw()
	self:DrawModel()
end