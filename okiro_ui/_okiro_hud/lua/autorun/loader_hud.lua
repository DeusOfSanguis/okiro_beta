if SERVER then
	AddCSLuaFile("hud/client/hud.lua")
end

if CLIENT then
	include("hud/client/hud.lua")
end