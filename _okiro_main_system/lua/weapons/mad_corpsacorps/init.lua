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

local lastKeyPress = {}
local lastDashTime = {}
local doubleTapTime = 0.5 -- Time in seconds within which the double-tap must occur
local dashForce = 4500 -- The force applied for the dash
local dashCooldown = 1 -- cooldown time in seconds

local timer_Simple = timer.Simple
local ents_FindInSphere = ents.FindInSphere

function SWEP:OnDrop()
    self:Remove() -- You can't drop fists
end

function SWEP:Holster()
	if IsValid(self:GetOwner():GetActiveWeapon()) then
		self:GetOwner():GetActiveWeapon():Mad_Debug()
	end
    return true
end

function SWEP:OnRemove()
	if IsValid(self:GetOwner():GetActiveWeapon()) then
	self:GetOwner():GetActiveWeapon():Mad_Debug()
	end
    return true
end

function SWEP:Mad_Debug()
	local ply = self:GetOwner()
    ply:SetModel(ply.AncienPM)
    ply:SetModelScale(1, 2)
    ply:SetLaggedMovementValue(1)
    ply:SetFOV(ply:GetNWInt("FOV"), 1)
    ply:StopParticles()

    ply:SetNWInt("Transforme", false)

    hook.Remove("PlayerButtonDown", self:GetOwner():SteamID().."BINDS_SOLOLEVELING_MAD")
    hook.Remove("PlayerButtonDown", "BINDS_ESQUIVE" .. self:GetOwner():EntIndex())
end

