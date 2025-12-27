-- LOTM Keybind System - Server
-- Серверная часть системы кейбиндов

util.AddNetworkString("LOTM_SaveKeybinds")
util.AddNetworkString("LOTM_RequestKeybinds")
util.AddNetworkString("LOTM_SendKeybinds")

LOTM.Keybinds = LOTM.Keybinds or {}
LOTM.PlayerKeybinds = LOTM.PlayerKeybinds or {}

--[[------------------------------------
    Сохранение кейбиндов игрока
--------------------------------------]]
function LOTM.Keybinds:SavePlayerBinds(ply, keybinds)
    if not IsValid(ply) then return end
    
    local steamID = ply:SteamID()
    self.PlayerKeybinds[steamID] = keybinds
    
    -- Сохранение в базу данных (можно использовать SQL или PData)
    ply:SetPData("lotm_keybinds", util.TableToJSON(keybinds))
end

--[[------------------------------------
    Загрузка кейбиндов игрока
--------------------------------------]]
function LOTM.Keybinds:LoadPlayerBinds(ply)
    if not IsValid(ply) then return nil end
    
    local steamID = ply:SteamID()
    
    -- Попытка загрузки из кеша
    if self.PlayerKeybinds[steamID] then
        return self.PlayerKeybinds[steamID]
    end
    
    -- Загрузка из PData
    local data = ply:GetPData("lotm_keybinds", "")
    if data != "" then
        local keybinds = util.JSONToTable(data)
        self.PlayerKeybinds[steamID] = keybinds
        return keybinds
    end
    
    -- Возврат дефолтных значений
    return table.Copy(LOTM.Config.Keybinds.Defaults)
end

-- Обработка запроса кейбиндов от клиента
net.Receive("LOTM_RequestKeybinds", function(len, ply)
    local keybinds = LOTM.Keybinds:LoadPlayerBinds(ply)
    
    net.Start("LOTM_SendKeybinds")
        net.WriteTable(keybinds)
    net.Send(ply)
end)

-- Обработка сохранения кейбиндов от клиента
net.Receive("LOTM_SaveKeybinds", function(len, ply)
    local keybinds = net.ReadTable()
    LOTM.Keybinds:SavePlayerBinds(ply, keybinds)
end)

-- Загрузка при подключении
hook.Add("PlayerInitialSpawn", "LOTM_LoadKeybinds", function(ply)
    timer.Simple(1, function()
        if IsValid(ply) then
            local keybinds = LOTM.Keybinds:LoadPlayerBinds(ply)
            
            net.Start("LOTM_SendKeybinds")
                net.WriteTable(keybinds)
            net.Send(ply)
        end
    end)
end)