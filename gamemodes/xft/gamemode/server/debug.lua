local debug = CreateConVar(GM.FolderName.."_debug", 0, FCVAR_NOTIFY, "Enables debugging information."):GetBool()

cvars.RemoveChangeCallback(GM.FolderName.."_debug", "default")
cvars.AddChangeCallback(GM.FolderName.."_debug", function(cvar, old, new)
	debug = tobool(new)
end, "default")

function GM:DebugEnabled()
	return debug
end
