OInconnu = {}

local function Inclu(f) return include("_okiro_inconnu/" .. f) end
local function AddCS(f) return AddCSLuaFile("_okiro_inconnu/" .. f) end
local function IncAdd(f) return Inclu(f), AddCS(f) end

if SERVER then

	Inclu("server/sv_network.lua")
	AddCS("client/cl_hooks.lua")

else

	Inclu("client/cl_hooks.lua")

end