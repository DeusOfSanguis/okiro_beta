-- LOTM System Initialization
-- Автозагрузка основной системы Lord of the Mysteries

if SERVER then
    AddCSLuaFile()
    print("[LOTM] Initializing Lord of the Mysteries system...")
end

-- Загрузка конфига
include("lotm/core/sh_config.lua")
if SERVER then AddCSLuaFile("lotm/core/sh_config.lua") end

-- Загрузка продвинутой системы хитбоксов
include("lotm/core/sh_hitbox_advanced.lua")
if SERVER then AddCSLuaFile("lotm/core/sh_hitbox_advanced.lua") end

-- Загрузка системы атак
include("lotm/core/sh_attack_system.lua")
if SERVER then AddCSLuaFile("lotm/core/sh_attack_system.lua") end

-- Загрузка старых систем (совместимость)
if SERVER then
    include("lotm/core/sv_hitbox.lua")
    include("lotm/core/sv_abilities.lua")
    include("lotm/core/sv_keybinds.lua")
    
    AddCSLuaFile("lotm/core/cl_hitbox.lua")
    AddCSLuaFile("lotm/core/cl_abilities.lua")
    AddCSLuaFile("lotm/core/cl_keybinds.lua")
    AddCSLuaFile("lotm/ui/cl_keybind_menu.lua")
    AddCSLuaFile("lotm/ui/cl_keybinds_modern.lua")
else
    include("lotm/core/cl_hitbox.lua")
    include("lotm/core/cl_abilities.lua")
    include("lotm/core/cl_keybinds.lua")
    include("lotm/ui/cl_keybind_menu.lua")
    include("lotm/ui/cl_keybinds_modern.lua")
end

-- Консольная команда для открытия нового меню
if CLIENT then
    concommand.Add("lotm_keybinds", function()
        LOTM.UI.OpenKeybindMenu()
    end)
    
    concommand.Add("lotm_test_attack", function(ply, cmd, args)
        local attackID = args[1] or "basic_melee"
        RunConsoleCommand("lotm_use_attack", attackID)
    end)
end

-- Серверная команда для использования атак
if SERVER then
    concommand.Add("lotm_use_attack", function(ply, cmd, args)
        if not IsValid(ply) then return end
        local attackID = args[1] or "basic_melee"
        LOTM.AttackSystem:Execute(ply, attackID)
    end)
end

if SERVER then
    print("[LOTM] ✓ System initialized successfully!")
    print("[LOTM] ✓ Advanced Hitbox System loaded")
    print("[LOTM] ✓ Attack Registry System loaded")
    print("[LOTM] ✓ Modern UI loaded")
else
    print("[LOTM] ✓ Client systems loaded")
    print("[LOTM] Use F4 or 'lotm_keybinds' to open keybind menu")
    print("[LOTM] Use 'lotm_test_attack <attackID>' to test attacks")
end