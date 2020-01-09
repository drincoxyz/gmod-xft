-- Init

include      "shared.lua"
AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

-- Server

include "spawn.lua"
include "damage.lua"

-- Client

include      "camera.lua"
AddCSLuaFile "language.lua"
AddCSLuaFile "camera.lua"

-- Shared

include      "optimize.lua"
include      "teams.lua"
include      "movement.lua"
include      "animation.lua"
include      "footstep.lua"
AddCSLuaFile "optimize.lua"
AddCSLuaFile "teams.lua"
AddCSLuaFile "movement.lua"
AddCSLuaFile "animation.lua"
AddCSLuaFile "footstep.lua"