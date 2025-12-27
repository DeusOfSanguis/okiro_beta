local COOLDOWN = 1 
local lastPress = 0 

hook.Add("PlayerSay", "UnifiedCommand", function(ply, text)
    local command = string.lower(text)
    
    if command == "!stuck" then
        if ply:Alive() and IsPlayerStuck(ply) then
            local unstuckPos = FindUnstuckPosition(ply)
            if unstuckPos then
                ply:SetPos(unstuckPos)
                ply:ChatPrint("Vous avez été téléporté car vous étiez bloqué.")
            else
                ply:ChatPrint("Aucun endroit sûr trouvé pour vous téléporter.")
            end
        else
            ply:ChatPrint("Vous n'êtes pas bloqué.")
        end
        return ""
    elseif command == "!coiffure" then
        if not (ply:Team() == TEAM_COIFFEUR) then
            ply:ChatPrint("Vous n'êtes pas un coiffeur !")
            return ""
        end

        local pos = ply:GetShootPos()
        local aim = ply:GetAimVector()
        local vector = 100
        local radius = 50

        local owner = ply

        local slash = {}
        slash.start = owner:GetShootPos()
        slash.endpos = owner:GetShootPos() + (owner:GetAimVector() * vector)
        slash.filter = function(ent)
            if ent:GetClass() == "mad_crystal" or ent == owner then
                return false
            end
            return true
        end
        slash.mins = Vector(-radius, -radius, 0)
        slash.maxs = Vector(radius, radius, 0)
        local tr = util.TraceHull(slash)

        if tr.Hit then
            if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
                ply:ActualiseClient_SL()
                net.Start("SL:Mad - Coiffeur:Menu")
                net.WriteEntity(tr.Entity)
                net.Send(ply)
            end
        end
        return ""
    elseif command == "!card" then
        if ply:Alive() and ply:HasWeapon("mad_asso_detecteur") then
            local pos = ply:GetShootPos()
            local aim = ply:GetAimVector()
            local vector = 100
            local radius = 50

            local owner = ply

            local slash = {}
            slash.start = owner:GetShootPos()
            slash.endpos = owner:GetShootPos() + (owner:GetAimVector() * vector)
            slash.filter = function(ent)
                if ent:GetClass() == "mad_crystal" or ent == owner then
                    return false
                end
                return true
            end
            slash.mins = Vector(-radius, -radius, 0)
            slash.maxs = Vector(radius, radius, 0)
            local tr = util.TraceHull(slash)

            if tr.Hit then
                if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
                    tr.Entity:Give("idcard")
                    RunConsoleCommand("perm_sweps_add", tr.Entity:SteamID(), "idcard")
                end
            end
        else
            ply:ChatPrint("Vous n'êtes pas de l'association.")
        end
        return ""
    end
end)

function IsPlayerStuck(ply)
    local tr = util.TraceEntity({
        start = ply:GetPos(),
        endpos = ply:GetPos(),
        filter = ply
    }, ply)
    return tr.StartSolid
end

function FindUnstuckPosition(ply)
    local directions = {
        Vector(1, 0, 0),
        Vector(-1, 0, 0),
        Vector(0, 1, 0),
        Vector(0, -1, 0),
        Vector(1, 1, 0),
        Vector(-1, -1, 0),
        Vector(1, -1, 0),
        Vector(-1, 1, 0),
        Vector(0, 0, 1),
        Vector(0, 0, -1),
        Vector(1, 0, 1),
        Vector(-1, 0, 1),
        Vector(0, 1, 1),
        Vector(0, -1, 1),
        Vector(1, 1, 1),
        Vector(-1, -1, 1),
        Vector(1, -1, 1),
        Vector(-1, 1, 1),
        Vector(1, 0, -1),
        Vector(-1, 0, -1),
        Vector(0, 1, -1),
        Vector(0, -1, -1),
        Vector(1, 1, -1),
        Vector(-1, -1, -1),
        Vector(1, -1, -1),
        Vector(-1, 1, -1)
    }

    local startPos = ply:GetPos()
    local maxRadius = 500000 
    local stepSize = 20

    for radius = stepSize, maxRadius, stepSize do
        for _, dir in ipairs(directions) do
            local testPos = startPos + dir * radius
            if IsPositionSafe(testPos, ply) then
                return testPos
            end
        end
    end
    return nil
end

function IsPositionSafe(pos, ply)
    local mins = ply:OBBMins()
    local maxs = ply:OBBMaxs()
    local tr = util.TraceHull({
        start = pos,
        endpos = pos,
        mins = mins,
        maxs = maxs,
        filter = ply
    })
    return not tr.StartSolid and not tr.AllSolid
end


