-- LOTM Keybind Menu - Enhanced UI
-- Современный интерфейс настройки кейбиндов (Valorant/CS:GO style)

LOTM.UI = LOTM.UI or {}

local PANEL = {}
local currentlyBinding = nil
local tempKeybinds = {}
local searchQuery = ""

-- Расширенные названия клавиш
local keyNames = {
    [KEY_0] = "0", [KEY_1] = "1", [KEY_2] = "2", [KEY_3] = "3", [KEY_4] = "4",
    [KEY_5] = "5", [KEY_6] = "6", [KEY_7] = "7", [KEY_8] = "8", [KEY_9] = "9",
    [KEY_Q] = "Q", [KEY_W] = "W", [KEY_E] = "E", [KEY_R] = "R", [KEY_T] = "T",
    [KEY_Y] = "Y", [KEY_U] = "U", [KEY_I] = "I", [KEY_O] = "O", [KEY_P] = "P",
    [KEY_A] = "A", [KEY_S] = "S", [KEY_D] = "D", [KEY_F] = "F", [KEY_G] = "G",
    [KEY_H] = "H", [KEY_J] = "J", [KEY_K] = "K", [KEY_L] = "L",
    [KEY_Z] = "Z", [KEY_X] = "X", [KEY_C] = "C", [KEY_V] = "V", [KEY_B] = "B",
    [KEY_N] = "N", [KEY_M] = "M",
    [KEY_LSHIFT] = "LSHIFT", [KEY_RSHIFT] = "RSHIFT",
    [KEY_LCONTROL] = "LCTRL", [KEY_RCONTROL] = "RCTRL",
    [KEY_LALT] = "LALT", [KEY_RALT] = "RALT",
    [KEY_SPACE] = "SPACE", [KEY_ENTER] = "ENTER", [KEY_BACKSPACE] = "BACKSPACE",
    [KEY_TAB] = "TAB", [KEY_CAPSLOCK] = "CAPS",
    [MOUSE_LEFT] = "MOUSE1", [MOUSE_RIGHT] = "MOUSE2", [MOUSE_MIDDLE] = "MOUSE3",
    [MOUSE_4] = "MOUSE4", [MOUSE_5] = "MOUSE5",
    [KEY_F1] = "F1", [KEY_F2] = "F2", [KEY_F3] = "F3", [KEY_F4] = "F4",
    [KEY_F5] = "F5", [KEY_F6] = "F6", [KEY_F7] = "F7", [KEY_F8] = "F8",
    [KEY_F9] = "F9", [KEY_F10] = "F10", [KEY_F11] = "F11", [KEY_F12] = "F12",
}

local function GetKeyName(key)
    return keyNames[key] or "NONE"
end

-- Цветовая палитра (Valorant-inspired)
local Colors = {
    Background = Color(12, 12, 18),
    BackgroundLight = Color(18, 18, 26),
    Primary = Color(255, 70, 85),
    PrimaryHover = Color(255, 90, 105),
    Secondary = Color(70, 80, 100),
    SecondaryHover = Color(85, 95, 115),
    Text = Color(235, 235, 245),
    TextDim = Color(160, 160, 180),
    Accent = Color(100, 210, 255),
    Border = Color(40, 40, 55),
    Success = Color(80, 220, 100),
    Warning = Color(255, 180, 60)
}

--[[------------------------------------
    Вспомогательная функция для lerp
--------------------------------------]]
local function LerpColor(frac, from, to)
    return Color(
        Lerp(frac, from.r, to.r),
        Lerp(frac, from.g, to.g),
        Lerp(frac, from.b, to.b),
        Lerp(frac, from.a or 255, to.a or 255)
    )
end

