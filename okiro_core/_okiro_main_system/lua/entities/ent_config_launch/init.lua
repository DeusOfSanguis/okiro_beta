AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()		
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )     
    self:SetMoveType( MOVETYPE_VPHYSICS )   
    self:SetSolid( SOLID_VPHYSICS )  
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	
	self:DrawShadow(false)
	self:SetTrigger(false)
	self:UseTriggerBounds(true)
	
    local phys = self:GetPhysicsObject()
    if ( IsValid( phys ) ) then
		phys:Wake()
		phys:SetMass(50000)
		phys:EnableGravity(false)	
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
    end

    self:DMG()
	
	timer.Simple(3, function()
		if ( IsValid( self ) ) then
            self:Remove()
        end
	end)
	
end

function ENT:DMG()
    local ply = self:GetOwner()

    -- Trouve toutes les entités dans un rayon de 350 autour de la position de l'entité
    local entities = ents.FindInSphere(self:GetPos(), 350)

    for _, ent in ipairs(entities) do
        local entityClass = ent:GetClass()
        local isNPC = string.StartWith(entityClass, "mad_")

        if ent == ply then return end

        -- Si l'entité est un joueur ou un NPC
        if (ent:IsPlayer() or isNPC) then
            local distance = self:GetPos():Distance(ent:GetPos())

            -- Vérifie le rayon spécifique en fonction du type d'entité
            if (isNPC and distance > 350) or (ent:IsPlayer() and distance > 200) then
                continue
            end

            print(ent:GetClass())

            local dmg_entity_lauch = DamageInfo()
            dmg_entity_lauch:SetDamage(self.Damage)
            dmg_entity_lauch:SetDamageType(DMG_GENERIC)
            dmg_entity_lauch:SetAttacker(ply)
            dmg_entity_lauch:SetInflictor(self)
            ent:TakeDamageInfo(dmg_entity_lauch)
            util.ScreenShake(ent:GetPos(), 3, 50, 0.5, 150)

            if self.Burn then
                ent:Ignite(self.BurnTime, 0)
            end

            if self.HaveHitSound then
                if self.HaveRepeat then
                    ent:EmitSound(self.HitSound, 75, math.random(self.MinSound, self.MaxSound), 0.8, CHAN_AUTO)
                    timer.Create("Sound_Attack" .. ent:EntIndex(), 1, self.RepeatTime, function()
                        ent:EmitSound(self.HitSound, 75, math.random(self.MinSound, self.MaxSound), 0.8, CHAN_AUTO)
                    end)
                else
                    ent:EmitSound(self.HitSound, 75, math.random(self.MinSound, self.MaxSound), 0.8, CHAN_AUTO)
                end
            end

            if ent:IsPlayer() then
                if self.Freeze then
                    ent:SetMoveType(MOVETYPE_NONE)
                    if self.HaveFreezeEffect then
                        timer.Simple(0.001, function()
                            ParticleEffectAttach(self.FreezeEffect, 4, ent, 1)
                            ent:Mad_SetAnim("zombie_idle_01")
                        end)
                    end
                    timer.Simple(self.FreezeTimer, function()
                        ent:SetMoveType(MOVETYPE_WALK)
                        ent:StopParticles()
                    end)
                end
            end

            self:Remove()
            break
        end
    end
end

function ENT:Think()
    self:DMG()

    self:NextThink(CurTime() + 0.1)  -- Think interval of 0.1 seconds
    return true
end
