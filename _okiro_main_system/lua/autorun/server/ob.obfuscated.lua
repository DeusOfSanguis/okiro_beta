util.AddNetworkString("SL:OpenStatus")
util.AddNetworkString("SL:OpenShop")
util.AddNetworkString("SL:OpenRevendeur")
util.AddNetworkString("SL:OpenSell")
util.AddNetworkString("SL:OpenClasseMenu")
util.AddNetworkString("SL:OpenSkillsMenu")
util.AddNetworkString("SL:OpenRangMenu")
util.AddNetworkString("SL:MainMenu")
util.AddNetworkString("SL:OpenInventaire")
util.AddNetworkString("SL:OpenBanque")

util.AddNetworkString("SL:Anim_Play")
util.AddNetworkString("SL:PO:ParticleEffectAttach")
util.AddNetworkString("SL:PO:ParticleEffectPosPlayer")

util.AddNetworkString("SL:Mad - Skills:Bind")

util.AddNetworkString("SL:OpenMagieMenu")

util.AddNetworkString("SL:Mad - Classe:Start")
util.AddNetworkString("SL:Mad - Classe:Choix")

util.AddNetworkString("SL:Mad - Rang:Start")

util.AddNetworkString("SL:Mad - Magie:Start")
util.AddNetworkString("SL:Mad - Magie:Choisir")

util.AddNetworkString("SL:Mad - Shop:Acheter")
util.AddNetworkString("SL:Mad - Shop:Vendre")
util.AddNetworkString("SL:Mad - Shop:Revendre")

util.AddNetworkString("SL:sendservertoclientdata")
util.AddNetworkString("SL:sendservertoclientdata_stats")
util.AddNetworkString("SL:sendservertoclientdata_classe")
util.AddNetworkString("SL:sendservertoclientdata_rerolls")
util.AddNetworkString("SL:sendservertoclientdata_skills")
util.AddNetworkString("SL:sendservertoclientdata_rang")
util.AddNetworkString("SL:sendservertoclientdata_magie")
util.AddNetworkString("SL:sendservertoclientdata_inv_equip")
util.AddNetworkString("SL:sendservertoclientdata_inv_banque")

util.AddNetworkString("SL:Mad - Inv:EquipWeapon")
util.AddNetworkString("SL:Mad - Inv:EquipArmure")

util.AddNetworkString("SL:Mad - Inv:RetirerDeLaBanque")
util.AddNetworkString("SL:Mad - Inv:AjouterALaBanque")
util.AddNetworkString("SL:Mad - Inv:AchatBanque")

util.AddNetworkString("SL:Mad - Inv:DeEquipWeapon")
util.AddNetworkString("SL:Mad - Inv:DeEquipArmure")
util.AddNetworkString("SL:Mad - Inv:JeterItem")

util.AddNetworkString("SL:Mad - Stats:Up")
util.AddNetworkString("SL:Mad - Stats:ResetStats")

util.AddNetworkString("SL:Notification")

util.AddNetworkString("SL:Mad - Admin:GiveItem")
util.AddNetworkString("SL:Mad - Admin:AddRerolls")

util.AddNetworkString("SL:Portail:Teleport")
util.AddNetworkString("SL:Portail:Open")
util.AddNetworkString("SL:Portail:Close")
util.AddNetworkString("SL:Portail:DungeonBreak")

util.AddNetworkString("SL:Mad - Coiffeur:Menu")
util.AddNetworkString("SL:Mad - Coiffeur:Change")

util.AddNetworkString("ASSO:OpenMenu")
util.AddNetworkString("ASSO:EnvoieTxt")

local plyMeta = FindMetaTable("Player")

function plyMeta:GetDataSL()

    if not file.Exists("sl_data/" .. self:SteamID64() .. "/classe.json", "DATA") then
        self:SetNWInt("Classe", "Aucune")
    elseif file.Exists("sl_data/" .. self:SteamID64() .. "/classe.json", "DATA") then
        self:SetNWInt("Classe", file.Read( "sl_data/" .. self:SteamID64() .. "/classe.json"), "DATA" )
    end

    self.sl_data = util.JSONToTable(file.Read("sl_data/" .. self:SteamID64() .. "/inv.json", "DATA")) or {}
    self.sl_data2 = util.JSONToTable(file.Read("sl_data/" .. self:SteamID64() .. "/stats.json", "DATA")) or {}
    self.sl_data3 = util.JSONToTable(file.Read("sl_data/" .. self:SteamID64() .. "/rerolls.json", "DATA")) or {}
    self.sl_data4 = util.JSONToTable(file.Read("sl_data/" .. self:SteamID64() .. "/skills.json", "DATA")) or {}
    self.sl_data5 = util.JSONToTable(file.Read("sl_data/" .. self:SteamID64() .. "/inv_equip.json", "DATA")) or {}
    self.sl_data6 = util.JSONToTable(file.Read("sl_data/" .. self:SteamID64() .. "/binds_save.json", "DATA")) or {}
    local filePath = "sl_data/" .. self:SteamID64() .. "/inv_banque.json"
    if file.Exists(filePath, "DATA") then
        self.sl_data7 = util.JSONToTable(file.Read("sl_data/" .. self:SteamID64() .. "/inv_banque.json", "DATA")) or {}
    end
