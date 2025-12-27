-- Loader file for 'wasied_enhanced_voice'
-- Automatically created by gcreator (github.com/MaaxIT)
EVoice = {}

-- Make loading functions
local function Inclu(f) return include("wasied_enhanced_voice/"..f) end
local function AddCS(f) return AddCSLuaFile("wasied_enhanced_voice/"..f) end
local function IncAdd(f) return Inclu(f), AddCS(f) end

-- Load addon files
IncAdd("config.lua")
IncAdd("constants.lua")
IncAdd("shared/sh_local_nw_vars.lua")
IncAdd("shared/sh_functions.lua")
IncAdd("shared/sh_meta.lua")

if SERVER then

	resource.AddSingleFile("materials/evoice/left-click.png")
	resource.AddSingleFile("materials/evoice/right-click.png")
	resource.AddSingleFile("materials/evoice/frequency.png")

	Inclu("server/sv_functions.lua")
	Inclu("server/sv_hooks.lua")
	Inclu("server/sv_network.lua")
	Inclu("server/sv_meta.lua")

	AddCS("client/cl_functions.lua")
	AddCS("client/cl_hooks.lua")
	AddCS("client/cl_network.lua")

else

	Inclu("client/cl_functions.lua")
	Inclu("client/cl_hooks.lua")
	Inclu("client/cl_network.lua")

end

print("[Wasied - Enhanced Voice] Addon successfully loaded!")