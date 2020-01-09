local allowedHUD = {
	["CHudChat"] = true,
	["CHudMenu"] = true,
}

function GM:HUDShouldDraw(element)
	return allowedHUD[element]
end