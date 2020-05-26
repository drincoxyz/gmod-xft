include "shared.lua"

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:SharedInitialize()

	sound.Play("status/drunk/haze.mp3", EyePos(), 0, math.Rand(95, 105), .75)

	hook.Add("RenderScreenspaceEffects", self, function(status)
		local fac = self:GetDrunkFactor()

		DrawMotionBlur(.2, .99*fac, .01)
		DrawBloom(0.75, 2*fac, 9, 9, 1, 1, 1, 1, 1)
	end)

	hook.Add("CustomView", self, function(status, pl, view)
		if pl != status.Owner then return end

		local fac = self:GetDrunkFactor()

		view.angles.y = view.angles.y + TimedSin(.125, 0, 50, 0)*fac
		view.angles.x = view.angles.x + TimedCos(.25, 0, 30, 0)*fac
		view.angles.z = view.angles.z + TimedCos(.075, 0, 50, 0)*fac
	end)
end
