util.AddNetworkString("SHAV:DiscordLogs")
util.AddNetworkString("SL:MainMenu")
util.AddNetworkString("SL:OpenInventaire")
util.AddNetworkString("SL:OpenShop")
util.AddNetworkString("SL:OpenSell")
util.AddNetworkString("SL:OpenClasseMenu") 
util.AddNetworkString("SL:OpenRangMenu")
util.AddNetworkString("SL:OpenSkillsMenu")
util.AddNetworkString("SL:OpenMagieMenu")
util.AddNetworkString("SL:OpenRevendeur")
util.AddNetworkString("SL:Notification")
util.AddNetworkString("SL:ErrorNotification")
util.AddNetworkString("SL:LevelNotification")
util.AddNetworkString("SL:Mad - Stats:Up")
util.AddNetworkString("SL:Mad - Stats:ResetStats")
util.AddNetworkString("SL:Mad - Classe:Start")
util.AddNetworkString("SL:Mad - Classe:Choix")
util.AddNetworkString("SL:Mad - Rang:Start")
util.AddNetworkString("SL:Mad - Magie:Start")
util.AddNetworkString("SL:Mad - Magie:Choisir")
util.AddNetworkString("SL:Mad - Shop:Acheter")
util.AddNetworkString("SL:Mad - Shop:Vendre")
util.AddNetworkString("SL:Mad - Shop:Revendre")
util.AddNetworkString("SL:Mad - Skills:Bind")
util.AddNetworkString("SL:Mad - Inv:EquipWeapon")
util.AddNetworkString("SL:Mad - Inv:DeEquipWeapon") 
util.AddNetworkString("SL:Mad - Inv:EquipArmure")
util.AddNetworkString("SL:Mad - Inv:DeEquipArmure")
util.AddNetworkString("SL:Mad - Inv:JeterItem")
util.AddNetworkString("SL:Mad - Admin:GiveItem")
util.AddNetworkString("SL:Mad - Admin:AddRerolls")
util.AddNetworkString("SL:Shavkat - Admin:GiveClasse")
util.AddNetworkString("SL:Shavkat - Admin:GiveMagie")
util.AddNetworkString("SL:Shavkat - Admin:GiveRang")
util.AddNetworkString("SL:Mad - Coiffeur:Menu")
util.AddNetworkString("SL:Mad - Coiffeur:Change")
util.AddNetworkString("SL:sendservertoclientdata")
util.AddNetworkString("SL:sendservertoclientdata_stats")
util.AddNetworkString("SL:sendservertoclientdata_rerolls")
util.AddNetworkString("SL:sendservertoclientdata_skills")
util.AddNetworkString("SL:sendservertoclientdata_classe")
util.AddNetworkString("SL:sendservertoclientdata_rang")
util.AddNetworkString("SL:sendservertoclientdata_magie")
util.AddNetworkString("SL:sendservertoclientdata_inv_equip")
util.AddNetworkString("SL:sendservertoclientdata_inv_banque")
util.AddNetworkString("SL:Portail:Teleport")
util.AddNetworkString("SL:Portail:Open")
util.AddNetworkString("SL:Portail:Close") 
util.AddNetworkString("SL:Portail:Delete")
util.AddNetworkString("SL:Portail:DungeonBreak")
util.AddNetworkString("SpawnPortal")
util.AddNetworkString("SL:Okiro:OpenGeneralMenu")
util.AddNetworkString("SL:Okiro:ThirdPerson")
util.AddNetworkString("SL:CloseMainMenu")

net.Receive( "SL:Mad - Coiffeur:Change", function( len, ply )

    if not ply:Team() == TEAM_COIFFEUR then return end

    if ply:getDarkRPVar("money") < 20000 then 
        net.Start("SL:ErrorNotification")
        net.WriteString("ОШИБКА: У вас нет денег на прическу." )
        net.Send(ply)
        return 
    end

    ply:addMoney(-20000)

    local cheveux = net.ReadFloat()

    local entity = net.ReadEntity()

    entity:GetDataSL_Chara(entity:GetNWInt("Slot_Choisis"))

    entity.data["sl_cheveux"] = cheveux

    file.Write("sl_data/" .. entity:SteamID64() .. "/" .. entity:GetNWInt("Slot_Choisis") .. "/chara.json", util.TableToJSON(entity.data))

    if entity.data.sl_genre == "male" then
        entity:SetBodygroup(3, cheveux)
    else
        entity:SetBodygroup(2, cheveux)
    end

    entity:ReloadDataSL_Chara()
end)

net.Receive( "SL:Portail:Teleport", function( len, ply )
    local portail = net.ReadEntity()

    if ( IsValid( ply ) and ply:IsPlayer() ) then


        ply:SetPos(portail:GetPos())

    end
end)

net.Receive( "SL:Portail:Open", function( len, ply )
    local portail = net.ReadEntity()

    if ( IsValid( ply ) and ply:IsPlayer() ) then


        portail.ouvert = true

    end
end)

net.Receive( "SL:Portail:Close", function( len, ply )
    local portail = net.ReadEntity()

    if ( IsValid( ply ) and ply:IsPlayer() ) then
        portail.ouvert = false
    end
end)

