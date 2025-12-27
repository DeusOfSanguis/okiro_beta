OKIRO = OKIRO or {}

if SERVER then
	AddCSLuaFile("whitelist/config/core.lua")
	AddCSLuaFile("whitelist/vgui/panelwl.lua")
	include("whitelist/config/core.lua")
	include("whitelist/sql/table.lua")
	include("whitelist/net/utils.lua")
	include("whitelist/net/request.lua")
	include("whitelist/net/add.lua")
	include("whitelist/net/remove.lua")
	include("whitelist/hook/connect.lua")
end

if CLIENT then
	include("whitelist/config/core.lua")
	include("whitelist/vgui/panelwl.lua")
end