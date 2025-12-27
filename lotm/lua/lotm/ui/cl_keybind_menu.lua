-- LOTM Keybind Menu - Client
-- Интерфейс настройки кейбиндов

LOTM.UI = LOTM.UI or {}

local PANEL = {}
local currentlyBinding = nil
local tempKeybinds = {}

-- Названия кнопок для отображения
local keyNames = {
    [KEY_1] = "1", [KEY_2] = "2", [KEY_3] = "3", [KEY_4] = "4", [KEY_5] = "5",
    [KEY_Q] = "Q", [KEY_W] = "W", [KEY_E] = "E", [KEY_R] = "R", [KEY_T] = "T",
    [KEY_A] = "A", [KEY_S] = "S", [KEY_D] = "D", [KEY_F] = "F", [KEY_G] = "G",
    [KEY_Z] = "Z", [KEY_X] = "X", [KEY_C] = "C", [KEY_V] = "V", [KEY_B] = "B",
    [KEY_N] = "N", [KEY_M] = "M",
    [KEY_LSHIFT] = "L.Shift", [KEY_RSHIFT] = "R.Shift",
    [KEY_LCONTROL] = "L.Ctrl", [KEY_RCONTROL] = "R.Ctrl",
    [KEY_LALT] = "L.Alt", [KEY_RALT] = "R.Alt",
    [KEY_SPACE] = "Space", [KEY_ENTER] = "Enter",
    [MOUSE_LEFT] = "Mouse1", [MOUSE_RIGHT] = "Mouse2", [MOUSE_MIDDLE] = "Mouse3",
}

local function GetKeyName(key)
    return keyNames[key] or "Key " .. key
end

