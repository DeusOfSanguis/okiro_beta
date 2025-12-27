if CLIENT then
    local backgroundMaterial = Material("okiro/echap/background.png")
    local escMaterial = Material("okiro/echap/title.png")
    local okiroMaterial = Material("okiro/echap/okiro.png")
    local arrowleftMaterial = "okiro/echap/arrow-left.png"
    local arrowrightMaterial = "okiro/echap/arrow-right.png"
    local sliderMaterial = Material("okiro/echap/slider.png")
    local newsbgMaterial = Material("okiro/echap/newsbg.png")
    local newspaperMaterial = "okiro/echap/newspaper-fill.png"
    local PANEL = {}

    function PANEL:Init()
        esc.menu = self
        self:SetSize(ScrW(), ScrH())
        self:MakePopup()
        self:SetAlpha(0)
        self:AlphaTo(255, 0.25)

        self.panel = self:Add("DPanel")
        self.panel:SetSize(ScrW(), ScrH())
        self.panel.Paint = function(this, w, h)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(backgroundMaterial)
            surface.DrawTexturedRect(0, 0, w, h)
        end
        self.EscPanel = self:Add("DPanel")
        self.EscPanel:SetSize(288, 51)
        self.EscPanel:SetPos(41, ScrH() - 1037)
        self.EscPanel.Paint = function(this, w, h)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(escMaterial)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        self.okiroPanel = self:Add("DPanel")
        self.okiroPanel:SetSize(1550, 51)
        self.okiroPanel:SetPos(ScrW() - 1579, ScrH() - 1037)
        self.okiroPanel.Paint = function(this, w, h)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(okiroMaterial)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        self.textPanel = self:Add("DPanel")
        self.textPanel:SetSize(484, 184)
        self.textPanel:SetPos(ScrW()- 518, ScrH() - 950)
        self.textPanel.Paint = function(this, w, h)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(sliderMaterial)
            surface.DrawTexturedRect(0, 0, w, h)
        end
        self.titlePart1 = self.textPanel:Add("DLabel")
        self.titlePart1:Dock(TOP)
        self.titlePart1:SetTall(50)
        self.titlePart1:DockMargin(10, 50, 10, 0)
        self.titlePart1:SetText(esc.text1)
        self.titlePart1:SetTextColor(Color(219, 227, 255))
        self.titlePart1:SetExpensiveShadow(1, color_blue)
        self.titlePart1:SetFont("Regular.28")
        self.titlePart1:SetContentAlignment(5)

        self.titlePart2 = self.textPanel:Add("DLabel")
        self.titlePart2:Dock(TOP)
        self.titlePart2:SetTall(50)
        self.titlePart2:DockMargin(10, -20, 10, 0)
        self.titlePart2:SetText(esc.text2)
        self.titlePart2:SetTextColor(Color(219, 227, 255))
        self.titlePart2:SetExpensiveShadow(1, color_blue)
        self.titlePart2:SetFont("Medium.28")
        self.titlePart2:SetContentAlignment(5)

        self.nevPanel = self:Add("DPanel")
        self.nevPanel:SetSize(484, 695)
        self.nevPanel:SetPos(ScrW()- 518, ScrH() - 740)
        self.nevPanel.Paint = function(this, w, h)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(newsbgMaterial)
            surface.DrawTexturedRect(0, 0, w, h)
        end
        self.titles = self.nevPanel:Add("DLabel")
        self.titles:Dock(TOP)
        self.titles:SetTall(50)
        self.titles:DockMargin(25, 20, 10, 0)
        self.titles:SetText(esc.textNev)
        self.titles:SetTextColor(Color(219, 227, 255))
        self.titles:SetExpensiveShadow(1, color_blue)
        self.titles:SetFont("Medium.35")
        self.titles:SetContentAlignment(5)
        self.titles:SetWrap(true)
        self.titles:SetWidth(300)

        self.NevPart0 = self.nevPanel:Add("DLabel")
        self.NevPart0:Dock(BOTTOM)
        self.NevPart0:SetTall(50)
        self.NevPart0:DockMargin(10, 0, 25, 10)
        self.NevPart0:SetText(esc.textNev0)
        self.NevPart0:SetTextColor(Color(219, 227, 255))
        self.NevPart0:SetExpensiveShadow(1, color_blue)
        self.NevPart0:SetFont("Medium.35")
        self.NevPart0:SetContentAlignment(9)

        self.NevPart1 = self.nevPanel:Add("DLabel")
        self.NevPart1:Dock(TOP)
        self.NevPart1:SetTall(50)
        self.NevPart1:DockMargin(25, 5, 10, 0)
        self.NevPart1:SetText(esc.textNev1)
        self.NevPart1:SetTextColor(Color(219, 227, 255))
        self.NevPart1:SetExpensiveShadow(1, color_blue)
        self.NevPart1:SetFont("Regular.25")
        self.NevPart1:SetContentAlignment(5)
        self.NevPart1:SetWrap(true)

        self.NevPart2 = self.nevPanel:Add("DLabel")
        self.NevPart2:Dock(TOP)
        self.NevPart2:SetTall(50)
        self.NevPart2:DockMargin(25, 0, 10, 0)
        self.NevPart2:SetText(esc.textNev2)
        self.NevPart2:SetTextColor(Color(219, 227, 255))
        self.NevPart2:SetExpensiveShadow(1, color_blue)
        self.NevPart2:SetFont("Regular.25")
        self.NevPart2:SetContentAlignment(5)
        self.NevPart2:SetWrap(true)

        self.NevPart3 = self.nevPanel:Add("DLabel")
        self.NevPart3:Dock(TOP)
        self.NevPart3:SetTall(50)
        self.NevPart3:DockMargin(25, 0, 10, 0)
        self.NevPart3:SetText(esc.textNev3)
        self.NevPart3:SetTextColor(Color(219, 227, 255))
        self.NevPart3:SetExpensiveShadow(1, color_blue)
        self.NevPart3:SetFont("Regular.25")
        self.NevPart3:SetContentAlignment(5)
        self.NevPart3:SetWrap(true)

        self.NevPart4 = self.nevPanel:Add("DLabel")
        self.NevPart4:Dock(TOP)
        self.NevPart4:SetTall(50)
        self.NevPart4:DockMargin(25, 0, 10, 0)
        self.NevPart4:SetText(esc.textNev4)
        self.NevPart4:SetTextColor(Color(219, 227, 255))
        self.NevPart4:SetExpensiveShadow(1, color_blue)
        self.NevPart4:SetFont("Regular.25")
        self.NevPart4:SetContentAlignment(5)
        self.NevPart4:SetWrap(true)

        self.newspaper = self.nevPanel:Add("DImage")
        self.newspaper:SetSize(50, 50)
        self.newspaper:SetPos(420, 20)
        self.newspaper:SetImage(newspaperMaterial)

        self.buttonsPanel = self.panel:Add("DPanel")
        self.buttonsPanel:SetSize(449, 480)
        self.buttonsPanel:SetPos(41, ScrH() - 500 - 20)

        self.modelPanel = self:Add("DModelPanel")
        self.modelPanel:SetSize(800, 1080)
        self.modelPanel:SetPos(ScrW() - 1300, 0)
        self.modelPanel:SetModel(LocalPlayer():GetModel())
        function self.modelPanel:LayoutEntity( ent ) end
        self.modelPanel:SetCamPos(Vector(50, 50, 50))
        self.modelPanel:SetLookAt(Vector(0, 0, 50))
        self.modelPanel:SetMouseInputEnabled(false)

        self.buttonsPanel.Paint = function(this, w, h)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(backgroundMaterial)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        self:showButtons()
    end

    function PANEL:showButtons(buttons)
        if self.buttons then
            self.lastButtons = self.buttons
        end

        self.buttonsPanel:Clear()

        local color = esc.color
        local r, g, b = color.r, color.g, color.b

        for k, v in ipairs(buttons or esc.buttons) do
            local button = self.buttonsPanel:Add("DButton")
            button:SetSize(449, 70)
            button:SetPos(0, (k - 1) * v.otst)
            button:SetText('')
            button.Paint = function(this, w, h)
                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(v.mat)
                surface.DrawTexturedRect(0, 0, w, h)

                if this.Depressed or this.m_bSelected then
                    surface.SetDrawColor(r * 3, g * 3, b * 3, 100)
                elseif this.Hovered then
                    surface.SetDrawColor(r, g, b, 50)
                else
                    surface.SetDrawColor(255, 255, 255, 0)
                end
                surface.DrawRect(0, 0, w, h)
            end

            button.DoClick = function(this)
                if v.action then
                    if type(v.action) == "string" then
                        if v.action:sub(1, 4) == "http" then
                            gui.OpenURL(v.action)
                        elseif v.action == "return" then
                            gui.HideGameUI()
                        elseif v.action:sub(1, 5) == "game:" then
                            RunConsoleCommand("gamemenucommand", v.action:sub(6))
                        elseif v.action == "disconnect" then
                            if IsValid(esc.menu) then esc.menu:Remove() end
                            RunConsoleCommand("disconnect")
                        else
                            LocalPlayer():ConCommand(v.action)
                        end
                    end
                end
            end
        end

        self.buttons = buttons or esc.buttons
    end

    local viewData = {
        x = 0,
        y = 0,
        drawhud = true,
        drawviewmodel = true,
        dopostprocess = true
    }

    function PANEL:Paint(w, h)
        viewData.w = ScrW()
        viewData.h = ScrH()
        render.RenderView(viewData)
    end

    function PANEL:Think()
        if not gui.IsGameUIVisible() then
            self:Remove()
        end
    end

    vgui.Register("esc", PANEL, "EditablePanel")
end
