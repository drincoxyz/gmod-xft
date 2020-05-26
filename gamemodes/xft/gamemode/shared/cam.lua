local mins, maxs = -Vector(8, 8, 8), Vector(8, 8, 8)

function GM:GetCameraDistance()
	return 100
end

function GM:GetCameraHull()
	return mins, maxs
end