end


hook.Add("PlayerInitialSpawn", "SL:Init_DATA", function(ply)
    ply:SetNWInt("mana", SL_Val_Config.InitialMana)
    ply:SetNWInt("mad_stamina", ply:GetNWInt("mana"))

    if not file.Exists("sl_data", "DATA") then
        file.CreateDir("sl_data")
    end

    if not file.Exists("sl_data/" .. ply:SteamID64(), "DATA") then
        local sl_data2 = util.TableToJSON(initsl_data2)
        local sl_data3 = util.TableToJSON(initsl_data3)
        file.CreateDir("sl_data/" .. ply:SteamID64())
        file.Write("sl_data/" .. ply:SteamID64() .. "/binds_save.json", "{}")
        file.Write("sl_data/" .. ply:SteamID64() .. "/inv.json", "{}")
        file.Write("sl_data/" .. ply:SteamID64() .. "/inv_equip.json", "{}")
        file.Write("sl_data/" .. ply:SteamID64() .. "/inv_banque.json", "{}")
        file.Write("sl_data/" .. ply:SteamID64() .. "/skills.json", "{}")
        file.Write("sl_data/" .. ply:SteamID64() .. "/titre.json", "{}")
        file.Write("sl_data/" .. ply:SteamID64() .. "/stats.json", sl_data2)
        file.Write("sl_data/" .. ply:SteamID64() .. "/rerolls.json", sl_data3)
    else
        ply:GetDataSL()
    end

    ply:KillSilent()
end)

