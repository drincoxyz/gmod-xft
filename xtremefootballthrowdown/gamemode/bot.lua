local botNames = {
	"William",
	"Brandon",
	"Brendan",
	"Joseph",
	"Frank",
	"Pablo",
	"Future",
	"Isaac",
	"Justin",
	"Madden",
	"Jesse",
	"Eric",
}

CreateConVar("xft_bots", 1, FCVAR_NOTIFY)

concommand.Add("xft_bot_add" , function(pl, cmd, args, argStr)
	local pl = player.CreateNextBot(botNames[math.random(#botNames)].." Bot")
	local id = tonumber(args[1] or 0)
	
	if not IsValid(pl) then return end
	
	if id > 0 then
		pl:SetTeam(id)
	else
	end
	
	pl:Spawn()
end)

hook.Add("StartCommand", "XFTBot", function(pl, cmd)
	if not pl:IsBot() then return end
	
	-- Reset command
	cmd:ClearMovement()
	cmd:ClearButtons()
end)