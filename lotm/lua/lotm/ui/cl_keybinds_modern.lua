-- LOTM Modern Keybind Menu
-- Современное UI меню настройки кейбиндов (Valorant/CS2 style)

LOTM.UI = LOTM.UI or {}

local PANEL = {}
local bindingKey = nil
local tempBinds = {}

-- Расширенная таблица названий клавиш
local KEY_NAMES = {
    [KEY_0] = "0", [KEY_1] = "1", [KEY_2] = "2", [KEY_3] = "3", [KEY_4] = "4",
    [KEY_5] = "5", [KEY_6] = "6", [KEY_7] = "7", [KEY_8] = "8", [KEY_9] = "9",
    [KEY_A] = "A", [KEY_B] = "B", [KEY_C] = "C", [KEY_D] = "D", [KEY_E] = "E",
    [KEY_F] = "F", [KEY_G] = "G", [KEY_H] = "H", [KEY_I] = "I", [KEY_J] = "J",
    [KEY_K] = "K", [KEY_L] = "L", [KEY_M] = "M", [KEY_N] = "N", [KEY_O] = "O",
    [KEY_P] = "P", [KEY_Q] = "Q", [KEY_R] = "R", [KEY_S] = "S", [KEY_T] = "T",
    [KEY_U] = "U", [KEY_V] = "V", [KEY_W] = "W", [KEY_X] = "X", [KEY_Y] = "Y", [KEY_Z] = "Z",
    [KEY_LSHIFT] = "L.SHIFT", [KEY_RSHIFT] = "R.SHIFT",
    [KEY_LCONTROL] = "L.CTRL", [KEY_RCONTROL] = "R.CTRL",
    [KEY_LALT] = "L.ALT", [KEY_RALT] = "R.ALT",
    [KEY_SPACE] = "SPACE", [KEY_ENTER] = "ENTER", [KEY_BACKSPACE] = "BACKSPACE",
    [KEY_TAB] = "TAB", [KEY_CAPSLOCK] = "CAPS LOCK",
    [MOUSE_LEFT] = "M1", [MOUSE_RIGHT] = "M2", [MOUSE_MIDDLE] = "M3",
    [MOUSE_4] = "M4", [MOUSE_5] = "M5",
    [KEY_F1] = "F1", [KEY_F2] = "F2", [KEY_F3] = "F3", [KEY_F4] = "F4",
    [KEY_F5] = "F5", [KEY_F6] = "F6", [KEY_F7] = "F7", [KEY_F8] = "F8",
    [KEY_F9] = "F9", [KEY_F10] = "F10", [KEY_F11] = "F11", [KEY_F12] = "F12",
    [KEY_NONE] = "NOT BOUND"
}

local function GetKeyName(key)
    return KEY_NAMES[key] or "KEY_" .. key
end

-- Цветовая схема (Modern Dark Theme)
local C = {
    BG_DARK = Color(11, 13, 18),
    BG_MEDIUM = Color(18, 21, 28),
    BG_LIGHT = Color(25, 29, 38),
    ACCENT = Color(255, 70, 85),
    ACCENT_HOVER = Color(255, 90, 105),
    TEXT = Color(240, 242, 247),
    TEXT_DIM = Color(155, 160, 175),
    BORDER = Color(35, 40, 52),
    SUCCESS = Color(80, 220, 100),
    WARNING = Color(255, 180, 50),
    INFO = Color(100, 200, 255)
}

-- Lerp для цвета
local function LerpC(t, from, to)
    return Color(
        Lerp(t, from.r, to.r),
        Lerp(t, from.g, to.g),
        Lerp(t, from.b, to.b)
    )
end

-- Создать градиент
local function DrawGradient(x, y, w, h, colorTop, colorBottom)
    surface.SetDrawColor(colorTop)
    surface.DrawRect(x, y, w, h/2)
    surface.SetDrawColor(colorBottom)
    surface.DrawRect(x, y + h/2, w, h/2)
end

