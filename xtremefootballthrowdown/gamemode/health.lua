--
-- Functions
--

function GM:SetHealthRegenAmount(amount)
	SetGlobalFloat("xft_health_regen_amount", tonumber(amount))
end

function GM:GetHealthRegenAmount()
	return GetGlobalFloat "xft_health_regen_amount"
end

function GM:SetHealthRegenCooldown(cooldown)
	SetGlobalFloat("xft_health_regen_cooldown", tonumber(cooldown))
end

function GM:GetHealthRegenCooldown()
	return GetGlobalFloat "xft_health_regen_cooldown"
end

function GM:SetHealthRegenInterval(int)
	SetGlobalFloat("xft_health_regen_interval", tonumber(int))
end

function GM:GetHealthRegenInterval()
	return GetGlobalFloat "xft_health_regen_interval"
end

--
-- ConVars
--

GM:SetHealthRegenAmount(CreateConVar("xft_health_regen_amount", 1, FCVAR_NOTIFY + FCVAR_REPLICATED):GetFloat())
GM:SetHealthRegenInterval(CreateConVar("xft_health_regen_interval", .25, FCVAR_NOTIFY + FCVAR_REPLICATED):GetFloat())
GM:SetHealthRegenCooldown(CreateConVar("xft_health_regen_cooldown", 3, FCVAR_NOTIFY + FCVAR_REPLICATED):GetFloat())

cvars.AddChangeCallback("xft_health_regen_amount", function(cvar, old, new)
	GAMEMODE:SetHealthRegenAmount(tonumber(new))
end, "Default")

cvars.AddChangeCallback("xft_health_regen_interval", function(cvar, old, new)
	GAMEMODE:SetHealthRegenInterval(tonumber(new))
end, "Default")

cvars.AddChangeCallback("xft_health_regen_cooldown", function(cvar, old, new)
	GAMEMODE:SetHealthRegenCooldown(tonumber(new))
end, "Default")

--
-- Hooks
--

if SERVER then
	hook.Add("EntityTakeDamage", "xft_health", function(ent, dmg)
		if not ent:IsPlayer() then return end
		ent:SetNextHealthRegen(CurTime() + GAMEMODE:GetHealthRegenCooldown())
	end)

	hook.Add("Move", "xft_health", function(pl, mv)
		if not pl:Alive() or CurTime() < pl:GetNextHealthRegen() then return end
		
		local health = pl:Health()
		local maxHealth = pl:GetMaxHealth()
		
		if health >= maxHealth then return end
		
		pl:SetHealth(math.min(health + GAMEMODE:GetHealthRegenAmount(), maxHealth))
		pl:SetNextHealthRegen(CurTime() + GAMEMODE:GetHealthRegenInterval())
	end)
end

--
-- Player
--

local meta = FindMetaTable "Player"

--
-- Name: Player:SetNextHealthRegen
-- Desc: Set the next time the player can regenerate health.
--
-- Arguments
--
-- [1] number - Next regen time.
--
function meta:SetNextHealthRegen(time)
	self:SetNW2Float("xft_next_health_regen", tonumber(time))
end

--
-- Name: Player:GetNextHealthRegen
-- Desc: Returns the next time the player can regenerate health.
--
-- Returns
--
-- [1] number - Next regen time.
--
function meta:GetNextHealthRegen()
	return self:GetNW2Float "xft_next_health_regen"
end