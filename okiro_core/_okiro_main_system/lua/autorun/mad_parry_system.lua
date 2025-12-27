MadParry = MadParry or {}
MadParry.Config = {
    PARRY_WINDOW = 0.2, -- Окно для успешного парирования
    PARRY_COOLDOWN = 3.0, -- Кулдаун между парированиями
    PERFECT_PARRY_WINDOW = 0.1, -- Окно для идеального парирования
    STAMINA_COST = 15, -- Стоимость стамины за парирование
    PERFECT_PARRY_BONUS = 1.5, -- Множитель урона при идеальном парировании
    SOUNDS = {
        normal = {
            "weapons/parry/parry_1.wav",
            "weapons/parry/parry_2.wav"
        },
        perfect = {
            "weapons/parry/perfect_parry_1.wav",
            "weapons/parry/perfect_parry_2.wav"
        }
    },
    EFFECTS = {
        normal = "parry_effect",
        perfect = "perfect_parry_effect"
    }
}

local PLAYER = FindMetaTable("Player")

function PLAYER:StartParry()
    if not IsValid(self) or not self:Alive() then return false end
    if self:GetNWFloat("ParryCooldown", 0) > CurTime() then return false end
    if self:GetNWInt("mad_stamina", 0) < MadParry.Config.STAMINA_COST then return false end
    
    self:SetNWFloat("ParryStart", CurTime())
    self:SetNWFloat("ParryEnd", CurTime() + MadParry.Config.PARRY_WINDOW)
    self:Mad_TakeStam(MadParry.Config.STAMINA_COST)
    
    local effectData = EffectData()
    effectData:SetOrigin(self:GetPos() + Vector(0, 0, 40))
    effectData:SetEntity(self)
    util.Effect("parry_start_effect", effectData)
    
    return true
end

function PLAYER:IsParrying()
    local currentTime = CurTime()
    return currentTime <= self:GetNWFloat("ParryEnd", 0)
end

function PLAYER:IsPerfectParryTiming()
    local currentTime = CurTime()
    local parryStart = self:GetNWFloat("ParryStart", 0)
    return (currentTime - parryStart) <= MadParry.Config.PERFECT_PARRY_WINDOW
end

function MadParry.ExtendWeapon(SWEP)
    function SWEP:SecondaryAttack()
        local owner = self:GetOwner()
        if not IsValid(owner) then return end
        
        if owner:StartParry() then
            owner:Mad_SetAnim("parry_stance")
            
            owner:EmitSound("weapons/parry/parry_ready.wav")
            
            local effectData = EffectData()
            effectData:SetOrigin(owner:GetPos())
            effectData:SetEntity(owner)
            util.Effect("parry_prepare", effectData)
        end
    end
end

hook.Add("EntityTakeDamage", "MadParryDamageHandler", function(target, dmginfo)
    if not IsValid(target) or not target:IsPlayer() then return end
    if not target:IsParrying() then return end
    
    local attacker = dmginfo:GetAttacker()
    if not IsValid(attacker) then return end
    
    if target:IsParrying() then
        local parrySuccess = true
        local isPerfect = target:IsPerfectParryTiming()
        
        if parrySuccess then
            dmginfo:SetDamage(0)
            
            local effectName = isPerfect and MadParry.Config.EFFECTS.perfect or MadParry.Config.EFFECTS.normal
            local effectData = EffectData()
            effectData:SetOrigin(target:GetPos() + Vector(0, 0, 40))
            effectData:SetEntity(target)
            util.Effect(effectName, effectData)
            
            local sounds = isPerfect and MadParry.Config.SOUNDS.perfect or MadParry.Config.SOUNDS.normal
            target:EmitSound(sounds[math.random(#sounds)])
            
            target:SetNWFloat("ParryCooldown", CurTime() + MadParry.Config.PARRY_COOLDOWN)
            
            if isPerfect then
                local counterDmg = DamageInfo()
                counterDmg:SetAttacker(target)
                counterDmg:SetDamage(dmginfo:GetDamage() * MadParry.Config.PERFECT_PARRY_BONUS)
                counterDmg:SetDamageType(dmginfo:GetDamageType())
                attacker:TakeDamageInfo(counterDmg)
                
                ParticleEffect("perfect_parry_impact", target:GetPos(), Angle(0,0,0))
                util.ScreenShake(target:GetPos(), 5, 5, 0.5, 100)
            end
            
            return true
        end
    end
end)