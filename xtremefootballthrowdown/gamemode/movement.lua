--
-- Functions
--

--
-- Name: GM:SetLookBehindRate
-- Desc: Sets the rate for players looking behind themselves.
--
function GM:SetLookBehindRate(rate)
	SetGlobalFloat("xft_look_behind_rate", tonumber(rate))
end

--
-- Name: GM:GetLookBehindRate
-- Desc: Returns the rate for players looking behind themselves.
--
function GM:GetLookBehindRate()
	return GetGlobalFloat "xft_look_behind_rate"
end

--
-- Name: GM:SetKnockdownCooldown
-- Desc: Sets the cooldown for being knocked down again.
--
function GM:SetKnockdownCooldown(cooldown)
	SetGlobalFloat("xft_knockdown_cooldown", tonumber(cooldown))
end

--
-- Name: GM:GetKnockdownCooldown
-- Desc: Returns the cooldown for being knocked down again.
--
function GM:GetKnockdownCooldown()
	return GetGlobalFloat "xft_knockdown_cooldown"
end

--
-- Name: GM:SetChargeSpeed
-- Desc: Sets the minimum charging speed.
--
function GM:SetChargeSpeed(speed)
	SetGlobalInt("xft_charge_speed", tonumber(speed))
	SetGlobalInt("xft_charge_speed_sqr", tonumber(speed) ^ 2)
end

--
-- Name: GM:GetChargeSpeed
-- Desc: Returns the minimum charging speed.
--
function GM:GetChargeSpeed()
	return GetGlobalInt "xft_charge_speed"
end

--
-- Name: GM:GetChargeSpeedSqr
-- Desc: Returns the minimum charging speed, in squared form.
--
function GM:GetChargeSpeedSqr()
	return GetGlobalInt "xft_charge_speed_sqr"
end

--
-- Name: GM:SetStrafeSpeed
-- Desc: Sets the maximum strafing speed.
--
function GM:SetStrafeSpeed(speed)
	SetGlobalInt("xft_strafe_speed", tonumber(speed))
	SetGlobalInt("xft_strafe_speed_sqr", tonumber(speed) ^ 2)
end

--
-- Name: GM:GetStrafeSpeed
-- Desc: Returns the maximum strafing speed.
--
function GM:GetStrafeSpeed()
	return GetGlobalInt "xft_strafe_speed"
end

--
-- Name: GM:GetStrafeSpeedSqr
-- Desc: Returns the maximum strafing speed, in squared form.
--
function GM:GetStrafeSpeedSqr()
	return GetGlobalInt "xft_strafe_speed_sqr"
end

--
-- Name: GM:SetCrouchSpeed
-- Desc: Sets the maximum crouching speed.
--
function GM:SetCrouchSpeed(speed)
	SetGlobalInt("xft_crouch_speed", tonumber(speed))
	SetGlobalInt("xft_crouch_speed_sqr", tonumber(speed) ^ 2)
end

--
-- Name: GM:GetCrouchSpeed
-- Desc: Returns the maximum crouching speed.
--
function GM:GetCrouchSpeed()
	return GetGlobalInt "xft_crouch_speed"
end

--
-- Name: GM:GetCrouchSpeedSqr
-- Desc: Returns the maximum crouching speed, in squared form.
--
function GM:GetCrouchSpeedSqr()
	return GetGlobalInt "xft_crouch_speed_sqr"
end

--
-- Name: GM:SetMaxSpeed
-- Desc: Sets the maximum speed.
--
function GM:SetMaxSpeed(speed)
	SetGlobalInt("xft_max_speed", tonumber(speed))
	SetGlobalInt("xft_max_speed_sqr", tonumber(speed) ^ 2)
end

--
-- Name: GM:GetMaxSpeed
-- Desc: Returns the maximum speed.
--
function GM:GetMaxSpeed()
	return GetGlobalInt "xft_max_speed"
end

