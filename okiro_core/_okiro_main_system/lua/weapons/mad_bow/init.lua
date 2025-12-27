AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function SWEP:EmitSoundX(...)
    local ply = self:GetOwner()
    ply:EmitSound(...,60,math.random(70,130),0.8,CHAN_AUTO)
end

function SWEP:SetupDataTables()
    self:NetworkVar("Int",0,"WepState")
    self:SetDTInt(0,self.STATE_NONE)
end
function SWEP:PlayActivity(act)
    self:SendWeaponAnim(act)
    local snd = self.ActivitySound[act]
    if snd then
        self:EmitSoundX(snd)
    end
    local t = self.ActivityLength[act]
    if t then
        self:SetNextPrimaryFire(CurTime()+t)
    end
end

function SWEP:Think()
    local ply = self:GetOwner()
    local CT = CurTime()
    local nextFire = self:GetNextPrimaryFire()
    local holdType = self.HoldTypeTranslate[self:GetDTInt(0)]
    if holdType ~= self:GetHoldType() then
        self:SetHoldType(holdType)
    end

    if nextFire >= CT then
        return
    end
    if ply.archerBuff then
        self.ActivityLength = {
            [ACT_VM_PULLBACK] = 0.1,
            [ACT_VM_DRAW] = 0.1,
            [ACT_VM_RELEASE] = 0.1,
            [ACT_VM_IDLE_TO_LOWERED] = 0.1,
        }
    else
        self.ActivityLength = {
            [ACT_VM_PULLBACK] = 0.2,
            [ACT_VM_DRAW] = 1.2,
            [ACT_VM_RELEASE] = 0.5,
            [ACT_VM_IDLE_TO_LOWERED] = 1.25,
        }
    end
    local noClip = self.Owner:GetMoveType() == MOVETYPE_NOCLIP
    local onGround = self.Owner:IsOnGround()
    local AerialAttackActive = ply.AerialAttackActive
    if self:GetDTInt(0) == self.STATE_PULLED then
        if self.Owner:KeyDown(IN_SPEED) then
            self:SetDTInt(0,self.STATE_NOCKED)
            self:PlayActivity(ACT_VM_RELEASE)
        elseif not self.Owner:KeyDown(IN_ATTACK) then
            self:SetDTInt(0,self.STATE_RELEASE)
            self:PlayActivity(ACT_VM_PRIMARYATTACK)
            
            if SERVER then
                local ang = self.Owner:GetAimVector():Angle()
                local pos = self.Owner:EyePos()+ang:Up()*-7+ang:Forward()*30
                local charge = self:GetNextSecondaryFire()
                charge = math.Clamp(CT-charge,0,1)

                local arrow = ents.Create("ent_arrow")
                arrow:SetOwner(self.Owner)
                arrow:SetPos(pos)
                arrow:SetAngles(ang)
                arrow:Spawn()
                arrow:Activate()
                arrow:SetVelocity(ang:Forward()*3000*charge)
                arrow.Weapon = self
            end
        end
    elseif self:GetDTInt(0) == self.STATE_RELEASE then
        if self.Owner:KeyDown(IN_ATTACK) then
            self:SetDTInt(0,self.STATE_NOCKED)
            self:PlayActivity(ACT_VM_LOWERED_TO_IDLE)
            self.Owner.STATE_RELEASE = true
        else
            self:SetDTInt(0,self.STATE_NONE)
            self:PlayActivity(ACT_VM_IDLE_TO_LOWERED)
        end
    elseif self:GetDTInt(0) == self.STATE_NOCKED then
    if AerialAttackActive then
        if self.Owner:KeyDown(IN_ATTACK) and not self.Owner:KeyDown(IN_SPEED) then
            self:SetDTInt(0,self.STATE_PULLED)
            self:PlayActivity(ACT_VM_PULLBACK)
            self:SetNextSecondaryFire(CT)
        end
    else
        if self.Owner:KeyDown(IN_ATTACK) and not (not onGround and not noClip) and not self.Owner:KeyDown(IN_SPEED) then
            self:SetDTInt(0,self.STATE_PULLED)
            self:PlayActivity(ACT_VM_PULLBACK)
            self:SetNextSecondaryFire(CT)
        end
    end
    elseif self:GetDTInt(0) == self.STATE_NONE then
        if self.Owner:KeyPressed(IN_ATTACK) then
            self:SetDTInt(0,self.STATE_NOCKED)
            self:PlayActivity(ACT_VM_LOWERED_TO_IDLE)
        end
    end
