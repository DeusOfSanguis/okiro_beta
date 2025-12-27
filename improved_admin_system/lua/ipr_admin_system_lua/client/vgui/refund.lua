---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

local ipr_PRemb = {}
ipr_PRemb.Frame = false

local function Admin_Sys_Frame_Remove()
    if not IsValid(ipr_PRemb.Frame) then
        return
    end
    ipr_PRemb.Frame:Remove()
end

ipr_PRemb.Bt = false
ipr_PRemb.Ply_Cached = false
ipr_PRemb.Gui = false
local function Admin_Sys_Func_Ext(Admin_Sys_Frame, Admin_Sys_Ply, Admin_Sys_Table, Admin_Sys_Name)
     if IsValid(ipr_PRemb.Gui) then
         ipr_PRemb.Gui:Remove()
     end
     ipr_PRemb.Gui = vgui.Create("DFrame")
     
     local Admin_Sys_Frame_Ext_DModel = vgui.Create("DModelPanel", ipr_PRemb.Gui)
     local Admin_Sys_Frame_Ext_BT = vgui.Create("DButton", ipr_PRemb.Gui)
     local Admin_Sys_Frame_Ext_DImage = vgui.Create("DImageButton", ipr_PRemb.Gui)
     local Admin_Sys_Job, Admin_Sys_Model, Admin_Sys_Curtime = "", "", 0
     local Admin_Sys_Money, Admin_Sys_Money_Bool, Admin_Sys_Weap_Bool = 0, false, false

     for k, v in pairs(Admin_Sys_Table) do
         if (k == "curtime") then
             Admin_Sys_Curtime = Admin_System_Global:TradTime(string.NiceTime(CurTime() - v ))
         end
         if (k == "model") then
             Admin_Sys_Model = v
         end
         if (k == "job") then
             Admin_Sys_Job = v
         end
         if (k == "money") then
            if (v == nil) then
                Admin_Sys_Money = 0
            else
             if isnumber(v) then
                if (v <= 0) then
                    Admin_Sys_Money_Bool = true
                else
                    Admin_Sys_Money = v
                end
             end
            end
         end
         if (k == "weapon") then
             for k, v in pairs(v) do
                 if k >= 1 then
                     Admin_Sys_Weap_Bool = true
                     break
                 end
             end
         end
     end
     ipr_PRemb.Ply_Cached = Admin_Sys_Ply
     if (Admin_Sys_Job == "") then
         Admin_Sys_Job = team.GetName(ipr_PRemb.Ply_Cached:Team()) or Admin_Sys_Job
     end
     if (Admin_Sys_Model == "") then
         Admin_Sys_Model = ipr_PRemb.Ply_Cached:GetModel() or Admin_Sys_Model
     end
 
     ipr_PRemb.Gui:SetTitle("")
     ipr_PRemb.Gui:SetSize(Admin_System_Global:Size_Auto(250, "w"), Admin_System_Global:Size_Auto(465, "h"))
     ipr_PRemb.Gui:ShowCloseButton(false)
     ipr_PRemb.Gui:SetDraggable(true)
     ipr_PRemb.Gui:SetPos(0, 0)
     ipr_PRemb.Gui.Think = function()
         if IsValid(Admin_Sys_Frame) then
             local x, y = Admin_Sys_Frame:GetPos()
             ipr_PRemb.Gui:SetPos(x + Admin_System_Global:Size_Auto(260, "w"), y - Admin_System_Global:Size_Auto(50, "h"))
         end
     end
     ipr_PRemb.Gui.Paint = function( self, w, h )
         draw.RoundedBox(6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94))
         Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 50 ), 8)
         draw.DrawText(Admin_System_Global.lang["remb_title_manage"], "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(2, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
         draw.DrawText(Admin_System_Global.lang["remb_death"].. "" ..Admin_Sys_Curtime, "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(150, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
         draw.DrawText(team.GetName(Admin_Sys_Job) , "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(165, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
         draw.DrawText(Admin_System_Global.lang["remb_moneylost"].. "" ..Admin_Sys_Money.. "" ..Admin_System_Global.lang["remb_moneysymb"], "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(180, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
         draw.DrawText(Admin_Sys_Name, "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(195, "h"), Color( 255, 255, 0, 240 ), TEXT_ALIGN_CENTER)
     end
 
     Admin_Sys_Frame_Ext_DImage:SetPos(Admin_System_Global:Size_Auto(230, "w"),Admin_System_Global:Size_Auto(4, "h"))
     Admin_Sys_Frame_Ext_DImage:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
     Admin_Sys_Frame_Ext_DImage:SetImage("icon16/cross.png")
     function Admin_Sys_Frame_Ext_DImage:Paint(w,h) end
     Admin_Sys_Frame_Ext_DImage.DoClick = function()
         ipr_PRemb.Gui:Remove()
 
         if IsValid(ipr_PRemb.Bt) then
             ipr_PRemb.Bt.DrawBox = false
         end
         if IsValid(Admin_Sys_Frame) then
             Admin_Sys_Frame:Center()
         end
     end
 
     Admin_Sys_Frame_Ext_DModel:SetSize(Admin_System_Global:Size_Auto(130, "w"), Admin_System_Global:Size_Auto(137, "h"))
     Admin_Sys_Frame_Ext_DModel:SetPos(Admin_System_Global:Size_Auto(60, "w"), Admin_System_Global:Size_Auto(10, "h"))
     Admin_Sys_Frame_Ext_DModel:SetModel(Admin_Sys_Model)
     Admin_Sys_Frame_Ext_DModel:SetAmbientLight(Color( 255, 0, 0, 255 ))
     if (Admin_Sys_Model ~= "models/error.mdl") and (Admin_Sys_Frame_Ext_DModel.Entity:LookupBone("ValveBiped.Bip01_Head1") ~= nil) then
         function Admin_Sys_Frame_Ext_DModel:LayoutEntity(ent)
             ent:SetSequence(ent:LookupSequence("idle_all_scared"))
             Admin_Sys_Frame_Ext_DModel:RunAnimation()
             return
         end
         local Admin_Sys_Bone = Admin_Sys_Frame_Ext_DModel.Entity:GetBonePosition(Admin_Sys_Frame_Ext_DModel.Entity:LookupBone("ValveBiped.Bip01_Head1"))
         Admin_Sys_Bone:Add(Vector(0, 0, -3 ))
         Admin_Sys_Frame_Ext_DModel:SetLookAt(Admin_Sys_Bone)
         Admin_Sys_Frame_Ext_DModel:SetCamPos(Admin_Sys_Bone-Vector(-20, 0, 0))
         Admin_Sys_Frame_Ext_DModel.Entity:SetEyeTarget(Admin_Sys_Bone-Vector(-12, 0, 0))
     end
     local Admin_Sys_BaseClass = baseclass.Get("DModelPanel")
     Admin_Sys_Frame_Ext_DModel.Paint = function(self,w,h)
         surface.SetDrawColor(Color( 0, 0, 0, 0 ))
         surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
         Admin_Sys_BaseClass.Paint(self, w, h)
     end
 
     local Admin_Sys_Lerp_, Admin_Sys_Lerp_An_ = 0, 0.05
     Admin_Sys_Frame_Ext_BT:SetPos(Admin_System_Global:Size_Auto(40, "w"), Admin_System_Global:Size_Auto(220, "h"))
     Admin_Sys_Frame_Ext_BT:SetSize(Admin_System_Global:Size_Auto(170, "w"), Admin_System_Global:Size_Auto(25, "h"))
     Admin_Sys_Frame_Ext_BT:SetText("")
     Admin_Sys_Frame_Ext_BT:SetIcon("icon16/shield.png")
     Admin_Sys_Frame_Ext_BT.Paint = function( self, w, h )
         draw.RoundedBox( 3, 0, 0, w, h, Color(52,73,94) )
         if (self:IsHovered()) then
             Admin_Sys_Lerp_ = Lerp(Admin_Sys_Lerp_An_, Admin_Sys_Lerp_, w - Admin_System_Global:Size_Auto(4, "w"))
         else
             Admin_Sys_Lerp_ = 0
         end
         draw.RoundedBox(6, Admin_System_Global:Size_Auto(2, "w"), 0, Admin_Sys_Lerp_, 1, Color(	41, 128, 185))
         draw.DrawText(Admin_System_Global.lang["remb_allrestore"], "Admin_Sys_Font_T1", w/2 +Admin_System_Global:Size_Auto(7, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(255,255,255, 250), TEXT_ALIGN_CENTER )
     end
     Admin_Sys_Frame_Ext_BT.DoClick = function()
         net.Start("Admin_Sys:Restore")
         net.WriteUInt(0, 3)
         net.WriteEntity(ipr_PRemb.Ply_Cached)
         net.SendToServer()

         Admin_Sys_Frame_Remove()
     end
 
     local ipr_ct = 0
     for k, v in pairs(Admin_Sys_Table) do
         if (k == "money") and (Admin_Sys_Money_Bool or Admin_Sys_Money == 0) or (k == "weapon" and not Admin_Sys_Weap_Bool) or (k == "curtime") or (k == nil) then
            continue
         end
         local Admin_Sys_Frame_Ext_BT_1, Admin_Sys_Name_Table = vgui.Create("DButton", ipr_PRemb.Gui), string.Replace(k, string.sub(k, 1, 1), string.upper(string.sub(k, 1, 1)))
         local Admin_Sys_Info = not istable(v) and v or ""
         if (Admin_Sys_Info == "") and (k ~= "weapon") then
             for _, t in pairs(v) do
                 Admin_Sys_Info = t
             end
         end
         if (k == "job") then
             Admin_Sys_Info = team.GetName(Admin_Sys_Info)
         end
         if (Admin_Sys_Info == "") then
             Admin_Sys_Info = Admin_System_Global.lang["remb_allweap_choice"]
         else
             Admin_Sys_Info = Admin_System_Global.lang["remb_weap_title"].. "" ..Admin_Sys_Info
         end
 
         local Admin_Sys_Lerp, Admin_Sys_Lerp_An = 0, 0.05
         Admin_Sys_Name_Table = (Admin_Sys_Name_Table == "HealtH") and Admin_System_Global.lang["remb_menu_bt1"] or (Admin_Sys_Name_Table == "Job") and Admin_System_Global.lang["remb_menu_bt2"] or (Admin_Sys_Name_Table == "Money") and Admin_System_Global.lang["remb_menu_bt3"] or (Admin_Sys_Name_Table == "Model") and Admin_System_Global.lang["remb_menu_bt4"] or (Admin_Sys_Name_Table == "Weapon") and Admin_System_Global.lang["remb_menu_bt5"]
         ipr_ct = ipr_ct + 1

         Admin_Sys_Frame_Ext_BT_1:SetPos(Admin_System_Global:Size_Auto(48, "w"), ipr_ct * (1 + Admin_System_Global:Size_Auto(37, "h")) + Admin_System_Global:Size_Auto(225, "h"))
         Admin_Sys_Frame_Ext_BT_1:SetSize(Admin_System_Global:Size_Auto(150, "w"), Admin_System_Global:Size_Auto(25, "h"))
         Admin_Sys_Frame_Ext_BT_1:SetText("")
         Admin_Sys_Frame_Ext_BT_1:SetIcon("icon16/bullet_wrench.png")
         Admin_Sys_Frame_Ext_BT_1:SetTooltip(Admin_Sys_Info)
         Admin_Sys_Frame_Ext_BT_1.Paint = function(self, w, h)
             draw.RoundedBox(3, 0, 0, w, h, Color(52,73,94))
             if (self:IsHovered()) then
                 Admin_Sys_Lerp = Lerp(Admin_Sys_Lerp_An, Admin_Sys_Lerp, w - Admin_System_Global:Size_Auto(4, "w"))
             else
                 Admin_Sys_Lerp = 0
             end

             draw.RoundedBox(6, Admin_System_Global:Size_Auto(2, "w"), 0, Admin_Sys_Lerp, 1, Color(	41, 128, 185))
             draw.DrawText(Admin_System_Global.lang["remb_allweaprest_title"].. "" ..Admin_Sys_Name_Table, "Admin_Sys_Font_T1", w/2 +Admin_System_Global:Size_Auto(7, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(255,255,255, 250), TEXT_ALIGN_CENTER)
         end
         Admin_Sys_Frame_Ext_BT_1.DoClick = function()
             if (k == "weapon") then
                 local Admin_Sys_Derma = DermaMenu()
                 local Admin_Sys_Derma_Option = Admin_Sys_Derma:AddOption(Admin_System_Global.lang["remb_allweap_rest"], function()
                     net.Start("Admin_Sys:Restore")
                     net.WriteUInt(1, 3)
                     net.WriteEntity(ipr_PRemb.Ply_Cached)
                     net.SendToServer()

                     Admin_Sys_Frame_Remove()
                 end)
                 Admin_Sys_Derma_Option:SetIcon("icon16/user_red.png")

                 local Admin_Sys_Derma_Sub, Admin_Sys_Derma_Parent = Admin_Sys_Derma:AddSubMenu(Admin_System_Global.lang["remb_allweaprest_choice"])
                 Admin_Sys_Derma_Parent:SetIcon("icon16/group.png")
                 for k , v in pairs(v) do
                     local Admin_Sys_Convert = ""
                     local Admin_Sys_FindClass_Ply = ents.FindByClass("player")
                     for _, i in ipairs(Admin_Sys_FindClass_Ply) do
                         if i:HasWeapon(v) then
                             Admin_Sys_Convert = i:GetWeapon(v):GetPrintName()
                             break
                         end
                     end
                     if (Admin_Sys_Convert == "") then 
                        Admin_Sys_Convert = v or "" 
                     end
 
                     local Admin_Sys_Derma_Option_1 = Admin_Sys_Derma_Sub:AddOption(Admin_Sys_Convert, function()
                         net.Start("Admin_Sys:Restore")
                         net.WriteUInt(6, 3)
                         net.WriteEntity(Admin_Sys_Ply)
                         net.WriteString(v)
                         net.SendToServer()

                         Admin_Sys_Frame_Remove()
                     end)
                     Admin_Sys_Derma_Option_1:SetIcon("icon16/add.png")
                 end
                 Admin_Sys_Derma:Open()
                 return
             end
             local Admin_Sys_Derma = DermaMenu()
             local Admin_Sys_Derma_Option = Admin_Sys_Derma:AddOption(Admin_System_Global.lang["remb_allweaprest_backup"].. "" ..Admin_Sys_Name_Table, function()
                 local ipr_X = {
                    ["money"] = 2,
                    ["health"] = 3,
                    ["model"] = 4,
                    ["job"] = 5,
                 }
                 ipr_X = ipr_X[tostring(k)]

                 net.Start("Admin_Sys:Restore")
                 net.WriteUInt(ipr_X, 3)
                 net.WriteEntity(Admin_Sys_Ply)
                 net.SendToServer()
                 
                 Admin_Sys_Frame_Remove()
             end)
             Admin_Sys_Derma:Open()
         end
     end
end

local function Admin_Sys_Func_Remb()
     if IsValid(ipr_PRemb.Frame) then
         return
     end
     local Admin_Sys_Int = net.ReadUInt(32)
     local Admin_Sys_ReadData = net.ReadData(Admin_Sys_Int)
     local Admin_Sys_Decompress = Admin_Sys_ReadData and util.Decompress(Admin_Sys_ReadData, Admin_Sys_Int)
     local Admin_Sys_Json = Admin_Sys_Decompress and util.JSONToTable(Admin_Sys_Decompress) or {}
 
     local ipr_ct = 0
     if IsValid(ipr_PRemb.Ply_Cached) and not Admin_Sys_Json[ipr_PRemb.Ply_Cached:AccountID()] then
         if IsValid(ipr_PRemb.Gui) then
             ipr_PRemb.Gui:Remove()
         end
     end
     ipr_PRemb.Frame = vgui.Create( "DFrame" )
     local Admin_Sys_Frame_Scroll = vgui.Create("DScrollPanel", ipr_PRemb.Frame)
     local Admin_Sys_Frame_Dimage = vgui.Create("DImageButton", ipr_PRemb.Frame)
     local Admin_Sys_Frame_Dimage_1 = vgui.Create("DImageButton", ipr_PRemb.Frame)
 
     ipr_PRemb.Frame:SetTitle("")
     ipr_PRemb.Frame:SetSize(Admin_System_Global:Size_Auto(250, "w"), Admin_System_Global:Size_Auto(350, "h"))
     ipr_PRemb.Frame:ShowCloseButton(false)
     ipr_PRemb.Frame:SetDraggable(true)
     ipr_PRemb.Frame:MakePopup()
     ipr_PRemb.Frame:Center()
     ipr_PRemb.Frame.Paint = function(self, w, h)
         Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 170 ), 8)
         draw.RoundedBox(6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94))

         draw.DrawText(Admin_System_Global.lang["remb_menu_title"], "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(5, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
         draw.DrawText(Admin_System_Global.lang["remb_menu_listsave"], "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(65, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
         draw.DrawText(Admin_System_Global.lang["remb_menu_numberply"].. "" ..ipr_ct, "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(35, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
         if (ipr_ct <= 0) then
             draw.DrawText(Admin_System_Global.lang["remb_menu_noply"], "Admin_Sys_Font_T1", w/2, h/2 + Admin_System_Global:Size_Auto(15, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
         end
     end
 
     local Admin_SysPos_Frame_BT_Sv1, Admin_SysPos_FrameB = vgui.Create("DImageButton", ipr_PRemb.Frame)
     Admin_SysPos_Frame_BT_Sv1:SetPos(Admin_System_Global:Size_Auto(7, "w"),Admin_System_Global:Size_Auto(4, "h"))
     Admin_SysPos_Frame_BT_Sv1:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
     Admin_SysPos_Frame_BT_Sv1:SetImage("icon16/layers.png")
     function Admin_SysPos_Frame_BT_Sv1:Paint(w,h) end
     Admin_SysPos_Frame_BT_Sv1.DoClick = function()
         ipr_PRemb.Frame:SetAlpha(50)
         Admin_SysPos_Frame_BT_Sv1:SetImage("icon16/monitor.png")
         ipr_PRemb.Frame:SetMouseInputEnabled(false)
         ipr_PRemb.Frame:SetKeyboardInputEnabled(false)

         if IsValid(ipr_PRemb.Gui) then
             ipr_PRemb.Gui:SetAlpha(50)
             ipr_PRemb.Gui:SetMouseInputEnabled(false)
             ipr_PRemb.Gui:SetKeyboardInputEnabled(false)
         end
         gui.EnableScreenClicker(false)

         timer.Simple(1, function()
             if not IsValid(ipr_PRemb.Frame) then 
                return 
            end
             local x, y = ipr_PRemb.Frame:GetPos()
             Admin_SysPos_FrameB = vgui.Create("DFrame")
             Admin_SysPos_FrameB:SetTitle("")
             Admin_SysPos_FrameB:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(315, "h"))
             Admin_SysPos_FrameB:SetMouseInputEnabled(true)
             Admin_SysPos_FrameB:ShowCloseButton(false)
             Admin_SysPos_FrameB:SetPos(x, y)
             Admin_SysPos_FrameB.Think = function()
                 if Admin_SysPos_FrameB:IsHovered() then

                     if IsValid(ipr_PRemb.Frame) then
                         ipr_PRemb.Frame:SetAlpha(255)
                         ipr_PRemb.Frame:SetMouseInputEnabled(true)
                         ipr_PRemb.Frame:SetKeyboardInputEnabled(true)
                         if IsValid(ipr_PRemb.Gui) then
                             ipr_PRemb.Gui:SetAlpha(255)
                             ipr_PRemb.Gui:SetMouseInputEnabled(true)
                             ipr_PRemb.Gui:SetKeyboardInputEnabled(true)
                         end
                         gui.EnableScreenClicker(true)
                         Admin_SysPos_Frame_BT_Sv1:SetImage("icon16/layers.png")
                     end
                     Admin_SysPos_FrameB:Remove()
                 end
             end
             Admin_SysPos_FrameB.Paint = function(self, w, h) end
         end)
     end
 
     Admin_Sys_Frame_Dimage:SetPos(Admin_System_Global:Size_Auto(231, "w"),Admin_System_Global:Size_Auto(5, "h"))
     Admin_Sys_Frame_Dimage:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
     Admin_Sys_Frame_Dimage:SetImage("icon16/cross.png")
     function Admin_Sys_Frame_Dimage:Paint(w,h)
     end
     Admin_Sys_Frame_Dimage.DoClick = function()
         if IsValid(ipr_PRemb.Gui) then
             ipr_PRemb.Gui:Remove()
         end
         Admin_Sys_Frame_Remove()
     end
 
     Admin_Sys_Frame_Dimage_1:SetPos(Admin_System_Global:Size_Auto(208, "w"),Admin_System_Global:Size_Auto(5, "h"))
     Admin_Sys_Frame_Dimage_1:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
     Admin_Sys_Frame_Dimage_1:SetImage("icon16/arrow_rotate_anticlockwise.png")
     function Admin_Sys_Frame_Dimage_1:Paint(w,h)
     end
     Admin_Sys_Frame_Dimage_1.DoClick = function()
         Admin_Sys_Frame_Remove()
         net.Start("Admin_Sys:R_Send_Data")
         net.SendToServer()
     end
 
     Admin_Sys_Frame_Scroll:SetSize(Admin_System_Global:Size_Auto(220, "w"), Admin_System_Global:Size_Auto(220, "h"))
     Admin_Sys_Frame_Scroll:SetPos(Admin_System_Global:Size_Auto(25, "w"), Admin_System_Global:Size_Auto(95, "h"))
     local Admin_Sys_Frame_Scroll_Vbar = Admin_Sys_Frame_Scroll:GetVBar()
     Admin_Sys_Frame_Scroll_Vbar:SetSize(Admin_System_Global:Size_Auto(0, "w"), Admin_System_Global:Size_Auto(0, "h"))
     Admin_Sys_Frame_Scroll_Vbar.Paint = function(self, w, h)
         draw.RoundedBox(6, 0, 0, w, h, Color(255,255,255,15))
     end
     Admin_Sys_Frame_Scroll_Vbar.btnUp.Paint = function(self, w, h)
         draw.RoundedBox(6, 0, 0, w, h, Color(255,255,255,100))
     end
     Admin_Sys_Frame_Scroll_Vbar.btnDown.Paint = function(self, w, h)
         draw.RoundedBox(6, 0, 0, w, h, Color(255,255,255,100))
     end
     Admin_Sys_Frame_Scroll_Vbar.btnGrip.Paint = function(self, w, h)
         draw.RoundedBox(2, 0, 0, w, h, Color(0,69,175,200))
     end
 
     for k, v in pairs(Admin_Sys_Json) do
         local u = player.GetByAccountID(k)
         if not IsValid(u) then
            continue
         end
         ipr_ct = ipr_ct + 1 

         local Admin_Sys_Frame_GenBT = vgui.Create("DButton", Admin_Sys_Frame_Scroll)
         local Admin_Sys_Name = u:Name()
         local Admin_Sys_Lerp, Admin_Sys_Lerp_An = 0, 0.05
         Admin_Sys_Frame_GenBT:SetPos(Admin_System_Global:Size_Auto(1, "w"), ipr_ct * (1 + Admin_System_Global:Size_Auto(40, "h")) -Admin_System_Global:Size_Auto(40, "h"))
         Admin_Sys_Frame_GenBT:SetSize(Admin_System_Global:Size_Auto(200, "w"), Admin_System_Global:Size_Auto(25, "h"))
         Admin_Sys_Frame_GenBT:SetText("")
         Admin_Sys_Frame_GenBT:SetIcon("icon16/status_online.png")
         Admin_Sys_Frame_GenBT.DrawBox = false
         Admin_Sys_Frame_GenBT.Paint = function(self, w, h)
             draw.RoundedBox(3, Admin_System_Global:Size_Auto(0, "w"), Admin_System_Global:Size_Auto(0, "h"), w, h, Color(52,73,94))

             if (self:IsHovered()) then
                 Admin_Sys_Lerp = Lerp(Admin_Sys_Lerp_An, Admin_Sys_Lerp, w - Admin_System_Global:Size_Auto(4, "w"))
             else
                 Admin_Sys_Lerp = 0
             end
             draw.RoundedBox(6, Admin_System_Global:Size_Auto(2, "w"), Admin_System_Global:Size_Auto(0, "h"), Admin_Sys_Lerp, 1, Color(41, 128, 185))

             if not IsValid(u) then
                 draw.DrawText(Admin_Sys_Name.. "" ..Admin_System_Global.lang["remb_menu_disco"], "Admin_Sys_Font_T1", w/2 +Admin_System_Global:Size_Auto(7, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(0,175,0, 250), TEXT_ALIGN_CENTER )
             else
                 draw.DrawText(Admin_Sys_Name, "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(7, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(255,255,255, 250), TEXT_ALIGN_CENTER )
             end
         end
         Admin_Sys_Frame_GenBT.DoClick = function()
             if not IsValid(u) then 
               return 
             end
             ipr_PRemb.Bt = ipr_PRemb.Bt or Admin_Sys_Frame_GenBT or nil
             ipr_PRemb.Frame:SetPos(ScrW() / 2 - Admin_System_Global:Size_Auto(225, "w") , ScrH() / 2 - Admin_System_Global:Size_Auto(170, "h"))

             if (ipr_PRemb.Bt ~= Admin_Sys_Frame_GenBT) then
                 if IsValid(ipr_PRemb.Bt) then
                     ipr_PRemb.Bt.DrawBox = false
                 end
                 ipr_PRemb.Bt = Admin_Sys_Frame_GenBT
             end

             Admin_Sys_Frame_GenBT.DrawBox = true
             Admin_Sys_Func_Ext(ipr_PRemb.Frame, u, Admin_Sys_Json[u:AccountID()], Admin_Sys_Name)
         end
         if (ipr_ct == 1) and IsValid(ipr_PRemb.Ply_Cached) then

             if IsValid(ipr_PRemb.Gui) and IsValid(ipr_PRemb.Frame)  then
                 ipr_PRemb.Gui:Remove()
                 ipr_PRemb.Frame:SetPos(ScrW() / 2 - Admin_System_Global:Size_Auto(225, "w") , ScrH() / 2 - Admin_System_Global:Size_Auto(170, "h"))

                 Admin_Sys_Func_Ext(ipr_PRemb.Frame, ipr_PRemb.Ply_Cached,  Admin_Sys_Json[ipr_PRemb.Ply_Cached:AccountID()], ipr_PRemb.Ply_Cached:Name())
             end
         end
     end
     if (ipr_ct >= 6) then
         Admin_Sys_Frame_Scroll:SetPos(Admin_System_Global:Size_Auto(20, "w"), Admin_System_Global:Size_Auto(95, "h"))
     end

     if IsValid(ipr_PRemb.Ply_Cached) and not istable(Admin_Sys_Json[ipr_PRemb.Ply_Cached:AccountID()]) and IsValid(ipr_PRemb.Gui) then
         ipr_PRemb.Gui:Remove()
         if IsValid(ipr_PRemb.Frame) then
             ipr_PRemb.Frame:Center()
         end
     end
end
net.Receive("Admin_Sys:Cmd_Remb", Admin_Sys_Func_Remb)