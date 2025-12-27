if SERVER then
	AddCSLuaFile("ost/client/vgui/core.lua")
end

if CLIENT then
	include("ost/client/vgui/core.lua")
end