net.Receive( "SL:Portail:Delete", function( len, ply )
    local portail = net.ReadEntity()

    if ( IsValid( ply ) and ply:IsPlayer() ) then
        portail:Remove()
    end
end)

net.Receive( "SL:Portail:DungeonBreak", function( len, ply )
    local portail = net.ReadEntity()

    if ( IsValid( ply ) and ply:IsPlayer() ) then


        local dungeon_break_portail = ents.Create("portail_break_sl")
        dungeon_break_portail:SetPos(portail:GetPos()) 
        dungeon_break_portail:Spawn()
    
        portail:Remove()
    
        local startPos = portail:GetPos() + portail:GetForward() * 400
        local endPos = portail:GetPos() + portail:GetForward() * -400 + ply:GetUp() * 500
    
        local totalMobs = 0
        local mobEntities = {}

        for k,v in pairs(mobsEntities) do
            if IsValid(v) then
                v:Remove()
            end
        end
    
        for mobType, mobCount in pairs(PORTAIL_SL[portail.rdmportail]["mob_in"]) do
            totalMobs = totalMobs + mobCount
            for i = 1, mobCount do
                local mobSpawnPos = Vector(
                    math.random(startPos.x, endPos.x),
                    math.random(startPos.y, endPos.y),
                    math.random(startPos.z, endPos.z)
                )
                
                local newMobEntity = ents.Create(mobType)
                newMobEntity:SetPos(mobSpawnPos)
                newMobEntity:Spawn()
                
                table.insert(mobEntities, newMobEntity)
            end
        end
    
        local hookName = "CheckDungeonEntitiesDead_" .. tostring(CurTime()) .. "_" .. tostring(portail:GetPos())

        local function CheckAllEntitiesDead()
            for _, entity in pairs(mobEntities) do
                if IsValid(entity) then
                    return false
                end
            end
            return true
        end

        hook.Add("EntityRemoved", hookName, function(entity)
            if table.HasValue(mobEntities, entity) then
                table.RemoveByValue(mobEntities, entity)
                if CheckAllEntitiesDead() then
                    if IsValid(dungeon_break_portail) then
                        dungeon_break_portail:Remove()
                    end
                    hook.Remove("EntityRemoved", hookName)
                end
            end
        end)

    end
end)

net.Receive("SL:Mad - Admin:AddRerolls", function(len, ply)
    local entity = net.ReadEntity()
    local item = net.ReadString()
    local nombre = math.Round(net.ReadFloat())

    if (IsValid(ply) and ply:IsPlayer()) then
        if item == "Ajout de Reroll Magie" then
            entity:AddRerollMagie(nombre)
            SHAVDiscordLogs("givereroll", ply, entity, "x".. nombre .. " Reroll магии")
        elseif item == "Ajout de Reset Stats" then
            entity:AddResetStats(nombre)
            SHAVDiscordLogs("givereroll", ply, entity, "x".. nombre .. " Сброс статов")
        elseif item == "Ajout de Points statistiques" then
            entity:AddPts(nombre)
            SHAVDiscordLogs("givereroll", ply, entity, "x".. nombre .. " Очки статов")
        elseif item == "Ajout de Reroll Rang" then
            entity:AddRerollRang(nombre)
            SHAVDiscordLogs("givereroll", ply, entity, "x".. nombre .. " Reroll ранга")
        elseif item == "Ajout de Reroll Classe" then
            entity:AddRerollClasse(nombre)
            SHAVDiscordLogs("givereroll", ply, entity, "x".. nombre .. " Reroll класса")
        elseif item == "Suppression de Reroll Magie" then
            entity:RemoveRerollMagie(nombre)
            SHAVDiscordLogs("givereroll", ply, entity, "x".. nombre .. " Удаление Reroll магии")
        elseif item == "Suppression de Reset Stats" then
            entity:RemoveResetStats(nombre)
            SHAVDiscordLogs("givereroll", ply, entity, "x".. nombre .. " Удаление сброса статов")
        elseif item == "Suppression de Points statistiques" then
            entity:RemovePts(nombre)
            SHAVDiscordLogs("givereroll", ply, entity, "x".. nombre .. " Удаление очков статов")
        elseif item == "Suppression de Reroll Rang" then
            entity:RemoveRerollRang(nombre)
            SHAVDiscordLogs("givereroll", ply, entity, "x".. nombre .. " Удаление Reroll ранга")
        elseif item == "Suppression de Reroll Classe" then
            entity:RemoveRerollClasse(nombre)
            SHAVDiscordLogs("givereroll", ply, entity, "x".. nombre .. " Удаление Reroll класса")
        end
    end
end)
net.Receive("SL:Shavkat - Admin:GiveClasse", function(len, ply)
    local playerSteamID64 = net.ReadString()
    local player = player.GetBySteamID64(playerSteamID64)
    local classe = net.ReadString()
    
    if (IsValid(ply) and ply:IsPlayer()) then
        if player:IsPlayer() then
            local selectedClasse
            local selectedClasseData
            
            for classeName, classeData in pairs(CLASSES_SL) do
                if string.find(string.lower(classe), classeName) then
                    selectedClasse = classeName
                    selectedClasseData = classeData
        
                    if player:GetNWInt("Classe") == selectedClasse then
                        ply:ChatPrint("Этот игрок уже имеет данный класс!")
                        return
                    end
                end
            end

            file.Write("sl_data/" .. playerSteamID64 .. "/classe.json", selectedClasse)
            player:SetNWString("Classe", selectedClasse)
            ply:ChatPrint("Класс " .. classe .. " был выдан игроку " .. player:Nick() .. "!")
    
            SHAVDiscordLogs("giveclasse", ply, player, selectedClasse)

            player:ActualiseClient_SL()
        end
    end
end)

