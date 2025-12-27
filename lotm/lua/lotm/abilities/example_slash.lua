-- Пример способности: Sword Slash
-- Демонстрация ближней атаки

if SERVER then
    AddCSLuaFile()
end

LOTM.Abilities:Register({
    id = "sword_slash",
    name = "Sword Slash",
    description = "Perform a devastating sword slash in front of you",
    icon = "materials/lotm/abilities/slash.png",
    cooldown = 3,
    manaCost = 15,
    
    onUse = function(ply, ability, slot)
        if not SERVER then return end
        
        local slashPos = ply:GetShootPos() + ply:GetAimVector() * 80
        
        -- Создаем хитбокс для удара
        LOTM.Hitboxes:Register(ply, {
            id = "slash_" .. CurTime(),
            offset = ply:GetAimVector() * 80 + Vector(0, 0, -20),
            radius = 60,
            damage = 100,
            damageType = DMG_SLASH,
            duration = 0.3, -- Короткая длительность для мгновенной атаки
            ignoreOwner = true,
            callback = function(attacker, victim, hitbox)
                -- Отбрасывание
                local knockback = attacker:GetAimVector() * 500 + Vector(0, 0, 200)
                victim:SetVelocity(knockback)
                
                -- Эффекты
                local effectdata = EffectData()
                effectdata:SetOrigin(victim:GetPos() + Vector(0, 0, 40))
                effectdata:SetNormal(attacker:GetAimVector())
                util.Effect("BloodImpact", effectdata)
                
                victim:EmitSound("physics/flesh/flesh_bloody_break.wav", 75, 100)
            end
        })
        
        -- Анимация
        ply:SetAnimation(PLAYER_ATTACK1)
        
        -- Звук взмаха
        ply:EmitSound("weapons/knife/knife_slash" .. math.random(1, 2) .. ".wav", 75, 90)
        
        -- Визуальный эффект взмаха
        local effectdata = EffectData()
        effectdata:SetOrigin(slashPos)
        effectdata:SetAngles(ply:GetAngles())
        effectdata:SetScale(1.5)
        util.Effect("ManhackSparks", effectdata)
    end
})

print("[LOTM] Example ability 'Sword Slash' registered!")