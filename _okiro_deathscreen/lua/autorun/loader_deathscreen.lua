if SERVER then
	AddCSLuaFile("deathscreen/client/deathscreen.lua")
	include("deathscreen/server/network.lua")
	include("deathscreen/server/playerdeath.lua")
end

if CLIENT then
	include("deathscreen/client/deathscreen.lua")
end