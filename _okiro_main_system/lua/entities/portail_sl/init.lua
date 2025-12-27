AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/hunter/blocks/cube4x4x4.mdl")
    self:SetMoveType(MOVETYPE_NONE)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetRenderMode(RENDERMODE_TRANSCOLOR)
    self:SetColor(Color(0, 0, 0, 0))

    self.rdmportail = self.rdmportail or tirerAuSortPortail()
    self.rangportail = PORTAIL_SL[self.rdmportail].rang

    self:SetNWInt("Portail", self.rdmportail)
    self:SetNWInt("Rang", self.rangportail)

    self.ouvert = false

    print("Portail sélectionné :", self.rdmportail)

    for k, v in pairs(player.GetAll()) do
        if v:HasWeapon("mad_asso_detecteur") then
            net.Start("SL:Notification")
            net.WriteString("Un portail est apparu !")
            net.Send(v)
        end
    end

    self.portail_retour = ents.Create("retour_portail_sl")
    self.portail_retour:SetPos(Vector(PORTAIL_SL[self.rdmportail].portail_retour_pos))
    self.portail_retour:Spawn()

    bossEntities = {}
    mobsEntities = {}

    local spawnPositions = {
        Vector(PORTAIL_SL[self.rdmportail].mob_spawn1_pos),
        Vector(PORTAIL_SL[self.rdmportail].mob_spawn2_pos),
        Vector(PORTAIL_SL[self.rdmportail].mob_spawn3_pos),
        Vector(PORTAIL_SL[self.rdmportail].mob_spawn4_pos),
        Vector(PORTAIL_SL[self.rdmportail].mob_spawn5_pos),
        Vector(PORTAIL_SL[self.rdmportail].mob_spawn6_pos),
        Vector(PORTAIL_SL[self.rdmportail].mob_spawn7_pos)
    }

    local spawnIndex = 1  -- Index pour suivre quelle position utiliser

    for mobType, mobCount in pairs(PORTAIL_SL[self.rdmportail]["mob_in"]) do
        for i = 1, mobCount do
            local newMobEntity = ents.Create(mobType)

            local spawnPosition
            if mobType:find("boss") or mobType == "npc_loupevo2" or mobType == "npc_goblin_mage" then
                spawnPosition = Vector(PORTAIL_SL[self.rdmportail].boss_spawn_pos)  -- Boss à sa position spécifique
            else
                spawnPosition = spawnPositions[spawnIndex]  -- Utiliser une position unique
                spawnIndex = spawnIndex + 1  -- Incrémenter l'index de spawn
                if spawnIndex > #spawnPositions then spawnIndex = 1 end  -- Réinitialiser si on dépasse le nombre de positions
            end

            newMobEntity:SetPos(spawnPosition)
            newMobEntity:Spawn()

            if mobType:find("boss") or mobType == "npc_loupevo2" or mobType == "npc_goblin_mage" then
                table.insert(bossEntities, newMobEntity)
            end

            table.insert(mobsEntities, newMobEntity)
        end
    end

    -- Fonctionnalités pour vérifier la mort des mobs et nettoyer
    local function CheckBossDead()
        for _, mob in pairs(bossEntities) do
            if IsValid(mob) then
                return false
            end
        end
        return true
    end

    -- Générer un nom de hook unique
    local hookName = "CheckDungeonBossDead_" .. tostring(CurTime()) .. "_" .. tostring(self:GetPos())

    -- Hook pour vérifier les morts d'entités
    hook.Add("EntityRemoved", hookName, function(entity)

        if table.HasValue(mobsEntities, entity) then
            table.RemoveByValue(mobsEntities, entity)
        end

        if table.HasValue(bossEntities, entity) then
            
            for _, v in pairs(bossEntities) do
                for _, p in pairs(ents.FindInSphere(v:GetPos(), 1000)) do
                    if p:IsPlayer() then
                        net.Start("SL:Notification")
                        net.WriteString("Le portail va se fermer dans 120 s")
                        net.Send(p)
                    end
                end
            end
            
            table.RemoveByValue(bossEntities, entity)
            if CheckBossDead() then
                if IsValid(self) then
                    timer.Simple(120, function()
                        if IsValid(self) then
                            for _, v in pairs(mobsEntities) do
                                if IsValid(v) then v:Remove() end
                            end
                            hook.Remove("EntityRemoved", hookName)
                            print("Portail terminé !")
                            self:Remove()
                        end
                    end)
                end
            end
        end
    end)

    // timer.Simple(MADSL_TIMER_PORTAIL, function()
    //     if IsValid(self) then
    //         for _, v in pairs(mobsEntities) do
    //             if IsValid(v) then v:Remove() end
    //         end
    //         self:Remove()
    //     end
    //     hook.Remove("OnNPCKilled", hookName)
    // end)

    local physObj = self:GetPhysicsObject()
    if IsValid(physObj) then
        physObj:EnableMotion(false)
    end
end

function ENT:OnTakeDamage()
    return false
end

function ENT:Use(activator)
    if activator.timeStamp == nil or CurTime() >= activator.timeStamp + 5 then
        if self.ouvert == true then
            if activator:IsPlayer() then
                local calcultest = self:GetPos() + activator:GetAimVector() * -500
                print(calcultest)
                activator:SetNWInt("Teleport_Pos_Return", calcultest)
                activator:SetPos(Vector(PORTAIL_SL[self.rdmportail].pos_in))
            end
        else
            activator:ChatPrint("Le portail est fermé.")
        end
        activator.timeStamp = CurTime()
    end
end

local function RemovePortailRetour(self)
    if IsValid(self.portail_retour) then
        self.portail_retour:Remove()

        for _, v in pairs(mobsEntities) do
            if IsValid(v) then v:Remove() end
        end
        
    end
end

function ENT:OnRemove()
    RemovePortailRetour(self)
end

concommand.Add("remove_dungeon_hooks", function(ply, cmd, args)
    if not ply:IsAdmin() then
        ply:ChatPrint("Vous devez être un administrateur pour exécuter cette commande.")
        return
    end

    local count = 0
    for hookName, _ in pairs(hook.GetTable()["OnNPCKilled"] or {}) do
        if string.StartWith(hookName, "CheckDungeonMobsDead_") then
            hook.Remove("OnNPCKilled", hookName)
            count = count + 1
            print("Hook supprimé : " .. hookName)
        end
    end

    if count > 0 then
        ply:ChatPrint(count .. " hooks supprimés.")
    else
        ply:ChatPrint("Aucun hook trouvé avec le préfixe CheckDungeonMobsDead_.")
    end
end)