--[[------------------------------------
    Создание UI меню
--------------------------------------]]
function LOTM.UI.OpenKeybindMenu()
    if IsValid(PANEL.Frame) then
        PANEL.Frame:Remove()
        return
    end
    
    -- Копируем текущие бинды во временную таблицу
    tempKeybinds = table.Copy(LOTM.CurrentKeybinds)
    
    local scrW, scrH = ScrW(), ScrH()
    local width, height = 700, 500
    
    -- Основной фрейм
    PANEL.Frame = vgui.Create("DFrame")
    PANEL.Frame:SetSize(width, height)
    PANEL.Frame:SetPos((scrW - width) / 2, (scrH - height) / 2)
    PANEL.Frame:SetTitle("")
    PANEL.Frame:SetDraggable(true)
    PANEL.Frame:ShowCloseButton(false)
    PANEL.Frame:MakePopup()
    PANEL.Frame.Paint = function(self, w, h)
        -- Фон с градиентом
        draw.RoundedBox(8, 0, 0, w, h, Color(25, 25, 30, 250))
        draw.RoundedBox(8, 0, 0, w, 50, Color(35, 35, 45, 255))
        
        -- Заголовок
        draw.SimpleText("Keybinds Configuration", "DermaLarge", w / 2, 25, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        -- Декоративные линии
        surface.SetDrawColor(60, 60, 80, 255)
        surface.DrawLine(20, 55, w - 20, 55)
    end
    
    -- Кнопка закрытия
    local closeBtn = vgui.Create("DButton", PANEL.Frame)
    closeBtn:SetSize(30, 30)
    closeBtn:SetPos(width - 40, 10)
    closeBtn:SetText("")
    closeBtn.Paint = function(self, w, h)
        local col = self:IsHovered() and Color(220, 50, 50) or Color(180, 50, 50)
        draw.RoundedBox(4, 0, 0, w, h, col)
        draw.SimpleText("✕", "DermaDefault", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    closeBtn.DoClick = function()
        PANEL.Frame:Remove()
    end
    
    -- Скролл панель
    local scroll = vgui.Create("DScrollPanel", PANEL.Frame)
    scroll:SetPos(20, 70)
    scroll:SetSize(width - 40, height - 140)
    
    -- Стилизация скроллбара
    local sbar = scroll:GetVBar()
    sbar:SetWide(8)
    sbar.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(40, 40, 50))
    end
    sbar.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(80, 80, 100))
    end
    sbar.btnUp.Paint = function() end
    sbar.btnDown.Paint = function() end
    
    -- Определение категорий
    local categories = {
        {name = "Abilities", binds = {
            {id = "Ability1", label = "Ability Slot 1"},
            {id = "Ability2", label = "Ability Slot 2"},
            {id = "Ability3", label = "Ability Slot 3"},
            {id = "Ability4", label = "Ability Slot 4"},
            {id = "Ability5", label = "Ability Slot 5"},
        }},
        {name = "Controls", binds = {
            {id = "ThirdPerson", label = "Toggle Third Person"},
            {id = "Aura", label = "Toggle Aura"},
            {id = "Artifacts", label = "Open Artifacts Menu"},
        }}
    }
    
    local yOffset = 0
    
    -- Создание категорий
    for _, category in ipairs(categories) do
        -- Заголовок категории
        local catHeader = vgui.Create("DPanel", scroll)
        catHeader:SetPos(0, yOffset)
        catHeader:SetSize(width - 60, 35)
        catHeader.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(45, 45, 60, 200))
            draw.SimpleText(category.name, "DermaDefaultBold", 15, h / 2, Color(200, 200, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
        yOffset = yOffset + 40
        
        -- Создание кнопок для каждого бинда
        for _, bind in ipairs(category.binds) do
            local bindPanel = vgui.Create("DPanel", scroll)
            bindPanel:SetPos(10, yOffset)
            bindPanel:SetSize(width - 80, 40)
            bindPanel.Paint = function(self, w, h)
                local col = self:IsHovered() and Color(50, 50, 70, 150) or Color(35, 35, 50, 100)
                draw.RoundedBox(4, 0, 0, w, h, col)
                
                -- Описание
                draw.SimpleText(bind.label, "DermaDefault", 15, h / 2, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            
            -- Кнопка бинда
            local bindBtn = vgui.Create("DButton", bindPanel)
            bindBtn:SetSize(100, 28)
            bindBtn:SetPos(width - 200, 6)
            bindBtn:SetText("")
            bindBtn.bindID = bind.id
            bindBtn.Paint = function(self, w, h)
                local isCurrent = currentlyBinding == self
                local col = isCurrent and Color(100, 150, 255) or (self:IsHovered() and Color(70, 70, 90) or Color(55, 55, 75))
                
                draw.RoundedBox(4, 0, 0, w, h, col)
                
                local text = isCurrent and "Press key..." or GetKeyName(tempKeybinds[bind.id] or KEY_NONE)
                draw.SimpleText(text, "DermaDefault", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                
                -- Рамка
                surface.SetDrawColor(80, 80, 100, 255)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
            bindBtn.DoClick = function(self)
                currentlyBinding = self
            end
            
            yOffset = yOffset + 45
        end
        
        yOffset = yOffset + 10
    end
    
    -- Кнопка сохранения
    local saveBtn = vgui.Create("DButton", PANEL.Frame)
    saveBtn:SetSize(150, 35)
    saveBtn:SetPos(width / 2 - 160, height - 50)
    saveBtn:SetText("")
    saveBtn.Paint = function(self, w, h)
        local col = self:IsHovered() and Color(70, 180, 70) or Color(50, 150, 50)
        draw.RoundedBox(6, 0, 0, w, h, col)
        draw.SimpleText("Save", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    saveBtn.DoClick = function()
        LOTM.Keybinds:Save(tempKeybinds)
        PANEL.Frame:Remove()
        
        notification.AddLegacy("Keybinds saved successfully!", NOTIFY_GENERIC, 3)
        surface.PlaySound("buttons/button15.wav")
    end
    
    -- Кнопка сброса
    local resetBtn = vgui.Create("DButton", PANEL.Frame)
    resetBtn:SetSize(150, 35)
    resetBtn:SetPos(width / 2 + 10, height - 50)
    resetBtn:SetText("")
    resetBtn.Paint = function(self, w, h)
        local col = self:IsHovered() and Color(180, 70, 70) or Color(150, 50, 50)
        draw.RoundedBox(6, 0, 0, w, h, col)
        draw.SimpleText("Reset to Default", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    resetBtn.DoClick = function()
        tempKeybinds = table.Copy(LOTM.Config.Keybinds.Defaults)
        PANEL.Frame:Remove()
        LOTM.UI.OpenKeybindMenu() -- Переоткрываем меню
    end
end

-- Обработка нажатий клавиш для привязки
hook.Add("PlayerButtonDown", "LOTM_KeybindCapture", function(ply, button)
    if not IsValid(PANEL.Frame) or not currentlyBinding then return end
    
    -- Игнорируем ESC и клик мыши вне кнопок
    if button == KEY_ESCAPE then
        currentlyBinding = nil
        return
    end
    
    -- Устанавливаем новый бинд
    tempKeybinds[currentlyBinding.bindID] = button
    currentlyBinding = nil
    
    surface.PlaySound("buttons/button14.wav")
end)