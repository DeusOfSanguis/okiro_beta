---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

local ipr_Stats = {}

local function Admin_Sys_UpdateDlist(Admin_Sys_F)
    for _, v in pairs(Admin_Sys_F:GetLines()) do
        for _, l in pairs(v.Columns) do
            l:SetTextColor(Color(236, 240, 241))
            l:SetFont("Admin_Sys_Font_T1")
        end
    end
end

ipr_Stats.PString = "STEAM"
local function Admin_SysAddList(Admin_Sys_T, Admin_Sys_Td, Admin_Sys_P)
    for d, v in pairs(Admin_Sys_T) do
        Admin_Sys_P:AddLine(v.Central_Admin, Admin_System_Global.lang["stats_indiq_i"].. "" ..Admin_System_Global:TradTime(string.NiceTime(os.time() - v.Central_Horodatage)), v.Central_NumbTicket, d and Admin_Sys_Td[d] and string.find( tostring(d), ipr_Stats.PString ) and Admin_Sys_Td[d].Admin_Sys_N.. "/5" or Admin_Sys_Td and Admin_Sys_Td[v.Central_SteamID] and Admin_Sys_Td[v.Central_SteamID].Admin_Sys_N .."/5" or "-/5", v.Central_G or v.Central_Grp or "Inconnu", not isnumber(d) and d or v.Central_SteamID or "Inconnu" )
    end
    
    local Admin_SysMaxVal, Admin_SysLines = 6, 0
    for nb, _ in pairs(Admin_Sys_P:GetLines()) do
        Admin_SysLines = nb
    end
    for i = 1, Admin_SysMaxVal + 1 do
        if i > Admin_SysLines and i <= Admin_SysMaxVal + 1 then
            Admin_Sys_P:AddLine("⁃","⁃","⁃","⁃","⁃","⁃")
        end
    end
end 

ipr_Stats.PTbl = {}
local function Admin_Sys_LerpAnim(Admin_System_Val, Admin_System_MaxVal, Admin_System_Nom)
    local Admin_System_Val = Admin_System_Val or 100
    local Admin_System_MaxVal = Admin_System_MaxVal or 100

    ipr_Stats.PTbl[Admin_System_Nom] = ipr_Stats.PTbl[Admin_System_Nom] or {oldhp = Admin_System_Val,newhp = Admin_System_Val,start = 0}
    local Admin_Sys_SmHp = Lerp((SysTime() - ipr_Stats.PTbl[Admin_System_Nom].start) / 0.7, ipr_Stats.PTbl[Admin_System_Nom].oldhp, ipr_Stats.PTbl[Admin_System_Nom].newhp)

    if (ipr_Stats.PTbl[Admin_System_Nom].newhp ~= Admin_System_Val) then
        if (Admin_Sys_SmHp ~= Admin_System_Val) then
            ipr_Stats.PTbl[Admin_System_Nom].newhp = Admin_Sys_SmHp
        end
        ipr_Stats.PTbl[Admin_System_Nom].oldhp = ipr_Stats.PTbl[Admin_System_Nom].newhp
        ipr_Stats.PTbl[Admin_System_Nom].start = SysTime()
        ipr_Stats.PTbl[Admin_System_Nom].newhp = Admin_System_Val
    end
    return math.Round(math.max(0, Admin_Sys_SmHp) / Admin_System_MaxVal * 100)
end 

local ipr = {
    timer = {
       rm = "ImprovedSys_SafeRemoveifStuck",
       dt = "ImprovedSys_SysTimerDataRdi",
    },
    value = {
        ct = 0,
        cr = 0;
        sv = 0,
        sn = 0,
    }
}
local function Admin_Sys_UpdateValue()
    ipr_Stats.PTbl = {}
    for k in pairs(ipr.value) do
        ipr.value[k] = 0
    end
    if timer.Exists(ipr.timer.dt) then
        timer.Remove(ipr.timer.dt)
    end
    if timer.Exists(ipr.timer.rm) then
        timer.Remove(ipr.timer.rm)
    end
end

