-- LOTM Attack Registry System
-- Система регистрации и управления атаками способностей

LOTM = LOTM or {}
LOTM.AttackSystem = LOTM.AttackSystem or {}
LOTM.AttackSystem.Registry = LOTM.AttackSystem.Registry or {}

--[[
    Регистрация новой атаки
    
    attackID - уникальный идентификатор атаки
    data = {
        name = "Attack Name",
        description = "Attack description",
        
        -- Урон и хитбокс
        damage = 50,
        damageType = LOTM.HitboxAdvanced.DAMAGE_TYPES.PHYSICAL,
        hitboxType = LOTM.HitboxAdvanced.TYPES.SPHERE,
        hitboxSize = 100,                    -- Vector или Number
        hitboxOffset = Vector(50, 0, 0),
        hitboxDuration = 0.3,
        pierce = false,
        maxHits = 1,
        
        -- Ресурсы
        cooldown = 5,
        manaCost = 20,
        staminaCost = 10,
        
        -- Эффекты
        knockback = Vector(0, 0, 0),
        effect = "explosion",
        sound = "weapons/physcannon/energy_sing_explosion2.wav",
        
        -- Анимация
        animation = ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,
        castTime = 0.2,
        
        -- Callbacks
        onCast = function(attacker, attackData) end,
        onHit = function(target, attacker, hitbox) end,
        requirements = function(attacker) return true end,
        
        -- Визуал
        visual = {
            enabled = true,
            color = Color(255, 100, 100, 150)
        }
    }
]]
function LOTM.AttackSystem:Register(attackID, data)
    if self.Registry[attackID] then
        print("[LOTM Attack] Warning: Overwriting attack '" .. attackID .. "'")
    end
    
    self.Registry[attackID] = {
        id = attackID,
        name = data.name or "Unnamed Attack",
        description = data.description or "No description",
        
        -- Урон и хитбокс
        damage = data.damage or 50,
        damageType = data.damageType or LOTM.HitboxAdvanced.DAMAGE_TYPES.PHYSICAL,
        hitboxType = data.hitboxType or LOTM.HitboxAdvanced.TYPES.SPHERE,
        hitboxSize = data.hitboxSize or 100,
        hitboxOffset = data.hitboxOffset or Vector(50, 0, 0),
        hitboxDuration = data.hitboxDuration or 0.3,
        pierce = data.pierce or false,
        maxHits = data.maxHits or 1,
        
        -- Ресурсы
        cooldown = data.cooldown or 5,
        manaCost = data.manaCost or 20,
        staminaCost = data.staminaCost or 10,
        
        -- Эффекты
        knockback = data.knockback or Vector(0, 0, 0),
        effect = data.effect,
        sound = data.sound,
        
        -- Анимация
        animation = data.animation,
        castTime = data.castTime or 0,
        
        -- Callbacks
        onCast = data.onCast or function() end,
        onHit = data.onHit or function() end,
        requirements = data.requirements or function() return true end,
        
        -- Визуал
        visual = data.visual or {enabled = false}
    }
    
    print("[LOTM Attack] Registered: " .. attackID)
end

-- Получить атаку по ID
function LOTM.AttackSystem:Get(attackID)
    return self.Registry[attackID]
end

-- Выполнить атаку
function LOTM.AttackSystem:Execute(attacker, attackID)
    if not IsValid(attacker) then return false end
    
    local attack = self:Get(attackID)
    if not attack then
        print("[LOTM Attack] Attack not found: " .. attackID)
        return false
    end
    
    -- Проверка требований
    if not attack.requirements(attacker) then
        return false
    end
    
    -- Анимация
    if attack.animation and SERVER then
        attacker:DoAnimationEvent(attack.animation)
    end
    
    -- Звук
    if attack.sound and SERVER then
        attacker:EmitSound(attack.sound)
    end
    
    -- Callback при использовании
    attack.onCast(attacker, attack)
    
    -- Создание хитбокса
    local hitboxID
    if attack.castTime > 0 then
        timer.Simple(attack.castTime, function()
            if not IsValid(attacker) then return end
            hitboxID = self:CreateHitbox(attacker, attack)
        end)
    else
        hitboxID = self:CreateHitbox(attacker, attack)
    end
    
    return true, hitboxID
end

-- Создание хитбокса для атаки
function LOTM.AttackSystem:CreateHitbox(attacker, attack)
    return LOTM.HitboxAdvanced:Create({
        owner = attacker,
        type = attack.hitboxType,
        size = attack.hitboxSize,
        offset = attack.hitboxOffset,
        duration = attack.hitboxDuration,
        damage = attack.damage,
        damageType = attack.damageType,
        pierce = attack.pierce,
        maxHits = attack.maxHits,
        knockback = attack.knockback,
        effect = attack.effect,
        visual = attack.visual,
        onHit = function(target, owner, hitbox)
            attack.onHit(target, owner, hitbox)
        end,
        filter = function(ent)
            return IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) and ent ~= attacker
        end
    })
end

-- ==================== ПРИМЕРЫ АТАК ====================

-- 1. Базовая ближняя атака
LOTM.AttackSystem:Register("basic_melee", {
    name = "Basic Strike",
    description = "Simple melee attack",
    damage = 25,
    damageType = LOTM.HitboxAdvanced.DAMAGE_TYPES.PHYSICAL,
    hitboxType = LOTM.HitboxAdvanced.TYPES.SPHERE,
    hitboxSize = 70,
    hitboxOffset = Vector(60, 0, 30),
    hitboxDuration = 0.2,
    cooldown = 1.5,
    manaCost = 5,
    sound = "weapons/knife/knife_slash1.wav",
    animation = ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,
    knockback = Vector(300, 0, 100),
    visual = {
        enabled = true,
        color = Color(255, 200, 100, 100)
    },
    onHit = function(target, attacker)
        if SERVER then
            target:ViewPunch(Angle(5, 0, 0))
        end
    end
})

