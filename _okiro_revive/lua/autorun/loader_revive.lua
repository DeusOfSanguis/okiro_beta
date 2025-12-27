if SERVER then
	AddCSLuaFile("revive/client/revive.lua")
	include("revive/server/network.lua")
	include("revive/server/hook.lua")
end

if CLIENT then
	include("revive/client/revive.lua")
end