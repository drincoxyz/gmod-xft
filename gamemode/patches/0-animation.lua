-- https://gist.github.com/drincoxyz/0eda488d1e02232a8f449ae4efa87dab
-- this patches player model functions to allow for custom animation models (models/*_anm.mdl)
-- this is a very intrusive patch and should only be used if you are 100% set on using custom animations
-- custom animation models MUST have a mesh of some kind (will be invisible in-game) in order to work
-- as a result of ^, m_anm.mdl and f_anm.mdl will NOT work with this patch
-- additionally, any custom ACT_ enums the animation model has will be generated automatically

local function GenAct(pl)
	for i, seq in pairs(pl:GetSequenceList()) do
		local actname = pl:GetSequenceActivityName(i)
		
		if actname != '' then
			local actid = pl:GetSequenceActivity(i)
			_G[actname] = actid
		end
	end
end

local player = FindMetaTable 'Player'
local entity = FindMetaTable 'Entity'

player._SetModel     = player._SetModel or entity.SetModel
player._GetModel     = player._GetModel or entity.GetModel
player._GetModelName = player._GetModelName or entity.GetModelName
player._DrawModel    = player._DrawModel or entity.DrawModel

local meta = player

function meta:SetModel(mdl)
	self:SetNW2String('model', mdl)
end

function meta:GetModel()
	return self:GetNW2String 'model'
end

function meta:SetAnimationModel(mdl)
	self:_SetModel(mdl)
	self:SetColor(Color(255, 255, 255, 0))
	GenAct(self)
end

function meta:GetAnimationModel()
	return self:_GetModel()
end

function meta:DrawModel()
	local ent = self:GetVisualModelEntity()

	if ent:IsValid() then
		ent:DrawModel()
	end
end

if SERVER then return end

function meta:CreateVisualModelEntity()
	local ent = self:GetVisualModelEntity()
	
	if ent:IsValid() then
		ent:Remove()
	end
	
	local mdl = self:GetModel()
	local ent = ClientsideModel(mdl)
	
	if ent:IsValid() then
		ent:SetModel(mdl)
		ent:SetOwner(self)
		ent:SetParent(self)
		ent:DrawShadow(true)
		ent:SetLocalPos(Vector())
		ent:SetLocalAngles(Angle())
		ent:AddEffects(EF_BONEMERGE)
		ent:AddEffects(EF_BONEMERGE_FASTCULL)
		
		self:SetVisualModelEntity(ent)
		GenAct(self)
		
		hook.Add("Think", ent, function()
			if !self:IsValid() then
				return ent:Remove()
			end
			
			local mdl    = self:GetModel()
			local entmdl = ent:GetModel()
			
			if entmdl != mdl then
				ent:SetModel(mdl)
			end
			
			function ent.GetPlayerColor()
				return self:IsValid() and self:GetPlayerColor() or Vector()
			end
		end)
	end
end

function meta:SetVisualModelEntity(ent)
	self.visualmdlent = ent
end

function meta:GetVisualModelEntity()
	self.visualmdlent = self.visualmdlent or NULL
	return self.visualmdlent
end

hook.Add('PrePlayerDraw', 'animpatch', function(pl)
	local ent = pl:GetVisualModelEntity()
	
	if !ent:IsValid() then
		pl:CreateVisualModelEntity()
	else
		ent:CreateShadow()
	end
end)