function SWEP:Deploy()

    self.Weapon:SetHoldType( "sl_corpsacorps_ht_mad" )

    local ply = self:GetOwner()
    local activeweapon = ply:GetActiveWeapon()

    ply.AncienPM = ply:GetModel()

    ply:SetNWInt("Transforme", true)

    ply:Freeze(true)
    ply:SetFOV(90, 1)
    ply:Mad_SetAnim("mad_a_p1003_v00_c00_basenut03 retarget")

    timer.Simple(0.001, function()
        ParticleEffectAttach("auraburst_sharp", 4, ply, 0)
        ParticleEffectAttach("dust_conquer_specks", 4, ply, 0)
        ParticleEffectAttach("klkdash_up", 4, ply, 0)
        ParticleEffectAttach("utaunt_electric_mist_parent", 4, ply, 0)
    end)

    ply:EmitSound("mad_sfx_sololeveling/bestial/roar.mp3", 75, math.random(100, 110), 1.5, CHAN_AUTO)
    ply:SetModelScale(1.3, 2)
    timer.Simple(2, function()
        if ply:GetActiveWeapon() != activeweapon then ply:StopParticles() return end
        ParticleEffectAttach("utaunt_electric_mist_parent", 4, ply, 0)
        ply:SetModel("models/mad_models/mad_sl_male_transfo2.mdl")
    end)

    timer.Simple(2, function()
        ply:Freeze(false)
        ply:SetLaggedMovementValue(1.2)
    end)

    hook.Add("PlayerButtonDown", "BINDS_ESQUIVE" .. ply:EntIndex(), function(ply_, button)

        if ply_ ~= ply then return end 

        if not ply_:IsValid() then return end

        local currentTime = CurTime()
        
        if not lastKeyPress[ply_] then
            lastKeyPress[ply_] = {}
        end
        
        if not lastDashTime[ply_] then
            lastDashTime[ply_] = 0
        end

        local function canDash(ply_)
            return (currentTime - lastDashTime[ply_] >= dashCooldown)
        end

        local function executeDash(ply_, direction, animationGround, animationAir, angleOffset)
            ply_:EmitSound(swing_attack[math.random(1, 3)], 75, math.random(120, 130), 0.8, CHAN_AUTO)
            if ply_:IsOnGround() then
                timer.Simple(0.001, function() ParticleEffect("klkdash_up", ply_:GetPos(), ply_:GetAngles() + angleOffset, ply_) end)
                timer.Simple(0.001, function() ParticleEffect("dust_block", ply_:GetPos(), ply_:GetAngles() + angleOffset, ply_) end)
                ply_:SetVelocity(direction * dashForce)
                ply_:Mad_SetAnim(animationGround)
            else
                ply_:SetVelocity(direction * dashForce / 4)
                ply_:Mad_SetAnim(animationAir)
            end
            lastDashTime[ply_] = currentTime -- Set the cooldown timer
        end

        -- Check for double-tap on the movement keys
        if canDash(ply_) then
            if button == KEY_Z then
                if lastKeyPress[ply_][button] and currentTime - lastKeyPress[ply_][button] <= doubleTapTime then
                    executeDash(ply_, ply_:GetForward(), "mad_a_p0020_v00_c00_basestepf01 retarget", "mad_a_p0020_v00_c00_basestepaf01 retarget", Angle(0, 0, 0))
                else
                    lastKeyPress[ply_][button] = currentTime
                end
            elseif button == KEY_S then
                if lastKeyPress[ply_][button] and currentTime - lastKeyPress[ply_][button] <= doubleTapTime then
                    executeDash(ply_, -ply_:GetForward(), "mad_a_p0020_v00_c00_basestepb01 retarget", "mad_a_p0020_v00_c00_basestepab01 retarget", Angle(0, 180, 0))
                else
                    lastKeyPress[ply_][button] = currentTime
                end
            elseif button == KEY_Q then
                if lastKeyPress[ply_][button] and currentTime - lastKeyPress[ply_][button] <= doubleTapTime then
                    executeDash(ply_, -ply_:GetRight(), "mad_a_p0020_v00_c00_basestepl01 retarget", "mad_a_p0020_v00_c00_basestepal01 retarget", Angle(0, 90, 0))
                else
                    lastKeyPress[ply_][button] = currentTime
                end
            elseif button == KEY_D then
                if lastKeyPress[ply_][button] and currentTime - lastKeyPress[ply_][button] <= doubleTapTime then
                    executeDash(ply_, ply_:GetRight(), "mad_a_p0020_v00_c00_basestepr01 retarget", "mad_a_p0020_v00_c00_basestepar01 retarget", Angle(0, -90, 0))
                else
                    lastKeyPress[ply_][button] = currentTime
                end
            end
        end
    end)

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
    local vector = 100 + 50
    local radius = 60
    local owner = self:GetOwner()
    local hitEntities = {}
    
    local angleOffset = 45
    
    for i = -angleOffset, angleOffset, 5 do
        local rotatedAim = aim:Angle()
        rotatedAim:RotateAroundAxis(rotatedAim:Up(), i)
        local direction = rotatedAim:Forward()
        
        local slash = {
            start = owner:GetShootPos(),
            endpos = owner:GetShootPos() + (direction * vector),
            filter = function(ent)
                if ent:GetClass() == "mad_crystal" or ent == owner then
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
                
                ply.damage = 20
                ply.strengthDamage = 0
                if Diablos.TS:IsTrainingEnabled("strength") then
                    ply.strengthDamage = ply:TSGetStrengthDamage()
                    ply.damage = ply.damage * (ply.strengthDamage / 10)
                end
                
                tr.Entity:TakeDamage(ply.damage, ply, self)
                tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
                util.ScreenShake(pos, 3, 50, 0.5, 150)
                
                local function ApplyParticles()
                    local torsoAttachID = tr.Entity:LookupAttachment("chest")
                    
                    if torsoAttachID == 0 then
                        if ply:GetNWInt("Combo") == 2 then
                            ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, 3)
                            ParticleEffectAttach("slashhit_base", PATTACH_POINT_FOLLOW, tr.Entity, 3)
                            tr.Entity:SetVelocity(aim * 750)
                        end
                        ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, 3)
                    else
                        if ply:GetNWInt("Combo") == 2 or ply:GetNWInt("Combo") == 3 then
                            ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID)
                            ParticleEffectAttach("slashhit_base", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID)
                            tr.Entity:SetVelocity(aim * 750)
                        end
                        ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID)
                    end
                end
                
                timer.Simple(0.001, ApplyParticles)
            end
        end
    end
end

