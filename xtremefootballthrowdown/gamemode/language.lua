--
-- Functions
--

function GM:GetLanguage()
	return cvars.String "gmod_language"
end

function GM:GetPhrase(phrase)
	local temp = "xft."..self:GetLanguage().."."..phrase
	local text = language.GetPhrase(temp)
	
	if text == temp then return language.GetPhrase("xft.en."..phrase) end
	
	return text
end

function GM:SetPhrase(phrase, lang, text)
	language.Add("xft."..lang.."."..phrase, text)
end