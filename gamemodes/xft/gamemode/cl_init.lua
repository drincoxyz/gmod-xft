include "shared.lua"

for i, script in SortedPairs(file.Find(GM.FolderName.."/gamemode/client/*.lua", "LUA", true)) do
	include(GM.FolderName.."/gamemode/client/"..script)
end
