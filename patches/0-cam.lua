-- https://gist.github.com/drincoxyz/b4abee5d7a46e02036c11faa0e3fa2b9
-- this patches the cam library to optionally allow cam.Start3D2D to start relative to the client's screen
-- this was made to have a more standard way of creating 3D2D HUD elements without needing to write global functions

if SERVER then return end

local cam = cam

cam._Start3D2D = cam._Start3D2D or cam.Start3D2D

local cam_Start3D2D = cam._Start3D2D

local function EyeAngles3D2D()
	local ang = EyeAngles()
	
	ang:RotateAroundAxis(ang:Up(), 180)
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	
	return ang
end

local function EyePos3D2DScreen(vec)
	local pos = EyePos()
	local ang = EyeAngles()
	
	return pos + ang:Forward() * (vec.z > 0 and vec.z or 1024) + ang:Right() * vec.x + ang:Up() * vec.y
end

function cam.Start3D2D(pos, ang, scale, screen)
	if screen then
		local ang2 = EyeAngles3D2D()
		
		ang2:RotateAroundAxis(ang2:Forward(), ang.x)
		ang2:RotateAroundAxis(ang2:Right(), ang.y)
		ang2:RotateAroundAxis(ang2:Up(), ang.z)
		
		pos = EyePos3D2DScreen(pos)
		ang = ang2
	end
	
	cam_Start3D2D(pos, ang, scale)
end