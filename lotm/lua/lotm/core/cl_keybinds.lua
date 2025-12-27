-- LOTM Keybind System - Client
-- Клиентская обработка кейбиндов

LOTM.Keybinds = LOTM.Keybinds or {}
LOTM.CurrentKeybinds = LOTM.CurrentKeybinds or table.Copy(LOTM.Config.Keybinds.Defaults)

--[[------------------------------------
    Запрос кейбиндов с сервера
--------------------------------------]]
function LOTM.Keybinds:Request()
    net.Start("LOTM_RequestKeybinds")
    net.SendToServer()
end

--[[------------------------------------
    Сохранение кейбиндов на сервер
--------------------------------------]]
function LOTM.Keybinds:Save(keybinds)
    self.CurrentKeybinds = keybinds
    
    net.Start("LOTM_SaveKeybinds")
        net.WriteTable(keybinds)
    net.SendToServer()
end

--[[------------------------------------
    Получение текущего бинда
--------------------------------------]]
function LOTM.Keybinds:Get(bindName)
    return self.CurrentKeybinds[bindName] or KEY_NONE
end

--[[------------------------------------
    Установка бинда
--------------------------------------]]
function LOTM.Keybinds:Set(bindName, key)
    self.CurrentKeybinds[bindName] = key
end

-- Получение кейбиндов с сервера
net.Receive("LOTM_SendKeybinds", function()
    LOTM.CurrentKeybinds = net.ReadTable()
end)

-- Обработка нажатий клавиш
hook.Add("PlayerButtonDown", "LOTM_HandleKeybinds", function(ply, button)
    if not IsFirstTimePredicted() then return end
    
    -- Открытие меню кейбиндов
    if button == LOTM.Config.Keybinds.MenuKey then
        LOTM.UI.OpenKeybindMenu()
        return
    end
    
    -- Способности 1-5
    for i = 1, 5 do
        if button == LOTM.Keybinds:Get("Ability" .. i) then
            LOTM.Abilities:UseAbility(i)
            return
        end
    end
    
    -- Третье лицо
    if button == LOTM.Keybinds:Get("ThirdPerson") then
        RunConsoleCommand("lotm_thirdperson")
        return
    end
    
    -- Аура
    if button == LOTM.Keybinds:Get("Aura") then
        RunConsoleCommand("lotm_toggle_aura")
        return
    end
    
    -- Артефакты
    if button == LOTM.Keybinds:Get("Artifacts") then
        RunConsoleCommand("lotm_open_artifacts")
        return
    end
end)

-- Запрос кейбиндов при загрузке
hook.Add("InitPostEntity", "LOTM_RequestKeybinds", function()
    timer.Simple(1, function()
        LOTM.Keybinds:Request()
    end)
end)