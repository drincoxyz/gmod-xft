--
-- Variables
--

GM.Characters = GM.Characters or {}

--
-- Functions
--

--
-- Name: GM:AddCharacter
-- Desc: Registers a valid character for players to use.
--
-- Arguments
--
-- [1] string - Character name.
-- [2] string - Player model.
--
function GM:AddCharacter(name, mdl)
	self.Characters[name] = mdl
end

--
-- Name: GM:GetCharacters
-- Desc: Returns a list of registered characters.
--
-- Returns
--
-- [1] table - Character list.
--
function GM:GetCharacters()
	return self.Characters
end

--
-- Hooks
--

if SERVER then
	hook.Add("PlayerSpawn", "xft_character", function(pl)
		pl:SetModel(pl:GetCharacterModel())
	end)

	hook.Add("PlayerInitialSpawn", "xft_default_character", function(pl)
		pl:SetCharacter "Barney"
	end)

	hook.Add("PlayerDeath", "xft_death_line", function(pl)
		pl:EmitVoiceLine "death"
	end)
end

--
-- Barney (English)
--

sound.Add {
	name = "xft.voice.barney.en.kill",
	channel = CHAN_VOICE,
	pitch = {95, 105},
	volume = 1,
	level = 75,
	sound = {
		"xft/voice/barney/en/kill1.ogg",
		"xft/voice/barney/en/kill2.ogg",
		"xft/voice/barney/en/kill3.ogg",
		"xft/voice/barney/en/kill4.ogg",
		"xft/voice/barney/en/kill5.ogg",
	},
}

sound.Add {
	name = "xft.voice.barney.en.death",
	channel = CHAN_VOICE,
	pitch = {95, 105},
	volume = 1,
	level = 75,
	sound = {
		"xft/voice/barney/en/death1.ogg",
		"xft/voice/barney/en/death2.ogg",
		"xft/voice/barney/en/death3.ogg",
	},
}

--
-- Barney (French)
--

sound.Add {
	name = "xft.voice.barney.fr.kill",
	channel = CHAN_VOICE,
	pitch = {95, 105},
	volume = 1,
	level = 75,
	sound = {
		"xft/voice/barney/fr/kill1.ogg",
		"xft/voice/barney/fr/kill2.ogg",
		"xft/voice/barney/fr/kill3.ogg",
		"xft/voice/barney/fr/kill4.ogg",
		"xft/voice/barney/fr/kill5.ogg",
	},
}

sound.Add {
	name = "xft.voice.barney.fr.death",
	channel = CHAN_VOICE,
	pitch = {95, 105},
	volume = 1,
	level = 75,
	sound = {
		"xft/voice/barney/fr/death1.ogg",
		"xft/voice/barney/fr/death2.ogg",
		"xft/voice/barney/fr/death3.ogg",
	},
}

--
-- Characters
--

GM:AddCharacter("Barney", "models/player/barney.mdl")

--
-- Player
--

local meta = FindMetaTable "Player"

function meta:SetCharacter(name)
	if GAMEMODE:GetCharacters()[name] then
		self:SetNW2String("xft_character", tostring(name))
	end
end

function meta:EmitVoiceLine(name)
	if SERVER then
		local filter = RecipientFilter()
		
		filter:AddPAS(self:GetPos() + self:OBBCenter())
		
		for i, pl in pairs(filter:GetPlayers()) do
			pl:SendLua("Entity("..self:EntIndex().."):EmitVoiceLine('"..name.."')")
		end
	else
		self:EmitSound("xft.voice."..string.lower(self:GetCharacter()).."."..GAMEMODE:GetLanguage().."."..name)
	end
end

function meta:GetCharacterModel()
	return GAMEMODE:GetCharacters()[self:GetCharacter()]
end

function meta:GetCharacter()
	return self:GetNW2String "xft_character"
end