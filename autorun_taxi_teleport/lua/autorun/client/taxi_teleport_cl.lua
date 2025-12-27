--[[
-----------------------------------------------------------
                    Informations
-----------------------------------------------------------
Ce fichier provient du site web https://aide-serveur.fr/ et a été publié et créé par Autorun__.
Toute forme de revente, de republication, d'envoi à des tiers, etc. est strictement interdite, car cet addon est payant.
Discord : Autorun__
Serveur Discord : Discord.gg/GgH8eKmFpt
-----------------------------------------------------------
--]]

include("sh_config_taxi_teleport.lua")

surface.CreateFont("DestinationButtonFont", {
    font = "Arial",
    size = 20,
    weight = 700,
    antialias = true,
})

surface.CreateFont("CloseButtonFont", {
    font = "Arial",
    size = 24,
    weight = 800,
    antialias = true,
})

function OpenTaxiMenu()
    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetSize(1000, 500)
    frame:Center()
    frame:MakePopup()

    local icon = vgui.Create("DImage", frame)
    icon:SetPos(350, 55) 
    icon:SetSize(16, 16) 
    icon:SetImage("materials/icons/autorun_taxi_destination.png")

    local icon2 = vgui.Create("DImage", frame)
    icon2:SetPos(420, 17) 
    icon2:SetSize(16, 16) 
    icon2:SetImage("materials/icons/autorun_taxi_taxi.png")

    local headerDest = vgui.Create("DLabel", frame)
    headerDest:SetColor(TaxiTeleportConfig.Colors.Text) 
    headerDest:SetFont("DestinationButtonFont") 
    headerDest:SetText("Choisissez votre destination :") 
    headerDest:SizeToContents() 

    local labelWidth = headerDest:GetWide()
    local frameWidth = frame:GetWide()
    local xPos = (frameWidth - labelWidth) / 2

    headerDest:SetPos(xPos, 55) 
    headerDest:SetContentAlignment(5)

    frame:SetSizable(false)
    frame:ShowCloseButton(false)
    frame.Paint = function(self, w, h)
        draw.RoundedBox(TaxiTeleportConfig.BorderRadius, 0, 0, w, h, TaxiTeleportConfig.Colors.Background) 
        draw.SimpleText("Taxi", "DestinationButtonFont", w / 2, 15, TaxiTeleportConfig.Colors.Text, TEXT_ALIGN_CENTER) 
    end

    local closeButton = vgui.Create("DButton", frame)
    closeButton:SetText("")
    closeButton:SetPos(frame:GetWide() - 40, 10) 
    closeButton:SetSize(30, 30) 
    closeButton.Paint = function(self, w, h)
        draw.RoundedBox(TaxiTeleportConfig.BorderRadius, 0, 0, w, h, TaxiTeleportConfig.Colors.CloseButton) 
        local text = "×"
        surface.SetFont("CloseButtonFont")
        local textW, textH = surface.GetTextSize(text)
        local textX = (w - textW) / 2
        local textY = (h - textH) / 2
        draw.SimpleText(text, "CloseButtonFont", textX, textY, TaxiTeleportConfig.Colors.XClose, 0, 0)
    end
    closeButton.DoClick = function()
        frame:Close()
    end

    local scrollPanel = vgui.Create("DScrollPanel", frame)
    scrollPanel:Dock(FILL)
    scrollPanel:DockMargin(10, 50, 10, 10)

    local sbar = scrollPanel:GetVBar()
    function sbar:Paint(w, h)
        draw.RoundedBox(TaxiTeleportConfig.BorderRadius, 0, 0, w, h, TaxiTeleportConfig.Colors.ScrollBar) 
    end
    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(TaxiTeleportConfig.BorderRadius, 0, 0, w, h, TaxiTeleportConfig.Colors.ScrollBarBtn) 
    end
    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(TaxiTeleportConfig.BorderRadius, 0, 0, w, h, TaxiTeleportConfig.Colors.ScrollBarBtn) 
    end
    function sbar.btnGrip:Paint(w, h)
        draw.RoundedBox(TaxiTeleportConfig.BorderRadius, 0, 0, w, h, TaxiTeleportConfig.Colors.ScrollBarGrip) 
    end

    for _, dest in pairs(TaxiTeleportConfig.Destinations) do
        local button = scrollPanel:Add("DButton")
        local currency = TaxiTeleportConfig.Currency
        local priceText = currency == "$" and currency .. dest.Price or dest.Price .. currency
        button:SetText(dest.Name .. " - " .. priceText)
        button:SetFont("DestinationButtonFont")
        button:Dock(TOP)
        button:DockMargin(10, 0, 10, 5)
        button:SetHeight(50)
        button.Paint = function(self, w, h)
            if self:IsHovered() then
                self:SetTextColor(TaxiTeleportConfig.Colors.ButtonTextHover)
                draw.RoundedBox(TaxiTeleportConfig.BorderRadius, 0, 0, w, h, TaxiTeleportConfig.Colors.ButtonBackgroundHover)
            else
                self:SetTextColor(TaxiTeleportConfig.Colors.ButtonText)
                draw.RoundedBox(TaxiTeleportConfig.BorderRadius, 0, 0, w, h, TaxiTeleportConfig.Colors.ButtonBackground)
            end
        end

        button.DoClick = function()
            local destIndex = table.KeyFromValue(TaxiTeleportConfig.Destinations, dest)
            net.Start("TaxiTeleportRequest")
            net.WriteInt(destIndex, 32)
            net.SendToServer()
            frame:Close()
        end        
    end
end

net.Receive("OpenTaxiMenu", function()
    OpenTaxiMenu()
end)