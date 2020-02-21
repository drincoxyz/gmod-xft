local conf = {}

if CLIENT then
	language.Add('team_joined', {
		en = '%s joined the %s.',
		fr = '%s a rejoint les %s.',
	})
	
	language.Add('team_deny_invalid', {
		en = 'That team is invalid.',
		fr = "Cette équipe n'est pas valide.",
	})
	
	language.Add('team_deny_already', {
		en = "You're already on the %s.",
		fr = "Vous êtes déjà dans l'équipe %s.",
	})
end

---------------------------------------------------------------------------------------------------

TEAM_SPECTATOR = 0
TEAM_RED       = 1
TEAM_BLUE      = 2

function GM:PlayerRequestTeam(pl, teamid)
	local teamid = tonumber(teamid) or -1
	local canjoin, reason = pl:CanJoinTeam(teamid)

	if canjoin then
		pl:SetTeam(teamid)
		pl:Spawn()
		self:AnnouncePlayerTeamJoin(pl, teamid)
		return
	end
	
	pl:PrintTeamJoinDenyReason(reason, teamid)
end

function GM:AnnouncePlayerTeamJoin(pl, teamid)
	if SERVER then
		BroadcastLua('GAMEMODE:AnnouncePlayerTeamJoin(Player('..pl:UserID()..'), '..teamid..')')
	elseif CLIENT then
		chat.AddText(language.GetPhrase 'team_joined':format(pl:Nick(), team.GetName(teamid)))
	end
end

function GM:CreateTeams()
	team.SetUp(TEAM_SPECTATOR, 'Spectators', Color(220, 220, 220), false)
	team.SetUp(TEAM_RED, 'Red Rhinos', Color(255, 0, 0), true)
	team.SetUp(TEAM_BLUE, 'Blue Bulls', Color(0, 100, 255), true)
	
	team.SetSpawnPoint(TEAM_SPECTATOR, {'info_player_spectate'})
	team.SetSpawnPoint(TEAM_RED, {'info_player_red'})
	team.SetSpawnPoint(TEAM_BLUE, {'info_player_blue'})
end

local meta = FindMetaTable 'Player'

function meta:CanJoinTeam(teamid)
	local teamid = teamid or -1
	
	if !team.Valid(teamid)then
		return false, '#team_deny_invalid'
	end

	local curteam = self:Team()
	
	if teamid == curteam then
		return false, '#team_deny_already'
	end

	return true
end

function meta:PrintTeamJoinDenyReason(reason, teamid)
	if SERVER then
		self:SendLua('Player('..self:UserID()..'):PrintTeamJoinDenyReason("'..reason..'", '..teamid..')')
	elseif CLIENT then
		local msg
		
		if reason == '#team_deny_already' then
			msg = language.GetPhrase(reason):format(team.GetName(teamid))
		elseif reason == '#team_deny_invalid' then
			msg = language.GetPhrase(reason)
		end
		
		chat.AddText(msg)
	end
end