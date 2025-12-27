---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

local ipr_Service = {}
ipr_Service.Count = 0

local function admin_sys_rf(Admin_Sys_Service_ScrollBar)
    local Admin_SysRefreshTbl, Admin_SysFindClass = {}, ents.FindByClass("player")
    Admin_Sys_Service_ScrollBar:GetCanvas():Clear()
    ipr_Service.Count = 0
    
    for k, v in ipairs(Admin_SysFindClass) do
        if not Admin_System_Global:Sys_Check(v) then
            continue
        end
        local Admin_Sys_Service_Dlabel = vgui.Create("DLabel", Admin_Sys_Service_ScrollBar)
        Admin_Sys_Service_Dlabel:SetSize(Admin_System_Global:Size_Auto(260, "w"), Admin_System_Global:Size_Auto(37, "h"))
        Admin_Sys_Service_Dlabel:SetPos(Admin_System_Global:Size_Auto(70, "w"), Admin_System_Global:Size_Auto(50, "h") * k - Admin_System_Global:Size_Auto(48, "h"))
        Admin_Sys_Service_Dlabel:SetText("")
        Admin_Sys_Service_Dlabel.Think = function()
            if not IsValid(v) then
                Admin_Sys_Service_Dlabel:Remove()
                admin_sys_rf(Admin_Sys_Service_ScrollBar)
            end
            if (Admin_Sys_Service_ScrollBar:GetCanvas():GetTall() <= 239) then
                Admin_Sys_Service_Dlabel:SetSize(Admin_System_Global:Size_Auto(265, "w"), Admin_System_Global:Size_Auto(37, "h"))
            else
                Admin_Sys_Service_Dlabel:SetSize(Admin_System_Global:Size_Auto(260, "w"), Admin_System_Global:Size_Auto(37, "h"))
            end
        end
        if (v ~= LocalPlayer()) then
            local Admin_SysPos_Frame_BT_r = vgui.Create( "DButton", Admin_Sys_Service_ScrollBar)
            Admin_SysPos_Frame_BT_r:SetPos(Admin_System_Global:Size_Auto(305, "w"),  9 + Admin_System_Global:Size_Auto(50, "h") * k -Admin_System_Global:Size_Auto(48, "h"))
            Admin_SysPos_Frame_BT_r:SetSize(21, 21)
            Admin_SysPos_Frame_BT_r:SetText("")
            Admin_SysPos_Frame_BT_r:SetIcon("icon16/shield.png")
            Admin_SysPos_Frame_BT_r.Paint = function(self, w, h)
                if self:IsHovered() then
                    draw.RoundedBox( 2, Admin_System_Global:Size_Auto(22, "w"), 0, w, h,  Color(192, 57, 43, 255))
                end
            end
            Admin_SysPos_Frame_BT_r.DoClick = function()
                local Admin_SysPos_Derma = DermaMenu()

                local Admin_SysPos_Optionb = Admin_SysPos_Derma:AddOption("Téléporter vers " ..v:Nick(), function()
                    net.Start("Admin_Sys:TP_Reset")
                    net.WriteUInt( 3, 4 )
                    net.WriteEntity(v)
                    net.SendToServer()
                end)
                Admin_SysPos_Optionb:SetIcon("icon16/shield.png")
                Admin_SysPos_Derma:Open()
            end
        end
        local Admin_Avatar = vgui.Create("AvatarImage", Admin_Sys_Service_Dlabel)
        Admin_Avatar:SetSize(30, 30)
        Admin_Avatar:SetPos(3,3)
        Admin_Avatar:SetPlayer(v, 64)
        Admin_Sys_Service_Dlabel.Paint = function(self,w,h)
            draw.RoundedBox( 8, 0, 0, w, h, Color(52,73,94) )

            surface.SetDrawColor(Color(255, 255, 255, 50))
            surface.DrawOutlinedRect(0, 0, w, h)

            surface.SetDrawColor(Color(255, 255, 255, 10))
            surface.DrawOutlinedRect(2, 2, w - 4, h - 4)

            surface.SetDrawColor(v:AdminStatusCheck() and Color(0,175,0, 250) or Color(255,0,0, 250))
            surface.DrawRect(w - 1.5, 1, 2, h - 1.5)

            draw.DrawText(v:Nick().. " - " ..team.GetName(v:Team()) or "Hors Ligne", "Admin_Sys_Font_T1", w/2, 3, Color(255,255,255, 250), TEXT_ALIGN_CENTER)
            draw.DrawText(v:AdminStatusCheck() and "En Service" or "Hors Service", "Admin_Sys_Font_T1", w/2, 17, v:AdminStatusCheck() and Color(0,175,0, 250) or Color(255,0,0, 250), TEXT_ALIGN_CENTER)
        end

        ipr_Service.Count = k
        Admin_SysRefreshTbl[#Admin_SysRefreshTbl + 1] = {panel = Admin_Sys_Service_Dlabel}
    end
end

ipr_Service.GuiP = false
ipr_Service.GuiS = false
ipr_Service.GuiT = false
local function admin_sys_ol()
     if IsValid(ipr_Service.GuiP) then 
        return 
     end
     ipr_Service.GuiP = vgui.Create("DFrame")
     local Admin_Sys_Service_ScrollBar = vgui.Create( "DScrollPanel", ipr_Service.GuiP)
     local Admin_Sys_Service_Frm = vgui.Create("DImageButton", ipr_Service.GuiP)
     admin_sys_rf(Admin_Sys_Service_ScrollBar)

     ipr_Service.GuiP:SetTitle("")
     ipr_Service.GuiP:SetSize(Admin_System_Global:Size_Auto(300, "w"), Admin_System_Global:Size_Auto(350, "h"))
     ipr_Service.GuiP:SetDraggable(true)
     ipr_Service.GuiP:ShowCloseButton(false)
     ipr_Service.GuiP:Center()
     ipr_Service.GuiP:MakePopup()
     timer.Create("AdminSys_RefreshOnlineAdmin", 7, 0, function()
         admin_sys_rf(Admin_Sys_Service_ScrollBar)
     end)
     local ipr_mat_ic = Material( "materials/icon16/cog.png" )
     ipr_Service.GuiP.Paint = function(self, w, h)
         Admin_System_Global:Gui_Blur(self, Admin_System_Global:Size_Auto(1, "w"), Color( 0, 0, 0, 150 ), 8)
        
         draw.RoundedBox( 6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94) )
         draw.DrawText("Administrateur en service (" ..ipr_Service.Count.. ")","Admin_Sys_Font_T1",w / 2, Admin_System_Global:Size_Auto(4, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
         if (ipr_Service.Count <= 0) then
             draw.DrawText("Aucun Administrateur en ligne" ,"Admin_Sys_Font_T1",w / 2,Admin_System_Global:Size_Auto(150, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
         else
            local ipr_timer = math.Round(timer.TimeLeft( "AdminSys_RefreshOnlineAdmin" ))
            local ipr_sec = (ipr_timer <= 1) and true or false
            ipr_sec = ipr_sec and " sec" or " secs"
            
            surface.SetMaterial(ipr_mat_ic)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRectRotated(w / 2 - 69, 40, 15, 15, CurTime() * 180)

            draw.DrawText("Refresh dans : " ..ipr_timer.. "" ..ipr_sec,"Admin_Sys_Font_T3",w / 2, Admin_System_Global:Size_Auto(33, "h"),Color(255, 255, 250), TEXT_ALIGN_CENTER)
         end
     end
 
     Admin_Sys_Service_ScrollBar:SetSize(Admin_System_Global:Size_Auto(345, "w"), Admin_System_Global:Size_Auto(270, "h"))
     Admin_Sys_Service_ScrollBar:SetPos(-Admin_System_Global:Size_Auto(50, "w"), Admin_System_Global:Size_Auto(65, "h"))
     local Admin_Sys_Service_Vbar = Admin_Sys_Service_ScrollBar:GetVBar()
     Admin_Sys_Service_Vbar:SetSize(Admin_System_Global:Size_Auto(7, "w"), Admin_System_Global:Size_Auto(7, "h"))
     Admin_Sys_Service_Vbar.Paint = function( self, w, h )
         draw.RoundedBox(6, 0, 0, w, h, Color(255,255,255,15))
     end
     Admin_Sys_Service_Vbar.btnUp.Paint = function( self, w, h )
         draw.RoundedBox(6, 0, 0, w, h, Admin_System_Global.TicketScrollBar)
     end
     Admin_Sys_Service_Vbar.btnDown.Paint = function( self, w, h )
         draw.RoundedBox(6, 0, 0, w, h, Admin_System_Global.TicketScrollBar)
     end
     Admin_Sys_Service_Vbar.btnGrip.Paint = function( self, w, h )
         draw.RoundedBox(2, 0, 0, w, h, Admin_System_Global.TicketScrollBar)
     end
 
     Admin_Sys_Service_Frm:SetPos(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(5, "h"))
     Admin_Sys_Service_Frm:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(17, "h"))
     Admin_Sys_Service_Frm:SetImage("icon16/cross.png")
     function Admin_Sys_Service_Frm:Paint(w, h) end
     Admin_Sys_Service_Frm.DoClick = function()
         ipr_Service.GuiP:Remove()
         if timer.Exists("AdminSys_RefreshOnlineAdmin") then
             timer.Remove("AdminSys_RefreshOnlineAdmin")
         end
     end
 
     local Admin_SysPos_Frame_BT_Sv1, Admin_SysPos_FrameB = vgui.Create("DImageButton", ipr_Service.GuiP)
     Admin_SysPos_Frame_BT_Sv1:SetPos(Admin_System_Global:Size_Auto(7, "w"),Admin_System_Global:Size_Auto(5, "h"))
     Admin_SysPos_Frame_BT_Sv1:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
     Admin_SysPos_Frame_BT_Sv1:SetImage("icon16/layers.png")
     function Admin_SysPos_Frame_BT_Sv1:Paint(w,h) end
     Admin_SysPos_Frame_BT_Sv1.DoClick = function()
         ipr_Service.GuiP:SetAlpha(50)
         Admin_SysPos_Frame_BT_Sv1:SetImage("icon16/monitor.png")
         ipr_Service.GuiP:SetMouseInputEnabled(false)
         ipr_Service.GuiP:SetKeyboardInputEnabled(false)
         gui.EnableScreenClicker(false)

         timer.Simple(1, function()
             if not IsValid(ipr_Service.GuiP) then 
                return 
             end
             local x, y = ipr_Service.GuiP:GetPos()

             Admin_SysPos_FrameB = vgui.Create("DFrame")
             Admin_SysPos_FrameB:SetTitle("")
             Admin_SysPos_FrameB:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(315, "h"))
             Admin_SysPos_FrameB:SetMouseInputEnabled(true)
             Admin_SysPos_FrameB:ShowCloseButton(false)
             Admin_SysPos_FrameB:SetPos(x, y)
             Admin_SysPos_FrameB.Think = function()
                 if Admin_SysPos_FrameB:IsHovered() then
                     if IsValid(ipr_Service.GuiP) then
                         ipr_Service.GuiP:SetAlpha(255)
                         ipr_Service.GuiP:SetMouseInputEnabled(true)
                         ipr_Service.GuiP:SetKeyboardInputEnabled(true)
                         gui.EnableScreenClicker(true)
                         Admin_SysPos_Frame_BT_Sv1:SetImage("icon16/layers.png")
                     end
                     Admin_SysPos_FrameB:Remove()
                 end
             end
             Admin_SysPos_FrameB.Paint = function(self, w, h) end
         end)
     end
end
Admin_System_Global:AddGui(2, admin_sys_ol)

local function admin_sys_chx()
     if IsValid(ipr_Service.GuiS) then
         return
     end
     local Admin_Sys_Ply = LocalPlayer()
     ipr_Service.GuiS = vgui.Create("DFrame")
     ipr_Service.GuiT = vgui.Create("DFrame")

     local Admin_Mod_Frame_Frm = vgui.Create("DImageButton", ipr_Service.GuiS)
     local Admin_Mod_Frame_BT_C = vgui.Create("DButton", ipr_Service.GuiS)
     local Admin_Mod_Frame_BT = vgui.Create("DButton", ipr_Service.GuiS)
     local Admin_Mod_Frame_BT_1 = vgui.Create("DButton", ipr_Service.GuiS)
     local Admin_Mod_Frame_BT_2 = vgui.Create("DButton", ipr_Service.GuiS)
     local Admin_Mod_Frame_BT_3 = vgui.Create("DButton", ipr_Service.GuiS)
     local Admin_SysPos_Frame_BT_Sv1 = vgui.Create("DImageButton", ipr_Service.GuiS)

     local Admin_Sys_Col, Admin_Sys_Gradient_ = Color(52,73,94), surface.GetTextureID( "gui/gradient" )
     ipr_Service.GuiS:SetTitle("")
     ipr_Service.GuiS:ShowCloseButton(false)
     ipr_Service.GuiS:SetDraggable(true)
     ipr_Service.GuiS:SetSize(Admin_System_Global:Size_Auto(350, "w"), Admin_System_Global:Size_Auto(130, "h"))
     ipr_Service.GuiS:SetPos(ScrW() / 2 - Admin_System_Global:Size_Auto(225, "w"), ScrH() / 2 - Admin_System_Global:Size_Auto(60, "h"))
     ipr_Service.GuiS:MakePopup()
     ipr_Service.GuiS.Paint = function(self, w, h)
         Admin_System_Global:Gui_Blur(self, 1, Color(0, 0, 0, 150), 5)

         draw.RoundedBoxEx(5, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94), true, true, false, false)
         draw.DrawText("Admin Configuration" ,"Admin_Sys_Font_T1",w/2 +5, Admin_System_Global:Size_Auto(5, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
     end
 
     ipr_Service.GuiT:SetTitle("")
     ipr_Service.GuiT:SetPos(0, 0)
     ipr_Service.GuiT:SetSize(Admin_System_Global:Size_Auto(330, "w"), Admin_System_Global:Size_Auto(25, "h"))
     ipr_Service.GuiT:ShowCloseButton(false)
     ipr_Service.GuiT:SetDraggable( false )
     ipr_Service.GuiT:MakePopup()
     ipr_Service.GuiT.Think = function()
         local t, u = ipr_Service.GuiS:GetPos()

         ipr_Service.GuiT:SetPos(t + 10, u + Admin_System_Global:Size_Auto(131, "h"))
     end
     ipr_Service.GuiT.Paint = function(self, w, h)
         Admin_System_Global:Gui_Blur(self, 1, Color(0, 0, 0, 150), 5)
         draw.RoundedBoxEx(5, 0, 0, w, 1, Color(255, 255, 255, 150), true, true, true, true)

         draw.DrawText("Status :" ,"Admin_Sys_Font_T1", 27, Admin_System_Global:Size_Auto(5, "h"), color_white, TEXT_ALIGN_CENTER)
         draw.DrawText(Admin_System_Global.SysCloakStatus and "Cloak : ON ✔" or "Cloak : OFF ✘" ,"Admin_Sys_Font_T1",55, Admin_System_Global:Size_Auto(5, "h"), Admin_Sys_Ply:GetNoDraw() and Color(236, 240, 241) or Color(231, 76, 60),TEXT_ALIGN_LEFT)
         draw.DrawText("- " ..((Admin_System_Global.SysGodModeStatus and "Godmod : ON ✔") or "Godmod : OFF ✘").. " -" ,"Admin_Sys_Font_T1",135, Admin_System_Global:Size_Auto(5, "h"), Admin_System_Global.SysGodModeStatus and Color(236, 240, 241) or Color(231, 76, 60),TEXT_ALIGN_LEFT)
         draw.DrawText((Admin_Sys_Ply:GetMoveType() == MOVETYPE_NOCLIP) and "Noclip : ON ✔" or "Noclip : OFF ✘" ,"Admin_Sys_Font_T1",245, Admin_System_Global:Size_Auto(5, "h"), (Admin_Sys_Ply:GetMoveType() == MOVETYPE_NOCLIP) and Color(236, 240, 241) or Color(231, 76, 60),TEXT_ALIGN_LEFT)
     end
 
     local Admin_SysPos_FrameB
     Admin_SysPos_Frame_BT_Sv1:SetPos(7,4)
     Admin_SysPos_Frame_BT_Sv1:SetSize(17,17)
     Admin_SysPos_Frame_BT_Sv1:SetImage("icon16/layers.png")
     function Admin_SysPos_Frame_BT_Sv1:Paint(w,h) end
     Admin_SysPos_Frame_BT_Sv1.DoClick = function()
         ipr_Service.GuiS:SetAlpha(50)
         ipr_Service.GuiT:SetAlpha(50)
         Admin_SysPos_Frame_BT_Sv1:SetImage("icon16/monitor.png")
         ipr_Service.GuiS:SetMouseInputEnabled(false)
         ipr_Service.GuiS:SetKeyboardInputEnabled(false)
         ipr_Service.GuiT:SetMouseInputEnabled(false)
         ipr_Service.GuiT:SetKeyboardInputEnabled(false)
         gui.EnableScreenClicker(false)

         timer.Simple(1, function()
             if not IsValid(ipr_Service.GuiS) or not IsValid(ipr_Service.GuiT) then
                 return
             end
             local x, y = ipr_Service.GuiS:GetPos()

             Admin_SysPos_FrameB = vgui.Create("DFrame")
             Admin_SysPos_FrameB:SetTitle("")
             Admin_SysPos_FrameB:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(315, "h"))
             Admin_SysPos_FrameB:SetMouseInputEnabled(true)
             Admin_SysPos_FrameB:ShowCloseButton(false)
             Admin_SysPos_FrameB:SetPos(x, y)

             Admin_SysPos_FrameB.Think = function()
                 if (Admin_SysPos_FrameB:IsHovered()) then
                     if IsValid(ipr_Service.GuiS) then
                         ipr_Service.GuiS:SetAlpha(255)
                         ipr_Service.GuiS:SetMouseInputEnabled(true)
                         ipr_Service.GuiS:SetKeyboardInputEnabled(true)
                         ipr_Service.GuiT:SetAlpha(255)
                         ipr_Service.GuiT:SetMouseInputEnabled(true)
                         ipr_Service.GuiT:SetKeyboardInputEnabled(true)
                         gui.EnableScreenClicker(true)
                         Admin_SysPos_Frame_BT_Sv1:SetImage("icon16/layers.png")
                     end

                     Admin_SysPos_FrameB:Remove()
                 end
             end
             Admin_SysPos_FrameB.Paint = function(self, w, h) end
         end)
     end

     Admin_Mod_Frame_BT_C:SetPos(Admin_System_Global:Size_Auto(75, "w"), Admin_System_Global:Size_Auto(32, "h"))
     Admin_Mod_Frame_BT_C:SetSize(Admin_System_Global:Size_Auto(215, "w"), Admin_System_Global:Size_Auto(25, "h"))
     Admin_Mod_Frame_BT_C:SetText("")
     Admin_Mod_Frame_BT_C:SetIcon("icon16/status_online.png")
     Admin_Mod_Frame_BT_C.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Admin_System_Global.ContextButton)
        draw.DrawText(Admin_Sys_Ply:AdminStatusCheck() and "Désactiver Mode Admin" or "Activer Mode Admin", "Admin_Sys_Font_T1", w/2, 4, self:IsHovered() and Admin_System_Global.ContextActionPlayerHoverRight or color_white, TEXT_ALIGN_CENTER)
     end
     Admin_Mod_Frame_BT_C.DoClick = function()
         Admin_Sys_Ply:ConCommand(Admin_System_Global.Mode_Cmd)
     end

     Admin_Mod_Frame_BT:SetPos(Admin_System_Global:Size_Auto(10, "w"), Admin_System_Global:Size_Auto(100, "h"))
     Admin_Mod_Frame_BT:SetSize(Admin_System_Global:Size_Auto(100, "w"), Admin_System_Global:Size_Auto(25, "h"))
     Admin_Mod_Frame_BT:SetText("")
     Admin_Mod_Frame_BT:SetIcon("icon16/shape_group.png")
     Admin_Mod_Frame_BT.Paint = function( self, w, h )
        draw.RoundedBox(8, 0, 0, w, h, Admin_System_Global.ContextButton)
        draw.DrawText("Cloak", "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(4, "h"), self:IsHovered() and Admin_System_Global.ContextActionPlayerHoverRight or color_white, TEXT_ALIGN_CENTER )
     end
     Admin_Mod_Frame_BT.DoClick = function()
        Admin_Sys_Ply:ConCommand(Admin_System_Global.Mode_AddCmd_Cloak)
     end
 
     Admin_Mod_Frame_BT_1:SetPos(Admin_System_Global:Size_Auto(125, "w"), Admin_System_Global:Size_Auto(100, "h"))
     Admin_Mod_Frame_BT_1:SetSize(Admin_System_Global:Size_Auto(100, "w"), Admin_System_Global:Size_Auto(25, "h"))
     Admin_Mod_Frame_BT_1:SetText("")
     Admin_Mod_Frame_BT_1:SetIcon("icon16/shield.png")
     Admin_Mod_Frame_BT_1.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Admin_System_Global.ContextButton)
        draw.DrawText("Godmode", "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(4, "h"), self:IsHovered() and Admin_System_Global.ContextActionPlayerHoverRight or color_white, TEXT_ALIGN_CENTER)
     end
     Admin_Mod_Frame_BT_1.DoClick = function()
        Admin_Sys_Ply:ConCommand(Admin_System_Global.Mode_AddCmd_GodMod)
     end
 
     Admin_Mod_Frame_BT_2:SetPos(Admin_System_Global:Size_Auto(240, "w"), Admin_System_Global:Size_Auto(100, "h"))
     Admin_Mod_Frame_BT_2:SetSize(Admin_System_Global:Size_Auto(100, "w"), Admin_System_Global:Size_Auto(25, "h"))
     Admin_Mod_Frame_BT_2:SetText("")
     Admin_Mod_Frame_BT_2:SetIcon("icon16/brick.png")
     Admin_Mod_Frame_BT_2.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Admin_System_Global.ContextButton)
        draw.DrawText("Noclip", "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(4, "h"), self:IsHovered() and Admin_System_Global.ContextActionPlayerHoverRight or color_white, TEXT_ALIGN_CENTER)
     end
     Admin_Mod_Frame_BT_2.DoClick = function()
        Admin_Sys_Ply:ConCommand(Admin_System_Global.Mode_AddCmd_NoClip)
     end

     Admin_Mod_Frame_BT_3:SetPos(Admin_System_Global:Size_Auto(75, "w"), Admin_System_Global:Size_Auto(62, "h"))
     Admin_Mod_Frame_BT_3:SetSize(Admin_System_Global:Size_Auto(215, "w"), Admin_System_Global:Size_Auto(25, "h"))
     Admin_Mod_Frame_BT_3:SetText("")
     Admin_Mod_Frame_BT_3:SetIcon("icon16/star.png")
     Admin_Mod_Frame_BT_3.Paint = function(self, w, h)
        draw.RoundedBox(8, 0, 0, w, h, Admin_System_Global.ContextButton)
        draw.DrawText(not Admin_System_Global.SysStreamerMod and "Activer Streamer Mod" or "Désactiver Streamer Mod", "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(4, "h"), self:IsHovered() and Admin_System_Global.ContextActionPlayerHoverRight or color_white, TEXT_ALIGN_CENTER)
     end
     Admin_Mod_Frame_BT_3.DoClick = function()
        Admin_Sys_Ply:ConCommand(Admin_System_Global.StreamMod_Cmd)
     end
 
     Admin_Mod_Frame_Frm:SetPos(Admin_System_Global:Size_Auto(330, "w"), Admin_System_Global:Size_Auto(5, "h"))
     Admin_Mod_Frame_Frm:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(17, "h"))
     Admin_Mod_Frame_Frm:SetImage("icon16/cross.png")
     function Admin_Mod_Frame_Frm:Paint(w, h)
     end
     Admin_Mod_Frame_Frm.DoClick = function()
         if IsValid(ipr_Service.GuiS) then
             ipr_Service.GuiS:Remove()
         end
         if IsValid(ipr_Service.GuiT) then
             ipr_Service.GuiT:Remove()
         end
     end
end
Admin_System_Global:AddGui(0, admin_sys_chx)