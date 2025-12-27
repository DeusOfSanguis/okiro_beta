MagieReroll.Ranks.Config.Command = 'magieranks'

MagieReroll.Ranks.Config.BackButtonFunction = function()
    OpenF4Menu()
end

MagieReroll.Ranks.Rarities = MagieReroll.Config.Rarities

MagieReroll.Ranks.UI = {
    colors = MagieReroll.UI.Config.colors,
    mats = {
        bg = MagieReroll.UI.Config.mats.bg,
        coin = MagieReroll.UI.Config.mats.coin,
        back = MagieReroll.UI.Config.mats.back,
    }
}

MagieReroll.Ranks.Items = {
    {
        name = 'Rang E',
        rarity = 'Common',
        chance = 49.489,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "E")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "E")
                end
                
                ply:SetNWString("Rang", "E")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu le rang: E")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Rang D',
        rarity = 'Uncommon',
        chance = 30,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "D")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "D")
                end
                
                ply:SetNWString("Rang", "D")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu le rang: D")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Rang C',
        rarity = 'Rare',
        chance = 15,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "C")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "C")
                end
                
                ply:SetNWString("Rang", "C")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu le rang: C")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Rang B',
        rarity = 'Mythical',
        chance = 5,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "B")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "B")
                end
                
                ply:SetNWString("Rang", "B")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu le rang: B")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Rang A',
        rarity = 'Legendary',
        chance = 0.51,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "A")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "A")
                end
                
                ply:SetNWString("Rang", "A")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu le rang: A")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Rang S',
        rarity = 'Divine',
        chance = 0, 
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "S")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/rang.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/rang.json", "S")
                end
                
                ply:SetNWString("Rang", "S")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu le rang: S")
                
                ply:ActualiseClient_SL()
            end
        end
    }
}

function MagieReroll.Ranks.GetRarityColor(rarity)
    return MagieReroll.Ranks.Rarities[rarity] or color_white
end

function MagieReroll.Ranks.CanAfford(ply)
    if not sl_data3 then
        sl_data3 = {}
    end

    local rang = sl_data3["rang"] or 0
    return rang >= 1
end


function MagieReroll.Ranks.GetPreviewItems()
    local preview = {}
    
    for _, item in ipairs(MagieReroll.Ranks.Items) do
        table.insert(preview, {
            name = item.name,
            rarity = item.rarity,
            icon = item.icon
        })
    end
    
    for i = #preview, 2, -1 do
        local j = math.random(i)
        preview[i], preview[j] = preview[j], preview[i]
    end
    
    local extendedPreview = {}
    for i = 1, 3 do
        for _, item in ipairs(preview) do
            table.insert(extendedPreview, table.Copy(item))
        end
    end
    
    return extendedPreview
end