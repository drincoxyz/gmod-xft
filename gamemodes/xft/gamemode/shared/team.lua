TEAM_SPECTATOR = 0
TEAM_RED       = 1
TEAM_BLUE      = 2

function GM:CreateTeams()
	team.SetUp(TEAM_SPECTATOR, "Red Rhinos", Color(255, 255, 255), true)
	team.SetUp(TEAM_RED,       "Red Rhinos", Color(255, 0, 0),     true)
	team.SetUp(TEAM_BLUE,      "Blue Bulls", Color(0, 0, 255),     true)
end
