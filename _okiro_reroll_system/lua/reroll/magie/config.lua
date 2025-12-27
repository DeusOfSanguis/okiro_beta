MagieReroll.Config.Command = 'magiereroll' 
MagieReroll.Config.DownloadFiles = true 

MagieReroll.Config.BackButtonFunction = function()
    OpenF4Menu()
end

MagieReroll.Config.Rarities = {
    ['Common'] = Color(200, 200, 200, 150),
    ['Uncommon'] = Color(75, 105, 255, 150),
    ['Rare'] = Color(100, 175, 255, 150),
    ['Mythical'] = Color(135, 50, 205, 150),
    ['Legendary'] = Color(255, 215, 0, 150),
    ['Ancient'] = Color(255, 80, 0, 150),
    ['Divine'] = Color(255, 0, 80, 150)
}

MagieReroll.UI.Config = {
    colors = {
        white = Color( 255, 255, 255 );
        main = Color( 219, 227, 255 );
        hover = Color( 219, 227, 255, 100 );
    };

    mats = {
        bg = Material( 'okiro/sincopa/reroll/magie/bg.png', 'smooth mips' );
        coin = Material( 'okiro/sincopa/reroll/coin.png', 'smooth mips' );
        back = Material( 'okiro/sincopa/reroll/back.png', 'smooth mips' );
    };
}
MagieReroll.Config.Items = {
    {
        name = 'Feu', 
        rarity = 'Common',
        icon = 'okiro/sincopa/reroll/magie/fire.png', 
        chance = 50,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "feu")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "feu")
                end
                
                ply:SetNWString("Magie", "feu")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la magie: Feu")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Terre',
        rarity = 'Common',
        icon = 'okiro/sincopa/reroll/magie/rock.png',
        chance = 25, 
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "terre")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "terre")
                end
                
                ply:SetNWString("Magie", "terre")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la magie: Terre")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Vent',
        rarity = 'Common',
        icon = 'okiro/sincopa/reroll/magie/wind.png',
        chance = 12,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "air")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "air")
                end
                
                ply:SetNWString("Magie", "air")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la magie: Air")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Eau',
        rarity = 'Uncommon',
        icon = 'okiro/sincopa/reroll/magie/water.png',
        chance = 12,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "eau")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "eau")
                end
                
                ply:SetNWString("Magie", "eau")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la magie: Eau")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Foudre',
        rarity = 'Rare',
        icon = 'okiro/sincopa/reroll/magie/flash.png',
        chance = 2,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "foudre")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "foudre")
                end
                
                ply:SetNWString("Magie", "foudre")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la magie: Foudre")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Glace',
        rarity = 'Rare',
        icon = 'okiro/sincopa/reroll/magie/ice.png',
        chance = 0.5,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "glace")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "glace")
                end
                
                ply:SetNWString("Magie", "glace")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la magie: Glace")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Lumiere',
        rarity = 'Legendary',
        icon = 'okiro/sincopa/reroll/magie/star.png',
        chance = 0.499,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "lumiere")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "lumiere")
                end
                
                ply:SetNWString("Magie", "lumiere")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la magie: Lumière")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        name = 'Tenebres',
        rarity = 'Legendary',
        icon = 'okiro/sincopa/reroll/magie/moon.png',
        chance = 0.001,
        func = function(ply)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "tenebre")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/magie.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/magie.json", "tenebre")
                end
                
                ply:SetNWString("Magie", "tenebre")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la magie: Ténèbres")
                
                ply:ActualiseClient_SL()
            end
        end
    },
}

function MagieReroll.GetRarityColor(rarity)
    return MagieReroll.Config.Rarities[rarity] or color_white
end

function MagieReroll.CanAfford(ply)
    return (sl_data3["magie"] or 0) >= 1
end