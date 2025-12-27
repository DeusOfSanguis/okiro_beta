
//Utils
AddCSLuaFile("squads/sh_squad_utils.lua")
include("squads/sh_squad_utils.lua")
//Config with g table
AddCSLuaFile("squads/sh_squad_config.lua")
include("squads/sh_squad_config.lua")
//System as it
AddCSLuaFile("squads/sh_squad_system.lua")
include("squads/sh_squad_system.lua")

//CS Files
AddCSLuaFile("squads/client/cl_squad_gfx.lua")
AddCSLuaFile("squads/client/cl_squad.lua")

if CLIENT then
    include("squads/client/cl_squad_gfx.lua")
    include("squads/client/cl_squad.lua")
else
    include("squads/server/sv_squad.lua")
    include("squads/server/sv_squad_db.lua")
end
