STATE_PRE_MATCH  = 0
STATE_PRE_ROUND  = 1
STATE_IN_ROUND   = 2
STATE_POST_ROUND = 3
STATE_POST_MATCH = 4

CreateConVar("xft_pre_round_time", 3, FCVAR_NOTIFY + FCVAR_REPLICATED)

if SERVER then
	--
	-- Starts a new round
	--
	function GM:StartRound()
		self:SetState(STATE_PRE_ROUND)
		
		for i, pl in pairs(player.GetAll()) do
			if pl:Team() > 0 then
				pl:Spawn()
			end
		end
		
		timer.Simple(cvars.Number "xft_pre_round_time", function()
			self:SetState(STATE_IN_ROUND)
		end)
	end
end

--
-- Returns the current state of the gamemode
--
function GM:SetState(state)
	SetGlobalInt("XFTState", state)
end

--
-- Returns the current state of the gamemode
--
function GM:GetState()
	return GetGlobalInt "XFTState"
end

--
-- This is just to make sure the game always starts in pre-match, in case GetGlobalInt doesn't
-- return 0 by default for whatever reason
--
hook.Add("Initialize", "XFTPreMatch", function()
	GAMEMODE:SetState(STATE_PRE_MATCH)
end)

--
-- This will make every other player invisible during the pre-match state
--
hook.Add("PreDrawPlayer", "XFTPreMatch", function(pl)
	if GAMEMODE:GetState() == STATE_PRE_MATCH then
		return true
	end
end)

--
-- This will disable all commands during the pre-match and pre-round states
--
hook.Add("StartCommand", "XFTPreMatch", function(pl, cmd)
	if GAMEMODE:GetState() == STATE_PRE_MATCH or GAMEMODE:GetState() == STATE_PRE_ROUND then
		cmd:ClearMovement()
		cmd:ClearButtons()
	end
end)