hook.Add("GetFallDamage", "DisableFallDamage", function(ply, speed) 
	return false
end)

local menu = false

hook.Add("PlayerButtonDown", "SL:MainMenu", function(ply, button)
    if button == KEY_F4 and CurTime() - lastPress >= COOLDOWN then
        local menu
        if menu then
            net.WriteString(menu):Close()
            lastPress = CurTime()
            menu = false
        else
            ply:ActualiseClient_SL()
            net.Start("SL:MainMenu")
            net.Send(ply)
            
            ply:SendLua([[surface.PlaySound("mad_sfx_sololeveling/voice/soundmenu.wav")]])
            lastPress = CurTime()
            menu = true
        end
    end
end)

hook.Add("PlayerButtonDown", "SL:Okiro:OpenGeneralMenu", function(ply, button)
    if button == KEY_F9 and CurTime() - lastPress >= COOLDOWN then
        net.Start("SL:Okiro:OpenGeneralMenu")
        net.Send(ply)
        lastPress = CurTime()
    end
end)

hook.Add("PlayerButtonDown", "SL:Okiro:ThirdPerson", function(ply, button)
    if button == KEY_F1 and CurTime() - lastPress >= COOLDOWN then
        net.Start("SL:Okiro:ThirdPerson")
        net.Send(ply)
        lastPress = CurTime()
    end
end)

