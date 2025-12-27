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

function SWEP:OnDrop()
    self:Remove() -- You can't drop fists
end

function SWEP:Holster()
    local owner = self:GetOwner()
    if IsValid(owner) then
        hook.Remove("PlayerButtonDown", owner:SteamID().."BINDS_SOLOLEVELING_MAD")
    end
    return true
end

function SWEP:OnRemove()
    local owner = self:GetOwner()
    if IsValid(owner) then
        hook.Remove("PlayerButtonDown", owner:SteamID().."BINDS_SOLOLEVELING_MAD")
    end
    return true
end

function SWEP:Deploy()
	
	self.Weapon:SetHoldType( self.holdtype )

	local ply = self:GetOwner()

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

        if SKILLS_SL[ply:GetNWInt("Technique1")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique1")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end

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

        if SKILLS_SL[ply:GetNWInt("Technique2")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique2")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end

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

        if SKILLS_SL[ply:GetNWInt("Technique3")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique3")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end

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

        if SKILLS_SL[ply:GetNWInt("Technique4")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique4")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end

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

        if SKILLS_SL[ply:GetNWInt("Technique5")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique5")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end
        
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

        if SKILLS_SL[ply:GetNWInt("Technique6")].type != self.TypeArme then ply:ChatPrint("Vous ne possédez pas l'arme nécessaire.") return end
        if ply:GetNWInt("Classe") != SKILLS_SL[ply:GetNWInt("Technique6")].classe then ply:ChatPrint("Vous ne possédez pas la bonne classe.") return end

        local skill = SKILLS_SL[ply:GetNWInt("Technique6")]
        if skill then
            skill.code(ply)
            ply:Mad_TakeStam(skill.stam)
        end

		ply:SetNWInt("next_attaque6", ct + SKILLS_SL[ply:GetNWInt("Technique6")].coldown )
		ply:SetNWInt("next_attaque", ct + 2 )
end


function SWEP:DamageCombo()
	if !IsValid( self ) then return end
	local ply = self:GetOwner()
	
		local pos = ply:GetShootPos()
		local aim = ply:GetAimVector()
		local vector = 100
		local radius = 35

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
                if (IsValid(tr.Entity) and tr.Entity:IsPlayer() or tr.Entity:IsNPC() and IsValid(tr.Entity) or tr.Entity:IsNextBot() and IsValid(tr.Entity)) then
                    tr.Entity:TakeDamage(5, ply, self)
                    tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
                    util.ScreenShake(pos, 3, 50, 0.5, 150)
                    local torsoAttachID = tr.Entity:LookupAttachment("chest")
                    if torsoAttachID == 0 then
                        if ply:GetNWInt("Combo") == 2 then
                            timer.Simple(0.001, function() ParticleEffect( "mudrock", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                            timer.Simple(0.001, function() ParticleEffect( "slashhit_flash_2", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                            tr.Entity:SetVelocity(aim * 750)
                        end
                        timer.Simple(0.001, function() ParticleEffect( "slashhit_helper_3", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                    else
                        if ply:GetNWInt("Combo") == 2 or ply:GetNWInt("Combo") == 3 then
                            timer.Simple(0.001, function() ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                            timer.Simple(0.001, function() ParticleEffectAttach("slashhit_flash_2", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                            tr.Entity:SetVelocity(aim * 750)
                        end
                        timer.Simple(0.001, function() ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                    end
                end
            end
        end
    end

function SWEP:DamageAttaque(dmg, dist, zonetouch)
	if not IsValid(self) then return end
	local ply = self:GetOwner()

	local pos = ply:GetShootPos()
	local aim = ply:GetAimVector()
	local vector = dist + 50
	local radius = zonetouch + 20

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
			if (IsValid(tr.Entity) and tr.Entity:IsPlayer() or tr.Entity:IsNPC() and IsValid(tr.Entity) or tr.Entity:IsNextBot() and IsValid(tr.Entity)) then
				tr.Entity:TakeDamage(dmg, ply, self)
				tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
				util.ScreenShake(pos, 3, 50, 0.5, 150)
				local torsoAttachID = tr.Entity:LookupAttachment("chest")
				if torsoAttachID == 0 then
					timer.Simple(0.001, function() ParticleEffect( "mudrock", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
					timer.Simple(0.001, function() ParticleEffect( "slashhit_flash_2", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
					tr.Entity:SetVelocity(aim * 750)
					timer.Simple(0.001, function() ParticleEffect( "slashhit_helper_3", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
				else
					timer.Simple(0.001, function() ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
					timer.Simple(0.001, function() ParticleEffectAttach("slashhit_flash_2", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
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
		ply:Mad_SetAnim( "mad_sonattaquesimple1" )
		if ply:IsOnGround() then
			timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
		end
		ply:SetNWInt("next_atk1", ct + 0.7 )
		self:DamageCombo()
		ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
		ply:SetNWInt("Combo", 1)
	elseif ply:GetNWInt("Combo") == 1 then
		ply:Mad_SetAnim( "mad_sonattaquesimple2" )
		if ply:IsOnGround() then
			timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
		end
		ply:SetNWInt("next_atk1", ct + 0.5 )
		self:DamageCombo()
		ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
		ply:SetNWInt("Combo", 2)
	elseif ply:GetNWInt("Combo") == 2 then
		ply:Mad_SetAnim( "mad_sonattaquesimple3" )
		if ply:IsOnGround() then
			timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
		end
		ply:SetNWInt("next_atk1", ct + 0.8 )
		timer_Simple(0.2, function()
			self:DamageCombo()
			self:DamageCombo()
			ply:SetNWInt("Combo", 3)
		end)
		ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
		timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
		timer_Simple(0.2, function() ply:SetFOV(90, 0.3) end)
		timer_Simple(0.4, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
	elseif ply:GetNWInt("Combo") == 3 then
		ply:Mad_SetAnim( "mad_son6ememouvement" )
		if ply:IsOnGround() then
			timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
		end
		ply:SetNWInt("next_atk1", ct + 1.7 )
		timer_Simple(0.2, function()
			self:DamageCombo()
			self:DamageCombo()
			ply:SetNWInt("Combo", 0)
		end)
		ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
		timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
		timer_Simple(0.2, function() ply:SetFOV(90, 0.3) end)
		timer_Simple(0.4, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
	end
	
end