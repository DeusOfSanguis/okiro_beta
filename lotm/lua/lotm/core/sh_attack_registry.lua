-- LOTM Attack Registry System
-- Система регистрации и управления атаками способностей

LOTM.AttackRegistry = LOTM.AttackRegistry or {}
LOTM.AttackRegistry.Registered = LOTM.AttackRegistry.Registered or {}

--[[------------------------------------
    Регистрация новой атаки
    
    @param attackID - уникальный ID атаки
    @param attackData - данные атаки:
        - name: название атаки
        - description: описание
        - damage: базовый урон
        - damageType: тип урона (LOTM.HitboxSystem.DamageTypes)
        - hitboxType: тип хитбокса (LOTM.HitboxSystem.Types)
        - hitboxSize: размер хитбокса
        - hitboxOffset: смещение хитбокса
        - duration: длительность хитбокса
        - cooldown: кулдаун атаки
        - manaCost: стоимость маны
        - effects: дополнительные эффекты
        - onCast: функция при использовании
        - onHit: функция при попадании
        - requirements: требования для использования
--------------------------------------]]
function LOTM.AttackRegistry:Register(attackID, attackData)
    if self.Registered[attackID] then
        print("[LOTM] Warning: Attack '" .. attackID .. "' is already registered. Overwriting...")
    end
    
    self.Registered[attackID] = {
        id = attackID,
        name = attackData.name or "Unknown Attack",
        description = attackData.description or "No description",
        
        -- Урон и тип
        damage = attackData.damage or 10,
        damageType = attackData.damageType or LOTM.HitboxSystem.DamageTypes.PHYSICAL,
        
        -- Хитбокс
        hitboxType = attackData.hitboxType or LOTM.HitboxSystem.Types.SPHERE,
        hitboxSize = attackData.hitboxSize or 50,
        hitboxOffset = attackData.hitboxOffset or Vector(50, 0, 0),
        hitboxDuration = attackData.hitboxDuration or 0.1,
        
        -- Ресурсы
        cooldown = attackData.cooldown or 5,
        manaCost = attackData.manaCost or 10,
        
        -- Эффекты
        effects = attackData.effects or {},
        
        -- Callbacks
        onCast = attackData.onCast or function(ply) end,
        onHit = attackData.onHit or function(target, attacker) end,
        
        -- Требования
        requirements = attackData.requirements or function(ply) return true end,
        
        -- Анимация
        animation = attackData.animation or nil,
        castTime = attackData.castTime or 0,
        
        -- Визуальные эффекты
        visual = attackData.visual or {}
    }
    
    print("[LOTM] Registered attack: " .. attackID)
end

--[[------------------------------------
    Получение данных атаки
--------------------------------------]]
function LOTM.AttackRegistry:Get(attackID)
    return self.Registered[attackID]
end

--[[------------------------------------
    Использование атаки
--------------------------------------]]
function LOTM.AttackRegistry:Execute(attacker, attackID)
    if not IsValid(attacker) then return false end
    
    local attack = self:Get(attackID)
    if not attack then
        print("[LOTM] Attack '" .. attackID .. "' not found!")
        return false
    end
    
    -- Проверка требований
    if not attack.requirements(attacker) then
        return false
    end
    
    -- Callback при использовании
    attack.onCast(attacker)
    
    -- Создание хитбокса
    if SERVER then
        LOTM.HitboxSystem:CreateHitbox(attacker, {
            type = attack.hitboxType,
            size = attack.hitboxSize,
            offset = attack.hitboxOffset,
            duration = attack.hitboxDuration,
            damage = attack.damage,
            damageType = attack.damageType,
            onHit = function(target, hitbox)
                attack.onHit(target, attacker)
            end,
            visual = attack.visual
        })
    end
    
    return true
end

--[[------------------------------------
    Пример регистрации атак
--------------------------------------]]

-- Базовая атака ближнего боя
LOTM.AttackRegistry:Register("basic_melee", {
    name = "Basic Melee",
    description = "Simple melee attack",
    damage = 15,
    damageType = LOTM.HitboxSystem.DamageTypes.PHYSICAL,
    hitboxType = LOTM.HitboxSystem.Types.SPHERE,
    hitboxSize = 60,
    hitboxOffset = Vector(50, 0, 0),
    hitboxDuration = 0.2,
    cooldown = 1,
    manaCost = 5,
    onCast = function(ply)
        if CLIENT then return end
        ply:EmitSound("weapons/knife/knife_slash1.wav")
    end,
    onHit = function(target, attacker)
        if CLIENT then return end
        target:SetVelocity(attacker:GetForward() * 200 + Vector(0, 0, 100))
    end
})

