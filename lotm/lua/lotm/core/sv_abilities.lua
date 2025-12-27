-- LOTM Ability System - Server
-- Система регистрации и использования способностей

util.AddNetworkString("LOTM_UseAbility")
util.AddNetworkString("LOTM_AbilityCooldown")
util.AddNetworkString("LOTM_SyncAbilities")

LOTM.Abilities = LOTM.Abilities or {}
LOTM.RegisteredAbilities = LOTM.RegisteredAbilities or {}
LOTM.PlayerAbilities = LOTM.PlayerAbilities or {}
LOTM.PlayerCooldowns = LOTM.PlayerCooldowns or {}

--[[------------------------------------
    Регистрация способности
    @param abilityData - данные способности
    {
        id = "fireball",
        name = "Fireball",
        description = "Launch a fireball",
        icon = "materials/icon.png",
        cooldown = 5,
        manaCost = 20,
        onUse = function(ply, ability) end,
        onHit = function(attacker, victim, hitData) end
    }
--------------------------------------]]
function LOTM.Abilities:Register(abilityData)
    if not abilityData.id then
        ErrorNoHalt("[LOTM] Ability registration failed: missing ID\n")
        return false
    end
    
    self.RegisteredAbilities[abilityData.id] = {
        id = abilityData.id,
        name = abilityData.name or "Unknown Ability",
        description = abilityData.description or "",
        icon = abilityData.icon,
        cooldown = abilityData.cooldown or LOTM.Config.Abilities.DefaultCooldown,
        manaCost = abilityData.manaCost or LOTM.Config.Abilities.DefaultManaCost,
        onUse = abilityData.onUse,
        onHit = abilityData.onHit,
        requiresTarget = abilityData.requiresTarget or false,
        maxRange = abilityData.maxRange or 1000
    }
    
    print("[LOTM] Registered ability: " .. abilityData.id)
    return true
end

--[[------------------------------------
    Выдача способности игроку
--------------------------------------]]
function LOTM.Abilities:GiveToPlayer(ply, abilityID, slot)
    if not IsValid(ply) then return false end
    if not self.RegisteredAbilities[abilityID] then
        ErrorNoHalt("[LOTM] Unknown ability: " .. abilityID .. "\n")
        return false
    end
    
    slot = slot or self:GetFreeSlot(ply)
    if not slot or slot > LOTM.Config.Abilities.MaxAbilities then
        return false
    end
    
    self.PlayerAbilities[ply:SteamID()] = self.PlayerAbilities[ply:SteamID()] or {}
    self.PlayerAbilities[ply:SteamID()][slot] = abilityID
    
    self:SyncToClient(ply)
    return true
end

--[[------------------------------------
    Получение свободного слота
--------------------------------------]]
function LOTM.Abilities:GetFreeSlot(ply)
    local steamID = ply:SteamID()
    self.PlayerAbilities[steamID] = self.PlayerAbilities[steamID] or {}
    
    for i = 1, LOTM.Config.Abilities.MaxAbilities do
        if not self.PlayerAbilities[steamID][i] then
            return i
        end
    end
    
    return nil
end

--[[------------------------------------
    Использование способности
--------------------------------------]]
function LOTM.Abilities:Use(ply, slot)
    if not IsValid(ply) or not ply:Alive() then return false end
    
    local steamID = ply:SteamID()
    local abilityID = self.PlayerAbilities[steamID] and self.PlayerAbilities[steamID][slot]
    
    if not abilityID then return false end
    
    local ability = self.RegisteredAbilities[abilityID]
    if not ability then return false end
    
    -- Проверка кулдауна
    self.PlayerCooldowns[steamID] = self.PlayerCooldowns[steamID] or {}
    local cooldown = self.PlayerCooldowns[steamID][slot]
    
    if cooldown and cooldown > CurTime() then
        return false
    end
    
    -- Проверка маны (если система маны реализована)
    -- if ply:GetMana() < ability.manaCost then
    --     return false
    -- end
    
    -- Использование способности
    if ability.onUse then
        ability.onUse(ply, ability, slot)
    end
    
    -- Установка кулдауна
    self.PlayerCooldowns[steamID][slot] = CurTime() + ability.cooldown
    
    -- Синхронизация кулдауна с клиентом
    net.Start("LOTM_AbilityCooldown")
        net.WriteUInt(slot, 8)
        net.WriteFloat(ability.cooldown)
    net.Send(ply)
    
    return true
end

--[[------------------------------------
    Синхронизация способностей с клиентом
--------------------------------------]]
function LOTM.Abilities:SyncToClient(ply)
    if not IsValid(ply) then return end
    
    local steamID = ply:SteamID()
    local abilities = self.PlayerAbilities[steamID] or {}
    
    net.Start("LOTM_SyncAbilities")
        net.WriteTable(abilities)
    net.Send(ply)
end

-- Обработка использования способностей от клиента
net.Receive("LOTM_UseAbility", function(len, ply)
    local slot = net.ReadUInt(8)
    LOTM.Abilities:Use(ply, slot)
end)

-- Синхронизация при подключении
hook.Add("PlayerInitialSpawn", "LOTM_SyncAbilities", function(ply)
    timer.Simple(1, function()
        if IsValid(ply) then
            LOTM.Abilities:SyncToClient(ply)
        end
    end)
end)