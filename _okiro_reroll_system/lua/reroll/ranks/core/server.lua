local util_AddNetworkString = util.AddNetworkString
local ipairs = ipairs
local math_random = math.random
local concommand_Add = concommand.Add
local IsValid = IsValid
local net_Start = net.Start
local net_Send = net.Send
local net_Receive = net.Receive
local table_insert = table.insert
local table_Copy = table.Copy
local net_WriteTable = net.WriteTable
local net_WriteInt = net.WriteInt
local timer_Simple = timer.Simple

util_AddNetworkString('MagieRanks_OpenMenu')
util_AddNetworkString('MagieRanks_DoReroll')
util_AddNetworkString('MagieRanks_SendResult')

local function GetRandomItem()
    local totalChance = 0
    for _, item in ipairs(MagieReroll.Ranks.Items) do
        totalChance = totalChance + (item.chance or 1)
    end
    
    local randomNum = math_random(1, totalChance)
    local currentChance = 0
    
    for _, item in ipairs(MagieReroll.Ranks.Items) do
        currentChance = currentChance + (item.chance or 1)
        if randomNum <= currentChance then
            return item
        end
    end
    
    return MagieReroll.Ranks.Items[1]
end

local function CleanItemForNetworking(item)
    local cleanItem = {
        name = item.name,
        rarity = item.rarity,
        icon = item.icon
    }
    return cleanItem
end

local function GenerateRerollItems(count)
    local items = {}
    for i = 1, count do
        local randomIndex = math_random(1, #MagieReroll.Ranks.Items)
        items[i] = CleanItemForNetworking(MagieReroll.Ranks.Items[randomIndex])
    end
    return items
end

concommand_Add(MagieReroll.Ranks.Config.Command, function(ply)
    if not IsValid(ply) then return end
    net_Start('MagieRanks_OpenMenu')
    net_Send(ply)
end)

net_Receive('MagieRanks_DoReroll', function(_, ply)
    if not IsValid(ply) then return end
    
    if (ply.sl_data3["rang"] or 0) < 1 then 
        DarkRP.notify(ply, 1, 5, 'ERREUR: Vous n\'avez pas de rerolls de rang.')
        return 
    end
    
    ply:RemoveRerollRang(1)
    
    local winItem = GetRandomItem()
    local winItemClean = CleanItemForNetworking(winItem)
    
    local itemCount = math_random(30, 40)
    local rerollItems = GenerateRerollItems(itemCount)
    
    for i = 1, 3 do
        local randomPos = math_random(1, #rerollItems)
        table_insert(rerollItems, randomPos, table_Copy(winItemClean))
    end
    
    table_insert(rerollItems, winItemClean)
    
    net_Start('MagieRanks_SendResult')
        net_WriteTable(rerollItems)
        net_WriteTable(winItemClean)
        net_WriteInt(#rerollItems, 16)
    net_Send(ply)
    
    timer_Simple(5.5, function()
        if IsValid(ply) then
            winItem.func(ply)
        end
    end)
end)