--
-- Name: GM:GetMaxSpeedSqr
-- Desc: Returns the maximum speed, in squared form.
--
function GM:GetMaxSpeedSqr()
	return GetGlobalInt "xft_max_speed_sqr"
end

if CLIENT then
	--
	-- Name: GM:SetAutoCharge
	-- Desc: Sets whether the player should auto-charge or not.
	--
	function GM:SetAutoCharge(state)
		self.AutoCharge = tobool(state)
	end
	
	--
	-- Name: GM:AutoChargingEnabled
	-- Desc: Returns whether the player has auto-charging enabled or not.
	--
	function GM:AutoChargingEnabled()
		return self.AutoCharge
	end
end

--
-- ConVars
--

GM:SetLookBehindRate(CreateConVar("xft_look_behind_rate", 5, FCVAR_NOTIFY + FCVAR_REPLICATED):GetFloat())
GM:SetLookBehindRate(CreateConVar("xft_knockdown_cooldown", 2, FCVAR_NOTIFY + FCVAR_REPLICATED):GetFloat())
GM:SetStrafeSpeed(CreateConVar("xft_strafe_speed", 150, FCVAR_NOTIFY + FCVAR_REPLICATED):GetInt())
GM:SetChargeSpeed(CreateConVar("xft_charge_speed", 300, FCVAR_NOTIFY + FCVAR_REPLICATED):GetInt())
GM:SetCrouchSpeed(CreateConVar("xft_crouch_speed", 125, FCVAR_NOTIFY + FCVAR_REPLICATED):GetInt())
GM:SetMaxSpeed(CreateConVar("xft_max_speed", 350, FCVAR_NOTIFY + FCVAR_REPLICATED):GetInt())

cvars.AddChangeCallback("xft_look_behind_rate", function(cvar, old, new)
	GAMEMODE:SetLookBehindRate(new)
end, "Default")

cvars.AddChangeCallback("xft_knockdown_cooldown", function(cvar, old, new)
	GAMEMODE:SetKnockDownCooldown(new)
end, "Default")

cvars.AddChangeCallback("xft_strafe_speed", function(cvar, old, new)
	GAMEMODE:SetStrafeSpeed(new)
end, "Default")

cvars.AddChangeCallback("xft_charge_speed", function(cvar, old, new)
	GAMEMODE:SetChargeSpeed(new)
end, "Default")

cvars.AddChangeCallback("xft_crouch_speed", function(cvar, old, new)
	GAMEMODE:SetCrouchSpeed(new)
end, "Default")

cvars.AddChangeCallback("xft_max_speed", function(cvar, old, new)
	GAMEMODE:SetMaxSpeed(new)
end, "Default")

if CLIENT then
	GM:SetAutoCharge(CreateClientConVar("xft_auto_charge", 1, true, true):GetBool())
	
	cvars.AddChangeCallback("xft_auto_charge", function(cvar, old, new)
		GAMEMODE:SetAutoCharge(new)
	end, "Default")
end

--
-- Hooks
--

hook.Add("ShouldCollide", "xft_players", function(ent1, ent2)
	if ent1:IsPlayer() and ent2:IsPlayer() then
		return false
	end
end)

hook.Add("Move", "xft_base", function(pl, mv)
	local obsMode = pl:GetObserverMode()
	
	if obsMode == OBS_MODE_NONE then
		local maxSpeed = cvars.Number "xft_max_speed"
		
		mv:SetMaxSpeed(maxSpeed)

		if pl:Crouching() then
			mv:SetMaxClientSpeed(cvars.Number "xft_crouch_speed")
		else
			if mv:GetForwardSpeed() > 0 then
				local vel = mv:GetVelocity()
				local speed = math.min(maxSpeed, vel:Length2D())
				local newSpeed = math.max(speed + FrameTime() * (15 + 0.5 * (400 - speed)) * 1, 100) * (1 - math.max(0, math.abs(math.AngleDifference(mv:GetMoveAngles().yaw, vel:Angle().yaw)) - 4) / 360)

				mv:SetSideSpeed(0)
				mv:SetMaxClientSpeed(newSpeed)
			else
				mv:SetMaxClientSpeed(cvars.Number "xft_strafe_speed")
			end
		end
	end
end)