net.Receive("SL:Shavkat - Admin:GiveRang", function(len, ply)
    local playerSteamID64 = net.ReadString()
    local player = player.GetBySteamID64(playerSteamID64)
    local rang = net.ReadString()
    
    if (IsValid(ply) and ply:IsPlayer()) then
        if player:IsPlayer() then
            if player:GetNWInt("Rang") == rang then
                ply:ChatPrint("Этот игрок уже имеет данный ранг!")
                return
            end

            file.Write("sl_data/" .. playerSteamID64 .. "/rang.json", rang)
            player:SetNWString("Rang", rang)
            ply:ChatPrint("Ранг " .. rang .. " был выдан игроку " .. player:Nick() .. "!")
    
            SHAVDiscordLogs("giverang", ply, player, rang)

            player:ActualiseClient_SL()
        end
    end
end)

net.Receive("SL:Shavkat - Admin:GiveMagie", function(len, ply)
    local playerSteamID64 = net.ReadString()
    local player = player.GetBySteamID64(playerSteamID64)
    local magie = net.ReadString()
    
    if (IsValid(ply) and ply:IsPlayer()) then
        if player:IsPlayer() then
            local selectedMagie = magie
            local selectedMagieData = nil
            
            for magieName, magieData in pairs(MAGIE_SL) do
                if string.find(magie, magieData.name) then
                    selectedMagie = magieName
                    selectedMagieData = magieData
                    
                    player:ActualiseClient_SL()
                    if player:GetNWInt("Magie") == selectedMagie then
                        ply:ChatPrint("Этот игрок уже обладает данной магией!")
                        return
                    end
                end
            end
            
            file.Write("sl_data/" .. playerSteamID64 .. "/magie.json", selectedMagie)
            player:SetNWString("Magie", selectedMagie)
            ply:ChatPrint("Магия " .. magie .. " была выдана игроку " .. player:Nick() .. "!")
            
            SHAVDiscordLogs("givemagie", ply, player, selectedMagie)
            
            player:ActualiseClient_SL()
        end
    end
end)

net.Receive( "SL:Mad - Admin:GiveItem", function( len, ply )
    local entity = net.ReadString()
    local item = net.ReadString()

    local plyy = player.GetBySteamID64(entity)

    if ( IsValid( plyy ) and plyy:IsPlayer() ) then

        for k,v in pairs(INV_SL) do
            if string.find(item, v.name) and string.find(string.lower(item), v.classe) then
                plyy:AddDataItemSL_INV(k, 1)

                SHAVDiscordLogs("giveitem", ply, plyy, v.name)
                return
            end
        end
    end
end)

net.Receive("SL:Mad - Skills:Bind", function(len, ply)
    local num = net.ReadFloat()
    local id = net.ReadString()

    local allCooldownsZero = true
    for i = 1, 6 do
        if ply:GetNWInt("next_attaque"..i) - CurTime() > 0 then
            allCooldownsZero = false
            break
        end
    end

    if not allCooldownsZero then
        net.Start("SL:ErrorNotification")
        net.WriteString("ОШИБКА: Дождитесь завершения перезарядки перед изменением биндов.")
        net.Send(ply)
        return
    end

    if ply.sl_data4[id] < 1 then 
        ply:Kick("Анти-чит система: Попытка эксплуатации навыков (Вы не забанены, но находитесь под подозрением; случай 0 не существует)")
        return 
    end

    if num > 6 or num < 1 then
        ply:Kick("Анти-чит система: Попытка эксплуатации навыков (Вы не забанены, но находитесь под подозрением; случай 0 не существует)")
        return
    end

    for i = 1, 6 do
        local technique = ply:GetNWInt("Technique"..i)
        if technique == id then
            ply:SetNWInt("Technique"..i, 0)
            ply:Binds_Set_DATA("Technique"..i, 0)
        end
    end

    ply:SetNWInt("Technique"..num, id)
    ply:Binds_Set_DATA("Technique"..num, id)
end)

net.Receive("SL:Mad - Magie:Start", function(len, ply)

    if ( IsValid( ply ) and ply:IsPlayer() ) then

        if ply.sl_data3["magie"] < 1 then return end

        ply:ConCommand("reset_skills")

        ply:RemoveRerollMagie(1)

        ply:SetNWInt("Magie_Reroll", GetRandomMagieByRarity(GetRandomRarity_Magie()))

        net.Start( "SL:sendservertoclientdata_magie" )
        net.WriteString(ply:GetNWInt("Magie_Reroll"))
        net.Send(ply)

        if not file.Exists("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA") then
            file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", ply:GetNWInt("Magie_Reroll"))
        else
            file.Delete("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA")
            file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", ply:GetNWInt("Magie_Reroll"))
        end

        ply:SetNWInt("Magie", ply:GetNWInt("Magie_Reroll"))

    
        ply:ActualiseClient_SL()

    end

end)

