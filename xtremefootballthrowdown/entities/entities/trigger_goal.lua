--
-- ! DEPRECATED ENTITY !
--

ENT.Type       = "brush"
ENT.BrushModel = ""
ENT.Slot       = 0

function ENT:KeyValue(key, val)
	if key == "teamid" then
		self.Slot = math.floor(tonumber(val))
	elseif key == "model" then
		self.BrushModel = val
	end
end