end


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
    ply.Inv = false
    ply:SetColor(Color(255,255,255,255))
    ply:DrawWorldModel(true)
    if ply:GetNWBool("IsAdminMode") == false then
        ply:SetNoDraw(false)
    end
    ply:DrawShadow(true)
end

function SWEP:OnDrop()
    self:Remove()
end

function SWEP:Holster()
    local owner = self:GetOwner()
    if IsValid(owner) then
        hook.Remove("PlayerButtonDown",owner:SteamID().."BINDS_SOLOLEVELING_MAD")
    end
    return true
end

function SWEP:OnRemove()
    local owner = self:GetOwner()
    if IsValid(owner) then
        hook.Remove("PlayerButtonDown",owner:SteamID().."BINDS_SOLOLEVELING_MAD")
    end
    return true
end

function SWEP:Deploy()
    self.Weapon:SetHoldType(self.holdtype)
    local ply = self:GetOwner()
    local effectdata = EffectData()
    effectdata:SetOrigin(ply:GetPos())
    effectdata:SetEntity(ply)
    util.Effect("sl_effect10",effectdata,true,true)
    hook.Add("PlayerButtonDown",self:GetOwner():SteamID().."BINDS_SOLOLEVELING_MAD",function(ply_,button)
        if ply_ ~= ply then return end
        if button == ply_:GetInfoNum("sl_attaque1",28) then
            ply_:GetActiveWeapon():Attaque1()
        elseif button == ply_:GetInfoNum("sl_attaque2",28) then
            ply_:GetActiveWeapon():Attaque2()
        elseif button == ply_:GetInfoNum("sl_attaque3",28) then
            ply_:GetActiveWeapon():Attaque3()
        elseif button == ply_:GetInfoNum("sl_attaque4",28) then
            ply_:GetActiveWeapon():Attaque4()
        elseif button == ply_:GetInfoNum("sl_attaque5",28) then
            ply_:GetActiveWeapon():Attaque5()
        elseif button == ply_:GetInfoNum("sl_attaque6",28) then
            ply_:GetActiveWeapon():Attaque6()
        end
    end)
end

function SWEP:Attaque1()
    if !IsValid(self) then return end
    local ply = self:GetOwner()
    local ct = CurTime()
    if ct < ply:GetNWInt("next_attaque1",0) then return end
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
    ply:SetNWInt("next_attaque1",ct+SKILLS_SL[ply:GetNWInt("Technique1")].coldown)
    ply:SetNWInt("next_attaque",ct+2)
end

function SWEP:Attaque2()
    if !IsValid(self) then return end
    local ply = self:GetOwner()
    local ct = CurTime()
    if ct < ply:GetNWInt("next_attaque2",0) then return end
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
    ply:SetNWInt("next_attaque2",ct+SKILLS_SL[ply:GetNWInt("Technique2")].coldown)
    ply:SetNWInt("next_attaque",ct+2)
end

function SWEP:Attaque3()
    if !IsValid(self) then return end
    local ply = self:GetOwner()
    local ct = CurTime()
    if ct < ply:GetNWInt("next_attaque3",0) then return end
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
    ply:SetNWInt("next_attaque3",ct+SKILLS_SL[ply:GetNWInt("Technique3")].coldown)
    ply:SetNWInt("next_attaque",ct+2)
end

function SWEP:Attaque4()
    if !IsValid(self) then return end
    local ply = self:GetOwner()
    local ct = CurTime()
    if ct < ply:GetNWInt("next_attaque4",0) then return end
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
    ply:SetNWInt("next_attaque4",ct+SKILLS_SL[ply:GetNWInt("Technique4")].coldown)
    ply:SetNWInt("next_attaque",ct+2)
end

function SWEP:Attaque5()
    if !IsValid(self) then return end
    local ply = self:GetOwner()
    local ct = CurTime()
    if ct < ply:GetNWInt("next_attaque5",0) then return end
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
    ply:SetNWInt("next_attaque5",ct+SKILLS_SL[ply:GetNWInt("Technique5")].coldown)
    ply:SetNWInt("next_attaque",ct+2)
end

function SWEP:Attaque6()
    if !IsValid(self) then return end
    local ply = self:GetOwner()
    local ct = CurTime()
    if ct < ply:GetNWInt("next_attaque6",0) then return end
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
    ply:SetNWInt("next_attaque6",ct+SKILLS_SL[ply:GetNWInt("Technique6")].coldown)
    ply:SetNWInt("next_attaque",ct+2)
end