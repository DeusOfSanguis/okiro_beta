-- LOTM Advanced Hitbox System
-- Продвинутая система хитбоксов для способностей

LOTM.HitboxSystem = LOTM.HitboxSystem or {}
LOTM.HitboxSystem.ActiveHitboxes = LOTM.HitboxSystem.ActiveHitboxes or {}

-- Типы хитбоксов
LOTM.HitboxSystem.Types = {
    SPHERE = 1,      -- Сферический хитбокс
    BOX = 2,         -- Прямоугольный хитбокс
    CYLINDER = 3,    -- Цилиндрический хитбокс
    CONE = 4,        -- Конусообразный хитбокс
    RAY = 5          -- Луч
}

-- Типы урона для тегирования
LOTM.HitboxSystem.DamageTypes = {
    PHYSICAL = 1,
    MYSTICAL = 2,
    SPIRITUAL = 3,
    MENTAL = 4,
    ELEMENTAL = 5
}

--[[------------------------------------
    Создание хитбокса
    
    @param owner - владелец хитбокса (Entity)
    @param config - конфигурация хитбокса:
        - type: тип хитбокса (LOTM.HitboxSystem.Types)
        - size: размер (Vector для BOX, число для SPHERE)
        - offset: смещение от владельца (Vector)
        - duration: длительность существования (секунды)
        - damage: урон
        - damageType: тип урона
        - onHit: функция обратного вызова при попадании
        - filter: функция фильтрации целей
        - visual: визуальные параметры (опционально)
--------------------------------------]]
function LOTM.HitboxSystem:CreateHitbox(owner, config)
    if not IsValid(owner) then return end
    
    local hitbox = {
        owner = owner,
        type = config.type or self.Types.SPHERE,
        size = config.size or Vector(50, 50, 50),
        offset = config.offset or Vector(0, 0, 0),
        damage = config.damage or 10,
        damageType = config.damageType or self.DamageTypes.PHYSICAL,
        filter = config.filter or function(ent) return IsValid(ent) and ent:IsPlayer() and ent ~= owner end,
        onHit = config.onHit or function() end,
        visual = config.visual or {},
        
        -- Внутренние данные
        createdTime = CurTime(),
        duration = config.duration or 0.1,
        hitEntities = {},
        id = #self.ActiveHitboxes + 1
    }
    
    table.insert(self.ActiveHitboxes, hitbox)
    
    if SERVER then
        self:ProcessHitbox(hitbox)
    end
    
    return hitbox.id
end

--[[------------------------------------
    Обработка хитбокса (серверная)
--------------------------------------]]
if SERVER then
    function LOTM.HitboxSystem:ProcessHitbox(hitbox)
        if not IsValid(hitbox.owner) then return end
        
        local pos = hitbox.owner:GetPos() + hitbox.owner:GetForward() * hitbox.offset.x + 
                    hitbox.owner:GetRight() * hitbox.offset.y + 
                    hitbox.owner:GetUp() * hitbox.offset.z
        
        local targets = self:FindTargetsInHitbox(hitbox, pos)
        
        for _, target in ipairs(targets) do
            if not table.HasValue(hitbox.hitEntities, target) then
                self:ApplyHit(hitbox, target)
                table.insert(hitbox.hitEntities, target)
            end
        end
    end
    
    function LOTM.HitboxSystem:FindTargetsInHitbox(hitbox, pos)
        local targets = {}
        local ents = ents.FindInSphere(pos, self:GetMaxRadius(hitbox))
        
        for _, ent in ipairs(ents) do
            if hitbox.filter(ent) and self:IsInHitbox(hitbox, pos, ent) then
                table.insert(targets, ent)
            end
        end
        
        return targets
    end
    
    function LOTM.HitboxSystem:IsInHitbox(hitbox, pos, ent)
        local entPos = ent:GetPos()
        
        if hitbox.type == self.Types.SPHERE then
            local radius = isnumber(hitbox.size) and hitbox.size or 50
            return entPos:Distance(pos) <= radius
            
        elseif hitbox.type == self.Types.BOX then
            local mins = pos - hitbox.size / 2
            local maxs = pos + hitbox.size / 2
            return entPos:WithinAABox(mins, maxs)
            
        elseif hitbox.type == self.Types.CYLINDER then
            local radius = hitbox.size.x or 50
            local height = hitbox.size.y or 100
            local dist2D = math.sqrt((entPos.x - pos.x)^2 + (entPos.y - pos.y)^2)
            local heightDiff = math.abs(entPos.z - pos.z)
            return dist2D <= radius and heightDiff <= height / 2
            
        elseif hitbox.type == self.Types.CONE then
            local dir = hitbox.owner:GetForward()
            local toEnt = (entPos - pos):GetNormalized()
            local angle = math.deg(math.acos(dir:Dot(toEnt)))
            local maxAngle = hitbox.size.x or 45
            local maxDist = hitbox.size.y or 200
            return angle <= maxAngle and entPos:Distance(pos) <= maxDist
            
        elseif hitbox.type == self.Types.RAY then
            local tr = util.TraceLine({
                start = pos,
                endpos = pos + hitbox.owner:GetForward() * (hitbox.size.x or 1000),
                filter = hitbox.owner
            })
            return tr.Entity == ent
        end
        
        return false
    end
    
    function LOTM.HitboxSystem:ApplyHit(hitbox, target)
        if not IsValid(target) then return end
        
        -- Применяем урон
        local dmg = DamageInfo()
        dmg:SetDamage(hitbox.damage)
        dmg:SetAttacker(hitbox.owner)
        dmg:SetInflictor(hitbox.owner)
        dmg:SetDamageType(DMG_GENERIC)
        
        target:TakeDamageInfo(dmg)
        
        -- Вызываем callback
        if hitbox.onHit then
            hitbox.onHit(target, hitbox)
        end
        
        -- Отправляем эффект на клиент
        net.Start("LOTM_HitboxHit")
            net.WriteEntity(target)
            net.WriteUInt(hitbox.damageType, 4)
        net.Broadcast()
    end
