-- https://gist.github.com/drincoxyz/0eda488d1e02232a8f449ae4efa87dab
-- this patches the team library to improve the team.BestAutoJoinTeam function
-- teams with an ID of less than 1 or greater than 999 are ignored (to exclude the dumb TEAM_UNASSIGNED team)
-- teams are also iterated through in a random order, making it so a random team is used if they are balanced

local team = team

function team.BestAutoJoinTeam()
	local SmallestTeam, SmallestPlayers
	local teams = team.GetAllTeams()

	for id, tm in RandomPairs(teams) do
		if id > 0 and id < 1000 and tm.Joinable then
			local PlayerCount = team.NumPlayers(id)
			
			if !SmallestTeam or !SmallestPlayers or PlayerCount < SmallestPlayers or (PlayerCount == SmallestPlayers and id < SmallestTeam) then
				SmallestPlayers = PlayerCount
				SmallestTeam = id
			end
		end
	end

	return SmallestTeam
end