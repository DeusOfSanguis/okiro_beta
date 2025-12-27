AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

-- Fonction d'utilisation
function ENT:Use(activator)
    if activator:IsPlayer() then
        -- Vérifie si le joueur est de la classe "porteur"
        if activator:GetNWInt("Classe") == "porteur" then
            -- Vérifie si l'entité n'est pas déjà en train de traiter une action
            if not self:GetNWBool("Processing") then
                local lastUsed = activator:GetNWInt("Minerai_LastUse", 0)
                local currentTime = CurTime()

                -- Vérifie le cooldown
                if currentTime - lastUsed < 2 then
                    activator:ChatPrint("Vous devez attendre avant de réutiliser le minerai.")
                    return
                end

                -- Met à jour le temps de la dernière utilisation
                activator:SetNWInt("Minerai_LastUse", currentTime)

                -- Marque que l'entité commence à traiter une action
                self:SetNWBool("Processing", true)
                -- Marque le joueur comme actif
                activator:SetNWEntity("CurrentMinerai", self)
                
                -- Envoie un message de début de traitement
                activator:ChatPrint("Vous avez commencé à extraire le minerai. Restez à proximité pendant 20 secondes.")

                -- Lance un timer pour gérer le processus
                local processingTime = 20
                timer.Create("MineraiProcessing_" .. self:EntIndex(), 1, processingTime, function()
                    -- Calcule le temps restant
                    local timeLeft = processingTime - 20 + timer.RepsLeft("MineraiProcessing_" .. self:EntIndex())

                    -- Debug: Vérifie si le timer est toujours actif
                    if not timer.Exists("MineraiProcessing_" .. self:EntIndex()) then
                        print("Timer non trouvé!")
                        return
                    end

                    -- Vérifie si le joueur est toujours à proximité
                    if activator:GetPos():DistToSqr(self:GetPos()) < 500^2 then
                        -- Affiche le temps restant
                        activator:ChatPrint("Temps restant : " .. timeLeft .. " secondes.")
                    else
                        -- Annule l'action si le joueur s'éloigne
                        if IsValid(activator) then
                            activator:ChatPrint("Vous vous êtes éloigné. L'extraction a échoué.")
                            activator:SetNWEntity("CurrentMinerai", nil)
                        end
                        -- Marque que l'entité a terminé le traitement
                        self:SetNWBool("Processing", false)
                        timer.Remove("MineraiProcessing_" .. self:EntIndex())
                        return
                    end

                    -- Si le temps est écoulé
                    if timeLeft <= 0 then
                        -- Rend l'entité invisible
                        self:SetNoDraw(true)
                        -- Informe le joueur
                        activator:ChatPrint("Extraction réussie ! L'entité est maintenant invisible pendant 10 minutes.")
                        
                        activator:AddDataCrystauxSL_INV("minerai", 1)
                        
                        -- Définir un autre timer pour la réapparition de l'entité
                        timer.Create("MineraiReappear_" .. self:EntIndex(), 600, 1, function()
                            if IsValid(self) then
                                self:SetNoDraw(false)
                                -- Informe le joueur
                                -- Marque que l'entité a terminé le traitement
                                self:SetNWBool("Processing", false)
                                -- Réinitialise le joueur actif
                                activator:SetNWEntity("CurrentMinerai", nil)
                            end
                        end)
                        
                        -- Marque que l'entité a terminé le traitement
                        self:SetNWBool("Processing", false)
                        -- Réinitialise le joueur actif
                        activator:SetNWEntity("CurrentMinerai", nil)
                        timer.Remove("MineraiProcessing_" .. self:EntIndex())
                    end
                end)
            else
                -- Informe le joueur si l'entité est déjà en train de traiter
                activator:ChatPrint("Le minerai est déjà en cours d'extraction.")
            end
        else
            -- Informe le joueur si la classe n'est pas correcte
            activator:ChatPrint("Vous n'êtes pas de la classe requise pour utiliser ce minerai.")
        end
    end
end

-- Fonction d'initialisation de l'entité
function ENT:Initialize()
    -- Initialisation de l'entité
    self:SetModel("models/props_foliage/rock_coast02a.mdl")
    self:SetColor(Color(0, 161, 255, 255))
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetNWBool("Processing", false)
end

-- Fonction pour nettoyer les timers lors de la suppression de l'entité
function ENT:OnRemove()
    timer.Remove("MineraiProcessing_" .. self:EntIndex())
    timer.Remove("MineraiReappear_" .. self:EntIndex())
end
