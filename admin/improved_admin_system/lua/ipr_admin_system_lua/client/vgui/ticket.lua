---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

if not (Admin_System_Global.TicketLoad) then 
     return 
end

local ipr_Tickets = {}
ipr_Tickets.GuiT = {}

net.Receive("Admin_Sys:Remv_Tick",function()
    local Admin_Sys_Ent = net.ReadEntity()

    for _, v in pairs(ipr_Tickets.GuiT) do
        if not IsValid(v) then
            continue
        end
        if (v.PlayerAT ~= Admin_Sys_Ent) then
            continue
        end
        
        v:Remove()
    end
end)

net.Receive("Admin_Sys:Notif", function()
    local Admin_Sys_String = net.ReadString()
    Admin_System_Global:Notification(Admin_Sys_String)
end)

net.Receive("Admin_Sys:Take_Tick",function()
    local Admin_Sys_TblTake, Admin_Sys_Int = {}, 2
    for i = 1, Admin_Sys_Int do
        Admin_Sys_TblTake[i] = net.ReadEntity()
    end
    if not IsValid(Admin_Sys_TblTake[1]) or not IsValid(Admin_Sys_TblTake[2]) then
        return
    end

    local ipr_Pl = LocalPlayer()
    for k, v in pairs(ipr_Tickets.GuiT) do 
        if (v.PlayerAT == Admin_Sys_TblTake[2]) then
            local ipr_AUserID = Admin_Sys_TblTake[1]:UserID()
            
            if (v.Admin_Sys_Waiting_Val ~= Admin_System_Global.lang["ticket_wait"] and v.Admin_Sys_Waiting_Val ~= ipr_AUserID) then
                local ipr_AUserName = Admin_Sys_TblTake[1]:Nick()
                Admin_Sys_TblTake[2]:PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["ticket_notif_"].. ""..ipr_AUserName)
            end

            local ipr_ValidUser = (Admin_Sys_TblTake[1] == ipr_Pl)
            local ipr_Children = v:GetChildren()
            for _, v in ipairs(ipr_Children) do
                if not IsValid(v) then
                    return
                end
                
                if (v.Child == 1) then
                    v:SetVisible((ipr_ValidUser) and false or true)
                end
                if (v.Child == 2) then
                    v:SetVisible(ipr_ValidUser)
                end
            end
            
            v.Admin_Sys_Waiting_Val = ipr_AUserID
            v.Admin_Sys_Col_Wait = Color(41, 128, 185)
        end
    end
end)

local function Admin_Sys_ReturnIDtoName(id, panel)
     if not IsValid(panel) then
         return ""
     end

     local ipr_CPlayer = ents.FindByClass("player")
     for _, v in ipairs(ipr_CPlayer) do
        local ipr_UserID = v:UserID()
        if (panel.Admin_Sys_Waiting_Val ~= ipr_UserID) then
            continue
        end

        return v:Nick()
     end

     return Admin_System_Global.lang["ticket_disco"]
end
 
local function Admin_Sys_Status(a, b, p, g)
    if not IsValid(p) and IsValid(g) then
        g:Remove()

        return false, a:PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["ticket_disco"])
    end

    if (b) then
        for _, v in pairs(ipr_Tickets.GuiT) do
            if (v.Admin_Sys_Waiting_Val == a:UserID() and v.PlayerAT == p) then
                return true
            end
        end

        return false, a:PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["ticket_taking_charge"])
    end
    if not Admin_System_Global.Ticket_TakePerm and Admin_System_Global:Sys_Check(a) or a:AdminStatusCheck() then
        return true
    end

    return false, a:PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["ticket_modeadmin_notif"])
end

local function Admin_Sys_RemoveTick(e, t)
    net.Start("Admin_Sys:Remv_Tick")
    net.WriteEntity(e)
    net.WriteBool(true)
    net.WriteString(t)
    net.SendToServer()
end

