--
-- ! DEPRECATED ENTITY !
--

ENT.Type = "brush"

function ENT:KeyValue(key, val)
	if key == "model" then
		self.BrushModel = val
	end
end

function ENT:SetBrushModel(mdl)
	self.BrushModel = tostring(mdl)
end

function ENT:GetBrushModel()
	return self.BrushModel
end