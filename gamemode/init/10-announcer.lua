local conf = {}

if CLIENT then
	language.Add('announcer_ball_reset', {
		en = 'announcer/en/ball_reset.ogg',
		fr = 'announcer/fr/ball_reset.ogg',
	})
end

---------------------------------------------------------------------------------------------------

function GM:Announce(snd)
	if SERVER then
		BroadcastLua('GAMEMODE:Announce("'..snd..'")')
	else
		surface.PlaySound(language.GetPhrase(snd))
	end
end