net.Receive("SL:Mad - Magie:Choisir", function(len, ply)

    if (IsValid(ply) and ply:IsPlayer()) then

        if ply.sl_data3["magie"] < 1 then return end

        local magie_choisi = net.ReadString()
        if magie_choisi == "1" then
            ply:SetNWInt("Magie_Reroll", "feu")
        elseif magie_choisi == "2" then
            ply:SetNWInt("Magie_Reroll", "eau")
        elseif magie_choisi == "3" then
            ply:SetNWInt("Magie_Reroll", "terre")
        elseif magie_choisi == "4" then
            ply:SetNWInt("Magie_Reroll", "air")
        else 
            ply:Kick("Анти-чит система: Попытка эксплуатации выбора магии (Вы не забанены, но находитесь под подозрением; случай 0 не существует)") 
            return 
        end

        ply:ConCommand("reset_skills")

        ply:RemoveRerollMagie(1)

        if not file.Exists("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA") then
            file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", ply:GetNWInt("Magie_Reroll"))
        else
            file.Delete("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA")
            file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", ply:GetNWInt("Magie_Reroll"))
        end

        ply:SetNWInt("Magie", ply:GetNWInt("Magie_Reroll"))

        ply:ActualiseClient_SL()

    end

end)

net.Receive("SL:Mad - Rang:Start", function(len, ply)

    if ( IsValid( ply ) and ply:IsPlayer() ) then

        if ply.sl_data3["rang"] < 1 then return end

        ply:RemoveRerollRang(1)

        ply:SetNWInt("Rang_Reroll", RandomRang())

        net.Start( "SL:sendservertoclientdata_rang" )
        net.WriteString(ply:GetNWInt("Rang_Reroll"))
        net.Send(ply)

        if not file.Exists("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA") then
            file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", ply:GetNWInt("Rang_Reroll"))
        else
            file.Delete("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA")
            file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", ply:GetNWInt("Rang_Reroll"))
        end

        ply:SetNWInt("Rang", ply:GetNWInt("Rang_Reroll"))


        ply:ActualiseClient_SL()

    end

end)

net.Receive("SL:Mad - Classe:Start", function(len, ply)

    if ( IsValid( ply ) and ply:IsPlayer() ) then

        if ply.sl_data3["classe"] < 1 then return end

        ply:ConCommand("reset_skills")

        for k, v in pairs(ply.sl_data) do
            if ply.sl_data5[k] and ply.sl_data5[k] >= 1 then
                if INV_SL[k].type == "arme" then
                    ply.EquipWeapon = false
                    ply:SetNWInt("EquipWeapon", false)
                    ply:StripWeapon(INV_SL[k].swep) 
                elseif INV_SL[k].type == "armure" then
                    ply.EquipArmure = false
                    ply:SetNWInt("EquipArmure", false)
                    ply:SetModel(ply.AncienMdl)
                    ply:SetHealth(ply:Health() - INV_SL[k].boost_hp)
                    ply:SetMaxHealth(ply:GetMaxHealth() - INV_SL[k].boost_hp)
                end
            end
        end

        file.Write("sl_data/" .. ply:SteamID64() .. "/inv_equip.json", "{}")

        ply:RemoveRerollClasse(1)

        ply:SetNWInt("Classe1", GetRandomClassByRarity(GetRandomRarity()))
        ply:SetNWInt("Classe2", GetRandomClassByRarity(GetRandomRarity()))
        ply:SetNWInt("Classe3", GetRandomClassByRarity(GetRandomRarity()))

        net.Start( "SL:sendservertoclientdata_classe" )
        net.WriteString(ply:GetNWInt("Classe1"))
        net.WriteString(ply:GetNWInt("Classe2"))
        net.WriteString(ply:GetNWInt("Classe3"))
        net.Send(ply)
        
        ply:ActualiseClient_SL()

    end

end)

net.Receive("SL:Mad - Classe:Choix", function(len, ply)
    local choix = net.ReadFloat()

    if (IsValid(ply) and ply:IsPlayer()) then

        ply:ConCommand("reset_skills")

        if ply:GetNWInt("Classe1") == "" then ply:Kick("Анти-чит система: Попытка эксплуатации выбора класса (Вы не забанены, но находитесь под подозрением; случай 0 не существует)") return end
        if ply:GetNWInt("Classe2") == "" then ply:Kick("Анти-чит система: Попытка эксплуатации выбора класса (Вы не забанены, но находитесь под подозрением; случай 0 не существует)") return end
        if ply:GetNWInt("Classe3") == "" then ply:Kick("Анти-чит система: Попытка эксплуатации выбора класса (Вы не забанены, но находитесь под подозрением; случай 0 не существует)") return end

        file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", ply:GetNWInt("Classe1"))

        if choix == 1 then
            if not file.Exists("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA") then
                file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", ply:GetNWInt("Classe1"))
            else
                file.Delete("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA")
                file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", ply:GetNWInt("Classe1"))
            end
        elseif choix == 2 then
            if not file.Exists("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA") then
                file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", ply:GetNWInt("Classe2"))
            else
                file.Delete("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA")
                file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", ply:GetNWInt("Classe2"))
            end
        elseif choix == 3 then
            if not file.Exists("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA") then
                file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", ply:GetNWInt("Classe3"))
            else
                file.Delete("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA")
                file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", ply:GetNWInt("Classe3"))
            end
        end

        ply:SetNWInt("Classe1", "")
        ply:SetNWInt("Classe2", "")
        ply:SetNWInt("Classe3", "")

        ply:ActualiseClient_SL()

    end
end)

