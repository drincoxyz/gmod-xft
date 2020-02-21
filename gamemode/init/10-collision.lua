local conf = {}

---------------------------------------------------------------------------------------------------

function GM:ShouldCollide(ent1, ent2)
	if ent1:IsPlayer() and ent2:IsPlayer() then
		return false
	end
	
	return true
end