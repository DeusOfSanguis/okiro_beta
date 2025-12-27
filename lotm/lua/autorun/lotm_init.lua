-- LOTM System Initialization
-- Автозагрузка основной системы

if SERVER then
    AddCSLuaFile()
    print("[LOTM] Initializing Lord of the Mysteries system...")
end

-- Загрузка модулей
if SERVER then
    include("lotm/core/sv_hitbox.lua")
    include("lotm/core/sv_abilities.lua")
    include("lotm/core/sv_keybinds.lua")
    
    AddCSLuaFile("lotm/core/cl_hitbox.lua")
    AddCSLuaFile("lotm/core/cl_abilities.lua")
    AddCSLuaFile("lotm/core/cl_keybinds.lua")
    AddCSLuaFile("lotm/ui/cl_keybind_menu.lua")
else
    include("lotm/core/cl_hitbox.lua")
    include("lotm/core/cl_abilities.lua")
    include("lotm/core/cl_keybinds.lua")
    include("lotm/ui/cl_keybind_menu.lua")
end

if SERVER then
    print("[LOTM] System initialized successfully!")
end