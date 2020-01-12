function GM:Announce(name)
	if SERVER then
		BroadcastLua("GAMEMODE:Announce('"..name.."')")
	else
		local path = "xft/announcer/"..cvars.String "gmod_language".."/"..name..".ogg"
		
		if not file.Exists("sound/"..path, "GAME") then
			path = "xft/announcer/en/"..name..".ogg"
		end
		
		surface.PlaySound(path)
	end
end