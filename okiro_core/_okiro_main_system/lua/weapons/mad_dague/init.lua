AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local hitjoueur = {
	"mad_sfx_sololeveling/punch/se_Punch_FaceHit.ogg",
	"mad_sfx_sololeveling/punch/se_Punch_Hit01.ogg",
	"mad_sfx_sololeveling/punch/se_Punch_Hit02.ogg"
}

local swing_attack = {
	"mad_sfx_sololeveling/punch/chopper_Punch01.ogg",
	"mad_sfx_sololeveling/punch/chopper_Punch02.ogg",
	"mad_sfx_sololeveling/punch/chopper_Punch03.ogg"
}

local timer_Simple = timer.Simple
local ents_FindInSphere = ents.FindInSphere


local parry_sounds = {
    "weapons/parry/parry_1.wav",
    "weapons/parry/parry_2.wav"
}
local PARRY_WINDOW = 0.6
local PARRY_COOLDOWN = 0
local PARRY_STAMINA_COST = 15
local PERFECT_PARRY_WINDOW = 0.3
local PERFECT_PARRY_BONUS = 1.5
local MOVEMENT_SLOW = 0.1
local PERFECT_PARRY_STUN = 1

function SWEP:SecondaryAttack()
    if not IsValid(self) then return end
    local ply = self:GetOwner()
    local ct = CurTime()

    if ply:GetNWBool("Blocage") then return end

    if ct < self:GetNWFloat("ParryCooldown", 0) then
        ply:ChatPrint("Vous pouvez parer de nouveau dans " .. math.ceil(self:GetNWFloat("ParryCooldown") - ct) .. " secondes...")
        return
    end

    if ply:GetNWInt("mad_stamina") < PARRY_STAMINA_COST then
        ply:ChatPrint("Pas assez de stamina pour parer!")
        return
    end

    if ply:GetNWBool("IsParrying") then return end

    ply:SetNWFloat("OriginalSpeedPlayerPar", ply:GetLaggedMovementValue())
    ply:SetLaggedMovementValue(MOVEMENT_SLOW)

    ply:SetNWFloat("ParryStart", ct)
    ply:SetNWFloat("ParryEnd", ct + PARRY_WINDOW)
    ply:SetNWBool("IsParrying", true)
    ply:Mad_TakeStam(PARRY_STAMINA_COST)

    self:SetNWFloat("ParryCooldown", ct + PARRY_COOLDOWN)

    ply:SetNWBool("Blocage", true)
    ply:Mad_SetAnim("wos_bs_shared_block_left_blocked_upper")

    local effectdata = EffectData()
    effectdata:SetOrigin(ply:GetPos() + Vector(0, 0, 40))
    effectdata:SetEntity(ply)
    util.Effect("sl_effect10", effectdata, true, true)

    timer.Simple(PARRY_WINDOW, function()
        if IsValid(ply) and IsValid(self) then
            ply:SetNWBool("IsParrying", false)
            ply:SetNWBool("Blocage", false)
            ply:SetLaggedMovementValue(ply:GetNWFloat("OriginalSpeedPlayerPar", 1.0))
            ply:SetNWFloat("OriginalSpeedPlayerPar", nil)
        end
    end)
