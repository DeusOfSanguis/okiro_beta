CardShuffle.Config.AnimationSpeed = 0.5
CardShuffle.Config.Command = 'cardshuffle'

CardShuffle.Config.BackButtonFunction = function()
    OpenF4Menu()
end

CardShuffle.Config.UI = {
    mats = {
        bg = Material( 'okiro/sincopa/reroll/shaffle/bg.png', 'smooth mips' );
        coin = MagieReroll.UI.Config.mats.coin;
        back = MagieReroll.UI.Config.mats.back;
        card = Material( 'okiro/sincopa/reroll/shaffle/unknown.png', 'smooth mips' );
    };

    colors = {
        white = Color( 255, 255, 255 );
        main = Color( 219, 227, 255 );
        hover = Color( 219, 227, 255, 100 );
    };
}

CardShuffle.Config.Sounds = {
    Open = 'ui/card_flip.wav',
    Win = 'ui/win.wav'
}

CardShuffle.Config.Rarities = {
    ['COMMUN'] = {
        Color = Color(143, 143, 143),
        Chance = 70 
    },

    ['RARE'] = {
        Color = Color(0, 81, 255),
        Chance = 20
    },

    ['ÉPIQUE'] = {
        Color = Color(191, 0, 255),
        Chance = 7
    },

    ['LEGENDAIRE'] = {
        Color = Color(255, 166, 0),
        Chance = 2.9
    },

    ['MYTHIQUE'] = {
        Color = Color(255, 0, 0),
        Chance = 0.099
    },

    ['UNIQUE'] = {
        Color = Color(87, 97, 205),
        Chance = 0.001
    }
}

CardShuffle.Config.Rewards = {
    {
        Name = 'PORTEUR',
        Icon = 'okiro/sincopa/reroll/shaffle/porteur.png',
        Rarity = 'COMMUN',
        Func = function(ply, reward)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "porteur")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "porteur")
                end
                
                ply:SetNWString("Classe", "porteur")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la classe: Porteur")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        Name = 'EPEISTE',
        Icon = 'okiro/sincopa/reroll/shaffle/epeiste.png',
        Rarity = 'COMMUN',
        Func = function(ply, reward)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "epeiste")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "epeiste")
                end
                
                ply:SetNWString("Classe", "epeiste")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la classe: Epeiste")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        Name = 'HEALER',
        Icon = 'okiro/sincopa/reroll/shaffle/healer.png',
        Rarity = 'COMMUN',
        Func = function(ply, reward)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "healer")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "healer")
                end
                
                ply:SetNWString("Classe", "healer")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la classe: Healer")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        Name = 'TANK',
        Icon = 'okiro/sincopa/reroll/shaffle/recto.png',
        Rarity = 'RARE',
        Func = function(ply, reward)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "tank")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "tank")
                end
                
                ply:SetNWString("Classe", "tank")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la classe: Tank")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        Name = 'ASSASSIN',
        Icon = 'okiro/sincopa/reroll/shaffle/assassin.png',
        Rarity = 'ÉPIQUE',
        Func = function(ply, reward)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "assassin")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "assassin")
                end
                
                ply:SetNWString("Classe", "assassin")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la classe: Assassin")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        Name = 'MAGE',
        Icon = 'okiro/sincopa/reroll/shaffle/mage.png',
        Rarity = 'LEGENDAIRE',
        Func = function(ply, reward)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "mage")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "mage")
                end
                
                ply:SetNWString("Classe", "mage")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la classe: Mage")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        Name = 'INVOCATEUR',
        Icon = 'okiro/sincopa/reroll/shaffle/invocateur.png',
        Rarity = 'MYTHIQUE',
        Func = function(ply, reward)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "invocateur")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "invocateur")
                end
                
                ply:SetNWString("Classe", "invocateur")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la classe: Invocateur")
                
                ply:ActualiseClient_SL()
            end
        end
    },
    {
        Name = 'BESTIAL',
        Icon = 'okiro/sincopa/reroll/shaffle/bestial.png',
        Rarity = 'UNIQUE',
        Func = function(ply, reward)
            if SERVER then
                if not (IsValid(ply) and ply:IsPlayer()) then return end
                
                if not file.Exists("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA") then
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "bestial")
                else
                    file.Delete("sl_data/" .. ply:SteamID64() .. "/classe.json", "DATA")
                    file.Write("sl_data/" .. ply:SteamID64() .. "/classe.json", "bestial")
                end
                
                ply:SetNWString("Classe", "bestial")
                
                DarkRP.notify(ply, 0, 5, "Vous avez obtenu la classe: Bestial")
                
                ply:ActualiseClient_SL()
            end
        end
    }
}

function CardShuffle.GetRarityColor(rarityName)
    local rarity = CardShuffle.Config.Rarities[rarityName]
    return rarity and rarity.Color or color_white
end

function CardShuffle.GetRandomReward()
    local totalChance = 0
    
    for _, rarity in pairs(CardShuffle.Config.Rarities) do
        totalChance = totalChance + rarity.Chance
    end
    
    if totalChance <= 0 then
        return CardShuffle.Config.Rewards[1]
    end
    
    local rand = math.random(1, totalChance)
    local currentSum = 0
    local selectedRarity = nil
    
    for rarityName, rarity in pairs(CardShuffle.Config.Rarities) do
        currentSum = currentSum + rarity.Chance
        if rand <= currentSum then
            selectedRarity = rarityName
            break
        end
    end
    
    if not selectedRarity then
        local firstRarity = next(CardShuffle.Config.Rarities)
        if firstRarity then
            selectedRarity = firstRarity
        else
            return CardShuffle.Config.Rewards[1]
        end
    end
    
    local possibleRewards = {}
    
    for _, reward in ipairs(CardShuffle.Config.Rewards) do
        if reward.Rarity == selectedRarity then
            table.insert(possibleRewards, reward)
        end
    end
    
    if #possibleRewards == 0 then
        if #CardShuffle.Config.Rewards > 0 then
            return CardShuffle.Config.Rewards[math.random(1, #CardShuffle.Config.Rewards)]
        else
            return {
                Name = 'Reward',
                Icon = 'icon16/money.png',
                Rarity = 'COMMUN',
                Func = function(ply) 
                    if SERVER and DarkRP and ply.addMoney then 
                        ply:ChatPrint( 'Nothing!' )
                    end 
                end
            }
        end
    end
    
    return possibleRewards[math.random(1, #possibleRewards)]
end