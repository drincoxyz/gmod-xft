local conf = {
	dir = GM.FolderName..'/gamemode/patches/',
}

for i, script in ipairs(file.Find(conf.dir..'*.lua', 'LUA')) do
	print("\tloading patch file '"..script.."'")
	include(conf.dir..script)
	AddCSLuaFile(conf.dir..script)
end

---------------------------------------------------------------------------------------------------