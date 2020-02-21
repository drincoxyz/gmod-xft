GM.Name      = 'Xtreme Football Throwdown'
GM.Author    = "Brandon 'Inco' Little"
GM.Website   = 'https://drinco.xyz/xft'
GM.Email     = 'drinco@posteo.net'
GM.TeamBased = true

local conf = {
	dir = GM.FolderName..'/gamemode/init/'
}

print '--------------------------------------------------------------------------------------'
print(GM.Name)
print '--------------------------------------------------------------------------------------'

for i, script in ipairs(file.Find(conf.dir..'*.lua', 'LUA')) do
	print("loading init file '"..script.."'")
	include(conf.dir..script)
	AddCSLuaFile(conf.dir..script)
end

print '--------------------------------------------------------------------------------------'