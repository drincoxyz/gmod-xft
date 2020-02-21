local conf = {}

---------------------------------------------------------------------------------------------------

function GM:CalcMainActivity(pl, vel)
	local anim = {
		seq = -1,
		act = ACT_XFT_IDLE,
	}

	if !pl:Spectating() then
		gamemode.Call('DefaultActivity', pl, vel, anim)
		gamemode.Call('CustomActivity', pl, vel, anim)
	end
	
	return anim.act, anim.seq
end

function GM:DefaultActivity(pl, vel, anim)
	local speedsqr = vel:Length2DSqr()
	
	if pl:OnGround() then
		if pl:Crouching() then
			anim.act = ACT_HL2MP_WALK_CROUCH
		else
			if speedsqr > 0 then
				anim.act = ACT_XFT_RUN
			end
		end
	else
		anim.act = ACT_HL2MP_JUMP_SLAM
	end
end

function GM:CustomActivity(pl, vel, anim)
end