---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

local ipr_PChat = {}
ipr_PChat.TChat = {}

local function Admin_SysLoadHistory(Admin_Sys_Tick_RichText, Admin_Sys_StringText)
     if IsValid(Admin_Sys_Tick_RichText) then
         ipr_PChat.TChat[#ipr_PChat.TChat + 1] = {nom = "Commande Chat : " ..LocalPlayer():Nick(), heure = os.time(), grp = LocalPlayer():GetUserGroup(), mssg = Admin_Sys_StringText}
         
         Admin_Sys_Tick_RichText:AppendText("\nCommande Chat : " ..LocalPlayer():Nick().. "["..LocalPlayer():GetUserGroup().. "] :\n" ..Admin_Sys_StringText)
         Admin_Sys_Tick_RichText:GotoTextEnd()
     end
end 

ipr_PChat.GChat = false
local function Admin_SysReload(Admin_Sys_Tick_RichText, Admin_Sys_StringText, Admin_Syst_ChatDtext)
     if IsValid(Admin_Sys_Tick_RichText) then
          local ipr_LPlayer = LocalPlayer()
          if not Admin_Sys_StringText or string.len(Admin_Sys_StringText) <= 1 then
               ipr_LPlayer:PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["chat_toosh"])
               return
          end
          Admin_Syst_ChatDtext:SetText(ipr_PChat.GChat.. " : " ..Admin_System_Global.lang["chat_dentry"])
		  if (ipr_PChat.GChat ~= Admin_System_Global.lang["chat_title"]) and (string.Trim(Admin_Sys_StringText) ~= "") then
               ipr_LPlayer:ConCommand("say " ..Admin_Sys_StringText)
			   Admin_SysLoadHistory(Admin_Sys_Tick_RichText, Admin_Sys_StringText)
               return
          end

          net.Start("Admin_Sys:ChatAdmin")
          net.WriteString(Admin_Sys_StringText)
          net.SendToServer()
     end
end