hook.Add("Move", "xft_push", function(pl, mv)
	if mv:GetForwardSpeed() ~= 0 or mv:GetSideSpeed() ~= 0 then return end
	if not pl:Alive() or pl:GetObserverMode() ~= OBS_MODE_NONE then return end

	local pos = mv:GetOrigin()
	local mins, maxs = pl:GetCollisionBounds()
	local tr = util.TraceHull {
		start = pos,
		endpos = pos,
		mins = mins,
		maxs = maxs,
		filter = pl,
	}
	
	if not tr.Hit or not IsValid(tr.Entity) or not tr.Entity:IsPlayer() or not tr.Entity:Alive() or tr.Entity:GetObserverMode() ~= OBS_MODE_NONE then return end
	
	local otherPos = tr.Entity:GetNetworkOrigin()
	local dir = (pos - otherPos):GetNormalized() * Vector(1, 1, 0)
	
	mv:SetVelocity(mv:GetVelocity() + (dir * 8))
end)

hook.Add("Move", "xft_charge", function(pl, mv)
	if pl:Charging() then
		if not pl:ShouldCharge() then
			pl:SetCharging(false)
			pl:SetChargeStop(CurTime())
		end
	else
		if pl:ShouldCharge() then
			pl:SetCharging(true)
			pl:SetChargeStart(CurTime())
		end
	end
end)

hook.Add("Move", "xft_look_behind", function(pl, mv)
	if pl:LookingBehind() then
		if not pl:ShouldLookBehind() then
			pl:SetLookingBehind(false)
			pl:SetLookBehindStop(CurTime())
		end
	else
		if pl:ShouldLookBehind() then
			pl:SetLookingBehind(true)
			pl:SetLookBehindStart(CurTime())
		end
	end
end)

--
-- Player
--

local meta = FindMetaTable "Player"

--
-- Name: Player:AutoChargingEnabled
-- Desc: Returns whether the player has auto-charging enabled or not.
--
-- Returns
--
-- [1] boolean - Player has auto-charging enabled.
--
function meta:AutoChargingEnabled()
	return SERVER and self:GetInfo "xft_auto_charge" or GAMEMODE:AutoChargingEnabled()
end

--
-- Name: Player:SetCharging
-- Desc: Sets whether the player is charging forward or not.
--
-- Arguments
--
-- [1] boolean - Player is charging forward.
--
function meta:SetCharging(state)
	self:SetNW2Bool("xft_charging", tobool(state))
end

--
-- Name: Player:ShouldCharge
-- Desc: Returns whether the player should be charging forward or not.
--
-- Returns
--
-- [1] boolean - Player should be charging forward.
--
function meta:ShouldCharge()
	return not self:LookingBehind() and self:OnGround() and self:Alive() and self:GetObserverMode() == OBS_MODE_NONE and (self:KeyDown(IN_ATTACK2) or self:AutoChargingEnabled()) and self:GetVelocity():Dot(self:GetForward()) > GAMEMODE:GetChargeSpeed()
end

--
-- Name: Player:Charging
-- Desc: Returns whether the player is charging forward or not.
--
-- Returns
--
-- [1] boolean - Player is charging forward.
--
function meta:Charging()
	return self:GetNW2Bool "xft_charging"
end

--
-- Name: Player:SetChargeStart
-- Desc: Sets the time the player started charging.
--
-- Arguments
--
-- [1] number - Charge start time, in CurTime format.
--
function meta:SetChargeStart(time)
	self:SetNW2Float("xft_charge_start", tonumber(time))
end

