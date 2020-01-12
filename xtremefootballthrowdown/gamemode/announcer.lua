--
-- English
--

sound.Add {
	name = "xft.voice.announcer.en.1",
	sound = "xft/voice/announcer/en/1.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.en.2",
	sound = "xft/voice/announcer/en/2.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.en.3",
	sound = "xft/voice/announcer/en/3.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.en.1min",
	sound = "xft/voice/announcer/en/1_minute_left.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.en.2min",
	sound = "xft/voice/announcer/en/2_minutes_left.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.en.3min",
	sound = "xft/voice/announcer/en/3_minutes_left.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.en.5min",
	sound = "xft/voice/announcer/en/5_minutes_left.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.en.30sec",
	sound = "xft/voice/announcer/en/30_seconds_left.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.en.ballreset",
	sound = "xft/voice/announcer/en/ball_reset.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

--
-- French
--

sound.Add {
	name = "xft.voice.announcer.fr.1",
	sound = "xft/voice/announcer/fr/1.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.fr.2",
	sound = "xft/voice/announcer/fr/2.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.fr.3",
	sound = "xft/voice/announcer/fr/3.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.fr.1min",
	sound = "xft/voice/announcer/fr/1_minute_left.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.fr.2min",
	sound = "xft/voice/announcer/fr/2_minutes_left.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.fr.3min",
	sound = "xft/voice/announcer/fr/3_minutes_left.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.fr.5min",
	sound = "xft/voice/announcer/fr/5_minutes_left.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.fr.30sec",
	sound = "xft/voice/announcer/fr/30_seconds_left.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

sound.Add {
	name = "xft.voice.announcer.fr.ballreset",
	sound = "xft/voice/announcer/fr/ball_reset.ogg",
	pitch = 100,
	volume = 1,
	level = 0,
}

--
-- Functions
--

--
-- Name: GM:Announce
-- Desc: Emits a global announcer quote. Automatically translated when available.
--       If called from the server, it will be broadcasted to all players.
--
-- Arguments
--
-- [1] string - The voice line to use.
--
function GM:Announce(name)
	if SERVER then
		BroadcastLua("GAMEMODE:Announce('"..name.."')")
	else
		sound.Play("xft.voice.announcer."..self:GetLanguage().."."..name, EyePos())
	end
end