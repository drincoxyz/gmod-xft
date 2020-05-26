function GM:DoPlayerDeath(pl, killer, dmg)
	pl:CreateRagdoll()
end

function GM:PlayerDeathSound()
	return true
end