net.Receive( "SL:Mad - Shop:Acheter", function( len, ply )
    local achat_selected = net.ReadString()

    if ( IsValid( ply ) and ply:IsPlayer() ) then
        if ply:getDarkRPVar("money") < INV_SL[achat_selected].price then 
            net.Start("SL:ErrorNotification")
            net.WriteString("ОШИБКА: У вас недостаточно денег для покупки этого предмета.")
            net.Send(ply)
            return end

        if INV_SL[achat_selected].teambuy == true then
            if ply:Team() != INV_SL[achat_selected].theteam then
                return
            end
        end

        if INV_SL[achat_selected].isforaspecialclass == true then
            if ply:GetNWString("Classe") != INV_SL[achat_selected].classe then ply:Kick("Анти-эксплойт: Попытка эксплуатации магазина (Вы не забанены, но подозреваетесь; случай 0 не существует)") return end
        end

        if ply:Verif_InvFull() then
            net.Start("SL:ErrorNotification")
            net.WriteString("ОШИБКА: Ваш инвентарь переполнен.")
            net.Send(ply)
        else
            net.Start("SL:Notification")
            net.WriteString("Вы приобрели: ".. INV_SL[achat_selected].name)
            net.Send(ply)

            ply:AddDataItemSL_INV(achat_selected, 1)
            ply:addMoney(- INV_SL[achat_selected].price)

        end

    end

end)


net.Receive( "SL:Mad - Shop:Vendre", function( len, ply )
    local achat_selected = net.ReadString()

    local nombre = ply.sl_data[achat_selected]

    if not ply.sl_data[achat_selected] then 
        net.Start("SL:ErrorNotification")
        net.WriteString("ОШИБКА: У вас нет этого предмета.")
        net.Send(ply)
        return
    end

    if ( IsValid( ply ) and ply:IsPlayer() ) then
        
        ply:ChatPrint("Вы продали: ".. nombre .. " ".. INV_SL[achat_selected].name)

        net.Start("SL:Notification")
        net.WriteString("Вы продали: ".. nombre .. " ".. INV_SL[achat_selected].name)
        net.Send(ply)

        ply:SetDataItemSL_INV(achat_selected, 0)
        ply:addMoney(INV_SL[achat_selected].sellprice * nombre)
    end
end)

net.Receive( "SL:Mad - Shop:Revendre", function( len, ply )
    local achat_selected = net.ReadString()

    local nombre = ply.sl_data[achat_selected]

    if not ply.sl_data[achat_selected] then 
        net.Start("SL:ErrorNotification")
        net.WriteString("ОШИБКА: У вас нет этого предмета.")
        net.Send(ply)
        return 
    end

    if ( IsValid( ply ) and ply:IsPlayer() ) then
        net.Start("SL:Notification")
        net.WriteString("Вы продали: ".. nombre .. " ".. INV_SL[achat_selected].name)
        net.Send(ply)

        if ply:IsEquipped(achat_selected) then

            if INV_SL[achat_selected].type == "arme" then
                if ply.EquipWeapon == true then
                    ply:StripWeapon(INV_SL[achat_selected].swep)
                    ply.EquipWeapon = false
                    ply:SetNWInt("EquipWeapon", false)
                end
            elseif INV_SL[achat_selected].type == "armure" then
                if ply.EquipArmure == true then
                    ply.EquipArmure = false
                    ply:SetNWInt("EquipArmure", false)
                    ply:SetModel(ply.AncienMdl)
                    ply:SetMaxHealth(ply:GetMaxHealth() - INV_SL[achat_selected].boost_hp)
                    if ply:Health() >= ply:GetMaxHealth() + INV_SL[achat_selected].boost_hp then
                        ply:SetHealth(ply:GetMaxHealth())
                    end
                end
            end

        else

        end

        ply:SetDataItemSL_INV(achat_selected, 0)
        ply:SetDataItemSL_INV_EQUIP(achat_selected, 0)
        ply:addMoney((INV_SL[achat_selected].price * nombre) / 2)

    end

end)

