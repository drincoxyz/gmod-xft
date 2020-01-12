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
	local prog = pl:GetLookBehindProgress()
	
	ang:RotateAroundAxis(Vector(0, 0, 1), prog * -179.99)
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