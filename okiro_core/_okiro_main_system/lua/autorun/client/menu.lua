if CLIENT then
    local btnColor = Color(100, 100, 255, 220)
    local btnHoverColor = Color(120, 120, 255, 255)
    local frameColor = Color(30, 30, 30, 240)
    local closeColor = Color(150, 50, 50, 255)
    local closeHoverColor = Color(200, 50, 50, 255)

    local function CreateStyledFrame(title, width, height)
        local frame = vgui.Create("DFrame")
        frame:SetSize(width, height)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("")
        frame:ShowCloseButton(false)
        frame:SetDraggable(true)
        
        frame.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, frameColor)
            draw.SimpleText(title, "Trebuchet24", w / 2, 10, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
            surface.SetDrawColor(255, 100, 0, 255)
            surface.DrawLine(10, 35, w - 10, 35)
        end

        local closeButton = vgui.Create("DButton", frame)
        closeButton:SetSize(24, 24)
        closeButton:SetPos(width - 34, 10)
        closeButton:SetText("X")
        closeButton:SetTextColor(Color(255, 255, 255))
        closeButton.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, self:IsHovered() and closeHoverColor or closeColor)
        end
        closeButton.DoClick = function() frame:Close() end

        return frame
    end

    local function CreateStyledButton(parent, x, y, w, h, text)
        local button = vgui.Create("DButton", parent)
        button:SetPos(x, y)
        button:SetSize(w, h)
        button:SetText("")
        button.Text = text
        button.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, self:IsHovered() and btnHoverColor or btnColor)
            draw.SimpleText(self.Text, "Trebuchet18", w / 2, h / 2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        return button
    end

    local function CreateStyledListView(parent, x, y, w, h)
        local list = vgui.Create("DListView", parent)
        list:SetPos(x, y)
        list:SetSize(w, h)
        list:SetMultiSelect(false)
        list.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50, 230))
        end
        return list
    end
end

if CLIENT then
    local fonts = {
        { "M_Font1", "Lexend", 25, 100 },
        { "M_Font2", "Lexend", 45, 100 },
        { "M_Font3", "Lexend", 25, 100 },
        { "M_Font4", "Lexend", 55, 100 },
        { "M_Font5", "Lexend", 20, 125 },
        { "MNew_Font1", "Lexend Medium", 33, 100 },
        { "MNew_Font2", "Lexend", 45, 100 },
        { "MNew_Font3", "Lexend", 25, 100 },
        { "MNew_Font4", "Lexend", 55, 100 },
        { "MNew_Font5", "Lexend", 20, 125 },
        { "MNew_Font6", "Lexend", 29, 100 }
    }

    for _, f in ipairs(fonts) do
        surface.CreateFont(f[1], {
            font = f[2],
            size = W(f[3]),
            weight = f[4],
            antialias = true,
            extended = true
        })
    end
end
