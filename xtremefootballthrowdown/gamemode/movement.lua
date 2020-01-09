if CLIENT then
	CreateClientConVar("xft_auto_charge", 1, true, true)
end

CreateConVar("xft_look_behind_rate", 20, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_strafe_speed", 150, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_charge_speed", 300, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_crouch_speed", 125, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_max_speed", 350, FCVAR_NOTIFY + FCVAR_REPLICATED)

--
-- These get changed automatically with the ConVars above to store their squared values
-- Speed calculations can be quicker by using these squared values
--
CreateConVar("_xft_look_behind_rate_linear", 1500, FCVAR_REPLICATED)
CreateConVar("_xft_strafe_speed_sqr", 22500, FCVAR_REPLICATED)
CreateConVar("_xft_charge_speed_sqr", 90000, FCVAR_REPLICATED)
CreateConVar("_xft_crouch_speed_sqr", 15625, FCVAR_REPLICATED)
CreateConVar("_xft_max_speed_sqr", 122500, FCVAR_REPLICATED)

cvars.AddChangeCallback("xft_look_behind_rate", function(cvar, old, new)
	RunConsoleCommand("_xft_look_behind_rate_linear", tostring(tonumber(new) * 75))
end, "Default")

cvars.AddChangeCallback("xft_strafe_speed", function(cvar, old, new)
	RunConsoleCommand("_xft_strafe_speed_sqr", tostring(tonumber(new)^2))
end, "Default")

cvars.AddChangeCallback("xft_charge_speed", function(cvar, old, new)
	RunConsoleCommand("_xft_charge_speed_sqr", tostring(tonumber(new)^2))
end, "Default")

cvars.AddChangeCallback("xft_crouch_speed", function(cvar, old, new)
	RunConsoleCommand("_xft_crouch_speed_sqr", tostring(tonumber(new)^2))
end, "Default")

cvars.AddChangeCallback("xft_max_speed", function(cvar, old, new)
	RunConsoleCommand("_xft_max_speed_sqr", tostring(tonumber(new)^2))
end, "Default")

function GM:Move(pl, mv)
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
end

local meta = FindMetaTable "Player"

--
-- Returns true if the player has autocharging enabled
--
function meta:AutoCharger()
	return SERVER and self:GetInfo "xft_auto_charge" or cvars.Bool "xft_auto_charge"
end

--
-- Returns true if the player is charging forward
--
function meta:Charging()
	return not self:LookingBehind() and self:OnGround() and self:Alive() and self:GetObserverMode() == OBS_MODE_NONE and (self:KeyDown(IN_ATTACK2) or self:AutoCharger()) and self:GetVelocity():Dot(self:GetForward()) > cvars.Number "xft_charge_speed"
end

--
-- Returns true if the player is looking behind themselves
--
function meta:LookingBehind()
	return self:Alive() and self:KeyDown(IN_RELOAD)
end