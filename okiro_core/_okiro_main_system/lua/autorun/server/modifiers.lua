
ModifierSystem = ModifierSystem or {}

local player_modifiers = {}
local BASE_STATS = {
    walk_speed = 200,
    run_speed = 400,
    health = 100,
    armor = 0,
    jump_power = 200
}

local function GetPlayerModifiers(ply)
    if not IsValid(ply) then 
        return {} 
    end
    local steamID = ply:SteamID()
    player_modifiers[steamID] = player_modifiers[steamID] or {}
    return player_modifiers[steamID]
end

local function RemoveModifierInternal(ply, mod_id)
    if not IsValid(ply) then return end
    
    local modifiers = GetPlayerModifiers(ply)
    if not modifiers[mod_id] then return end
    
    local mod_data = modifiers[mod_id]
    modifiers[mod_id] = nil
    
    local timer_id = "modifier_" .. mod_id .. "_" .. ply:SteamID()
    if timer.Exists(timer_id) then
        timer.Remove(timer_id)
    end
    
    ModifierSystem:RecalculateAll(ply)
    
    if mod_data.on_removed then
        mod_data.on_removed(ply)
    end
end

function ModifierSystem:AddModifier(ply, mod_id, mod_data)
    
    if not IsValid(ply) then return false end
    if not mod_id or not mod_data then return false end
    
    local modifiers = GetPlayerModifiers(ply)
    
    if modifiers[mod_id] then
        RemoveModifierInternal(ply, mod_id)
    end
    
    modifiers[mod_id] = {
        type = mod_data.type or "generic",
        value = mod_data.value or 0,
        priority = mod_data.priority or 1,
        duration = mod_data.duration,
        on_applied = mod_data.on_applied,
        on_removed = mod_data.on_removed,
        end_time = mod_data.duration and (CurTime() + mod_data.duration) or nil
    }
    
    if mod_data.on_applied then
        mod_data.on_applied(ply)
    end
    
    if mod_data.duration then
        local timer_id = "modifier_" .. mod_id .. "_" .. ply:SteamID()
        timer.Create(timer_id, mod_data.duration, 1, function()
            if IsValid(ply) then
                RemoveModifierInternal(ply, mod_id)
            end
        end)
    end
    
    ModifierSystem:RecalculateAll(ply)
    
    return true
end

function ModifierSystem:RecalculateAll(ply)
    
    if not IsValid(ply) then 
       debug.Trace()
        return 
    end
    
    local modifiers = GetPlayerModifiers(ply)
    local speed_mods = {}
    local health_mods = {}
    local armor_mods = {}
    local jump_mods = {}
    
    for id, mod in pairs(modifiers) do
        if mod.type == "speed" then
            table.insert(speed_mods, mod)
        elseif mod.type == "health" then
            table.insert(health_mods, mod)
        elseif mod.type == "armor" then
            table.insert(armor_mods, mod)
        elseif mod.type == "jump" then
            table.insert(jump_mods, mod)
        end
    end
    
    local speed_bonus = 0
    for _, mod in pairs(speed_mods) do
        speed_bonus = speed_bonus + mod.value
    end
    
    local speed_multiplier = 1 + (speed_bonus / 100)
    speed_multiplier = math.Clamp(speed_multiplier, 0.5, 2.75)
    
    ply:SetWalkSpeed(BASE_STATS.walk_speed * speed_multiplier)
    ply:SetRunSpeed(BASE_STATS.run_speed * speed_multiplier)
    
    local health_bonus = 0
    for _, mod in pairs(health_mods) do
        health_bonus = health_bonus + mod.value
    end
    
    local new_max_health = BASE_STATS.health + health_bonus
    ply:SetMaxHealth(new_max_health)
    if ply:Health() > new_max_health then
        ply:SetHealth(new_max_health)
    end
    
    local armor_bonus = 0
    for _, mod in pairs(armor_mods) do
        armor_bonus = armor_bonus + mod.value
    end
    
    ply:SetArmor(BASE_STATS.armor + armor_bonus)
    
    local jump_bonus = 0
    for _, mod in pairs(jump_mods) do 
        jump_bonus = jump_bonus + mod.value
    end 

    ply:SetJumpPower(BASE_STATS.jump_power + jump_bonus)
end







hook.Add("PlayerSay", "ModifierDebugTest", function(ply, text)
    if text == "w" then
        print("\n[TEST] === Starting test ===")
        ModifierSystem:AddModifier(ply, "test_speed", {
            type = "jump",
            value = 220,
            duration = 5,
            on_applied = function(p) 
            end,
            on_removed = function(p) 
            end
        })
        return ""
    end
end)