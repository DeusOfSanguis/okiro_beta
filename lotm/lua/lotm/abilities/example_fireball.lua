-- Пример способности: Fireball
-- Демонстрация использования системы

if SERVER then
    AddCSLuaFile()
end

-- Регистрируем способность
LOTM.Abilities:Register({
    id = "fireball",
    name = "Fireball",
    description = "Launch a blazing fireball that explodes on impact",
    icon = "materials/lotm/abilities/fireball.png",
    cooldown = 8,
    manaCost = 30,
    maxRange = 2000,
    
    onUse = function(ply, ability, slot)
        if not SERVER then return end
        
        local shootPos = ply:GetShootPos()
        local shootDir = ply:GetAimVector()
        
        -- Создаем визуальную сущность файрбола
        local fireball = ents.Create("prop_physics")
        fireball:SetModel("models/hunter/misc/sphere025x025.mdl")
        fireball:SetPos(shootPos + shootDir * 50)
        fireball:SetAngles(shootDir:Angle())
        fireball:Spawn()
        fireball:SetMaterial("models/debug/debugwhite")
        fireball:SetColor(Color(255, 100, 0))
        fireball:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
        
        -- Физика
        local phys = fireball:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableGravity(false)
            phys:SetVelocity(shootDir * 1500)
        end
        
        -- Создаем хитбокс, привязанный к файрболу
        local hitboxID = LOTM.Hitboxes:Register(fireball, {
            id = "fireball_" .. CurTime(),
            offset = Vector(0, 0, 0),
            radius = 25,
            damage = 75,
            damageType = DMG_BURN,
            duration = 5,
            ignoreOwner = true,
            callback = function(attacker, victim, hitbox)
                -- Эффект взрыва
                local effectdata = EffectData()
                effectdata:SetOrigin(fireball:GetPos())
                effectdata:SetScale(2)
                util.Effect("Explosion", effectdata)
                
                -- Звук
                fireball:EmitSound("weapons/explode" .. math.random(3, 5) .. ".wav", 100, 100)
                
                -- Удаляем файрбол
                SafeRemoveEntity(fireball)
            end
        })
        
        -- Звук запуска
        ply:EmitSound("weapons/physcannon/energy_sing_explosion2.wav", 75, 120)
        
        -- Удаляем файрбол через 5 секунд, если не попал
        timer.Simple(5, function()
            if IsValid(fireball) then
                fireball:Remove()
            end
        end)
        
        -- Партиклы (если есть)
        ParticleEffectAttach("fire_large_01", PATTACH_ABSORIGIN_FOLLOW, fireball, 0)
    end
})

print("[LOTM] Example ability 'Fireball' registered!")