local function Admin_SysHistory(Admin_Sys_Tick_RichText, Admin_Sys_Tick_RichBool)
    if IsValid(Admin_Sys_Tick_RichText) and istable(ipr_PChat.TChat) and (#ipr_PChat.TChat >= 1) then
        Admin_Sys_Tick_RichText:SetText("")
        Admin_Sys_Tick_RichText:InsertColorChange(255, 255, 255, 255)
        Admin_Sys_Tick_RichText:AppendText(Admin_System_Global.lang["chat_welc"])

        if not Admin_Sys_Tick_RichBool then
            Admin_Sys_Tick_RichText:InsertColorChange(255, 177, 66, 255)
        end
        for i = 1, #ipr_PChat.TChat do
            Admin_Sys_Tick_RichText:AppendText((not Admin_Sys_Tick_RichBool and Admin_System_Global.lang["chat_bck"] or "\n ") ..ipr_PChat.TChat[i].nom.. "["..ipr_PChat.TChat[i].grp.. "] - " ..((isnumber(tonumber(ipr_PChat.TChat[i].heure)) and Admin_System_Global:TradTime( string.NiceTime( os.time() - ipr_PChat.TChat[i].heure ))) or "").. " :\n" ..ipr_PChat.TChat[i].mssg)
        end
        Admin_Sys_Tick_RichText:InsertColorChange(255, 255, 255, 255)
        timer.Simple(0.1, function()
            if IsValid(Admin_Sys_Tick_RichText) then
                Admin_Sys_Tick_RichText:GotoTextEnd()
            end
        end)
    end
end

ipr_PChat.Chat = false
ipr_PChat.RText = false
local function Admin_Syst_ChatFunc()
     local Admin_Sys_Tbl, Admin_Sys_Int = {}, net.ReadUInt(8)
     for i = 1, Admin_Sys_Int do
         Admin_Sys_Tbl[i] = net.ReadString()
     end
     local Admin_Sys_Ent = net.ReadEntity()
     if not IsValid(ipr_PChat.Chat) and Admin_Sys_Tbl[1] then
         ipr_PChat.TChat[#ipr_PChat.TChat + 1] = {nom = Admin_Sys_Tbl[1], heure = Admin_Sys_Tbl[3], grp = Admin_Sys_Tbl[2], mssg = Admin_Sys_Tbl[4]}
         return
     end
     if IsValid(ipr_PChat.Chat) then
         if IsValid(ipr_PChat.RText) then
             Admin_SysHistory(ipr_PChat.RText, true)

             if (Admin_Sys_Tbl[1]) then
                 ipr_PChat.TChat[#ipr_PChat.TChat + 1] = {nom = Admin_Sys_Tbl[1], heure = Admin_Sys_Tbl[3], grp = Admin_Sys_Tbl[2], mssg = Admin_Sys_Tbl[4]}
             end
             if (Admin_Sys_Tbl[4]) then
                 ipr_PChat.RText:AppendText("\n" ..Admin_Sys_Tbl[1].. "["..Admin_Sys_Tbl[2].. "] :\n" ..Admin_Sys_Tbl[4])
             end
             ipr_PChat.RText:GotoTextEnd()
         end
         return
     end

     ipr_PChat.GChat = Admin_System_Global.lang["chat_title"]
     ipr_PChat.Chat = vgui.Create("DFrame")
     ipr_PChat.RText = vgui.Create("RichText",ipr_PChat.Chat)
     local Admin_Syst_ChatDtext, Admin_Sys_StringText = vgui.Create( "DTextEntry", ipr_PChat.Chat)
     local Admin_Syst_ChatDComb = vgui.Create("DImageButton", ipr_PChat.Chat)
     local Admin_Syst_ChatDComb_a = vgui.Create("DImageButton", ipr_PChat.Chat)
     local Admin_Syst_ChatFrm = vgui.Create("DImageButton", ipr_PChat.Chat)
     local Admin_Syst_ChatBT, Admin_Syst_ChatBTb = vgui.Create("DImageButton", ipr_PChat.Chat)
     local Admin_Syst_ChatV, Admin_Sys_Lerp, Admin_Sys_Lerp_An = vgui.Create("DButton", ipr_PChat.Chat), 0, 0.05
     local Admin_Sys_Count, Admin_Sys_CurTime = 0, 0
 
     ipr_PChat.Chat:SetSize(Admin_System_Global:Size_Auto(350, "w"), Admin_System_Global:Size_Auto(190, "h"))
     ipr_PChat.Chat:SetTitle("")
     ipr_PChat.Chat:ShowCloseButton(false)
     ipr_PChat.Chat:Center()
     ipr_PChat.Chat:MakePopup()
     ipr_PChat.Chat:SetSizable( true )
     ipr_PChat.Chat:SetMinWidth( 200 )
     ipr_PChat.Chat:SetMinHeight( 100 )
     ipr_PChat.Chat.Paint = function(self, w, h)
         Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 150 ), 8)
         draw.RoundedBox(6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94))
         local ipr_Cur = CurTime()

         if (ipr_Cur > Admin_Sys_CurTime) then
             local Admin_SysFindClass = ents.FindByClass("player")
             Admin_Sys_Count = 0
             for _, v in ipairs(Admin_SysFindClass) do
                 if not Admin_System_Global:Sys_Check(v) then
                   continue
                 end
                 Admin_Sys_Count = Admin_Sys_Count + 1
             end
             Admin_Sys_CurTime = ipr_Cur + 5
         end
         draw.DrawText(ipr_PChat.GChat.. " - En ligne : " ..Admin_Sys_Count,"Admin_Sys_Font_T1",w / 2, Admin_System_Global:Size_Auto(5, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
     end
 
     ipr_PChat.RText:SetPos(Admin_System_Global:Size_Auto(5, "w"),Admin_System_Global:Size_Auto(30, "h"))
     ipr_PChat.RText:SetSize(0,0)
     ipr_PChat.RText:InsertColorChange(255, 255, 255, 255)
     ipr_PChat.RText:SetVerticalScrollbarEnabled(true)
     ipr_PChat.RText.Think = function()
         local x, y = ipr_PChat.Chat:GetSize()
         ipr_PChat.RText:SetSize(x -10, y - 65)
     end
     local ipr_child_p = ipr_PChat.RText:GetChildren()[1]
     local ipr_child_s = ipr_PChat.RText:GetChildren()[2]
     if IsValid(ipr_child_p) then
        ipr_child_p.Paint = function(self, w, h)
         draw.RoundedBox(6, 0, 0, w-Admin_System_Global:Size_Auto(1, "w"), h, Admin_System_Global.TicketScrollRichText)
     end
    end
    if IsValid(ipr_child_s) then
        ipr_child_s.Paint = function(self, w, h)
         draw.RoundedBox(6, 0, 0, w-Admin_System_Global:Size_Auto(1, "w"), h, Color(0,0,0,50))
     end
    end
     function ipr_PChat.RText:PerformLayout()
         self:SetFontInternal("Admin_Sys_Font_T3")
     end
     ipr_PChat.RText:AppendText(Admin_System_Global.lang["chat_welc"])
 
     Admin_Syst_ChatDtext:SetSize(0, 0)
     Admin_Syst_ChatDtext:SetPos(0, 0)
     Admin_Syst_ChatDtext:SetText(ipr_PChat.GChat.. " : " ..Admin_System_Global.lang["chat_dentry"])
     Admin_Syst_ChatDtext:SetFont("Admin_Sys_Font_T2")
     Admin_Syst_ChatDtext.MaxCaractere = 150
     Admin_Syst_ChatDtext.Think = function()
         local x, y = ipr_PChat.Chat:GetSize()
         Admin_Syst_ChatDtext:SetPos(Admin_System_Global:Size_Auto(10, "w"), y - 31)
         Admin_Syst_ChatDtext:SetSize(x - 120, Admin_System_Global:Size_Auto(25, "h"))
     end
     Admin_Syst_ChatDtext.OnGetFocus = function()
         if (Admin_Syst_ChatDtext:GetText() == ipr_PChat.GChat.. " : " ..Admin_System_Global.lang["chat_dentry"]) then
             Admin_Syst_ChatDtext:SetTextColor(Color(0, 0, 0, 255))
             Admin_Syst_ChatDtext:SetText("")
         end
     end
     Admin_Syst_ChatDtext.OnTextChanged = function(self)
         Admin_Sys_StringText = self:GetValue()
         local Admin_Sys_Number = string.len(Admin_Sys_StringText)
         if (Admin_Sys_Number > self.MaxCaractere) then
             self:SetText(self.OText or Admin_System_Global.lang["complaint"])
             self:SetValue(self.OText or Admin_System_Global.lang["complaint"])
         else
             self.OText = Admin_Sys_StringText
         end
     end
     Admin_Syst_ChatDtext.OnEnter = function()
         Admin_SysReload(ipr_PChat.RText, Admin_Sys_StringText, Admin_Syst_ChatDtext)
         Admin_Sys_StringText = nil
     end
 
     Admin_Syst_ChatDComb:SetPos(0, 0)
     Admin_Syst_ChatDComb:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(19, "h"))
     Admin_Syst_ChatDComb:SetImage("icon16/comments.png")
     Admin_Syst_ChatDComb.Think = function()
         local x, y = ipr_PChat.Chat:GetSize()
         Admin_Syst_ChatDComb:SetPos(x - 43, Admin_System_Global:Size_Auto(5, "h"))
     end
     function Admin_Syst_ChatDComb:Paint(w, h) end
     Admin_Syst_ChatDComb.DoClick = function()
         local Admin_SysPos_Derma = DermaMenu()
         local Admin_SysPos_Option = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["chat_title"], function()
             ipr_PChat.GChat = Admin_System_Global.lang["chat_title"]
             Admin_Syst_ChatDtext:SetText(ipr_PChat.GChat.. " : " ..Admin_System_Global.lang["chat_dentry"])
         end)
         Admin_SysPos_Option:SetIcon("icon16/user_gray.png")
         local Admin_SysPos_Option_ = Admin_SysPos_Derma:AddOption("Commande Chat (!admin ect..)", function()
             ipr_PChat.GChat = "Commande Chat (!admin ect..)"
             Admin_Syst_ChatDtext:SetText(ipr_PChat.GChat.. " : " ..Admin_System_Global.lang["chat_dentry"])
         end)
         Admin_SysPos_Option_:SetIcon("icon16/application_xp_terminal.png")
         Admin_SysPos_Derma:Open()
     end
 
     Admin_Syst_ChatDComb_a:SetPos(30, 5)
     Admin_Syst_ChatDComb_a:SetSize(Admin_System_Global:Size_Auto(16, "w"), Admin_System_Global:Size_Auto(16, "h"))
     Admin_Syst_ChatDComb_a:SetImage("icon16/cog.png")
     function Admin_Syst_ChatDComb_a:Paint(w, h) end
     Admin_Syst_ChatDComb_a.DoClick = function()
         local Admin_SysPos_Derma = DermaMenu()
         local Admin_SysPos_Option = Admin_SysPos_Derma:AddOption("Clear Chat", function()
             ipr_PChat.TChat = {}
             ipr_PChat.RText:SetText("")
             ipr_PChat.RText:InsertColorChange( 255, 255, 255, 255 )
         end)
         Admin_SysPos_Option:SetIcon("icon16/cog.png")
         Admin_SysPos_Derma:Open()
     end
 
     Admin_Syst_ChatFrm:SetPos(0, 0)
     Admin_Syst_ChatFrm:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(19, "h"))
     Admin_Syst_ChatFrm:SetImage("icon16/cross.png")
     Admin_Syst_ChatFrm.Think = function()
         local x, y = ipr_PChat.Chat:GetSize()
         Admin_Syst_ChatFrm:SetPos(x - 20, Admin_System_Global:Size_Auto(4, "h"))
     end
     function Admin_Syst_ChatFrm:Paint(w, h) end
     Admin_Syst_ChatFrm.DoClick = function()
         ipr_PChat.Chat:Remove()
     end
 
     Admin_Syst_ChatV:SetPos(0, 0)
     Admin_Syst_ChatV:SetSize(Admin_System_Global:Size_Auto(95, "w"), Admin_System_Global:Size_Auto(22, "h"))
     Admin_Syst_ChatV:SetText("")
     Admin_Syst_ChatV:SetIcon("icon16/tick.png")
     Admin_Syst_ChatV.Think = function()
         local x, y = ipr_PChat.Chat:GetSize()
         Admin_Syst_ChatV:SetPos(x - 100, y - 30)
     end
     function Admin_Syst_ChatV:Paint(w, h)
         draw.RoundedBox(3, 0, 0, w, h, Color(52,73,94))
         
         local ipr_Hover = self:IsHovered()
         if (ipr_Hover) then
             Admin_Sys_Lerp = Lerp(Admin_Sys_Lerp_An, Admin_Sys_Lerp, w - 3)
         else
             Admin_Sys_Lerp = 0
         end
         draw.RoundedBox(6, 2, 0, Admin_Sys_Lerp, 1, Color(192, 57, 43))
         draw.DrawText(Admin_System_Global.lang["chat_send"], "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(2, "h"), Color(255,255,255, 280), TEXT_ALIGN_CENTER )
     end
     Admin_Syst_ChatV.DoClick = function()
         Admin_SysReload(ipr_PChat.RText, Admin_Sys_StringText, Admin_Syst_ChatDtext)
     end
 
     Admin_Syst_ChatBT:SetPos(Admin_System_Global:Size_Auto(7, "w"),Admin_System_Global:Size_Auto(5, "h"))
     Admin_Syst_ChatBT:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
     Admin_Syst_ChatBT:SetImage("icon16/layers.png")
     Admin_Syst_ChatBT.DoClick = function()
         ipr_PChat.Chat:SetAlpha(50)
         Admin_Syst_ChatBT:SetImage("icon16/monitor.png")
         ipr_PChat.Chat:SetMouseInputEnabled(false)
         ipr_PChat.Chat:SetKeyboardInputEnabled(false)
         gui.EnableScreenClicker(false)
         timer.Simple(1, function()
             if not IsValid(ipr_PChat.Chat) then return end
             local x, y = ipr_PChat.Chat:GetPos()
             Admin_Syst_ChatBTb = vgui.Create("DFrame")
             Admin_Syst_ChatBTb:SetTitle("")
             Admin_Syst_ChatBTb:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(315, "w"))
             Admin_Syst_ChatBTb:SetMouseInputEnabled(true)
             Admin_Syst_ChatBTb:ShowCloseButton(false)
             Admin_Syst_ChatBTb:SetPos(x, y)
             Admin_Syst_ChatBTb.Think = function()
                 local x, y = ipr_PChat.Chat:GetSize()
                 Admin_Syst_ChatBTb:SetSize(x, y)
                 if Admin_Syst_ChatBTb:IsHovered() then
                     if IsValid(ipr_PChat.Chat) then
                         ipr_PChat.Chat:SetAlpha(255)
                         ipr_PChat.Chat:SetMouseInputEnabled(true)
                         ipr_PChat.Chat:SetKeyboardInputEnabled(true)
                         gui.EnableScreenClicker(true)
                         Admin_Syst_ChatBT:SetImage("icon16/layers.png")
                     end
                     Admin_Syst_ChatBTb:Remove()
                 end
             end
             Admin_Syst_ChatBTb.Paint = function(self, w, h) end
         end)
     end

     Admin_SysHistory(ipr_PChat.RText)
end 
net.Receive("Admin_Sys:ChatAdmin", Admin_Syst_ChatFunc)