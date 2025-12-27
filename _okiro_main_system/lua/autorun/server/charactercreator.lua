util.AddNetworkString("SL:OpenCharacterCreatorMenu")
util.AddNetworkString("SL:CreateCharacterMenu")
util.AddNetworkString("SL:Mad - Character:Create")
util.AddNetworkString("SL:Mad - Character:Load")
util.AddNetworkString("SL:Mad - Character:Reload")
util.AddNetworkString("SL:Mad - Character:SendClient_1")
util.AddNetworkString("SL:Mad - Character:SendClient_2")
util.AddNetworkString("SL:Mad - Character:SendClient_3")

concommand.Add("sl_charactercreator", function(ply)
    net.Start( "SL:OpenCharacterCreatorMenu" )
    net.Send(ply)
end)

net.Receive("SL:Mad - Character:Create", function(len, ply)
    local slot = net.ReadFloat()
    local genre = net.ReadString()
    local cheveux = net.ReadFloat()
    local yeux = net.ReadFloat()
    local nom = net.ReadString()
    local prenom = net.ReadString()
    local playercolor = net.ReadVector()

    ply.data = {
        sl_slot = slot,
        sl_model = model,
        sl_genre = genre,
        sl_cheveux = cheveux,
        sl_yeux = yeux,
        sl_nom = nom,
        sl_prenom = prenom,
        sl_haircolor = playercolor 
    }

    if ply.data.sl_genre == "male" then
        ply.data.sl_model = "models/mad_models/mad_sl_male_civil1.mdl"
    else
        ply.data.sl_model = "models/mad_models/mad_sl_female1.mdl"
    end

    if not file.Exists("sl_data/" .. ply:SteamID64() .. "/" .. slot, "DATA") then
        local sl_data_chara = util.TableToJSON(ply.data)
        file.CreateDir("sl_data/" .. ply:SteamID64())
        file.CreateDir("sl_data/" .. ply:SteamID64() .. "/" .. slot)
        file.Write("sl_data/" .. ply:SteamID64() .. "/" .. slot .. "/chara.json", sl_data_chara)

        ply:GetDataSL_Chara(slot)

        if not file.Exists("sl_data/" .. ply:SteamID64() .. "/" .. slot, "DATA") then
             ply:ReloadDataSL_Chara()
        else
            if ply:GetNWString("PMPERSO") != "RIEN" then
                ply:SetModel(ply:GetNWString("PMPERSO"))
            else
                ply:SetModel(ply.data.sl_model)
                if ply.data.sl_genre == "male" then
                    ply:SetBodygroup(3, ply.data.sl_cheveux)
                else
                    ply:SetBodygroup(2, ply.data.sl_cheveux)
                end
            end
            ply:SetPlayerColor(ply.data.sl_haircolor) 
            ply:SetNWInt("Slot_Choisis", slot)
            ply:SetSkin(ply.data.sl_yeux)
            ply:SetNWInt("Genre", ply.data.sl_genre)


            timer.Simple(1,function ()
                ply:ReloadDataSL_Chara()
            end)
            
        end
    end
end)

local plyMeta = FindMetaTable("Player")

function plyMeta:GetDataSL_Chara(slot)
    if file.Exists("sl_data/" .. self:SteamID64() .. "/" .. slot, "DATA") then
        self.data = util.JSONToTable(file.Read("sl_data/" .. self:SteamID64() .. "/" .. slot .. "/chara.json", "DATA")) or {}
    end
end

function plyMeta:ReloadDataSL_Chara()
    if file.Exists("sl_data/" .. self:SteamID64() .. "/1", "DATA") then
        self.data = util.JSONToTable(file.Read("sl_data/" .. self:SteamID64() .. "/1/chara.json", "DATA")) or {}
        self:SetNWInt("Perso1", "good")
        
        net.Start( "SL:Mad - Character:SendClient_1" )
        net.WriteTable(self.data)
        net.Send(self)
    else
        self:SetNWInt("Perso1", "no")
    end

    if file.Exists("sl_data/" .. self:SteamID64() .. "/2", "DATA") then
        self.data = util.JSONToTable(file.Read("sl_data/" .. self:SteamID64() .. "/2/chara.json", "DATA")) or {}
        self:SetNWInt("Perso2", "good")
        
        net.Start( "SL:Mad - Character:SendClient_2" )
        net.WriteTable(self.data)
        net.Send(self)
    else
        self:SetNWInt("Perso2", "no")
    end

    if file.Exists("sl_data/" .. self:SteamID64() .. "/3", "DATA") then
        self.data = util.JSONToTable(file.Read("sl_data/" .. self:SteamID64() .. "/3/chara.json", "DATA")) or {}
        self:SetNWInt("Perso3", "good")
        
        net.Start( "SL:Mad - Character:SendClient_3" )
        net.WriteTable(self.data)
        net.Send(self)
    else
        self:SetNWInt("Perso3", "no")
    end
