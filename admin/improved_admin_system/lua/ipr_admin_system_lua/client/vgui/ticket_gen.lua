---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

if not (Admin_System_Global.TicketLoad) then
     return
end

local ipr_TGen = {}
local function Admin_Sys_Check_Frame(Admin_Sys_FrameComp, Admin_Sys_BoolOp)
    if IsValid(Admin_Sys_FrameComp) then
        Admin_Sys_FrameComp:Remove()
    end
    if not Admin_Sys_BoolOp then
        return
    end
    
    net.Start("Admin_Sys:Remv_Tick")
    net.WriteBool(false)
    net.SendToServer()
end

local function Admin_Sys_Frame_Comp(Admin_Sys_StringTitle)
    local Admin_Sys_Frame = vgui.Create( "DFrame" )
    local Admin_Sys_Dtext = vgui.Create( "DTextEntry", Admin_Sys_Frame )
    local Admin_Sys_BT_1 = vgui.Create( "DButton", Admin_Sys_Frame  )
    local Admin_Sys_Dimage = vgui.Create("DImageButton", Admin_Sys_Frame)
    local Admin_Sys_Dimage_Back = vgui.Create("DImageButton", Admin_Sys_Frame)
    local Admin_Sys_Number, Admin_Sys_StringText, Admin_Sys_ColVal, ipr_Char = 0, "", Color(192, 57, 43)

    Admin_Sys_Frame:SetTitle("")
    Admin_Sys_Frame:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(200, "h"))
    Admin_Sys_Frame:ShowCloseButton(false)
    Admin_Sys_Frame:SetDraggable(true)
    Admin_Sys_Frame:Center()
    Admin_Sys_Frame:MakePopup()
    Admin_Sys_Frame.Paint = function(self, w, h)
        Admin_System_Global:Gui_Blur(self, 1, Color(0, 0, 0, 140), 6)
        surface.SetDrawColor(Admin_System_Global.CreatetickColorCtr.r, Admin_System_Global.CreatetickColorCtr.g, Admin_System_Global.CreatetickColorCtr.b)
        surface.DrawOutlinedRect(0, 0, w, h, 5)
        
        draw.RoundedBox(1, Admin_System_Global:Size_Auto(5, "w"),  Admin_System_Global:Size_Auto(4, "h"), w - Admin_System_Global:Size_Auto(9, "w"), Admin_System_Global:Size_Auto(26, "h"), Admin_Sys_ColVal)
        draw.RoundedBox(1, Admin_System_Global:Size_Auto(4, "w"), Admin_System_Global:Size_Auto(4, "h"), w - Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(25, "h"), Admin_System_Global.CreatetickColorComp) 
        draw.DrawText(Admin_System_Global.lang["title"] .. "" .. Admin_Sys_StringTitle,"Admin_Sys_Font_T4",w / 2,Admin_System_Global:Size_Auto(6, "h"),Admin_System_Global.CreatetickColorCompTitle,TEXT_ALIGN_CENTER)
        draw.DrawText(Admin_System_Global.lang["reason"],"Admin_Sys_Font_T4",w / 2,Admin_System_Global:Size_Auto(45, "h"),Admin_System_Global.CreatetickColorCompTitle,TEXT_ALIGN_CENTER)
        ipr_Char = Admin_System_Global.CharMax

        if (Admin_Sys_Number > 0) then
            ipr_Char = Admin_System_Global.CharMax - Admin_Sys_Number
            Admin_Sys_ColVal = Color(39, 174, 96)
        end
        if (ipr_Char < 0) then
            ipr_Char = 0
        elseif (ipr_Char >= Admin_System_Global.CharMax) then
            Admin_Sys_ColVal = Color(192, 57, 43)
        end
        draw.DrawText(Admin_System_Global.lang["character"].. "" .. ipr_Char,"Admin_Sys_Font_T4",w / 2,Admin_System_Global:Size_Auto(125, "h"), Admin_System_Global.CreatetickColorCompTextChar, TEXT_ALIGN_CENTER)
    end

    Admin_Sys_Dtext:SetPos(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(80, "h"))
    Admin_Sys_Dtext:SetSize(Admin_System_Global:Size_Auto(250, "w"), Admin_System_Global:Size_Auto(25, "h"))
    Admin_Sys_Dtext:SetText(Admin_System_Global.lang["complaint"])
    Admin_Sys_Dtext:SetFont("Admin_Sys_Font_T4")
    Admin_Sys_Dtext.MaxCaractere = Admin_System_Global.CharMax
    Admin_Sys_Dtext.OnGetFocus = function()
        if (Admin_Sys_Dtext:GetText() == Admin_System_Global.lang["complaint"]) then
            Admin_Sys_Dtext:SetTextColor(Color(0, 0, 0, 255))
            Admin_Sys_Dtext:SetText("")
        end
    end
    Admin_Sys_Dtext.OnTextChanged = function(self)
        Admin_Sys_StringText = self:GetValue()
        Admin_Sys_Number = string.len(Admin_Sys_StringText)
        
        if (Admin_Sys_Number > self.MaxCaractere) then
            self:SetText(self.Admin_Sys_ODTextVal or Admin_System_Global.lang["complaint"])
            self:SetValue(self.Admin_Sys_ODTextVal or Admin_System_Global.lang["complaint"])
        else
            self.Admin_Sys_ODTextVal = Admin_Sys_StringText
        end
    end

    Admin_Sys_BT_1:SetPos(Admin_System_Global:Size_Auto(90, "w"), Admin_System_Global:Size_Auto(157, "h"))
    Admin_Sys_BT_1:SetSize(Admin_System_Global:Size_Auto(100, "w"), Admin_System_Global:Size_Auto(25, "h"))
    Admin_Sys_BT_1:SetText("")
    Admin_Sys_BT_1.Paint = function(self, w, h)
        draw.RoundedBox( 6, 0, 0, w, h, Admin_System_Global.CreatetickColorCompValid )
        draw.DrawText(Admin_System_Global.lang["validate"], "Admin_Sys_Font_T4", w / 2, Admin_System_Global:Size_Auto(2, "h"), Admin_System_Global.CreatetickColorCompText, TEXT_ALIGN_CENTER)
    end
    Admin_Sys_BT_1.DoClick = function()
        if (ipr_Char >= Admin_System_Global.CharMax) then
            return
        end

        net.Start("Admin_Sys:Gen_Tick")
        net.WriteString(Admin_Sys_StringTitle)
        net.WriteString(Admin_Sys_StringText)
        net.SendToServer()
        
        ipr_TGen.GSend = ipr_TGen.GSend + 1
        timer.Simple(0.1, function()
            Admin_Sys_Check_Frame(Admin_Sys_Frame, true)
        end)
    end

    Admin_Sys_Dimage:SetPos(Admin_System_Global:Size_Auto(258, "w"), Admin_System_Global:Size_Auto(9, "h"))
    Admin_Sys_Dimage:SetSize(Admin_System_Global:Size_Auto(13, "w"), Admin_System_Global:Size_Auto(13, "h"))
    Admin_Sys_Dimage:SetImage("icon16/cross.png")
    function Admin_Sys_Dimage:Paint(w, h)
    end
    Admin_Sys_Dimage.DoClick = function()
        timer.Simple(0.1, function()
            Admin_Sys_Check_Frame(Admin_Sys_Frame, true)
        end)
    end

    Admin_Sys_Dimage_Back:SetPos(Admin_System_Global:Size_Auto(10, "w"), Admin_System_Global:Size_Auto(7, "h"))
    Admin_Sys_Dimage_Back:SetSize(Admin_System_Global:Size_Auto(16, "w"), Admin_System_Global:Size_Auto(16, "h"))
    Admin_Sys_Dimage_Back:SetImage("icon16/arrow_left.png")
    function Admin_Sys_Dimage_Back:Paint(w, h)
    end
    Admin_Sys_Dimage_Back.DoClick = function()
        LocalPlayer():ConCommand( Admin_System_Global.Ticket_Cmd)
        Admin_Sys_Frame:Remove()
    end
