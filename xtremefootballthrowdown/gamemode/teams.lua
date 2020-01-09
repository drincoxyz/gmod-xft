--
-- Teams work a little differently in XFT than they did in EFT
--
-- For one, there can be more than two teams playing at the same time in a single map, provided
-- the map supports it
--
-- In addition, teams are managed on a slot-basis, meaning teams are assigned to sides at runtime,
-- as opposed to having just red and blue sides
--

TEAM_SPECTATE = 0
TEAM_RED      = 1
TEAM_BLUE     = 2
TEAM_GREEN    = 3
TEAM_YELLOW   = 4

TEAM_DENY_INVALID  = 0
TEAM_DENY_COOLDOWN = 1
TEAM_DENY_ALREADY  = 2
TEAM_DENY_INACTIVE = 3

if CLIENT then
	GM:SetPhrase("team.joined", "en", "joined the")
	GM:SetPhrase("team.joined", "fr", "a rejoint le") -- joined the

	GM:SetPhrase("team.deny.invalid", "en", "That team doesn't exist")
	GM:SetPhrase("team.deny.invalid", "fr", "Cette équipe n'existe pas") -- This team does not exist
	
	GM:SetPhrase("team.deny.already", "en", "You're already on the")
	GM:SetPhrase("team.deny.already", "fr", "Vous faites déjà partie de") -- You're already part of
	
	GM:SetPhrase("team.deny.cooldown", "en", "You must wait % more seconds before joining another team")
	GM:SetPhrase("team.deny.cooldown", "fr", "Vous devez attendre % secondes de plus avant de rejoindre une autre équipe") -- You must wait an additional % seconds before joining another team
	
	GM:SetPhrase("team.deny.inactive", "en", "The % are inactive")
	GM:SetPhrase("team.deny.inactive", "fr", "Les % sont inactives") -- % are inactive
end

CreateConVar("xft_team_1", TEAM_RED, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_team_2", TEAM_BLUE, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_team_3", TEAM_SPECTATE, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_team_4", TEAM_SPECTATE, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("_xft_team_1", TEAM_RED, FCVAR_REPLICATED)
CreateConVar("_xft_team_2", TEAM_BLUE, FCVAR_REPLICATED)
CreateConVar("_xft_team_3", TEAM_SPECTATE, FCVAR_REPLICATED)
CreateConVar("_xft_team_4", TEAM_SPECTATE, FCVAR_REPLICATED)
CreateConVar("xft_team_switch_cooldown_normal", 30, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_team_switch_cooldown_betrayal", 60, FCVAR_NOTIFY + FCVAR_REPLICATED)

cvars.AddChangeCallback("xft_team_1", function(cvar, old, new)
	RunConsoleCommand("_xft_team_"..tostring(old), "0")
	RunConsoleCommand("_xft_team_"..tostring(new), "1")
end, "Default")

cvars.AddChangeCallback("xft_team_2", function(cvar, old, new)
	RunConsoleCommand("_xft_team_"..tostring(old), "0")
	RunConsoleCommand("_xft_team_"..tostring(new), "2")
end, "Default")

cvars.AddChangeCallback("xft_team_3", function(cvar, old, new)
	RunConsoleCommand("_xft_team_"..tostring(old), "0")
	RunConsoleCommand("_xft_team_"..tostring(new), "3")
end, "Default")

cvars.AddChangeCallback("xft_team_4", function(cvar, old, new)
	RunConsoleCommand("_xft_team_"..tostring(old), "0")
	RunConsoleCommand("_xft_team_"..tostring(new), "4")
end, "Default")

--
-- Assigns a given team to a given slot.
--
function GM:SetTeam(slot, id)
	RunConsoleCommand("xft_team_"..slot, tostring(id))
end

--
-- Returns the team occupying a given slot.
--
function GM:GetTeam(slot)
	return cvars.Number("xft_team_"..slot)
end

--
-- Returns the slot used by a given team.
--
function GM:GetTeamSlot(id)
	return cvars.Number("_xft_team_"..id)
end

function GM:PlayerCanJoinTeam(pl, id)
	if not team.Valid(id) then return false, TEAM_DENY_INVALID end
	
	if id > 0 and GAMEMODE:GetTeamSlot(id) < 1 then return false, TEAM_DENY_INACTIVE end

	local old = pl:Team()
	
	if id == old then return false, TEAM_DENY_ALREADY end
	
	local cooldown = pl:GetNextTeamSwitch()
	
	if CurTime() < cooldown then return false, TEAM_DENY_COOLDOWN end
	
	return true
end

function GM:CreateTeams()
	team.SetUp(TEAM_SPECTATE, "Spectators", Color(255, 255, 255), true)
	team.SetUp(TEAM_RED, "Red Rhinos", Color(255, 0, 0), true)
	team.SetUp(TEAM_BLUE, "Blue Bulls", Color(0, 0, 255), true)
	team.SetUp(TEAM_GREEN, "Green Gators", Color(0, 255, 0), true)
	team.SetUp(TEAM_YELLOW, "Yellow Yaks", Color(255, 255, 0), true)
end

function GM:PlayerRequestTeam(pl, id)
	local joinable, reason = pl:CanJoinTeam(id)
	
	if not joinable then
		if reason == TEAM_DENY_INVALID then
			pl:SendLua("chat.AddText(GAMEMODE:GetPhrase 'team.deny.invalid')")
		elseif reason == TEAM_DENY_COOLDOWN then
			pl:SendLua("chat.AddText(string.Replace(GAMEMODE:GetPhrase 'team.deny.cooldown', '%', tostring(math.ceil(Entity("..pl:EntIndex().."):GetNextTeamSwitch() - CurTime()))))")
		elseif reason == TEAM_DENY_ALREADY then
			pl:SendLua("chat.AddText(GAMEMODE:GetPhrase 'team.deny.already'..' '..team.GetName("..id.."))")
		elseif reason == TEAM_DENY_INACTIVE then
			pl:SendLua("chat.AddText(string.Replace(GAMEMODE:GetPhrase 'team.deny.inactive', '%', team.GetName("..id..")))")
		end
	
		return
	end
	
	local old = pl:Team()
	local cooldown = old == TEAM_SPECTATE and cvars.Number "xft_team_switch_cooldown_normal" or cvars.Number "xft_team_switch_cooldown_betrayal"
	
	pl:SetNextTeamSwitch(CurTime() + cooldown)
	pl:SetTeam(id)
	pl:Spawn()
	
	gamemode.Call("OnPlayerChangedTeam", pl, old, id)
end

function GM:OnPlayerChangedTeam(pl, old, new)
	local everyone = player.GetHumans()
	local name = team.GetName(new)
	local nick = pl:Nick()
	
	for i, pl in pairs(everyone) do
		pl:SendLua("chat.AddText('"..nick.." '..GAMEMODE:GetPhrase 'team.joined'..' "..name.."')")
	end
end

local meta = FindMetaTable "Player"

--
-- Sets the next time a player can switch teams again
--
function meta:SetNextTeamSwitch(time)
	self:SetNW2Float("NextTeamSwitch", time)
end

--
-- Returns the next time a player can switch teams again
--
function meta:GetNextTeamSwitch()
	return self:GetNW2Float "NextTeamSwitch"
end

--
-- Returns true if a player can join the given team
--
function meta:CanJoinTeam(id)
	return GAMEMODE:PlayerCanJoinTeam(self, id)
end