local function ipr_ClearDelay(e)
    if not IsValid(e) then
        return
    end

    local ipr_Steam64 = e:SteamID64()
    if (timer.Exists("Admin_Sys_Tick_Delay"..ipr_Steam64)) then
        timer.Remove("Admin_Sys_Tick_Delay"..ipr_Steam64)
    end
end

local function ipr_TextMaxChar(t)
    return (#t > 25) and t:sub(1, 25).. ".." or t
end

local function Admin_Sys_LoadText(e, t)
    for _, ck in pairs(ipr_Tickets.GuiT) do
        if (ck.PlayerAT == e) then
            ck:GetChildren()[6]:AppendText("\n".. t)
            ck:GetChildren()[6]:GotoTextEnd()

            if (Admin_System_Global.Ticket_Delai ~= 0) then
                ipr_ClearDelay(e)

                local ipr_Steam64 = e:SteamID64()
                timer.Create("Admin_Sys_Tick_Delay" ..ipr_Steam64, Admin_System_Global.Ticket_Delai, 1, function()
                    if not IsValid(ck) then
                        return
                    end

                    net.Start("Admin_Sys:TP_Reset")
                    net.WriteUInt(2, 4)
                    net.WriteEntity(e)
                    net.SendToServer()

                    ck:Remove()
                end)
            end

            return true
        end
    end

    return false
end 

ipr_Tickets.Pos = {
    ["ticket"] = {
        w = {
            ["droite"] = ScrW() - 310,
            ["gauche"] = 10,
        },
        h = {
            ["haut"] = 270,
            ["milieu"] = ScrH() / 2 + 105,
        },
    },
    ["ticket_"] = {
        w = {
            ["droite"] = ScrW() - 45,
            ["gauche"] = 160,
        },
        h = {
            ["haut"] = 20,
            ["milieu"] = ScrH() / 2 - 140,
        },
    },
    ["_ticket_"] = {
        w = {
            notifmove = {
                ["gauche"] = 25,
                ["droite"] = 175,
            },
            notifpos = {
                ["gauche"] = -100,
                ["droite"] = ScrW() - 70,
            },
            notifmoveto = {
                ["gauche"] = 10,
                ["droite"] = ScrW() - 215,
            },
            notifnpos = {
                ["gauche"] = 82,
                ["droite"] = 117,
            },
            roundedbox = {
                ["gauche"] = 82,
                ["droite"] = 117,
            },
            btset = {
                ["gauche"] = 2,
                ["droite"] = 180,
            },
            movet = {
                ["gauche"] = -160,
                ["droite"] = ScrW() - 45,
            },
            movetpos = {
                ["gauche"] = 25,
                ["droite"] = 175,
            },
            bt1 = {
                ["gauche"] = 24,
                ["droite"] = 159,
            },
        },
    },
}

ipr_Tickets.GuiN = false
ipr_Tickets.GuiVisible = false
local function ipr_NotifTicket()
    surface.PlaySound(Admin_System_Global.Notif_Son)
    if IsValid(ipr_Tickets.GuiN) then
        return
    end
    ipr_Tickets.GuiN = vgui.Create("DFrame")

    local Admin_Sys_Notification_BT = vgui.Create("DImageButton",ipr_Tickets.GuiN)
    local Admin_Sys_Notification_BT_1 = vgui.Create("DImageButton",ipr_Tickets.GuiN)

    ipr_Tickets.GuiN:SetSize(200, 27)
    ipr_Tickets.GuiN:SetPos(ipr_Tickets.Pos["_ticket_"].w.notifpos[Admin_System_Global.Ticket_PosRdm_W], ipr_Tickets.Pos["ticket_"].h[Admin_System_Global.Ticket_PosRdm_H])
    ipr_Tickets.GuiN:SetTitle("")
    ipr_Tickets.GuiN:SetDraggable(true)
    ipr_Tickets.GuiN:ShowCloseButton(false)

    ipr_Tickets.GuiN:MoveTo(ipr_Tickets.Pos["_ticket_"].w.movet[Admin_System_Global.Ticket_PosRdm_W], ipr_Tickets.Pos["ticket_"].h[Admin_System_Global.Ticket_PosRdm_H], 0.3, 0,1)
    ipr_Tickets.GuiN:MoveToFront()

    local ipr_BoolHover = false
    local ipr_CTicketPos = (Admin_System_Global.Ticket_PosRdm_W == "gauche")
    ipr_Tickets.GuiN.Paint = function(self, w, h)
        local Admin_Sys_Math_Abs = math.abs(math.sin(CurTime() * 5) * 192)
        local Admin_Sys_Color_Cur = Color(Admin_Sys_Math_Abs, 57, 43)

        local ipr_Hovered = self:IsHovered()
        if (ipr_Hovered) then
            if not ipr_BoolHover then
                self:MoveTo(ipr_Tickets.Pos["_ticket_"].w.notifmoveto[Admin_System_Global.Ticket_PosRdm_W], ipr_Tickets.Pos["ticket_"].h[Admin_System_Global.Ticket_PosRdm_H] + 40, 0.3, 0, 1)
                ipr_BoolHover = true
            end
        end

        local ipr_Count = #ipr_Tickets.GuiT
        if (ipr_Count <= 0) then
            ipr_Tickets.GuiVisible = false
            ipr_Tickets.GuiN:Remove()
        end

        draw.RoundedBox(6, 0, 0, w, 26, Admin_System_Global.NotifTick)
        draw.RoundedBox(4, ipr_CTicketPos and w - 8 or 1, 1, 7, 23, Admin_Sys_Color_Cur)
        draw.DrawText(ipr_BoolHover and Admin_System_Global.lang["ticket_modeadmin_att"].. "(" ..ipr_Count.. ") " or "+ " ..ipr_Count, "Admin_Sys_Font_T1", w - (ipr_BoolHover and ipr_Tickets.Pos["_ticket_"].w.notifnpos[Admin_System_Global.Ticket_PosRdm_W] or ipr_Tickets.Pos["_ticket_"].w.movetpos[Admin_System_Global.Ticket_PosRdm_W]), 4, Admin_System_Global.NotifTickText, TEXT_ALIGN_CENTER)
    end

    Admin_Sys_Notification_BT:SetPos(ipr_Tickets.Pos["_ticket_"].w.btset[Admin_System_Global.Ticket_PosRdm_W], 4)
    Admin_Sys_Notification_BT:SetSize(17, 17)
    Admin_Sys_Notification_BT:SetImage("icon16/cross.png")
    function Admin_Sys_Notification_BT:Paint(w,h) end

    Admin_Sys_Notification_BT.DoClick = function()
        ipr_Tickets.GuiN:MoveTo(ipr_Tickets.Pos["_ticket_"].w.movet[Admin_System_Global.Ticket_PosRdm_W], ipr_Tickets.Pos["ticket_"].h[Admin_System_Global.Ticket_PosRdm_H], 0.3, 0, 1)

        ipr_BoolHover = false
        gui.EnableScreenClicker(false)
    end

    Admin_Sys_Notification_BT_1:SetPos(ipr_Tickets.Pos["_ticket_"].w.bt1[Admin_System_Global.Ticket_PosRdm_W], 4)
    Admin_Sys_Notification_BT_1:SetSize(17, 17)
    Admin_Sys_Notification_BT_1:SetImage("icon16/add.png")
    function Admin_Sys_Notification_BT_1:Paint(w, h) end
    Admin_Sys_Notification_BT_1.DoClick = function()
        local Admin_Sys_Derma = DermaMenu()

        local Admin_Sys_Option = Admin_Sys_Derma:AddOption(Admin_System_Global.lang["ticket_modeadmin_afftick"], function()
            for i = 1, #ipr_Tickets.GuiT do
                if (i > Admin_System_Global.Ticket_TicketVisible) then
                    break
                end

                ipr_Tickets.GuiT[i]:SetVisible(true)
            end

            ipr_Tickets.GuiVisible  = true
        end)

        local Admin_Sys_AddOption_1 = Admin_Sys_Derma:AddOption(Admin_System_Global.lang["ticket_modeadmin_cachtick"], function()
            for i = 1, #ipr_Tickets.GuiT do
                ipr_Tickets.GuiT[i]:SetVisible(false)
            end
        end)

        ipr_Tickets.GuiVisible  = false
        Admin_Sys_Derma:Open()
    end
end

local function ipr_CreateTicket(Admin_Sys_TblRes, Admin_Sys_Ent)
    if Admin_Sys_LoadText(Admin_Sys_Ent, Admin_Sys_TblRes[2]) then
        return
    end
    if (Admin_System_Global.Notif_Bool) then
        ipr_NotifTicket()
    else
        surface.PlaySound(Admin_System_Global.Notif_Son)
    end

    local Admin_Sys_Tick_Frame = vgui.Create("DFrame")
    local Admin_Sys_Tick_Scroll = vgui.Create( "DScrollPanel", Admin_Sys_Tick_Frame)
    local Admin_Sys_Tick_RichText = vgui.Create("RichText",Admin_Sys_Tick_Frame)
    local Admin_Sys_Tick_Dimage = vgui.Create("DImageButton",Admin_Sys_Tick_Frame)
    local Admin_Sys_Tick_Dimage_1 = vgui.Create("DImageButton",Admin_Sys_Tick_Frame)
    local Admin_Sys_Tick_BT = vgui.Create("DButton",Admin_Sys_Tick_Frame)
    local Admin_Sys_Tick_BT_1 = vgui.Create("DButton",Admin_Sys_Tick_Frame)

    Admin_Sys_Tick_Frame:SetTitle("")
    Admin_Sys_Tick_Frame:SetPos(ipr_Tickets.Pos["ticket"].w[Admin_System_Global.Ticket_PosRdm_W], ipr_Tickets.Pos["ticket"].h[Admin_System_Global.Ticket_PosRdm_H])
    Admin_Sys_Tick_Frame:SetSize(300, 145)
    Admin_Sys_Tick_Frame:ShowCloseButton(false)
    Admin_Sys_Tick_Frame:MoveToFront()
    Admin_Sys_Tick_Frame.Admin_Sys_Waiting_Val = Admin_System_Global.lang["ticket_wait"]
    Admin_Sys_Tick_Frame.PlayerAT = Admin_Sys_Ent

    timer.Simple(0.000001, function()
        for i = 1, #ipr_Tickets.GuiT do
            if Admin_System_Global.Notif_Bool then
                if not ipr_Tickets.GuiVisible  then
                    if IsValid(Admin_Sys_Tick_Frame) then
                        Admin_Sys_Tick_Frame:SetVisible(false)
                        break
                    end
                else
                    if (i > Admin_System_Global.Ticket_TicketVisible) then
                        ipr_Tickets.GuiT[i]:SetVisible(false)
                    else
                        ipr_Tickets.GuiT[i]:SetVisible(true)
                    end
                end
            else
                if (i > Admin_System_Global.Ticket_TicketVisible) then
                    ipr_Tickets.GuiT[i]:SetVisible(false)
                else
                    ipr_Tickets.GuiT[i]:SetVisible(true)
                end
            end
        end
    end)

    Admin_Sys_Tick_Frame.Admin_Sys_Col_Wait = Color(192, 57, 43)
    local ipr_Steam64 = Admin_Sys_Ent:SteamID64()
    function Admin_Sys_Tick_Frame:Paint(w, h)
        Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 150 ), 6)

        draw.RoundedBoxEx(5, 0, 0, w, h / 2 - 53, Admin_System_Global.TicketBorder, true, true, false, false)

        if (self.Admin_Sys_Waiting_Val == Admin_System_Global.lang["ticket_wait"]) then
            draw.SimpleTextOutlined(self.Admin_Sys_Waiting_Val ..Admin_System_Global:Admin_Sys_TicketDot(), "Admin_Sys_Font_T3", 20, 90, Admin_System_Global.TicketText, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 0.8, self.Admin_Sys_Col_Wait)
        else
            draw.SimpleTextOutlined(Admin_System_Global.lang["ticket_notif_taking_charge"], "Admin_Sys_Font_T3", 30, 80, Admin_System_Global.TicketText, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 0.8, self.Admin_Sys_Col_Wait)
            draw.SimpleTextOutlined(Admin_System_Global.Ticket_CachePCharge and Admin_System_Global.Ticket_CachePCharge_Text or Admin_Sys_ReturnIDtoName(self.Admin_Sys_Waiting_Val, self), "Admin_Sys_Font_T3", 90, 105, Admin_System_Global.TicketText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.8, self.Admin_Sys_Col_Wait)
        end

        draw.DrawText(Admin_System_Global.lang["ticket_tick"].. "" ..((IsValid(Admin_Sys_Ent) and ipr_TextMaxChar(Admin_Sys_Ent:Nick())) or "Déconnecté"), "Admin_Sys_Font_T3", w/2, 3, Admin_System_Global.TicketText, TEXT_ALIGN_CENTER )

        if (timer.Exists("Admin_Sys_Tick_Delay" ..ipr_Steam64)) then
            local ipr_TimeLeft = math.Round(timer.TimeLeft("Admin_Sys_Tick_Delay" ..ipr_Steam64))
            draw.DrawText("(" ..ipr_TimeLeft.. ")", "Admin_Sys_Font_T3", 7, 3, Admin_System_Global.TicketText, TEXT_ALIGN_LEFT)
        end
    end

    Admin_Sys_Tick_Frame:MoveTo(ipr_Tickets.Pos["ticket"].w[Admin_System_Global.Ticket_PosRdm_W], ipr_Tickets.Pos["ticket"].h[Admin_System_Global.Ticket_PosRdm_H] + 165 * (#ipr_Tickets.GuiT - 1), 0.3, 0,1)
    ipr_Tickets.GuiT[#ipr_Tickets.GuiT + 1] = Admin_Sys_Tick_Frame

    function Admin_Sys_Tick_Frame:OnRemove()
        for i = 1, #ipr_Tickets.GuiT do
            if (ipr_Tickets.GuiT[i] ~= self) then
                continue
            end

            table.remove(ipr_Tickets.GuiT, i)
        end

        timer.Simple(0.2, function()
            for i = 1, #ipr_Tickets.GuiT do
                ipr_Tickets.GuiT[i]:MoveTo(ipr_Tickets.Pos["ticket"].w[Admin_System_Global.Ticket_PosRdm_W], ipr_Tickets.Pos["ticket"].h[Admin_System_Global.Ticket_PosRdm_H] + 165 * (i - 1) - 165, 0.1, 0, 1)

                if (Admin_System_Global.Notif_Bool) then
                    if not ipr_Tickets.GuiVisible  then
                        if IsValid(Admin_Sys_Tick_Frame) then
                            Admin_Sys_Tick_Frame:SetVisible(false)
                            break
                        end
                    else
                        if (i > Admin_System_Global.Ticket_TicketVisible) then
                            ipr_Tickets.GuiT[i]:SetVisible(false)
                        else
                            ipr_Tickets.GuiT[i]:SetVisible(true)
                        end
                    end
                else
                    if (i > Admin_System_Global.Ticket_TicketVisible) then
                        ipr_Tickets.GuiT[i]:SetVisible(false)
                    else
                        ipr_Tickets.GuiT[i]:SetVisible(true)
                    end
                end
            end
        end)

        ipr_ClearDelay(e)
    end

    Admin_Sys_Tick_Scroll:SetPos(177, 26)
    Admin_Sys_Tick_Scroll:SetSize(120, 113)
    local Admin_Sys_Vbar = Admin_Sys_Tick_Scroll:GetVBar()
    Admin_Sys_Vbar:SetSize(7, 7)

    Admin_Sys_Vbar.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, Color(255, 255, 255, 15))
    end
    Admin_Sys_Vbar.btnUp.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, Admin_System_Global.TicketScrollUp)
    end
    Admin_Sys_Vbar.btnDown.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, Admin_System_Global.TicketScrollDown)
    end
    Admin_Sys_Vbar.btnGrip.Paint = function(self, w, h)
        draw.RoundedBox(2, 0, 0, w, h, Admin_System_Global.TicketScrollBar)
    end

    Admin_Sys_Tick_RichText:SetPos(5, 26)
    Admin_Sys_Tick_RichText:SetSize(185, 47)
    Admin_Sys_Tick_RichText:InsertColorChange(255, 255, 255, 255)
    Admin_Sys_Tick_RichText:SetVerticalScrollbarEnabled(true)

    local Admin_Sys_RichText_Children = Admin_Sys_Tick_RichText:GetChildren()[1]
    if IsValid(Admin_Sys_RichText_Children) then
        Admin_Sys_RichText_Children.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w - 1, h, Admin_System_Global.TicketScrollRichText)
        end
    end

    local Admin_Sys_RichText_Children_1 = Admin_Sys_Tick_RichText:GetChildren()[2]
    if IsValid(Admin_Sys_RichText_Children_1) then
        Admin_Sys_RichText_Children_1.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w - 1, h, Color(0, 0, 0, 15))
        end
    end

    function Admin_Sys_Tick_RichText:PerformLayout()
        self:SetFontInternal("Admin_Sys_Font_T3")
    end
    Admin_Sys_Tick_RichText:AppendText(Admin_Sys_TblRes[2])

    local ipr_Frame = {
        [7] = true,
        [8] = true,
        [3] = true,
    }
    for i = 1, #Admin_System_Global.Ipr_TkGen do
        local Admin_Sys_Table_GenBT = vgui.Create("DButton", Admin_Sys_Tick_Scroll)

        Admin_Sys_Table_GenBT:SetPos(15, 25 * i - 25)
        Admin_Sys_Table_GenBT:SetSize(95, 18)
        Admin_Sys_Table_GenBT:SetText("")

        Admin_Sys_Table_GenBT.Paint = function(self, w, h)
            draw.RoundedBox(3, 0, 0, w, h, Admin_System_Global.TicketBut)

            local ipr_Hover = self:IsHovered()
            draw.RoundedBox(6, 2, 0, ipr_Hover and w or 0, 1, Color(192, 57, 43))
            draw.DrawText(Admin_System_Global.Ipr_TkGen[i].Admin_Sys_String, "Admin_Sys_Font_T2", w/2, 2, Admin_System_Global.TicketButText, TEXT_ALIGN_CENTER)
        end

        Admin_Sys_Table_GenBT.DoClick = function()
            if not ipr_Frame[i] then
                if not Admin_Sys_Status(LocalPlayer(), true, Admin_Sys_Ent, Admin_Sys_Tick_Frame) then
                    return
                end
            end

            Admin_System_Global.Ipr_TkGen[i].Admin_Sys_Func(Admin_Sys_Ent)
            surface.PlaySound("buttons/button24.wav")
        end
    end

    Admin_Sys_Tick_BT:SetPos(47, 120)
    Admin_Sys_Tick_BT:SetSize(90, 18)
    Admin_Sys_Tick_BT:SetText("")
    Admin_Sys_Tick_BT.Child = 1

    Admin_Sys_Tick_BT.Paint = function(self, w, h)
        local ipr_Hover = self:IsHovered()
        draw.RoundedBox(3, 0, 0, w, h, ipr_Hover and Color(255, 99, 71) or Color(0, 179, 0))
       
        draw.RoundedBox(1, 1, 1, w - 2, h - 2, Admin_System_Global.Ticket_ColPrdrTick)
        draw.DrawText(Admin_System_Global.lang["ticket_prd"], "Admin_Sys_Font_T2", w / 2, 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    local ipr_Local = LocalPlayer()
    local ipr_UserId = ipr_Local:UserID()
    Admin_Sys_Tick_BT.DoClick = function()
        if not Admin_Sys_Status(ipr_Local, false, Admin_Sys_Ent, Admin_Sys_Tick_Frame) then
            return
        end
        if (Admin_System_Global.Ticket_AntiPCharge) and ((Admin_Sys_Tick_Frame.Admin_Sys_Waiting_Val ~= ipr_UserId) and (Admin_Sys_Tick_Frame.Admin_Sys_Waiting_Val ~= Admin_System_Global.lang["ticket_wait"])) then
            ipr_Local:PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["ticket_tickdj"])
            return
        end

        net.Start("Admin_Sys:Take_Tick")
        net.WriteEntity(Admin_Sys_Ent)
        net.SendToServer()
    end

    Admin_Sys_Tick_BT_1:SetPos(47, 120)
    Admin_Sys_Tick_BT_1:SetSize(90, 18)
    Admin_Sys_Tick_BT_1:SetText("")
    Admin_Sys_Tick_BT_1:SetVisible(false)
    Admin_Sys_Tick_BT_1.Child = 2

    Admin_Sys_Tick_BT_1.Paint = function(self, w, h)
        local ipr_Hover = self:IsHovered()
        draw.RoundedBox(3, 0, 0, w, h, ipr_Hover and Color(255, 99, 71) or Color(0, 179, 0))

        draw.RoundedBox(1, 1, 1, w - 2, h - 2, Admin_System_Global.Ticket_ColTickReso)
        draw.DrawText(Admin_System_Global.lang["ticket_reso"], "Admin_Sys_Font_T2", w/2, 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    Admin_Sys_Tick_BT_1.DoClick = function()
        if not IsValid(Admin_Sys_Ent) then
            Admin_Sys_Tick_Frame:Remove()
            return
        end
        if not Admin_Sys_Status(ipr_Local, true, Admin_Sys_Ent, Admin_Sys_Tick_Frame) then
            return
        end

        local Admin_Sys_DermaMenu = DermaMenu()
        local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption(Admin_System_Global.lang["ticket_resotp"], function()
            Admin_Sys_RemoveTick(Admin_Sys_Ent, Admin_Sys_TblRes[1])

            net.Start("Admin_Sys:TP_Reset")
            net.WriteUInt(2, 4)
            net.WriteEntity(Admin_Sys_Ent)
            net.SendToServer()
        end)

        local Admin_Sys_AddOption_1 = Admin_Sys_DermaMenu:AddOption(Admin_System_Global.lang["ticket_resonotp"],function()
            Admin_Sys_RemoveTick(Admin_Sys_Ent, Admin_Sys_TblRes[1])

            net.Start("Admin_Sys:TP_Reset")
            net.WriteUInt(1, 4)
            net.WriteEntity(Admin_Sys_Ent)
            net.SendToServer()
        end)

        Admin_Sys_DermaMenu:Open()
    end

    Admin_Sys_Tick_Dimage_1:SetPos(260, 3)
    Admin_Sys_Tick_Dimage_1:SetSize(14, 14)
    Admin_Sys_Tick_Dimage_1:SetTooltip(Admin_System_Global.lang["ticket_enabadmin"])

    local ipr_NoLoop = nil
    Admin_Sys_Tick_Dimage_1.Think = function()
        local ipr_Status = ipr_Local:AdminStatusCheck()

        if (ipr_Status ~= ipr_NoLoop) then
            Admin_Sys_Tick_Dimage_1:SetImage(ipr_Status and "icon16/shield_delete.png" or "icon16/shield_add.png")
            ipr_NoLoop = ipr_Status
        end
    end

    Admin_Sys_Tick_Dimage_1.DoClick = function()
        local Admin_Sys_DermaMenu = DermaMenu()
        local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption(ipr_Local:AdminStatusCheck() and Admin_System_Global.lang["ticket_desactadmin"] or Admin_System_Global.lang["ticket_activadmin"], function()
                net.Start("admin_sys:updatenw")
                net.SendToServer()
        end)

        if (ipr_Local:AdminStatusCheck()) then
            local Admin_Sys_AddOption_Choice = Admin_Sys_DermaMenu:AddOption(Admin_System_Global.lang["ticket_choice"])
            local Admin_Sys_AddOption_Sub, Admin_Sys_AddOption_Parent = Admin_Sys_AddOption_Choice:AddSubMenu(Admin_System_Global.lang["ticket_addpos"])

            local Admin_Sys_AddOption_Choice_1 = Admin_Sys_AddOption_Sub:AddOption(ipr_Local:GetMoveType() ~= MOVETYPE_NOCLIP and Admin_System_Global.lang["ticket_actnoclip"] or Admin_System_Global.lang["ticket_desactnoclip"], function()
                ipr_Local:ConCommand(Admin_System_Global.Mode_AddCmd_NoClip)
            end)
            local Admin_Sys_AddOption_Choice_2 = Admin_Sys_AddOption_Sub:AddOption(not ipr_Local:GetNoDraw() and Admin_System_Global.lang["ticket_actcloak"] or Admin_System_Global.lang["ticket_desactcloak"], function()
                ipr_Local:ConCommand(Admin_System_Global.Mode_AddCmd_Cloak)
            end)
            local Admin_Sys_AddOption_Choice_3 = Admin_Sys_AddOption_Sub:AddOption(not Admin_System_Global.SysGodModeStatus and Admin_System_Global.lang["ticket_actgodmode"] or Admin_System_Global.lang["ticket_desactgodmode"], function()
                ipr_Local:ConCommand(Admin_System_Global.Mode_AddCmd_GodMod)
            end)
        end

        Admin_Sys_DermaMenu:Open()
    end

    Admin_Sys_Tick_Dimage:SetPos(282, 3)
    Admin_Sys_Tick_Dimage:SetSize(16, 16)
    Admin_Sys_Tick_Dimage:SetImage("icon16/cross.png")

    Admin_Sys_Tick_Dimage.DoClick = function()
        local Admin_Sys_DermaMenu = DermaMenu()
        local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption(Admin_System_Global.lang["ticket_frmtick"], function()
            net.Start("Admin_Sys:TP_Reset")
            net.WriteUInt(2, 4)
            net.WriteEntity(Admin_Sys_Ent)
            net.SendToServer()

            Admin_Sys_Tick_Frame:Remove()
        end)

        Admin_Sys_DermaMenu:Open()
    end

    if (Admin_System_Global.Ticket_Delai ~= 0) then
        local ipr_Steam64 = Admin_Sys_Ent:SteamID64()

        timer.Create("Admin_Sys_Tick_Delay" ..ipr_Steam64, Admin_System_Global.Ticket_Delai, 1, function()
            if not IsValid(Admin_Sys_Tick_Frame) then
                return
            end

            net.Start("Admin_Sys:TP_Reset")
            net.WriteUInt(2, 4)
            net.WriteEntity(Admin_Sys_Ent)
            net.SendToServer()

            Admin_Sys_Tick_Frame:Remove()
        end)
    end
end

net.Receive("Admin_Sys:Gen_Tick", function()
    local Admin_Sys_Ent = net.ReadEntity()
    local Admin_Sys_Int = net.ReadUInt(8)
    if not IsValid(Admin_Sys_Ent) or not Admin_Sys_Ent:IsPlayer() then
        return
    end

    local Admin_Sys_Tbl = {}
    for i = 1, Admin_Sys_Int do
        Admin_Sys_Tbl[i] = net.ReadString()
    end
    
    Admin_Sys_Tbl[2] = Admin_Sys_Tbl[2] ~= "" and Admin_System_Global.lang["net_ticket_title"].. "" ..Admin_Sys_Tbl[1].. "\n" ..Admin_Sys_Tbl[2] or Admin_System_Global.lang["net_ticket_title"].. "" ..Admin_Sys_Tbl[1]
    ipr_CreateTicket(Admin_Sys_Tbl, Admin_Sys_Ent)
end)