--
-- Name: Player:GetChargeStart
-- Desc: Returns the time the player started charging.
--
-- Returns
--
-- [1] number - Charge start time, in CurTime format.
--
function meta:GetChargeStart()
	return self:GetNW2Float "xft_charge_start"
end

--
-- Name: Player:SetChargeStop
-- Desc: Sets the time the player stopped charging.
--
-- Arguments
--
-- [1] number - Charge stop time, in CurTime format.
--
function meta:SetChargeStop(time)
	self:SetNW2Float("xft_charge_stop", tonumber(time))
end

--
-- Name: Player:GetChargeStop
-- Desc: Returns the time the player stopped charging.
--
-- Returns
--
-- [1] number - Charge stop time, in CurTime format.
--
function meta:GetChargeStop()
	return self:GetNW2Float "xft_charge_stop"
end

--
-- Name: Player:SetLookingBehind
-- Desc: Sets whether the player is looking behind themselves or not.
--
-- Arguments
--
-- [1] boolean - Player is looking behind themselves.
--
function meta:SetLookingBehind(state)
	self:SetNW2Bool("xft_look_behind", tobool(state))
end

--
-- Name: Player:LookingBehind
-- Desc: Returns whether the player is looking behind themselves or not.
--
-- Returns
--
-- [1] boolean - Player is looking behind themselves.
--
function meta:LookingBehind()
	return self:GetNW2Bool "xft_look_behind"
end

--
-- Name: Player:ShouldLookBehind
-- Desc: Returns whether the player should be looking behind themselves or not.
--
-- Returns
--
-- [1] boolean - Player should be looking behind themselves.
--
function meta:ShouldLookBehind()
	return self:Alive() and self:KeyDown(IN_RELOAD)
end

--
-- Name: Player:GetLookBehindProgress
-- Desc: Returns the progress for the player looking behind themselves.
--
-- Returns
--
-- [1] number - Look behind progress.
--
function meta:GetLookBehindProgress()
	local time = CurTime()
	local rate = GAMEMODE:GetLookBehindRate()
	local start = self:GetLookBehindStart()
	local stop = self:GetLookBehindStop()

	if self:LookingBehind() then
		local x = math.Clamp(1 - (start - stop) * rate, 0, 1)
		return Lerp(math.EaseInOut(math.Clamp(((time - start) * rate) + x, 0, 1), 0, 1), 0, 1)
	else
		local x = math.Clamp(1 - (stop - start) * rate, 0, 1)
		return Lerp(math.EaseInOut(math.Clamp(((time - stop) * rate) + x, 0, 1), 0, 1), 1, 0)
	end
end

--
-- Name: Player:SetLookBehindStart
-- Desc: Sets the time the player started looking behind themselves.
--
-- Arguments
--
-- [1] number - Look behind start time.
--
function meta:SetLookBehindStart(time)
	self:SetNW2Float("xft_look_behind_start", tonumber(time))
end

--
-- Name: Player:GetLookBehindStart
-- Desc: Returns the time the player started looking behind themselves.
--
-- Returns
--
-- [1] number - Look behind start time.
--
function meta:GetLookBehindStart()
	return self:GetNW2Float "xft_look_behind_start"
end

--
-- Name: Player:SetLookBehindStop
-- Desc: Sets the time the player stopped looking behind themselves.
--
-- Arguments
--
-- [1] number - Look behind stop time.
--
function meta:SetLookBehindStop(time)
	self:SetNW2Float("xft_look_behind_stop", tonumber(time))
end

--
-- Name: Player:GetLookBehindStop
-- Desc: Returns the time the player stopped looking behind themselves.
--
-- Returns
--
-- [1] number - Look behind stop time.
--
function meta:GetLookBehindStop()
	return self:GetNW2Float "xft_look_behind_stop"
end

