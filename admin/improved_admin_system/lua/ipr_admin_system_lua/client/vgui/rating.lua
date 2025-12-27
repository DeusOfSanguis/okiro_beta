---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

if not (Admin_System_Global.RateAdminEnable) then 
     return 
end

local ipr_Rate = {}
ipr_Rate.GuiP = false

local function Admin_Syst_RatingEnd()
    ipr_Rate.GuiP = vgui.Create("DFrame")
    local Admin_Sys_RatingEndFrm = vgui.Create("DImageButton", ipr_Rate.GuiP)

    ipr_Rate.GuiP:SetTitle("")
    ipr_Rate.GuiP:ShowCloseButton(false)
    ipr_Rate.GuiP:SetDraggable(false)
    ipr_Rate.GuiP:SetSize(Admin_System_Global:Size_Auto(160, "w"), Admin_System_Global:Size_Auto(25, "h"))
    ipr_Rate.GuiP:AlphaTo(5, 0, 0)
    ipr_Rate.GuiP:AlphaTo(255, 2, 0)
    ipr_Rate.GuiP:AlphaTo(0, 4, 2)
    ipr_Rate.GuiP:Center()
    ipr_Rate.GuiP.Paint = function(self, w, h)
        Admin_System_Global:Gui_Blur(self, 1, Color(52,73,94), 8)
        draw.DrawText(Admin_System_Global.lang["rating_supportnd"],"Admin_Sys_Font_T1", Admin_System_Global:Size_Auto(88, "w"), Admin_System_Global:Size_Auto(4, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
    end

    Admin_Sys_RatingEndFrm:SetPos(Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(4, "h"))
    Admin_Sys_RatingEndFrm:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(17, "h"))
    Admin_Sys_RatingEndFrm:SetImage("icon16/emoticon_wink.png")
    function Admin_Sys_RatingEndFrm:Paint(w, h) end

    timer.Simple(4, function()
        if IsValid(ipr_Rate.GuiP) then
            ipr_Rate.GuiP:Remove()
        end
    end)
end

ipr_Rate.GStars = {}
ipr_Rate.GRate = false
local function Admin_Syst_RatingEx()
     if IsValid(ipr_Rate.GRate) then 
        return 
     end
     ipr_Rate.GRate = vgui.Create("DFrame")
     local Admin_SysRate, Admin_Sys_Inc, Admin_Sys_Count = "-", nil, 0
     local Admin_Sys_Dtext, Admin_Sys_StringText = vgui.Create("DTextEntry", ipr_Rate.GRate)
     local Admin_Sys_Rating_Frm = vgui.Create("DImageButton", ipr_Rate.GRate)
     
     ipr_Rate.GRate:SetTitle("")
     ipr_Rate.GRate:ShowCloseButton(false)
     ipr_Rate.GRate:SetSize(Admin_System_Global:Size_Auto(250, "w"), Admin_System_Global:Size_Auto(180, "h"))
     ipr_Rate.GRate:Center()
     ipr_Rate.GRate:MakePopup()
     ipr_Rate.GRate.Paint = function(self, w, h)
         Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 150 ), 8)        
         draw.RoundedBox(6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94))

         draw.DrawText(Admin_System_Global.lang["rating_supportft"] ,"Admin_Sys_Font_T1",w / 2, Admin_System_Global:Size_Auto(5, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
         draw.DrawText(Admin_System_Global.lang["rating_supportrate"] ,"Admin_Sys_Font_T1",w / 2, Admin_System_Global:Size_Auto(30, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
         draw.DrawText(Admin_System_Global.lang["rating_supportchx"].. "" ..Admin_SysRate.. "/5","Admin_Sys_Font_T1",w / 2, Admin_System_Global:Size_Auto(115, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
     end
 
     Admin_Sys_Dtext:SetPos(Admin_System_Global:Size_Auto(15, "w"), Admin_System_Global:Size_Auto(85, "h"))
     Admin_Sys_Dtext:SetSize(Admin_System_Global:Size_Auto(225, "w"), Admin_System_Global:Size_Auto(25, "h"))
     Admin_Sys_Dtext:SetText(Admin_System_Global.lang["rating_supportcom"])
     Admin_Sys_Dtext:SetFont("Admin_Sys_Font_T1")
     Admin_Sys_Dtext.MaxCaractere = 45
     Admin_Sys_Dtext.OnGetFocus = function()
         if (Admin_Sys_Dtext:GetText() == Admin_System_Global.lang["rating_supportcom"]) then
             Admin_Sys_Dtext:SetTextColor(Color(0, 0, 0, 255))
             Admin_Sys_Dtext:SetText("")
         end
     end
     Admin_Sys_Dtext.OnTextChanged = function(self)
         Admin_Sys_StringText = self:GetValue()
         local Admin_Sys_Number = string.len(Admin_Sys_StringText)
 
         if (Admin_Sys_Number > self.MaxCaractere) then
             self:SetText(self.Admin_Sys_ODTextVal or Admin_System_Global.lang["complaint"])
             self:SetValue(self.Admin_Sys_ODTextVal or Admin_System_Global.lang["complaint"])
         else
             self.Admin_Sys_ODTextVal = Admin_Sys_StringText
         end
     end
 
     Admin_Sys_Rating_Frm:SetPos(Admin_System_Global:Size_Auto(230, "w"), Admin_System_Global:Size_Auto(4, "h"))
     Admin_Sys_Rating_Frm:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(17, "h"))
     Admin_Sys_Rating_Frm:SetImage("icon16/cross.png")
     function Admin_Sys_Rating_Frm:Paint(w, h) end
     Admin_Sys_Rating_Frm.DoClick = function()
         ipr_Rate.GRate:Remove()
     end

     for i = 1, 5 do
         local Admin_Sys_Rating_Stars = vgui.Create("DImageButton", ipr_Rate.GRate)
         Admin_Sys_Rating_Stars.Number = i
         
         Admin_Sys_Rating_Stars:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(17, "h"))
         Admin_Sys_Rating_Stars:SetPos(-Admin_System_Global:Size_Auto(5, "w") + i * (1 + Admin_System_Global:Size_Auto(40, "w")), Admin_System_Global:Size_Auto(55, "h"))
         Admin_Sys_Rating_Stars:SetImage("icon16/star.png")
         function Admin_Sys_Rating_Stars:Paint(w, h) end
         
         Admin_Sys_Rating_Stars.Think = function()
             if (Admin_Sys_Rating_Stars:IsHovered()) then
                 for _, v in pairs(ipr_Rate.GStars) do
                     if not IsValid(v) then
                         continue 
                     end
                     if (Admin_Sys_Rating_Stars.Number >= 2) or (Admin_Sys_Rating_Stars.Number <= 4) then
                         v:SetAlpha(255)
                     end
                     if (Admin_Sys_Rating_Stars.Number < v.Number) then
                         v:SetAlpha(35)
                     else
                         Admin_Sys_Rating_Stars:SetAlpha(255)
                     end 
                 end
             end
         end
         Admin_Sys_Rating_Stars.DoClick = function()
             Admin_SysRate = Admin_Sys_Rating_Stars.Number
         end
         ipr_Rate.GStars[i] = Admin_Sys_Rating_Stars
     end  
     for c, p in ipairs(ipr_Rate.GStars) do
        if (c <= 3) then
            continue
        end 
        p:SetAlpha(35)
     end

     local Admin_Sys_Rating_V, Admin_Sys_Lerp, Admin_Sys_Lerp_An = vgui.Create("DButton", ipr_Rate.GRate), 0, 0.05
     Admin_Sys_Rating_V:SetPos( Admin_System_Global:Size_Auto(70, "w"), Admin_System_Global:Size_Auto(145, "h"))
     Admin_Sys_Rating_V:SetSize( Admin_System_Global:Size_Auto(105, "w"), Admin_System_Global:Size_Auto(22, "h") )
     Admin_Sys_Rating_V:SetText( "" )
     Admin_Sys_Rating_V:SetIcon("icon16/tick.png")
     function Admin_Sys_Rating_V:Paint(w, h)
         draw.RoundedBox(3, 0, 0, w, h, Color(52,73,94))
         
         local ipr_Hover = self:IsHovered()
         if (ipr_Hover) then
             Admin_Sys_Lerp = Lerp(Admin_Sys_Lerp_An, Admin_Sys_Lerp, w - 3)
         else
             Admin_Sys_Lerp = 0
         end
         draw.RoundedBox( 6, 2, 0, Admin_Sys_Lerp, 1, Color(192, 57, 43) )
         draw.DrawText(Admin_System_Global.lang["validate"], "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(2, "h"), Color(255,255,255, 280), TEXT_ALIGN_CENTER )
     end
     Admin_Sys_Rating_V.DoClick = function()
         if not isnumber(Admin_SysRate) or not Admin_Sys_StringText or (string.len(Admin_Sys_StringText) <= 1) then
             LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["rating_oblgcom"])
             return
         end
         
         net.Start("Admin_Sys:Rate")
         net.WriteFloat(Admin_SysRate)
         net.WriteString(Admin_Sys_StringText)
         net.SendToServer()

         ipr_Rate.GRate:Remove()
         Admin_Syst_RatingEnd()
     end
end

net.Receive("Admin_Sys:Rate", Admin_Syst_RatingEx)