local conf = {}

---------------------------------------------------------------------------------------------------

local math_abs             = math.abs
local math_min             = math.min
local math_max             = math.max
local math_AngleDifference = math.AngleDifference

SPEED_MAX    = 350
SPEED_STRAFE = 150
SPEED_CHARGE = 300

SPEEDSQR_MAX    = 122500
SPEEDSQR_STRAFE = 22500
SPEEDSQR_CHARGE = 90000

function GM:Move(pl, mv)
	local override

	if !pl:Spectating() then
		override = gamemode.Call('DefaultMove', pl, mv)
		override = gamemode.Call('CustomMove', pl, mv)
	end
	
	return override
end

function GM:DefaultMove(pl, mv)
	local rag = pl:GetRagdollEntity()
	
	if rag:IsValid() then
		local phys   = pl:GetPhysicsObject()
		local ragpos = rag:GetPos()
		local ragvel = rag:GetVelocity()
	
		mv:SetOrigin(ragpos)
		mv:SetVelocity(ragvel)
		
		return true
	end
	
	mv:SetMaxSpeed(SPEED_MAX)
	
	if !pl:Crouching() and mv:GetForwardSpeed() > 0 then
		local vel       = mv:GetVelocity()
		local mvang     = mv:GetMoveAngles()
		local maxspeed  = mv:GetMaxSpeed()
		local sidespeed = mv:GetSideSpeed()
		local newmvang  = mvang + Angle(0, sidespeed < 0 and 15 or sidespeed > 0 and -15 or 0, 0)
		local speed     = math_min(maxspeed, vel:Length2D())
		local newspeed  = math_max(speed + FrameTime() * (15 + 0.5 * (400 - speed)) * 1, 100) * (1 - math_max(0, math_abs(math_AngleDifference(newmvang.yaw, vel:Angle().yaw)) - 4) / 360)

		mv:SetSideSpeed(0)
		mv:SetMoveAngles(newmvang)
		mv:SetMaxClientSpeed(newspeed)
	else
		mv:SetMaxClientSpeed(SPEED_STRAFE)
	end
end

function GM:CustomMove(pl, mv)
end