-- Открытие меню
function LOTM.UI.OpenKeybindMenu()
    if IsValid(PANEL.Frame) then
        PANEL.Frame:Remove()
        return
    end
    
    tempBinds = table.Copy(LOTM.CurrentKeybinds or {})
    bindingKey = nil
    
    local sw, sh = ScrW(), ScrH()
    local w, h = 1000, 650
    
    -- Фон с размытием
    PANEL.Frame = vgui.Create("EditablePanel")
    PANEL.Frame:SetSize(sw, sh)
    PANEL.Frame:SetPos(0, 0)
    PANEL.Frame:MakePopup()
    PANEL.Frame:SetKeyboardInputEnabled(false)
    PANEL.Frame.Paint = function(self, pw, ph)
        Derma_DrawBackgroundBlur(self, CurTime())
        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(0, 0, pw, ph)
    end
    
    -- Основная панель
    local main = vgui.Create("DPanel", PANEL.Frame)
    main:SetSize(w, h)
    main:Center()
    main.Paint = function(self, pw, ph)
        -- Тень
        draw.RoundedBox(16, -8, -8, pw + 16, ph + 16, Color(0, 0, 0, 150))
        -- Фон
        draw.RoundedBox(14, 0, 0, pw, ph, C.BG_DARK)
        -- Верхняя полоса
        draw.RoundedBoxEx(14, 0, 0, pw, 80, C.BG_MEDIUM, true, true, false, false)
        -- Акцентная линия
        surface.SetDrawColor(C.ACCENT)
        surface.DrawRect(0, 80, pw, 3)
    end
    
    -- Иконка
    local icon = vgui.Create("DLabel", main)
    icon:SetPos(35, 20)
    icon:SetSize(50, 50)
    icon:SetFont("DermaLarge")
    icon:SetText("⚙")
    icon:SetTextColor(C.ACCENT)
    
    -- Заголовок
    local title = vgui.Create("DLabel", main)
    title:SetPos(95, 22)
    title:SetSize(400, 30)
    title:SetFont("DermaLarge")
    title:SetText("KEYBINDS")
    title:SetTextColor(C.TEXT)
    
    -- Подзаголовок
    local subtitle = vgui.Create("DLabel", main)
    subtitle:SetPos(95, 50)
    subtitle:SetSize(400, 20)
    subtitle:SetText("Configure ability controls")
    subtitle:SetTextColor(C.TEXT_DIM)
    
    -- Кнопка закрытия
    local closeBtn = vgui.Create("DButton", main)
    closeBtn:SetSize(45, 45)
    closeBtn:SetPos(w - 60, 18)
    closeBtn:SetText("")
    closeBtn.Hover = 0
    closeBtn.Paint = function(self, bw, bh)
        self.Hover = Lerp(FrameTime() * 10, self.Hover, self:IsHovered() and 1 or 0)
        local col = LerpC(self.Hover, C.BG_LIGHT, C.ACCENT)
        draw.RoundedBox(10, 0, 0, bw, bh, col)
        
        surface.SetDrawColor(C.TEXT)
        local center = bw / 2
        surface.DrawLine(center - 8, center - 8, center + 8, center + 8)
        surface.DrawLine(center + 8, center - 8, center - 8, center + 8)
    end
    closeBtn.DoClick = function()
        PANEL.Frame:Remove()
        surface.PlaySound("ui/buttonclickrelease.wav")
    end
    
    -- Контент
    local content = vgui.Create("DPanel", main)
    content:SetPos(30, 100)
    content:SetSize(w - 60, h - 180)
    content.Paint = nil
    
    -- Скролл
    local scroll = vgui.Create("DScrollPanel", content)
    scroll:Dock(FILL)
    
    local sbar = scroll:GetVBar()
    sbar:SetWide(8)
    sbar:SetHideButtons(true)
    sbar.Paint = function(self, pw, ph)
        draw.RoundedBox(4, 0, 0, pw, ph, C.BG_MEDIUM)
    end
    sbar.btnGrip.Paint = function(self, pw, ph)
        draw.RoundedBox(4, 0, 0, pw, ph, C.BORDER)
    end
    
    -- Категории
    local categories = {
        {
            name = "ABILITIES",
            icon = "⚡",
            items = {
                {id = "Ability1", label = "Ability Slot 1", desc = "Primary ability"},
                {id = "Ability2", label = "Ability Slot 2", desc = "Secondary ability"},
                {id = "Ability3", label = "Ability Slot 3", desc = "Tertiary ability"},
                {id = "Ability4", label = "Ability Slot 4", desc = "Quaternary ability"},
                {id = "Ability5", label = "Ability Slot 5", desc = "Ultimate ability"},
            }
        },
        {
            name = "CONTROLS",
            icon = "🎮",
            items = {
                {id = "ThirdPerson", label = "Third Person", desc = "Toggle camera view"},
                {id = "Aura", label = "Aura Display", desc = "Show/hide aura"},
                {id = "Artifacts", label = "Artifacts", desc = "Open artifacts menu"},
            }
        }
    }
    
    for _, cat in ipairs(categories) do
        -- Заголовок категории
        local catHead = vgui.Create("DPanel", scroll)
        catHead:Dock(TOP)
        catHead:DockMargin(0, 0, 0, 5)
        catHead:SetTall(50)
        catHead.Paint = function(self, pw, ph)
            draw.RoundedBox(8, 0, 0, pw, ph, C.BG_MEDIUM)
            draw.SimpleText(cat.icon, "DermaLarge", 20, ph/2, C.INFO, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(cat.name, "DermaDefaultBold", 60, ph/2, C.TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        
        -- Итемы
        for _, item in ipairs(cat.items) do
            local row = vgui.Create("DPanel", scroll)
            row:Dock(TOP)
            row:DockMargin(0, 0, 0, 2)
            row:SetTall(75)
            row.Hover = 0
            row.Paint = function(self, pw, ph)
                self.Hover = Lerp(FrameTime() * 8, self.Hover, self:IsHovered() and 1 or 0)
                local bg = LerpC(self.Hover, C.BG_DARK, C.BG_LIGHT)
                draw.RoundedBox(6, 0, 0, pw, ph, bg)
                
                -- Название
                draw.SimpleText(item.label, "DermaDefaultBold", 20, 22, C.TEXT)
                -- Описание
                draw.SimpleText(item.desc, "DermaDefault", 20, 45, C.TEXT_DIM)
                
                -- Линия снизу
                surface.SetDrawColor(C.BORDER)
                surface.DrawRect(10, ph - 1, pw - 20, 1)
            end
            
            -- Кнопка бинда
            local bindBtn = vgui.Create("DButton", row)
            bindBtn:SetSize(160, 50)
            bindBtn:SetPos(w - 220, 12)
            bindBtn:SetText("")
            bindBtn.bindID = item.id
            bindBtn.Hover = 0
            bindBtn.Paint = function(self, bw, bh)
                local isBinding = (bindingKey == self)
                
                self.Hover = Lerp(FrameTime() * 12, self.Hover, (self:IsHovered() or isBinding) and 1 or 0)
                
                local bg
                if isBinding then
                    bg = C.INFO
                else
                    bg = LerpC(self.Hover, C.BG_MEDIUM, C.BG_LIGHT)
                end
                
                draw.RoundedBox(8, 0, 0, bw, bh, bg)
                
                local text = isBinding and "PRESS KEY..." or GetKeyName(tempBinds[item.id] or KEY_NONE)
                local textCol = isBinding and C.BG_DARK or C.TEXT
                draw.SimpleText(text, "DermaDefaultBold", bw/2, bh/2, textCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                
                if self:IsHovered() and not isBinding then
                    surface.SetDrawColor(C.ACCENT)
                    surface.DrawOutlinedRect(0, 0, bw, bh, 2)
                end
            end
            bindBtn.DoClick = function(self)
                bindingKey = self
                surface.PlaySound("ui/buttonclick.wav")
            end
        end
    end
    
    -- Нижняя панель
    local bottom = vgui.Create("DPanel", main)
    bottom:SetSize(w, 70)
    bottom:SetPos(0, h - 70)
    bottom.Paint = function(self, pw, ph)
        draw.RoundedBoxEx(14, 0, 0, pw, ph, C.BG_MEDIUM, false, false, true, true)
        surface.SetDrawColor(C.BORDER)
        surface.DrawRect(0, 0, pw, 2)
    end
    
    -- Кнопка сохранения
    local saveBtn = vgui.Create("DButton", bottom)
    saveBtn:SetSize(200, 45)
    saveBtn:SetPos(w - 420, 13)
    saveBtn:SetText("")
    saveBtn.Hover = 0
    saveBtn.Paint = function(self, bw, bh)
        self.Hover = Lerp(FrameTime() * 10, self.Hover, self:IsHovered() and 1 or 0)
        local col = LerpC(self.Hover, C.SUCCESS, Color(100, 255, 120))
        draw.RoundedBox(10, 0, 0, bw, bh, col)
        draw.SimpleText("SAVE CHANGES", "DermaDefaultBold", bw/2, bh/2, C.BG_DARK, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    saveBtn.DoClick = function()
        LOTM.Keybinds:Save(tempBinds)
        PANEL.Frame:Remove()
        notification.AddLegacy("✓ Keybinds saved!", NOTIFY_GENERIC, 3)
        surface.PlaySound("buttons/button15.wav")
    end
    
    -- Кнопка сброса
    local resetBtn = vgui.Create("DButton", bottom)
    resetBtn:SetSize(200, 45)
    resetBtn:SetPos(w - 210, 13)
    resetBtn:SetText("")
    resetBtn.Hover = 0
    resetBtn.Paint = function(self, bw, bh)
        self.Hover = Lerp(FrameTime() * 10, self.Hover, self:IsHovered() and 1 or 0)
        local col = LerpC(self.Hover, C.BG_LIGHT, C.BORDER)
        draw.RoundedBox(10, 0, 0, bw, bh, col)
        draw.SimpleText("RESET DEFAULT", "DermaDefaultBold", bw/2, bh/2, C.TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    resetBtn.DoClick = function()
        tempBinds = table.Copy(LOTM.Config.Keybinds.Defaults)
        PANEL.Frame:Remove()
        timer.Simple(0.05, function()
            LOTM.UI.OpenKeybindMenu()
        end)
        surface.PlaySound("ui/buttonclick.wav")
    end
end

-- Обработка нажатий
hook.Add("PlayerButtonDown", "LOTM_ModernKeybindCapture", function(ply, button)
    if not IsValid(PANEL.Frame) or not bindingKey then return end
    
    if button == KEY_ESCAPE then
        bindingKey = nil
        return
    end
    
    tempBinds[bindingKey.bindID] = button
    bindingKey = nil
    surface.PlaySound("buttons/button14.wav")
end)

print("[LOTM] Modern Keybind UI loaded!")