ipr_Stats.GuiS = false
ipr_Stats.GuiF = false
local function Admin_Syst_StatsSec_Func(Admin_Syst_RTPrimary, Admin_Syst_ValPly, Admin_Syst_ValTbl, Admin_Syst_ValNg, Admin_Syst_ValST)
    if IsValid(ipr_Stats.GuiF) then
        return
    end
    Admin_Syst_RTPrimary:Center()
    local y, g = Admin_Syst_RTPrimary:GetPos()
    Admin_Syst_RTPrimary:SetPos(y - Admin_System_Global:Size_Auto(170, "w"), g)

    ipr_Stats.GuiF = vgui.Create("DFrame")
    local Admin_Sys_Rating_Frm = vgui.Create("DImageButton", ipr_Stats.GuiF)
    local Admin_Sys_FrameInfo_Scroll = vgui.Create("DScrollPanel", ipr_Stats.GuiF)
    local Admin_SysCount = 0

    ipr_Stats.GuiF:SetTitle("")
    ipr_Stats.GuiF:ShowCloseButton(false)
    ipr_Stats.GuiF:SetSize(Admin_System_Global:Size_Auto(350, "w"), Admin_System_Global:Size_Auto(250, "h"))
    ipr_Stats.GuiF:SetPos(0, 0)
    ipr_Stats.GuiF:MakePopup()
    ipr_Stats.GuiF.Think = function()
        if IsValid(Admin_Syst_RTPrimary) then
            local x, y = Admin_Syst_RTPrimary:GetPos()
            ipr_Stats.GuiF:SetPos(x + Admin_System_Global:Size_Auto(380, "w"), y + Admin_System_Global:Size_Auto(45, "h"))
        end
    end
    ipr_Stats.GuiF.Paint = function(self, w, h)
        Admin_System_Global:Gui_Blur(self, Admin_System_Global:Size_Auto(1, "w"), Color( 0, 0, 0, 150 ), 8)

        draw.RoundedBox( 6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94) )
        draw.DrawText(Admin_System_Global.lang["stats_titlesp"], "Admin_Sys_Font_T1",w / 2,Admin_System_Global:Size_Auto(5, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
        draw.DrawText(Admin_System_Global.lang["stats_adminsp"].. "" ..Admin_Syst_ValPly, "Admin_Sys_Font_T1",w / 2,Admin_System_Global:Size_Auto(28, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
        draw.DrawText(Admin_System_Global.lang["stats_moynsp"].. "" ..Admin_Syst_ValNg.. "" ..Admin_System_Global.lang["stats_moynspav"].. "" ..Admin_SysCount, "Admin_Sys_Font_T1",w / 2,Admin_System_Global:Size_Auto(45, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
        if not Admin_Syst_ValTbl then
            draw.DrawText(Admin_System_Global.lang["stats_noratesave"], "Admin_Sys_Font_T4",w / 2,Admin_System_Global:Size_Auto(140, "h"),Color(46, 204, 113),TEXT_ALIGN_CENTER)
        end
    end

    Admin_Sys_Rating_Frm:SetPos(Admin_System_Global:Size_Auto(330, "w"), Admin_System_Global:Size_Auto(4, "h"))
    Admin_Sys_Rating_Frm:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(17, "h"))
    Admin_Sys_Rating_Frm:SetImage("icon16/cross.png")
    function Admin_Sys_Rating_Frm:Paint(w, h) end
    Admin_Sys_Rating_Frm.DoClick = function()
        Admin_Syst_RTPrimary:Center()
        ipr_Stats.GuiF:Remove()
    end

    Admin_Sys_FrameInfo_Scroll:SetSize(Admin_System_Global:Size_Auto(355, "w"), Admin_System_Global:Size_Auto(155, "h"))
    Admin_Sys_FrameInfo_Scroll:SetPos(Admin_System_Global:Size_Auto(0, "w"), Admin_System_Global:Size_Auto(75, "h"))
    local Admin_Sys_FrameInfo_Vbar = Admin_Sys_FrameInfo_Scroll:GetVBar()
    Admin_Sys_FrameInfo_Vbar:SetSize(0, 0)
    function Admin_Sys_FrameInfo_Vbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Admin_System_Global.CreatetickScrollBar_Up)
    end
    function Admin_Sys_FrameInfo_Vbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Admin_System_Global.CreatetickScrollBar_Down)
    end
    function Admin_Sys_FrameInfo_Vbar.btnGrip:Paint(w, h)
        draw.RoundedBox(8, 0, 0, w, h, color_white)
    end

    if (Admin_Syst_ValTbl) then
        for k, v in pairs(Admin_Syst_ValTbl) do
            if istable(v) then
                Admin_SysCount = Admin_SysCount + 1
                local Admin_Sys_Service_Dlabel = vgui.Create("DLabel", Admin_Sys_FrameInfo_Scroll)
                Admin_Sys_Service_Dlabel:SetPos(1, Admin_System_Global:Size_Auto(45, "h") * Admin_SysCount -Admin_System_Global:Size_Auto(45, "h"))
                Admin_Sys_Service_Dlabel:SetSize(Admin_System_Global:Size_Auto(347, "w"), Admin_System_Global:Size_Auto(40, "h"))
                Admin_Sys_Service_Dlabel:SetText("")
                Admin_Sys_Service_Dlabel.Paint = function(self,w,h)
                    draw.RoundedBox(6, 1, 1, w, h, Color(52,73,94, 240))
                    draw.DrawText(Admin_System_Global.lang["stats_ratecat"].. "" ..v.Central_R.. "/5" or "-/5", "Admin_Sys_Font_T1", Admin_System_Global:Size_Auto(40, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(255,255,255, 250), TEXT_ALIGN_CENTER)
                    draw.DrawText(Admin_System_Global.lang["stats_rateplycat"].. "" ..v.Central_P, "Admin_Sys_Font_T1", Admin_System_Global:Size_Auto(130, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(255,255,255, 250), TEXT_ALIGN_CENTER)
                    draw.DrawText(v.Central_C, "Admin_Sys_Font_T1", Admin_System_Global:Size_Auto(7, "w"), Admin_System_Global:Size_Auto(20, "h"), Color(255,255,255, 250), TEXT_ALIGN_LEFT)
                end
                if (v.Central_R) then
                    for i = 1, v.Central_R do
                        local Admin_Sys_Rating_Stars = vgui.Create("DImageButton", Admin_Sys_FrameInfo_Scroll)
                        Admin_Sys_Rating_Stars:SetSize(Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(8, "h"))
                        Admin_Sys_Rating_Stars:SetPos(Admin_System_Global:Size_Auto(195, "w") + i * (1 + Admin_System_Global:Size_Auto(13, "w")), Admin_System_Global:Size_Auto(4, "h") + Admin_System_Global:Size_Auto(45, "h") * Admin_SysCount - Admin_System_Global:Size_Auto(45, "h"))
                        Admin_Sys_Rating_Stars:SetImage("icon16/star.png")
                        function Admin_Sys_Rating_Stars:Paint(w, h) end
                    end
                end
                local Admin_Sys_BT_1 = vgui.Create( "DButton", Admin_Sys_FrameInfo_Scroll)
                Admin_Sys_BT_1:SetPos(Admin_System_Global:Size_Auto(321, "w"), Admin_System_Global:Size_Auto(45, "h") * Admin_SysCount - Admin_System_Global:Size_Auto(45, "h") + Admin_System_Global:Size_Auto(13, "h") )
                Admin_Sys_BT_1:SetSize(Admin_System_Global:Size_Auto(25, "w"), Admin_System_Global:Size_Auto(16, "h"))
                Admin_Sys_BT_1:SetText("")
                Admin_Sys_BT_1:SetIcon("icon16/cog.png")
                Admin_Sys_BT_1.Paint = function(self, w, h)

                    local ipr_Hover = self:IsHovered()
                    if (ipr_Hover) then
                        draw.RoundedBox(2, Admin_System_Global:Size_Auto(22, "w"), 0, w, h,  Color(192, 57, 43, 255))
                    end
                end
                Admin_Sys_BT_1.DoClick = function()
                    local Admin_SysPos_Derma = DermaMenu()
                    local Admin_SysPos_Optiona = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["ticket_copysteam"], function()
                        SetClipboardText( k )
                        LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"] )
                    end)
                    Admin_SysPos_Optiona:SetIcon("icon16/cut_red.png")
                    local Admin_SysPos_Optionb = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["ticket_copynom"], function()
                        SetClipboardText( v.Central_P )
                        LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"] )
                    end)
                    Admin_SysPos_Optionb:SetIcon("icon16/cut.png")
                    if Admin_System_Global.RateAdminDelete[LocalPlayer():GetUserGroup()] then
                        Admin_SysPos_Derma:AddSpacer()
                        local Admin_SysPos_Optionc = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["stats_deleterate"], function()
                            net.Start("Admin_Sys:DeleteRate")
                            net.WriteString(k)
                            net.WriteString(Admin_Syst_ValST)
                            net.SendToServer()
                            if IsValid(ipr_Stats.GuiS) then
                                ipr_Stats.GuiS:Remove()
                            end
                            if IsValid(ipr_Stats.GuiF) then
                                ipr_Stats.GuiF:Remove()
                            end
                        end)
                        Admin_SysPos_Optionc:SetIcon("icon16/exclamation.png")
                    end
                    Admin_SysPos_Derma:Open()
                end
            end
        end
    end
end

ipr_Stats.JsonT = false
ipr_Stats.JsonR = false
ipr_Stats.LData = false
local function Admin_Sys_Stats_Func(Admin_Sys_Json, Admin_Sys_Jsonv)
    if IsValid(ipr_Stats.GuiS) then
        return
    end

    ipr_Stats.GuiS = vgui.Create( "DFrame" )
    local Admin_Sys_Frame_Stats_Dlist = vgui.Create( "DListView", ipr_Stats.GuiS )
    local Admin_Sys_Frame_Stats_Dtext = vgui.Create( "DTextEntry", ipr_Stats.GuiS )
    local Admin_Sys_Frame_Stats_BT = vgui.Create( "DButton", ipr_Stats.GuiS  )
    local Admin_Sys_Frame_Stats_BT_1 = vgui.Create("DImageButton", ipr_Stats.GuiS )
    local Admin_Sys_Frame_Stats_BT_2 = vgui.Create("DButton", ipr_Stats.GuiS )
    local Admin_SysPos_Frame_BT_Sv1, Admin_SysPos_FrameB = vgui.Create("DImageButton", ipr_Stats.GuiS )

    ipr_Stats.GuiS:SetTitle( "" )
    ipr_Stats.GuiS:SetSize( Admin_System_Global:Size_Auto(370, "w"), Admin_System_Global:Size_Auto(325, "h") )
    ipr_Stats.GuiS:ShowCloseButton(false)
    ipr_Stats.GuiS:SetDraggable(true)
    ipr_Stats.GuiS:Center()
    ipr_Stats.GuiS:MakePopup()
    ipr_Stats.GuiS.Paint = function( self, w, h )
        Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 170 ), 8)
        draw.RoundedBox( 6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94))
        draw.DrawText( Admin_System_Global.lang["stats_cons"], "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(5, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( Admin_System_Global.lang["stats_indiq"], "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(35, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( Admin_System_Global.lang["stats_allratevw"], "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(140, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
    end

    Admin_Sys_Frame_Stats_Dtext:SetPos(Admin_System_Global:Size_Auto(60, "w"), Admin_System_Global:Size_Auto(65, "h"))
    Admin_Sys_Frame_Stats_Dtext:SetSize(Admin_System_Global:Size_Auto(250, "w"), Admin_System_Global:Size_Auto(25, "h"))
    Admin_Sys_Frame_Stats_Dtext:SetFont( "Admin_Sys_Font_T1" )
    Admin_Sys_Frame_Stats_Dtext:SetText( Admin_System_Global.lang["stats_indiq_text"] )
    Admin_Sys_Frame_Stats_Dtext:SetTextColor(Color(255,0,0,250))
    Admin_Sys_Frame_Stats_Dtext.OnGetFocus = function()
        if Admin_Sys_Frame_Stats_Dtext:GetText() == Admin_System_Global.lang["stats_indiq_text"] then
            Admin_Sys_Frame_Stats_Dtext:SetTextColor(Color(255,0,0,250))
            Admin_Sys_Frame_Stats_Dtext:SetText("")
        end
    end

    Admin_Sys_Frame_Stats_Dlist:Clear()
    Admin_SysAddList(Admin_Sys_Json, Admin_Sys_Jsonv, Admin_Sys_Frame_Stats_Dlist)
    local Admin_SysMaxVal, Admin_SysLines = 6, 0
    for nb, _ in pairs(Admin_Sys_Frame_Stats_Dlist:GetLines()) do
        Admin_SysLines = nb
    end
    for i = 1, Admin_SysMaxVal + 1 do
        if i > Admin_SysLines and i <= Admin_SysMaxVal + 1 then
            Admin_Sys_Frame_Stats_Dlist:AddLine("⁃","⁃","⁃","⁃","⁃","⁃")
        end
    end

    Admin_Sys_Frame_Stats_Dlist:SetPos(Admin_System_Global:Size_Auto(3, "w"), Admin_System_Global:Size_Auto(163, "h"))
    Admin_Sys_Frame_Stats_Dlist:SetSize(Admin_System_Global:Size_Auto(363, "w"), Admin_System_Global:Size_Auto(145, "h"))
    Admin_Sys_Frame_Stats_Dlist:AddColumn("Admin(s)"):SetWidth(Admin_System_Global:Size_Auto(70, "w"))
    Admin_Sys_Frame_Stats_Dlist:AddColumn("Connexion(s)"):SetWidth(Admin_System_Global:Size_Auto(95, "w"))
    Admin_Sys_Frame_Stats_Dlist:AddColumn("Ticket(s)")
    Admin_Sys_Frame_Stats_Dlist:AddColumn(Admin_System_Global.lang["stats_ratelist"]):SetWidth(Admin_System_Global:Size_Auto(50, "w"))
    Admin_Sys_Frame_Stats_Dlist:AddColumn(Admin_System_Global.lang["stats_rategrp"])
    Admin_Sys_Frame_Stats_Dlist:AddColumn("SteamID")
    Admin_Sys_Frame_Stats_Dlist:SetMultiSelect(false)
    function Admin_Sys_Frame_Stats_Dlist:Paint(w, h)
        draw.RoundedBox( 6, 0, 3, w, h, Color( 255, 255, 255, 100 ) )
    end
    Admin_Sys_Frame_Stats_Dlist.OnRowSelected = function( panel, rowIndex, row )
        if (row:GetValue(1) =="⁃") then
            return
        end
        local Admin_SysPos_Derma = DermaMenu()

        local Admin_SysPos_Optiona = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["ticket_copysteam"], function()
            SetClipboardText( row:GetValue(6) )
            LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"] )
        end)
        Admin_SysPos_Optiona:SetIcon("icon16/cut_red.png")

        local Admin_SysPos_Optionb = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["ticket_copynom"], function()
            SetClipboardText( row:GetValue(1) )
            LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"] )
        end)
        Admin_SysPos_Optionb:SetIcon("icon16/cut.png")
        Admin_SysPos_Derma:AddSpacer()

        local Admin_SysPos_Optionc = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["stats_viewratecom"], function()
            if IsValid(ipr_Stats.GuiF) then
                ipr_Stats.GuiF:Remove()
            end
            Admin_Syst_StatsSec_Func(ipr_Stats.GuiS, row:GetValue(1), Admin_Sys_Jsonv[row:GetValue(6)], row:GetValue(4), row:GetValue(6))
        end)
        Admin_SysPos_Optionc:SetIcon("icon16/table_sort.png")
        Admin_SysPos_Derma:Open()
    end

    Admin_SysPos_Frame_BT_Sv1:SetPos(Admin_System_Global:Size_Auto(7, "w"),Admin_System_Global:Size_Auto(4, "h"))
    Admin_SysPos_Frame_BT_Sv1:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
    Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/layers.png" )
    function Admin_SysPos_Frame_BT_Sv1:Paint(w,h) end
    Admin_SysPos_Frame_BT_Sv1.DoClick = function()
        ipr_Stats.GuiS:SetAlpha(50)
        Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/monitor.png" )
        ipr_Stats.GuiS:SetMouseInputEnabled(false)
        ipr_Stats.GuiS:SetKeyboardInputEnabled(false)

        if IsValid(ipr_Stats.GuiF) then
            ipr_Stats.GuiF:SetAlpha(50)
            ipr_Stats.GuiF:SetMouseInputEnabled(false)
            ipr_Stats.GuiF:SetKeyboardInputEnabled(false)
        end
        gui.EnableScreenClicker(false)

        timer.Simple(1, function()
            if not IsValid(ipr_Stats.GuiS) then
                return
            end
            local x, y = ipr_Stats.GuiS:GetPos()
            Admin_SysPos_FrameB = vgui.Create( "DFrame" )
            Admin_SysPos_FrameB:SetTitle( "" )
            Admin_SysPos_FrameB:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(315, "h"))
            Admin_SysPos_FrameB:SetMouseInputEnabled(true)
            Admin_SysPos_FrameB:ShowCloseButton(false)
            Admin_SysPos_FrameB:SetPos(x, y)

            Admin_SysPos_FrameB.Think = function()
                if Admin_SysPos_FrameB:IsHovered() then
                    if IsValid(ipr_Stats.GuiS) then
                        ipr_Stats.GuiS:SetAlpha(255)
                        ipr_Stats.GuiS:SetMouseInputEnabled(true)
                        ipr_Stats.GuiS:SetKeyboardInputEnabled(true)
                        if IsValid(ipr_Stats.GuiF) then
                            ipr_Stats.GuiF:SetAlpha(255)
                            ipr_Stats.GuiF:SetMouseInputEnabled(true)
                            ipr_Stats.GuiF:SetKeyboardInputEnabled(true)
                        end
                        gui.EnableScreenClicker(true)
                        Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/layers.png" )
                    end
                    
                    Admin_SysPos_FrameB:Remove()
                end
            end
            Admin_SysPos_FrameB.Paint = function(self, w, h) end
        end)
    end

    local Admin_Sys_Lerp_, Admin_Sys_Lerp_An_, Admin_SysScanSteamID = 0, 0.05
    Admin_Sys_Frame_Stats_BT:SetPos(Admin_System_Global:Size_Auto(60, "w"), Admin_System_Global:Size_Auto(105, "h"))
    Admin_Sys_Frame_Stats_BT:SetSize(Admin_System_Global:Size_Auto(115, "w"), Admin_System_Global:Size_Auto(25, "h"))
    Admin_Sys_Frame_Stats_BT:SetText("")
    Admin_Sys_Frame_Stats_BT:SetIcon("icon16/zoom_in.png")
    Admin_Sys_Frame_Stats_BT.Paint = function( self, w, h )
        draw.RoundedBox( 3, Admin_System_Global:Size_Auto(0, "w"), Admin_System_Global:Size_Auto(0, "h"), w, h, Color(52,73,94))

        local ipr_Hover = self:IsHovered()
        if (ipr_Hover) then
            Admin_Sys_Lerp_ = Lerp(Admin_Sys_Lerp_An_, Admin_Sys_Lerp_, w - 4)
        else
            Admin_Sys_Lerp_ = 0
        end
        draw.RoundedBox(6, Admin_System_Global:Size_Auto(2, "w"), Admin_System_Global:Size_Auto(0, "h"), Admin_Sys_Lerp_, 1, Color(	41, 128, 185))
        draw.DrawText(Admin_System_Global.lang["stats_scan"], "Admin_Sys_Font_T1", w /2 + Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(255,255,255, 280), TEXT_ALIGN_CENTER )
    end
    Admin_Sys_Frame_Stats_BT.DoClick = function()
        local Admin_Sys_Value = Admin_Sys_Frame_Stats_Dtext:GetValue()

        if string.sub(Admin_Sys_Value, 1, 5) == ipr_Stats.PString and string.len(Admin_Sys_Value) > 0 and Admin_Sys_Value ~= "" and Admin_Sys_Value ~= " " then
            local Admin_Sys_FindClass_Ply = ents.FindByClass("player")

            if string.len(Admin_Sys_Value) <= 6 then
                LocalPlayer():ChatPrint( "Veuillez indiquer un SteamID !" )
                Admin_Sys_Frame_Stats_Dtext:SetText(Admin_System_Global.lang["stats_indiq_text"])
                return
            end
            if Admin_Sys_Json and (Admin_Sys_Json[Admin_Sys_Value] or Admin_Sys_Json[1]) then
                if (Admin_SysScanSteamID and Admin_SysScanSteamID == Admin_Sys_Value) then
                    LocalPlayer():ChatPrint( "Ce SteamID a déjà été scanné !" )
                    return
                end
                Admin_Sys_Frame_Stats_Dlist:Clear()
                local Admin_SysSqlite
                for k, v in pairs(Admin_Sys_Json) do
                    if (v.Central_SteamID == Admin_Sys_Value) then
                        Admin_SysSqlite = tonumber(k)
                    end
                end
                Admin_SysSqlite = isnumber(Admin_SysSqlite) and Admin_SysSqlite or Admin_Sys_Value
                Admin_Sys_Frame_Stats_Dlist:AddLine(Admin_Sys_Json[Admin_SysSqlite].Central_Admin, Admin_System_Global.lang["stats_indiq_i"].. "" ..Admin_System_Global:TradTime(string.NiceTime(os.time() - Admin_Sys_Json[Admin_SysSqlite].Central_Horodatage)), Admin_Sys_Json[Admin_SysSqlite].Central_NumbTicket or "aucun", string.find( tostring(d), ipr_Stats.PString ) and Admin_Sys_Jsonv[d] and Admin_Sys_Jsonv[d].Admin_Sys_N.. "/5" or Admin_Sys_Jsonv[Admin_Sys_Value] and Admin_Sys_Jsonv[Admin_Sys_Value].Admin_Sys_N.. "/5" or "-/5", Admin_Sys_Json[Admin_SysSqlite].Central_G or Admin_Sys_Json[Admin_SysSqlite].Central_Grp or "Inconnu", not isnumber(d) and d or Admin_Sys_Value or "Inconnu" )
                
                LocalPlayer():ChatPrint( Admin_System_Global.lang["stats_scan_text"].. "" ..Admin_Sys_Value.. "" ..Admin_System_Global.lang["stats_scan_trv"] )
                Admin_SysScanSteamID = Admin_Sys_Value
            else
                LocalPlayer():ChatPrint( Admin_System_Global.lang["stats_scannoval"] )
            end

            Admin_Sys_UpdateDlist(Admin_Sys_Frame_Stats_Dlist)
        end
    end

    local Admin_Sys_Lerp_x, Admin_Sys_Lerp_An_x = 0, 0.05
    Admin_Sys_Frame_Stats_BT_2:SetPos(Admin_System_Global:Size_Auto(195, "w"), Admin_System_Global:Size_Auto(105, "h"))
    Admin_Sys_Frame_Stats_BT_2:SetSize(Admin_System_Global:Size_Auto(115, "w"), Admin_System_Global:Size_Auto(25, "h"))
    Admin_Sys_Frame_Stats_BT_2:SetText("")
    Admin_Sys_Frame_Stats_BT_2:SetIcon("icon16/chart_pie.png")
    Admin_Sys_Frame_Stats_BT_2.Paint = function(self, w, h)
        draw.RoundedBox(3, Admin_System_Global:Size_Auto(0, "w"), Admin_System_Global:Size_Auto(0, "h"), w, h, Color(52,73,94))
        
        local ipr_Hover = self:IsHovered()
        if (ipr_Hover) then
            Admin_Sys_Lerp_x = Lerp(Admin_Sys_Lerp_An_x, Admin_Sys_Lerp_x, w - Admin_System_Global:Size_Auto(4, "w"))
        else
            Admin_Sys_Lerp_x = 0
        end
        draw.RoundedBox(6, Admin_System_Global:Size_Auto(2, "w"), Admin_System_Global:Size_Auto(0, "h"), Admin_Sys_Lerp_x, 1, Color(	41, 128, 185))
        draw.DrawText(Admin_System_Global.lang["stats_scan_aff"], "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(255,255,255, 280), TEXT_ALIGN_CENTER )
    end
    Admin_Sys_Frame_Stats_BT_2.DoClick = function()
        local Admin_Sys_Value = Admin_Sys_Frame_Stats_Dtext:GetValue()
        Admin_SysScanSteamID = nil

        Admin_Sys_Frame_Stats_Dlist:Clear()

        Admin_SysAddList(Admin_Sys_Json, Admin_Sys_Jsonv, Admin_Sys_Frame_Stats_Dlist)
        Admin_Sys_UpdateDlist(Admin_Sys_Frame_Stats_Dlist)
    end

    Admin_Sys_Frame_Stats_BT_1:SetPos(Admin_System_Global:Size_Auto(350, "w"),Admin_System_Global:Size_Auto(5, "h"))
    Admin_Sys_Frame_Stats_BT_1:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
    Admin_Sys_Frame_Stats_BT_1:SetImage( "icon16/cross.png" )
    function Admin_Sys_Frame_Stats_BT_1:Paint(w,h)
    end
    Admin_Sys_Frame_Stats_BT_1.DoClick = function()
        if IsValid(ipr_Stats.GuiF) then
            ipr_Stats.GuiF:Remove()
        end

        ipr_Stats.GuiS:Remove()
    end

    Admin_Sys_UpdateDlist(Admin_Sys_Frame_Stats_Dlist)
    for k, v in pairs(Admin_Sys_Frame_Stats_Dlist.Columns) do
        Admin_Sys_Frame_Stats_Dlist.Columns[k].Header:SetTextColor(Color(236, 240, 241))
        Admin_Sys_Frame_Stats_Dlist.Columns[k].Header:SetFont("Admin_Sys_Font_T1")
        Admin_Sys_Frame_Stats_Dlist.Columns[k].Header.Paint = function(self, w, h) draw.RoundedBox( 6, 0, 0, w, h, Color(52,73,94)) end
    end

    Admin_Sys_Frame_Stats_Dlist:GetChildren()[8].btnGrip.Paint = function(self, w, h) draw.RoundedBox( 3, 0, 0, w, h, Color(52,73,94)) end
    Admin_Sys_Frame_Stats_Dlist:GetChildren()[8].btnUp.Paint = function(self, w, h) draw.RoundedBox( 5, 0, 0, w, h, Color(52,73,94)) end
    Admin_Sys_Frame_Stats_Dlist:GetChildren()[8].btnDown.Paint = function(self, w, h) draw.RoundedBox( 5, 0, 0, w, h, Color(52,73,94)) end
    Admin_Sys_Frame_Stats_Dlist:GetChildren()[8].Paint = function() end
    Admin_Sys_Frame_Stats_Dlist:GetChildren()[8]:SetHideButtons( true )

    Admin_Sys_Frame_Stats_Dlist.Paint = function() end
end

local function Admin_Sys_Stats_Primary()
    if (IsValid(ipr_Stats.LData) and ipr.value.sv == 2) or IsValid(ipr_Stats.GuiS) then
        return
    end

    local Admin_Sys_Int = net.ReadUInt(32)
    local Admin_Sys_Data = net.ReadData( Admin_Sys_Int )
    local Admin_Sys_Decompress = Admin_Sys_Data and util.Decompress(Admin_Sys_Data)
    local Admin_Sys_Json = Admin_Sys_Decompress and util.JSONToTable( Admin_Sys_Decompress ) or {}

    if istable(Admin_Sys_Json) then
        ipr.value.sv = ipr.value.sv + 1

        if (ipr.value.sv == 1) then
            ipr_Stats.JsonT = Admin_Sys_Json
            ipr.value.ct = ipr.value.ct + table.Count(ipr_Stats.JsonT)
        else
            ipr_Stats.JsonR = Admin_Sys_Json
            ipr.value.cr = ipr.value.cr + table.Count(ipr_Stats.JsonR)
        end
    end
    if IsValid(ipr_Stats.LData) then
        return
    end
    
    ipr_Stats.LData = vgui.Create( "DFrame" )
    timer.Create(ipr.timer.rm, 15, 1, function()
        if IsValid(ipr_Stats.LData) then
            Admin_Sys_UpdateValue()
            ipr_Stats.LData:Remove()
        end
    end)

    local Admin_Sys_LoadDataFrame_BT = vgui.Create( "DButton", ipr_Stats.LData  )
    local Admin_SysLoadPr, Admin_SysCur = 0, CurTime() + 1
    local Admin_SysLoadRate, Admin_SysLoadStat = "...", "..."

    ipr_Stats.LData:SetSize( Admin_System_Global:Size_Auto(300, "w"), Admin_System_Global:Size_Auto(125, "h") )
    ipr_Stats.LData:SetDraggable(true)
    ipr_Stats.LData:ShowCloseButton(false)
    ipr_Stats.LData:SetTitle( "" )
    ipr_Stats.LData:Center()
    ipr_Stats.LData:MakePopup()
    ipr_Stats.LData.Paint = function( self, w, h )
        Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 170 ), 2)

        draw.RoundedBox(6, 10, 35, w-20, 80, Color(52,73,94, 120))
        draw.RoundedBox(6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94))
        draw.RoundedBox(6, 4, 25, Admin_Sys_LerpAnim(ipr.value.sn, 34.1, "loadrd"), 1, Admin_SysLoadPr <= 5 and Color(255,0,0, 150) or Color(39, 174, 96))

        draw.DrawText(Admin_System_Global.lang["stats_loadwt"].. "" ..Admin_Sys_LerpAnim(ipr.value.sn, 100, "load").. "%", "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(5, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
        draw.DrawText("Status : ", "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(40, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
        draw.DrawText(Admin_SysLoadStat, Admin_SysLoadPr <= 5 and "Admin_Sys_Font_T1" or "Admin_Sys_Font_T4", w/2, Admin_SysLoadPr <= 5 and Admin_System_Global:Size_Auto(90, "h") or Admin_System_Global:Size_Auto(75, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
        draw.DrawText(Admin_SysLoadPr <= 5 and Admin_SysLoadRate or "", "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(65, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER)
    end

    timer.Create(ipr.timer.dt, 0, 0, function()
        local AdminSysCurThink = CurTime()
        if (Admin_SysLoadPr >= 2) and (ipr.value.sn == 0) then
            ipr.value.sn = 50
        elseif (Admin_SysLoadPr >= 4) and (ipr.value.sn == 50) then
            ipr.value.sn = 100
        end
        if (Admin_SysLoadPr <= 0) then
            Admin_SysLoadRate = Admin_System_Global.lang["stats_loadratingtbl"].. ""..Admin_System_Global:Admin_Sys_TicketDot()
            Admin_Sys_LoadDataFrame_BT:SetImage( "icon16/arrow_refresh.png" )
        end
        if (AdminSysCurThink > Admin_SysCur + 0.5) and (ipr.value.sv >= 1) then
            Admin_SysLoadRate = Admin_System_Global.lang["stats_endratingtbl"]
            Admin_SysLoadPr = 2
        end
        if (Admin_SysLoadPr >= 0) and (Admin_SysLoadPr <= 2) then
            Admin_SysLoadStat = Admin_System_Global.lang["stats_loadstatstbl"].. ""..Admin_System_Global:Admin_Sys_TicketDot()
        end
        if (ipr.value.sv >= 2) then
            Admin_SysLoadStat = Admin_System_Global.lang["stats_endstatstbl"]
            Admin_Sys_LoadDataFrame_BT:SetImage( "icon16/cross.png" )
            Admin_SysLoadPr = 4
        end
        if (Admin_SysLoadPr >= 3) and (AdminSysCurThink > Admin_SysCur + 2) then
            Admin_SysLoadStat = Admin_System_Global.lang["stats_opfound"].. "" ..ipr.value.ct..  " logs (global stats)"
            Admin_SysLoadRate = Admin_System_Global.lang["stats_opfound"].. "" ..ipr.value.cr.. " logs (evaluations)"
            Admin_SysLoadPr = 5
        end
        if (Admin_SysLoadPr >= 5) and (AdminSysCurThink > Admin_SysCur + 4) then
            Admin_SysLoadStat = Admin_System_Global.lang["stats_oplogs"].. ""..Admin_System_Global:Admin_Sys_TicketDot()
            Admin_SysLoadPr = 6
        end

        if (Admin_SysLoadPr >= 6) and (AdminSysCurThink > Admin_SysCur + 5) then
            Admin_Sys_Stats_Func(ipr_Stats.JsonT or {}, ipr_Stats.JsonR or {})
            Admin_Sys_UpdateValue()

            timer.Remove(ipr.timer.dt)
            ipr_Stats.LData:Remove()
        end
    end)

    Admin_Sys_LoadDataFrame_BT:SetPos(Admin_System_Global:Size_Auto(277, "w"),Admin_System_Global:Size_Auto(5, "h"))
    Admin_Sys_LoadDataFrame_BT:SetSize(Admin_System_Global:Size_Auto(19, "w"),Admin_System_Global:Size_Auto(19, "h"))
    Admin_Sys_LoadDataFrame_BT:SetImage( "icon16/cross.png" )
    function Admin_Sys_LoadDataFrame_BT:Paint(w,h) end
    Admin_Sys_LoadDataFrame_BT.DoClick = function()
        if (Admin_SysLoadPr < 4) then
            return
        end
        Admin_Sys_UpdateValue()
        
        if IsValid(ipr_Stats.LData) then
            ipr_Stats.LData:Remove()
        end
    end
end
net.Receive("Admin_Sys:Log", Admin_Sys_Stats_Primary)