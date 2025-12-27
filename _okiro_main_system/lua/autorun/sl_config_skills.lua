-- type : "corpsacorps" == arme poings
-- type : "sword" == arme epeiste
-- type : "marteau" == arme tank
-- type : "magie" == arme poings && baton

game.AddParticles("particles/union_sololeveling_mage21.pcf")
game.AddParticles("particles/union_sololeveling_mage22.pcf")
game.AddParticles("particles/union_sololeveling_mage13.pcf")

local particlename = {
    "[mad_union]_lightning_sphere_impacta",
	"[union_mage]_light_projectile",
    "[tenebre]_lonelymoon",
    "[tenebre]_moon_vortex",
}

for _, v in ipairs(particlename) do PrecacheParticleSystem(v) end

local timer_Simple = timer.Simple
local ents_FindInSphere = ents.FindInSphere

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

local dash_sfx = "mad_sfx_sololeveling/normal/xiangze_dashatk.ogg"

SKILLS_SL = {
    ["epeiste1"] = {
        stam = 25,
        name = "Slash Rapide",
        level = 2,
        icon = "mad_sololeveling/skills/icons/slashrapide.png",
        classe = "epeiste",
        coldown = 3,
        type = "sword",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_foudreattaquesimple2" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(50, 50, 25)
            end)

        end,
    },

    ["epeiste2"] = {
        stam = 50,
        name = "Coup Violent",
        level = 10,
        icon = "mad_sololeveling/skills/icons/attack20.png",
        classe = "epeiste",
        coldown = 5,
        type = "sword",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_eauattaquelourde3" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(75, 75, 35)
            end)

        end,
    },

    ["epeiste3"] = {
        stam = 75,
        name = "Revers de Lame",
        level = 20,
        icon = "mad_sololeveling/skills/icons/attack17.png",
        classe = "epeiste",
        coldown = 5,
        type = "sword",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_soleilattaquelourde3" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
    
            timer_Simple(0.5,function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(100, 100, 35)
            end)

        end,
    },

    ["epeiste4"] = {
        stam = 125,
        name = "Tempête de lames",
        level = 30,
        icon = "mad_sololeveling/skills/icons/attack14.png",
        classe = "epeiste",
        coldown = 7,
        type = "sword",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_flammeattaquelourde3" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end

            timer_Simple(0.15,function()
                ply:GetActiveWeapon():DamageAttaque(150, 150, 35)
            end)
    
            timer_Simple(0.8,function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(150, 150, 35)
            end)

        end,
    },

    ["epeiste5"] = {
        stam = 175,
        name = "Groundcrack",
        level = 35,
        icon = "mad_sololeveling/skills/icons/attack18.png",
        classe = "epeiste",
        coldown = 10,
        type = "sword",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_eau6ememouvement" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
    
            timer_Simple(1,function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(250, 250, 35)

                ParticleEffect( "[union]_rock_smash", ply:GetPos()+ply:GetForward()*75, ply:GetAngles() )
            end)

        end,
    },

    ["epeiste6"] = {
        stam = 225,
        name = "Aura Slash",
        level = 45,
        icon = "mad_sololeveling/skills/icons/attack25.png",
        classe = "epeiste",
        coldown = 12,
        type = "sword",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_flamme3ememouvement" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect1", effectdata, true, true )

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            timer_Simple(0.4,function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(300, 300, 35)
                timer_Simple(0.001, function() ParticleEffect( "[2]_fog_slash_add", ply:GetPos()+ply:GetUp()*35+ply:GetForward()*35, ply:GetAngles() + Angle(-120,90,90), ply ) end)
            end)

        end,
    },

    ["epeiste7"] = {
        stam = 300,
        name = "Transcendent Slash",
        level = 55,
        icon = "mad_sololeveling/skills/icons/attack26.png",
        classe = "epeiste",
        coldown = 15,
        type = "sword",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_foudre5ememouvement" )
            

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffectAttach("[mad_sl] epeiste1", 4, ply, 0)
            end)

            timer.Simple(0.2, function()
                timer.Create("Attack_TranscendentSlash_Epeiste"..ply:SteamID(), 0.2, 9, function()
                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                    ply:GetActiveWeapon():DamageAttaque(425, 425, 35)
                end)
            end)

        end,
    },


    ["porteur1"] = {
        stam = 10,
        name = "Coup Rapide",
        level = 2,
        icon = "mad_sololeveling/skills/icons/slashrapide.png",
        classe = "porteur",
        coldown = 3,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_foudreattaquesimple2" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(30, 30, 25)
            end)

        end,
    },

    ["porteur2"] = {
        stam = 25,
        name = "Cassage",
        level = 10,
        icon = "mad_sololeveling/skills/icons/attack20.png",
        classe = "porteur",
        coldown = 5,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_eauattaquelourde3" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(50, 50, 35)
            end)

        end,
    },

    ["porteur3"] = {
        stam = 50,
        name = "Revers de Dague",
        level = 15,
        icon = "mad_sololeveling/skills/icons/attack17.png",
        classe = "porteur",
        coldown = 5,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_soleilattaquelourde3" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
    
            timer_Simple(0.5,function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(75, 75, 35)
            end)

        end,
    },

    ["porteur4"] = {
        stam = 100,
        name = "Tempête",
        level = 20,
        icon = "mad_sololeveling/skills/icons/attack14.png",
        classe = "porteur",
        coldown = 9,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_flammeattaquelourde3" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end

            timer_Simple(0.15,function()
                ply:GetActiveWeapon():DamageAttaque(50, 50, 35)
            end)
    
            timer_Simple(0.8,function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(50, 50, 35)
            end)

        end,
    },

    ["porteur5"] = {
        stam = 150,
        name = "Écrassement",
        level = 25,
        icon = "mad_sololeveling/skills/icons/attack18.png",
        classe = "porteur",
        coldown = 12,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_eau6ememouvement" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
    
            timer_Simple(1,function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(185, 185, 35)
            end)

        end,
    },

    ["tank1"] = {
        stam = 25,
        name = "Frappé",
        level = 2,
        icon = "mad_sololeveling/skills/icons/tank3.png",
        classe = "tank",
        coldown = 3,
        type = "marteau",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_an_hero_asta_combat_grim_skill_01 retarget" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
            end)

            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
    
            timer_Simple(0.8,function()
                ply:EmitSound( "mad_sfx_sololeveling/punch/sakazuki_LavaPunch01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(40, 40, 35)

                ParticleEffect( "[union]_rock_smash", ply:GetPos()+ply:GetForward()*75, ply:GetAngles() )
            end)

        end,
    },

    ["tank2"] = {
        stam = 50,
        name = "Séisme",
        level = 10,
        icon = "mad_sololeveling/skills/icons/tank1.png",
        classe = "tank",
        coldown = 5,
        type = "marteau",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_an_hero_siren_combat_grim_skill_02_end retarget" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffectAttach("[19]_rock_circle", 4, ply, 0)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
    
            timer_Simple(1.2,function()
                ply:EmitSound( "mad_sfx_sololeveling/punch/sakazuki_LavaPunch01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(75, 75, 35)

                ply:StopParticles()
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
                ParticleEffect( "[union]_rock_smash", ply:GetPos()+ply:GetForward()*75, ply:GetAngles() )
            end)

        end,
    },

    ["tank3"] = {
        stam = 150,
        name = "Protection",
        level = 15,
        icon = "mad_sololeveling/skills/icons/tank2.png",
        classe = "tank",
        coldown = 10,
        type = "marteau",
        ismagie = false,
        element = "none",
        code = function(ply)

            

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "tank_buff", effectdata, true, true )

            timer_Simple(0.0001, function()
                ply:SetNWBool("BuffTank", true)
                util.ScreenShake( ply:GetPos(), 3, 50, 0.5, 150 )
                ply:EmitSound( dash_sfx, 75, math.random(90, 100), 1.7, CHAN_AUTO )  
            end)
    
            timer_Simple(6, function()
                ply:SetNWBool("BuffTank", false)
                hook.Remove("EntityTakeDamage", "BuffTank"..ply:SteamID())
            end)
    
            hook.Add("EntityTakeDamage", "BuffTank"..ply:SteamID(), function(target, dmginfo) 
                if target:IsPlayer() and target:GetNWBool("BuffTank") == true then
                    dmginfo:ScaleDamage( 0.5 ) // Damage is now half of what you would normally take.
                end
            end)

        end,
    },

    ["tank4"] = {
        stam = 100,
        name = "Renforcement du Marteau",
        level = 20,
        icon = "mad_sololeveling/skills/icons/tank4.png",
        classe = "tank",
        coldown = 8,
        type = "marteau",
        ismagie = false,
        element = "none",
        code = function(ply)

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "tank_enchancement", effectdata, true, true )

            ply:Mad_SetAnim( "mad_an_hero_siren_combat_skill_01 retarget" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end

            timer_Simple(0.75, function() ParticleEffect( "[19]_rock_slash_add", ply:GetPos()+ply:GetUp()*35+ply:GetForward()*35, ply:GetAngles() + Angle(-120,90,90), ply ) end)
            timer_Simple(0.75, function() ParticleEffect( "[19]_rock_slash_add", ply:GetPos()+ply:GetUp()*35+ply:GetForward()*35, ply:GetAngles() + Angle(120,90,90), ply ) end)

            timer_Simple(0.8,function()
                ply:EmitSound( "mad_sfx_sololeveling/punch/sakazuki_LavaPunch03.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(170, 170, 45)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
                ParticleEffect( "[union]_rock_smash", ply:GetPos()+ply:GetForward()*75, ply:GetAngles() )
            end)

        end,
    },

    ["tank5"] = {
        stam = 250,
        name = "Dome Protection",
        level = 25,
        icon = "mad_sololeveling/skills/icons/tank5.png",
        classe = "tank",
        coldown = 20,
        type = "marteau",
        ismagie = false,
        element = "none",
        code = function(ply)
            local effectdata = EffectData()
            effectdata:SetOrigin( ply:GetPos() )
            effectdata:SetEntity( ply )
            util.Effect( "tank_enchancement", effectdata, true, true )

            ply:Mad_SetAnim( "mad_flammeconcentration" )

            ply:EmitSound( "mad_sfx_sololeveling/sword/mihawknew_S7_swordwind.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO )     

            ply.dome = ents.Create("prop_dynamic")
            ply.dome:SetModel("models/yugend/models/black_clover/skill/yuno/bc_yuno_move2b_ball2.mdl")
            ply.dome:SetModelScale(140, 0.75)
            -- ply.dome:SetMaterial("models/debug/debugwhite")
            -- ply.dome:SetRenderMode( RENDERMODE_TRANSCOLOR )
            ply.dome:SetColor( Color(127,255,255,100) )
            ply.dome:SetPos(ply:GetPos())
            ply.dome:Spawn()

            ply:Freeze(true)
            timer.Simple(3.5, function()
                ply:Freeze(false)
            end)

            timer.Simple(0.8, function()
                timer.Create("TankDefense"..ply:SteamID64(), 0.2, 27.5, function()
                    if not IsValid(ply.dome) then timer.Remove("TankDefense"..ply:SteamID64()) return end
                    for k, v in ipairs( ents.FindInSphere( ply.dome:GetPos(), 250 ) ) do
    
                        if v:IsNPC() or v:IsNextBot() then
                            v:SetVelocity(v:GetForward()*-600)
                        end
    
                        if v:IsPlayer() then
                            if v:Health() < v:GetMaxHealth() then
                                if v:Health() < v:GetMaxHealth() - 2 then
                                    v:SetHealth(v:Health()+2)
                                else
                                    v:SetHealth(v:GetMaxHealth())
                                end
                            end
    
                            local effectdata = EffectData()
                            effectdata:SetOrigin( v:GetPos() )
                            effectdata:SetEntity( v )
                            util.Effect( "sl_effect3", effectdata, true, true )
    
                        end
                    end
                end)
            end)

            timer.Simple(6, function()
                if IsValid(ply.dome) then
                    ply.dome:SetModelScale(0, 0.75)

                    timer.Simple(1.5, function()
                        if IsValid(ply.dome) then
                            ply.dome:Remove()
                        end
                    end)
                end
            end)
        end,
    },

    ["tank6"] = {
        stam = 150,
        name = "Météore",
        level = 30,
        icon = "mad_sololeveling/skills/icons/tank6.png",
        classe = "tank",
        coldown = 11,
        type = "marteau",
        ismagie = false,
        element = "none",
        code = function(ply)

            
            
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_roche3ememouvement" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[26]_snake_catch", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(2,function()

                ParticleEffect( "[8]_howl", ply:GetPos(), ply:GetAngles() + Angle(0,90,0), ply ) 
                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/normal/Punch_Explosion_02.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				

                for i=1,10 do 
                    
                    ParticleEffect( "[union]_rock_smash", ply:GetPos()+ply:GetForward()*75*i, ply:GetAngles() )
                    util.ScreenShake(ply:GetPos()+ply:GetForward()*75*i, 3, 50, 0.5, 250)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:SetMoveType(MOVETYPE_WALK)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(270, 270, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

        end,
    },

    ["tank7"] = {
        stam = 175,
        name = "Riposte",
        level = 35,
        icon = "mad_sololeveling/skills/icons/tank7.png",
        classe = "tank",
        coldown = 14,
        type = "marteau",
        ismagie = false,
        element = "none",
        code = function(ply)

            
            
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_an_hero_asta_combat_skill_01 retarget" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[19]_rock_circle", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[9]_swirl_add_3", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[5]_ash_dash", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)

            timer_Simple(0.5, function() 
                ply:StopParticles()
                ply:ViewPunch(Angle(0, 0, 10)) 
                ply:GetActiveWeapon():DamageAttaque(50, 350, 35)
            end)

            timer_Simple(1.2, function()
                ParticleEffect( "[5]_ash_catch", ply:GetPos(), ply:GetAngles() + Angle(0,-90,0), ply ) 
                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/normal/Punch_Explosion_02.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				

                for i=1,3 do 
                    
                    ParticleEffect( "[union]_rock_smash", ply:GetPos()+ply:GetForward()*75*i, ply:GetAngles() )
                    util.ScreenShake(ply:GetPos()+ply:GetForward()*75*i, 3, 50, 0.5, 250)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(450, 450, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

        end,
    },

    ["feu1"] = {
        stam = 25,
        name = "Boule de feu",
        level = 2,
        icon = "mad_sololeveling/skills/icons/magie18.png",
        classe = "mage",
        coldown = 3,
        type = "magie",
        ismagie = true,
        element = "feu",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.5, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(45, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[sl_mage]_fire_tiger_projectile", "[sl_mage]_fireball"}, 750)
            end)

        end,
    },

    ["feu2"] = {
        stam = 50,
        name = "Canon Rail de Feu",
        level = 10,
        icon = "mad_sololeveling/skills/icons/magie17.png",
        classe = "mage",
        coldown = 5,
        type = "magie",
        ismagie = true,
        element = "feu",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquesimple1" )
            
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(25, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[sl_mage]_fire_tiger_projectile", "[sl_mage]_fireball"}, 750)
            end)

            timer_Simple(0.6, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(25, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[sl_mage]_fire_tiger_projectile", "[sl_mage]_fireball"}, 750)
            end)

            timer_Simple(0.8, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(25, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[sl_mage]_fire_tiger_projectile", "[sl_mage]_fireball"}, 750)
            end)

        end,
    },

    ["feu3"] = {
        stam = 75,
        name = "Cercle de Feu",
        level = 15,
        icon = "mad_sololeveling/skills/icons/magie16.png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "feu",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquelourde3" )
            
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(120, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[10]_spin_dash"}, 750)
            end)

        end,
    },

    ["feu4"] = {
        stam = 125,
        name = "Éruption de Feu",
        level = 20,
        icon = "mad_sololeveling/skills/icons/magie15.png",
        classe = "mage",
        coldown = 9,
        type = "magie",
        ismagie = true,
        element = "feu",
        code = function(ply)

            
            
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_fils3emeattaque" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(2,function()

                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/normal/Punch_Explosion_02.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				

                for i=1,4 do 
                    
                    ParticleEffect( "[10]_fire_blast", ply:GetPos()+ply:GetForward()*75*i, ply:GetAngles() )
                    util.ScreenShake(ply:GetPos()+ply:GetForward()*75*i, 3, 50, 0.5, 250)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                            tr.Entity:Ignite(3, 4)
                        end
                    end
                end

                ply:SetMoveType(MOVETYPE_WALK)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(175, 175, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

        end,
    },

    ["feu5"] = {
        stam = 155,
        name = "Concentration de Feu",
        level = 25,
        icon = "mad_sololeveling/skills/icons/magie13.png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "feu",
        code = function(ply)

            

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(225, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[10]_unknowing_fire", "[10]_blazing_universe"}, 750)
            end)

        end,
    },

    ["feu6"] = {
        stam = 200,
        name = "Téléportation de Feu",
        level = 30,
        icon = "mad_sololeveling/skills/icons/magie12.png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "feu",
        code = function(ply)

        
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_filseveil" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[10]_fire_tiger_sword", ply:GetPos()+ply:GetForward()*75+ply:GetUp()*75, ply:GetAngles()+Angle(0,90,0), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[sl_mage_feu]_nezuko_ground_small", ply:GetPos(), ply:GetAngles(), ply ) 
            end)

            timer_Simple(2, function()

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_Fire01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()
                ParticleEffect( "[10]_rengoku_start", ply:GetPos(), ply:GetAngles(), ply ) 

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(145, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[sl_mage]_fire_tiger_projectile", "[sl_mage]_fireball", "[10]_unknowing_add_2", "[3]_blue_sky", "[sl_mage_feu]_nezuko_projectile"}, 750)
                timer_Simple(1.6,function()
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_Fire01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		

                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                    ply:GetActiveWeapon():DamageLaunch(145, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[sl_mage]_fire_tiger_projectile", "[sl_mage]_fireball", "[10]_unknowing_add_2", "[3]_blue_sky", "[sl_mage_feu]_nezuko_projectile"}, 750)
                end)
            end)

        end,
    },

    ["feu7"] = {
        stam = 300,
        name = "Tornade de Feu",
        level = 35,
        icon = "mad_sololeveling/skills/icons/magie9.png",
        classe = "mage",
        coldown = 30,
        type = "magie",
        ismagie = true,
        element = "feu",
        code = function(ply)

            

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_fl??che5emeattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ply:EmitSound( "mad_sfx_sololeveling/fire/Margo_fire.ogg", 75, math.random(60, 75), 1, CHAN_AUTO ) 		
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[10]_fire_tiger_sword", ply:GetPos()+ply:GetForward()*75+ply:GetUp()*75, ply:GetAngles()+Angle(0,90,0), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[sl_mage_feu]_nezuko_ground_small", ply:GetPos(), ply:GetAngles(), ply ) 
            end)

            timer_Simple(2, function()

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_Fire01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                ply:EmitSound( "mad_sfx_sololeveling/fire/hong_skillW_fire.ogg", 85, math.random(70, 130), 1.5, CHAN_AUTO ) 		
                ply:EmitSound( "mad_sfx_sololeveling/fire/LavaFIreBoiling.ogg", 85, math.random(60, 75), 1, CHAN_AUTO ) 		

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()

                
            ply.feu7 = ents.Create("prop_dynamic")
            ply.feu7:SetModel("models/props_phx/construct/glass/glass_dome360.mdl")
            ply.feu7:SetRenderMode( RENDERMODE_TRANSCOLOR ) 
            ply.feu7:SetColor( Color(127,255,255,0) )
            ply.feu7:SetPos(ply:GetPos())
            ply.feu7:Spawn()

            timer_Simple(0.001,function()
                ParticleEffect( "[10]_rengoku_tornado", ply:GetPos(), ply:GetAngles(), ply ) 
            end)

            timer.Create("Feu7Attack"..ply:SteamID64(), 0.2, 25, function()
                if not IsValid(ply.feu7) then timer.Remove("Feu7Attack"..ply:SteamID64()) return end
                for k, v in ipairs( ents.FindInSphere( ply.feu7:GetPos(), 500 ) ) do
                    if v != ply and v != ply.feu7 then
                        v:TakeDamage(37+ply:GetActiveWeapon().BonusDegats, ply)
                    end
                end
            end)

            timer.Simple(5, function()
                if IsValid(ply.feu7) then ply.feu7:Remove() end
                ply:StopParticles()
            end)

            end)

        end,
    },

    ["eau1"] = {
        stam = 25,
        name = "Boule d'Eau",
        level = 2,
        icon = "mad_sololeveling/skills/icons/eau1.png",
        classe = "mage",
        coldown = 3,
        type = "magie",
        ismagie = true,
        element = "eau",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.5, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/water/jinbe_Water02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(45, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/water/se_waterhit4.ogg", 60, 80, false, 0, {"[union_mage]_water_projectile"}, 750)
            end)

        end,
    },

    ["eau2"] = {
        stam = 50,
        name = "Jet d'Eau",
        level = 10,
        icon = "mad_sololeveling/skills/icons/a (250).png",
        classe = "mage",
        coldown = 5,
        type = "magie",
        ismagie = true,
        element = "eau",
        code = function(ply)

            ply:Mad_SetAnim( "mad_an_hero_william_combat_skill_02_end retarget" )
            

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.1, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/water/jinbe_Water02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                
                ply:GetActiveWeapon():DamageAttaque(75, 75, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
                timer.Simple(0.001,function() ParticleEffect( "[4]_water_jet", ply:GetPos()+ply:GetForward()*35+ply:GetUp()*45, ply:GetAngles(), ply ) end)
                timer_Simple(1,function() ply:StopParticles() end)
            end)

        end,
    },

    ["eau3"] = {
        stam = 75,
        name = "Onde Aquatique",
        level = 15,
        icon = "mad_sololeveling/skills/icons/magie16.png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "eau",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquelourde3" )
            

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/water/jinbe_Water02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                ply:GetActiveWeapon():DamageLaunch(120, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/water/se_waterhit4.ogg", 60, 80, false, 0, {"[union_mage]_water_projectile", "[mage_union]_water_circle"}, 750)	
            end)

        end,
    },

    ["eau4"] = {
        stam = 125,
        name = "Éruption d'Eau",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (245).png",
        classe = "mage",
        coldown = 9,
        type = "magie",
        ismagie = true,
        element = "eau",
        code = function(ply)

            
            
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_fils3emeattaque" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(2,function()

                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/water/jinbe_Water06.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				

                for i=1,4 do 
                    
                    ParticleEffect( "[9]_water_tornado", ply:GetPos()+ply:GetForward()*95*i, ply:GetAngles(), ply )
                    util.ScreenShake(ply:GetPos()+ply:GetForward()*75*i, 3, 50, 0.5, 250)

                    timer_Simple(0.9, function() ply:StopParticles() end)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:SetMoveType(MOVETYPE_WALK)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(175, 175, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

        end,
    },

    ["eau5"] = {
        stam = 155,
        name = "Concentration d'Eau",
        level = 25,
        icon = "mad_sololeveling/skills/icons/a (170).png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "eau",
        code = function(ply)

            

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/water/jinbe_Water06.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                
                timer_Simple(0.001, function() 
                    ParticleEffect( "[9]_shtil", ply:GetPos(), ply:GetAngles(), ply ) 
                    ParticleEffect( "[9]_water_trap", ply:GetPos(), ply:GetAngles(), ply ) 
                    util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
                    timer_Simple(0.5,function()
                        ply:StopParticles()
                    end)

                    for k, v in ipairs( ents.FindInSphere( ply:GetPos(), 350 ) ) do
                        if v != ply then
                            if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                                v:TakeDamage(225+ply:GetActiveWeapon().BonusDegats, ply)
                            end
                        end
                    end
                end)

            end)

        end,
    },

    ["eau6"] = {
        stam = 200,
        name = "Téléportation Aquatique",
        level = 30,
        icon = "mad_sololeveling/skills/icons/magie12.png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "eau",
        code = function(ply)

            

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_filseveil" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[mage_union]_water_circle", ply:GetPos()+ply:GetForward()*75+ply:GetUp()*75, ply:GetAngles()+Angle(0,0,0), ply ) 
                ParticleEffect( "[9]_shtil", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[9]_water_trap", ply:GetPos(), ply:GetAngles(), ply ) 
                ply:EmitSound( "mad_sfx_sololeveling/water/jinbe_Water06.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            end)

            timer_Simple(2, function()

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()
                ParticleEffect( "[4]_compass_impact", ply:GetPos(), ply:GetAngles(), ply ) 

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(145, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/water/se_waterhit4.ogg", 60, 80, false, 0, {"[union_mage]_water_projectile", "[sl_mage]_waterball", "[mage_union]_water_circle", "[20]_forward_dash_main"}, 750)
                timer_Simple(1.6,function()
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_Fire01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		

                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                    ply:GetActiveWeapon():DamageLaunch(145, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/water/se_waterhit4.ogg", 60, 80, false, 0, {"[union_mage]_water_projectile", "[sl_mage]_waterball", "[mage_union]_water_circle", "[20]_forward_dash_main"}, 750)
                end)
            end)

        end,
    },

    
    ["eau7"] = {
        stam = 300,
        name = "Tornade d'Eau",
        level = 35,
        icon = "mad_sololeveling/skills/icons/a (246).png",
        classe = "mage",
        coldown = 30,
        type = "magie",
        ismagie = true,
        element = "eau",
        code = function(ply)

            

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_fl??che5emeattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[mage_union]_water_circle", ply:GetPos()+ply:GetForward()*75+ply:GetUp()*75, ply:GetAngles()+Angle(0,0,0), ply ) 
                ParticleEffect( "[9]_shtil", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[9]_water_trap", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[9]_swirl", ply:GetPos(), ply:GetAngles(), ply ) 
                ply:EmitSound( "mad_sfx_sololeveling/water/jinbe_Water06.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 		
            end)

            timer_Simple(2, function()

                ply:EmitSound( "mad_sfx_sololeveling/water/se_waterexplosion.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                ply:EmitSound( "mad_sfx_sololeveling/water/jinbe_Water06.ogg", 85, math.random(70, 130), 1.5, CHAN_AUTO ) 		
                ply:EmitSound( "mad_sfx_sololeveling/water/se_WaterBurst01.ogg", 85, math.random(60, 75), 1, CHAN_AUTO ) 		

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()

                
            ply.eau7 = ents.Create("prop_dynamic")
            ply.eau7:SetModel("models/props_phx/construct/glass/glass_dome360.mdl")
            ply.eau7:SetRenderMode( RENDERMODE_TRANSCOLOR )
            ply.eau7:SetColor( Color(127,255,255,0) )
            ply.eau7:SetPos(ply:GetPos())
            ply.eau7:Spawn()

            timer_Simple(0.001,function()
                ParticleEffect( "[9]_urokodaki_special", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[9]_bubble_explosion", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[0]_rain", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[0]_rain_main", ply:GetPos()+ply:GetUp()*1000, ply:GetAngles(), ply ) 
            end)

            timer.Create("Eau7Attack"..ply:SteamID64(), 0.2, 25, function()
                if not IsValid(ply.eau7) then timer.Remove("Eau7Attack"..ply:SteamID64()) return end
                for k, v in ipairs( ents.FindInSphere( ply.eau7:GetPos(), 500 ) ) do
                    if v != ply and v != ply.eau7 then
                        v:TakeDamage(37+ply:GetActiveWeapon().BonusDegats, ply)
                    end
                end
            end)

            timer.Simple(5, function()
                if IsValid(ply.eau7) then ply.eau7:Remove() end
                ply:StopParticles()
            end)

            end)

        end,
    },

    -- ["vent1"] = {
    --     stam = 25,
    --     name = "Trancheur de Vent",
    --     level = 2,
    --     icon = "mad_sololeveling/skills/icons/a (230).png",
    --     classe = "mage",
    --     coldown = 3,
    --     type = "magie",
    --     ismagie = true,
    --     element = "air",
    --     code = function(ply)
    --         ply:Mad_SetAnim( "mad_fils1erattaque" )
    --         ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

    --         timer_Simple(0.5, function()
    --             ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

    --             ply:EmitSound( "mad_sfx_sololeveling/wind/hancocknewMagicwind_1.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
    --             ply:GetActiveWeapon():DamageLaunch(45, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/wind/nami_Wind_Push.ogg", 60, 80, false, 0, { "[4]_brice_add_3", "[5]_trombe_prepar_add_2"}, 750)
    --         end)

    --     end,
    -- },

    ["vent2"] = {
        stam = 50,
        name = "Jet de Vent",
        level = 10,
        icon = "mad_sololeveling/skills/icons/a (250).png",
        classe = "mage",
        coldown = 5,
        type = "magie",
        ismagie = true,
        element = "air",
        code = function(ply)

            

            ply:Mad_SetAnim( "mad_an_hero_william_combat_skill_02_end retarget" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.1, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/wind/hancocknewMagicwind_1.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                
                ply:GetActiveWeapon():DamageAttaque(75, 75, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
                timer.Simple(0.001,function() ParticleEffect( "[5]_trombe", ply:GetPos()+ply:GetForward()*35+ply:GetUp()*45, ply:EyeAngles()+Angle(0,100,0), ply ) end)
                timer_Simple(1,function() ply:StopParticles() end)
            end)

        end,
    },

    ["vent3"] = {
        stam = 75,
        name = "Onde de Choc Aérienne",
        level = 15,
        icon = "mad_sololeveling/skills/icons/magie16.png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "air",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquelourde3" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/wind/hancocknewMagicwind_1.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageLaunch(120, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/wind/nami_Wind_Push.ogg", 60, 80, false, 0, {"[5]_jumelles", "[4]_brice_add_3", "[5]_trombe_prepar_add_2", "[union_mad]_wind_circle"}, 750)	
            end)

        end,
    },

    ["vent4"] = {
        stam = 125,
        name = "Éruption de Vent",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (345).png",
        classe = "mage",
        coldown = 9,
        type = "magie",
        ismagie = true,
        element = "air",
        code = function(ply)

            
            
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_fils3emeattaque" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(2,function()

                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/wind/hancocknewMagicwind_1.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/wind/kid_Wind01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	

                for i=1,4 do 
                    
                    ParticleEffect( "[5]_trombe", ply:GetPos()+ply:GetForward()*125*i, ply:GetAngles()+Angle(0,0,-90), ply )
                    ParticleEffect( "[4]_brice_add_3", ply:GetPos()+ply:GetForward()*125*i, ply:GetAngles()+Angle(0,0,0), ply )
                    util.ScreenShake(ply:GetPos()+ply:GetForward()*125*i, 3, 50, 0.5, 250)

                    timer_Simple(0.9, function() ply:StopParticles() end)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:SetMoveType(MOVETYPE_WALK)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(175, 175, 50)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

        end,
    },

    ["vent5"] = {
        stam = 155,
        name = "Concentration du Vent",
        level = 25,
        icon = "mad_sololeveling/skills/icons/a (170).png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "air",
        code = function(ply)

            

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/wind/hancocknewMagicwind_1.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/wind/kid_Wind01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/wind/nami_WindBuff.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                
                timer_Simple(0.001, function() 
                    ParticleEffect( "[4]_brice", ply:GetPos(), ply:GetAngles(), ply ) 
                    ParticleEffect( "[5]_flash", ply:GetPos(), ply:GetAngles(), ply ) 
                    util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
                    timer_Simple(0.5,function()
                        ply:StopParticles()
                    end)

                    for k, v in ipairs( ents.FindInSphere( ply:GetPos(), 350 ) ) do
                        if v != ply then
                            if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                                v:TakeDamage(225+ply:GetActiveWeapon().BonusDegats, ply)
                            end
                        end
                    end
                end)

            end)

        end,
    },

    ["wind6"] = {
        stam = 200,
        name = "Téléportation de Vent",
        level = 30,
        icon = "mad_sololeveling/skills/icons/magie12.png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "air",
        code = function(ply)

            

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_filseveil" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[union_mad]_wind_circle", ply:GetPos()+ply:GetForward()*75+ply:GetUp()*75, ply:GetAngles()+Angle(0,0,0), ply ) 
                ParticleEffect( "[4]_brice", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[18]_wins_slashes_around", ply:GetPos(), ply:GetAngles(), ply ) 

                ply:EmitSound( "mad_sfx_sololeveling/wind/hancocknewMagicwind_1.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/wind/kid_Wind01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/wind/nami_WindBuff.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            end)

            timer_Simple(2, function()

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()
                ParticleEffect( "[4]_compass_impact", ply:GetPos(), ply:GetAngles(), ply ) 

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(145, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/wind/nami_Wind_Push.ogg", 60, 80, false, 0, {"[5]_jumelles", "[4]_brice_add_3", "[5]_trombe_prepar_add_2", "[union_mad]_wind_circle", "[18]_wind_vortex"}, 750)
                timer_Simple(1.6,function()
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_Fire01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		

                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                    ply:GetActiveWeapon():DamageLaunch(145, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/wind/nami_Wind_Push.ogg", 60, 80, false, 0, {"[5]_jumelles", "[4]_brice_add_3", "[5]_trombe_prepar_add_2","[union_mad]_wind_circle", "[18]_wind_vortex"}, 750)
                end)
            end)

        end,
    },

        
    ["wind7"] = {
        stam = 300,
        name = "Tornade de Vent",
        level = 35,
        icon = "mad_sololeveling/skills/icons/a (351).png",
        classe = "mage",
        coldown = 30,
        type = "magie",
        ismagie = true,
        element = "air",
        code = function(ply)

            

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_fl??che5emeattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[union_mad]_wind_circle", ply:GetPos()+ply:GetForward()*75+ply:GetUp()*75, ply:GetAngles()+Angle(0,0,0), ply ) 
                ParticleEffect( "[4]_brice", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[18]_wins_slashes_around", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[18]_wind_tornado", ply:GetPos(), ply:GetAngles(), ply ) 

                ply:EmitSound( "mad_sfx_sololeveling/wind/hancocknewMagicwind_1.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/wind/kid_Wind01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/wind/nami_WindBuff.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 	
            end)

            timer_Simple(2, function()

                ply:EmitSound( "mad_sfx_sololeveling/wind/hancocknewMagicwind_1.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/wind/kid_Wind01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/wind/nami_WindBuff.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 		

                ply:EmitSound( "mad_sfx_sololeveling/wind/crocodile_CircleWind.ogg", 105, math.random(40, 50), 1, CHAN_AUTO ) 		

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()

                
            ply.vent7 = ents.Create("prop_dynamic")
            ply.vent7:SetModel("models/props_phx/construct/glass/glass_dome360.mdl")
            ply.vent7:SetRenderMode( RENDERMODE_TRANSCOLOR )
            ply.vent7:SetColor( Color(127,255,255,0) )
            ply.vent7:SetPos(ply:GetPos())
            ply.vent7:Spawn()

            timer_Simple(0.001,function()
                ParticleEffect( "[5]_jumelles_explosion", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[5]_flash", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[4]_brice", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[18]_wins_slashes_around", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[18]_wind_tornado", ply:GetPos(), ply:GetAngles(), ply ) 
            end)

            timer.Create("vent7Attack"..ply:SteamID64(), 0.2, 25, function()
                if not IsValid(ply.vent7) then timer.Remove("vent7Attack"..ply:SteamID64()) return end
                for k, v in ipairs( ents.FindInSphere( ply.vent7:GetPos(), 500 ) ) do
                    if v != ply and v != ply.vent7 then
                        v:TakeDamage(37+ply:GetActiveWeapon().BonusDegats, ply)
                    end
                end
            end)

            timer.Simple(5, function()
                if IsValid(ply.vent7) then ply.vent7:Remove() end
                ply:StopParticles()
            end)

            end)

        end,
    },

    ["terre1"] = {
        stam = 25,
        name = "Lames Terrestres",
        level = 2,
        icon = "mad_sololeveling/skills/icons/a (110).png",
        classe = "mage",
        coldown = 3,
        type = "magie",
        ismagie = true,
        element = "terre",
        code = function(ply)

            

            timer_Simple(0.001,function()
                ParticleEffect( "dust_dash_mudrock", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "dust_dash_smoke", ply:GetPos(), ply:GetAngles(), ply ) 
            end)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.5, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/earth/hancocknewRockbreak.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch2(45, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/earth/moria_GroundImpact.ogg", 60, 80, false, 0, {"[12]_rock"}, 2500, "models/hunter/misc/sphere025x025.mdl", 1, "models/props_pipes/GutterMetal01a", 55)
            end)

        end,
    },

    ["terre2"] = {
        stam = 50,
        name = "Rafale Terrestre",
        level = 10,
        icon = "mad_sololeveling/skills/icons/a (112).png",
        classe = "mage",
        coldown = 5,
        type = "magie",
        ismagie = true,
        element = "terre",
        code = function(ply)

            

            timer_Simple(0.001,function()
                ParticleEffect( "dust_dash_mudrock", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "dust_roll", ply:GetPos(), ply:GetAngles(), ply ) 
            end)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.2,function()
                timer.Create("Terre2Atk"..ply:SteamID64(), 0.2, 3, function()
                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                    ply:EmitSound( "mad_sfx_sololeveling/earth/hancocknewRockbreak.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                    ply:GetActiveWeapon():DamageLaunch2(75, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/earth/moria_GroundImpact.ogg", 60, 80, false, 0, {"[12]_rock"}, 2500, "models/hunter/misc/sphere025x025.mdl", 1.2, "models/props_pipes/GutterMetal01a", 55)
                end)
            end)

        end,
    },

    ["terre3"] = {
        stam = 75,
        name = "Pique Terrestre",
        level = 15,
        icon = "mad_sololeveling/skills/icons/a (111).png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "terre",
        code = function(ply)

            timer_Simple(0.001,function()
                ParticleEffect( "dust_dash_mudrock", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "dust_roll", ply:GetPos(), ply:GetAngles(), ply ) 
            end)

            ply:Mad_SetAnim( "mad_an_hero_william_combat_skill_01 retarget" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.2,function()
                ply:EmitSound( "mad_sfx_sololeveling/earth/hancocknewRockbreak.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/earth/bltrmo_jumprock.ogg", 95, math.random(70, 130), 1, CHAN_AUTO ) 
                timer_Simple(0.001,function()
                    ParticleEffect( "[unionmage]_rock_aaa", ply:GetPos()+ply:GetForward()*250, ply:GetAngles(), ply ) 
                    ply:GetActiveWeapon():DamageAttaque(120, 120, 65)
                    util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
                end)
            end)

        end,
    },

    ["terre4"] = {
        stam = 125,
        name = "Rangée de Pointe",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (109).png",
        classe = "mage",
        coldown = 9,
        type = "magie",
        ismagie = true,
        element = "terre",
        code = function(ply)


            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_fils3emeattaque" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "dust_dash_mudrock", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "dust_roll", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(2,function()

                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/earth/hancocknewRockbreak.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/earth/bltrmo_jumprock.ogg", 95, math.random(70, 130), 1, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/earth/perona_GroundHit.ogg", 95, math.random(70, 130), 1, CHAN_AUTO ) 

                for i=1,4 do 
                    
                    ParticleEffect( "dust_conquer_sharp", ply:GetPos()+ply:GetForward()*345*i, ply:GetAngles()+Angle(0,0,0), ply )
                    ParticleEffect( "[unionmage]_rock_aaa", ply:GetPos()+ply:GetForward()*315*i, ply:GetAngles()+Angle(0,0,0), ply )

                    util.ScreenShake(ply:GetPos()+ply:GetForward()*125*i, 3, 50, 0.5, 250)

                    timer_Simple(0.9, function() ply:StopParticles() end)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:SetMoveType(MOVETYPE_WALK)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(175, 175, 65)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)


        end,
    },

    
    ["terre5"] = {
        stam = 155,
        name = "Tremblement de Terre",
        level = 25,
        icon = "mad_sololeveling/skills/icons/a (144).png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "terre",
        code = function(ply)


            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_fl??che4emeattaque" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "dust_dash_mudrock", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "dust_roll", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[19]_rock_circle", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(0.9,function()

                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/earth/hancocknewRockbreak.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/earth/bltrmo_jumprock.ogg", 95, math.random(70, 130), 1, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/earth/perona_GroundHit.ogg", 95, math.random(70, 130), 1, CHAN_AUTO ) 

                for i=1,4 do 
                    
                    ParticleEffect( "dust_conquer_sharp", ply:GetPos()+ply:GetForward()*100*i, ply:GetAngles()+Angle(0,0,0), ply )
                    ParticleEffect( "[union]_rock_smash", ply:GetPos()+ply:GetForward()*100*i, ply:GetAngles()+Angle(0,0,0), ply )

                    util.ScreenShake(ply:GetPos()+ply:GetForward()*100*i, 3, 50, 0.5, 250)

                    timer_Simple(0.9, function() ply:StopParticles() end)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:SetMoveType(MOVETYPE_WALK)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(225, 225, 65)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)


        end,
    },

    ["terre6"] = {
        stam = 300,
        name = "Dôme de Terre",
        level = 30,
        icon = "mad_sololeveling/skills/icons/a (164).png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "terre",
        code = function(ply)

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "tank_enchancement", effectdata, true, true )

            ply:Mad_SetAnim( "mad_flammeconcentration" )
            
            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "dust_dash_mudrock", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "dust_roll", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "dust_fear", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            ply:ViewPunch(Angle(0, 0, 30))
            ply:EmitSound( "mad_sfx_sololeveling/earth/hancocknewRockbreak.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
            ply:EmitSound( "mad_sfx_sololeveling/earth/bltrmo_jumprock.ogg", 95, math.random(70, 130), 1, CHAN_AUTO ) 
            ply:EmitSound( "mad_sfx_sololeveling/earth/perona_GroundHit.ogg", 95, math.random(70, 130), 1, CHAN_AUTO ) 

            ply.dome = ents.Create("prop_dynamic")
            ply.dome:SetModel("models/props_phx/construct/glass/glass_dome360.mdl")
            ply.dome:SetModelScale(3.5, 2)
            ply.dome:SetMaterial("models/props_pipes/GutterMetal01a")
            ply.dome:SetColor( Color(255,255,255,255) )
            ply.dome:SetPos(ply:GetPos())
            ply.dome:Spawn()

            timer_Simple(0.001,function()
                ParticleEffectAttach("mudrock_subjugate", 4, ply.dome, 0)
                ParticleEffectAttach("[unionmage]_earth_area", 4, ply.dome, 0)
            end)

            ply:Freeze(true)
            timer.Simple(3, function()
                ply:Freeze(false)
            end)

            timer.Create("DefenseTerre6"..ply:SteamID64(), 0.2, 25, function()
                if not IsValid(ply.dome) then timer.Remove("DefenseTerre6"..ply:SteamID64()) return end
                for k, v in ipairs( ents.FindInSphere( ply.dome:GetPos(), 250 ) ) do

                    if v:IsNextBot() or v:IsNPC() or v:IsPlayer() and v != ply or v:IsScripted() then
                        v:SetVelocity(v:GetForward()*-450)
                    end

                    if v:IsPlayer() and v == ply then
                        v:GodEnable()
                        timer_Simple(0.19,function()
                            v:GodDisable()
                        end)
                    end
                end
            end)

            timer.Simple(12, function()
                ply:StopParticles()
                if IsValid(ply.dome) then ply.dome:Remove() end
                ply:GodDisable()
            end)

        end,
    },

    ["terre7"] = {
        stam = 300,
        name = "Frappe Sismique",
        level = 35,
        icon = "mad_sololeveling/skills/icons/a (161).png",
        classe = "mage",
        coldown = 30,
        type = "magie",
        ismagie = true,
        element = "terre",
        code = function(ply)

            ply:Mad_SetAnim( "mad_an_hero_william_combat_skill_01 retarget" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_fl??che5emeattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_dash_mudrock", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "dust_roll", ply:GetPos(), ply:GetAngles(), ply ) 		
                ParticleEffect( "[19]_rock_circle", ply:GetPos(), ply:GetAngles(), ply ) 		
                ParticleEffect( "dust_conquer_sharp", ply:GetPos(), ply:GetAngles(), ply )
                ParticleEffect( "[union]_rock_smash", ply:GetPos(), ply:GetAngles(), ply ) 		
                ParticleEffect( "mudrock_subjugate", ply:GetPos(), ply:GetAngles(), ply ) 		
                ply:EmitSound( "mad_sfx_sololeveling/earth/hancocknewRockbreak.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/earth/bltrmo_jumprock.ogg", 95, math.random(70, 130), 1, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/earth/perona_GroundHit.ogg", 95, math.random(70, 130), 1, CHAN_AUTO )  	
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

            timer_Simple(2, function()
        
                ply:SetMoveType(MOVETYPE_WALK)

                ply.terre7 = ents.Create("prop_dynamic")
                ply.terre7:SetModel("models/props_phx/construct/glass/glass_dome360.mdl")
                ply.terre7:SetModelScale(3.5, 2)
                ply.terre7:SetMaterial("models/props_pipes/GutterMetal01a")
                ply.terre7:SetRenderMode( RENDERMODE_TRANSCOLOR )
                ply.terre7:SetColor( Color(255,255,255,0) )
                ply.terre7:SetPos(ply:GetPos())
                ply.terre7:Spawn()

                timer.Create("Terre7Atk", 0.2, 20, function()

                if not IsValid(ply.terre7) then timer.Remove("Terre7Atk"..ply:SteamID64()) return end
                for k, v in ipairs( ents.FindInSphere( ply.terre7:GetPos(), 500 ) ) do
                    if v != ply and v != ply.terre7 then
                        v:TakeDamage(46+ply:GetActiveWeapon().BonusDegats, ply)
                    end
                end

                ply.terre7:EmitSound( "mad_sfx_sololeveling/earth/hancocknewRockbreak.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply.terre7:EmitSound( "mad_sfx_sololeveling/earth/bltrmo_jumprock.ogg", 95, math.random(70, 130), 1, CHAN_AUTO ) 
                ply.terre7:EmitSound( "mad_sfx_sololeveling/earth/perona_GroundHit.ogg", 95, math.random(70, 130), 1, CHAN_AUTO ) 
                timer_Simple(0.001,function()
                    util.ScreenShake(ply.terre7:GetPos(), 3, 50, 0.5, 250)
                end)
                ply:StopParticles()

                timer_Simple(0.001,function()
                    ParticleEffect( "[unionmage]_seisme", ply.terre7:GetPos(), ply.terre7:GetAngles(), ply.terre7 )
                    ParticleEffect( "[unionmage]_seisme_annihilation_type", ply.terre7:GetPos(), ply.terre7:GetAngles()+Angle(0,180,0), ply.terre7 )
                    ParticleEffect( "[unionmage]_seisme_cast_blast", ply.terre7:GetPos(), ply.terre7:GetAngles()+Angle(0,180,0), ply.terre7 )

                    for i=1,4 do 
                        util.ScreenShake(ply.terre7:GetPos(), 3+10*i, 50+10*i, 0.5, 500*i)
                    end

                end)

                timer_Simple(4,function()
                    ply.terre7:Remove()
                end)

            end)


            end)
        end,
    },

    ["foudre1"] = {
        stam = 25,
        name = "Boule de Foudre",
        level = 2,
        icon = "mad_sololeveling/skills/icons/a (279).png",
        classe = "mage",
        coldown = 3,
        type = "magie",
        ismagie = true,
        element = "foudre",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.5, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/electric/nami_Electric01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(50, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/electric/nami_Electric03.ogg", 60, 80, false, 0, {"[mad_union]_lightning_sphere_impacta"}, 750)
            end)

        end,
    },

    ["foudre2"] = {
        stam = 50,
        name = "Railgun de Foudre",
        level = 10,
        icon = "mad_sololeveling/skills/icons/a (190).png",
        classe = "mage",
        coldown = 5,
        type = "magie",
        ismagie = true,
        element = "foudre",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquesimple1" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/electric/nami_Electric01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(27, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/electric/nami_Electric03.ogg", 60, 80, false, 0, {"[mad_union]_lightning_sphere_impacta"}, 750)
            end)

            timer_Simple(0.6, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/electric/nami_Electric01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(27, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/electric/nami_Electric03.ogg", 60, 80, false, 0, {"[mad_union]_lightning_sphere_impacta"}, 750)
            end)

            timer_Simple(0.8, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/electric/nami_Electric01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(26, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/electric/nami_Electric03.ogg", 60, 80, false, 0, {"[mad_union]_lightning_sphere_impacta"}, 750)
            end)

        end,
    },

    ["foudre3"] = {
        stam = 75,
        name = "Distorsion Foudroyante",
        level = 15,
        icon = "mad_sololeveling/skills/icons/a (183).png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "foudre",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquelourde3" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/electric/nami_Electric01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(130, false, 0, true, 1, false, "", true, "mad_sfx_sololeveling/electric/nami_Electric03.ogg", 60, 80, false, 0, {"[14]_lightning_dash_add_2", "[14]_lightning_child"}, 750)
            end)

        end,
    },

    ["foudre4"] = {
        stam = 125,
        name = "Onde de Choc Foudroyante",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (184).png",
        classe = "mage",
        coldown = 9,
        type = "magie",
        ismagie = true,
        element = "foudre",
        code = function(ply)

            
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect6", effectdata, true, true )

            ply:Mad_SetAnim( "mad_fils3emeattaque" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffectAttach("[elec_mage]_dissolve", 4, ply, 0)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(2,function()

                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/electric/enel_ElectricPose.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				

                for i=1,5 do 
                    
                    ParticleEffect( "[14]_lightning_dash_sphere", ply:GetPos()+ply:GetForward()*75*i, ply:EyeAngles(), ply )
                    ParticleEffect( "[14]_lightning_dash_sphere_add_2", ply:GetPos()+ply:GetForward()*75*i, ply:EyeAngles(), ply )
                    ParticleEffect( "[14]_lightning_dash_sphere_add_2_trail", ply:GetPos()+ply:GetForward()*75*i, ply:EyeAngles(), ply )
                    ParticleEffect( "[14]_lightning_dash_glow", ply:GetPos()+ply:GetForward()*75*i, ply:EyeAngles(), ply )
                    timer_Simple(0.7, function()
                        ply:StopParticles()
                    end)
                    util.ScreenShake(ply:GetPos()+ply:GetForward()*75*i, 3, 50, 0.5, 250)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() then
                            tr.Entity:Freeze(true)
                            timer_Simple(0.5,function()
                                tr.Entity:Freeze(false)
                            end)
                        end
                    end
                end

                ply:SetMoveType(MOVETYPE_WALK)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(185, 185, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

        end,
    },

    ["foudre5"] = {
        stam = 155,
        name = "Concentration de Foudre",
        level = 25,
        icon = "mad_sololeveling/skills/icons/magie13.png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "foudre",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[14]_lightning_dash_sphere_add", ply:GetPos()+ply:GetForward()*75+ply:GetUp()*75, ply:GetAngles()+Angle(0,0,0), ply ) 
                ParticleEffect( "[14]_lightning_dash_base", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[14]_lightning_dash", ply:GetPos(), ply:GetAngles(), ply ) 
                ply:EmitSound( "mad_sfx_sololeveling/water/jinbe_Water06.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 		
            end)

            timer_Simple(0.4, function()
                ply:StopParticles()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/electric/nami_Electric01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(235, false, 0, true, 1, false, "", true, "mad_sfx_sololeveling/electric/nami_Electric03.ogg", 60, 80, false, 0, {"[14]_lightning_dash_sphere", "[14]_lightning_dash_add_2", "[14]_lightning_child", "[14]_lightning_dash_glow"}, 750)
            end)

        end,
    },


    ["foudre6"] = {
        stam = 155,
        name = "Téléportation Foudroyante",
        level = 30,
        icon = "mad_sololeveling/skills/icons/a (189).png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "foudre",
        code = function(ply)

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_filseveil" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[14]_lightning_dash_base", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[14]_lightning_explosion", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[elec_mage_union]_aura", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffectAttach("[elec_mage]_dissolve", 4, ply, 0)
                ply:EmitSound( "mad_sfx_sololeveling/electric/nami_elec01.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                ply:EmitSound( "mad_sfx_sololeveling/electric/enel_ElectricDragon.ogg", 85, math.random(70, 130), 1.2, CHAN_AUTO ) 	 				
            end)

            timer_Simple(2, function()

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(150, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/eletric/enel_ElectricHit01.ogg", 60, 80, false, 0, {"[elec_mage_union]_projectile", "[14]_lightning_dash_sphere_add"}, 750)
                timer_Simple(1.6,function()
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_Fire01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		

                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                    ply:GetActiveWeapon():DamageLaunch(150, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/electric/enel_ElectricHit01.ogg", 60, 80, false, 0, {"[elec_mage_union]_projectile", "[14]_lightning_dash_sphere_add"}, 750)
                end)
            end)

        end,
    },

    ["foudre7"] = {
        stam = 300,
        name = "Tempête de Tonnerre",
        level = 35,
        icon = "mad_sololeveling/skills/icons/magie9.png",
        classe = "mage",
        coldown = 30,
        type = "magie",
        ismagie = true,
        element = "foudre",
        code = function(ply)

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_fl??che5emeattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[14]_lightning_dash_sphere_add", ply:GetPos()+ply:GetForward()*75+ply:GetUp()*75, ply:GetAngles()+Angle(0,0,0), ply ) 
                ParticleEffect( "[14]_lightning_dash_base", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[14]_lightning_dash", ply:GetPos(), ply:GetAngles(), ply ) 
                ply:EmitSound( "mad_sfx_sololeveling/electric/nami_elec01.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                ply:EmitSound( "mad_sfx_sololeveling/electric/enel_ElectricDragon.ogg", 85, math.random(70, 130), 1.2, CHAN_AUTO ) 		
            end)

            timer_Simple(2, function()

                ply:EmitSound( "mad_sfx_sololeveling/electric/enel_ElectricThunder02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                ply:EmitSound( "mad_sfx_sololeveling/eletrice/enel_ElectricThunder03.ogg", 85, math.random(70, 130), 1.5, CHAN_AUTO ) 		
                ply:EmitSound( "mad_sfx_sololeveling/electric/enel_ElectricThunder05.ogg", 85, math.random(60, 75), 1, CHAN_AUTO ) 		

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()
                
            ply.foudre7 = ents.Create("prop_dynamic")
            ply.foudre7:SetModel("models/props_phx/construct/glass/glass_dome360.mdl")
            ply.foudre7:SetRenderMode( RENDERMODE_TRANSCOLOR )
            ply.foudre7:SetColor( Color(127,255,255,0) )
            ply.foudre7:SetPos(ply:GetPos())
            ply.foudre7:Spawn()

            timer.Create("foudre7Attack"..ply:SteamID64(), 0.2, 25, function()
                if not IsValid(ply.foudre7) then timer.Remove("foudre7Attack"..ply:SteamID64()) return end
                for k, v in ipairs( ents.FindInSphere( ply.foudre7:GetPos(), 500 ) ) do
                    if v != ply and v != ply.foudre7 and v:IsPlayer() or v:IsNextBot() or v:IsNPC() then
                        v:TakeDamage(40+ply:GetActiveWeapon().BonusDegats, ply)
                        timer_Simple(0.001,function()
                            ParticleEffect( "[14]_lightning_explosion", v:GetPos(), v:GetAngles(), v ) 
                        end)
                    end
                end
            end)

            timer.Simple(5, function()
                if IsValid(ply.foudre7) then ply.foudre7:Remove() end
                ply:StopParticles()
            end)

            end)

        end,
    },
    
    ["glace1"] = {
        stam = 50,
        name = "Souffle de Glace",
        level = 2,
        icon = "mad_sololeveling/skills/icons/a (9).png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "glace",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.5, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/ice/hong_skillE_ice.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(20, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/ice/shouji_ice01.ogg", 60, 80, false, 0, {"[4]_dash_ice"}, 750)
            end)

        end,
    },

    ["glace2"] = {
        stam = 100,
        name = "Jet de Glace",
        level = 10,
        icon = "mad_sololeveling/skills/icons/a (250).png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "glace",
        code = function(ply)

            ply:Mad_SetAnim( "mad_an_hero_william_combat_skill_02_end retarget" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.1, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/ice/hong_skillE_ice.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                
                ply:GetActiveWeapon():DamageAttaque(35, 350, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
                timer.Simple(0.001,function() ParticleEffect( "[22]_icerush", ply:GetPos()+ply:GetForward()*35+ply:GetUp()*55, ply:GetAngles()+Angle(0,90,0), ply ) end)
                timer_Simple(1,function() ply:StopParticles() end)
            end)

        end,
    },

    ["glace3"] = {
        stam = 150,
        name = "Ruée Fraîche",
        level = 15,
        icon = "mad_sololeveling/skills/icons/magie16.png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "glace",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquelourde3" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.1, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/ice/hong_skillE_ice.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                
                ply:GetActiveWeapon():DamageAttaque(80, 400, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
                timer.Simple(0.001,function() ParticleEffect( "[4]_ice_wave_main", ply:GetPos()+ply:GetForward()*35, ply:GetAngles()+Angle(0,-90,0), ply ) end)
                timer_Simple(1,function() ply:StopParticles() end)
            end)

        end,
    },


    ["glace4"] = {
        stam = 200,
        name = "Distorsion Glaciale",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (245).png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "glace",
        code = function(ply)

            
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_fils3emeattaque" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(2,function()

                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/ice/hong_skillW_ice03.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				

                for i=1,4 do 
                    
                    ParticleEffect( "[4]_frozen_dragon_add_2", ply:GetPos()+ply:GetForward()*95*i, ply:GetAngles(), ply )
                    util.ScreenShake(ply:GetPos()+ply:GetForward()*75*i, 3, 50, 0.5, 250)

                    timer_Simple(0.9, function() ply:StopParticles() end)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:SetMoveType(MOVETYPE_WALK)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(150, 350, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

        end,
    },

    ["glace5"] = {
        stam = 250,
        name = "Débordement de Glace",
        level = 25,
        icon = "mad_sololeveling/skills/icons/a (153).png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "glace",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/ice/hong_skillE_ice.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                
                timer_Simple(0.001, function() 
                    ParticleEffect( "[4]_frozen_dragon_hitmark", ply:GetPos(), ply:GetAngles(), ply ) 
                    util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
                    timer_Simple(0.5,function()
                        ply:StopParticles()
                    end)

                    for k, v in ipairs( ents.FindInSphere( ply:GetPos(), 350 ) ) do
                        if v != ply then
                            if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                                v:TakeDamage(190+ply:GetActiveWeapon().BonusDegats, ply)
                            end
                        end
                    end
                end)

            end)

        end,
    },

    ["glace6"] = {
        stam = 300,
        name = "Téléportation de Glace",
        level = 30,
        icon = "mad_sololeveling/skills/icons/a (305).png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "glace",
        code = function(ply)

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_filseveil" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[4]_frozen_aura", ply:GetPos(), ply:GetAngles(), ply ) 
                ply:EmitSound( "mad_sfx_sololeveling/ice/hong_skillW_ice03.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            end)

            timer_Simple(2, function()

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()
                timer_Simple(0.001,function()
                    ParticleEffect( "[4]_frozen_dragon_hitmark", ply:GetPos(), ply:GetAngles(), ply ) 
                end)

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/ice/hong_skillW_ice01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(125, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/ice/shouji_ice02.ogg", 60, 80, false, 0, {"[mad_union]_loze_around"}, 750)
                timer_Simple(1.6,function()
                    ply:EmitSound( "mad_sfx_sololeveling/ice/hong_skillW_ice01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		

                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                    ply:GetActiveWeapon():DamageLaunch(125, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/ice/shouji_ice02.ogg", 60, 80, false, 0, {"[mad_union]_loze_around"}, 750)
                end)
            end)

        end,
    },

    ["glace7"] = {
        stam = 350,
        name = "Torture de Glace",
        level = 35,
        icon = "mad_sololeveling/skills/icons/a (323).png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "glace",
        code = function(ply)

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_fl??che5emeattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[4]_frozen_dragon", ply:GetPos(), ply:GetAngles(), ply ) 
                ply:EmitSound( "mad_sfx_sololeveling/ice/hong_ability_ice.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 		
            end)

            timer_Simple(2, function()

                ply:EmitSound( "mad_sfx_sololeveling/ice/hong_skillE_ice.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                ply:EmitSound( "mad_sfx_sololeveling/ice/hong_skillQ_ice.ogg", 85, math.random(70, 130), 1.5, CHAN_AUTO ) 		
                ply:EmitSound( "mad_sfx_sololeveling/ice/hong_skillW_ice01.ogg", 85, math.random(60, 75), 1, CHAN_AUTO ) 		

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()

                
            ply.glace7 = ents.Create("prop_dynamic")
            ply.glace7:SetModel("models/props_phx/construct/glass/glass_dome360.mdl")
            ply.glace7:SetRenderMode( RENDERMODE_TRANSCOLOR ) -- You need to set the render mode on some entities in order for the color to change
            ply.glace7:SetColor( Color(127,255,255,0) )
            ply.glace7:SetPos(ply:GetPos())
            ply.glace7:Spawn()

            timer_Simple(0.001,function()
                ParticleEffect( "[4]_ice_judgmentcut_sphere_add_3", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[4]_ice_judgmentcut_sphere_add_3", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[4]_frozen_aura", ply.glace7:GetPos(), ply.glace7:GetAngles(), ply.glace7 ) 
            end)

            timer.Create("glace7Attack"..ply:SteamID64(), 0.2, 25, function()
                if not IsValid(ply.glace7) then timer.Remove("glace7Attack"..ply:SteamID64()) return end
                for k, v in ipairs( ents.FindInSphere( ply.glace7:GetPos(), 500 ) ) do
                    if v != ply and v != ply.glace7 and v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                        v:TakeDamage(16+ply:GetActiveWeapon().BonusDegats, ply)

                        timer_Simple(0.001,function()
                            ParticleEffect( "[4]_frozen_dragon_hitmark", v:GetPos(), v:GetAngles(), ply ) 
                        end)

                    end
                end
            end)

            timer.Simple(5, function()
                if IsValid(ply.glace7) then ply.glace7:Remove() end
                ply:StopParticles()
                ply.glace7:StopParticles()
            end)

            end)

        end,
    },
    
    ["lumiere1"] = {
        stam = 30,
        name = "Sphère Lumineuse",
        level = 2,
        icon = "mad_sololeveling/skills/icons/a (31).png",
        classe = "mage",
        coldown = 3,
        type = "magie",
        ismagie = true,
        element = "lumiere",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.5, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(60, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[union_mage]_light_projectile"}, 1500)
            end)

        end,
    },

    ["lumiere2"] = {
        stam = 55,
        name = "Canon Rail de Lumière",
        level = 10,
        icon = "mad_sololeveling/skills/icons/a (33).png",
        classe = "mage",
        coldown = 5,
        type = "magie",
        ismagie = true,
        element = "lumiere",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquesimple1" )
            timer_Simple(0.5, function() ply:Mad_SetAnim( "mad_fils4emeattaque" ) end)

            ply:SetMoveType(MOVETYPE_NONE)
            
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(30, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[union_mage]_light_projectile"}, 1500)
                ply:SetMoveType(MOVETYPE_WALK)
            end)

            timer_Simple(0.6, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(30, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[union_mage]_light_projectile"}, 1000)
            end)

            timer_Simple(0.8, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(30, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[union_mage]_light_projectile"}, 750)
            
            end)

        end, 
    },
 
    ["lumiere3"] = {
        stam = 80,
        name = "Éclairement de Lumière",
        level = 15,
        icon = "mad_sololeveling/skills/icons/magie12.png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "lumiere",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquelourde3" )
            

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                ply:GetActiveWeapon():DamageLaunch(140, true, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[union_mage]_light_flash", "[union_mage]_light_projectile", "[1]_light_groundfire_hitmark_impact"}, 1250)	
            end)

        end,
    },

    ["lumiere4"] = {
        stam = 130,
        name = "Éruption de Lumière",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (78).png",
        classe = "mage",
        coldown = 9,
        type = "magie",
        ismagie = true,
        element = "lumiere",
        code = function(ply)
            
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_fils3emeattaque" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
            ply:EmitSound( "mad_sfx_sololeveling/fire/040_swg_fire1.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 			
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(2,function()

                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/fire/040_swg_fire1.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                ply:EmitSound( "mad_sfx_sololeveling/fire/Fireball_Lava_Launch3.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				

                for i=1,4 do 
                    
                    ParticleEffect( "[1]_light_groundfire_hitmark", ply:GetPos()+ply:GetForward()*125*i, ply:GetAngles(), ply )
                    util.ScreenShake(ply:GetPos()+ply:GetForward()*125*i, 3, 50, 0.5, 250)

                    timer_Simple(0.9, function() ply:StopParticles() end)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:SetMoveType(MOVETYPE_WALK)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(195, 195, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

        end,
    },

    ["lumiere5"] = {
        stam = 160,
        name = "Zone de Lumière",
        level = 25,
        icon = "mad_sololeveling/skills/icons/a (164).png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "lumiere",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/water/jinbe_Water06.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                
                timer_Simple(0.001, function() 
                    ParticleEffect( "[1]_light_sphere", ply:GetPos(), ply:GetAngles(), ply ) 
                    ParticleEffect( "[1]_light_groundcircle_add", ply:GetPos(), ply:GetAngles(), ply ) 
                    util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
                    timer_Simple(1.4,function()
                        ply:StopParticles()
                    end)

                    for k, v in ipairs( ents.FindInSphere( ply:GetPos(), 350 ) ) do
                        if v != ply then
                            if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                                v:TakeDamage(245+ply:GetActiveWeapon().BonusDegats, ply)
                            end
                        end
                    end
                end)

            end)

        end,
    },

    ["lumiere6"] = {
        stam = 160,
        name = "Téléportation de Lumière",
        level = 30,
        icon = "mad_sololeveling/skills/icons/a (64).png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "lumiere",
        code = function(ply)

            

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_filseveil" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[1]_light_flash", ply:GetPos()+ply:GetForward()*75+ply:GetUp()*75, ply:GetAngles()+Angle(0,0,0), ply ) 
                ParticleEffect( "[1]_light_groundcircle", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[1]_light_sphere", ply:GetPos(), ply:GetAngles(), ply ) 
                ply:EmitSound( "mad_sfx_sololeveling/fire/040_swg_fire1.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                ply:EmitSound( "mad_sfx_sololeveling/fire/Fireball_Lava_Launch3.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 					
            end)

            timer_Simple(2, function()

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()
                ParticleEffect( "[1]_light_sphere_bloom", ply:GetPos(), ply:GetAngles(), ply ) 

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(155, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[union_mage]_light_flash", "[union_mage]_light_projectile", "[1]_light_groundfire_hitmark_impact"}, 750)
                timer_Simple(1.6,function()
                    ply:StopParticles()
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_Fire01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		

                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                    ply:GetActiveWeapon():DamageLaunch(155, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[union_mage]_light_flash", "[union_mage]_light_projectile", "[1]_light_groundfire_hitmark_impact"}, 750)
                end)
            end)

        end,
    },

    ["lumiere7"] = {
        stam = 310,
        name = "Lumière du Soleil",
        level = 35,
        icon = "mad_sololeveling/skills/icons/a (174).png",
        classe = "mage",
        coldown = 30,
        type = "magie",
        ismagie = true,
        element = "lumiere",
        code = function(ply)
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_fl??che5emeattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[1]_light_flash", ply:GetPos()+ply:GetForward()*75+ply:GetUp()*75, ply:GetAngles()+Angle(0,0,0), ply ) 
                ParticleEffect( "[1]_light_groundcircle", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[1]_light_sphere", ply:GetPos(), ply:GetAngles(), ply ) 
                ply:EmitSound( "mad_sfx_sololeveling/fire/040_swg_fire1.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                ply:EmitSound( "mad_sfx_sololeveling/fire/Fireball_Lava_Launch3.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 		
            end)

            timer_Simple(2, function()

                ply:EmitSound( "mad_sfx_sololeveling/light/borsalino_LightAppear01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                ply:EmitSound( "mad_sfx_sololeveling/light/borsalino_LightShining02.ogg", 85, math.random(70, 130), 1.5, CHAN_AUTO ) 	
                timer_Simple(0.7,function()	
                    ply.lumiere7:EmitSound( "mad_sfx_sololeveling/light/nami_Lightning03.ogg", 105, math.random(60, 60), 1, CHAN_AUTO ) 	
                    ply.lumiere7:EmitSound( "mad_sfx_sololeveling/light/borsalino_LightBlink01.ogg", 105, math.random(60, 60), 1, CHAN_AUTO ) 		
                end)
                timer_Simple(1.4,function()
                    ply.lumiere7:EmitSound( "mad_sfx_sololeveling/fire/Ace_Fire01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                    ply.lumiere7:EmitSound( "mad_sfx_sololeveling/fire/hong_skillW_fire.ogg", 85, math.random(70, 130), 1.5, CHAN_AUTO ) 
                end)

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()

                
            ply.lumiere7 = ents.Create("prop_dynamic")
            ply.lumiere7:SetModel("models/props_phx/construct/glass/glass_dome360.mdl")
            ply.lumiere7:SetRenderMode( RENDERMODE_TRANSCOLOR ) 
            ply.lumiere7:SetColor( Color(127,255,255,0) )
            ply.lumiere7:SetPos(ply:GetPos())
            ply.lumiere7:Spawn()

            timer_Simple(0.001,function()
                ParticleEffect( "[3]_supreme_sun_main", ply.lumiere7:GetPos(), ply.lumiere7:GetAngles(), ply ) 
            end)

            timer.Create("lumiere7Attack"..ply:SteamID64(), 0.2, 15, function()
                if not IsValid(ply.lumiere7) then timer.Remove("lumiere7Attack"..ply:SteamID64()) return end
                for k, v in ipairs( ents.FindInSphere( ply.lumiere7:GetPos(), 500 ) ) do
                    if v != ply and v != ply.lumiere7 then
                        v:TakeDamage(68+ply:GetActiveWeapon().BonusDegats, ply)
                    end
                end
            end)

            timer.Simple(3, function()
                if IsValid(ply.lumiere7) then ply.lumiere7:Remove() end
                ply:StopParticles()
            end)

            end)

        end,
    },

    ["tenebre1"] = {
        stam = 30,
        name = "Boule Sombre",
        level = 2,
        icon = "mad_sololeveling/skills/icons/a (31).png",
        classe = "mage",
        coldown = 3,
        type = "magie",
        ismagie = true,
        element = "tenebre",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.5, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(60, false, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[union_dark_mage3]__projectile"}, 1500)
            end)

        end,
    },

    ["tenebre2"] = {
        stam = 55,
        name = "Canon Rail Sombre",
        level = 10,
        icon = "mad_sololeveling/skills/icons/a (76).png",
        classe = "mage",
        coldown = 5,
        type = "magie",
        ismagie = true,
        element = "tenebre",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquesimple1" )
            
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(30, false, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[union_dark_mage3]__projectile"}, 1500)
            end)

            timer_Simple(0.6, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(30, false, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[union_dark_mage3]__projectile"}, 1000)
            end)

            timer_Simple(0.8, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(30, false, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[union_dark_mage3]__projectile"}, 750)
            end)

        end,
    },

    ["tenebre3"] = {
        stam = 80,
        name = "Tornade Sombre",
        level = 15,
        icon = "mad_sololeveling/skills/icons/a (77).png",
        classe = "mage",
        coldown = 8,
        type = "magie",
        ismagie = true,
        element = "tenebre",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquelourde3" )
            

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                ply:GetActiveWeapon():DamageLaunch(140, false, 2, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[3]_dark_tornado", "[3]_dark_tornado"}, 1250)	
            end)

        end,
    },

    ["tenebre4"] = {
        stam = 130,
        name = "Éruption Sombre",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (100).png",
        classe = "mage",
        coldown = 9,
        type = "magie",
        ismagie = true,
        element = "tenebre",
        code = function(ply)
            
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_fils3emeattaque" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
            ply:EmitSound( "mad_sfx_sololeveling/fire/040_swg_fire1.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 			
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(2,function()

                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/fire/040_swg_fire1.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                ply:EmitSound( "mad_sfx_sololeveling/fire/Fireball_Lava_Launch3.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 		

                ParticleEffect( "[tenebre]_lonelymoon", ply:GetPos()+ply:GetForward()*125, ply:GetAngles(), ply )
                util.ScreenShake(ply:GetPos()+ply:GetForward()*125, 3, 50, 0.5, 250)

                timer_Simple(0.9, function() ply:StopParticles() end)

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:SetMoveType(MOVETYPE_WALK)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(195, 350, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

        end,
    },

    ["tenebre5"] = {
        stam = 160,
        name = "Zone Sombre",
        level = 25,
        icon = "mad_sololeveling/skills/icons/a (153).png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "tenebre",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fils1erattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.4, function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                ply:EmitSound( "mad_sfx_sololeveling/water/jinbe_Water06.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                
                timer_Simple(0.001, function() 
                    ParticleEffect( "[tenebre]_moon_vortex", ply:GetPos(), ply:GetAngles(), ply ) 
                    util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
                    timer_Simple(1.4,function()
                        ply:StopParticles()
                    end)

                    for k, v in ipairs( ents.FindInSphere( ply:GetPos(), 350 ) ) do
                        if v != ply then
                            if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                                v:TakeDamage(245+ply:GetActiveWeapon().BonusDegats, ply)
                            end
                        end
                    end
                end)

            end)

        end,
    },

    ["tenebre6"] = {
        stam = 160,
        name = "Téléportation Sombre",
        level = 30,
        icon = "mad_sololeveling/skills/icons/magie12.png",
        classe = "mage",
        coldown = 12,
        type = "magie",
        ismagie = true,
        element = "tenebre",
        code = function(ply)
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_filseveil" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[tenebre]_moon_vortex", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[3]_buff_aura", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[3]_dark_tornado", ply:GetPos(), ply:GetAngles(), ply ) 
                ply:EmitSound( "mad_sfx_sololeveling/fire/040_swg_fire1.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                ply:EmitSound( "mad_sfx_sololeveling/fire/Fireball_Lava_Launch3.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 					
            end)

            timer_Simple(2, function()

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                ply:GetActiveWeapon():DamageLaunch(155, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[3]_dark_tornado", "[3]_dark_tornado"}, 750)
                timer_Simple(1.6,function()
                    ply:StopParticles()
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_Fire01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		

                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                    ply:EmitSound( "mad_sfx_sololeveling/fire/Ace_FireShoot02.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 			
                    ply:GetActiveWeapon():DamageLaunch(155, false, 0, false, 0, false, "", true, "mad_sfx_sololeveling/fire/Ace_FireBoom.ogg", 60, 80, false, 0, {"[3]_dark_tornado", "[3]_dark_tornado"}, 750)
                end)
            end)

        end,
    },

    ["tenebre7"] = {
        stam = 310,
        name = "Monde Obscur",
        level = 35,
        icon = "mad_sololeveling/skills/icons/a (233).png",
        classe = "mage",
        coldown = 30,
        type = "magie",
        ismagie = true,
        element = "tenebre",
        code = function(ply)
            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:SetMoveType(MOVETYPE_NONE)

            ply:Mad_SetAnim( "mad_fl??che5emeattaque" )
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

            timer_Simple(0.001, function()
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[tenebre]_moon_vortex", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[3]_buff_aura", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[3]_dark_tornado", ply:GetPos(), ply:GetAngles(), ply ) 
                ply:EmitSound( "mad_sfx_sololeveling/dark/blackbear_DarkOut02.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                ply:EmitSound( "mad_sfx_sololeveling/dark/blackbear_DarkOut03.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 		
            end)

            timer_Simple(2, function()

                ply:EmitSound( "mad_sfx_sololeveling/dark/blackbear_DarkOut02.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                ply:EmitSound( "mad_sfx_sololeveling/dark/blackbear_DarkOut03.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                timer_Simple(0.7,function()	
                    ply.tenebre7:EmitSound( "mad_sfx_sololeveling/dark/blackbear_DarkIn01.ogg", 105, math.random(60, 60), 1, CHAN_AUTO ) 	
                    ply.tenebre7:EmitSound( "mad_sfx_sololeveling/dark/blackbear_DarkIn02.ogg", 105, math.random(60, 60), 1, CHAN_AUTO ) 		
                end)
                timer_Simple(1.4,function()
                    ply.tenebre7:EmitSound( "mad_sfx_sololeveling/dark/blackbear_DarkExplo.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
                    ply.tenebre7:EmitSound( "mad_sfx_sololeveling/dark/blackbear_DarkIn04.ogg", 85, math.random(70, 130), 1.5, CHAN_AUTO ) 
                end)

                ply:SetMoveType(MOVETYPE_WALK)

                ply:StopParticles()

                
            ply.tenebre7 = ents.Create("prop_dynamic")
            ply.tenebre7:SetModel("models/props_phx/construct/glass/glass_dome360.mdl")
            ply.tenebre7:SetRenderMode( RENDERMODE_TRANSCOLOR )
            ply.tenebre7:SetColor( Color(127,255,255,0) )
            ply.tenebre7:SetPos(ply:GetPos())
            ply.tenebre7:Spawn()

            timer_Simple(0.001,function()
                ParticleEffect( "[3]_cursed_ground", ply.tenebre7:GetPos(), ply.tenebre7:GetAngles(), ply ) 
            end)

            timer.Create("tenebre7Attack"..ply:SteamID64(), 0.2, 15, function()
                if not IsValid(ply.tenebre7) then timer.Remove("tenebre7Attack"..ply:SteamID64()) return end
                for k, v in ipairs( ents.FindInSphere( ply.tenebre7:GetPos(), 500 ) ) do
                    if v != ply and v != ply.tenebre7 then
                        v:TakeDamage(68+ply:GetActiveWeapon().BonusDegats, ply)
                    end
                end
            end)

            timer.Simple(3, function()
                if IsValid(ply.tenebre7) then ply.tenebre7:Remove() end
                ply:StopParticles()
            end)

            end)

        end,
    },

    ["assassin1"] = {
        stam = 25,
        name = "Entaille Mortelle",
        level = 2,
        icon = "mad_sololeveling/skills/icons/slashrapide.png",
        classe = "assassin",
        coldown = 2,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_son6ememouvement" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(50, 65, 25)
            end)

        end,
    },

    ["assassin2"] = {
        stam = 50,
        name = "Coup de pied defensif",
        level = 10,
        icon = "mad_sololeveling/skills/icons/attack20.png",
        classe = "assassin",
        coldown = 5,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_sonattaquesimple2" )
            
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    

            timer_Simple(0.2,function()
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
                
                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 65 + 50
                local radius = 65 + 20

                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(-radius, -radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply) then
                            tr.Entity:SetMoveType(MOVETYPE_NONE)
                            timer.Simple(0.3, function()
                                tr.Entity:SetMoveType(MOVETYPE_WALK)
                            end)
                        end
                    end
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(75, 75, 35)
            end)

        end,
    },

    ["assassin3"] = {
        stam = 150,
        name = "Invisibilité",
        level = 15,
        icon = "mad_sololeveling/skills/icons/a (107).png",
        classe = "assassin",
        coldown = 5,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)

            if not ply.Invisi == true then 

                ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
                
                ply.i = 255
                ply.Invisi = true

                timer.Create("StaminaInvisi"..ply:SteamID64(), 1, 0, function()
                    ply:Mad_TakeStam(2)
                end)

                timer.Create("InvisiCoagulation"..ply:SteamID(), 0.1, 25.5, function()
                    ply.i = ply.i - 10
                    if ply.i < 10 then
                        if ply.Invisi == true then
                            ply:DrawWorldModel( false )
                            ply:SetNoDraw( true )
                            ply:DrawShadow( false )
                        else
                            ply:DrawWorldModel( true )
                            ply:SetNoDraw( false )
                            ply:DrawShadow( true )
                            ply:SetColor(Color(255,255,255,255))
                        end
                        return end
                    ply:SetColor(Color(255,255,255,ply.i))
                end)
            
            end
    
        end,
    },

    ["assassin4"] = {
        stam = 100,
        name = "Accrochage",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (4).png",
        classe = "assassin",
        coldown = 9,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_bete1ermouvement" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end

            timer_Simple(0.15,function()
                ply:GetActiveWeapon():DamageAttaque(65, 65, 35)
            end)
    
            timer_Simple(0.5,function()
                ply:SetFOV(90, 0.3)
                timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(65, 65, 35)
            end)

            timer_Simple(1.3,function()
                ply:SetFOV(90, 0.3)
                timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(55, 55, 35)
            end)

        end,
    },

    ["assassin5"] = {
        stam = 150,
        name = "Empoignement",
        level = 25,
        icon = "mad_sololeveling/skills/icons/a (1).png",
        classe = "assassin",
        coldown = 9,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_bete2ememouvement" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
            if ply:IsOnGround() then
                timer_Simple(0.1, function() if ply:IsOnGround() then ply:SetVelocity(ply:GetForward()*500+ply:GetUp()*250) ply:ViewPunch(Angle(0, 0, 10)) end end)
            end
    
            timer_Simple(0.3,function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(250, 65, 35)
            end)

        end,
    },

    ["assassin6"] = {
        stam = 175,
        name = "Entaille Rapide",
        level = 30,
        icon = "mad_sololeveling/skills/icons/a (140).png",
        classe = "assassin",
        coldown = 12,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_son1ermouvement" )

            timer_Simple(0.2, function()

                local effectdata = EffectData()
                effectdata:SetOrigin( ply:GetPos() )
                effectdata:SetEntity( ply )
                util.Effect( "sl_effect1", effectdata, true, true )
    
                local effectdata = EffectData()
                effectdata:SetOrigin( ply:GetPos() )
                effectdata:SetEntity( ply )
                util.Effect( "sl_effect4", effectdata, true, true )

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
                timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

                ply:ConCommand("+forward")
                ply:ConCommand("+speed")
                ply:SetLaggedMovementValue(1.5)
            end)   
            
            timer_Simple(1, function()
                ply:ConCommand("-forward")
                ply:ConCommand("-speed")
                ply:SetLaggedMovementValue(1)

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
                timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
        
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                local effectdata = EffectData()
                effectdata:SetOrigin( ply:GetPos() )
                effectdata:SetEntity( ply )
                util.Effect( "sl_effect1", effectdata, true, true )
    
                local effectdata = EffectData()
                effectdata:SetOrigin( ply:GetPos() )
                effectdata:SetEntity( ply )
                util.Effect( "sl_effect4", effectdata, true, true )
    
                timer_Simple(0.1,function()
                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                    ply:GetActiveWeapon():DamageAttaque(150, 65, 35)
                    timer_Simple(0.001, function() ParticleEffect( "[2]_fog_slash_add", ply:GetPos()+ply:GetUp()*35+ply:GetForward()*35, ply:GetAngles() + Angle(135,90,90), ply ) end)
                    ParticleEffectAttach("Explosion_ShockWave_01", 1, ply, 2)
                end)

                timer_Simple(0.4,function()
                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                    ply:GetActiveWeapon():DamageAttaque(150, 65, 35)
                    timer_Simple(0.001, function() ParticleEffect( "[2]_fog_slash_add", ply:GetPos()+ply:GetUp()*35+ply:GetForward()*35, ply:GetAngles() + Angle(20,90,90), ply ) end)
                    ParticleEffectAttach("Explosion_ShockWave_01", 1, ply, 2)
                end)
            
            end)  

        end,
    },

    ["assassin7"] = {
        stam = 200,
        name = "Entaille Tournoyante",
        level = 35,
        icon = "mad_sololeveling/skills/icons/a (72).png",
        classe = "assassin",
        coldown = 15,
        type = "dague",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_soneveil" )

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            timer.Simple(0.9, function()
                ply:GetActiveWeapon():DamageAttaque(370, 65, 35)
            end)

            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
		
            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            local pos = ply:GetShootPos()
            local aim = ply:GetAimVector()
            local vector = 200 + 50
            local radius = 35 + 20
        
            local slash = {}
            slash.start = ply:GetShootPos()
            slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
            slash.filter = ply
            slash.mins = Vector(-radius, -radius, 0)
            slash.maxs = Vector(radius, radius, 0)
            local tr = util.TraceHull(slash)
        
            if tr.Hit then
                if IsValid(tr.Entity) then
                    if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply or IsValid(tr.Entity) and tr.Entity:IsPlayer() or IsValid(tr.Entity) and tr.Entity:IsNextBot()) then
                        timer.Simple(0.001, function() ParticleEffect("klkdash_up", ply:GetPos(), ply:GetAngles(), ply) end)
                        timer.Simple(0.002, function()
                            ply:SetPos(tr.Entity:GetPos()+tr.Entity:GetForward()*-50)
                            ply:SetEyeAngles(tr.Entity:EyeAngles())
                            tr.Entity:SetLaggedMovementValue(0.5)
                            timer.Simple(5, function()
                                tr.Entity:SetLaggedMovementValue(1)
                            end)

                            timer.Create("PoisonAttack7_Assassin".. ply:SteamID(), 0.5, 10, function()
                                tr.Entity:TakeDamage(1)
                                tr.Entity:ScreenFade( SCREENFADE.IN, Color( 127, 255, 159, 50 ), 0.3, 0 )
                            end)

                        end)
                    end
                end
            end

        end,
    },

    ["healer1"] = {
        stam = 50,
        name = "Soin",
        level = 2,
        icon = "mad_sololeveling/skills/icons/a (61).png",
        classe = "healer",
        coldown = 5,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquesimple1" )
        
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO )                 
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO )     
                
                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 150
                local radius = 50

                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply ) then

                            local baseDamage = 40 + ply:GetActiveWeapon().BonusDegats
                            local sensModifier = math.max(1, ply.sl_data2["sens"] / 2)
                            local bonushealth = baseDamage * sensModifier

                            if tr.Entity:Health() + bonushealth > tr.Entity:GetMaxHealth() then
                                tr.Entity:SetHealth(tr.Entity:GetMaxHealth())
                            else
                                tr.Entity:SetHealth(tr.Entity:Health() + bonushealth)
                            end

                            tr.Entity:EmitSound("mad_sfx_sololeveling/heal/heal4.mp3", 75, math.random(70, 130), 0.8, CHAN_AUTO)
                            util.ScreenShake(pos, 3, 50, 0.5, 150)
                            ParticleEffectAttach("[5]_healing_aura", 4, tr.Entity, 0)

                            timer.Simple(1, function()
                                tr.Entity:StopParticles()
                            end)           
                        end
                    end
                else
                    local baseDamage = 40 + ply:GetActiveWeapon().BonusDegats
                    local sensModifier = math.max(1, ply.sl_data2["sens"] / 2)
                    local bonushealth = baseDamage * sensModifier

                    if ply:Health() + bonushealth > ply:GetMaxHealth() then
                        ply:SetHealth(ply:GetMaxHealth())
                    else
                        ply:SetHealth(ply:Health() + bonushealth)
                    end

                    ply:EmitSound("mad_sfx_sololeveling/heal/heal4.mp3", 75, math.random(70, 130), 0.8, CHAN_AUTO)
                    util.ScreenShake(pos, 3, 50, 0.5, 150)
                    ParticleEffectAttach("[5]_healing_aura", 4, ply, 0)
                    
                    timer.Simple(1, function()
                        ply:StopParticles()
                    end)
                end

            end)

        end,
    },

    ["healer2"] = {
        stam = 100,
        name = "Soin Extrême",
        level = 10,
        icon = "mad_sololeveling/skills/icons/a (50).png",
        classe = "healer",
        coldown = 15,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fl??che5emeattaque" )

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO )                 
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.8,function()
    
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply )
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO )     
                
                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 150
                local radius = 35

                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply ) then

                            local baseDamage = 75 + ply:GetActiveWeapon().BonusDegats
                            local sensModifier = math.max(1, ply.sl_data2["sens"] / 2)
                            local bonushealth = baseDamage * sensModifier

                            if tr.Entity:Health() + bonushealth > tr.Entity:GetMaxHealth() then
                                tr.Entity:SetHealth(tr.Entity:GetMaxHealth())
                            else
                                tr.Entity:SetHealth(tr.Entity:Health() + bonushealth)
                            end

                            tr.Entity:EmitSound("mad_sfx_sololeveling/heal/heal4.mp3", 75, math.random(70, 130), 0.8, CHAN_AUTO)
                            util.ScreenShake(pos, 3, 50, 0.5, 150)
                            ParticleEffectAttach("utaunt_runeprison_green_parent", 4, tr.Entity, 0)
                            timer.Simple(3, function()
                                tr.Entity:StopParticles()
                            end)
                        end
                    end
                end

            end)

        end,
    },

    ["healer3"] = {
        stam = 150,
        name = "Protéger",
        level = 15,
        icon = "mad_sololeveling/skills/icons/a (60).png",
        classe = "healer",
        coldown = 15,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquesimple1" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                
                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 150
                local radius = 35

                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply ) then

                            local baseDamage = 125 + ply:GetActiveWeapon().BonusDegats
                            local sensModifier = math.max(1, ply.sl_data2["sens"] / 2)
                            local bonushealth = baseDamage * sensModifier

                            tr.Entity:GodEnable()

                            -- ply:addXP(bonushealth/10)

                            tr.Entity:EmitSound("mad_sfx_sololeveling/heal/heal4.mp3", 75, math.random(70, 130), 0.8, CHAN_AUTO)
                            util.ScreenShake(pos, 3, 50, 0.5, 150)
                            timer.Simple(0.001, function() ParticleEffectAttach("utaunt_marigoldritual_blue_orbit_holder", 4, tr.Entity, 0) end)
                            timer.Simple(5, function()
                                tr.Entity:GodDisable()
                                tr.Entity:StopParticles()
                            end)
                        end
                    end
                end

            end)

        end,
    },

    ["healer4"] = {
        stam = 200,
        name = "Régénération",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (147).png",
        classe = "healer",
        coldown = 15,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquesimple1" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                
                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 150
                local radius = 35

                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply ) then

                            local baseDamage = 165 + ply:GetActiveWeapon().BonusDegats
                            local sensModifier = math.max(1, ply.sl_data2["sens"] / 2)
                            local bonushealth = baseDamage * sensModifier    

                            -- if tr.Entity:Health() < tr.Entity:GetMaxHealth() then
                            --     ply:addXP(bonushealth/10)
                            -- end

                            timer.Create("Heal_Regeneration4"..tr.Entity:SteamID64(), 0.7, 10, function()
                                if tr.Entity:Health() + bonushealth/10 > tr.Entity:GetMaxHealth() then
                                    tr.Entity:SetHealth(tr.Entity:GetMaxHealth())
                                else
                                    tr.Entity:SetHealth(tr.Entity:Health() + bonushealth/10)
                                end
                            end)

                            tr.Entity:EmitSound("mad_sfx_sololeveling/heal/heal4.mp3", 75, math.random(70, 130), 0.8, CHAN_AUTO)
                            util.ScreenShake(pos, 3, 50, 0.5, 150)
                            timer.Simple(0.001, function() ParticleEffectAttach("utaunt_arcane_green_parent", 4, tr.Entity, 0) end)
                            timer.Simple(7, function()
                                tr.Entity:StopParticles()
                            end)
                        end
                    end
                end

            end)

        end,
    },

    ["healer5"] = {
        stam = 250,
        name = "Zone de guérison",
        level = 25,
        icon = "mad_sololeveling/skills/icons/a (151).png",
        classe = "healer",
        coldown = 30,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquesimple1" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "amphora_splash_heal", ply:GetPos(), ply:GetAngles(), ply ) end)
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	

                for k, v in pairs(ents.FindInSphere(ply:GetPos(), 600)) do
                    if v:IsPlayer() then

                        local baseDamage = 220 + ply:GetActiveWeapon().BonusDegats
                        local sensModifier = math.max(1, ply.sl_data2["sens"] / 2)
                        local bonushealth = baseDamage * sensModifier

                        -- if v:Health() < v:GetMaxHealth() then
                        --     ply:addXP(math.Round(bonushealth/30))
                        -- end

                        timer.Create("Heal_Regeneration5"..v:SteamID64(), 0.7, 10, function()
                            if v:Health() + bonushealth/20 > v:GetMaxHealth() then
                                v:SetHealth(v:GetMaxHealth())
                            else
                                v:SetHealth(v:Health() + bonushealth/20)
                            end
                        end)

                        v:EmitSound("mad_sfx_sololeveling/heal/heal4.mp3", 75, math.random(70, 130), 0.8, CHAN_AUTO)
                        timer.Simple(0.001, function() ParticleEffectAttach("utaunt_arcane_green_parent", 4, v, 0) end)
                        timer.Simple(7, function()
                            v:StopParticles()
                        end)

                    end
                end                

            end)

        end,
    },

    -- ["healer6"] = {
    --     stam = 300,
    --     name = "Zone de buff",
    --     level = 30,
    --     icon = "mad_sololeveling/skills/icons/a (213).png",
    --     classe = "healer",
    --     coldown = 2,
    --     type = "magie",
    --     ismagie = false,
    --     element = "none",
    --     code = function(ply)

    --         ply:Mad_SetAnim( "mad_fl??che5emeattaque" )
		
    --         ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
    --         timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
    --         timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
    --         timer_Simple(0.2,function()

    --             timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    --             timer_Simple(0.001, function() ParticleEffect( "amphora_splash_heal", ply:GetPos(), ply:GetAngles(), ply ) end)

    --             if ply:IsOnGround() then
    --                 timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
    --             end
    
    --             ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	

    --             for k, v in pairs(ents.FindInSphere(ply:GetPos(), 350)) do
    --                 if v:IsPlayer() then

    --                     if v:GetActiveWeapon().BonusDegats then
    --                         v.BonusDegats = v:GetActiveWeapon().BonusDegats
    --                         v:GetActiveWeapon().BonusDegats = v.BonusDegats*1.5
    --                     end
    --                     v:SetLaggedMovementValue(1.5)

    --                     local bonushealth = ( 250 + ply:GetActiveWeapon().BonusDegats ) * ply.sl_data2["force"]/2

    --                     -- if v:Health() < v:GetMaxHealth() then
    --                     --     ply:addXP(math.Round(bonushealth/30))
    --                     -- end


    --                     timer.Create("Heal_Regeneration6"..v:SteamID64(), 0.7, 10, function()
    --                         if v:Health() + bonushealth/50 > v:GetMaxHealth() then
    --                             v:SetHealth(v:GetMaxHealth())
    --                         else
    --                             v:SetHealth(v:Health() + bonushealth/50)
    --                         end
    --                     end)

    --                     v:EmitSound("mad_sfx_sololeveling/heal/heal2.mp3", 75, math.random(70, 130), 0.8, CHAN_AUTO)
    --                     timer.Simple(0.001, function() ParticleEffectAttach("utaunt_arcane_yellow_parent", 4, v, 0) end)
    --                     timer.Simple(0.001, function() ParticleEffectAttach("utaunt_runeprison_teamcolor_red", 4, v, 0) end)
    --                     timer.Simple(0.001, function() ParticleEffectAttach("utaunt_auroraglow_orange_parent", 4, v, 0) end)
    --                     timer.Simple(7, function()
    --                         v:StopParticles()
    --                         if v:GetActiveWeapon().BonusDegats then
    --                             v:GetActiveWeapon().BonusDegats = v.BonusDegats
    --                         end
    --                         v:SetLaggedMovementValue(1)
    --                     end)

    --                 end
    --             end                

    --         end)

    --     end,
    -- },

    ["healer7"] = {
        stam = 50,
        name = "Résurrection",
        level = 35,
        icon = "mad_sololeveling/skills/icons/a (210).png",
        classe = "healer",
        coldown = 50,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_filsattaquesimple1" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	

                for k, v in ipairs( ents.FindInSphere( ply:GetPos(), 1000 ) ) do
                    if IsValid(v) then
                        if (IsValid(v) and v:IsPlayer() and v != ply ) then

                            print(v:Nick())
                            if not v:Alive() then
                                v:Spawn()
                                v:SetPos(ply:GetPos() + ply:GetForward()*150)
                                ParticleEffectAttach("utaunt_hands_green_parent", 4, v, 0)
                                ParticleEffectAttach("capfx_parent", 4, v, 0)
                                v:EmitSound("mad_sfx_sololeveling/heal/heal3.mp3", 75, math.random(70, 130), 0.8, CHAN_AUTO)
                                timer_Simple(3,function()
                                    v:StopParticles()
                                    v:SetHealth(v:Health()/5)
                                end)
                            end

                        end
                    end
                end

            end)

        end,
    },

    ["invocateur1"] = {
        stam = 40,
        name = "Gobelin",
        level = 2,
        icon = "mad_sololeveling/skills/icons/a (140).png",
        classe = "invocateur",
        coldown = 2,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            local pos = ply:GetShootPos()
            local aim = ply:GetAimVector()
            local vector = 190
            local radius = 45
        
            local slash = {}
            slash.start = ply:GetShootPos()
            slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
            slash.filter = ply
            slash.mins = Vector(-radius, -radius, 0)
            slash.maxs = Vector(radius, radius, 0)
            local tr = util.TraceHull(slash)        

            ply.goblin = ents.Create("prop_dynamic")
            ply.goblin:SetMaterial("models/shiny")
            ply.goblin:SetModel("models/mad_goblin.mdl")
            ply.goblin:SetModelScale(1.5)
            ply.goblin:SetOwner(ply)
            ply.goblin:SetPos(ply:GetPos() + ply:GetForward() * 50)
            ply.goblin:SetAngles(ply:GetAngles())
            ply.goblin:Spawn()
            ply.goblin:ResetSequence("attack"..math.random(2))
            ply.goblin:SetSequence("attack"..math.random(2))
            ply.goblin:DrawShadow(false)
            ply.goblin:SetRenderMode(RENDERMODE_TRANSALPHA)
            ply.goblin:SetColor(Color(0, 0, 0, 0))

            timer.Simple(0.001, function()
                ParticleEffectAttach("utaunt_wispy_parent_g", 4, ply.goblin, 0)
            end)
 
            for i = 0, 255, 5 do
                timer.Simple(i * 0.004, function()
                    if IsValid(ply.goblin) then
                        ply.goblin:SetColor(Color(0, 0, 0, i))
                    end
                end)
            end
            
			timer.Simple(1, function()
				for i = 0, 255, 5 do
					timer.Simple(i * 0.004, function()
						if IsValid(ply.goblin) then
							ply.goblin:SetColor(Color(0, 0, 0, 255 - i))
						end
					end)
				end
				timer.Simple(1.2, function()
					if IsValid(ply.goblin) then
						ply.goblin:Remove()
					end
				end)
			end)

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply or tr.Entity:IsNPC() and IsValid(tr.Entity)) or tr.Entity:IsNextBot() and IsValid(tr.Entity) then
                            tr.Entity:TakeDamage(90+ply:GetActiveWeapon().BonusDegats, ply, ply:GetActiveWeapon())
                            tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
                            util.ScreenShake(pos, 3, 50, 0.5, 150)
                            local torsoAttachID = tr.Entity:LookupAttachment("chest")
                            if torsoAttachID == 0 then
                                timer.Simple(0.001, function() ParticleEffect( "mudrock", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_flash_2", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_helper_3", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                            else
                                timer.Simple(0.001, function() ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_flash_2", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                            end
                        end
                    end
                end

            end)

        end,
    },

    ["invocateur2"] = {
        stam = 65,
        name = "Mage gobelin",
        level = 10,
        icon = "mad_sololeveling/skills/icons/a (150).png",
        classe = "invocateur",
        coldown = 5,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply.goblinmage = ents.Create("prop_dynamic")
            ply.goblinmage:SetModel("models/mad_goblinmage.mdl")
            ply.goblinmage:SetMaterial("models/shiny")
            ply.goblinmage:SetModelScale(1.5)
            ply.goblinmage:SetOwner(ply)
            ply.goblinmage:SetPos(ply:GetPos() + ply:GetForward() * 50)
            ply.goblinmage:SetAngles(ply:GetAngles())
            ply.goblinmage:Spawn()
            ply.goblinmage:ResetSequence("attack"..math.random(2))
            ply.goblinmage:SetSequence("attack"..math.random(2))
            ply.goblinmage:DrawShadow(false)
            ply.goblinmage:SetRenderMode(RENDERMODE_TRANSALPHA)
            ply.goblinmage:SetColor(Color(0, 0, 0, 0))

            timer.Simple(0.001, function()
                ParticleEffectAttach("utaunt_wispy_parent_g", 4, ply.goblinmage, 0)
            end)

            timer.Simple(0.7, function()
                ply.goblinmage.shot = ents.Create("ent_config_launch")
                --------------------------------------------------------------------------
                ply.goblinmage.shot.Damage = ( 125 + ply:GetActiveWeapon().BonusDegats )
                ply.goblinmage.shot.Burn = true
                ply.goblinmage.shot.BurnTime = 1
                --------------------------------------------------------------------------
                ply.goblinmage.shot.Freeze = false
                ply.goblinmage.shot.FreezeTimer = 0
                ply.goblinmage.shot.HaveFreezeEffect = false
                ply.goblinmage.shot.FreezeEffect = ""
                --------------------------------------------------------------------------
                ply.goblinmage.shot.HaveHitSound = true
                ply.goblinmage.shot.HitSound = hitjoueur[math.random(1,3)]
                ply.goblinmage.shot.MinSound = 70
                ply.goblinmage.shot.MaxSound = 130
                ply.goblinmage.shot.HaveRepeat = false
                ply.goblinmage.shot.RepeatTime = 0
                --------------------------------------------------------------------------
                ply.goblinmage.shot:SetPos(ply.goblinmage:GetPos() + Vector(0,0,50) + ply.goblinmage:GetForward()*75)
                ply.goblinmage.shot:SetOwner(ply)
                ply.goblinmage.shot:SetAngles(ply.goblinmage:GetAngles())
                ply.goblinmage.shot:Spawn()
                ply.goblinmage.shot:GetPhysicsObject():EnableMotion(true)
                ply.goblinmage.shot:SetRenderMode( RENDERMODE_TRANSCOLOR )
                ply.goblinmage.shot:SetColor(Color(0,0,0,0))
                ply.goblinmage.shot:SetModel("models/hunter/misc/sphere175x175.mdl")
    
                timer.Simple(0.001, function()
                    ParticleEffectAttach("[1]_fire_goblinmage_projectile", 4, ply.goblinmage.shot, 0)
                end)
    
                local phys = ply.goblinmage.shot:GetPhysicsObject()
                phys:EnableGravity(false)
                phys:SetVelocity( ply.goblinmage.shot:GetForward() * 750 )
            end)

            timer.Simple(0.001, function()
                ParticleEffectAttach("utaunt_wispy_parent_g", 4, ply.goblin, 0)
            end)
 
            for i = 0, 255, 5 do
                timer.Simple(i * 0.004, function()
                    if IsValid(ply.goblinmage) then
                        ply.goblinmage:SetColor(Color(0, 0, 0, i))
                    end
                end)
            end
            
			timer.Simple(1, function()
				for i = 0, 255, 5 do
					timer.Simple(i * 0.004, function()
						if IsValid(ply.goblinmage) then
							ply.goblinmage:SetColor(Color(0, 0, 0, 255 - i))
						end
					end)
				end
				timer.Simple(1.2, function()
					if IsValid(ply.goblinmage) then
						ply.goblinmage:Remove()
					end
				end)
			end)

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
            end)

        end,
    },

    ["invocateur3"] = {
        stam = 90,
        name = "Loup",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (30).png",
        classe = "invocateur",
        coldown = 7,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            local pos = ply:GetShootPos()
            local aim = ply:GetAimVector()
            local vector = 190
            local radius = 45
        
            local slash = {}
            slash.start = ply:GetShootPos()
            slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
            slash.filter = ply
            slash.mins = Vector(-radius, -radius, 0)
            slash.maxs = Vector(radius, radius, 0)
            local tr = util.TraceHull(slash)      

            ply.wolf = ents.Create("prop_dynamic")
            ply.wolf:SetMaterial("models/shiny")
            ply.wolf:SetModel("models/mad_loupevo.mdl")
            ply.wolf:SetModelScale(1.5)
            ply.wolf:SetOwner(ply)
            ply.wolf:SetPos(ply:GetPos() + ply:GetForward() * 125)
            ply.wolf:SetAngles(ply:GetAngles())
            ply.wolf:Spawn()
            ply.wolf:ResetSequence("attack"..math.random(2))
            ply.wolf:SetSequence("attack"..math.random(2))
            ply.wolf:DrawShadow(false)
            ply.wolf:SetRenderMode(RENDERMODE_TRANSALPHA)
            ply.wolf:SetColor(Color(0, 0, 0, 0))

            timer.Simple(0.001, function()
                ParticleEffectAttach("utaunt_wispy_parent_g", 4, ply.wolf, 0)
            end)
 
            for i = 0, 255, 5 do
                timer.Simple(i * 0.004, function()
                    if IsValid(ply.wolf) then
                        ply.wolf:SetColor(Color(0, 0, 0, i))
                    end
                end)
            end
            
			timer.Simple(1, function()
				for i = 0, 255, 5 do
					timer.Simple(i * 0.004, function()
						if IsValid(ply.wolf) then
							ply.wolf:SetColor(Color(0, 0, 0, 255 - i))
						end
					end)
				end
				timer.Simple(1.2, function()
					if IsValid(ply.wolf) then
						ply.wolf:Remove()
					end
				end)
			end)

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply or tr.Entity:IsNPC() and IsValid(tr.Entity)) or tr.Entity:IsNextBot() and IsValid(tr.Entity) then
                            tr.Entity:TakeDamage(145+ply:GetActiveWeapon().BonusDegats, ply, ply:GetActiveWeapon())
                            tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
                            util.ScreenShake(pos, 3, 50, 0.5, 150)
                            local torsoAttachID = tr.Entity:LookupAttachment("chest")
                            if torsoAttachID == 0 then
                                timer.Simple(0.001, function() ParticleEffect( "mudrock", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_flash_2", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_helper_3", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                            else
                                timer.Simple(0.001, function() ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_flash_2", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                            end
                        end
                    end
                end
                
            end)

        end,
    },

    ["invocateur4"] = {
        stam = 140,
        name = "Mort-vivant",
        level = 30,
        icon = "mad_sololeveling/skills/icons/a (256).png",
        classe = "invocateur",
        coldown = 9,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            local pos = ply:GetShootPos()
            local aim = ply:GetAimVector()
            local vector = 190
            local radius = 45
        
            local slash = {}
            slash.start = ply:GetShootPos()
            slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
            slash.filter = ply
            slash.mins = Vector(-radius, -radius, 0)
            slash.maxs = Vector(radius, radius, 0)
            local tr = util.TraceHull(slash)      

            ply.undead = ents.Create("prop_dynamic")
            ply.undead:SetMaterial("models/shiny")
            ply.undead:SetModel("models/mad_undeadmob.mdl")
            ply.undead:SetModelScale(1.5)
            ply.undead:SetOwner(ply)
            ply.undead:SetPos(ply:GetPos() + ply:GetForward() * 85)
            ply.undead:SetAngles(ply:GetAngles())
            ply.undead:Spawn()
            ply.undead:ResetSequence("attack"..math.random(2))
            ply.undead:SetSequence("attack"..math.random(2))
            ply.undead:DrawShadow(false)
            ply.undead:SetRenderMode(RENDERMODE_TRANSALPHA)
            ply.undead:SetColor(Color(0, 0, 0, 0))

            timer.Simple(0.001, function()
                ParticleEffectAttach("utaunt_wispy_parent_g", 4, ply.undead, 0)
            end)
 
            for i = 0, 255, 5 do
                timer.Simple(i * 0.004, function()
                    if IsValid(ply.undead) then
                        ply.undead:SetColor(Color(0, 0, 0, i))
                    end
                end)
            end
            
			timer.Simple(1, function()
				for i = 0, 255, 5 do
					timer.Simple(i * 0.004, function()
						if IsValid(ply.undead) then
							ply.undead:SetColor(Color(0, 0, 0, 255 - i))
						end
					end)
				end
				timer.Simple(1.2, function()
					if IsValid(ply.undead) then
						ply.undead:Remove()
					end
				end)
			end)

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply or tr.Entity:IsNPC() and IsValid(tr.Entity)) or tr.Entity:IsNextBot() and IsValid(tr.Entity) then
                            tr.Entity:TakeDamage(250+ply:GetActiveWeapon().BonusDegats, ply, ply:GetActiveWeapon())
                            tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
                            util.ScreenShake(pos, 3, 50, 0.5, 150)
                            local torsoAttachID = tr.Entity:LookupAttachment("chest")
                            if torsoAttachID == 0 then
                                timer.Simple(0.001, function() ParticleEffect( "mudrock", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_flash_2", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_helper_3", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                            else
                                timer.Simple(0.001, function() ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_flash_2", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                            end
                        end
                    end
                end

                local vector = 150
                local radius = 45
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if not tr.Entity:IsPlayer() and tr.Entity == ply then return end
                        timer.Create("PoisonDamageInvoc".. ply:SteamID64(), 0.2, 10, function()
                            if not tr.Entity:Alive() then return end
                            tr.Entity:TakeDamage(5)
                        end)
                    end
                end
                
            end)

        end,
    },

    ["invocateur5"] = {
        stam = 260,
        name = "Roi des morts-vivants",
        level = 65,
        icon = "mad_sololeveling/skills/icons/a (257).png",
        classe = "invocateur",
        coldown = 25,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            local pos = ply:GetShootPos()
            local aim = ply:GetAimVector()
            local vector = 400
            local radius = 60
        
            local slash = {}
            slash.start = ply:GetShootPos()
            slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
            slash.filter = ply
            slash.mins = Vector(-radius, -radius, 0)
            slash.maxs = Vector(radius, radius, 0)
            local tr = util.TraceHull(slash)      

            ply.undeadking = ents.Create("prop_dynamic")
            ply.undeadking:SetMaterial("models/shiny")
            ply.undeadking:SetModel("models/mad_undeadboss.mdl")
            ply.undeadking:SetModelScale(1.5)
            ply.undeadking:SetOwner(ply)
            ply.undeadking:SetPos(ply:GetPos() + ply:GetForward() * 85)
            ply.undeadking:SetAngles(ply:GetAngles())
            ply.undeadking:Spawn()
            ply.undeadking:ResetSequence("attack"..math.random(2))
            ply.undeadking:SetSequence("attack"..math.random(2))
            ply.undeadking:DrawShadow(false)
            ply.undeadking:SetRenderMode(RENDERMODE_TRANSALPHA)
            ply.undeadking:SetColor(Color(0, 0, 0, 0))

            timer.Simple(0.001, function()
                ParticleEffectAttach("utaunt_wispy_parent_g", 4, ply.undeadking, 0)
            end)
 
            for i = 0, 255, 5 do
                timer.Simple(i * 0.004, function()
                    if IsValid(ply.undeadking) then
                        ply.undeadking:SetColor(Color(0, 0, 0, i))
                    end
                end)
            end
            
			timer.Simple(1, function()
				for i = 0, 255, 5 do
					timer.Simple(i * 0.004, function()
						if IsValid(ply.undeadking) then
							ply.undeadking:SetColor(Color(0, 0, 0, 255 - i))
						end
					end)
				end
				timer.Simple(1.2, function()
					if IsValid(ply.undeadking) then
						ply.undeadking:Remove()
					end
				end)
			end)

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.9,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/punch/sakazuki_LavaPunch01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply or tr.Entity:IsNPC() and IsValid(tr.Entity)) or tr.Entity:IsNextBot() and IsValid(tr.Entity) then
                            tr.Entity:TakeDamage(630+ply:GetActiveWeapon().BonusDegats, ply, ply:GetActiveWeapon())
                            tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
                            util.ScreenShake(pos, 3, 50, 0.5, 150)
                            local torsoAttachID = tr.Entity:LookupAttachment("chest")
                            if torsoAttachID == 0 then
                                timer.Simple(0.001, function() ParticleEffect( "mudrock", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_flash_2", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_helper_3", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                            else
                                timer.Simple(0.001, function() ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_flash_2", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                            end
                        end
                    end
                end

                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
                ParticleEffect( "[union]_rock_smash", ply.undeadking:GetPos()+ply:GetForward()*200, ply.undeadking:GetAngles() )

                local vector = 150
                local radius = 45
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if not tr.Entity:IsPlayer() and tr.Entity == ply then return end
                        timer.Create("PoisonDamageInvoc2".. ply:SteamID64(), 0.2, 10, function()
                            if not tr.Entity:Alive() then return end
                            tr.Entity:TakeDamage(25)
                        end)
                    end
                end
                
            end)

        end,
    },

    ["invocateur6"] = {
        stam = 200,
        name = "Roi loup-garou",
        level = 50,
        icon = "mad_sololeveling/skills/icons/a (79).png",
        classe = "invocateur",
        coldown = 18,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            local pos = ply:GetShootPos()
            local aim = ply:GetAimVector()
            local vector = 400
            local radius = 60
        
            local slash = {}
            slash.start = ply:GetShootPos()
            slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
            slash.filter = ply
            slash.mins = Vector(-radius, -radius, 0)
            slash.maxs = Vector(radius, radius, 0)
            local tr = util.TraceHull(slash)      

            ply.werewolfking = ents.Create("prop_dynamic")
            ply.werewolfking:SetMaterial("models/shiny")
            ply.werewolfking:SetModel("models/mad_werewolfboss.mdl")
            ply.werewolfking:SetModelScale(1.5)
            ply.werewolfking:SetOwner(ply)
            ply.werewolfking:SetPos(ply:GetPos() + ply:GetForward() * 85)
            ply.werewolfking:SetAngles(ply:GetAngles())
            ply.werewolfking:Spawn()
            ply.werewolfking:ResetSequence("attack"..math.random(2))
            ply.werewolfking:SetSequence("attack"..math.random(2))
            ply.werewolfking:DrawShadow(false)
            ply.werewolfking:SetRenderMode(RENDERMODE_TRANSALPHA)
            ply.werewolfking:SetColor(Color(0, 0, 0, 0))

            timer.Simple(0.001, function()
                ParticleEffectAttach("utaunt_wispy_parent_g", 4, ply.werewolfking, 0)
            end)
 
            for i = 0, 255, 5 do
                timer.Simple(i * 0.004, function()
                    if IsValid(ply.werewolfking) then
                        ply.werewolfking:SetColor(Color(0, 0, 0, i))
                    end
                end)
            end
            
			timer.Simple(1, function()
				for i = 0, 255, 5 do
					timer.Simple(i * 0.004, function()
						if IsValid(ply.werewolfking) then
							ply.werewolfking:SetColor(Color(0, 0, 0, 255 - i))
						end
					end)
				end
				timer.Simple(1.2, function()
					if IsValid(ply.werewolfking) then
						ply.werewolfking:Remove()
					end
				end)
			end)

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.4,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/punch/sakazuki_LavaPunch01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply or tr.Entity:IsNPC() and IsValid(tr.Entity)) or tr.Entity:IsNextBot() and IsValid(tr.Entity) then
                            tr.Entity:TakeDamage(420+ply:GetActiveWeapon().BonusDegats, ply, ply:GetActiveWeapon())
                            tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
                            util.ScreenShake(pos, 3, 50, 0.5, 150)
                            local torsoAttachID = tr.Entity:LookupAttachment("chest")
                            if torsoAttachID == 0 then
                                timer.Simple(0.001, function() ParticleEffect( "mudrock", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_flash_2", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_helper_3", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                            else
                                timer.Simple(0.001, function() ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_flash_2", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                            end
                        end
                    end
                end

                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
                ParticleEffect( "[union]_rock_smash", ply.werewolfking:GetPos()+ply:GetForward()*200, ply.werewolfking:GetAngles() )

                local vector = 150
                local radius = 45
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if not tr.Entity:IsPlayer() and tr.Entity == ply then return end
                        timer.Create("PoisonDamageInvoc3".. ply:SteamID64(), 0.2, 10, function()
                            if not tr.Entity:Alive() then return end
                            tr.Entity:TakeDamage(25)
                        end)
                    end
                end
                
            end)

        end,
    },

    ["invocateur7"] = {
        stam = 155,
        name = "Centipede",
        level = 35,
        icon = "mad_sololeveling/skills/icons/a (94).png",
        classe = "invocateur",
        coldown = 15,
        type = "magie",
        ismagie = false,
        element = "none",
        code = function(ply)

            local pos = ply:GetShootPos()
            local aim = ply:GetAimVector()
            local vector = 400
            local radius = 60
        
            local slash = {}
            slash.start = ply:GetShootPos()
            slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
            slash.filter = ply
            slash.mins = Vector(-radius, -radius, 0)
            slash.maxs = Vector(radius, radius, 0)
            local tr = util.TraceHull(slash)      

            ply.centipede = ents.Create("prop_dynamic")
            ply.centipede:SetMaterial("models/shiny")
            ply.centipede:SetModel("models/mad_centipedeboss.mdl")
            ply.centipede:SetModelScale(1.5)
            ply.centipede:SetOwner(ply)
            ply.centipede:SetPos(ply:GetPos() + ply:GetForward() * 85)
            ply.centipede:SetAngles(ply:GetAngles())
            ply.centipede:Spawn()
            ply.centipede:ResetSequence("attack"..math.random(2))
            ply.centipede:SetSequence("attack"..math.random(2))
            ply.centipede:DrawShadow(false)
            ply.centipede:SetRenderMode(RENDERMODE_TRANSALPHA)
            ply.centipede:SetColor(Color(0, 0, 0, 0))

            timer.Simple(0.001, function()
                ParticleEffectAttach("utaunt_wispy_parent_g", 4, ply.centipede, 0)
            end)
 
            for i = 0, 255, 5 do
                timer.Simple(i * 0.004, function()
                    if IsValid(ply.centipede) then
                        ply.centipede:SetColor(Color(0, 0, 0, i))
                    end
                end)
            end
            
			timer.Simple(1, function()
				for i = 0, 255, 5 do
					timer.Simple(i * 0.004, function()
						if IsValid(ply.centipede) then
							ply.centipede:SetColor(Color(0, 0, 0, 255 - i))
						end
					end)
				end
				timer.Simple(1.2, function()
					if IsValid(ply.centipede) then
						ply.centipede:Remove()
					end
				end)
			end)

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
    
            timer_Simple(0.4,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:EmitSound( "mad_sfx_sololeveling/punch/sakazuki_LavaPunch01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 

                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply or tr.Entity:IsNPC() and IsValid(tr.Entity)) or tr.Entity:IsNextBot() and IsValid(tr.Entity) then
                            tr.Entity:TakeDamage(360+ply:GetActiveWeapon().BonusDegats, ply, ply:GetActiveWeapon())
                            tr.Entity:EmitSound(hitjoueur[math.random(1, 3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
                            util.ScreenShake(pos, 3, 50, 0.5, 150)
                            local torsoAttachID = tr.Entity:LookupAttachment("chest")
                            if torsoAttachID == 0 then
                                timer.Simple(0.001, function() ParticleEffect( "mudrock", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_flash_2", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                                timer.Simple(0.001, function() ParticleEffect( "slashhit_helper_3", tr.Entity:GetPos()+tr.Entity:GetUp()*40, Angle(0,0,0), tr.Entity ) end)
                            else
                                timer.Simple(0.001, function() ParticleEffectAttach("mudrock", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_flash_2", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                                timer.Simple(0.001, function() ParticleEffectAttach("slashhit_helper_3", PATTACH_POINT_FOLLOW, tr.Entity, torsoAttachID) end)
                            end
                        end
                    end
                end

                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
                ParticleEffect( "[union]_rock_smash", ply.centipede:GetPos()+ply:GetForward()*200, ply.centipede:GetAngles() )

                local vector = 150
                local radius = 45
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if not tr.Entity:IsPlayer() and tr.Entity == ply then return end
                        ParticleEffectAttach("utaunt_spider_green_parent", 4, tr.Entity, 0)
                        timer.Simple(2, function()
                            tr.Entity:StopParticles()
                        end)
                        timer.Create("PoisonDamageInvoc3".. ply:SteamID64(), 0.2, 10, function()
                            if not tr.Entity:Alive() then return end
                            tr.Entity:TakeDamage(25)
                        end)
                    end
                end
                
            end)

        end,
    },

    ["bestial1"] = {
        stam = 50,
        name = "Attaque Rapide",
        level = 2,
        icon = "mad_sololeveling/skills/icons/a (29).png",
        classe = "bestial",
        coldown = 5,
        type = "corpsacorps",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_fl??cheattaquesimple2" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
                timer_Simple(0.001, function() ParticleEffect( "[2]_fog_slash_add", ply:GetPos()+ply:GetUp()*35+ply:GetForward()*35, ply:GetAngles() + Angle(30,90,90), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(20, 65, 25)
            end)

        end,
    },

    ["bestial2"] = {
        stam = 100,
        name = "Enchainement",
        level = 10,
        icon = "mad_sololeveling/skills/icons/a (225).png",
        classe = "bestial",
        coldown = 5,
        type = "corpsacorps",
        ismagie = false,
        element = "none",
        code = function(ply)
    
            ply:Mad_SetAnim( "mad_fl??cheattaquelourde1" )
            
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO )
            
            ply:GetActiveWeapon():DamageAttaque(35/2, 65, 35)
            
            timer_Simple(0.001, function() ParticleEffect( "[2]_fog_slash_add", ply:GetPos()+ply:GetUp()*35+ply:GetForward()*35, ply:GetAngles() + Angle(-30,90,90), ply ) end)
    
            timer_Simple(0.2,function()
    
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
                timer_Simple(0.001, function() ParticleEffect( "[2]_fog_slash_add", ply:GetPos()+ply:GetUp()*35+ply:GetForward()*35, ply:GetAngles() + Angle(30,90,90), ply ) end)
    
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end
    
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(35/2, 65, 35)
            end)
    
        end,
    },

    ["bestial3"] = {
        stam = 150,
        name = "Claquer",
        level = 15,
        icon = "mad_sololeveling/skills/icons/a (340).png",
        classe = "bestial",
        coldown = 5,
        type = "corpsacorps",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_tambourattaquelourde1" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
            end)

            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
    
            timer_Simple(0.4,function()
                ply:EmitSound( "mad_sfx_sololeveling/punch/sakazuki_LavaPunch01.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(80, 65, 35)

                ParticleEffect( "[union]_rock_smash", ply:GetPos()+ply:GetForward()*75, ply:GetAngles() )
            end)

        end,
    },

    ["bestial4"] = {
        stam = 200,
        name = "Ravage",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (318).png",
        classe = "bestial",
        coldown = 9,
        type = "corpsacorps",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_soryu4emeattaque" )
            
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 				

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end

            timer_Simple(0.15,function()
                ply:GetActiveWeapon():DamageAttaque(75, 65, 35)
            end)
    
            timer_Simple(0.8,function()
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                ply:GetActiveWeapon():DamageAttaque(75/6, 65, 35)	

                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end

                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
                timer.Create("Bestial4Atk".. ply:SteamID(), 0.15, 5, function()
                    timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
                    ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
                    ply:GetActiveWeapon():DamageAttaque(75/6, 65, 35)

                    if ply:IsOnGround() then
                        timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                    end

                end)
            end)

        end,
    },

    ["bestial5"] = {
        stam = 250,
        name = "Attaque oculaire",
        level = 25,
        icon = "mad_sololeveling/skills/icons/a (278).png",
        classe = "bestial",
        coldown = 9,
        type = "corpsacorps",
        ismagie = false,
        element = "none",
        code = function(ply)

            ply:Mad_SetAnim( "mad_rui_a_p1007_v00_c00_atkcmbw02" )
            
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 
            ply:GetActiveWeapon():DamageAttaque(190/2, 65, 35)				

            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
            timer_Simple(0.1, function() ParticleEffect( "[2]_fog_slash_add", ply:GetPos()+ply:GetUp()*35+ply:GetForward()*35, ply:GetAngles() + Angle(130,90,90), ply ) end)
            timer_Simple(0.2, function() ParticleEffect( "[2]_fog_slash_add", ply:GetPos()+ply:GetUp()*35+ply:GetForward()*35, ply:GetAngles() + Angle(40,90,90), ply ) end)

            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
            end
    
            timer_Simple(0.2,function()
                if ply:IsOnGround() then
                    timer_Simple(0.1, function() ply:SetVelocity(ply:GetForward()*250) ply:ViewPunch(Angle(0, 0, 10)) end)
                end

                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(190/2, 65, 35)

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 65 + 50
                local radius = 35 + 20
            
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(-radius, -radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and tr.Entity != ply) then
                            tr.Entity:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 5, 1 )
                            ply:ChatPrint("[OKIRO] Vous avez aveuglé quelqu'un" )
                            ply:ChatPrint("[OKIRO] La cible possède actuellement : ".. tr.Entity:Health() .. " HP" )
                        end
                    end
                end

               
            end)

        end,
    },

    ["bestial6"] = {
        stam = 300,
        name = "Onde de choc",
        level = 30,
        icon = "mad_sololeveling/skills/icons/a (320).png",
        classe = "bestial",
        coldown = 5,
        type = "corpsacorps",
        ismagie = false,
        element = "none",
        code = function(ply)

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_soryueveil" )

            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		

            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(1, function()
                ply:EmitSound( "mad_sfx_sololeveling/bestial/roar2.mp3", 100, math.random(70, 80), 0.8, CHAN_AUTO ) 
            end)

            timer_Simple(1.2,function()
                timer_Simple(0.001, function() ParticleEffect( "dust_conquer_charge", ply:GetPos(), ply:GetAngles(), ply ) end)
                timer_Simple(0.001, function() ParticleEffect( "dust_sharp_shockwave", ply:GetPos(), ply:GetAngles(), ply ) end)
                timer_Simple(0.001, function() ParticleEffect( "auraburst_sharp", ply:GetPos(), ply:GetAngles(), ply ) end)
                timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)

                for k, v in ipairs( ents.FindInSphere( ply:GetPos(), 500 ) ) do
                    if v:IsPlayer() and v != ply then
                        v:Mad_SetAnim("mad_eaufear")
                        v:Freeze(true)
                        v:ChatPrint("[OKIRO] Vous êtes paralysé de peur.")
                        v:ViewPunch(Angle(0, 0, 50))
                        timer.Simple(4.3, function()
                            v:Freeze(false)
                        end)
                    elseif v:IsNPC() or v:IsNextBot() then
                        v:TakeDamage(250)
                    end
                end

            end)
            
            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)
    
            if ply:IsOnGround() then
                timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            end

            timer_Simple(2, function()
                ply:SetMoveType(MOVETYPE_WALK)
            end)

        end,
    },

    ["bestial7"] = {
        stam = 350,
        name = "Choc terrestre",
        level = 35,
        icon = "mad_sololeveling/skills/icons/a (315).png",
        classe = "bestial",
        coldown = 10,
        type = "corpsacorps",
        ismagie = false,
        element = "none",
        code = function(ply)

            local effectdata = EffectData()
			effectdata:SetOrigin( ply:GetPos() )
			effectdata:SetEntity( ply )
		    util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_soryu6emeattaque" )
		
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO )

            util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            timer_Simple(0.001, function() ParticleEffect( "dust_conquer_charge", ply:GetPos(), ply:GetAngles(), ply ) end)
            timer_Simple(0.001, function() ParticleEffect( "dust_sharp_shockwave", ply:GetPos(), ply:GetAngles(), ply ) end)
            timer_Simple(0.001, function() ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)

            timer_Simple(0.5, function() 
                ply:StopParticles()
            end)


            timer_Simple(0.7,function()

                ParticleEffect( "[bestial]_forward_dash", ply:GetPos()+Vector(0,0,15), ply:GetAngles() + Angle(0,0,0), ply ) 
                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/normal/Punch_Explosion_02.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				

                for i=1,5 do 
                    
                    ParticleEffect( "[union]_rock_smash", ply:GetPos()+ply:GetForward()*75*i, ply:GetAngles() )
                    util.ScreenShake(ply:GetPos()+ply:GetForward()*75*i, 3, 50, 0.5, 250)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(400, 350, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

        end,
    },


    ["sable1"] = {
        stam = 5000,
        name = "Poussières de sable",
        level = 99,
        icon = "mad_sololeveling/skills/icons/a (315).png",
        classe = "mage",
        coldown = 5,
        type = "magie",
        ismagie = true,
        element = "sable",
        code = function(ply)
            ply:Mad_SetAnim( "ald_animation_213" )
            
            ply:SetNWInt("FOV", 90)
            ply:SetFOV(130, 0.5)

            timer_Simple(0.7,function()
                
                ParticleEffectAttach( "[6]_sand_charge", 1, ply, 0 ) 

                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/normal/Punch_Explosion_02.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO )                 
                if not (ply:DrawWorldModel(false) and ply:SetNoDraw(true) and ply:DrawShadow(false)) then
                    ply:DrawWorldModel( false )
                    ply:SetNoDraw( true )
                    ply:DrawShadow( false )
                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:SetVelocity(aim * 1500 + ply:GetUp() * 1000)

                timer.Create("CheckGroundTimer_" .. ply:EntIndex(), 0.1, 0, function()
                    if IsValid(ply) and ply:IsOnGround() then
                        ply:StopParticles() 
                        power = false
                        ply:DrawWorldModel( true )
                        ply:SetNoDraw( false )
                        ply:DrawShadow( true )
                        ply:SetFOV(ply:GetNWInt("FOV"), 0.5)
                        timer.Remove("CheckGroundTimer_" .. ply:EntIndex())
                    end
                end)

            end)

        end,
    },

    ["sable2"] = {
        stam = 5000,
        name = "Sable mouvant",
        level = 99,
        icon = "mad_sololeveling/skills/icons/a (315).png",
        classe = "mage",
        coldown = 10,
        type = "magie",
        ismagie = true,
        element = "sable",
        code = function(ply)
            ply:Mad_SetAnim( "mad_a_p1005_v01_c00_aktcmbl03 retarget" )
            
            ply:SetNWInt("FOV", 90)
            ply:SetFOV(110, 0.5)

            timer_Simple(0.7,function()
                
                ParticleEffectAttach( "[6]_sand_trap", 1, ply, 0 ) 
                
                if not (ply:DrawWorldModel(false) and ply:SetNoDraw(true) and ply:DrawShadow(false)) then
                    ply:DrawWorldModel( false )
                    ply:SetNoDraw( true )
                    ply:DrawShadow( false )
                end

                ply:EmitSound( "mad_sfx_sololeveling/sword/mihawknew_S7_swordwind.ogg", 75, math.random(70, 130), 0.8, CHAN_AUTO )     

                ply.dome = ents.Create("prop_dynamic")
                ply.dome:SetModel("models/hunter/blocks/cube025x025x025.mdl")
                ply.dome:SetColor(Color(255, 255, 255, 0))
                ply.dome:SetNoDraw(true)
                ply.dome:SetPos(ply:GetPos())
                ply.dome:SetParent(ply)
                ply.dome:Spawn()
    
                ply:Freeze(true)
                timer.Simple(1.5, function()
                    ply:Freeze(false)
                end)
    
                timer.Simple(1.5, function()
                    timer.Create("SableMouvant"..ply:SteamID64(), 0.2, 27.5, function()
                        if not IsValid(ply.dome) then timer.Remove("SableMouvant"..ply:SteamID64()) return end
                        for k, v in ipairs( ents.FindInSphere( ply.dome:GetPos(), 250 ) ) do
        
                            if v:IsNPC() or v:IsNextBot() or v:IsPlayer() then
                                v:SetMaxSpeed(10)

                                if v:Health() < v:GetMaxHealth() then
                                    if v:Health() < v:GetMaxHealth() - 2 then
                                        v:SetHealth(v:Health() - 2)
                                    else
                                        v:SetHealth(v:GetMaxHealth())
                                    end
                                end  
                            end
                        end
                    end)
                end)
    
                timer.Simple(6, function()
                    if IsValid(ply.dome) then
                        if IsValid(ply.dome) then
                            ply.dome:Remove()
                            ply:StopParticles()

                            ply:DrawWorldModel( true )
                            ply:SetNoDraw( false )
                            ply:DrawShadow( true )

                            ply:SetFOV(ply:GetNWInt("FOV"), 0.5)
                        end
                    end
                end)
            end)
        end,
    },

    ["sable3"] = {
        stam = 130,
        name = "Eruption de Sable",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (78).png",
        classe = "mage",
        coldown = 9,
        type = "magie",
        ismagie = true,
        element = "sable",
        code = function(ply)
            
            local effectdata = EffectData()
            effectdata:SetOrigin( ply:GetPos() )
            effectdata:SetEntity( ply )
            util.Effect( "sl_effect4", effectdata, true, true )

            ply:Mad_SetAnim( "mad_fils3emeattaque" )
        
            ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 		
            ply:EmitSound( "mad_sfx_sololeveling/fire/040_swg_fire1.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 			
            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function() 
                ParticleEffect( "dust_block", ply:GetPos(), ply:GetAngles(), ply ) 
                ParticleEffect( "[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply ) 
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.1, function() ply:ViewPunch(Angle(0, 0, 10)) end)
            ply:SetMoveType(MOVETYPE_NONE)

            timer_Simple(2,function()

                ply:ViewPunch(Angle(0, 0, 30))
                ply:EmitSound( "mad_sfx_sololeveling/fire/040_swg_fire1.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				
                ply:EmitSound( "mad_sfx_sololeveling/fire/Fireball_Lava_Launch3.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO ) 				

                for i=1,4 do 
                    
                    ParticleEffect( "[6]_sand_dash", ply:GetPos()+ply:GetForward()*125*i, ply:GetAngles(), ply )
                    util.ScreenShake(ply:GetPos()+ply:GetForward()*125*i, 3, 50, 0.5, 250)

                    timer_Simple(0.9, function() ply:StopParticles() end)

                end

                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 350
                local radius = 35
        
                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(- radius, - radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)
            
                if tr.Hit then
                    if IsValid(tr.Entity) then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            tr.Entity:SetVelocity(aim*1500 + tr.Entity:GetUp()*350)
                        end
                    end
                end

                ply:SetMoveType(MOVETYPE_WALK)
                ply:EmitSound( swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO ) 	
                ply:GetActiveWeapon():DamageAttaque(195, 195, 35)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 250)
            end)

        end,
    },
    
    ["archer1"] = {
        stam = 100,
        name = "Ombre des Forêts",
        level = 2,
        icon = "mad_sololeveling/skills/icons/a (180).png",
        classe = "archer",
        coldown = 2,
        type = "bow",
        ismagie = false,
        element = "none",
        code = function(ply) 
            if ply.Invisi then return end
    
            ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
            ply.i = 255
            ply.Invisi = true
            ply.CloakPos = ply:GetPos()
            ply.StoredWeapon = ply:GetActiveWeapon()
            local steamID = ply:SteamID64()
            local stam = math.floor(ply:GetNWInt("mana") / 50)
    
            timer.Create("StaminaInvisi".. steamID, 1, 0, function()
                if not IsValid(ply) or not ply.Invisi then
                    timer.Remove("StaminaInvisi".. steamID)
                    return
                end
                ply:Mad_TakeStam(10 + stam)
            end)
    
            timer.Create("InvisiCoagulation".. steamID, 0.05, 25, function()
                if not IsValid(ply) then return end
                ply.i = math.max(ply.i - 10, 0)
                ply:SetColor(Color(255,255,255,ply.i))
    
                if ply.i <= 10 then
                    ply:SetNoDraw(true)
                    ply:DrawShadow(false)
                    ply:DrawWorldModel(false)
                    timer.Remove("InvisiCoagulation".. steamID)
                end
            end)
    
            timer.Create("ClMoveCheck".. steamID, 0.1, 0, function()
                if not IsValid(ply) then
                    timer.Remove("ClMoveCheck".. steamID)
                    return
                end
                if ply:GetPos():Distance(ply.CloakPos) > 5 then
                    if IsValid(ply.StoredWeapon) then
                        ply.StoredWeapon:DesacInvisi()
                    end
                end
            end)
        end,
    },
    
    ["archer2"] = {
        stam = 250,
        name = "Prédateur Aérien",
        level = 10,
        icon = "mad_sololeveling/skills/icons/a (32).png",
        classe = "archer",
        coldown = 15,
        type = "bow",
        ismagie = false,
        element = "none",
        code = function(ply)
            if ply.AerialAttackActive then return end
    
            ply.AerialAttackActive = true
            ply.OriginalGravityForAerial = ply:GetGravity()
            ply:SetGravity(0.25)
            ply:SetLaggedMovementValue(0.5)
            ply:Mad_SetAnim("mad_filsjump1")
            ply:EmitSound(swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)
    
            timer.Simple(0.5, function()
                if IsValid(ply) and ply.AerialAttackActive then
                    ply:SetVelocity(Vector(0, 0, 350))
                    ParticleEffectAttach("kirakiraskill", 4, ply, 0)
                    ply:SetFOV(100, 0.3)
                    ply:EmitSound("mad_sfx_sololeveling/light/borsalino_LightShining02.ogg", 75, 90, 0.3, CHAN_AUTO)
                end
            end)
    
            local hookID = "AerialAttackHook" .. ply:SteamID64()
            local function Cleanup()
                if IsValid(ply) then
                    ply:SetGravity(ply.OriginalGravityForAerial or 1)
                    ply:SetLaggedMovementValue(1)
                    ply:SetFOV(0, 0.5)
                    ply.AerialAttackActive = false
                    ply:StopParticles()
                end
                hook.Remove("KeyPress", hookID)
            end
    
            hook.Add("KeyPress", hookID, function(player, key)
                if player == ply and key == IN_JUMP and ply.AerialAttackActive then
                    ply:SetVelocity(Vector(0, 0, 10))
                end
            end)
    
            timer.Simple(6, Cleanup)
            hook.Add("PlayerDeath", "AerialAttackDeath" .. ply:SteamID64(), function(victim)
                if victim == ply then Cleanup() end
            end)
        end,
    },
      
    ["archer3"] = {
        stam = 12,
        name = "Dague de Lancer",
        level = 15,
        icon = "mad_sololeveling/skills/icons/a (1).png",
        classe = "archer",
        coldown = 2,
        type = "bow",
        ismagie = false,
        element = "none",
        code = function(ply)
            ply:Mad_SetAnim( "mad_a_p0013_v00_c00_atkawake01 retarget" )
            if SERVER then
                local ang = ply:GetAimVector():Angle()
                local pos = ply:EyePos()+ang:Up()*-7+ang:Forward()*30
                local adjustAngle = Angle(-20, -90, 0) 
                local finalAngle = ang + adjustAngle
                local dagger = ents.Create("ent_dagger")
                if IsValid(dagger) then
                    dagger:SetOwner(ply)
                    dagger:SetPos(pos)
                    dagger:SetAngles(finalAngle)
                    dagger:Spawn()
                    dagger:Activate()
                    dagger:SetVelocity(ang:Forward()*3000)
                    dagger.Weapon = self
                end
                
            end
        end,
    },

    ["archer4"] = {
        stam = 100,
        name = "Marque du Chasseur",
        level = 20,
        icon = "mad_sololeveling/skills/icons/a (78).png",
        classe = "archer",
        coldown = 2,
        type = "bow",
        ismagie = false,
        element = "none",
        code = function(ply)
            ply:SetNWEntity("MarkTarget", nil)
            ply:SetNWBool("MarkActive", true)
    
            timer.Simple(15, function()
                ply:SetNWBool("MarkActive", false)
                ply:SetNWEntity("MarkTarget", nil)
            end)

            local function ArcherMark(v, attacker)
                v.MarkAtt = attacker
                v:SetNWBool("MarkArcher", true)
                if IsValid(v) then
                    timer.Simple(15, function()
                        v:SetNWBool("MarkArcher", false)
                    end)
                end
            end

            hook.Add("EntityTakeDamage", "ArcherMarkBuff", function(v, dmgInfo)
                local attacker = dmgInfo:GetAttacker()
                if IsValid(attacker) and attacker:GetNWBool("MarkActive") then
                    attacker:SetNWEntity("MarkTarget", v)
                    attacker:SetNWBool("MarkActive", false)
                    ArcherMark(v, attacker)
                end
            end)
    
            hook.Add("EntityTakeDamage", "ArcherMarkDeBuff", function(v, dmgInfo)
                if v:GetNWBool("MarkArcher") and v.MarkAtt == dmgInfo:GetAttacker() then
                    dmgInfo:ScaleDamage(1.5)
                end
            end)
        end
    },

    ["archer5"] = {
        stam = 200,
        name = "Chaînes du Silence",
        level = 25,
        icon = "mad_sololeveling/skills/icons/a (64).png",
        classe = "archer",
        coldown = 5,
        type = "bow",
        ismagie = false,
        element = "none",
        code = function(ply)
            ply:Mad_SetAnim("aby_swiping_mantis_60fps")
            local time = 60
            local trapActivated = false
            local trap = ents.Create("prop_physics")
            trap:SetModel("models/hunter/plates/plate.mdl")
            trap:SetPos(ply:GetPos() + Vector(0, 0, 10))
            trap:SetAngles(Angle(0, math.random(0, 360), 0))
            trap:Spawn()
            trap:SetMoveType(MOVETYPE_NONE)
            trap:SetCollisionGroup(COLLISION_GROUP_WORLD)
            trap:SetRenderMode(RENDERMODE_TRANSCOLOR)
            trap:SetColor(Color(0, 0, 0, 0))
            local radius = 100
            local slowDuration = 3
            local blockDuration = 1.5
            local particleTimer
    
            local function startParticles()
                particleTimer = timer.Create("TrapParticleEffect", 0.5, time * 2, function()
                    if IsValid(trap) then
                        ParticleEffect("bo3_zodsword_slam_sparks", trap:GetPos(), trap:GetAngles())
                    else
                        timer.Remove("TrapParticleEffect")
                    end
                end)
            end
            local function CheckActivation()
                if trapActivated then return end
                for _, v in ipairs(ents.FindInSphere(trap:GetPos(), radius)) do
                    if v:IsNPC() or v:IsNextBot() then
                        v:TakeDamage(300 + ply:GetActiveWeapon().BonusDegats, ply)
                        ParticleEffect("bo3_zodsword_slam", trap:GetPos(), trap:GetAngles())
                        ply:EmitSound("bow/trap.wav")
                        trapActivated = true
                        trap:Remove()
                    end
                    if v:IsPlayer() and v != ply then
                        ParticleEffect("bo3_zodsword_slam", trap:GetPos(), trap:GetAngles())
                        trapActivated = true
                        ply:EmitSound("bow/trap.wav")
                        trap:Remove()
                        local origWalkSpeed = v:GetWalkSpeed()
                        local origRunSpeed = v:GetRunSpeed()
                        v:SetWalkSpeed(origWalkSpeed * 0.5)
                        v:SetRunSpeed(origRunSpeed * 0.5)
                        local originalWeapon = v:GetActiveWeapon()
                        local noWeapon = ents.Create("weapon_empty")
                        v:Give("weapon_empty")
                        v:SetActiveWeapon(noWeapon)
                        timer.Simple(blockDuration, function()
                            if IsValid(v) then
                                v:StripWeapon("weapon_empty")
                                if IsValid(originalWeapon) then
                                    v:Give(originalWeapon:GetClass())
                                    v:SetActiveWeapon(originalWeapon)
                                end
                            end
                        end)
                        timer.Simple(slowDuration, function()
                            if IsValid(ply) then
                                v:SetWalkSpeed(origWalkSpeed)
                                v:SetRunSpeed(origRunSpeed)
                            end
                        end)
                    end
                end
            end
    
            local checkTimer = timer.Create("TrapCheckTimer", 1, time, function()
                CheckActivation()
            end)
    
            timer.Simple(time, function()
                if IsValid(trap) and not trapActivated then
                    trap:Remove()
                    if particleTimer then
                        timer.Remove("TrapParticleEffect")
                    end
                    if checkTimer then
                        timer.Remove("TrapCheckTimer")
                    end
                end
            end)
    
            startParticles()
        end,
    },
    
    ["archer6"] = {
        stam = 12,
        name = "Souffle de la Tempête",
        level = 30,
        icon = "mad_sololeveling/skills/icons/magie10.png",
        classe = "archer",
        coldown = 2,
        type = "bow",
        ismagie = false,
        element = "none",
        code = function(ply)
            if IsValid(ply) then
                ply.archerBuff = true
                local time = 5
                timer_Simple(0.05, function() ply:SetFOV(100, 0.3) end)
                timer_Simple(5.0, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)
                local origWalkSpeed = ply:GetWalkSpeed()
                local origRunSpeed = ply:GetRunSpeed()
                local origJumpPower = ply:GetJumpPower()
                ply:SetWalkSpeed(origWalkSpeed * 1.25)
                ply:SetRunSpeed(origRunSpeed * 1.25)
                ply:SetJumpPower(origJumpPower * 1.5)
                timer.Simple(time, function()
                    if IsValid(ply) then
                        ply:SetWalkSpeed(origWalkSpeed)
                        ply:SetRunSpeed(origRunSpeed - 5)
                        ply:SetJumpPower(origJumpPower)
                    end
                end)		
                ply:EmitSound("bow/qwesawq.mp3")

                local particleTimer
    
                local function startParticlBuff()
                    particleTimer = timer.Create("BuffArcherParticleEffect", 0.5, 1, function()
                        if IsValid(ply) then
                            ParticleEffectAttach("[4]bfg_rnd", PATTACH_ABSORIGIN_FOLLOW, ply, 0)

                        else
                            timer.Remove("BuffArcherParticleEffect")
                        end
                    end)
                end
                local function stopParticleBuff()
                    if IsValid(ply) then
                        ply:StopParticles()
                    end
                end
                timer.Simple(time, function()
                    if IsValid(ply) then
                        stopParticleBuff()
                        ply.archerBuff = false
                    end
                end)
                startParticlBuff()

            end
    

            
        end,
    },
    
    ["archer7"] = {
        stam = 12,
        name = "Lames de l’Ouragan",
        level = 35,
        icon = "mad_sololeveling/skills/icons/a (158).png",
        classe = "archer",
        coldown = 2,
        type = "bow",
        ismagie = false,
        element = "none",
        code = function(ply)
            ply:SetVelocity(Vector(0, 0, 650))

            ply:EmitSound(swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)

            local effectdata = EffectData()
            effectdata:SetOrigin(ply:GetPos())
            effectdata:SetEntity(ply)
            util.Effect("sl_effect4", effectdata, true, true)

            timer_Simple(0.05, function() ply:SetFOV(90, 0.3) end)
            timer_Simple(0.15, function() ply:SetFOV(ply:GetNWInt("FOV"), 0.5) end)

            timer_Simple(0.001, function()
                ParticleEffect("dust_block", ply:GetPos(), ply:GetAngles(), ply)
                ParticleEffect("[20]_beast_feeling", ply:GetPos(), ply:GetAngles(), ply)
                util.ScreenShake(ply:GetPos(), 3, 50, 0.5, 150)
            end)

            timer_Simple(0.6, function() 
                ply:SetMoveType(MOVETYPE_NONE)
                ply:Mad_SetAnim("mad_soryu6emeattaque")
                ply:ViewPunch(Angle(0, 0, 10)) 

                ParticleEffectAttach("[1]_several_cuts_parent_wind_add", PATTACH_POINT_FOLLOW, ply, ply:LookupAttachment("anim_attachment_LH"))
                ParticleEffectAttach("[1]_several_cuts_parent_wind_add", PATTACH_POINT_FOLLOW, ply, ply:LookupAttachment("anim_attachment_RH"))

                timer_Simple(0.2, function()
                    local eyeAngles = ply:EyeAngles()
                    local forward = eyeAngles:Forward()
                    ParticleEffect("[1]_front_blade_wind_add", ply:GetPos(), eyeAngles, ply)
                    ParticleEffect("[1]_front_blade_wind_add", ply:GetPos() + forward * 150, eyeAngles, ply)
                end)
            end)

            timer_Simple(1.2, function()
                ply:StopParticles()
                ply:SetMoveType(MOVETYPE_WALK)

                ply:EmitSound("mad_sfx_sololeveling/normal/Punch_Explosion_02.ogg", 105, math.random(70, 130), 0.8, CHAN_AUTO)
                ply:EmitSound(swing_attack[math.random(1,3)], 75, math.random(70, 130), 0.8, CHAN_AUTO)

                local eyeAngles = ply:EyeAngles()
                local forward = eyeAngles:Forward()

                for i=1,5 do
                    local particlePos = ply:GetPos() + forward * 110 * i
                    ParticleEffect("[1]_front_blade_wind_add", particlePos, eyeAngles)
                    util.ScreenShake(particlePos, 3, 50, 0.5, 250)
                end

                ply:ViewPunch(Angle(0, 0, 30))
                local pos = ply:GetShootPos()
                local aim = ply:GetAimVector()
                local vector = 850  
                local radius = 200  

                local slash = {}
                slash.start = ply:GetShootPos()
                slash.endpos = ply:GetShootPos() + (ply:GetAimVector() * vector)
                slash.filter = ply
                slash.mins = Vector(-radius, -radius, 0)
                slash.maxs = Vector(radius, radius, 0)
                local tr = util.TraceHull(slash)

                if tr.Hit then
                    if IsValid(tr.Entity) and tr.Entity:GetClass() != "mad_crystal" then
                        if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot() then
                            ParticleEffectAttach("[3]_buff_aura", 4, tr.Entity, 0)

                            local maxHealth = tr.Entity:GetMaxHealth()
                            local damagePerTick = math.ceil(maxHealth * 0.005)

                            timer.Create("PoisonDamageAssassin8" .. ply:SteamID64(), 0.5, 10, function()
                                if IsValid(tr.Entity) and (tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsNextBot()) then
                                    tr.Entity:TakeDamage(damagePerTick, ply)
                                end
                            end)

                            timer.Simple(5, function()
                                if IsValid(tr.Entity) then
                                    tr.Entity:StopParticles()
                                end
                            end)

                            if tr.Entity:IsPlayer() then
                                local originalSpeed = tr.Entity:GetWalkSpeed()
                                tr.Entity:SetWalkSpeed(originalSpeed * 0.6)
                                timer.Simple(5, function()
                                    if IsValid(tr.Entity) then
                                        tr.Entity:SetWalkSpeed(originalSpeed)
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
        end,

    },
}