hook.Add("PlayerSpawn", "SL:Spawn_DATA", function(ply)
    if not file.Exists("sl_data", "DATA") then
        file.CreateDir("sl_data")
    end

    if ply:GetNWInt("Classe") == "bestial" then
        ply:Give("mad_corpsacorps")
    end

    ply.EquipWeapon = false
    ply.EquipArmure = false
    ply:SetNWInt("EquipWeapon", false)
    ply:SetNWInt("EquipArmure", false)

    ply:Flashlight(false)
    timer.Simple(0.1, function()
        ply:AllowFlashlight(false)
    end)

    if not file.Exists("sl_data/" .. ply:SteamID64(), "DATA") then
        local sl_data2 = util.TableToJSON(initsl_data2)
        local sl_data3 = util.TableToJSON(initsl_data3)
        file.CreateDir("sl_data/" .. ply:SteamID64())
        file.Write("sl_data/" .. ply:SteamID64() .. "/binds_save.json", "{}")
        file.Write("sl_data/" .. ply:SteamID64() .. "/inv.json", "{}")
        file.Write("sl_data/" .. ply:SteamID64() .. "/inv_equip.json", "{}")
        file.Write("sl_data/" .. ply:SteamID64() .. "/skills.json", "{}")
        file.Write("sl_data/" .. ply:SteamID64() .. "/stats.json", sl_data2)
        file.Write("sl_data/" .. ply:SteamID64() .. "/rerolls.json", sl_data3)
    else
        ply:GetDataSL()
    end

    timer.Simple(1, function()

        -- Ajoute les armes initiales depuis la SL_Val_Config
        for _, weapon in ipairs(SL_Val_Config.InitialWeapons) do
            ply:Give(weapon)
        end

        ply:SetNWInt("mana", SL_Val_Config.InitialMana * ply.sl_data2["intelligence"])
        ply:SetNWInt("mad_stamina", ply:GetNWInt("mana"))
        ply:SetNWInt("regene", SL_Val_Config.Regeneration)

        local filePath = "sl_data/" .. ply:SteamID64() .. "/banqueachat.json"
        ply:SetNWInt("AchatBanque", file.Exists(filePath, "DATA") and true or false)

        local steamid64 = ply:SteamID64()
        local filePath = "sl_data/" .. steamid64 .. "/titre.json"

        if file.Exists(filePath, "DATA") then
            local data = file.Read(filePath, "DATA")
            local modelTable = util.JSONToTable(data)

            if modelTable and modelTable.titre then
                ply:SetNWString("Titre", TITRE_SL[modelTable.titre].name)
                timer.Simple(1, function()
                    ply:SetHealth(ply:GetMaxHealth() + TITRE_SL[modelTable.titre].bonus_vie)
                    ply:SetMaxHealth(ply:Health())
                    ply:SetRunSpeed(ply:GetRunSpeed() + TITRE_SL[modelTable.titre].bonus_vitesse)
                    ply:SetNWInt("DegatSupplementaireTitre", TITRE_SL[modelTable.titre].bonus_degat)
                end)
            else
                ply:SetNWString("Titre", SL_Val_Config.DefaultTitre)
                ply:SetNWInt("DegatSupplementaireTitre", 0)
            end
        else
            ply:SetNWString("Titre", SL_Val_Config.DefaultTitre)
            ply:SetNWInt("DegatSupplementaireTitre", 0)
        end

        if not file.Exists("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA") then
            ply:SetNWInt("Rang", SL_Val_Config.DefaultRank)
            ply:SetHealth(ply:GetMaxHealth() + SL_Val_Config.VitalityMultiplier * ply.sl_data2["vitalite"])
            ply:SetMaxHealth(ply:Health())
            ply:SetRunSpeed(ply:GetRunSpeed() + SL_Val_Config.AgilityMultiplier * ply.sl_data2["agilite"])
        else
            ply:SetNWInt("Rang", file.Read("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA"))

            if ply:GetNWInt("Rang") == "S" then
                ply:SetNWInt("Aura_RangS", true)
            else
                ply:SetNWInt("Aura_RangS", false)
            end

            ply:SetHealth((ply:GetMaxHealth() + SL_Val_Config.VitalityMultiplier * ply.sl_data2["vitalite"]) * RANG_SL[ply:GetNWInt("Rang")].coef_bonus_vie)
            ply:SetMaxHealth(ply:Health())
            ply:SetRunSpeed((ply:GetRunSpeed() + SL_Val_Config.AgilityMultiplier * ply.sl_data2["agilite"]) * RANG_SL[ply:GetNWInt("Rang")].coef_bonus_vitesse)
        end

        -- Gestion de la magie
        local magiePath = "sl_data/" .. ply:SteamID64() .. "/magie.json"
        ply:SetNWInt("Magie", file.Exists(magiePath, "DATA") and file.Read(magiePath, "DATA") or SL_Val_Config.DefaultMagie)

        print(ply:GetNWInt("Magie"))

        -- Ajustement des dégâts
        timer.Simple(0.01, function()
            hook.Add("EntityTakeDamage", "CustomPlayerDamageMultiplier" .. ply:SteamID(), function(target, dmginfo)
                local attacker = dmginfo:GetAttacker()
                if IsValid(attacker) and attacker:IsPlayer() and attacker == ply then
                    local forceMultiplier = ply.sl_data2["force"]
                    if ply:GetNWInt("Rang") ~= SL_Val_Config.DefaultRank then
                        forceMultiplier = forceMultiplier + RANG_SL[ply:GetNWInt("Rang")].coef_bonus_degat
                    end

                    local newDamage = dmginfo:GetDamage() + ply:GetNWInt("DegatSupplementaireTitre") + (forceMultiplier * SL_Val_Config.ForceMultiplier)
                    dmginfo:SetDamage(newDamage)
                end
            end)
        end)

        local slot = ply:GetNWInt("Slot_Choisis")

        ply:GetDataSL_Chara(slot)

        if not file.Exists("sl_data/" .. ply:SteamID64() .. "/" .. slot, "DATA") then
            --net.Start( "SL:OpenCharacterCreatorMenu" )
            --net.Send(ply)
        else
            if not ply:GetNWString("PMPERSO") == "RIEN" then
                ply:SetModel(ply:GetNWString("PMPERSO"))
            else
                ply:SetModel(ply.data.sl_model)
            end
            ply.AncienMdl = ply:GetModel()
            if ply.data.sl_genre == "male" then
                ply:SetBodygroup(3, ply.data.sl_cheveux)
            else
                ply:SetBodygroup(2, ply.data.sl_cheveux)
            end
            ply:SetPlayerColor(ply.data.sl_haircolor)
            ply:SetSkin(ply.data.sl_yeux)
            ply:SetNWInt("Genre", ply.data.sl_genre)
            ply:setDarkRPVar("rpname", ply.data.sl_nom .. " " .. ply.data.sl_prenom)
            ply:SetNWInt("Age", ply.data.sl_age)
        end
    
        for k, v in pairs(ply.sl_data) do
            if ply.sl_data5[k] and ply.sl_data5[k] >= 1 then
                if INV_SL[k].type == "arme" then
                    ply.EquipWeapon = true
                    ply:SetNWInt("EquipWeapon", true)
                    ply:Give(INV_SL[k].swep) -- Donne l'arme au joueur
                elseif INV_SL[k].type == "armure" then
                    ply.EquipArmure = true
                    ply:SetNWInt("EquipArmure", true)
                    if not ply:GetNWString("PMPERSO") == "RIEN" then
                        ply:SetModel(ply:GetNWString("PMPERSO"))
                    else
                        if ply:GetNWInt("Genre") == "male" then
                            ply:SetModel(INV_SL[k].playermodel_male)
                        else
                            ply:SetModel(INV_SL[k].playermodel_female)
                        end
                    end
                    ply:SetHealth(ply:Health() + INV_SL[k].boost_hp) -- Ajoute le bonus de vie
                    ply:SetMaxHealth(ply:GetMaxHealth() + INV_SL[k].boost_hp)
                end
            end
        end
    
        for i = 1, 6 do
            for k, v in pairs(ply.sl_data6) do
                if ply.sl_data6["Technique"..i] and not ply.sl_data6["Technique"..i] == 0 then
                    ply:SetNWInt("Technique"..i, ply.sl_data6["Technique"..i])
                end
            end
        end
        
    end)
end)