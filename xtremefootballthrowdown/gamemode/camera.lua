CreateConVar("xft_camera_dist", "100", FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_camera_hull", "8", FCVAR_NOTIFY + FCVAR_REPLICATED)

if SERVER then return end

local lookBehindYaw = 0

CreateClientConVar("xft_camera_smooth", "1", true, false)

function GM:CalcView(pl, pos, ang, fov, znear, zfar)
	local obs = pl:GetObserverMode()
	local view = {
		origin = pos,
		angles = ang,
		fov = fov,
		znear = znear,
		zfar = zfar,
	}
	
	view.angles:RotateAroundAxis(Vector(0, 0, 1), lookBehindYaw)
	
	if obs == OBS_MODE_NONE then
		local hull = cvars.Number "xft_camera_hull" * Vector(1, 1, 1)
		local tr = util.TraceHull {
			start = view.origin,
			endpos = view.origin - view.angles:Forward() * cvars.Number "xft_camera_dist",
			mins = -hull,
			maxs = hull,
			mask = MASK_PLAYERSOLID_BRUSHONLY,
		}

		view.origin = tr.HitPos
		view.drawviewer = true
		
		if pl:LookingBehind() then
			if lookBehindYaw > -179.98 then
				if cvars.Bool "xft_camera_smooth" then
					lookBehindYaw = Lerp(FrameTime() * cvars.Number "xft_look_behind_rate", lookBehindYaw, -179.99)
				else
					lookBehindYaw = math.Approach(lookBehindYaw, -179.99, FrameTime() * cvars.Number "_xft_look_behind_rate_linear")
				end
			end
		else
			if lookBehindYaw < 0.01 then
				if cvars.Bool "xft_camera_smooth" then
					lookBehindYaw = Lerp(FrameTime() * cvars.Number "xft_look_behind_rate", lookBehindYaw, 0)
				else
					lookBehindYaw = math.Approach(lookBehindYaw, 0, FrameTime() * cvars.Number "_xft_look_behind_rate_linear")
				end
			end
		end
	end
	
	return view
end