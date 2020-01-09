function GM:CalcMainActivity(pl, vel)
	local act, seq = ACT_HL2MP_IDLE_ANGRY, -1
	
	if pl:Charging() then
		act = ACT_HL2MP_RUN_CHARGING
	else
		if pl:OnGround() then
			if pl:Crouching() then
				act = ACT_HL2MP_WALK_CROUCH
			else
				local speed = vel:Length2DSqr()
				
				if speed > cvars.Number "_xft_charge_speed_sqr" then
					act = ACT_HL2MP_RUN_FAST
				elseif speed > 0 then
					act = ACT_HL2MP_RUN
				end
			end
		else
			act = ACT_HL2MP_JUMP_SLAM
		end
	end
	
	return act, seq
end