--[[------------------------------------
    Создание улучшенного UI меню
--------------------------------------]]
function LOTM.UI.OpenKeybindMenu()
    if IsValid(PANEL.Frame) then
        PANEL.Frame:Remove()
        return
    end
    
    tempKeybinds = table.Copy(LOTM.CurrentKeybinds)
    searchQuery = ""
    
    local scrW, scrH = ScrW(), ScrH()
    local width, height = 900, 600
    
    -- Основной фрейм с эффектом размытия
    PANEL.Frame = vgui.Create("EditablePanel")
    PANEL.Frame:SetSize(scrW, scrH)
    PANEL.Frame:SetPos(0, 0)
    PANEL.Frame:MakePopup()
    PANEL.Frame.Paint = function(self, w, h)
        -- Размытый фон
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(0, 0, w, h)
    end
    
    -- Центральная панель
    local mainPanel = vgui.Create("DPanel", PANEL.Frame)
    mainPanel:SetSize(width, height)
    mainPanel:SetPos((scrW - width) / 2, (scrH - height) / 2)
    mainPanel.Paint = function(self, w, h)
        -- Фон с тенью
        draw.RoundedBox(12, -4, -4, w + 8, h + 8, Color(0, 0, 0, 100))
        draw.RoundedBox(10, 0, 0, w, h, Colors.Background)
        
        -- Верхняя полоса
        draw.RoundedBoxEx(10, 0, 0, w, 70, Colors.BackgroundLight, true, true, false, false)
        
        -- Акцентная линия
        surface.SetDrawColor(Colors.Primary)
        surface.DrawRect(0, 70, w, 2)
    end
    
    -- Заголовок
    local title = vgui.Create("DLabel", mainPanel)
    title:SetPos(30, 15)
    title:SetSize(400, 40)
    title:SetFont("DermaLarge")
    title:SetText("KEYBINDS")
    title:SetTextColor(Colors.Text)
    
    -- Подзаголовок
    local subtitle = vgui.Create("DLabel", mainPanel)
    subtitle:SetPos(30, 45)
    subtitle:SetSize(400, 20)
    subtitle:SetFont("DermaDefault")
    subtitle:SetText("Configure your ability keybinds")
    subtitle:SetTextColor(Colors.TextDim)
    
    -- Кнопка закрытия (X)
    local closeBtn = vgui.Create("DButton", mainPanel)
    closeBtn:SetSize(40, 40)
    closeBtn:SetPos(width - 55, 15)
    closeBtn:SetText("")
    closeBtn.Lerp = 0
    closeBtn.Paint = function(self, w, h)
        self.Lerp = Lerp(FrameTime() * 8, self.Lerp, self:IsHovered() and 1 or 0)
        local col = LerpColor(self.Lerp, Colors.Secondary, Colors.Primary)
        
        draw.RoundedBox(8, 0, 0, w, h, col)
        
        -- X символ
        surface.SetDrawColor(Colors.Text)
        surface.DrawLine(w * 0.3, h * 0.3, w * 0.7, h * 0.7)
        surface.DrawLine(w * 0.7, h * 0.3, w * 0.3, h * 0.7)
    end
    closeBtn.DoClick = function()
        PANEL.Frame:Remove()
        surface.PlaySound("ui/buttonclickrelease.wav")
    end
    
    -- Контейнер для контента
    local contentPanel = vgui.Create("DPanel", mainPanel)
    contentPanel:SetPos(30, 90)
    contentPanel:SetSize(width - 60, height - 160)
    contentPanel.Paint = function(self, w, h)
        -- Ничего не рисуем
    end
    
    -- Скролл панель
    local scroll = vgui.Create("DScrollPanel", contentPanel)
    scroll:Dock(FILL)
    
    local sbar = scroll:GetVBar()
    sbar:SetWide(6)
    sbar.Paint = function() end
    sbar.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox(3, 0, 0, w, h, Colors.Secondary)
    end
    sbar.btnUp.Paint = function() end
    sbar.btnDown.Paint = function() end
    
    -- Категории кейбиндов
    local categories = {
        {
            name = "ABILITIES",
            icon = "⚡",
            binds = {
                {id = "Ability1", label = "Ability Slot 1", desc = "Primary ability slot"},
                {id = "Ability2", label = "Ability Slot 2", desc = "Secondary ability slot"},
                {id = "Ability3", label = "Ability Slot 3", desc = "Tertiary ability slot"},
                {id = "Ability4", label = "Ability Slot 4", desc = "Quaternary ability slot"},
                {id = "Ability5", label = "Ability Slot 5", desc = "Ultimate ability slot"},
            }
        },
        {
            name = "CONTROLS",
            icon = "⚙",
            binds = {
                {id = "ThirdPerson", label = "Third Person View", desc = "Toggle third person camera"},
                {id = "Aura", label = "Aura Display", desc = "Toggle aura visibility"},
                {id = "Artifacts", label = "Artifacts Menu", desc = "Open artifacts interface"},
            }
        }
    }
    
    local yOffset = 0
    
    for catIndex, category in ipairs(categories) do
        -- Заголовок категории
        local catHeader = vgui.Create("DPanel", scroll)
        catHeader:SetSize(width - 96, 45)
        catHeader:SetPos(0, yOffset)
        catHeader.Paint = function(self, w, h)
            -- Фон категории
            draw.RoundedBox(8, 0, 0, w, h, Colors.BackgroundLight)
            
            -- Иконка
            draw.SimpleText(category.icon, "DermaLarge", 15, h / 2, Colors.Accent, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            
            -- Название
            draw.SimpleText(category.name, "DermaDefaultBold", 50, h / 2, Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            
            -- Линия снизу
            surface.SetDrawColor(Colors.Border)
            surface.DrawRect(0, h - 1, w, 1)
        end
        
        yOffset = yOffset + 50
        
        -- Кейбинды в категории
        for bindIndex, bind in ipairs(category.binds) do
            local bindRow = vgui.Create("DPanel", scroll)
            bindRow:SetSize(width - 96, 70)
            bindRow:SetPos(0, yOffset)
            bindRow.Lerp = 0
            bindRow.Paint = function(self, w, h)
                self.Lerp = Lerp(FrameTime() * 6, self.Lerp, self:IsHovered() and 1 or 0)
                local bgColor = LerpColor(self.Lerp, Colors.Background, Colors.BackgroundLight)
                
                draw.RoundedBox(6, 0, 0, w, h, bgColor)
                
                -- Название бинда
                draw.SimpleText(bind.label, "DermaDefaultBold", 20, 20, Colors.Text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                
                -- Описание
                draw.SimpleText(bind.desc, "DermaDefault", 20, 40, Colors.TextDim, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                
                -- Разделительная линия
                surface.SetDrawColor(Colors.Border)
                surface.DrawRect(0, h - 1, w, 1)
            end
            
            -- Кнопка бинда
            local bindBtn = vgui.Create("DButton", bindRow)
            bindBtn:SetSize(140, 45)
            bindBtn:SetPos(width - 256, 12)
            bindBtn:SetText("")
            bindBtn.bindID = bind.id
            bindBtn.Lerp = 0
            bindBtn.Paint = function(self, w, h)
                local isBinding = currentlyBinding == self
                
                self.Lerp = Lerp(FrameTime() * 10, self.Lerp, (self:IsHovered() or isBinding) and 1 or 0)
                
                local bgColor
                if isBinding then
                    bgColor = Colors.Accent
                else
                    bgColor = LerpColor(self.Lerp, Colors.Secondary, Colors.SecondaryHover)
                end
                
                draw.RoundedBox(6, 0, 0, w, h, bgColor)
                
                -- Текст
                local text = isBinding and "Press any key..." or GetKeyName(tempKeybinds[bind.id] or KEY_NONE)
                local textColor = isBinding and Colors.Background or Colors.Text
                draw.SimpleText(text, "DermaDefaultBold", w / 2, h / 2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                
                -- Рамка при наведении
                if self:IsHovered() and not isBinding then
                    surface.SetDrawColor(Colors.Accent)
                    surface.DrawOutlinedRect(0, 0, w, h, 2)
                end
            end
            bindBtn.DoClick = function(self)
                currentlyBinding = self
                surface.PlaySound("ui/buttonclick.wav")
            end
            
            yOffset = yOffset + 75
        end
        
        yOffset = yOffset + 10
    end
    
    -- Нижняя панель с кнопками
    local bottomPanel = vgui.Create("DPanel", mainPanel)
    bottomPanel:SetSize(width, 60)
    bottomPanel:SetPos(0, height - 60)
    bottomPanel.Paint = function(self, w, h)
        draw.RoundedBoxEx(10, 0, 0, w, h, Colors.BackgroundLight, false, false, true, true)
        
        surface.SetDrawColor(Colors.Border)
        surface.DrawRect(0, 0, w, 1)
    end
    
    -- Кнопка сохранения
    local saveBtn = vgui.Create("DButton", bottomPanel)
    saveBtn:SetSize(180, 40)
    saveBtn:SetPos(width - 390, 10)
    saveBtn:SetText("")
    saveBtn.Lerp = 0
    saveBtn.Paint = function(self, w, h)
        self.Lerp = Lerp(FrameTime() * 8, self.Lerp, self:IsHovered() and 1 or 0)
        local col = LerpColor(self.Lerp, Colors.Success, Color(100, 240, 120))
        
        draw.RoundedBox(8, 0, 0, w, h, col)
        draw.SimpleText("SAVE CHANGES", "DermaDefaultBold", w / 2, h / 2, Colors.Background, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    saveBtn.DoClick = function()
        LOTM.Keybinds:Save(tempKeybinds)
        PANEL.Frame:Remove()
        
        notification.AddLegacy("✓ Keybinds saved successfully!", NOTIFY_GENERIC, 4)
        surface.PlaySound("buttons/button15.wav")
    end
    
    -- Кнопка сброса
    local resetBtn = vgui.Create("DButton", bottomPanel)
    resetBtn:SetSize(180, 40)
    resetBtn:SetPos(width - 200, 10)
    resetBtn:SetText("")
    resetBtn.Lerp = 0
    resetBtn.Paint = function(self, w, h)
        self.Lerp = Lerp(FrameTime() * 8, self.Lerp, self:IsHovered() and 1 or 0)
        local col = LerpColor(self.Lerp, Colors.Secondary, Colors.SecondaryHover)
        
        draw.RoundedBox(8, 0, 0, w, h, col)
        draw.SimpleText("RESET TO DEFAULT", "DermaDefaultBold", w / 2, h / 2, Colors.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    resetBtn.DoClick = function()
        tempKeybinds = table.Copy(LOTM.Config.Keybinds.Defaults)
        PANEL.Frame:Remove()
        timer.Simple(0.1, function()
            LOTM.UI.OpenKeybindMenu()
        end)
        surface.PlaySound("ui/buttonclick.wav")
    end
end

-- Обработка нажатий клавиш для привязки
hook.Add("PlayerButtonDown", "LOTM_KeybindCapture", function(ply, button)
    if not IsValid(PANEL.Frame) or not currentlyBinding then return end
    
    if button == KEY_ESCAPE then
        currentlyBinding = nil
        surface.PlaySound("ui/buttonclickrelease.wav")
        return
    end
    
    tempKeybinds[currentlyBinding.bindID] = button
    currentlyBinding = nil
    
    surface.PlaySound("buttons/button14.wav")
end)