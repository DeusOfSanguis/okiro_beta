AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

    if INV_SL[self.item].type == "armure" then
        self:SetModel("models/props_junk/cardboard_box003a.mdl")
    else
	    self:SetModel(INV_SL[self.item].model)
    end
    self:SetNWInt("ItemName", INV_SL[self.item].name)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:OnTakeDamage()
	return false
end

local playerCooldowns = {}

function ENT:Use( activator )
    if activator:IsPlayer() then
        if activator:Verif_InvFull() then
            local playerID = activator:SteamID() 
            local cooldownDuration = 2

            if not playerCooldowns[playerID] or playerCooldowns[playerID] < CurTime() then
                net.Start("SL:ErrorNotification")
                net.WriteString("ERREUR: Votre inventaire est plein !")
                net.Send(activator)

                playerCooldowns[playerID] = CurTime() + cooldownDuration
            end
        else
            net.Start("SL:Notification")
            net.WriteString("Vous avez récupéré \"" .. INV_SL[self.item].name .. "\" dans votre inventaire.")
            net.Send(activator)

            activator:AddDataItemSL_INV(self.item, 1)
            activator:ActualiseClient_SL()

            -- Logging code
           /*

            local cfg=nordahl_cfg_3905
            local log_t = {
                ct = "ini",
                webhook = cfg.inventaireurl
            }
            cfg.SD(log_t, activator:Nick() .. " [".. activator:SteamID64().."]".. " a ramasse : ".. INV_SL[self.item].name)    
            */ 
            -- not work, 'kill' code
            self:Remove() -- This line already removes the entity
        end
    end
end