local util_AddNetworkString = util.AddNetworkString
local IsValid = IsValid
local table_insert = table.insert
local CurTime = CurTime
local net_Start = net.Start
local net_Send = net.Send
local net_Receive = net.Receive
local net_ReadUInt = net.ReadUInt
local net_WriteUInt = net.WriteUInt
local net_WriteString = net.WriteString
local timer_Simple = timer.Simple
local concommand_Add = concommand.Add
local hook_Add = hook.Add

util_AddNetworkString('CardShuffle_OpenMenu')
util_AddNetworkString('CardShuffle_SelectCard')
util_AddNetworkString('CardShuffle_RevealResult')

local math_random = math.random
local table_insert = table.insert

local playerSessions = {}

util_AddNetworkString('CardShuffle_DoReroll')

net_Receive('CardShuffle_DoReroll', function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then 
        return 
    end
    
    if ply.sl_data3["classe"] < 1 then 
        DarkRP.notify(ply, 1, 5, 'ERREUR: Vous n\'avez pas de rerolls de classe.')
        return 
    end
    
    playerSessions[ply:SteamID()] = nil
    
    local rewards = {}
    for i = 1, 3 do
        local reward = CardShuffle.GetRandomReward()
        if not reward then
            reward = {
                Name = 'Reward',
                Icon = 'icon16/money.png',
                Rarity = 'COMMUN',
                Func = function(p) 
                    p:ChatPrint('Nothing!')
                end
            }
        end
        table_insert(rewards, reward)
    end
    
    playerSessions[ply:SteamID()] = {
        rewards = rewards,
        selectedCard = nil,
        timestamp = CurTime()
    }
    
    net_Start('CardShuffle_OpenMenu')
    net_Send(ply)
end)

util_AddNetworkString('CardShuffle_CloseMenu')

net_Receive('CardShuffle_CloseMenu', function(len, ply)
    if not IsValid(ply) then return end
    
    if playerSessions[ply:SteamID()] then
        playerSessions[ply:SteamID()] = nil
    end
end)

function CardShuffle.OpenMenu(ply)
    if not IsValid(ply) or not ply:IsPlayer() then 
        return 
    end
    
    if ply.sl_data3["classe"] < 1 then 
        DarkRP.notify(ply, 1, 5, 'ERREUR: Vous n\'avez pas de rerolls de classe.')
        return 
    end

    local rewards = {}
    for i = 1, 3 do
        local reward = CardShuffle.GetRandomReward()
        if not reward then
            reward = {
                Name = 'Reward',
                Icon = 'icon16/money.png',
                Rarity = 'COMMUN',
                Func = function(p) 
                    p:ChatPrint( 'Nothing!' )
                end
            }
        end
        table_insert(rewards, reward)
    end
    
    playerSessions[ply:SteamID()] = {
        rewards = rewards,
        selectedCard = nil,
        timestamp = CurTime()
    }
    
    net_Start('CardShuffle_OpenMenu')
    net_Send(ply)
end

net_Receive('CardShuffle_SelectCard', function(len, ply)
    local cardIndex = net_ReadUInt(4)
    
    if not IsValid(ply) or not ply:IsPlayer() or cardIndex < 1 or cardIndex > 3 then 
        return 
    end
    
    local session = playerSessions[ply:SteamID()]
    if not session then
        return
    end
    
    if session.selectedCard then
        return
    end
    
    session.selectedCard = cardIndex

    if ply.sl_data3["classe"] < 1 then 
        DarkRP.notify(ply, 1, 5, 'ERREUR: Vous n\'avez pas de rerolls de classe.')
        return 
    end
    
    ply:RemoveRerollClasse(1)
    
    local reward = session.rewards[cardIndex]
    
    net_Start('CardShuffle_RevealResult')
    net_WriteUInt(cardIndex, 4)
    
    for i = 1, 3 do
        local cardReward = session.rewards[i]
        net_WriteString(cardReward.Name or 'Unknown reward')
        net_WriteString(cardReward.Icon or 'icon16/help.png')
        net_WriteString(cardReward.Rarity or 'COMMUN')
    end
    
    net_Send(ply)
    
    if reward and reward.Func then
        reward.Func(ply, reward)
    end
    
    timer_Simple(10, function()
        playerSessions[ply:SteamID()] = nil
    end)
end)

concommand_Add( CardShuffle.Config.Command, function(ply)
    if not IsValid(ply) then return end
    CardShuffle.OpenMenu(ply)
end)

hook_Add('PlayerDisconnected', 'CardShuffle_CleanupSessions', function(ply)
    if playerSessions[ply:SteamID()] then
        playerSessions[ply:SteamID()] = nil
    end
end)

function CardShuffle.GiveCards(ply)
    if IsValid(ply) and ply:IsPlayer() then
        CardShuffle.OpenMenu(ply)
        return true
    end
    return false
end