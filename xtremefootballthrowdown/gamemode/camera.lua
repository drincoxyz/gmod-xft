--
-- Functions
--

--
-- Name: GM:GetCameraDistance
-- Desc: Sets the ideal distance between the camera and the player.
--
function GM:SetCameraDistance(dist)
	SetGlobalInt("xft_camera_dist", dist)
end

--
-- Name: GM:GetCameraDistance
-- Desc: Returns the ideal distance between the camera and the player.
--
function GM:GetCameraDistance()
	return GetGlobalInt "xft_camera_dist"
end

--
-- Name: GM:SetCameraHull
-- Desc: Sets the camera collision boundaries.
--
function GM:SetCameraHull(hull)
	SetGlobalVector("xft_camera_hull", hull)
end

--
-- Name: GM:GetCameraHull
-- Desc: Returns the camera collision boundaries.
--
function GM:GetCameraHull()
	return GetGlobalVector "xft_camera_hull"
end

if CLIENT then
	function GM:SetCameraSmooth(state)
		self.CameraSmooth = tobool(state)
	end
	
	function GM:CameraSmoothingEnabled()
		return self.CameraSmooth
	end
end

--
-- ConVars
--

GM:SetCameraDistance(CreateConVar("xft_camera_dist", "100", FCVAR_NOTIFY + FCVAR_REPLICATED):GetInt())
GM:SetCameraHull(CreateConVar("xft_camera_hull", "8", FCVAR_NOTIFY + FCVAR_REPLICATED):GetInt() * Vector(1, 1, 1))

cvars.AddChangeCallback("xft_camera_dist", function(cvar, old, new)
	GAMEMODE:SetCameraDistance(new)
end)

cvars.AddChangeCallback("xft_camera_hull", function(cvar, old, new)
	GAMEMODE:SetCameraHull(Vector(new, new, new))
end)

if SERVER then return end

GM:SetCameraSmooth(CreateClientConVar("xft_camera_smooth", "1", true, false):GetBool())

--
-- Hooks
--

hook.Add("CalcView", "xft_pre_match", function(pl, pos, ang, fov)
	if GAMEMODE:GetState() ~= STATE_PRE_MATCH then return end
	
	local ball = GAMEMODE.Ball
	
	if not IsValid(ball) then return end
	
	local hull = cvars.Number "xft_camera_hull"
	local pos = ball:GetPos()
	local ang = Angle(25, (CurTime() * 25) % 360, 0)
	local tr = util.TraceHull {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		mins = -hull,
		maxs = hull,
		mask = MASK_PLAYERSOLID_BRUSHONLY,
	}
	
	return {
		origin = tr.HitPos,
		angles = ang,
	}
end)

hook.Add("CalcView", "xft_look_behind", function(pl, pos, ang, fov)
	local lookBehindAng = pl:GetLookBehindAngle()
	
	ang:RotateAroundAxis(Vector(0, 0, 1), lookBehindAng.y)
end)

hook.Add("CalcView", "xft_base", function(pl, pos, ang, fov)
	local obs = pl:GetObserverMode()
	
	if obs == OBS_MODE_NONE then
		local hull = cvars.Number "xft_camera_hull" * Vector(1, 1, 1)
		local tr = util.TraceHull {
			start = pos,
			endpos = pos - ang:Forward() * cvars.Number "xft_camera_dist",
			mins = -hull,
			maxs = hull,
			mask = MASK_PLAYERSOLID_BRUSHONLY,
		}

		pos = tr.HitPos
	end
	
	return {
		origin = pos,
		angles = ang,
		drawviewer = true,
	}
end)

--
-- Players
--

local meta = FindMetaTable "Player"

--
-- Name: GetLookBehindAngle
-- Desc: Returns the angle for the player looking behind themselves.
--
-- Returns
--
-- [1] Angle - Look behind angle.
--
function meta:GetLookBehindAngle()
	local time = CurTime()
	local rate = GAMEMODE:GetLookBehindRate()
	local start = self:GetLookBehindStart()
	local stop = self:GetLookBehindStop()
	local yaw = 0

	if self:LookingBehind() then
		local x = math.Clamp(1 - (start - stop) * rate, 0, 1)
		yaw = Lerp(math.EaseInOut(math.Clamp(((time - start) * rate) + x, 0, 1), 0, 1), 0, -179.99)
	else
		local x = math.Clamp(1 - (stop - start) * rate, 0, 1)
		yaw = Lerp(math.EaseInOut(math.Clamp(((time - stop) * rate) + x, 0, 1), 0, 1), -179.99, 0)
	end
	
	return Angle(0, yaw, 0)
end