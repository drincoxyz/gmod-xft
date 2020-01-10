-- Init

include      "shared.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

-- Server

include "bot.lua"
include "eft.lua"
include "spawn.lua"
include "damage.lua"
include "autobalance.lua"

-- Client

AddCSLuaFile "language.lua"
AddCSLuaFile "hud.lua"

-- Shared

include      "item.lua"
include      "state.lua"
include      "goal.lua"
include      "camera.lua"
include      "optimize.lua"
include      "teams.lua"
include      "movement.lua"
include      "animation.lua"
include      "footstep.lua"
AddCSLuaFile "item.lua"
AddCSLuaFile "state.lua"
AddCSLuaFile "goal.lua"
AddCSLuaFile "camera.lua"
AddCSLuaFile "optimize.lua"
AddCSLuaFile "teams.lua"
AddCSLuaFile "movement.lua"
AddCSLuaFile "animation.lua"
AddCSLuaFile "footstep.lua"