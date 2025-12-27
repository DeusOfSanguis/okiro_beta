-- Nom du module et informations
sam.command.set_category("Admin")

sam.command.new("spectate")
    :SetPermission("spectate", "admin") -- Définit qui peut utiliser la commande (ici les admins)
    :AddArg("player", {optional = true}) -- Option pour spectate un autre joueur
    :Help("Mettre en mode spectateur un joueur.")
    :OnExecute(function(ply, target)
        if not IsValid(target) then
            target = ply -- Si pas de cible, le joueur devient spectateur
        end
        
        if not ply.sam_spectating then
            ply:Spectate(OBS_MODE_ROAMING) -- Mode spectateur libre
            ply:SpectateEntity(target) -- Spectate un joueur en particulier si spécifié
            ply.sam_spectating = true
            ply:ChatPrint("Vous êtes maintenant en mode spectateur.")
        else
            ply:UnSpectate() -- Quitte le mode spectateur
            ply.sam_spectating = false
            ply:ChatPrint("Vous avez quitté le mode spectateur.")
        end
    end)
:End()