end
hook.Add("EntityTakeDamage", "MadWeaponParrySystem", function(target, dmginfo)
    if not IsValid(target) or not target:IsPlayer() or not target:IsNPC() then return end

    local ct = CurTime()
    local parryEnd = target:GetNWFloat("ParryEnd", 0)

    if CurTime() <= parryEnd and target:GetNWBool("IsParrying") then
        local attacker = dmginfo:GetAttacker()
        if not IsValid(attacker) then return end
        local parryStart = target:GetNWFloat("ParryStart", 0)
        local timeDiff = ct - parryStart
        local isPerfect = timeDiff <= PERFECT_PARRY_WINDOW

        dmginfo:SetDamage(0)
        dmginfo:SetDamageForce(Vector(0, 0, 0))

        -- Calculate impact position (middle point between attacker and target)
        local impactPos = (target:GetPos() + attacker:GetPos()) / 2
        impactPos.z = impactPos.z + 50 -- Adjust height to be around weapon level

        -- Create spark effect at impact position
        local effectData = EffectData()
        effectData:SetOrigin(impactPos)
        effectData:SetScale(1.0)
        util.Effect("parry_sparks", effectData, true, true)

        -- Sound effect for sparks
        target:EmitSound("physics/metal/metal_solid_impact_hard" .. math.random(1, 4) .. ".wav", 75, math.random(90, 110))

        if isPerfect then
            util.ScreenShake(target:GetPos(), 5, 5, 0.5, 100)

            local counterDmg = DamageInfo()
            counterDmg:SetAttacker(target)
            counterDmg:SetDamage(dmginfo:GetDamage() * PERFECT_PARRY_BONUS)
            counterDmg:SetDamageType(dmginfo:GetDamageType())
            attacker:TakeDamageInfo(counterDmg)

            target:ChatPrint("Perfect Parry!")
            
            if IsValid(attacker) and attacker:IsPlayer() then
                attacker:Lock()
                attacker:SetNWBool("ParryStunned", true)
                attacker:SetNWFloat("ParryStunEnd", CurTime() + PERFECT_PARRY_STUN)

                timer.Simple(PERFECT_PARRY_STUN, function()
                    if IsValid(attacker) then
                        attacker:UnLock()
                        attacker:SetNWBool("ParryStunned", false)
                        attacker:SetNWFloat("ParryStunEnd", 0)
                    end
                end)
            end
        else
            target:ChatPrint("Parry!")
        end

        target:SetNWBool("IsParrying", false)
        target:SetNWFloat("ParryCooldown", CurTime() + PARRY_COOLDOWN)
        target:SetLaggedMovementValue(target:GetNWFloat("OriginalSpeedPlayerPar", 1.0))
        target:SetNWFloat("OriginalSpeedPlayerPar", nil)

        return true
    end
end)

function SWEP:DesacInvisi()
	local ply = self:GetOwner()
	if ply.Invisi == true then

		timer.Remove("StaminaInvisi"..ply:SteamID64())

		ply.Invisi = false
		ply:SetColor(Color(255,255,255,255))
		ply:DrawWorldModel( true )

		local effectdata = EffectData()
		effectdata:SetOrigin( ply:GetPos() )
		effectdata:SetEntity( ply )
		util.Effect( "sl_effect10", effectdata, true, true )

		if ply:GetNWBool("IsAdminMode") == false then
			ply:SetNoDraw( false )
		end
		ply:DrawShadow( true )
	end
end

function SWEP:Mad_Debug()
	local ply = self:GetOwner()

	timer.Remove("StaminaInvisi"..ply:SteamID64())
	ply.Invisi = false
	ply:SetColor(Color(255,255,255,255))
	ply:DrawWorldModel( true )
	if ply:GetNWBool("IsAdminMode") == false then
		ply:SetNoDraw( false )
	end
	ply:DrawShadow( true )
end

function SWEP:OnDrop()
    self:Remove() -- You can't drop fists
end

function SWEP:Holster()
    local owner = self:GetOwner()
	if IsValid(self:GetOwner():GetActiveWeapon()) then
		self:GetOwner():GetActiveWeapon():Mad_Debug()
	end
    if IsValid(owner) then
        hook.Remove("PlayerButtonDown", owner:SteamID().."BINDS_SOLOLEVELING_MAD")
    end
    return true
end

function SWEP:OnRemove()
    local owner = self:GetOwner()
	if IsValid(self:GetOwner():GetActiveWeapon()) then
		self:GetOwner():GetActiveWeapon():Mad_Debug()
	end
    if IsValid(owner) then
        hook.Remove("PlayerButtonDown", owner:SteamID().."BINDS_SOLOLEVELING_MAD")
    end
    return true
end

function SWEP:Deploy()

	self.Weapon:SetHoldType( self.holdtype )

	local ply = self:GetOwner()
	
	local effectdata = EffectData()
	effectdata:SetOrigin( ply:GetPos() )
	effectdata:SetEntity( ply )
	util.Effect( "sl_effect10", effectdata, true, true )

    hook.Add("PlayerButtonDown", self:GetOwner():SteamID().."BINDS_SOLOLEVELING_MAD", function( ply_, button )

        if ply_ ~= ply then return end 

		if button == ply_:GetInfoNum( "sl_attaque1", 28) then
            ply_:GetActiveWeapon():Attaque1()
		elseif button == ply_:GetInfoNum( "sl_attaque2", 28) then
            ply_:GetActiveWeapon():Attaque2()
		elseif button == ply_:GetInfoNum( "sl_attaque3", 28) then
            ply_:GetActiveWeapon():Attaque3()
		elseif button == ply_:GetInfoNum( "sl_attaque4", 28) then
            ply_:GetActiveWeapon():Attaque4()
        elseif button == ply_:GetInfoNum( "sl_attaque5", 28) then
            ply_:GetActiveWeapon():Attaque5()
        elseif button == ply_:GetInfoNum( "sl_attaque6", 28) then
            ply_:GetActiveWeapon():Attaque6()
        end
    
    end)