-- Дальняя атака конусом
LOTM.AttackRegistry:Register("cone_blast", {
    name = "Cone Blast",
    description = "AOE cone attack",
    damage = 25,
    damageType = LOTM.HitboxSystem.DamageTypes.MYSTICAL,
    hitboxType = LOTM.HitboxSystem.Types.CONE,
    hitboxSize = Vector(45, 300), -- angle, distance
    hitboxOffset = Vector(0, 0, 0),
    hitboxDuration = 0.3,
    cooldown = 8,
    manaCost = 30,
    onCast = function(ply)
        if CLIENT then return end
        ply:EmitSound("ambient/explosions/explode_4.wav", 75, 120)
    end,
    onHit = function(target, attacker)
        if CLIENT then return end
        local effectData = EffectData()
        effectData:SetOrigin(target:GetPos())
        util.Effect("Explosion", effectData)
    end,
    visual = {
        color = Color(100, 150, 255, 100)
    }
})

-- Луч атака
LOTM.AttackRegistry:Register("piercing_ray", {
    name = "Piercing Ray",
    description = "Long range piercing attack",
    damage = 40,
    damageType = LOTM.HitboxSystem.DamageTypes.SPIRITUAL,
    hitboxType = LOTM.HitboxSystem.Types.RAY,
    hitboxSize = Vector(2000), -- distance
    hitboxOffset = Vector(0, 0, 50),
    hitboxDuration = 0.1,
    cooldown = 12,
    manaCost = 50,
    onCast = function(ply)
        if CLIENT then return end
        ply:EmitSound("weapons/physcannon/energy_sing_loop4.wav")
    end,
    onHit = function(target, attacker)
        if CLIENT then return end
        target:Ignite(3)
    end,
    visual = {
        color = Color(255, 50, 50, 200)
    }
})

-- Цилиндрическая AOE атака
LOTM.AttackRegistry:Register("ground_slam", {
    name = "Ground Slam",
    description = "AOE ground attack",
    damage = 35,
    damageType = LOTM.HitboxSystem.DamageTypes.PHYSICAL,
    hitboxType = LOTM.HitboxSystem.Types.CYLINDER,
    hitboxSize = Vector(150, 100), -- radius, height
    hitboxOffset = Vector(0, 0, -50),
    hitboxDuration = 0.5,
    cooldown = 10,
    manaCost = 40,
    onCast = function(ply)
        if CLIENT then return end
        ply:EmitSound("physics/concrete/boulder_impact_hard" .. math.random(1, 4) .. ".wav")
        util.ScreenShake(ply:GetPos(), 5, 5, 1, 500)
    end,
    onHit = function(target, attacker)
        if CLIENT then return end
        target:SetVelocity(Vector(0, 0, 300))
    end,
    visual = {
        color = Color(200, 100, 50, 100)
    }
})

-- Прямоугольная атака (стена)
LOTM.AttackRegistry:Register("spirit_wall", {
    name = "Spirit Wall",
    description = "Creates a damaging wall",
    damage = 20,
    damageType = LOTM.HitboxSystem.DamageTypes.SPIRITUAL,
    hitboxType = LOTM.HitboxSystem.Types.BOX,
    hitboxSize = Vector(200, 50, 150), -- width, depth, height
    hitboxOffset = Vector(100, 0, 0),
    hitboxDuration = 2.0,
    cooldown = 15,
    manaCost = 60,
    onCast = function(ply)
        if CLIENT then return end
        ply:EmitSound("ambient/wind/wind_snippet1.wav")
    end,
    onHit = function(target, attacker)
        if CLIENT then return end
        target:SetVelocity(attacker:GetRight() * math.random(-200, 200))
    end,
    visual = {
        color = Color(150, 255, 150, 80)
    }
})

print("[LOTM] Attack Registry initialized with " .. table.Count(LOTM.AttackRegistry.Registered) .. " attacks")