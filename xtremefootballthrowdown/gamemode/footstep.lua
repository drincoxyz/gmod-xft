function GM:PlayerStepSoundTime(pl, step, walking)
	if pl:Crouching() then
		return 250
	end
	
	local vel = pl:GetVelocity()
	local speed = vel:Length2DSqr()
	
	if speed <= cvars.Number "_xft_strafe_speed_sqr" * 2 then
		return 300
	elseif speed <= cvars.Number "_xft_charge_speed_sqr" then
		return 250
	end
	
	return 175
end