net.Receive("SL:Mad - Stats:Up", function(len, ply)
    local stats = net.ReadString()

    if (IsValid(ply) and ply:IsPlayer()) then
        if ply.sl_data2["pts"] < 1 then return end

        if not (stats == "force" or stats == "agilite" or stats == "sens" or 
                stats == "vitalite" or stats == "intelligence") then
            ply:Kick("Античит система: Попытка эксплуатации характеристик (Вы не забанены, но подозрительны)")
            return 
        end
        
        local function ErrorMessage(message)
            net.Start("SL:ErrorNotification")
            net.WriteString("ОШИБКА: ".. message)
            net.Send(ply)
        end

        local rank = ply:GetNWInt("Rang")
        local currentValue = ply.sl_data2[stats]
        
        if rank == "E" and currentValue >= 10 then 
            ErrorMessage("Вы достигли лимита для вашего ранга (10/10).") 
            return 
        elseif rank == "D" and currentValue >= 15 then 
            ErrorMessage("Вы достигли лимита для вашего ранга (15/15).") 
            return
        elseif rank == "C" and currentValue >= 30 then 
            ErrorMessage("Вы достигли лимита для вашего ранга (30/30).") 
            return
        elseif rank == "B" and currentValue >= 40 then 
            ErrorMessage("Вы достигли лимита для вашего ранга (40/40).") 
            return
        elseif rank == "A" and currentValue >= 45 then 
            ErrorMessage("Вы достигли лимита для вашего ранга (45/45).") 
            return
        elseif rank == NULL and currentValue >= 5 then 
            ErrorMessage("Вы достигли базового лимита без ранга (5/5).") 
            return 
        end

        ply:AddCompetence(stats, 1)
        ply:RemovePts(1)

        if stats == "intelligence" then
            ply:SetNWInt("mana", 100 * ply.sl_data2["intelligence"])
            ply:SetNWInt("mad_stamina", ply:GetNWInt("mana"))
        end

        ply:ActualiseClient_SL()
    end
end)

net.Receive("SL:Mad - Stats:ResetStats", function(len, ply)
    if (IsValid(ply) and ply:IsPlayer()) then
        if ply.sl_data2["rerollstats"] < 1 then 
            net.Start("SL:ErrorNotification")
            net.WriteString("ОШИБКА: У вас нет Reset Stats!")
            net.Send(ply)
            return 
        end

        local save_points = ply.sl_data2["pts"] + 
                          ply.sl_data2["force"] + 
                          ply.sl_data2["agilite"] + 
                          ply.sl_data2["sens"] + 
                          ply.sl_data2["vitalite"] + 
                          ply.sl_data2["intelligence"] 
        
        local resetstatspoint = ply.sl_data2["rerollstats"]

        local sl_data2 = util.TableToJSON(initsl_data2)
        file.Write("sl_data/" .. ply:SteamID64() .. "/stats.json", sl_data2)

        ply:AddPts(save_points-5)
        
        ply:AddResetStats(resetstatspoint-1)

        ply:ActualiseClient_SL()
    end
end)

net.Receive("SL:Mad - Inv:DeEquipWeapon", function(len, ply)
    local inv_selected = net.ReadString()

    if (IsValid(ply) and ply:IsPlayer()) then
        if ply.sl_data[inv_selected] < 1 then 
            ply:Kick("Античит система: Попытка эксплуатации инвентаря (Вы не забанены, но подозрительны; случай 0 не существует)")
            return 
        end

        if INV_SL[inv_selected].type == "arme" then
            if ply.EquipWeapon == true then
                ply:AddDataItemSL_INV_EQUIP(inv_selected, 0)

                net.Start("SL:Notification")
                net.WriteString("Вы сняли: ".. INV_SL[inv_selected].name)
                net.Send(ply)

                ply:StripWeapon(INV_SL[inv_selected].swep)
                
                ply.EquipWeapon = false
                ply:SetNWInt("EquipWeapon", false)
                ply:SetNWString("CurrentWeapon", nil)
            else
                ply:ChatPrint("У вас нет экипированного оружия")
            end
        end
    end
end)

net.Receive("SL:Mad - Inv:EquipWeapon", function(len, ply)
    local inv_selected = net.ReadString()

    if (IsValid(ply) and ply:IsPlayer()) then
        if ply.sl_data[inv_selected] < 1 then 
            ply:Kick("Античит система: Попытка эксплуатации инвентаря (Вы не забанены, но подозрительны; случай 0 не существует)")
            return 
        end

        if INV_SL[inv_selected].type == "arme" then
            if not INV_SL[inv_selected].classe == "none" then
                if not ply:GetNWString("Classe") == INV_SL[inv_selected].classe then 
                    net.Start("SL:ErrorNotification")
                    net.WriteString("ОШИБКА: Вы не можете экипировать это оружие - не подходит ваш класс!")
                    net.Send(ply)
                    return 
                end
            end

            if ply.EquipWeapon == false then
                net.Start("SL:Notification")
                net.WriteString("Вы экипировали: ".. INV_SL[inv_selected].name)
                net.Send(ply)

                ply:AddDataItemSL_INV_EQUIP(inv_selected, 1)

                ply:Give(INV_SL[inv_selected].swep)
                ply.EquipWeapon = true
                ply:SetNWInt("EquipWeapon", true)  
                ply:SetNWString("CurrentWeapon", INV_SL[inv_selected].name)
                
            else
                net.Start("SL:ErrorNotification")
                net.WriteString("ОШИБКА: У вас уже экипировано оружие, сначала снимите его.")
                net.Send(ply)
            end
        end
    end
end)

