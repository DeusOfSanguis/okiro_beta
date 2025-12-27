-- LOTM Advanced Hitbox System
-- Продвинутая система хитбоксов с множественными типами и визуализацией

LOTM = LOTM or {}
LOTM.HitboxAdvanced = LOTM.HitboxAdvanced or {}
LOTM.HitboxAdvanced.Active = LOTM.HitboxAdvanced.Active or {}
LOTM.HitboxAdvanced.IDCounter = LOTM.HitboxAdvanced.IDCounter or 0

-- Типы хитбоксов
LOTM.HitboxAdvanced.TYPES = {
    SPHERE = 1,         -- Сферический хитбокс
    BOX = 2,            -- Прямоугольный хитбокс
    CYLINDER = 3,       -- Цилиндр (для AOE ground атак)
    CONE = 4,           -- Конус (для направленных атак)
    RAY = 5,            -- Луч (для дальних атак)
    CAPSULE = 6         -- Капсула (для мечей и копий)
}

-- Категории урона
LOTM.HitboxAdvanced.DAMAGE_TYPES = {
    PHYSICAL = 1,
    MYSTICAL = 2,
    SPIRITUAL = 3,
    MENTAL = 4,
    ELEMENTAL = 5
}

--[[
    Создание хитбокса
    
    config = {
        owner = Entity,              -- Владелец хитбокса
        type = TYPES.SPHERE,         -- Тип хитбокса
        size = Vector/Number,        -- Размер (Vector для BOX, Number для SPHERE)
        offset = Vector(0,0,0),      -- Смещение от владельца
        angle = Angle(0,0,0),        -- Угол поворота (опционально)
        duration = 0.5,              -- Длительность в секундах
        damage = 50,                 -- Урон
        damageType = DAMAGE_TYPES.PHYSICAL,
        onHit = function(target, attacker, hitbox) end,
        filter = function(ent) return true end,
        visual = {
            enabled = true,
            color = Color(255,0,0,100),
            material = "sprites/light_glow02_add"
        },
        pierce = false,              -- Пронзает ли цели
        maxHits = 1,                 -- Максимум попаданий
        knockback = Vector(0,0,0),   -- Отталкивание
        effect = "explosion"         -- Эффект при попадании
    }
]]
function LOTM.HitboxAdvanced:Create(config)
    if not IsValid(config.owner) then 
        print("[LOTM Hitbox] Error: Invalid owner")
        return nil 
    end
    
    self.IDCounter = self.IDCounter + 1
    
    local hitbox = {
        id = self.IDCounter,
        owner = config.owner,
        type = config.type or self.TYPES.SPHERE,
        size = config.size or 50,
        offset = config.offset or Vector(0, 0, 0),
        angle = config.angle or Angle(0, 0, 0),
        duration = config.duration or 0.5,
        damage = config.damage or 50,
        damageType = config.damageType or self.DAMAGE_TYPES.PHYSICAL,
        onHit = config.onHit or function() end,
        filter = config.filter or function(ent) 
            return IsValid(ent) and ent:IsPlayer() and ent ~= config.owner 
        end,
        visual = config.visual or {},
        pierce = config.pierce or false,
        maxHits = config.maxHits or 1,
        knockback = config.knockback or Vector(0, 0, 0),
        effect = config.effect,
        
        -- Внутренние данные
        createdTime = CurTime(),
        hitEntities = {},
        hitCount = 0
    }
    
    table.insert(self.Active, hitbox)
    
    if SERVER then
        -- Отправляем на клиент для визуализации
        net.Start("LOTM_CreateHitbox")
            net.WriteUInt(hitbox.id, 16)
            net.WriteEntity(hitbox.owner)
            net.WriteUInt(hitbox.type, 4)
            net.WriteVector(hitbox.size)
            net.WriteVector(hitbox.offset)
            net.WriteAngle(hitbox.angle)
            net.WriteFloat(hitbox.duration)
            net.WriteBool(hitbox.visual.enabled or false)
            if hitbox.visual.enabled then
                net.WriteColor(hitbox.visual.color or Color(255, 0, 0, 100))
            end
        net.Broadcast()
    end
    
    return hitbox.id
end

