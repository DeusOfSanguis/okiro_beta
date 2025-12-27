--[[
    Addon : EliteWeaponSelector
    By : Esteb
	Support : !Esteb.#6666
	Version : 2.0
--]]

--[[
╔═╗╔═╗╔═╗  ╔╦╗╔═╗  ╔═╗╔═╗╔╗╔╔═╗╦╔═╗  ╦╔═╗╦
╠═╝╠═╣╚═╗   ║║║╣   ║  ║ ║║║║╠╣ ║║ ╦  ║║  ║
╩  ╩ ╩╚═╝  ═╩╝╚═╝  ╚═╝╚═╝╝╚╝╚  ╩╚═╝  ╩╚═╝╩
--]]

include("eliteswephud/sh_config.lua");

if (SERVER) then 

	AddCSLuaFile("eliteswephud/sh_config.lua");
	AddCSLuaFile("eliteswephud/cl_hud.lua");
else 

	include("eliteswephud/cl_hud.lua");
end