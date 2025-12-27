-- LOTM Hitbox System - Server
-- Система регистрации и обработки хитбоксов

util.AddNetworkString("LOTM_HitboxDamage")
util.AddNetworkString("LOTM_RegisterHitbox")

LOTM.Hitboxes = LOTM.Hitboxes or {}
LOTM.HitboxRegistry = LOTM.HitboxRegistry or {}

--[[------------------------------------
    Регистрация хитбокса для способности
    @param entity - сущность владельца
    @param hitboxData - данные хитбокса
    {
        id = "unique_id",
        bone = "ValveBiped.Bip01_Head1", -- или координаты
        radius = 10,
        damageType = DMG_SLASH,
        damage = 50,
        callback = function(attacker, victim, hitbox) end
    }
--------------------------------------]]
function LOTM.Hitboxes:Register(entity, hitboxData)
    if not IsValid(entity) then return end
    
    local id = hitboxData.id or "hitbox_" .. CurTime()
    
    self.HitboxRegistry[id] = {
        entity = entity,
        bone = hitboxData.bone,
        offset = hitboxData.offset or Vector(0, 0, 0),
        radius = hitboxData.radius or 10,
        damageType = hitboxData.damageType or DMG_GENERIC,
        damage = hitboxData.damage or 10,
        duration = hitboxData.duration or 1,
        created = CurTime(),
        callback = hitboxData.callback,
        ignoreOwner = hitboxData.ignoreOwner != false,
        teams = hitboxData.teams -- опционально: только определенные команды
    }
    
    -- Автоудаление по истечению времени
    timer.Simple(hitboxData.duration or 1, function()
        self:Unregister(id)
    end)
    
    return id
end

--[[------------------------------------
    Удаление хитбокса
--------------------------------------]]
function LOTM.Hitboxes:Unregister(id)
    self.HitboxRegistry[id] = nil
end

--[[------------------------------------
    Получение позиции хитбокса
--------------------------------------]]
function LOTM.Hitboxes:GetPosition(hitboxData)
    if not IsValid(hitboxData.entity) then return nil end
    
    if hitboxData.bone then
        local boneID = hitboxData.entity:LookupBone(hitboxData.bone)
        if boneID then
            local pos, ang = hitboxData.entity:GetBonePosition(boneID)
            return pos + hitboxData.offset
        end
    end
    
    return hitboxData.entity:GetPos() + hitboxData.offset
end

--[[------------------------------------
    Проверка попадания
--------------------------------------]]
function LOTM.Hitboxes:CheckHit(id, targetPos, targetEntity)
    local hitbox = self.HitboxRegistry[id]
    if not hitbox then return false end
    
    -- Проверка времени жизни
    if CurTime() - hitbox.created > hitbox.duration then
        self:Unregister(id)
        return false
    end
    
    -- Игнорирование владельца
    if hitbox.ignoreOwner and hitbox.entity == targetEntity then
        return false
    end
    
    -- Проверка команды
    if hitbox.teams and not table.HasValue(hitbox.teams, targetEntity:Team()) then
        return false
    end
    
    -- Проверка расстояния
    local hitboxPos = self:GetPosition(hitbox)
    if not hitboxPos then return false end
    
    local distance = hitboxPos:Distance(targetPos)
    
    if distance <= hitbox.radius then
        return true, hitbox
    end
    
    return false
end

--[[------------------------------------
    Нанесение урона через хитбокс
--------------------------------------]]
function LOTM.Hitboxes:DealDamage(id, victim)
    local hitbox = self.HitboxRegistry[id]
    if not hitbox or not IsValid(victim) then return end
    
    local dmgInfo = DamageInfo()
    dmgInfo:SetAttacker(hitbox.entity)
    dmgInfo:SetInflictor(hitbox.entity)
    dmgInfo:SetDamage(hitbox.damage)
    dmgInfo:SetDamageType(hitbox.damageType)
    
    victim:TakeDamageInfo(dmgInfo)
    
    -- Callback
    if hitbox.callback then
        hitbox.callback(hitbox.entity, victim, hitbox)
    end
    
    -- Отправка на клиент для эффектов
    net.Start("LOTM_HitboxDamage")
        net.WriteEntity(hitbox.entity)
        net.WriteEntity(victim)
        net.WriteVector(self:GetPosition(hitbox))
    net.Broadcast()
end

-- Думающий хук для автоматической проверки хитбоксов
hook.Add("Think", "LOTM_HitboxThink", function()
    for id, hitbox in pairs(LOTM.HitboxRegistry) do
        if not IsValid(hitbox.entity) then
            LOTM.Hitboxes:Unregister(id)
            continue
        end
        
        local hitboxPos = LOTM.Hitboxes:GetPosition(hitbox)
        if not hitboxPos then continue end
        
        -- Проверка всех игроков
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) and ply:Alive() then
                local hit, hitboxData = LOTM.Hitboxes:CheckHit(id, ply:GetPos() + Vector(0, 0, 40), ply)
                if hit then
                    LOTM.Hitboxes:DealDamage(id, ply)
                    -- Удаляем хитбокс после попадания (опционально)
                    -- LOTM.Hitboxes:Unregister(id)
                end
            end
        end
        
        -- Проверка NPC
        for _, npc in ipairs(ents.FindByClass("npc_*")) do
            if IsValid(npc) and npc:Health() > 0 then
                local hit = LOTM.Hitboxes:CheckHit(id, npc:GetPos() + Vector(0, 0, 40), npc)
                if hit then
                    LOTM.Hitboxes:DealDamage(id, npc)
                end
            end
        end
    end
end)