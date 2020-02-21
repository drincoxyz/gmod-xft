local conf = {}

---------------------------------------------------------------------------------------------------

function GM:EntityEmitSound(snd)
	local timescale = game.GetTimeScale()

	if timescale != 1 then
		local ent = snd.Entity
		
		if ent and ent:IsValid() then
			if ent:IsPlayer() or ent:GetMoveType() ~= MOVETYPE_NONE then
				snd.Pitch = math.Clamp(snd.Pitch * math.Clamp(timescale ^ 0.6, 0.4, 3), 10, 255)
				snd.DSP = 21
				return true
			end
		end
	end
end