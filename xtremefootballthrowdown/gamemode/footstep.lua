--
-- Hooks
--

hook.Add("PlayerStepSoundTime", "xft_base", function(pl, step, walking)
	if pl:Crouching() then
		return 250
	end
	
	local vel = pl:GetVelocity()
	local speed = vel:Length2DSqr()
	
	if speed <= GAMEMODE:GetStrafeSpeedSqr() then
		return 300
	elseif speed <= GAMEMODE:GetChargeSpeedSqr() then
		return 250
	end
	
	return 175
end)