end

function SWEP:Attaque1()
	if !IsValid( self ) then return end

	local ply = self:GetOwner()
	local ct = CurTime()

	if ct < ply:GetNWInt("next_attaque1", 0) then return end
		if ct < ply:GetNWInt("next_attaque") then return end
        
        if ply:GetNWInt("Technique1") == 0 then return end

		if ply:GetNWInt("mad_stamina") < SKILLS_SL[ply:GetNWInt("Technique1")].stam then ply:ChatPrint("Vous n'avez pu assez de stamina !") return end

        if SKILLS_SL[ply:GetNWInt("Technique1")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique1")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end
		if SKILLS_SL[ply:GetNWInt("Technique1")].element != "none" then
			if SKILLS_SL[ply:GetNWInt("Technique1")].element != ply:GetNWInt("Magie") then return end
		end

        local skill = SKILLS_SL[ply:GetNWInt("Technique1")]
        if skill then
            skill.code(ply)
			ply:Mad_TakeStam(skill.stam)
        end

		ply:SetNWInt("next_attaque1", ct + SKILLS_SL[ply:GetNWInt("Technique1")].coldown )
		ply:SetNWInt("next_attaque", ct + 2 )
end

function SWEP:Attaque2()
	if !IsValid( self ) then return end

	local ply = self:GetOwner()
	local ct = CurTime()

	if ct < ply:GetNWInt("next_attaque2", 0) then return end
		if ct < ply:GetNWInt("next_attaque") then return end
        
        if ply:GetNWInt("Technique2") == 0 then return end

		if ply:GetNWInt("mad_stamina") < SKILLS_SL[ply:GetNWInt("Technique2")].stam then ply:ChatPrint("Vous n'avez pu assez de stamina !") return end

        if SKILLS_SL[ply:GetNWInt("Technique2")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique2")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end
		if SKILLS_SL[ply:GetNWInt("Technique2")].element != "none" then
			if SKILLS_SL[ply:GetNWInt("Technique2")].element != ply:GetNWInt("Magie") then return end
		end

        local skill = SKILLS_SL[ply:GetNWInt("Technique2")]
        if skill then
            skill.code(ply)
			ply:Mad_TakeStam(skill.stam)
        end

		ply:SetNWInt("next_attaque2", ct + SKILLS_SL[ply:GetNWInt("Technique2")].coldown )
		ply:SetNWInt("next_attaque", ct + 2 )
end

function SWEP:Attaque3()
	if !IsValid( self ) then return end

	local ply = self:GetOwner()
	local ct = CurTime()

	if ct < ply:GetNWInt("next_attaque3", 0) then return end
		if ct < ply:GetNWInt("next_attaque") then return end
        
        if ply:GetNWInt("Technique3") == 0 then return end

		if ply:GetNWInt("mad_stamina") < SKILLS_SL[ply:GetNWInt("Technique3")].stam then ply:ChatPrint("Vous n'avez pu assez de stamina !") return end

        if SKILLS_SL[ply:GetNWInt("Technique3")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique3")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end
		if SKILLS_SL[ply:GetNWInt("Technique3")].element != "none" then
			if SKILLS_SL[ply:GetNWInt("Technique3")].element != ply:GetNWInt("Magie") then return end
		end

        local skill = SKILLS_SL[ply:GetNWInt("Technique3")]
        if skill then
            skill.code(ply)
			ply:Mad_TakeStam(skill.stam)
        end

		ply:SetNWInt("next_attaque3", ct + SKILLS_SL[ply:GetNWInt("Technique3")].coldown )
		ply:SetNWInt("next_attaque", ct + 2 )
end

function SWEP:Attaque4()
	if !IsValid( self ) then return end

	local ply = self:GetOwner()
	local ct = CurTime()

	if ct < ply:GetNWInt("next_attaque4", 0) then return end
		if ct < ply:GetNWInt("next_attaque") then return end
        
        if ply:GetNWInt("Technique4") == 0 then return end

		if ply:GetNWInt("mad_stamina") < SKILLS_SL[ply:GetNWInt("Technique4")].stam then ply:ChatPrint("Vous n'avez pu assez de stamina !") return end

        if SKILLS_SL[ply:GetNWInt("Technique4")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique4")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end
		if SKILLS_SL[ply:GetNWInt("Technique4")].element != "none" then
			if SKILLS_SL[ply:GetNWInt("Technique4")].element != ply:GetNWInt("Magie") then return end
		end

        local skill = SKILLS_SL[ply:GetNWInt("Technique4")]
        if skill then
            skill.code(ply)
			ply:Mad_TakeStam(skill.stam)
        end

		ply:SetNWInt("next_attaque4", ct + SKILLS_SL[ply:GetNWInt("Technique4")].coldown )
		ply:SetNWInt("next_attaque", ct + 2 )
end

function SWEP:Attaque5()
	if !IsValid( self ) then return end

	local ply = self:GetOwner()
	local ct = CurTime()

	if ct < ply:GetNWInt("next_attaque5", 0) then return end
		if ct < ply:GetNWInt("next_attaque") then return end
        
        if ply:GetNWInt("Technique5") == 0 then return end

		if ply:GetNWInt("mad_stamina") < SKILLS_SL[ply:GetNWInt("Technique5")].stam then ply:ChatPrint("Vous n'avez pu assez de stamina !") return end

        if SKILLS_SL[ply:GetNWInt("Technique5")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique5")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end
		if SKILLS_SL[ply:GetNWInt("Technique5")].element != "none" then
			if SKILLS_SL[ply:GetNWInt("Technique5")].element != ply:GetNWInt("Magie") then return end
		end
        
        local skill = SKILLS_SL[ply:GetNWInt("Technique5")]
        if skill then
            skill.code(ply)
			ply:Mad_TakeStam(skill.stam)
        end

		ply:SetNWInt("next_attaque5", ct + SKILLS_SL[ply:GetNWInt("Technique5")].coldown )
		ply:SetNWInt("next_attaque", ct + 2 )
end

function SWEP:Attaque6()
	if !IsValid( self ) then return end

	local ply = self:GetOwner()
	local ct = CurTime()

	if ct < ply:GetNWInt("next_attaque6", 0) then return end
		if ct < ply:GetNWInt("next_attaque") then return end
        
        if ply:GetNWInt("Technique6") == 0 then return end

		if ply:GetNWInt("mad_stamina") < SKILLS_SL[ply:GetNWInt("Technique6")].stam then ply:ChatPrint("Vous n'avez pu assez de stamina !") return end

        if SKILLS_SL[ply:GetNWInt("Technique6")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique6")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end
		if SKILLS_SL[ply:GetNWInt("Technique6")].element != "none" then
			if SKILLS_SL[ply:GetNWInt("Technique6")].element != ply:GetNWInt("Magie") then return end
		end

        local skill = SKILLS_SL[ply:GetNWInt("Technique6")]
        if skill then
            skill.code(ply)
			ply:Mad_TakeStam(skill.stam)
        end

		ply:SetNWInt("next_attaque6", ct + SKILLS_SL[ply:GetNWInt("Technique6")].coldown )
		ply:SetNWInt("next_attaque", ct + 2 )
end


function SWEP:DamageCombo()
    if !IsValid(self) then return end
    local ply = self:GetOwner()
    ply:SetAnimation(PLAYER_ATTACK1)
    
    local pos = ply:GetShootPos()
    local aim = ply:GetAimVector()
    local vector = 175
    local radius = 15
    local hitEntities = {}
    
    local angleOffset = 18
    
    self:DesacInvisi()
    
    for i = -angleOffset, angleOffset, 5 do
        local rotatedAim = aim:Angle()
        rotatedAim:RotateAroundAxis(rotatedAim:Up(), i)
        local direction = rotatedAim:Forward()
        
        local slash = {
            start = pos,
            endpos = pos + (direction * vector),
            filter = function(ent)
                if ent:GetClass() == "mad_crystal" or ent == ply then
                    return false
                end
                return true
            end,
            mins = Vector(-radius, -radius, 0),
            maxs = Vector(radius, radius, 0)
        }
        
        local tr = util.TraceHull(slash)
        
        if tr.Hit and IsValid(tr.Entity) and not hitEntities[tr.Entity] then
            local entityClass = tr.Entity:GetClass()
            local isNPC = string.StartWith(entityClass, "mad_")
            
            if (tr.Entity:IsPlayer() or isNPC or tr.Entity:IsNextBot()) then
                hitEntities[tr.Entity] = true
                
                local dmginfo = DamageInfo()
                
                if ply:GetNWInt("Classe") == "porteur" then
                    ply.damage = 3
                else
                    ply.damage = 5
                end
                
                ply.strengthDamage = 0
                if Diablos.TS:IsTrainingEnabled("strength") then
                    ply.strengthDamage = ply:TSGetStrengthDamage()
                    ply.damage = ply.damage * (ply.strengthDamage / 100)
                end
                
                dmginfo:SetDamage(ply.damage + self.BonusDegats)
                dmginfo:SetAttacker(ply)
                dmginfo:SetInflictor(self)
                
                if hook.Run("CheckParrying", tr.Entity, dmginfo) then return end
                
                tr.Entity:TakeDamageInfo(dmginfo)
                tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
                util.ScreenShake(pos, 3, 50, 0.5, 150)
                
                local torsoAttachID = tr.Entity:LookupAttachment("chest")
                
                if torsoAttachID == 0 then
                    if ply:GetNWInt("Combo") == 2 then
                        timer.Simple(0.001, function()
                            ParticleEffect("mudrock", tr.Entity:GetPos() + tr.Entity:GetUp() * 40, Angle(0,0,0), tr.Entity)
                            ParticleEffect("slashhit_base", tr.Entity:GetPos() + tr.Entity:GetUp() * 40, Angle(0,0,0), tr.Entity)
                        end)
                        tr.Entity:SetVelocity(aim * 750)
                    end
                    timer.Simple(0.001, function()
                        ParticleEffect("slashhit_helper_3", tr.Entity:GetPos() + tr.Entity:GetUp() * 40, Angle(0,0,0), tr.Entity)
                    end)
                else
                    if ply:GetNWInt("Combo") == 2 or ply:GetNWInt("Combo") == 3 then
                        timer.Simple(0.001, function()
                            ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID)
                            ParticleEffectAttach("slashhit_base", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID)
                        end)
                        tr.Entity:SetVelocity(aim * 750)
                    end
                    timer.Simple(0.001, function()
                        ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID)
                    end)
                end
            end
        end
    end
end

function SWEP:DamageAttaque(dmg, dist, zonetouch)
    if not IsValid(self) then return end
    local ply = self:GetOwner()

    ply:SetAnimation(PLAYER_ATTACK1)

    local pos = ply:GetShootPos()
    local aim = ply:GetAimVector()
    local vector = dist + 50
    local radius = zonetouch + 20

    local slash = {}
    slash.start = pos
    slash.endpos = pos + (aim * vector)
    slash.filter = function(ent)
        if ent:GetClass() == "mad_crystal" or ent == ply then
            return false
        end
        return true
    end
    slash.mins = Vector(-radius, -radius, 0)
    slash.maxs = Vector(radius, radius, 0)
    local tr = util.TraceHull(slash)        

    self:DesacInvisi()

    if tr.Hit and IsValid(tr.Entity) then
        local entityClass = tr.Entity:GetClass()
        local isNPC = string.StartWith(entityClass, "mad_")

        if (tr.Entity:IsPlayer() or isNPC or tr.Entity:IsNextBot()) then
            local dmginfo = DamageInfo()
            
            if ply:GetNWInt("Classe") == "porteur" then
                ply.damage = dmg/1.2
            else
                ply.damage = dmg
            end

            ply.strengthDamage = 0
            if Diablos.TS:IsTrainingEnabled("strength") then
                ply.strengthDamage = ply:TSGetStrengthDamage()
                ply.damage = ply.damage * (ply.strengthDamage / 100)
            end

            dmginfo:SetDamage(ply.damage + self.BonusDegats)
            dmginfo:SetAttacker(ply)
            dmginfo:SetInflictor(self)

            if hook.Run("CheckParrying", tr.Entity, dmginfo) then return end

            tr.Entity:TakeDamageInfo(dmginfo)

            tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
            util.ScreenShake(pos, 3, 50, 0.5, 150)

            local torsoAttachID = tr.Entity:LookupAttachment("chest")
            if torsoAttachID == 0 then
                timer.Simple(0.001, function()
                    ParticleEffect("mudrock", tr.Entity:GetPos() + tr.Entity:GetUp() * 40, Angle(0,0,0), tr.Entity)
                    ParticleEffect("slashhit_base", tr.Entity:GetPos() + tr.Entity:GetUp() * 40, Angle(0,0,0), tr.Entity)
                    ParticleEffect("slashhit_helper_3", tr.Entity:GetPos() + tr.Entity:GetUp() * 40, Angle(0,0,0), tr.Entity)
                end)
            else
                timer.Simple(0.001, function()
                    ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID)
                    ParticleEffectAttach("slashhit_base", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID)
                    ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID)
                end)
            end
            tr.Entity:SetVelocity(aim * 750)
        end
    end
end


function SWEP:PrimaryAttack()
if not self:IsValid() then return end
local ply = self:GetOwner()
local ct = CurTime()

if ply:GetNWInt("Blocage") == true then return end

	if ct < ply:GetNWInt("next_atk1", 0) then return end
	
	if ply:GetNWInt("Combo") == 0 then
		ply:Mad_SetAnim( "mad_beteattaquesimple1" )
		if ply:IsOnGround() then
			timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
		end
		ply.cd = 0.7
		if Diablos.TS:IsTrainingEnabled("attackspeed") then
			ply.attackspeed = ply:TSGetAttackSpeed() -- 100% of attack speed by default
			ply.cd = ply.cd / (ply.attackspeed / 150)
		end

		ply:SetNWInt("next_atk1", ct + ply.cd )
		self:DamageCombo()
		ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
		ply:SetNWInt("Combo", 1)
	elseif ply:GetNWInt("Combo") == 1 then
		ply:Mad_SetAnim( "mad_beteattaquesimple2" )
		if ply:IsOnGround() then
			timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
		end
		ply.cd = 0.5
		if Diablos.TS:IsTrainingEnabled("attackspeed") then
			ply.attackspeed = ply:TSGetAttackSpeed() -- 100% of attack speed by default
			ply.cd = ply.cd / (ply.attackspeed / 150)
		end

		ply:SetNWInt("next_atk1", ct + ply.cd )
		self:DamageCombo()
		ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
		ply:SetNWInt("Combo", 2)
	elseif ply:GetNWInt("Combo") == 2 then
		ply:Mad_SetAnim( "mad_beteattaquesimple3" )
		if ply:IsOnGround() then
			timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
		end
		ply.cd = 0.8
		if Diablos.TS:IsTrainingEnabled("attackspeed") then
			ply.attackspeed = ply:TSGetAttackSpeed() -- 100% of attack speed by default
			ply.cd = ply.cd / (ply.attackspeed / 150)
		end

		ply:SetNWInt("next_atk1", ct + ply.cd )
		timer_Simple(0.2, function()
			self:DamageCombo()
			ply:SetNWInt("Combo", 3)
		end)
		ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
		timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
		timer_Simple(0.2, function() ply:SetFOV(90, 0.3) end)
		timer_Simple(0.4, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
	elseif ply:GetNWInt("Combo") == 3 then
		ply:Mad_SetAnim( "mad_beteattaquesimple4" )
		if ply:IsOnGround() then
			timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
		end
		ply.cd = 1.7
		if Diablos.TS:IsTrainingEnabled("attackspeed") then
			ply.attackspeed = ply:TSGetAttackSpeed() -- 100% of attack speed by default
			ply.cd = ply.cd / (ply.attackspeed / 150)
		end

		ply:SetNWInt("next_atk1", ct + ply.cd )
		timer_Simple(0.2, function()
			self:DamageCombo()
			ply:SetNWInt("Combo", 0)
		end)
		ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
		timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
		timer_Simple(0.2, function() ply:SetFOV(90, 0.3) end)
		timer_Simple(0.4, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
	end
	
end