end

hook.Add("PlayerSpawn", "SL:Spawn_DATA_Character", function(ply)

    ply:ReloadDataSL_Chara()

    timer.Simple(0.5, function()

        ply:GetDataSL_Chara(ply:GetNWInt("Slot_Choisis"))

        if file.Exists("sl_data/" .. ply:SteamID64() .. "/" .. ply:GetNWInt("Slot_Choisis"), "DATA") then
            if ply:GetNWString("PMPERSO") != "RIEN" then
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
        end
    end)

end)

hook.Add("PlayerInitialSpawn", "SL:PlayerInitialSpawn_DATA_Character", function(ply)

    timer.Simple(0.5, function()
        ply:ReloadDataSL_Chara()
    end)

    timer.Simple(1, function()
        net.Start( "SL:OpenCharacterCreatorMenu" )
        net.Send(ply)
    end)

end)

net.Receive("SL:Mad - Character:Reload", function(len, ply)
    if file.Exists("sl_data/" .. ply:SteamID64() .. "/1", "DATA") then
        ply.data = util.JSONToTable(file.Read("sl_data/" .. ply:SteamID64() .. "/1/chara.json", "DATA")) or {}
        ply:SetNWInt("Perso1", "good")
        
        net.Start( "SL:Mad - Character:SendClient_1" )
        net.WriteTable(ply.data)
        net.Send(ply)
    else
        ply:SetNWInt("Perso1", "no")
    end

    if file.Exists("sl_data/" .. ply:SteamID64() .. "/2", "DATA") then
        ply.data = util.JSONToTable(file.Read("sl_data/" .. ply:SteamID64() .. "/2/chara.json", "DATA")) or {}
        ply:SetNWInt("Perso2", "good")
        
        net.Start( "SL:Mad - Character:SendClient_2" )
        net.WriteTable(ply.data)
        net.Send(ply)
    else
        ply:SetNWInt("Perso2", "no")
    end

    if file.Exists("sl_data/" .. ply:SteamID64() .. "/3", "DATA") then
        ply.data = util.JSONToTable(file.Read("sl_data/" .. ply:SteamID64() .. "/3/chara.json", "DATA")) or {}
        ply:SetNWInt("Perso3", "good")
        
        net.Start( "SL:Mad - Character:SendClient_3" )
        net.WriteTable(ply.data)
        net.Send(ply)
    else
        ply:SetNWInt("Perso3", "no")
    end
end)

net.Receive( "SL:Mad - Character:Load", function( len, ply )

    ply:KillSilent()

    slot = net.ReadFloat()
    ply:GetDataSL_Chara(slot)

    if not file.Exists("sl_data/" .. ply:SteamID64() .. "/" .. slot, "DATA") then
        net.Start( "SL:OpenCharacterCreatorMenu" )
        net.Send(ply)
    else
        if ply:GetNWString("PMPERSO") != "RIEN" then
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
        ply:SetNWInt("Slot_Choisis", slot)
        ply:SetSkin(ply.data.sl_yeux)
        ply:SetNWInt("Genre", ply.data.sl_genre)
    end

    for k, v in pairs(ply.sl_data) do
        if ply.sl_data5[k] and ply.sl_data5[k] >= 1 then
            if INV_SL[k].type == "arme" then
                ply.EquipWeapon = true
                ply:SetNWInt("EquipWeapon", true)
                ply:Give(INV_SL[k].swep) 
            elseif INV_SL[k].type == "armure" then
                ply.EquipArmure = true
                ply:SetNWInt("EquipArmure", true)
                if ply:GetNWString("PMPERSO") != "RIEN" then
                    ply:SetModel(ply:GetNWString("PMPERSO"))
                else
                    if ply:GetNWInt("Genre") == "male" then
                        ply:SetModel(INV_SL[k].playermodel_male)
                    else
                        ply:SetModel(INV_SL[k].playermodel_female)
                    end
                end
                ply:SetHealth(ply:Health() + INV_SL[k].boost_hp)
                ply:SetMaxHealth(ply:GetMaxHealth() + INV_SL[k].boost_hp)
            end
        end
    end

    for i = 1, 6 do
        for k, v in pairs(ply.sl_data6) do
            if ply.sl_data6["Technique"..i] and ply.sl_data6["Technique"..i] != 0 then
                ply:SetNWInt("Technique"..i, ply.sl_data6["Technique"..i])
            end
        end
    end

end)