-- LOTM Ability System - Client
-- Клиентская часть системы способностей

LOTM.Abilities = LOTM.Abilities or {}
LOTM.ClientAbilities = LOTM.ClientAbilities or {}
LOTM.ClientCooldowns = LOTM.ClientCooldowns or {}

--[[------------------------------------
    Использование способности
--------------------------------------]]
function LOTM.Abilities:UseAbility(slot)
    net.Start("LOTM_UseAbility")
        net.WriteUInt(slot, 8)
    net.SendToServer()
end

-- Получение кулдауна
net.Receive("LOTM_AbilityCooldown", function()
    local slot = net.ReadUInt(8)
    local cooldown = net.ReadFloat()
    
    LOTM.ClientCooldowns[slot] = CurTime() + cooldown
end)

-- Синхронизация способностей
net.Receive("LOTM_SyncAbilities", function()
    LOTM.ClientAbilities = net.ReadTable()
end)

--[[------------------------------------
    Проверка доступности способности
--------------------------------------]]
function LOTM.Abilities:IsReady(slot)
    local cooldown = LOTM.ClientCooldowns[slot]
    if not cooldown then return true end
    
    return CurTime() >= cooldown
end

--[[------------------------------------
    Получение оставшегося кулдауна
--------------------------------------]]
function LOTM.Abilities:GetCooldownRemaining(slot)
    local cooldown = LOTM.ClientCooldowns[slot]
    if not cooldown then return 0 end
    
    return math.max(0, cooldown - CurTime())
end