end

ipr_TGen.GuiP = false
ipr_TGen.GSend = 0
local function ipr_CreaTick()
    if IsValid(ipr_TGen.GuiP) then
        return
    end
    ipr_TGen.GuiP = vgui.Create("DFrame")
    local Admin_Sys_FrameInfo_Scroll = vgui.Create("DScrollPanel", ipr_TGen.GuiP)
    local Admin_Sys_FrameInfo_Dimage = vgui.Create("DImageButton", ipr_TGen.GuiP)
    local Admin_Sys_Bot = vgui.Create("DImageButton", ipr_TGen.GuiP)
    local Admin_Sys_Up = vgui.Create("DImageButton", ipr_TGen.GuiP)

    ipr_TGen.GuiP:SetTitle("")
    ipr_TGen.GuiP:ShowCloseButton(false)
    ipr_TGen.GuiP:SetSize(Admin_System_Global:Size_Auto(300, "w"), Admin_System_Global:Size_Auto(420, "h"))
    ipr_TGen.GuiP:MakePopup()
    ipr_TGen.GuiP:Center()
    ipr_TGen.GuiP.Paint = function(self, w, h)
        Admin_System_Global:Gui_Blur(self, 1, Color(0, 0, 0, 140), 6)
        surface.SetDrawColor(Admin_System_Global.CreatetickColorCtr.r, Admin_System_Global.CreatetickColorCtr.g, Admin_System_Global.CreatetickColorCtr.b)
        surface.DrawOutlinedRect(0, 0, w, h, 5)

        draw.RoundedBox(1, Admin_System_Global:Size_Auto(4, "w"),  Admin_System_Global:Size_Auto(4, "h"), w - Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(33, "h"), Admin_System_Global.CreatetickColorInfos)
        draw.RoundedBox(1, Admin_System_Global:Size_Auto(4, "w"), Admin_System_Global:Size_Auto(4, "h"), w - Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(25, "h"), Admin_System_Global.CreatetickColor) -- Top border
        draw.RoundedBox(1, Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(37, "h"), w - Admin_System_Global:Size_Auto(10, "w"), h - Admin_System_Global:Size_Auto(41, "h"), Admin_System_Global.CreatetickColorBackground ) -- Background middle but
        draw.RoundedBox(11, w - Admin_System_Global:Size_Auto(27, "w"), Admin_System_Global:Size_Auto(6, "h"), Admin_System_Global:Size_Auto(20, "w"), Admin_System_Global:Size_Auto(20, "h"), Color(0,0,0,100) )
       
        draw.DrawText(Admin_System_Global.lang["creation"],"Admin_Sys_Font_T4",w / 2, Admin_System_Global:Size_Auto(5, "h"), Admin_System_Global.CreatetickColorTitle, TEXT_ALIGN_CENTER)
        draw.RoundedBox( 6, Admin_System_Global:Size_Auto(70, "w"), Admin_System_Global:Size_Auto(45, "h"), w -Admin_System_Global:Size_Auto(140, "w"), Admin_System_Global:Size_Auto(25, "h"), Admin_System_Global.CreatetickColorInfos)
        draw.DrawText("Ticket(s) envoyé(s) : " ..ipr_TGen.GSend,"Admin_Sys_Font_T6",w / 2, Admin_System_Global:Size_Auto(50, "h"), Color(255,255,255), TEXT_ALIGN_CENTER)

        draw.RoundedBox( 6, Admin_System_Global:Size_Auto(70, "w"), h- Admin_System_Global:Size_Auto(40, "h"), w -Admin_System_Global:Size_Auto(140, "w"), Admin_System_Global:Size_Auto(25, "h"), Admin_System_Global.CreatetickColorInfos)
        draw.DrawText("Joueur(s) en ligne : " ..#player.GetAll(),"Admin_Sys_Font_T6",w / 2, h - Admin_System_Global:Size_Auto(35, "h"), Color(255,255,255), TEXT_ALIGN_CENTER)
    end

    Admin_Sys_FrameInfo_Scroll:SetSize(Admin_System_Global:Size_Auto(300, "w"), Admin_System_Global:Size_Auto(257, "h"))
    Admin_Sys_FrameInfo_Scroll:SetPos(-Admin_System_Global:Size_Auto(15, "w"), Admin_System_Global:Size_Auto(95, "h"))
    local Admin_Sys_FrameInfo_Vbar = Admin_Sys_FrameInfo_Scroll:GetVBar()
    Admin_Sys_FrameInfo_Vbar:SetSize(0, 0)
    function Admin_Sys_FrameInfo_Vbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Admin_System_Global.CreatetickScrollBar_Up)
    end
    function Admin_Sys_FrameInfo_Vbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Admin_System_Global.CreatetickScrollBar_Down)
    end
    function Admin_Sys_FrameInfo_Vbar.btnGrip:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, Admin_System_Global.CreatetickScrollBar)
    end

    Admin_Sys_FrameInfo_Dimage:SetPos(Admin_System_Global:Size_Auto(275, "w"), Admin_System_Global:Size_Auto(8, "h"))
    Admin_Sys_FrameInfo_Dimage:SetSize(Admin_System_Global:Size_Auto(16, "w"), Admin_System_Global:Size_Auto(15, "h"))
    Admin_Sys_FrameInfo_Dimage:SetImage("icon16/cross.png")
    function Admin_Sys_FrameInfo_Dimage:Paint(w, h)
    end
    Admin_Sys_FrameInfo_Dimage.DoClick = function()
        Admin_Sys_Check_Frame(ipr_TGen.GuiP, true)
    end

    Admin_Sys_Up:SetPos(Admin_System_Global:Size_Auto(265, "w"), Admin_System_Global:Size_Auto(75, "h"))
    Admin_Sys_Up:SetSize(Admin_System_Global:Size_Auto(20, "w"), Admin_System_Global:Size_Auto(20, "h"))
    function Admin_Sys_Up:Paint(w, h)
       local ipr_arrow_bot = {
        { x = w / 2 - w / 2, y = h / 2 + w / 4 },
        { x = w / 2, y = h / 2 - w / 4 },
        { x = w / 2 + w / 2, y = h / 2 + w / 4 }
       }

    surface.SetDrawColor(236, 240, 241)
    draw.NoTexture()
    surface.DrawPoly(ipr_arrow_bot)
    end
    Admin_Sys_Up.DoClick = function()
       local Admin_Scroll = Admin_Sys_FrameInfo_Scroll.VBar:GetScroll()
       Admin_Sys_FrameInfo_Scroll.VBar:SetScroll(Admin_Scroll - 40)
    end

    Admin_Sys_Bot:SetPos(Admin_System_Global:Size_Auto(265, "w"), Admin_System_Global:Size_Auto(355, "h"))
    Admin_Sys_Bot:SetSize(Admin_System_Global:Size_Auto(20, "w"), Admin_System_Global:Size_Auto(20, "h"))
    function Admin_Sys_Bot:Paint(w, h)
    local ipr_arrow_up = {
        { x = w / 2 - w / 2, y = h / 2 - w / 4 },
        { x = w / 2 + w / 2, y = h / 2 - w / 4 },
        { x = w / 2, y = h / 2 + w / 4 }
    }
    surface.SetDrawColor(236, 240, 241)
    draw.NoTexture()
    surface.DrawPoly(ipr_arrow_up)
    end
    Admin_Sys_Bot.DoClick = function()
       local Admin_Scroll = Admin_Sys_FrameInfo_Scroll.VBar:GetScroll()
       Admin_Sys_FrameInfo_Scroll.VBar:SetScroll(Admin_Scroll + 40)
    end
    
    for i = 1, #Admin_System_Global.Gen_Ticket do
        local Admin_Sys_FrameInfo_BTGen, Admin_Sys_Lerp, Admin_Sys_Lerp_An = vgui.Create("DButton", Admin_Sys_FrameInfo_Scroll), 0, 0.05

        Admin_Sys_FrameInfo_BTGen:SetSize( Admin_System_Global:Size_Auto(210, "w"), Admin_System_Global:Size_Auto(30, "h") )
        Admin_Sys_FrameInfo_BTGen:SetPos( Admin_System_Global:Size_Auto(60, "w"), Admin_System_Global:Size_Auto(40, "h") * i-Admin_System_Global:Size_Auto(40, "h") )
        Admin_Sys_FrameInfo_BTGen:SetText("")
        
        local ipr_grad_start = Color(52, 73, 94)
        local ipr_grad_end = Color(44, 50, 80)
        Admin_Sys_FrameInfo_BTGen.Paint = function(self, w, h)
            local ipr_gradient_h = h / 2
            for i = 0, ipr_gradient_h do
                local ipr_t = i / h
                local ipr_r = Lerp(ipr_t, ipr_grad_start.r, ipr_grad_end.r)
                local ipr_g = Lerp(ipr_t, ipr_grad_start.g, ipr_grad_end.g)
                local ipr_b = Lerp(ipr_t, ipr_grad_start.b, ipr_grad_end.b)

                draw.RoundedBox(6, 0, i, w, ipr_gradient_h, Color(ipr_r, ipr_g, ipr_b, 255))
            end
            draw.DrawText(Admin_System_Global.Gen_Ticket[i].NameButton, "Admin_Sys_Font_T4", w/2 , 4, self:IsHovered() and Admin_System_Global.ContextActionPlayerHoverRight or Admin_System_Global.CreatetickColorText, TEXT_ALIGN_CENTER)
        end
        Admin_Sys_FrameInfo_BTGen.DoClick = function()
            local Admin_Sys_Bool = false
            for _, numbplayer in pairs(ents.FindByClass( "player" )) do
                if IsValid(numbplayer) and numbplayer:IsPlayer() and Admin_System_Global:Sys_Check(numbplayer) then
                    Admin_Sys_Bool = true
                end
            end
            if not (Admin_Sys_Bool) then
                chat.AddText(Color(255,0,0), Admin_System_Global.Ticket_NoText)
                Admin_Sys_Check_Frame(ipr_TGen.GuiP, true)
                return
            end
            if (Admin_System_Global.Gen_Ticket[i].WebLink == "") then
                if (Admin_System_Global.Gen_Ticket[i].Complementary) then
                    Admin_Sys_Frame_Comp(Admin_System_Global.Gen_Ticket[i].NameButton)
                    Admin_Sys_Check_Frame(ipr_TGen.GuiP, false)
                else
                    net.Start("Admin_Sys:Gen_Tick")
                    net.WriteString(Admin_System_Global.Gen_Ticket[i].NameButton)
                    net.WriteString("")
                    net.SendToServer()
                    ipr_TGen.GSend = ipr_TGen.GSend + 1
                    Admin_Sys_Check_Frame(ipr_TGen.GuiP, true)
                end
            else
                gui.OpenURL(Admin_System_Global.Gen_Ticket[i].WebLink)
                Admin_Sys_Check_Frame(ipr_TGen.GuiP, true)
            end
        end
    end
end
Admin_System_Global:AddGui(3, ipr_CreaTick)