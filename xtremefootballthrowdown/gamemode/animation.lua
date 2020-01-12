--
-- Hooks
--

hook.Add("CalcMainActivity", "xft_base", function(pl, vel)
	local act, seq = ACT_HL2MP_IDLE_ANGRY, -1
	
	if pl:OnGround() and not pl.WasOnGround then
		pl:AnimRestartGesture(GESTURE_SLOT_JUMP, ACT_LAND, true)
	end
	
	if pl:Charging() then
		act = ACT_HL2MP_RUN_CHARGING
	else
		if pl:OnGround() then
			if pl:Crouching() then
				act = ACT_HL2MP_WALK_CROUCH
			else
				local speed = vel:Length2DSqr()
				
				if speed > GAMEMODE:GetChargeSpeedSqr() then
					act = ACT_HL2MP_RUN_FAST
				elseif speed > 0 then
					act = ACT_HL2MP_RUN
				end
			end
		else
			act = ACT_HL2MP_JUMP_SLAM
		end
	end
	
	pl.WasOnGround = pl:OnGround()
	
	return act, seq
end)

--
-- Player
--

local meta = FindMetaTable "Player"