end

--[[------------------------------------
    Вспомогательные функции
--------------------------------------]]
function LOTM.HitboxSystem:GetMaxRadius(hitbox)
    if hitbox.type == self.Types.SPHERE then
        return isnumber(hitbox.size) and hitbox.size or 50
    elseif hitbox.type == self.Types.BOX then
        return hitbox.size:Length() / 2
    elseif hitbox.type == self.Types.CYLINDER then
        return math.max(hitbox.size.x or 50, hitbox.size.y or 100)
    elseif hitbox.type == self.Types.CONE or hitbox.type == self.Types.RAY then
        return hitbox.size.y or 200
    end
    return 100
end

--[[------------------------------------
    Визуализация хитбоксов (клиент)
--------------------------------------]]
if CLIENT then
    hook.Add("PostDrawTranslucentRenderables", "LOTM_DrawHitboxes", function()
        if not LOTM.Config.Hitbox.DebugMode then return end
        
        for _, hitbox in ipairs(LOTM.HitboxSystem.ActiveHitboxes) do
            if not IsValid(hitbox.owner) then continue end
            if CurTime() - hitbox.createdTime > hitbox.duration then continue end
            
            local pos = hitbox.owner:GetPos() + hitbox.owner:GetForward() * hitbox.offset.x + 
                        hitbox.owner:GetRight() * hitbox.offset.y + 
                        hitbox.owner:GetUp() * hitbox.offset.z
            
            local color = hitbox.visual.color or LOTM.Config.Hitbox.DebugColor
            
            if hitbox.type == LOTM.HitboxSystem.Types.SPHERE then
                render.DrawWireframeSphere(pos, isnumber(hitbox.size) and hitbox.size or 50, 20, 20, color)
            elseif hitbox.type == LOTM.HitboxSystem.Types.BOX then
                render.DrawWireframeBox(pos, Angle(0, 0, 0), -hitbox.size / 2, hitbox.size / 2, color)
            end
        end
    end)
    
    -- Получение эффектов попадания
    net.Receive("LOTM_HitboxHit", function()
        local target = net.ReadEntity()
        local damageType = net.ReadUInt(4)
        
        if not IsValid(target) then return end
        
        -- Создаем визуальный эффект попадания
        local effectData = EffectData()
        effectData:SetOrigin(target:GetPos() + Vector(0, 0, 40))
        util.Effect("lotm_hit_effect", effectData)
    end)
end

--[[------------------------------------
    Обновление активных хитбоксов
--------------------------------------]]
hook.Add("Think", "LOTM_UpdateHitboxes", function()
    local currentTime = CurTime()
    
    for i = #LOTM.HitboxSystem.ActiveHitboxes, 1, -1 do
        local hitbox = LOTM.HitboxSystem.ActiveHitboxes[i]
        
        if not IsValid(hitbox.owner) or currentTime - hitbox.createdTime > hitbox.duration then
            table.remove(LOTM.HitboxSystem.ActiveHitboxes, i)
        elseif SERVER then
            LOTM.HitboxSystem:ProcessHitbox(hitbox)
        end
    end
end)

if SERVER then
    util.AddNetworkString("LOTM_HitboxHit")
end