-- 2. Конусная AOE атака
LOTM.AttackSystem:Register("flame_breath", {
    name = "Flame Breath",
    description = "Cone-shaped fire attack",
    damage = 40,
    damageType = LOTM.HitboxAdvanced.DAMAGE_TYPES.ELEMENTAL,
    hitboxType = LOTM.HitboxAdvanced.TYPES.CONE,
    hitboxSize = Vector(60, 400), -- угол, дистанция
    hitboxOffset = Vector(0, 0, 50),
    hitboxDuration = 0.5,
    pierce = true,
    maxHits = 5,
    cooldown = 8,
    manaCost = 40,
    sound = "ambient/fire/mtov_flame2.wav",
    effect = "fire_jet_01",
    visual = {
        enabled = true,
        color = Color(255, 100, 0, 120)
    },
    onCast = function(attacker)
        if SERVER then
            util.ScreenShake(attacker:GetPos(), 3, 5, 0.5, 300)
        end
    end,
    onHit = function(target, attacker)
        if SERVER then
            target:Ignite(3)
        end
    end
})

-- 3. Лучевая атака
LOTM.AttackSystem:Register("spirit_beam", {
    name = "Spirit Beam",
    description = "Long-range piercing beam",
    damage = 60,
    damageType = LOTM.HitboxAdvanced.DAMAGE_TYPES.SPIRITUAL,
    hitboxType = LOTM.HitboxAdvanced.TYPES.RAY,
    hitboxSize = Vector(2000), -- дистанция
    hitboxOffset = Vector(0, 0, 50),
    hitboxDuration = 0.1,
    pierce = true,
    maxHits = 3,
    cooldown = 12,
    manaCost = 60,
    sound = "weapons/physcannon/energy_sing_loop4.wav",
    castTime = 0.3,
    visual = {
        enabled = true,
        color = Color(100, 200, 255, 200)
    },
    onCast = function(attacker)
        if CLIENT then return end
        local effectData = EffectData()
        effectData:SetOrigin(attacker:GetPos() + Vector(0, 0, 50))
        effectData:SetStart(attacker:GetPos() + Vector(0, 0, 50))
        effectData:SetNormal(attacker:GetForward())
        util.Effect("PhyscannonImpact", effectData)
    end
})

-- 4. Цилиндрическая AOE атака (удар по земле)
LOTM.AttackSystem:Register("ground_pound", {
    name = "Ground Pound",
    description = "AOE ground slam",
    damage = 50,
    damageType = LOTM.HitboxAdvanced.DAMAGE_TYPES.PHYSICAL,
    hitboxType = LOTM.HitboxAdvanced.TYPES.CYLINDER,
    hitboxSize = Vector(200, 0, 120), -- радиус, 0, высота
    hitboxOffset = Vector(0, 0, -50),
    hitboxDuration = 0.6,
    pierce = true,
    maxHits = 10,
    cooldown = 10,
    manaCost = 50,
    sound = "physics/concrete/boulder_impact_hard1.wav",
    knockback = Vector(0, 0, 400),
    visual = {
        enabled = true,
        color = Color(200, 100, 50, 100)
    },
    onCast = function(attacker)
        if SERVER then
            util.ScreenShake(attacker:GetPos(), 8, 10, 1, 600)
        end
    end
})

-- 5. Капсульная атака (для мечей)
LOTM.AttackSystem:Register("sword_slash", {
    name = "Sword Slash",
    description = "Sweeping sword attack",
    damage = 35,
    damageType = LOTM.HitboxAdvanced.DAMAGE_TYPES.PHYSICAL,
    hitboxType = LOTM.HitboxAdvanced.TYPES.CAPSULE,
    hitboxSize = Vector(30, 150), -- радиус, длина
    hitboxOffset = Vector(80, 0, 30),
    hitboxDuration = 0.3,
    pierce = false,
    maxHits = 3,
    cooldown = 2,
    manaCost = 15,
    sound = "weapons/knife/knife_slash1.wav",
    animation = ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,
    knockback = Vector(250, 0, 50),
    visual = {
        enabled = true,
        color = Color(200, 200, 255, 120)
    }
})

-- 6. Прямоугольная атака (духовная стена)
LOTM.AttackSystem:Register("spirit_wall", {
    name = "Spirit Wall",
    description = "Creates a damaging barrier",
    damage = 30,
    damageType = LOTM.HitboxAdvanced.DAMAGE_TYPES.MYSTICAL,
    hitboxType = LOTM.HitboxAdvanced.TYPES.BOX,
    hitboxSize = Vector(300, 80, 200),
    hitboxOffset = Vector(150, 0, 0),
    hitboxDuration = 2.0,
    pierce = true,
    maxHits = 20,
    cooldown = 15,
    manaCost = 70,
    sound = "ambient/wind/wind_snippet5.wav",
    visual = {
        enabled = true,
        color = Color(150, 255, 150, 80)
    },
    onHit = function(target, attacker)
        if SERVER then
            local direction = (target:GetPos() - attacker:GetPos()):GetNormalized()
            target:SetVelocity(direction * 150 + Vector(0, 0, 100))
        end
    end
})

print("[LOTM] Attack System loaded with " .. table.Count(LOTM.AttackSystem.Registry) .. " attacks!")