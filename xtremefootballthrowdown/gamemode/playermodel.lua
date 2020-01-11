---------------
-- Variables --
---------------

GM.DefaultPlayerModel = GM.DefaultPlayerModel or ""
GM.PlayerModels = GM.PlayerModels or {
	["models/player/eli.mdl"] = true,
	["models/player/alyx.mdl"] = true,
	["models/player/breen.mdl"] = true,
	["models/player/barney.mdl"] = true,
}

---------------
-- Functions --
---------------

function GM:SetDefaultPlayerModel(mdl)
	self.DefaultPlayerModel = mdl
end

function GM:GetDefaultPlayerModel()
	return self.DefaultPlayerModel
end

function GM:AddPlayerModel(mdl, sounds)
	self.PlayerModels[mdl] = true
end

function GM:RemovePlayerModel(mdl)
	self.PlayerModels[mdl] = nil
end

function GM:GetPlayerModels()
	return self.PlayerModels
end

------------
-- Player --
------------

local meta = FindMetaTable "Player"

function meta:GetPlayerModel(mdl)
	self:SetNW2String("PlayerModel", mdl)
end

function meta:GetPlayerModel()
	return self:GetNW2String "PlayerModel"
end