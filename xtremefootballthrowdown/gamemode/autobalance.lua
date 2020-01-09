CreateConVar("xft_auto_balance", 1, FCVAR_NOTIFY)
CreateConVar("xft_auto_balance_bots", 1, FCVAR_NOTIFY)

hook.Add("OnPlayerChangedTeam", "XFTAutoBalance", function(pl, old, new)
	if not cvars.Bool "xft_auto_balance" then return end
end)