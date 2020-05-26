GM.Name    = "Xtreme Football Throwdown"
GM.Email   = "drinco@posteo.net"
GM.Author  = "Brandon 'Inco' Little"
GM.Website = "https://drinco.xyz"

for i, script in SortedPairs(file.Find(GM.FolderName.."/gamemode/shared/*.lua", "LUA", true)) do
	AddCSLuaFile(GM.FolderName.."/gamemode/shared/"..script)
	include(GM.FolderName.."/gamemode/shared/"..script)
end