function SWEP:DamageAttaque(dmg, dist, zonetouch)
	if not IsValid(self) then return end
	local ply = self:GetOwner()

    ply:SetAnimation( PLAYER_ATTACK1 )

	local pos = ply:GetShootPos()
	local aim = ply:GetAimVector()
	local vector = dist + 100
	local radius = zonetouch + 60

    local owner = self:GetOwner()

    local slash = {}
    slash.start = owner:GetShootPos()
    slash.endpos = owner:GetShootPos() + (owner:GetAimVector() * vector)
    slash.filter = function(ent)
        if ent:GetClass() == "mad_crystal" or ent == owner then
            return false
        end
        return true
    end
    slash.mins = Vector(-radius, -radius, 0)
    slash.maxs = Vector(radius, radius, 0)
    local tr = util.TraceHull(slash)		

    if tr.Hit then
        if IsValid(tr.Entity) then
            local entityClass = tr.Entity:GetClass()
            local isNPC = string.StartWith(entityClass, "mad_")

            if (tr.Entity:IsPlayer() or isNPC or tr.Entity:IsNextBot()) then
                ply.damage = dmg*1.5

                ply.strengthDamage = 0
                if Diablos.TS:IsTrainingEnabled("strength") then
                    ply.strengthDamage = ply:TSGetStrengthDamage()
                    ply.damage = ply.damage * (ply.strengthDamage / 10)
                end

                tr.Entity:TakeDamage(ply.damage, ply, self)

				tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
				util.ScreenShake(pos, 3, 50, 0.5, 150)
				local torsoAttachID = tr.Entity:LookupAttachment("chest")
				if torsoAttachID == 0 then
					timer.Simple(0.001, function() ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, 3) end)
					timer.Simple(0.001, function() ParticleEffectAttach("slashhit_base", PATTACH_POINT_FOLLOW, tr.Entity, 3) end)
					tr.Entity:SetVelocity(aim * 750)
					timer.Simple(0.001, function() ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, 3) end)
				else
					timer.Simple(0.001, function() ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
					timer.Simple(0.001, function() ParticleEffectAttach("slashhit_base", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
					tr.Entity:SetVelocity(aim * 750)
					timer.Simple(0.001, function() ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
				end
			end
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
            ply:Mad_SetAnim( "mad_soryuattaquesimple1" )
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
            ply.cd = 0.4
            if Diablos.TS:IsTrainingEnabled("attackspeed") then
                ply.attackspeed = ply:TSGetAttackSpeed() -- 100% of attack speed by default
                ply.cd = ply.cd / (ply.attackspeed / 150)
            end
    
            ply:SetNWInt("next_atk1", ct + ply.cd )
            self:DamageCombo()
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            ply:SetNWInt("Combo", 1)
        elseif ply:GetNWInt("Combo") == 1 then
            ply:Mad_SetAnim( "mad_soryuattaquesimple2" )
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
            ply.cd = 0.6
            if Diablos.TS:IsTrainingEnabled("attackspeed") then
                ply.attackspeed = ply:TSGetAttackSpeed() -- 100% of attack speed by default
                ply.cd = ply.cd / (ply.attackspeed / 150)
            end
    
            ply:SetNWInt("next_atk1", ct + ply.cd )
            self:DamageCombo()
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            ply:SetNWInt("Combo", 2)
        elseif ply:GetNWInt("Combo") == 2 then
            ply:Mad_SetAnim( "mad_soryuattaquesimple3" )
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
            ply.cd = 0.9
            if Diablos.TS:IsTrainingEnabled("attackspeed") then
                ply.attackspeed = ply:TSGetAttackSpeed() -- 100% of attack speed by default
                ply.cd = ply.cd / (ply.attackspeed / 150)
            end
    
            ply:SetNWInt("next_atk1", ct + ply.cd )
            timer_Simple(0.2, function()
                self:DamageCombo()
                self:DamageCombo()
                ply:SetNWInt("Combo", 3)
            end)
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
        elseif ply:GetNWInt("Combo") == 3 then
            ply:Mad_SetAnim( "mad_soryuattaquelourde3" )
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
                self:DamageCombo()
                ply:SetNWInt("Combo", 0)
            end)
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
        end
        
    end