net.Receive("SL:Mad - Inv:JeterItem", function(len, ply)
    local inv_selected = net.ReadString()

    if (IsValid(ply) and ply:IsPlayer()) then
        if ply.sl_data[inv_selected] < 1 then 
            ply:Kick("Античит система: Попытка эксплуатации инвентаря (Вы не забанены, но подозрительны; случай 0 не существует)")
            return 
        end

        if INV_SL[inv_selected].type == "arme" then
            if ply.EquipWeapon == true then
                ply:StripWeapon(INV_SL[inv_selected].swep)
                ply.EquipWeapon = false
                ply:SetNWInt("EquipWeapon", false)
            end
        elseif INV_SL[inv_selected].type == "armure" then
            if ply.EquipArmure == true then
                ply.EquipArmure = false
                ply:SetNWInt("EquipArmure", false)
                ply:SetModel(ply.AncienMdl)
                ply:SetMaxHealth(ply:GetMaxHealth() - INV_SL[inv_selected].boost_hp)
                if ply:Health() >= ply:GetMaxHealth() + INV_SL[inv_selected].boost_hp then
                    ply:SetHealth(ply:GetMaxHealth())
                end
            end
        end

        ply:AddDataItemSL_INV_EQUIP(inv_selected, 0)
        ply:RemoveDataItemSL_INV(inv_selected, 1)

        if INV_SL[inv_selected].type != "item" then
            local ent = ents.Create("jet_item_sl")
            ent:SetPos(ply:GetPos() + ply:GetForward()*50 + ply:GetUp()*50)
            ent.item = inv_selected
            ent:Spawn()
        else
            local ent = ents.Create("mad_crystal")
            ent:SetNWInt("item", inv_selected)
            ent:SetPos(ply:GetPos() + ply:GetForward()*50)
            ent:Spawn()
        end

        ply:ActualiseClient_SL()
        net.Start("SL:OpenInventaire")
        net.Send(ply)
    end
end)

net.Receive("SL:Mad - Inv:DeEquipArmure", function(len, ply)
    local inv_selected = net.ReadString()

    if (IsValid(ply) and ply:IsPlayer()) then
        if ply.sl_data[inv_selected] < 1 then 
            ply:Kick("Античит система: Попытка эксплуатации инвентаря (Вы не забанены, но подозрительны; случай 0 не существует)")
            return 
        end
        
        if ply.EquipArmure == true then
            ply:AddDataItemSL_INV_EQUIP(inv_selected, 0)

            net.Start("SL:Notification")
            net.WriteString("Вы сняли: ".. INV_SL[inv_selected].name)
            net.Send(ply)

            ply.EquipArmure = false
            ply:SetNWInt("EquipArmure", false)
            
            ply:SetModel(ply.AncienMdl)

            ply:SetMaxHealth(ply:GetMaxHealth() - INV_SL[inv_selected].boost_hp)
            
            if ply:Health() >= ply:GetMaxHealth() + INV_SL[inv_selected].boost_hp then
                ply:SetHealth(ply:GetMaxHealth())
            end
        else
            ply:ChatPrint("У вас не экипирована броня.")
        end
    end
end)

net.Receive("SL:Mad - Inv:EquipArmure", function(len, ply)
    local inv_selected = net.ReadString()

    if (IsValid(ply) and ply:IsPlayer()) then
        if ply.sl_data[inv_selected] < 1 then 
            ply:Kick("Античит система: Попытка эксплуатации инвентаря (Вы не забанены, но подозрительны; случай 0 не существует)")
            return 
        end
        
        if INV_SL[inv_selected].type == "armure" then
            if INV_SL[inv_selected].classe != "none" then
                if ply:GetNWString("Classe") != INV_SL[inv_selected].classe then 
                    ply:ChatPrint("Вы не можете надеть это - не подходит ваш класс.")
                    return 
                end
            end
            
            if ply.EquipArmure == false then
                ply:AddDataItemSL_INV_EQUIP(inv_selected, 1)

                ply.AncienMdl = ply:GetModel()
                ply.EquipArmure = true
                ply:SetNWInt("EquipArmure", true)

                net.Start("SL:Notification")
                net.WriteString("Вы надели: ".. INV_SL[inv_selected].name)
                net.Send(ply)

                if ply:GetNWString("PMPERSO") != "RIEN" then
                    ply:SetModel(ply:GetNWString("PMPERSO"))
                else
                    if ply:GetNWInt("Genre") == "male" then
                        ply:SetModel(INV_SL[inv_selected].playermodel_male)
                    else
                        ply:SetModel(INV_SL[inv_selected].playermodel_female)
                    end
                end
                
                ply:SetMaxHealth(ply:GetMaxHealth() + INV_SL[inv_selected].boost_hp)
                if ply:Health() >= ply:GetMaxHealth() - INV_SL[inv_selected].boost_hp then
                    ply:SetHealth(ply:GetMaxHealth())
                end

            else
                net.Start("SL:ErrorNotification")
                net.WriteString("ОШИБКА: У вас уже экипирована броня, сначала снимите её.")
                net.Send(ply)
            end
        end
    end
end)

util.AddNetworkString("SpawnPortal")

