sam.command.set_category("Okiro")




------------------------ HP ------------------------

sam.command.new("setmaxhp")
    :SetPermission("setmaxhp", "admin")
    :AddArg("player", { single_target = true })
    :AddArg("number", { hint = "HP", min = 1, round = true })
    :Help("Ajoute un niveau à un joueur.")
    :OnExecute(function(ply, target, hp)
        local tg = target[1] or target

        if not hp or hp < 1 then
            ply:sam_send_message("HP invalide !")
            return
        end
        if not IsValid(tg) or tg.DarkRPUnInitialized then
            ply:sam_send_message("Cible invalide !")
            return
        end

        tg:SetMaxHealth(hp)
        tg:SetHealth(hp)
        tg:ChatPrint(ply:Nick() .. " vous a mis le nombre de HP max à " .. hp)
        ply:sam_send_message("{A} a mis {V} de HP max à {T}", {
            A = ply, T = {tg}, V = hp 
        })
    end)
:End()





------------------------ XP ------------------------

sam.command.new("addxp")
    :SetPermission("addxp", "admin")
    :AddArg("player", { single_target = true })
    :AddArg("number", { hint = "XP", min = 0, round = true })
    :Help("Ajoute XP à un joueur.")
    :OnExecute(function(ply, target, amount)
        local tg = target[1] or target  

        if not amount or amount <= 0 then
            ply:sam_send_message("XP invalide !")
            return
        end
        if not IsValid(tg) or tg.DarkRPUnInitialized then
            ply:sam_send_message("Cible invalide !")
            return
        end

        tg:addXP(amount, true)
        tg:ChatPrint(ply:Nick() .. " vous a ajouté " .. amount .. " XP")
        ply:sam_send_message("{A} a ajouté {V} XP à {T}", {
            A = ply, T = {tg}, V = amount  
        })

        print(ply)
    end)
:End()

sam.command.new("setxp")
    :SetPermission("setxp", "admin")
    :AddArg("player", { single_target = true })
    :AddArg("number", { hint = "XP", min = 0, round = true })
    :Help("Met un nombre d'XP à un joueur.")
    :OnExecute(function(ply, target, amount)
        local tg = target[1] or target

        if not amount or amount <= 0 then
            ply:sam_send_message("XP invalide !")
            return
        end
        if not IsValid(tg) or tg.DarkRPUnInitialized then
            ply:sam_send_message("Cible invalide !")
            return
        end

        tg:setXP(amount, true)
        tg:ChatPrint(ply:Nick() .. " vous a mis " .. amount .. " XP")
        ply:sam_send_message("{A} a mis {V} XP à {T}", {
            A = ply, T = {tg}, V = amount  
        })
    end)
:End()




------------------------ Level ------------------------

sam.command.new("setlevel")
    :SetPermission("setlevel", "admin")
    :AddArg("player", { single_target = true })
    :AddArg("number", { hint = "Niveau", min = 1, round = true })
    :Help("Met un niveau à un joueur.")
    :OnExecute(function(ply, target, level)
        local tg = target[1] or target

        if not level or level < 1 then
            ply:sam_send_message("Niveau invalide !")
            return
        end
        if not IsValid(tg) or tg.DarkRPUnInitialized then
            ply:sam_send_message("Cible invalide !")
            return
        end

        if level >= 99 then
            level = 99
        end

        tg:setLevel(level, 0)
        tg:ChatPrint(ply:Nick() .. " a mis votre niveau à " .. level)
        ply:sam_send_message("{A} a mis {V} niveau(x) à {T}", {
            A = ply, T = {tg}, V = level 
        })
    end)
:End()

sam.command.new("addlevel")
    :SetPermission("addlevel", "admin")
    :AddArg("player", { single_target = true })
    :AddArg("number", { hint = "Niveau", min = 1, round = true })
    :Help("Ajoute un niveau à un joueur.")
    :OnExecute(function(ply, target, level)
        local tg = target[1] or target

        if not level or level < 1 then
            ply:sam_send_message("Niveau invalide !")
            return
        end
        if not IsValid(tg) or tg.DarkRPUnInitialized then
            ply:sam_send_message("Cible invalide !")
            return
        end

        if level >= 99 then
            level = 99
        end

        tg:addLevels(level, 0)
        tg:ChatPrint(ply:Nick() .. " vous a ajouté " .. level .. " niveau(s)")
        ply:sam_send_message("{A} a ajouté {V} niveau(x) à {T}", {
            A = ply, T = {tg}, V = level 
        })
    end)
:End()




------------------------ Mana ------------------------

sam.command.new("setmana")
    :SetPermission("setmana", "admin")
    :AddArg("player", { single_target = true })
    :AddArg("number", { hint = "Mana", min = 1, round = true })
    :Help("Met un niveau à un joueur.")
    :OnExecute(function(ply, target, mana)
        local tg = target[1] or target

        if not mana or mana < 1 then
            ply:sam_send_message("Niveau invalide !")
            return
        end
        if not IsValid(tg) or tg.DarkRPUnInitialized then
            ply:sam_send_message("Cible invalide !")
            return
        end

        tg:SetNWInt("mana", mana)
        tg:SetNWInt("mad_stamina", mana)
        tg:ChatPrint(ply:Nick() .. " a mis votre mana à " .. mana)
        ply:sam_send_message("{A} a mis {V} de mana à {T}", {
            A = ply, T = {tg}, V = mana 
        })
    end)
:End()

sam.command.new("addmana")
    :SetPermission("addmana", "admin")
    :AddArg("player", { single_target = true })
    :AddArg("number", { hint = "Mana", min = 1, round = true })
    :Help("Ajoute un niveau à un joueur.")
    :OnExecute(function(ply, target, mana)
        local tg = target[1] or target

        if not mana or mana < 1 then
            ply:sam_send_message("Niveau invalide !")
            return
        end
        if not IsValid(tg) or tg.DarkRPUnInitialized then
            ply:sam_send_message("Cible invalide !")
            return
        end

        local stam = tg:GetNWInt("mad_stamina")
        
        tg:SetNWInt("mad_stamina", stam + mana)
        tg:ChatPrint(ply:Nick() .. " vous a ajouté " .. mana .. " de mana")
        ply:sam_send_message("{A} a ajouté {V} de mana à {T}", {
            A = ply, T = {tg}, V = mana 
        })
    end)
:End()