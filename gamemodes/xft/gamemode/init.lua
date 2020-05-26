include      "shared.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

for i, script in SortedPairs(file.Find(GM.FolderName.."/gamemode/server/*.lua", "LUA", true)) do
	include(GM.FolderName.."/gamemode/server/"..script)
end

for i, script in SortedPairs(file.Find(GM.FolderName.."/gamemode/client/*.lua", "LUA", true)) do
	AddCSLuaFile(GM.FolderName.."/gamemode/client/"..script)
end
