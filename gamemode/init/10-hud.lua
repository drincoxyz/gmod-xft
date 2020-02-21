local conf = {
	dir = GM.FolderName..'/gamemode/hud/',

	whitelist = {
		CHudChat = true,
		CHudMenu = true,
	},
}

conf.hud = {}
for i, script in ipairs(file.Find(conf.dir..'*.lua', 'LUA')) do
	print("\tloading HUD file '"..script.."'")
	AddCSLuaFile(conf.dir..script)
	if CLIENT then table.insert(conf.hud, include(conf.dir..script)) end
end

if SERVER then return end

conf.lerp         = {}
conf.lerp.yaw     = 0
conf.lerp.ang     = Angle()
conf.lerp.lastang = EyeAngles()

conf.enabled = CreateConVar('xft_hud', 1, nil, 'draws the HUD'):GetBool()
cvars.RemoveChangeCallback('xft_hud', 'default')
cvars.AddChangeCallback('xft_hud', function(cvar, old, new) conf.enabled = tobool(new) end, 'default')

---------------------------------------------------------------------------------------------------

function GM:DrawHUD(pl, lerp)
	for i, func in pairs(conf.hud) do
		func(pl, lerp)
	end
end

function GM:HUDShouldDraw(element)
	return conf.whitelist[element]
end

hook.Add('PreDrawEffects', 'DrawHUD', function()
	local pl     = LocalPlayer()
	local obs    = pl:GetObserverTarget()
	local target = obs:IsValid() and obs:IsPlayer() and obs or pl

	if conf.enabled then
		local ang = EyeAngles()
		local ft  = RealFrameTime()
		
		conf.lerp.ang     = LerpAngle(ft * 5, conf.lerp.ang, ang - conf.lerp.lastang)
		conf.lerp.ang.y   = math.Clamp(conf.lerp.ang.y, -5, 5)
		conf.lerp.yaw     = conf.lerp.ang.y
		conf.lerp.lastang = ang
	
		cam.Start3D(nil, nil, 90)
		cam.IgnoreZ(true)
			gamemode.Call('DrawHUD', target, conf.lerp.yaw * 5)
		cam.IgnoreZ(false)
		cam.End3D()
	end
end)