-- Получение позиции хитбокса
function LOTM.HitboxAdvanced:GetPosition(hitbox)
    if not IsValid(hitbox.owner) then return Vector(0, 0, 0) end
    
    local pos = hitbox.owner:GetPos()
    local ang = hitbox.owner:GetAngles()
    
    -- Применяем смещение с учётом угла владельца
    local forward = ang:Forward() * hitbox.offset.x
    local right = ang:Right() * hitbox.offset.y
    local up = ang:Up() * hitbox.offset.z
    
    return pos + forward + right + up
end

-- Проверка попадания в зависимости от типа хитбокса
function LOTM.HitboxAdvanced:CheckCollision(hitbox, target)
    if not IsValid(target) or not hitbox.filter(target) then return false end
    if table.HasValue(hitbox.hitEntities, target) and not hitbox.pierce then return false end
    
    local hitboxPos = self:GetPosition(hitbox)
    local targetPos = target:GetPos() + target:OBBCenter()
    
    if hitbox.type == self.TYPES.SPHERE then
        local radius = isnumber(hitbox.size) and hitbox.size or hitbox.size.x
        return hitboxPos:Distance(targetPos) <= radius
        
    elseif hitbox.type == self.TYPES.BOX then
        local mins = hitboxPos - hitbox.size / 2
        local maxs = hitboxPos + hitbox.size / 2
        return targetPos:WithinAABox(mins, maxs)
        
    elseif hitbox.type == self.TYPES.CYLINDER then
        local radius = hitbox.size.x
        local height = hitbox.size.z
        local dist2D = math.sqrt((targetPos.x - hitboxPos.x)^2 + (targetPos.y - hitboxPos.y)^2)
        local heightDiff = math.abs(targetPos.z - hitboxPos.z)
        return dist2D <= radius and heightDiff <= height / 2
        
    elseif hitbox.type == self.TYPES.CONE then
        local maxAngle = hitbox.size.x or 45
        local maxDist = hitbox.size.y or 300
        
        local toTarget = (targetPos - hitboxPos):GetNormalized()
        local forward = hitbox.owner:GetForward()
        local angle = math.deg(math.acos(forward:Dot(toTarget)))
        
        return angle <= maxAngle and hitboxPos:Distance(targetPos) <= maxDist
        
    elseif hitbox.type == self.TYPES.RAY then
        local maxDist = hitbox.size.x or 1000
        local trace = util.TraceLine({
            start = hitboxPos,
            endpos = hitboxPos + hitbox.owner:GetForward() * maxDist,
            filter = hitbox.owner
        })
        return trace.Entity == target
        
    elseif hitbox.type == self.TYPES.CAPSULE then
        -- Капсула = два сферических конца + цилиндр между ними
        local startPos = hitboxPos
        local endPos = hitboxPos + hitbox.owner:GetForward() * (hitbox.size.y or 100)
        local radius = hitbox.size.x or 20
        
        local closest = self:ClosestPointOnLineSegment(startPos, endPos, targetPos)
        return closest:Distance(targetPos) <= radius
    end
    
    return false
end

-- Ближайшая точка на отрезке (для CAPSULE)
function LOTM.HitboxAdvanced:ClosestPointOnLineSegment(a, b, point)
    local ab = b - a
    local ap = point - a
    local t = math.Clamp(ap:Dot(ab) / ab:LengthSqr(), 0, 1)
    return a + ab * t
end

-- Обработка попадания (SERVER)
if SERVER then
    function LOTM.HitboxAdvanced:ProcessHit(hitbox, target)
        if hitbox.hitCount >= hitbox.maxHits and not hitbox.pierce then return end
        
        -- Наносим урон
        local dmg = DamageInfo()
        dmg:SetDamage(hitbox.damage)
        dmg:SetAttacker(hitbox.owner)
        dmg:SetInflictor(hitbox.owner)
        dmg:SetDamageType(DMG_GENERIC)
        
        target:TakeDamageInfo(dmg)
        
        -- Отталкивание
        if hitbox.knockback:Length() > 0 then
            local direction = hitbox.owner:GetForward()
            target:SetVelocity(direction * hitbox.knockback.x + 
                             hitbox.owner:GetRight() * hitbox.knockback.y + 
                             Vector(0, 0, hitbox.knockback.z))
        end
        
        -- Callback
        hitbox.onHit(target, hitbox.owner, hitbox)
        
        -- Эффект
        if hitbox.effect then
            net.Start("LOTM_HitboxEffect")
                net.WriteString(hitbox.effect)
                net.WriteVector(target:GetPos() + target:OBBCenter())
            net.Broadcast()
        end
        
        table.insert(hitbox.hitEntities, target)
        hitbox.hitCount = hitbox.hitCount + 1
    end