--
-- Name: Player:SetKnockedDown
-- Desc: Sets whether the player is knocked down or not.
--
-- Arguments
--
-- [1] boolean - Player is knocked down.
--
function meta:SetKnockedDown(state)
	self:SetNW2Bool("xft_knockdown", tobool(state))
end

--
-- Name: Player:KnockedDown
-- Desc: Returns whether the player is knocked down or not.
--
-- Returns
--
-- [1] boolean - Player is knocked down.
--
function meta:KnockedDown()
	return self:GetNW2Bool "xft_knockdown"
end

--
-- Name: Player:SetKnockdownIgnore
-- Desc: Sets whether the player is ignoring knockdowns or not.
--
-- Arguments
--
-- [1] boolean - Player is ignoring knockdowns.
--
function meta:SetKnockdownIgnore(state)
	self:SetNW2Bool("xft_knockdown_ignore", tobool(state))
end

--
-- Name: Player:IgnoringKnockdown
-- Desc: Returns whether the player is ignoring knockdowns or not.
--
-- Returns
--
-- [1] boolean - Player is ignoring knockdowns.
--
function meta:IgnoringKnockdown()
	return self:GetNW2Bool "xft_knockdown_ignore"
end


--
-- Name: Player:SetKnockdownImmune
-- Desc: Sets whether the player is immune to knockdowns or not.
--
-- Arguments
--
-- [1] boolean - Player is immune to knockdowns.
--
function meta:SetKnockdownImmune(state)
	self:SetNW2Bool("xft_knockdown_immune", tobool(state))
end

--
-- Name: Player:KnockdownImmune
-- Desc: Returns whether the player is immune to knockdowns or not.
--
-- Returns
--
-- [1] boolean - Player is immune to knockdowns.
--
function meta:KnockdownImmune()
	return self:GetNW2Bool "xft_knockdown_immune"
end

--
-- Name: Player:SetKnockdownStart
-- Desc: Sets the time the player started being knocked down.
--
-- Arguments
--
-- [1] number - Knock down start time.
--
function meta:SetKnockdownStart(time)
	self:SetNW2Float("xft_knock_down_start", tonumber(time))
end

--
-- Name: Player:GetKnockdownStart
-- Desc: Returns the time the player started being knocked down.
--
-- Returns
--
-- [1] number - Knock down start time.
--
function meta:GetKnockdownStart()
	return self:SetNW2Float "xft_knock_down_start"
end

--
-- Name: Player:SetKnockdownStop
-- Desc: Sets the time the player stopped being knocked down.
--
-- Arguments
--
-- [1] number - Knock down start time.
--
function meta:SetKnockdownStop(time)
	self:SetNW2Float("xft_knock_down_stop", tonumber(time))
end

--
-- Name: Player:GetKnockdownStop
-- Desc: Returns the time the player stopped being knocked down.
--
-- Returns
--
-- [1] number - Knock down start time.
--
function meta:GetKnockdownStop()
	return self:SetNW2Float "xft_knock_down_stop"
end

if SERVER then
	--
	-- Name: Player:Knockdown
	-- Desc: Knocks down another player.
	--
	-- Arguments
	--
	-- [1] Player  - Victim to knock down. Leave blank to knock down the attacker themselves.
	-- [2] Vector  - Amount of force to apply to the victim. Leave blank to use the attacker's velocity.
	-- [3] number  - Amount of damage to apply to the victim. Leave blank to not damage the victim.
	-- [4] boolean - Ignores fair knock down logic.
	--
	-- Returns
	--
	-- [1] boolean - Victim was successfully hit by the knockdown. Can be false if the victim is ignoring knockdowns.
	-- [2] boolean - Victim was successfully knocked down. Can be false if the victim is immune to knockdowns.
	--
	function meta:Knockdown(pl, vel, dmg, force)
		local pl = pl or self
		
		if pl:KnockdownImmune() then return end
		
		local vel = vel or self:GetVelocity()
		local dmg = dmg or 0
	end
end