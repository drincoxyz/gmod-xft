local conf = {}

---------------------------------------------------------------------------------------------------

function GM:PlayerStepSoundTime(pl, type, walking)	
	if pl:Crouching() then
		return 275
	else
		local vel      = pl:GetVelocity()
		local speedsqr = vel:Length2DSqr()
		
		if speedsqr > 90000 then
			return 175
		elseif speedsqr > 40000 then
			return 250
		else
			return 300
		end
	end
end