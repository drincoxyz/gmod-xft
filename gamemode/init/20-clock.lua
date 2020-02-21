local conf = {
	matchlen   = CreateConVar('xft_match_length', 600, FCVAR_REPLICATED + FCVAR_NOTIFY, 'amount of seconds a match can play for without overtime'):GetInt(),
	waitlen    = CreateConVar('xft_wait_length', 30, FCVAR_REPLICATED + FCVAR_NOTIFY, 'amount of seconds before a match starts'):GetInt(),
	otlen      = CreateConVar('xft_overtime_length', 180, FCVAR_REPLICATED + FCVAR_NOTIFY, 'amount of seconds a match can be in overtime before ending'):GetInt(),
	startdelay = 3,
	nextdelay  = 5,
}

STAGE_PRE_MATCH   = 0
STAGE_PRE_ROUND   = 1
STAGE_IN_ROUND    = 2
STAGE_IN_OVERTIME = 3
STAGE_POST_ROUND  = 4
STAGE_POST_MATCH  = 5

cvars.RemoveChangeCallback('xft_match_length', 'default')
cvars.AddChangeCallback('xft_match_length', function(cvar, old, new)
	conf.matchlen = tonumber(new)
end, 'default')

cvars.RemoveChangeCallback('xft_wait_length', 'default')
cvars.AddChangeCallback('xft_wait_length', function(cvar, old, new)
	conf.waitlen = tonumber(new)
end, 'default')

cvars.RemoveChangeCallback('xft_overtime_length', 'default')
cvars.AddChangeCallback('xft_overtime_length', function(cvar, old, new)
	conf.otlen = tonumber(new)
end, 'default')

---------------------------------------------------------------------------------------------------

hook.Add('Think', 'stage', function()
	if CLIENT then return end

	local time  = CurTime()
	local clock = GAMEMODE:GetClock()
	local stage = GAMEMODE:GetStage()

	if stage == STAGE_PRE_MATCH then
		if time >= conf.waitlen then
			GAMEMODE:StartRound()
		end
	elseif stage == STAGE_PRE_ROUND then
		local start = GAMEMODE:GetRoundStart()
		
		if time >= start then
			GAMEMODE:SetStage(STAGE_IN_ROUND)
		end
	elseif stage == STAGE_POST_ROUND then
		local next = GAMEMODE:GetNextRound()
		
		if time >= next then
			GAMEMODE:StartRound()
		end
	end
end)

function GM:SetAddClock(add)
	SetGlobalFloat('add_clock', add)
end

function GM:AddClock(add)
	self:SetAddClock(self:GetAddClock() + add)
end

function GM:GetAddClock()
	return GetGlobalFloat 'add_clock'
end

function GM:GetClock()
	return math.Clamp(conf.matchlen - CurTime() + conf.waitlen + self:GetAddClock(), 0, conf.matchlen)
end

function GM:GetOvertimeClock()
	return math.clamp(self:GetClock() + conf.otlen, 0, conf.otlen)
end

function GM:StartRound()
	local time = CurTime()
	local ball = self:GetBall()
	
	if ball:IsValid() then
		ball:Reset(true)
	end

	self:SetStage(STAGE_PRE_ROUND)
	self:AddClock(conf.startdelay)
	self:SetRoundStart(time + conf.startdelay)

	for i, pl in pairs(player.GetAll()) do
		local teamid = pl:Team()
		
		if team.Joinable(teamid) then
			pl:Spawn()
		end
	end
end

function GM:EndRound()
	local time = CurTime()

	self:SetStage(STAGE_POST_ROUND)
	self:AddClock(conf.nextdelay)
	self:SetNextRound(time + conf.nextdelay)
end

function GM:SetStage(stage)
	SetGlobalInt('stage', stage)
end

function GM:GetStage()
	return GetGlobalInt 'stage'
end

function GM:SetNextRound(time)
	SetGlobalFloat('next_round', time)
end

function GM:GetNextRound()
	return GetGlobalFloat 'next_round'
end

function GM:SetRoundStart(time)
	SetGlobalFloat('round_start', time)
end

function GM:GetRoundStart()
	return GetGlobalFloat 'round_start'
end