------------------
-- Enumerations --
------------------

STATE_PRE_MATCH  = 0
STATE_PRE_ROUND  = 1
STATE_IN_ROUND   = 2
STATE_POST_ROUND = 3
STATE_POST_MATCH = 4

-------------
-- ConVars --
-------------

CreateConVar("xft_match_time", 600, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_overtime_time", 300, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_pre_match_time", 30, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("xft_pre_round_time", 3, FCVAR_NOTIFY + FCVAR_REPLICATED)
CreateConVar("_xft_state", 0, FCVAR_REPLICATED)

---------------
-- Functions --
---------------

if SERVER then
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

function GM:SetState(state)
	RunConsoleCommand("_xft_state", math.floor(tonumber(state)))
end

function GM:GetState()
	return cvars.Number "_xft_state"
end

function GM:GetClock()
	local matchTime = cvars.Number "xft_match_time"
	
	if CurTime() > matchTime then
		matchTime = matchTime + cvars.Number "xft_overtime_time"
	end

	return matchTime - CurTime()
end

-----------
-- Hooks --
-----------

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