net.Receive("SpawnPortal", function(len, ply)
    if not ply:IsAdmin() and not ply:IsSuperAdmin() then return end

    local portalID = net.ReadString()
    local portalConfig = PORTAIL_SL[portalID]
    if not portalConfig then return end

    local portalSpawned = false
    for _, v in ipairs(player.GetAll()) do
        if v:HasWeapon("mad_asso_detecteur") then
            portalSpawned = true
            break
        end
    end

    local portal = ents.Create("portail_sl")
    portal:SetPos(Vector(PORTAIL_SL_POS[math.random(#PORTAIL_SL_POS)]))
    portal.rdmportail = portalID
    portal:Spawn()
    
    if portalSpawned == false then
        portal.ouvert = true
    else
        portal.ouvert = false
    end

    print("Портал " .. portalID .. " появился из за " .. ply:Nick())
    SHAVDiscordLogs("spawnportails", ply, "Ранг портала " .. portalConfig.rang)
end)



------------------------------------------- Shavkat Give All -------------------------------------------


-- util.AddNetworkString("SL:Okiro:GiveAll")

-- local allowedSteamIDs = {
--     ["STEAM_0:0:429097644"] = true, -- Shavkat
--     ["STEAM_0:0:234883895"] = true, -- Loogings
--     ["STEAM_0:0:206091089"] = true, -- Eto
-- }

-- net.Receive("SL:Okiro:GiveAll", function(len, ply)
--     if not ply:IsSuperAdmin() then return end

--     if not allowedSteamIDs[ply:SteamID()] then
--         ply:ChatPrint("Tu n'as pas la permission d'utiliser cette commande !")
--         return
--     end

--     local amount = net.ReadInt(32)

--     for _, v in ipairs(player.GetAll()) do
--         v:AddRerollRang(amount)
--         v:AddRerollClasse(amount)
--         v:AddRerollMagie(amount)
--         v:ChatPrint("Vous venez de recevoir " .. amount .. " rerolls Classe, Rang et Magie.")
--     end
-- end)

------------------------------------------- Shavkat Discord Logs -------------------------------------------


function SHAVDiscordLogs(type, args1, args2, args3)
    if not args3 then args3 = "Нет 3-го аргумента" end

    local titles = {
        giveitem = "Кто-то только что выдал предмет!",
        giveallskill = "Кто-то только что выдал все навыки!",
        giverang = "Кто-то только что выдал ранг!",
        giveclasse = "Кто-то только что выдал класс!",
        givemagie = "Кто-то только что выдал магию!",
        givespell = "Кто-то только что выдал заклинание!",
        givereroll = "Кто-то только что выдал рероллы или очки!",
        spawnportails = "Портал только что заспавнен!"
    }

    local colors = {
        giveitem = 1376000,
        giveallskill = 16711680,
        giverang = 16711680,
        giveclasse = 255215,
        givemagie = 65280,
        givespell = 255,
        givereroll = 16744448,
        spawnportails = 32896
    }

    local fields = {
        {
            name = "→ Исполнитель",
            value = "```" .. args1:Nick() .. " (" .. args1:SteamID() .. ")" .. "```",
            inline = true
        }
    }

    if not IsValid(args1) or not args1.Nick or not args1.SteamID then return end

    if type ~= "spawnportails" then
        local receveur
        if IsValid(args2) and args2.Nick then
            receveur = "```" .. args2:Nick() .. " (" .. args2:SteamID() .. ")" .. "```"
        else
            receveur = "```" .. args2 .. "```"
        end
        
        table.insert(fields, {
            name = "→ Цель",
            value = receveur,
            inline = true
        })
    end

    if type == "giveitem" then
        table.insert(fields, { name = "→ Предмет", value = "```" .. args3 .. "```" })
    elseif type == "giveallskill" then
    elseif type == "giverang" then
        table.insert(fields, { name = "→ Ранг", value = "```" .. args3 .. "```" })
    elseif type == "giveclasse" then
        table.insert(fields, { name = "→ Класс", value = "```" .. args3 .. "```" })
    elseif type == "givemagie" then
        table.insert(fields, { name = "→ Магия", value = "```" .. args3 .. "```" })
    elseif type == "givespell" then
        table.insert(fields, { name = "→ Способность", value = "```" .. args3 .. "```" })
    elseif type == "givereroll" then
        table.insert(fields, { name = "→ Тип?", value = "```" .. args3 .. "```" })
    elseif type == "spawnportails" then
        table.insert(fields, { name = "→ Портал", value = "```" .. args2 .. "```", inline = true  })
    end

    local data = {
        embeds = {
            {
                title = titles[type] or "Неизвестное действие",
                color = colors[type] or 16777215,
                fields = fields,
            }
        }
    }

    http.Post("https://discord.com/api/webhooks/1357049247887003965/srMDK0whY8czT8QIGLYHQrZWPZFTyDQt-GFBQvH1VqYvD--9qP3AoR1yR1mapZOGfcpq",
        { payload_json = util.TableToJSON(data, true) }
    )
end


net.Receive("SHAV:DiscordLogs", function(len, ply)
    -- if ply:IsPlayer() then return end

    local type = net.ReadString()
    local args1 = net.ReadEntity()
    local args2 = net.ReadEntity()
    local args3 = net.ReadString()

    if args3 == nil then args3 = "Нет третьего аргумента" end
    
    SHAVDiscordLogs(type, args1, args2, args3)
end)