function GetRandomKey(tbl)
    local keys = {}
    for key, _ in pairs(tbl) do
        table.insert(keys, key)
    end
    return keys[math.random(1, #keys)]
end

CLASS_RARITY_CHANCES = {
    ["commun"] = 70,
    ["rare"] = 24,
    ["epique"] = 4,
    ["legendaire"] = 1.5,
    ["mythique"] = 0.5,
    ["unique"] = 0.0,
}

function GetRandomRarity()
    local totalChances = 0
    for _, chance in pairs(CLASS_RARITY_CHANCES) do
        totalChances = totalChances + chance
    end

    local randNum = math.random() * totalChances

    local cumulativeChance = 0
    for rarity, chance in pairs(CLASS_RARITY_CHANCES) do
        cumulativeChance = cumulativeChance + chance
        if randNum <= cumulativeChance then
            return rarity
        end
    end

    return "commun"
end

function GetRandomClassByRarity(rarity)
    local possibleClasses = {}

    for className, classData in pairs(CLASSES_SL) do
        if classData.rarete == rarity then
            table.insert(possibleClasses, className)
        end
    end

    if #possibleClasses > 0 then
        local randomClassName = possibleClasses[math.random(1, #possibleClasses)]
        return randomClassName
    else
        return "epeiste"
    end
end

function RandomRang()
    local totalPourcent = 0
    for _, rang in pairs(RANG_SL) do
        totalPourcent = totalPourcent + rang.pourcent
    end

    local randomValue = math.random() * totalPourcent
    local cumulative = 0

    for rank, data in pairs(RANG_SL) do
        cumulative = cumulative + data.pourcent
        if randomValue <= cumulative then
            return rank
        end
    end
end

MAGIE_RARITY_CHANCES = {
    ["commun"] = 75,
    ["rare"] = 20,
    ["legendaire"] = 5,
}

function GetRandomRarity_Magie()
    local totalChances = 0
    for rarity, chance in pairs(MAGIE_RARITY_CHANCES) do
        totalChances = totalChances + chance
    end

    local randNum = math.random(1, totalChances)

    local cumulativeChance = 0
    for rarity, chance in pairs(MAGIE_RARITY_CHANCES) do
        cumulativeChance = cumulativeChance + chance
        if randNum <= cumulativeChance then
            return rarity
        end
    end

    return "commun"
end

function GetRandomMagieByRarity(rarity)
    local possibleMagies = {}

    for magieName, classData in pairs(MAGIE_SL) do
        if classData.rarete == rarity then
            table.insert(possibleMagies, magieName)
        end
    end

    if #possibleMagies > 0 then
        local randomMagieName = table.Random(possibleMagies)
        return randomMagieName
    else
        return "feu"
    end
end

local function UpdateNetCode( ply )
    local classe = tonumber(ply.sl_data3["classe"] or 0 )
    local magie = tonumber(ply.sl_data3["magie"] or 0 )
    local rang = tonumber(ply.sl_data3["rang"] or 0 )

    net.Start( 'SL:sendservertoclientdata_rerolls' )
        net.WriteFloat( classe )
        net.WriteFloat( magie )
        net.WriteFloat( rang )
    net.Send( ply )
end

local plyMeta = FindMetaTable("Player")

function plyMeta:AddPts(value)
    self:GetDataSL()
    self.sl_data2["pts"] = self.sl_data2["pts"] + value
    file.Write("sl_data/"..self:SteamID64() .."/stats.json", util.TableToJSON(self.sl_data2))
end

function plyMeta:RemovePts(value)
    self:GetDataSL()
    self.sl_data2["pts"] = self.sl_data2["pts"] - value
    file.Write("sl_data/"..self:SteamID64() .."/stats.json", util.TableToJSON(self.sl_data2))
end

function plyMeta:AddResetStats(value)
    self:GetDataSL()
    self.sl_data2["rerollstats"] = self.sl_data2["rerollstats"] + value
    file.Write("sl_data/"..self:SteamID64() .."/stats.json", util.TableToJSON(self.sl_data2))
end

function plyMeta:RemoveResetStats(value)
    self:GetDataSL()
    self.sl_data2["rerollstats"] = self.sl_data2["rerollstats"] - value
    file.Write("sl_data/"..self:SteamID64() .."/stats.json", util.TableToJSON(self.sl_data2))
end

function plyMeta:AddRerollClasse(value)
    self:GetDataSL()
    self.sl_data3["classe"] = self.sl_data3["classe"] + value
    file.Write("sl_data/"..self:SteamID64() .."/rerolls.json", util.TableToJSON(self.sl_data3))

    UpdateNetCode( self )
end

function plyMeta:RemoveRerollClasse(value)
    self:GetDataSL()
    self.sl_data3["classe"] = self.sl_data3["classe"] - value
    file.Write("sl_data/"..self:SteamID64() .."/rerolls.json", util.TableToJSON(self.sl_data3))

    UpdateNetCode( self )
end

function plyMeta:AddRerollRang(value)
    self:GetDataSL()
    self.sl_data3["rang"] = self.sl_data3["rang"] + value
    file.Write("sl_data/"..self:SteamID64() .."/rerolls.json", util.TableToJSON(self.sl_data3))

    UpdateNetCode( self )
end

function plyMeta:RemoveRerollRang(value)
    self:GetDataSL()
    self.sl_data3["rang"] = self.sl_data3["rang"] - value
    file.Write("sl_data/"..self:SteamID64() .."/rerolls.json", util.TableToJSON(self.sl_data3))

    UpdateNetCode( self )
end

function plyMeta:AddRerollMagie(value)
    self:GetDataSL()
    self.sl_data3["magie"] = self.sl_data3["magie"] + value
    file.Write("sl_data/"..self:SteamID64() .."/rerolls.json", util.TableToJSON(self.sl_data3))

    UpdateNetCode( self )
end

function plyMeta:RemoveRerollMagie(value)
    self:GetDataSL()
    self.sl_data3["magie"] = self.sl_data3["magie"] - value
    file.Write("sl_data/"..self:SteamID64() .."/rerolls.json", util.TableToJSON(self.sl_data3))

    UpdateNetCode( self )
end

function plyMeta:AddCompetence(index, value)
    self:GetDataSL()
    self.sl_data2[index] = self.sl_data2[index] + value
    file.Write("sl_data/"..self:SteamID64() .."/stats.json", util.TableToJSON(self.sl_data2))
end

function plyMeta:RemoveCompetence(index, value)
    self:GetDataSL()
    self.sl_data2[index] = self.sl_data2[index] - value
    file.Write("sl_data/"..self:SteamID64() .."/stats.json", util.TableToJSON(self.sl_data2))
end

function plyMeta:Binds_Set_DATA(index, value)
    self:GetDataSL()

    if not self:Verif_InvFull_Equip() then
        self.sl_data6[index] = value

        file.Write("sl_data/" .. self:SteamID64() .. "/binds_save.json", util.TableToJSON(self.sl_data6))
    end
end

function plyMeta:Verif_CrystalFull()
    self:GetDataSL()

    if not self.sl_data then
        return false
    end

    local crystalCount = 0

    for _, v in pairs(self.sl_data) do
        if type(v) == "table" then
            for itemName, count in pairs(v) do
                if string.StartWith(itemName, "crystal") and count >= 1 then
                    crystalCount = crystalCount + count
                end
            end
        else
            if string.StartWith(_, "crystal") and v >= 1 then
                crystalCount = crystalCount + v
            end
        end
    end

    if self:GetUserGroup() == "vip" then
        return crystalCount > 1
    else
        return crystalCount > 0
    end
end

function plyMeta:Verif_InvFull()
    self:GetDataSL()

    local ply = self

    if not self.sl_data then
        return false
    end

    local uniqueItems = {}
    local itemCount = 0

    for _, v in pairs(self.sl_data) do
        if type(v) == "table" then
            for itemName, count in pairs(v) do
                if count >= 1 then
                    uniqueItems[itemName] = true
                end
            end
        else
            if v >= 1 then
                uniqueItems[_] = true
            end
        end
    end

    local uniqueItemCount = table.Count(uniqueItems)
    if ply:GetNWInt("Classe") == "porteur" then
        return uniqueItemCount >= 40
    else
        if self:GetUserGroup() == "vip" then 
            return uniqueItemCount >= 10
        else
            return uniqueItemCount >= 8
        end
    end
end

function plyMeta:IsEquipped(item_id)
    self:GetDataSL()

    if not self.sl_data5 then
        return false
    end

    for _, v in pairs(self.sl_data5) do
        if type(v) == "table" then
            for itemName, count in pairs(v) do
                if itemName == item_id and count >= 1 then
                    return true
                end
            end
        else
            if _ == item_id and v >= 1 then
                return true
            end
        end
    end

    return false
end


function plyMeta:Verif_InvFull_Equip()
    self:GetDataSL()

    if not self.sl_data5 then
        return false
    end

    local uniqueItems = {}
    local itemCount = 0

    for _, v in pairs(self.sl_data5) do
        if type(v) == "table" then
            for itemName, count in pairs(v) do
                if count >= 1 then
                    uniqueItems[itemName] = true
                end
            end
        else
            if v >= 1 then
                uniqueItems[_] = true
            end
        end
    end

    local uniqueItemCount = table.Count(uniqueItems)
    return uniqueItemCount >= 5
end

function plyMeta:Verif_InvFull_Banque()
    self:GetDataSL()

    if not self.sl_data7 then
        return false
    end

    local uniqueItems = {}
    local itemCount = 0

    for _, v in pairs(self.sl_data7) do
        if type(v) == "table" then
            for itemName, count in pairs(v) do
                if count >= 1 then
                    uniqueItems[itemName] = true
                end
            end
        else
            if v >= 1 then
                uniqueItems[_] = true
            end
        end
    end

    local uniqueItemCount = table.Count(uniqueItems)
    return uniqueItemCount >= 15
end


function plyMeta:SetDataItemSL_INV(index, value)
    self:GetDataSL()

    if not self.sl_data[index] then
        self.sl_data[index] = value
    else
        self.sl_data[index] = value
    end

    file.Write("sl_data/" .. self:SteamID64() .. "/inv.json", util.TableToJSON(self.sl_data))
end

function plyMeta:AddDataItemSL_INV(index, value)
    self:GetDataSL()

    if not self:Verif_InvFull() then
        if not self.sl_data[index] then
            self.sl_data[index] = value
        else
            self.sl_data[index] = self.sl_data[index] + value
        end

        file.Write("sl_data/" .. self:SteamID64() .. "/inv.json", util.TableToJSON(self.sl_data))
    end
end


function plyMeta:AddDataCrystauxSL_INV(index, value)
    self:GetDataSL()
    
    if not self.sl_data[index] then
        self.sl_data[index] = value
    else
        self.sl_data[index] = self.sl_data[index] + value
    end

    file.Write("sl_data/" .. self:SteamID64() .. "/inv.json", util.TableToJSON(self.sl_data))
end

function plyMeta:AddDataItemSL_INV_EQUIP(index, value)
    self:GetDataSL()

    if not self:Verif_InvFull_Equip() then
        self.sl_data5[index] = value

        file.Write("sl_data/" .. self:SteamID64() .. "/inv_equip.json", util.TableToJSON(self.sl_data5))
    end
end

function plyMeta:SetDataItemSL_INV_EQUIP(index, value)
    self:GetDataSL()

    if not self:Verif_InvFull_Equip() then
        self.sl_data5[index] = 0

        file.Write("sl_data/" .. self:SteamID64() .. "/inv_equip.json", util.TableToJSON(self.sl_data5))
    end
end

function plyMeta:AddDataItemSL_BANQUE(index, value)
    self:GetDataSL()

    if not self:Verif_InvFull_Banque() then
        self.sl_data7[index] = self.sl_data7[index] or 0
        self.sl_data7[index] = self.sl_data7[index] + value

        file.Write("sl_data/" .. self:SteamID64() .. "/inv_banque.json", util.TableToJSON(self.sl_data7))
    end
end

function plyMeta:RemoveDataItemSL_BANQUE(index, value)
    self:GetDataSL()

    if self.sl_data7[index] then
        self.sl_data7[index] = self.sl_data7[index] - value

        if self.sl_data7[index] <= 0 then
            self.sl_data7[index] = nil
        end

        file.Write("sl_data/" .. self:SteamID64() .. "/inv_banque.json", util.TableToJSON(self.sl_data7))
    end
end

function plyMeta:RemoveDataItemSL_INV(index, value)
    self:GetDataSL()

    if self.sl_data[index] then
        self.sl_data[index] = self.sl_data[index] - value

        if self.sl_data[index] <= 0 then
            self.sl_data[index] = nil
        end

        file.Write("sl_data/" .. self:SteamID64() .. "/inv.json", util.TableToJSON(self.sl_data))
    end
end

function plyMeta:SetDataItemSL_BANQUE(index, value)
    self:GetDataSL()

    if not self:Verif_InvFull_Banque() then
        self.sl_data7[index] = 0

        file.Write("sl_data/" .. self:SteamID64() .. "/inv_banque.json", util.TableToJSON(self.sl_data7))
    end
end

function plyMeta:HasSkill(skillName)
    self:GetDataSL()

    if self.sl_data4[skillName] == nil or self.sl_data4[skillName] <= 0 then 
        return false 
    else
        return true 
    end
end

function plyMeta:AddDataSkillsSL(index, value)
    self:GetDataSL()

    if not self.sl_data4[index] then
        self.sl_data4[index] = value
    else
        self.sl_data4[index] = self.sl_data4[index] + value
    end

    file.Write("sl_data/" .. self:SteamID64() .. "/skills.json", util.TableToJSON(self.sl_data4))
end

function plyMeta:ResetDataSkillsSL(index, value)
    self:GetDataSL()

    file.Write("sl_data/" .. self:SteamID64() .. "/skills.json", "{}")
end

function plyMeta:RemoveDataItemSL_INV(index, value)
    self:GetDataSL()
    self.sl_data[index] = self.sl_data[index] - value
    file.Write("sl_data/"..self:SteamID64() .."/inv.json", util.TableToJSON(self.sl_data))
end

function plyMeta:ActualiseClient_SL()

    self:GetDataSL()

    net.Start( "SL:sendservertoclientdata" )
    net.WriteTable(self.sl_data)
    net.Send(self)

    net.Start( "SL:sendservertoclientdata_stats" )
    net.WriteFloat(self.sl_data2["pts"])
    net.WriteFloat(self.sl_data2["rerollstats"])
    net.WriteFloat(self.sl_data2["force"])
    net.WriteFloat(self.sl_data2["agilite"])
    net.WriteFloat(self.sl_data2["sens"])
    net.WriteFloat(self.sl_data2["vitalite"])
    net.WriteFloat(self.sl_data2["intelligence"])
    net.Send(self)

    net.Start( "SL:sendservertoclientdata_rerolls" )
    net.WriteFloat(self.sl_data3["classe"])
    net.WriteFloat(self.sl_data3["magie"])
    net.WriteFloat(self.sl_data3["rang"])
    net.Send(self)

    net.Start( "SL:sendservertoclientdata_skills" )
    net.WriteTable(self.sl_data4)
    net.Send(self)

    net.Start( "SL:sendservertoclientdata_inv_equip" )
    net.WriteTable(self.sl_data5)
    net.Send(self)

    local filePath = "sl_data/" .. self:SteamID64() .. "/inv_banque.json"
    if file.Exists(filePath, "DATA") then
        net.Start( "SL:sendservertoclientdata_inv_banque" )
        net.WriteTable(self.sl_data7)
        net.Send(self)
    end

end

function plyMeta:Mad_SetAnim( seq )
    net.Start("SL:Anim_Play")
    net.WriteEntity( self )
    net.WriteString( seq )
    net.Broadcast()
end

if SERVER then
    util.AddNetworkString("SetCosmetiqueArme")
    util.AddNetworkString("DeleteComestiqueData")

    local function WriteModelToFile(steamid64, modelPath)
        local dir = "sl_data/" .. steamid64
        if not file.IsDir(dir, "DATA") then
            file.CreateDir(dir)
        end
        local filePath = dir .. "/comestique.json"
        local data = util.TableToJSON({modelPath})
        file.Write(filePath, data)

        local filePath = "sl_data/" .. steamid64 .. "/comestique.json"
        local data = file.Read(filePath, "DATA")
        local modelTable = util.JSONToTable(data)
        player.GetBySteamID64(steamid64):SetNWString("CosmetiqueArme", modelTable[1])
    end

    local function DeleteComestiqueData(steamid64)
        local filePath = "sl_data/" .. steamid64 .. "/comestique.json"
        if file.Exists(filePath, "DATA") then
            file.Delete(filePath)
            player.GetBySteamID64(steamid64):SetNWString("CosmetiqueArme", "RIEN")
        end
    end

    net.Receive("SetCosmetiqueArme", function(len, ply)
        if not ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "Responsable" then return end

        local steamid64 = net.ReadString()
        local modelPath = net.ReadString()

        WriteModelToFile(steamid64, modelPath)
    end)

    net.Receive("DeleteComestiqueData", function(len, ply)
        if not ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "Responsable" then return end

        local steamid64 = net.ReadString()
        
        DeleteComestiqueData(steamid64)
    end)

    hook.Add("PlayerSpawn", "SetCosmetiqueArmeOnSpawn", function(ply)
        local steamid64 = ply:SteamID64()
        local filePath = "sl_data/" .. steamid64 .. "/comestique.json"
        if file.Exists(filePath, "DATA") then
            local data = file.Read(filePath, "DATA")
            local modelTable = util.JSONToTable(data)
            if modelTable and modelTable[1] then
                ply:SetNWString("CosmetiqueArme", modelTable[1])
            else
                ply:SetNWString("CosmetiqueArme", "RIEN")
            end
        else
            ply:SetNWString("CosmetiqueArme", "RIEN")
        end
    end)
end

if SERVER then
    util.AddNetworkString("SetPMPERSO")
    util.AddNetworkString("DeletePMPERSOData")

    local function WriteModelToFile(steamid64, modelPath)
        local dir = "sl_data/" .. steamid64
        if not file.IsDir(dir, "DATA") then
            file.CreateDir(dir)
        end
        local filePath = dir .. "/PMPERSO.json"
        local data = util.TableToJSON({modelPath})
        file.Write(filePath, data)

        local filePath = "sl_data/" .. steamid64 .. "/PMPERSO.json"
        local data = file.Read(filePath, "DATA")
        local modelTable = util.JSONToTable(data)
        player.GetBySteamID64(steamid64):SetNWString("PMPERSO", modelTable[1])
    end

    local function DeletePMPERSOData(steamid64)
        local filePath = "sl_data/" .. steamid64 .. "/pmperso.json"
        if file.Exists(filePath, "DATA") then
            file.Delete(filePath)
            player.GetBySteamID64(steamid64):SetNWString("PMPERSO", "RIEN")
        end
    end

    net.Receive("SetPMPERSO", function(len, ply)
        if not ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "Responsable" then return end

        local steamid64 = net.ReadString()
        local modelPath = net.ReadString()

        WriteModelToFile(steamid64, modelPath)
    end)

    net.Receive("DeletePMPERSOData", function(len, ply)
        if not ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "Responsable" then return end

        local steamid64 = net.ReadString()
        
        DeletePMPERSOData(steamid64)
    end)

    hook.Add("PlayerSpawn", "SetPMPERSOOnSpawn", function(ply)
        local steamid64 = ply:SteamID64()
        local filePath = "sl_data/" .. steamid64 .. "/PMPERSO.json"
        if file.Exists(filePath, "DATA") then
            local data = file.Read(filePath, "DATA")
            local modelTable = util.JSONToTable(data)
            if modelTable and modelTable[1] then
                ply:SetNWString("PMPERSO", modelTable[1])
            else
                ply:SetNWString("PMPERSO", "RIEN")
            end
        else
            ply:SetNWString("PMPERSO", "RIEN")
        end
    end)
end

util.AddNetworkString("AssignTitle")

net.Receive("AssignTitle", function(len, ply)
    if (ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "Responsable") then
        local titleName = net.ReadString()
        local playerSteamID64 = net.ReadString()
        local filePath = "sl_data/" .. playerSteamID64 .. "/titre.json"

        if file.Exists(filePath, "DATA") then
            local data = util.JSONToTable(file.Read(filePath, "DATA"))
            data.titre = titleName
            file.Write(filePath, util.TableToJSON(data, true))
        else
            file.Write(filePath, util.TableToJSON({titre = titleName}, true))
        end

        ply:ChatPrint("Titre attribué avec succès.")
    else
        print(ply:Nick() "a essayer d'accéder au menu titre.")
    end
end)

util.AddNetworkString("CKPlayer")

local function DeleteDirectoryRecursive(path)
    local files, directories = file.Find(path .. "*", "DATA")
    
    for _, fileName in ipairs(files) do
        file.Delete(path .. fileName)
    end
    
    for _, dirName in ipairs(directories) do
        DeleteDirectoryRecursive(path .. dirName .. "/")
    end
    
    if file.Exists(path, "DATA") then
        file.Delete(path)
    end
end

net.Receive("CKPlayer", function(len, ply)
    if (ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "Responsable") then
        local playerSteamID64 = net.ReadString()
        local folderPath = "sl_data/" .. playerSteamID64 .. "/"

        if file.Exists(folderPath, "DATA") then
            DeleteDirectoryRecursive(folderPath)
            
            ply:ChatPrint("Dossier du joueur supprimé avec succès.")
        else
            ply:ChatPrint("Le dossier du joueur n'existe pas.")
        end

        local sl_data2 = util.TableToJSON(initsl_data2)
        local sl_data3 = util.TableToJSON(initsl_data3)
        if not file.Exists("sl_data/" .. playerSteamID64, "DATA") then
            file.CreateDir("sl_data/" .. playerSteamID64)
        end

        local save_points = player.GetBySteamID64( playerSteamID64 ).sl_data2["pts"] + player.GetBySteamID64( playerSteamID64 ).sl_data2["force"] + player.GetBySteamID64( playerSteamID64 ).sl_data2["agilite"] + player.GetBySteamID64( playerSteamID64 ).sl_data2["sens"] + player.GetBySteamID64( playerSteamID64 ).sl_data2["vitalite"] + player.GetBySteamID64( playerSteamID64 ).sl_data2["intelligence"] 

        file.Write("sl_data/" .. playerSteamID64 .. "/binds_save.json", "{}")
        file.Write("sl_data/" .. playerSteamID64 .. "/inv.json", "{}")
        file.Write("sl_data/" .. playerSteamID64 .. "/inv_equip.json", "{}")
        file.Write("sl_data/" .. playerSteamID64 .. "/inv_banque.json", "{}")
        file.Write("sl_data/" .. playerSteamID64 .. "/skills.json", "{}")
        file.Write("sl_data/" .. playerSteamID64 .. "/titre.json", "{}")
        file.Write("sl_data/" .. playerSteamID64 .. "/stats.json", sl_data2)
        file.Write("sl_data/" .. playerSteamID64 .. "/rerolls.json", sl_data3)

        player.GetBySteamID64( playerSteamID64 ):addMoney(-player.GetBySteamID64( playerSteamID64 ):getDarkRPVar("money") + 500000)

        player.GetBySteamID64( playerSteamID64 ):setLevel(0)
        player.GetBySteamID64( playerSteamID64 ):setXP(0)
        player.GetBySteamID64( playerSteamID64 ):KillSilent()
        player.GetBySteamID64( playerSteamID64 ):Spawn()
        timer.Simple(1, function()
            player.GetBySteamID64( playerSteamID64 ):ConCommand("sl_charactercreator")
            player.GetBySteamID64( playerSteamID64 ):AddPts(save_points-5)
        end)

    else
        print(ply:Nick() "a essayer d'accéder au menu CK.")
    end
end)

net.Receive("GiveSelectedSkill", function(len, ply)
    if not (ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "Responsable") then return end    
    local playerSteamID64 = net.ReadString()
    local skill = net.ReadString()
    local player = player.GetBySteamID64( playerSteamID64 )
    local playerClass = player:GetNWInt("Classe")
    local playerLevel = player:getDarkRPVar("level")

    local selectedSkill = skill
    local selectedSkillData = nil
    for skillName, skillData in pairs(SKILLS_SL) do
        if string.find(skill, skillData.name) then
            selectedSkill = skillName
            selectedSkillData = skillData

            if player:HasSkill(skillName) == true then
                ply:ChatPrint("Cette personne posséde déjà ce skill !")
                return
            elseif playerLevel <= skillData.level then
                ply:ChatPrint("Cette personne n'est pas du bon niveau !")
                return
            elseif playerClass ~= skillData.classe then
                ply:ChatPrint("Cette personne n'est pas de la bonne classe !")
                return
            elseif skillData.element ~= "none" then
                if player:GetNWInt("Magie") ~= skillData.element then
                    ply:ChatPrint("Cette personne n'a pas la bonne magie !")
                    return
                end
            end
        end
    end

    local skillData = SKILLS_SL[selectedSkill]

    if skillData then
        player:AddDataSkillsSL(selectedSkill, skillData.level)
        net.Start("SL:Notification")
        net.WriteString("Vous avez obtenu le skill : "..skillData.name)
        net.Send(player)
        ply:ChatPrint("Technique " .. skillData.name .. " ajoutée avec succès à " .. player:Nick())
    end
end)

util.AddNetworkString("GiveSelectedSkill")

net.Receive("GiveRandomSkill", function(len, ply)
    if not (ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "Responsable") then return end    
    local playerSteamID64 = net.ReadString()
    local player = player.GetBySteamID64( playerSteamID64 )
    local playerClass = player:GetNWInt("Classe")
    local playerLevel = player:getDarkRPVar("level")
    local availableSkills = {} 
    for skillName, skillData in pairs(SKILLS_SL) do
        if skillData.classe == playerClass and playerLevel >= skillData.level and player:HasSkill(skillName) == false then
            if skillData.ismagie == false then
                table.insert(availableSkills, skillName)
            elseif skillData.ismagie == true then
                if player:GetNWInt("Magie") == skillData.element then
                    table.insert(availableSkills, skillName)
                end
            end
        end
    end

    local randomSkill = availableSkills[math.random(#availableSkills)]
    local skillData = SKILLS_SL[randomSkill]

    if skillData then
        player:AddDataSkillsSL(randomSkill, skillData.level)
        net.Start("SL:Notification")
        net.WriteString("Vous avez obtenu le skill : "..skillData.name)
        net.Send(player)
        ply:ChatPrint("Technique " .. skillData.name .. " ajoutée avec succès à " .. player:Nick())
    end
end)

util.AddNetworkString("GiveRandomSkill")

if SERVER then
    concommand.Add("machine_addreroll", function(ply, cmd, args)
        if ply:IsPlayer() then
            ply:ChatPrint("Cette commande est réservée à la console du serveur.")
            return
        end

        if #args < 3 then
            print("Usage: machine_addreroll <steamid64> <type> <nombre>")
            return
        end

        local steamid64 = args[1] 
        local rerollType = args[2]:lower()
        local rerollCount = tonumber(args[3]) 

        -- if not string.match(steamid64, "^%d+$") then
        --     print("Erreur: SteamID64 invalide.")
        --     return
        -- end
 
        if rerollType ~= "magie" and rerollType ~= "rang" and rerollType ~= "classe" then
            print("Erreur: Type de reroll invalide. Choisissez parmi 'magie', 'rang', ou 'classe'.")
            return
        end

        if not rerollCount or rerollCount <= 0 then
            print("Erreur: Le nombre doit être un entier positif.")
            return
        end 

        local targetPlayer = nil
        for _, v in ipairs(player.GetAll()) do
            if v:SteamID() == steamid64 then
                targetPlayer = v
                break
            end
        end

        if not targetPlayer then
            print("Erreur: Aucun joueur avec ce SteamID64 trouvé sur le serveur.")
            return
        end

        if rerollType == "magie" then
            targetPlayer:AddRerollMagie(rerollCount)
        elseif rerollType == "rang" then
            targetPlayer:AddRerollRang(rerollCount)
        elseif rerollType == "classe" then
            targetPlayer:AddRerollClasse(rerollCount)
        end

        print("Reroll de type '" .. rerollType .. "' effectué avec succès pour " .. steamid64 .. " (" .. rerollCount .. ").")
    end)
end




net.Receive("GiveAllSkill", function(len, ply)
    if not (ply:GetUserGroup() == "superadmin" or ply:GetUserGroup() == "Responsable") then return end    
    local playerSteamID64 = net.ReadString()
    local player = player.GetBySteamID64(playerSteamID64)
    local playerClass = player:GetNWInt("Classe")

    if not ply then
        print("Vous ne pouvez pas utiliser cette commande via la console.")
        return
    end

    if not player then
        ply:ChatPrint("Erreur: Joueur non trouvé avec ce SteamID64.")
        return
    end

    local skills = {}
    
    for skillName, skillData in pairs(SKILLS_SL) do
        if player:HasSkill(skillName) then
            ply:ChatPrint("Cette personne posséde le skill " .. skillData.name .. " !")
            continue
        end

        if playerClass == "mage" then
            if player:GetNWInt("Magie") == skillData.element and skillData.ismagie then
                table.insert(skills, skillName)
            end
        end

        if playerClass == skillData.classe then
            if not skillData.ismagie and skillData.element == "none" then
                table.insert(skills, skillName)
            end
        end
    end

    for _, skillName in ipairs(skills) do
        local skillData = SKILLS_SL[skillName]
        if skillData then
            player:AddDataSkillsSL(skillName, skillData.level)
            net.Start("SL:Notification")
            net.WriteString("Vous avez obtenu le skill : " .. skillData.name)
            net.Send(player)
            ply:ChatPrint("Technique " .. skillData.name .. " ajoutée avec succès à " .. player:Nick())
        end
    end
end)

util.AddNetworkString("GiveAllSkill")

concommand.Add("resetallskills", function(ply, cmd, args)
    if ply:IsPlayer() then
        ply:ChatPrint("Cette commande est réservée à la console du serveur.")
        return
    end

    local playerr = args[1]

    if not playerr then
        print("[OKIRO - CONSOLE] Vous devez spécifier un joueur.")
        return
    end

    for _, v in pairs(player.GetAll()) do
        if v:SteamID64() == playerr then
            playerr = v
            break
        end
    end

    playerr:ResetDataSkillsSL()
    print("[OKIRO - CONSOLE] Tous les skills de " .. playerr:Nick() .. " ont été reset.")
    playerr:ChatPrint("Tous vos skills ont été reset, si vous avez un soucis concernant ce reset, veuillez faire un ticket sur le Discord.")
end)