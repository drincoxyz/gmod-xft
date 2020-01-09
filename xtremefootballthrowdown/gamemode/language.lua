--
-- This allows you to set gamemode-related phrases in multiple languages
--
-- The correct phrases will be used automatically based on the player's language preference
-- (or will fallback to English)
--
-- Note that this does NOT automatically translate phrases for you, and is also limited to the
-- clientside realm only
--
-- When adding a translation to a phrase, please add a Lua comment next to it showing the rough
-- English translation
--

--
-- Returns the translated text of a given phrase
--
function GM:GetPhrase(phrase)
	local temp = "xft."..cvars.String "gmod_language".."."..phrase
	local text = language.GetPhrase(temp)
	
	if text == temp then return language.GetPhrase("xft.en."..phrase) end
	
	return text
end

--
-- Sets the translated text of a given phrase for a given language
--
function GM:SetPhrase(phrase, lang, text)
	language.Add("xft."..lang.."."..phrase, text)
end