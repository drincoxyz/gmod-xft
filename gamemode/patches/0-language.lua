-- https://gist.github.com/drincoxyz/a053bf607f8001cbee86921a410f844f
-- this patches the language library in gmod to optionally accept a table as the second argument in language.Add
-- doing so will allow you to define multiple translations for a single phrases like this: {en = "hello", fr = "bonjour"}
-- these translations will be applied automatically with the gmod_language cvar (or default to the english (en) translation)
-- the old functionality (using just a string) is still supported, making this a pretty non-intrusive patch

if SERVER then return end

language._Add = language._Add or language.Add

function language.Add(phrase, text)
	if isstring(text) then
		language._Add(phrase, text)
	elseif istable(text) then
		language._Add(phrase, text[cvars.String 'gmod_language'] or text.en)
		cvars.RemoveChangeCallback('gmod_language', phrase)
		cvars.AddChangeCallback('gmod_language', function(cvar, old, new)
			language._Add(phrase, text[new] or text.en)
		end, phrase)
	end
end