end

-- Обновление хитбоксов
hook.Add("Think", "LOTM_HitboxAdvanced_Think", function()
    for i = #LOTM.HitboxAdvanced.Active, 1, -1 do
        local hitbox = LOTM.HitboxAdvanced.Active[i]
        
        -- Проверка времени жизни
        if CurTime() - hitbox.createdTime >= hitbox.duration or not IsValid(hitbox.owner) then
            table.remove(LOTM.HitboxAdvanced.Active, i)
            continue
        end
        
        -- Обработка столкновений (только на сервере)
        if SERVER then
            for _, ent in ipairs(ents.GetAll()) do
                if LOTM.HitboxAdvanced:CheckCollision(hitbox, ent) then
                    LOTM.HitboxAdvanced:ProcessHit(hitbox, ent)
                end
            end
        end
    end
end)

-- Визуализация хитбоксов (CLIENT)
if CLIENT then
    hook.Add("PostDrawTranslucentRenderables", "LOTM_HitboxAdvanced_Draw", function()
        if not GetConVar("lotm_debug_hitboxes") or not GetConVar("lotm_debug_hitboxes"):GetBool() then return end
        
        for _, hitbox in ipairs(LOTM.HitboxAdvanced.Active) do
            if not IsValid(hitbox.owner) then continue end
            if not hitbox.visual.enabled then continue end
            
            local pos = LOTM.HitboxAdvanced:GetPosition(hitbox)
            local color = hitbox.visual.color or Color(255, 0, 0, 100)
            
            render.SetColorMaterial()
            
            if hitbox.type == LOTM.HitboxAdvanced.TYPES.SPHERE then
                local radius = isnumber(hitbox.size) and hitbox.size or hitbox.size.x
                render.DrawWireframeSphere(pos, radius, 16, 16, color, true)
                
            elseif hitbox.type == LOTM.HitboxAdvanced.TYPES.BOX then
                render.DrawWireframeBox(pos, hitbox.angle, -hitbox.size/2, hitbox.size/2, color, true)
                
            elseif hitbox.type == LOTM.HitboxAdvanced.TYPES.CYLINDER then
                -- Рисуем цилиндр как несколько кругов
                local radius = hitbox.size.x
                local height = hitbox.size.z
                render.DrawWireframeSphere(pos + Vector(0,0,height/2), radius, 16, 8, color, true)
                render.DrawWireframeSphere(pos - Vector(0,0,height/2), radius, 16, 8, color, true)
                
            elseif hitbox.type == LOTM.HitboxAdvanced.TYPES.CONE then
                -- Визуализация конуса
                local maxDist = hitbox.size.y or 300
                local forward = hitbox.owner:GetForward()
                render.DrawLine(pos, pos + forward * maxDist, color, true)
            end
        end
    end)
end

-- Сетевые строки
if SERVER then
    util.AddNetworkString("LOTM_CreateHitbox")
    util.AddNetworkString("LOTM_HitboxEffect")
end

if CLIENT then
    net.Receive("LOTM_CreateHitbox", function()
        local id = net.ReadUInt(16)
        local owner = net.ReadEntity()
        local type = net.ReadUInt(4)
        local size = net.ReadVector()
        local offset = net.ReadVector()
        local angle = net.ReadAngle()
        local duration = net.ReadFloat()
        local visualEnabled = net.ReadBool()
        local color = visualEnabled and net.ReadColor() or Color(255, 0, 0, 100)
        
        -- Создаём хитбокс на клиенте для визуализации
        table.insert(LOTM.HitboxAdvanced.Active, {
            id = id,
            owner = owner,
            type = type,
            size = size,
            offset = offset,
            angle = angle,
            duration = duration,
            createdTime = CurTime(),
            visual = {
                enabled = visualEnabled,
                color = color
            }
        })
    end)
    
    net.Receive("LOTM_HitboxEffect", function()
        local effect = net.ReadString()
        local pos = net.ReadVector()
        
        local effectData = EffectData()
        effectData:SetOrigin(pos)
        util.Effect(effect, effectData)
    end)
end

-- ConVar для дебага
if CLIENT then
    CreateClientConVar("lotm_debug_hitboxes", "0", true, false, "Показывать хитбоксы для отладки")
end

print("[LOTM] Advanced Hitbox System loaded!")