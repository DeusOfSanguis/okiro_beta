--[[
-----------------------------------------------------------
                    Informations
-----------------------------------------------------------
Ce fichier provient du site web https://aide-serveur.fr/ et a été publié et créé par Autorun__.
Toute forme de revente, de republication, d'envoi à des tiers, etc. est strictement interdite, car cet addon est payant.
Discord : Autorun__
Serveur Discord : Discord.gg/GgH8eKmFpt
-----------------------------------------------------------
--]]

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(TaxiTeleportConfig.EntityModel)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    self.lastUseTime = 0
    self.useCooldown = 2 -- Cooldown de 2 secondes
end

function ENT:Use(activator, caller)
    if not activator:IsPlayer() then return end

    local currentTime = CurTime()
    if (currentTime - self.lastUseTime) < self.useCooldown then
        return
    end

    self.lastUseTime = currentTime

    net.Start("OpenTaxiMenu")
    net.Send(activator)
end
