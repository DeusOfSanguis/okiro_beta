local function W(x)
    return x * ScrW() / 1920
end

local function H(y)
    return y * ScrH() / 1080
end

local x, y = ScrW(), ScrH()
local MainFrame
local SecondFrame
local MELTabGodEnbl = true
local MELTabCloakEnbl = true
local MELTabFreezeEnbl = true
local MELTabOpen = false

surface.CreateFont("MELScoreBoard:Font:Grade", {
	font = "Lexend",
	size = ScrH()*0.022,
	weight = 20
})

surface.CreateFont("MELScoreBoard:Font:List", {
	font = "Lexend",
	size = ScrH()*0.025,
	weight = 20
})

surface.CreateFont("MELScoreBoard:Font:Button", {
	font = "Lexend",
	size = ScrH()*0.029,
	weight = 20
})

local function MELScoreBoardDraw()

    if IsValid(MainFrame) then return end
    MainFrame = vgui.Create("DFrame")
    MainFrame:SetSize(W(1308.36), H(708.72))
    MainFrame:Center()
    MainFrame:SetTitle("  ")
    MainFrame:SetDraggable(false)
    MainFrame:ShowCloseButton(false)
    MainFrame.Paint = function(self, w, h)
        surface.SetMaterial(MEL_ScoreBoard.Materials["BackGround"])
        surface.SetDrawColor(Color(219, 227, 255, 255))
        surface.DrawTexturedRect(x*0, y*0, w, h)

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(Material("okiro/tab/Nom.png")) 
        surface.DrawTexturedRect(W(191.36), H(89.86), W(251), H(38)) 

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(Material("okiro/tab/Classe.png")) 
        surface.DrawTexturedRect(W(449.36), H(89.86), W(335), H(38)) 

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(Material("okiro/tab/Rang.png")) 
        surface.DrawTexturedRect(W(794.36), H(89.86), W(220), H(38)) 

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(Material("okiro/tab/Ping.png")) 
        surface.DrawTexturedRect(W(1023.36), H(89.86), W(118), H(38)) 

        draw.SimpleText("Игроков онлайн: " .. table.Count(player.GetAll()), "MELScoreBoard:Font:Grade", W(191.36), H(608.86), Color(219, 227, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)    end

    local ScrollPanel = vgui.Create("DScrollPanel", MainFrame)
    ScrollPanel:SetPos(W(191.36), H(138.86))
    ScrollPanel:SetSize(W(950), H(447))
	ScrollPanel.Paint = function(self, w, h)
	end

    local ScrollBar = ScrollPanel:GetVBar()
	ScrollBar:SetSize(W(6), H(447))
    ScrollBar:SetPos(W(1135.36), H(138.86))
    ScrollBar:SetHideButtons(true) 
    function ScrollBar:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 219, 227, 255, 10 ) )
        surface.SetDrawColor(219, 227, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h, 1 )
    end
    function ScrollBar.btnGrip:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 219, 227, 255, 255 ) )
    end
    
    for k, v in pairs(player.GetAll()) do
        if not IsValid(v) then return end
        if not v:IsPlayer() then return end

        local PlayerList = vgui.Create("DButton", ScrollPanel)
        PlayerList:SetSize(W(933), H(43))
        PlayerList:SetPos(W(497), H(325))
        PlayerList:Dock(TOP)
        PlayerList:DockMargin(0, 5, 5, 0)
        PlayerList:SetText("")
		PlayerList.Paint = function(self, w, h)
            if not IsValid(v) then return end

            if v == LocalPlayer() then
                surface.SetDrawColor(255, 255, 255, 255)
                surface.SetMaterial(Material("okiro/tab/prout.png")) 
                surface.DrawTexturedRect(0, 0, w, h*1) 
                local d = draw.RoundedBox( 0, 0, 0, w, h*1, Color( 219, 227, 255, 10 ) )
                if LocalPlayer():GetUserGroup() ~= "user" and LocalPlayer():GetUserGroup() ~= "monarch" then
                    if self:IsHovered() then
                        surface.SetDrawColor(255, 255, 255, 255)
                        surface.SetMaterial(Material("okiro/tab/prout.png")) 
                        surface.DrawTexturedRect(0, 0, w, h*1) 
                        d = draw.RoundedBox( 0, 0, 0, w, h*1, Color( 219, 227, 255, 15 ) )
                    end
                end
            elseif self:IsHovered() then
                if LocalPlayer():GetUserGroup() ~= "user" and LocalPlayer():GetUserGroup() ~= "monarch" then
                    surface.SetDrawColor(255, 255, 255, 150) 
                    surface.SetMaterial(Material("okiro/tab/prout.png")) 
                    surface.DrawTexturedRect(0, 0, w, h*1)
                    draw.RoundedBox( 0, 0, 0, w, h*1, Color( 219, 227, 255, 5 ) )
                else 
                    surface.SetDrawColor(255, 255, 255, 255) 
                    surface.SetMaterial(Material("okiro/tab/prout.png")) 
                    surface.DrawTexturedRect(0, 0, w, h*1) 
                end
            else
                surface.SetDrawColor(255, 255, 255, 255) 
                surface.SetMaterial(Material("okiro/tab/prout.png")) 
                surface.DrawTexturedRect(0, 0, w, h*1) 
            end
                         
            local Avatar = vgui.Create( "AvatarImage", PlayerList )
            Avatar:SetSize( h*0.7, h*0.7 )
            Avatar:SetPos( x*0.004, y*0.0065 )
            Avatar:SetPlayer( v, 64 )

            if not IsValid(v) then if IsValid(Avatar) then Avatar:Remove() end return end

            if v:GetUserGroup() == "monarch" then
                surface.SetDrawColor(255, 255, 255, 255) 
                surface.SetMaterial(Material("okiro/tab/Tag VIP.png")) 
                surface.DrawTexturedRect(x*0.022, y*0.0045, W(83), H(35)) 
                draw.SimpleText(v:Name(), "MELScoreBoard:Font:Grade", x*0.065, y*0.008, Color(219, 227, 255, 255))
            else 
                draw.SimpleText(v:Name(), "MELScoreBoard:Font:Grade", x*0.028, y*0.008, Color(219, 227, 255, 255))
            end

            local ping_color
            if v:Ping() <= 100 then
                ping_color = Color(219, 227, 255, 255)
            elseif v:Ping() <= 200 then
                ping_color = Color(255, 219, 219, 255)
            elseif v:Ping() <= 300 then
                ping_color = Color(255, 174, 174, 255)
            elseif v:Ping() <= 400 then
                ping_color = Color(255, 131, 131, 255)
            elseif v:Ping() <= 500 then
                ping_color = Color(255, 83, 83, 255)
            elseif v:Ping() <= 600 then
                ping_color = Color(255, 25, 25, 255)
            end

            local ping = draw.SimpleText(v:Ping(), "MELScoreBoard:Font:Grade", x*0.48, y*0.008, ping_color, TEXT_ALIGN_RIGHT)

            local classe = v:GetNWInt("Classe")
            if classe == "Aucune" then
                classe = "Нет Класса"
            else
                classe = CLASSES_SL[LocalPlayer():GetNWString("Classe")].name
            end
            
            draw.SimpleText(string.upper(string.sub(classe, 1, 1))..string.sub(classe, 2, -1), "MELScoreBoard:Font:Grade",y*0.255, y*0.008, Color(219, 227, 255, 255) , TEXT_ALIGN_LEFT)
            local rang = "Ранг " .. v:GetNWInt("Rang")

            if rang == "Ранг Aucune" then
                rang = "Нет Ранга"
            end
            draw.SimpleText(string.upper(string.sub(rang, 1, 1))..string.sub(rang, 2, -1), "MELScoreBoard:Font:Grade",y*0.57, y*0.008, Color(219, 227, 255, 255) , TEXT_ALIGN_LEFT)
        end

        PlayerList.DoRightClick = function()
            if not IsValid(v) then return end
            
            local DetailsDMenu = DermaMenu() 
            DetailsDMenu:AddOption("Копировать SteamID32", function()
                SetClipboardText(v:SteamID())
                LocalPlayer():ChatPrint("SteamID32 успешно скопирован!")
            end)
            
            DetailsDMenu:AddOption("Копировать SteamID64", function()
                SetClipboardText(util.SteamIDTo64(v:SteamID()))
                LocalPlayer():ChatPrint("SteamID64 успешно скопирован!")
            end)
            
            DetailsDMenu:AddOption("Копировать имя", function()
                SetClipboardText(v:Name())
                LocalPlayer():ChatPrint("Имя игрока успешно скопировано!")
            end)
            DetailsDMenu:Open()
            DetailsDMenu.Paint = function(self, w, h)
                draw.RoundedBox(6, x*0, y*0, w, h, MEL_ScoreBoard.Color["Bleu1"])
            end
        end

        PlayerList.DoClick = function()
            if LocalPlayer():GetUserGroup() ~= "user" and LocalPlayer():GetUserGroup() ~= "monarch" then
                if not IsValid(v) then return end

                local name = v:SteamID64()
                if not v then
                    if IsValid(SecondFrame) then 
                        SecondFrame:Close()
                    end 
                    return
                end
                
                if name == nil then 
                    ply:ChatPrint("Не удалось получить имя игрока!")
                    return 
                end
                if IsValid(MainFrame) then MainFrame:Close() end
    
                if IsValid(SecondFrame) then return end

                SecondFrame = vgui.Create("DFrame")
                SecondFrame:SetSize(W(1308.36), H(708.72))
                SecondFrame:Center()
                SecondFrame:SetTitle("")
                SecondFrame:SetDraggable(false)
                SecondFrame:ShowCloseButton(false)
                SecondFrame.Paint = function(self, w, h)
                    surface.SetMaterial(MEL_ScoreBoard.Materials["BackGround"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0, y*0, w, h)
                    draw.SimpleText(MEL_ScoreBoard.Translate["Nom"] .. " : " .. v:Name(), "MELScoreBoard:Font:List", x*0.24, y*0.105, Color(219, 227, 255, 255))
                    draw.SimpleText(MEL_ScoreBoard.Translate["SteamID"] .. " : " .. v:SteamID(), "MELScoreBoard:Font:List", x*0.24, y*0.125, Color(219, 227, 255, 255))
                    draw.SimpleText(MEL_ScoreBoard.Translate["Grade"] .. " : " .. v:GetUserGroup(), "MELScoreBoard:Font:List", x*0.24, y*0.145, Color(219, 227, 255, 255))
                    draw.SimpleText(MEL_ScoreBoard.Translate["Meurtre"] .. " : " .. v:Frags(), "MELScoreBoard:Font:List", x*0.24, y*0.165, Color(219, 227, 255, 255))
                    draw.SimpleText(MEL_ScoreBoard.Translate["Mort"] .. " : " .. v:Deaths(), "MELScoreBoard:Font:List", x*0.24, y*0.185, Color(219, 227, 255, 255))
                    draw.SimpleText(MEL_ScoreBoard.Translate["Argent"] .. " : " .. v:getDarkRPVar("money") .. " ₩", "MELScoreBoard:Font:List", x*0.24, y*0.205, Color(219, 227, 255, 255))
                    draw.SimpleText(MEL_ScoreBoard.Translate["Métier"] .. " : " .. v:getDarkRPVar("job"), "MELScoreBoard:Font:List", x*0.24, y*0.225, Color(219, 227, 255, 255))
                    draw.SimpleText(MEL_ScoreBoard.Translate["Vie"] .. " : " .. v:Health(), "MELScoreBoard:Font:List", x*0.24, y*0.245, Color(219, 227, 255, 255))
                    draw.SimpleText(MEL_ScoreBoard.Translate["Armure"] .. " : " .. v:Armor(), "MELScoreBoard:Font:List", x*0.24, y*0.265, Color(219, 227, 255, 255))
                    draw.SimpleText(MEL_ScoreBoard.Translate["Faim"] .. " : " .. math.Round(v:getDarkRPVar("Energy") or 0), "MELScoreBoard:Font:List", x*0.24, y*0.285, Color(219, 227, 255, 255))
                end
    
                local CopySteamID = vgui.Create("DButton", SecondFrame)
                CopySteamID:SetPos(x*0.24, y*0.125)
                CopySteamID:SetSize(x*0.1, y*0.018)
                CopySteamID:SetText("")
                CopySteamID.Paint = function(self, w, h)
                end
    
                CopySteamID.DoClick = function()
    
                    SetClipboardText(v:SteamID())
                end
    
                local BackButton = vgui.Create("DButton", SecondFrame)
                BackButton:SetPos(W(1093.36), H(103.86))
                BackButton:SetSize(x*0.015, y*0.03)
                BackButton:SetText("")
                BackButton.Paint = function(self, w, h)
                    surface.SetMaterial(MEL_ScoreBoard.Materials["Cube"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0, y*0, w, h)
                end
                BackButton.DoClick = function()
    
                    if IsValid(SecondFrame) then SecondFrame:Close() end
                    MELScoreBoardDraw()  
                end
                
                local Avatar = vgui.Create("AvatarImage", SecondFrame)
                Avatar:SetPos(x*0.1, y*0.1)
                Avatar:SetSize(x*0.128, x*0.128)
                Avatar:SetPlayer(v, 128)
                
                local BanButton = vgui.Create("DButton", SecondFrame)
                BanButton:SetPos(x*0.1, y*0.35)
                BanButton:SetSize(x*0.05, y*0.04)
                BanButton:SetText("")
                BanButton.Paint = function(self, w, h)
                    if self:IsHovered() then
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(219, 227, 255, 10)
                        surface.DrawRect(x*0, y*0, w, h)
                    else
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(x*0, y*0, w, h)
                    end     
                    surface.SetMaterial(MEL_ScoreBoard.Materials["Marteau"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0.007, y*0.009, h*0.6, h*0.6)
                    draw.SimpleText(MEL_ScoreBoard.Translate["Bannissement"], "MELScoreBoard:Font:Button", x*0.027, y*0.005, Color(219, 227, 255, 255))
                end
                BanButton.DoClick = function()
    
                    if IsValid(MainFrame) then MainFrame:Close() end
                    if IsValid(SecondFrame) then SecondFrame:Close() end
    
                    local BanTime = 60
                    local NICK = ""
                    local reason = "Если вы считаете, что это ошибка, пожалуйста, свяжитесь с нами: скоро..."
                    local M,H,D,W,Y = BanTime % 60,
                    math.floor(BanTime / 60) % 24,
                    math.floor(BanTime / 1440) % 7,
                    math.floor(BanTime / 10080) % 53,
                    math.floor(BanTime / 525948)
                    local Window = vgui.Create("DFrame")
                    Window:SetTitle("")
                    Window:SetDraggable( false )
                    Window:ShowCloseButton(false)
                    Window:SetBackgroundBlur( true )
                    Window:SetDrawOnTop( true )
                    Window.Paint = function(self, w, h)
                        draw.RoundedBox(6, x*0, y*0, w, h, MEL_ScoreBoard.Color["Bleu1"])
                    end
    
                    local InnerPanel = vgui.Create("DPanel", Window)
                    InnerPanel:SetPaintBackground(false)
    
                    local Text = vgui.Create("DLabel", InnerPanel)
                    Text:SetText("Бан " .. v:Name() .. "")
                    Text:SizeToContents()
                    Text:SetContentAlignment( 5 )
                    Text:SetFont("MELScoreBoard:Font:Grade")
    
                    local TimePanel = vgui.Create("DPanel", Window)
                    TimePanel:SetPaintBackground(false)
    
                    local TextEntry = vgui.Create("DTextEntry", TimePanel)
                    TextEntry:SetText(DarkRP.deLocalise(reason))
                    TextEntry.OnEnter = function() Window:Close() end
                    function TextEntry:OnFocusChanged(changed)
                        self:RequestFocus()
                        self:SelectAllText(true)
                    end
    
                    local Minutes = vgui.Create("DNumberWang", TimePanel)
                    Minutes:SetMinMax(0, 59)
                    Minutes:SetDecimals(0)
                    Minutes:SetValue(M)
    
                    local Hours = vgui.Create("DNumberWang", TimePanel)
                    Hours:SetMinMax(0, 23)
                    Hours:SetValue(H)
                    Hours:SetDecimals(0)
    
                    local Days = vgui.Create("DNumberWang", TimePanel)
                    Days:SetMinMax(0, 6)
                    Days:SetValue(D)
                    Days:SetDecimals(0)
    
                    local Weeks = vgui.Create("DNumberWang", TimePanel)
                    Weeks:SetMinMax(0, 53)
                    Weeks:SetValue(W)
                    Weeks:SetDecimals(0)
    
                    local Years = vgui.Create("DNumberWang", TimePanel)
                    Years:SetMinMax(0, 3)
                    Years:SetValue(Y)
                    Years:SetDecimals(0)
    
                    local MinLabel, HourLabel, DayLabel, WeekLabel, YearLabel = vgui.Create("DLabel", TimePanel), vgui.Create("DLabel", TimePanel),
                    vgui.Create("DLabel", TimePanel), vgui.Create("DLabel", TimePanel), vgui.Create("DLabel", TimePanel)
                    MinLabel:SetText("Минуты:")
                    HourLabel:SetText("Часы:")
                    DayLabel:SetText("Дни:")
                    WeekLabel:SetText("Недели:")
                    YearLabel:SetText("Годы:")
    
    
                    MinLabel:SetPos(370, 0)
                    HourLabel:SetPos(280, 0)
                    DayLabel:SetPos(190, 0)
                    WeekLabel:SetPos(100, 0)
                    YearLabel:SetPos(10, 0)
    
                    local function update()
                        BanTime = M + H * 60 + D * 1440 + W * 10080 + Y * 525948
                    end
    
                    function Minutes:OnValueChanged(val) if val == M then return end M = val update() end
                    function Hours:OnValueChanged(val) if val == H then return end H = val update() end
                    function Days:OnValueChanged(val) if val == D then return end D = val update() end
                    function Weeks:OnValueChanged(val) if val == W then return end W = val update() end
                    function Years:OnValueChanged(val) if val == Y then return end Y = val update() end
    
                    local ButtonPanel = vgui.Create("DPanel", Window)
                    ButtonPanel:SetTall(25)
                    ButtonPanel:SetPaintBackground(false)
    
                    local Button = vgui.Create("DButton", ButtonPanel)
                    Button:SetText("Забанить")
                    Button:SizeToContents()
                    Button:SetTall( 20 )
                    Button:SetWide( Button:GetWide() + 20 )
                    Button:SetPos(5, 3)
                    Button.DoClick = function()
        
                        Window:Close()
                        M, H, D, W, Y = Minutes:GetValue(), Hours:GetValue(), Days:GetValue(), Weeks:GetValue(), Years:GetValue()
                        update()
                        RunConsoleCommand("sam", "ban", name, BanTime, (TextEntry and TextEntry:GetValue()) or "")
                    end
    
                    local ButtonCancel = vgui.Create("DButton", ButtonPanel )
                    ButtonCancel:SetText("Отмена")
                    ButtonCancel:SizeToContents()
                    ButtonCancel:SetTall( 20 )
                    ButtonCancel:SetWide( Button:GetWide() + 20 )
                    ButtonCancel:SetPos(5, 3)
                    ButtonCancel.DoClick = function()
        
                        Window:Close()
                     end
                    ButtonCancel:MoveRightOf( Button, 5 )
    
                    ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
    
                    Window:SetSize( 450, 111 + 75 + 20 )
                    Window:Center()
    
                    InnerPanel:StretchToParent( 5, 25, 5, 125 )
                    TimePanel:StretchToParent(5, 83, 5, 37)
    
                    Minutes:SetPos(370, 20)
                    Hours:SetPos(280, 20)
                    Days:SetPos(190, 20)
                    Weeks:SetPos(100, 20)
                    Years:SetPos(10, 20)
    
                    Text:StretchToParent( 5, 5, 5, nil )
    
                    TextEntry:StretchToParent( 5, nil, 5, nil )
                    TextEntry:AlignBottom( 5 )
    
                    TextEntry:RequestFocus()
    
                    ButtonPanel:CenterHorizontal()
                    ButtonPanel:AlignBottom(7)
    
                    Window:MakePopup()
                    Window:DoModal()
                end
    
                local KickButton = vgui.Create("DButton", SecondFrame)
                KickButton:SetPos(x*0.16, y*0.35)
                KickButton:SetSize(x*0.052, y*0.04)
                KickButton:SetText("")
                KickButton.Paint = function(self, w, h)
                    if self:IsHovered() then
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(219, 227, 255, 10)
                        surface.DrawRect(x*0, y*0, w, h)
                    else
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(x*0, y*0, w, h)
                    end                     
                    surface.SetMaterial(MEL_ScoreBoard.Materials["Marteau"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0.007, y*0.009, h*0.6, h*0.6)
                    draw.SimpleText(MEL_ScoreBoard.Translate["Expulsé"], "MELScoreBoard:Font:Button", x*0.027, y*0.005, Color(219, 227, 255, 255))
                end
                KickButton.DoClick = function()
    
                    if IsValid(MainFrame) then MainFrame:Close() end
                    if IsValid(SecondFrame) then SecondFrame:Close() end
    
                    local NICK = name
    
                    local Window = vgui.Create("DFrame")
                    Window:SetTitle("")
                    Window:SetDraggable( false )
                    Window:ShowCloseButton( false )
                    Window:SetBackgroundBlur( true )
                    Window:SetDrawOnTop( true )
                    Window.Paint = function(self, w, h)
                        draw.RoundedBox(6, x*0, y*0, w, h, MEL_ScoreBoard.Color["Bleu1"])
                    end
    
                    local InnerPanel = vgui.Create("DPanel", Window)
                    InnerPanel:SetPaintBackground(false)
    
                    local Text = vgui.Create("DLabel", InnerPanel)
                    Text:SetText("Кик " .. v:Name())
                    Text:SizeToContents()
                    Text:SetContentAlignment( 5 )
                    Text:SetTextColor( Color(219, 227, 255, 255) )
    
                    local TextEntry = vgui.Create("DTextEntry", InnerPanel )
                    TextEntry:SetPlaceholderText("Введите причину...")
                    TextEntry.OnEnter = function() Window:Close() end
                    function TextEntry:OnFocusChanged(changed)
                        self:RequestFocus()
                        self:SelectAllText(true)
                    end
    
                    local ButtonPanel = vgui.Create("DPanel", Window)
                    ButtonPanel:SetTall(30)
                    ButtonPanel:SetPaintBackground(false)
    
                    local Button = vgui.Create("DButton", ButtonPanel)
                    Button:SetText("Кикнуть")
                    Button:SizeToContents()
                    Button:SetTall( 20 )
                    Button:SetWide( Button:GetWide() + 20 )
                    Button:SetPos( 5, 5 )
                    Button.DoClick = function() 
                        Window:Close() 
                        RunConsoleCommand("sam", "kick", NICK, TextEntry:GetValue()) 
                    end
    
                    local ButtonCancel = vgui.Create("DButton", ButtonPanel )
                    ButtonCancel:SetText("Отмена")
                    ButtonCancel:SizeToContents()
                    ButtonCancel:SetTall( 20 )
                    ButtonCancel:SetWide( Button:GetWide() + 20 )
                    ButtonCancel:SetPos( 5, 5 )
                    ButtonCancel.DoClick = function()
                        Window:Close() 
                    end
                    ButtonCancel:MoveRightOf( Button, 5 )
    
                    ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
    
                    local w, h = Text:GetSize()
                    w = math.max( w, 400 )
    
                    Window:SetSize( w + 50, h + 25 + 75 + 10 )
                    Window:Center()
    
                    InnerPanel:StretchToParent( 5, 25, 5, 45 )
    
                    Text:StretchToParent( 5, 5, 5, 35 )
    
                    TextEntry:StretchToParent( 5, nil, 5, nil )
                    TextEntry:AlignBottom( 5 )
    
                    TextEntry:RequestFocus()
    
                    ButtonPanel:CenterHorizontal()
                    ButtonPanel:AlignBottom( 8 )
    
                    Window:MakePopup()
                    Window:DoModal()
                end
    
                local TPButton = vgui.Create("DButton", SecondFrame)
                TPButton:SetPos(x*0.222, y*0.35)
                TPButton:SetSize(x*0.06, y*0.04)
                TPButton:SetText("")
                TPButton.Paint = function(self, w, h)
                    if self:IsHovered() then
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(219, 227, 255, 10)
                        surface.DrawRect(x*0, y*0, w, h)
                    else
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(x*0, y*0, w, h)
                    end                     
                    surface.SetMaterial(MEL_ScoreBoard.Materials["Magie"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0.007, y*0.009, h*0.6, h*0.6)
                    draw.SimpleText(MEL_ScoreBoard.Translate["Téléporter"], "MELScoreBoard:Font:Button", x*0.027, y*0.005, Color(219, 227, 255, 255))
                end
                TPButton.DoClick = function()
                    RunConsoleCommand("sam", "bring", name)
                end
    
                local GotoButton = vgui.Create("DButton", SecondFrame)
                GotoButton:SetPos(x*0.292, y*0.35)
                GotoButton:SetSize(x*0.063, y*0.04)
                GotoButton:SetText("")
                GotoButton.Paint = function(self, w, h)
                    if self:IsHovered() then
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(219, 227, 255, 10)
                        surface.DrawRect(x*0, y*0, w, h)
                    else
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(x*0, y*0, w, h)
                    end                     
                    surface.SetMaterial(MEL_ScoreBoard.Materials["Goto"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0.007, y*0.009, h*0.6, h*0.6)
                    draw.SimpleText(MEL_ScoreBoard.Translate["Goto"], "MELScoreBoard:Font:Button", x*0.027, y*0.005, Color(219, 227, 255, 255))
                end
                GotoButton.DoClick = function()
    
                    RunConsoleCommand("sam", "goto", name)
                end
    
                local GodButton = vgui.Create("DButton", SecondFrame)
                GodButton:SetPos(x*0.365, y*0.35)
                GodButton:SetSize(x*0.08, y*0.04)
                GodButton:SetText("")
                GodButton.Paint = function(self, w, h)
                    if not MELTabGodEnbl then
                        if self:IsHovered() then
                            surface.SetDrawColor(219, 227, 255, 255)
                            surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                            surface.SetDrawColor(0, 0, 0, 100)
                            surface.DrawRect(x*0, y*0, w, h)
                        else
                            surface.SetDrawColor(219, 227, 255, 255)
                            surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                            surface.SetDrawColor(219, 227, 255, 10)
                            surface.DrawRect(x*0, y*0, w, h)
                        end    
    
                    else
                        if self:IsHovered() then
                            surface.SetDrawColor(219, 227, 255, 255)
                            surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                            surface.SetDrawColor(219, 227, 255, 10)
                            surface.DrawRect(x*0, y*0, w, h)
                        else
                            surface.SetDrawColor(219, 227, 255, 255)
                            surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                            surface.SetDrawColor(0, 0, 0, 100)
                            surface.DrawRect(x*0, y*0, w, h)
                        end     
                    end
                    surface.SetMaterial(MEL_ScoreBoard.Materials["Illuminati"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0.007, y*0.009, h*0.6, h*0.6)
                    draw.SimpleText(MEL_ScoreBoard.Translate["Invincible"], "MELScoreBoard:Font:Button", x*0.027, y*0.005, Color(219, 227, 255, 255))
                end
                GodButton.DoClick = function()
    
                    if MELTabGodEnbl == true then
                        RunConsoleCommand("sam", "god", name)
                        MELTabGodEnbl = false
                    else
                        RunConsoleCommand("sam", "ungod", name)
                        MELTabGodEnbl = true
                    end
                end
    
                local CloakButton = vgui.Create("DButton", SecondFrame)
                CloakButton:SetPos(x*0.455, y*0.35)
                CloakButton:SetSize(x*0.062, y*0.04)
                CloakButton:SetText("")
                CloakButton.Paint = function(self, w, h)
                    if not MELTabCloakEnbl then
                        if self:IsHovered() then
                            surface.SetDrawColor(219, 227, 255, 255)
                            surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                            surface.SetDrawColor(0, 0, 0, 100)
                            surface.DrawRect(x*0, y*0, w, h)
                        else
                            surface.SetDrawColor(219, 227, 255, 255)
                            surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                            surface.SetDrawColor(219, 227, 255, 10)
                            surface.DrawRect(x*0, y*0, w, h)
                        end    
    
                    else
                        if self:IsHovered() then
                            surface.SetDrawColor(219, 227, 255, 255)
                            surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                            surface.SetDrawColor(219, 227, 255, 10)
                            surface.DrawRect(x*0, y*0, w, h)
                        else
                            surface.SetDrawColor(219, 227, 255, 255)
                            surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                            surface.SetDrawColor(0, 0, 0, 100)
                            surface.DrawRect(x*0, y*0, w, h)
                        end 
                    end             
                    surface.SetMaterial(MEL_ScoreBoard.Materials["Invisible"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0.007, y*0.009, h*0.6, h*0.6)
                    draw.SimpleText(MEL_ScoreBoard.Translate["Invisible"], "MELScoreBoard:Font:Button", x*0.027, y*0.005, Color(219, 227, 255, 255))
                end
                CloakButton.DoClick = function()
    
                    if MELTabCloakEnbl == true then
                        RunConsoleCommand("sam", "cloak", name)
                        MELTabCloakEnbl = false
                    else
                        RunConsoleCommand("sam", "uncloak", name)
                        MELTabCloakEnbl = true
                    end
                end
    
                local StripButton = vgui.Create("DButton", SecondFrame)
                StripButton:SetPos(x*0.527, y*0.35)
                StripButton:SetSize(x*0.06, y*0.04)
                StripButton:SetText("")
                StripButton.Paint = function(self, w, h)
                    if self:IsHovered() then
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(219, 227, 255, 10)
                        surface.DrawRect(x*0, y*0, w, h)
                    else
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(x*0, y*0, w, h)
                    end                     
                    surface.SetMaterial(MEL_ScoreBoard.Materials["Strip"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0.007, y*0.009, h*0.6, h*0.6)
                    draw.SimpleText(MEL_ScoreBoard.Translate["Enlever Les Armes"], "MELScoreBoard:Font:Button", x*0.027, y*0.005, Color(219, 227, 255, 255))
                end
                StripButton.DoClick = function()
                    RunConsoleCommand("sam", "strip", name)
                end
    
                local SetTeamButton = vgui.Create("DButton", SecondFrame)
                SetTeamButton:SetPos(x*0.1, y*0.4)
                SetTeamButton:SetSize(x*0.095, y*0.04)
                SetTeamButton:SetText("")
                SetTeamButton.Paint = function(self, w, h)
                    if self:IsHovered() then
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(219, 227, 255, 10)
                        surface.DrawRect(x*0, y*0, w, h)
                    else
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(x*0, y*0, w, h)
                    end                     
                    surface.SetMaterial(MEL_ScoreBoard.Materials["SetTeam"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0.007, y*0.009, h*0.6, h*0.6)
                    draw.SimpleText(MEL_ScoreBoard.Translate["Changer De Jobs"], "MELScoreBoard:Font:Button", x*0.027, y*0.005, Color(219, 227, 255, 255))
                end
                SetTeamButton.DoClick = function()
                    local SetTeamDMenu = DermaMenu() 
                    for _, y in pairs(team.GetAllTeams()) do
                        SetTeamDMenu:AddOption( y.Name, function() RunConsoleCommand("sam", "setjob", v:Name(), y.Name) end )
                    end
                    SetTeamDMenu:Open()
                    SetTeamDMenu.Paint = function(self, w, h)
                        draw.RoundedBox(6, x*0, y*0, w, h, MEL_ScoreBoard.Color["Bleu1"])
                    end
                end
    
                local FreezeButton = vgui.Create("DButton", SecondFrame)
                FreezeButton:SetPos(x*0.205, y*0.4)
                FreezeButton:SetSize(x*0.065, y*0.04)
                FreezeButton:SetText("")
                FreezeButton.Paint = function(self, w, h)
                    if self:IsHovered() then
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(219, 227, 255, 10)
                        surface.DrawRect(x*0, y*0, w, h)
                    else
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(x*0, y*0, w, h)
                    end     
                    surface.SetMaterial(MEL_ScoreBoard.Materials["Freeze"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0.007, y*0.009, h*0.6, h*0.6)
                    draw.SimpleText(MEL_ScoreBoard.Translate["Geler"], "MELScoreBoard:Font:Button", x*0.027, y*0.005, Color(219, 227, 255, 255))
                end
                FreezeButton.DoClick = function()
                    if MELTabFreezeEnbl == true then
                        RunConsoleCommand("sam", "freeze", name)
                        MELTabFreezeEnbl = false
                    else
                        RunConsoleCommand("sam", "unfreeze", name)
                        MELTabFreezeEnbl = true
                    end
                end

                local SpectateButton = vgui.Create("DButton", SecondFrame)
                SpectateButton:SetPos(x*0.280, y*0.4)
                SpectateButton:SetSize(x*0.08, y*0.04)
                SpectateButton:SetText("")
                SpectateButton.Paint = function(self, w, h)
                    if self:IsHovered() then
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(219, 227, 255, 10)
                        surface.DrawRect(x*0, y*0, w, h)
                    else
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(x*0, y*0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(x*0, y*0, w, h)
                    end                
                    surface.SetMaterial(MEL_ScoreBoard.Materials["Invisible"])
                    surface.SetDrawColor(Color(219, 227, 255, 255))
                    surface.DrawTexturedRect(x*0.007, y*0.009, h*0.6, h*0.6)
                    draw.SimpleText("Spectate", "MELScoreBoard:Font:Button", x*0.027, y*0.005, Color(219, 227, 255, 255))
                end
                SpectateButton.DoClick = function()
                    RunConsoleCommand("FSpectate", v:UserID())
                end
            end
        end
    end
end

local function MELScoreBoardP(pPlayer, iKey)
    if iKey == IN_SCORE then
        MELScoreBoardDraw()
        gui.EnableScreenClicker(true)
    end
end

local function MELScoreBoardR(pPlayer, iKey)
    if iKey == IN_SCORE then
        if IsValid(MainFrame) then MainFrame:Close() end
        if IsValid(SecondFrame) then SecondFrame:Close() end
        gui.EnableScreenClicker(false)
    end
end

hook.Add("KeyPress", "MELScoreBoard:KeyPress", MELScoreBoardP)
hook.Add("KeyRelease", "MELScoreBoard:KeyRelease", MELScoreBoardR)

local function MELScoreBoardOpen()
    return true
end

local function MELScoreBoardClose()
	return true
end

hook.Add("ScoreboardShow", "MELScoreBoard:ScoreboardShow", MELScoreBoardOpen)
hook.Add("ScoreboardHide", "MELScoreBoard:ScoreboardHide", MELScoreBoardClose)