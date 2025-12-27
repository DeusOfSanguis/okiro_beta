---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

do
    local ipr_timestamp = {["day"] = "jour", ["year"] = "année", ["week"] = "semaine", ["hour"] = "heure", ["second"] = "seconde"}
    function Admin_System_Global:TradTime(t)
        if (Admin_System_Global.Mode_Lang == "fr") then
            for k, v in pairs(ipr_timestamp) do
                if (string.find(t, k)) then
                    return string.Replace(t, k, v)
                end
            end
        end

        return t
    end

    local ipr_dot_tc, ipr_dot_c = 0, 0
    function Admin_System_Global:Admin_Sys_TicketDot()
        local ipr_dot_tim = ipr_dot_c - CurTime()

        if (ipr_dot_tim < 0) then
            ipr_dot_tc = ipr_dot_tc + 1

            if (ipr_dot_tc > 3) then
                ipr_dot_tc = 0
            end
            ipr_dot_c = CurTime() + math.random(0.2, 2)
        end

        local ipr_dot_rt = ""
        for i = 1, ipr_dot_tc do
            ipr_dot_rt = ipr_dot_rt .. "."
        end

        return ipr_dot_rt
    end

    local Admin_Sys_BlurMat = Material("pp/blurscreen")
    function Admin_System_Global:Gui_Blur(Admin_Sys_Frame, Admin_Sys_Float, Admin_Sys_Col, Admin_Sys_Bord)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(Admin_Sys_BlurMat)

        local ipr_Posx, ipr_Posy = Admin_Sys_Frame:LocalToScreen(0, 0)
        Admin_Sys_BlurMat:SetInt("$blur", 2)
        Admin_Sys_BlurMat:Recompute()
        render.UpdateScreenEffectTexture()

        local ipr_w, ipr_h = ScrW(), ScrH()
        surface.DrawTexturedRect(ipr_Posx * -1, ipr_Posy * -1, ipr_w, ipr_h)
        local ipr_Gwide, ipr_GTall = Admin_Sys_Frame:GetWide(), Admin_Sys_Frame:GetTall()
        draw.RoundedBoxEx(Admin_Sys_Bord, 0, 0, ipr_Gwide, ipr_GTall, Admin_Sys_Col, true, true, true, true)
    end
end

function Admin_System_Global:Size_Auto(ipr_size, ipr_str, ipr_disabled)
    if not Admin_System_Global.Admin_System_AutoRdm then
        return ipr_size
    end
    
    return (ipr_str == "w") and (ipr_size / 1920) * ScrW() or (ipr_size / 1080) * ScrH()
end

Admin_System_Global.Ipr_TkGen = {
    {Admin_Sys_String = Admin_System_Global.lang["ticket_teleporto"],  Admin_Sys_Func = function(Admin_Sys_Ply)
        local Admin_SysPos_Derma = DermaMenu()
        local Admin_SysPos_Option = Admin_SysPos_Derma:AddOption("Téléporter vers le joueur", function()
            net.Start("Admin_Sys:TP_Reset")
            net.WriteUInt(3, 4)
            net.WriteEntity(Admin_Sys_Ply)
            net.SendToServer()
        end)
        Admin_SysPos_Option:SetIcon("icon16/group.png")
        local Admin_SysPos_Sub, Admin_SysPos_Parent = Admin_SysPos_Derma:AddSubMenu("Téléporter vers le(s) véhicule(s) du joueur")
        Admin_SysPos_Parent:SetIcon("icon16/car.png")
        local Admin_Sys_FindClass_Veh, Admin_Sys_Valide, Admin_SysPos_Option_1 = ents.FindByClass("prop_vehicle_jeep"), false, nil
        for _, v in ipairs(Admin_Sys_FindClass_Veh) do
            local Admin_Sys_v, Admin_Sys_x = v.CPPIGetOwner and v:CPPIGetOwner()
            if IsValid(Admin_Sys_v) and (Admin_Sys_v == Admin_Sys_Ply) then
                local c = v:GetVehicleClass()
                local t = list.Get("Vehicles")[c]
                Admin_SysPos_Option_1 = Admin_SysPos_Sub:AddOption("Nom du véhicule : " ..(istable(t) and t.Name or c or "Nom Inconnu").. "- Distance : " ..math.Round(LocalPlayer():GetPos():Distance(v:GetPos())).. "m", function()
                    net.Start("Admin_Sys:TP_Reset")
                    net.WriteUInt(3, 4)
                    net.WriteEntity(v)
                    net.SendToServer()
                end)
                Admin_Sys_Valide = true
                Admin_SysPos_Option_1:SetIcon("icon16/arrow_right.png")
            end
        end
        if not Admin_Sys_Valide then
            Admin_SysPos_Option_1 = Admin_SysPos_Sub:AddOption("Aucun véhicule")
        end
        Admin_SysPos_Derma:Open()
    end},

    {Admin_Sys_String = Admin_System_Global.lang["ticket_ret"], Admin_Sys_Func = function(Admin_Sys_Ply)
        net.Start("Admin_Sys:TP_Reset")
        net.WriteUInt(1, 4)
        net.WriteEntity(Admin_Sys_Ply)
        net.SendToServer()
    end},

    {Admin_Sys_String = Admin_System_Global.lang["ticket_notif"], Admin_Sys_Func = function(Admin_Sys_Ply)
        local Admin_Sys_DermaMenu = DermaMenu()

        for i = 1, #Admin_System_Global.Notif_Gen do
            local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption(Admin_System_Global.Notif_Gen[i].Name_Notification, function()
                net.Start("Admin_Sys:Notif")
                net.WriteEntity(Admin_Sys_Ply)
                net.WriteUInt(i, 8)
                net.SendToServer()
            end)
        end
        Admin_Sys_DermaMenu:Open()
    end},

    {Admin_Sys_String = Admin_System_Global.lang["ticket_tpzone"], Admin_Sys_Func = function(Admin_Sys_Ply)
        net.Start("Admin_Sys:ZNAdmin")
        net.WriteBool(true)
        net.WriteEntity(Admin_Sys_Ply)
        net.WriteUInt(1, 4)
        net.SendToServer()
    end},

    {Admin_Sys_String = Admin_System_Global.lang["ticket_tpatrj"], Admin_Sys_Func = function(Admin_Sys_Ply)
        local Admin_Sys_DermaMenu = DermaMenu()
        local Admin_Sys_Table_Derma = {}
        if (#player.GetAll() <= 1) then
            LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_teleportnotif"] )
            return
        end
        for _, player in ipairs(ents.FindByClass( "player" )) do
            if (player == LocalPlayer()) then
                continue
            end
            Admin_Sys_Table_Derma[#Admin_Sys_Table_Derma + 1] = {Admin_Sys_Ply = player, Admin_Sys_Name = player:Nick()}
        end
        local Admin_Sys_SortTable = function(x, z)
            return x.Admin_Sys_Name > z.Admin_Sys_Name
        end
        table.sort(Admin_Sys_Table_Derma, Admin_Sys_SortTable)
        for _, v in pairs(Admin_Sys_Table_Derma) do
            if (v.Admin_Sys_Ply == Admin_Sys_Ply) then
                v.Admin_Sys_Name = v.Admin_Sys_Name.. "" ..Admin_System_Global.lang["ticket_creatorown"]
            end
            local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption(v.Admin_Sys_Name, function()
                net.Start("Admin_Sys:ZNAdmin")
                net.WriteBool(false)
                net.WriteEntity(v.Admin_Sys_Ply) 
                net.WriteUInt(2, 4)
                net.WriteEntity(Admin_Sys_Ply)
                net.SendToServer()
                Admin_Sys_DermaMenu:Remove()
            end)
        end
        Admin_Sys_DermaMenu:Open()
    end},

    {Admin_Sys_String = Admin_System_Global.lang["ticket_respawn"], Admin_Sys_Func = function(Admin_Sys_Ply)
        local Admin_Sys_DermaMenu = DermaMenu()
        local Admin_Sys_Table_Derma = {}
        for _, player in pairs(ents.FindByClass("player")) do
            if (player == LocalPlayer()) or player:Alive() then
               continue
            end
            Admin_Sys_Table_Derma[#Admin_Sys_Table_Derma + 1] = {Admin_Sys_Ply = player, Admin_Sys_Name = player:Nick()}
        end
        if (#Admin_Sys_Table_Derma <= 0) then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["ticket_respawnnotif"])
            return
        end
        local Admin_Sys_SortTable = function(x, z)
            return x.Admin_Sys_Name > z.Admin_Sys_Name
        end
        table.sort(Admin_Sys_Table_Derma, Admin_Sys_SortTable)
        for _, v in pairs(Admin_Sys_Table_Derma) do
            if not v.Admin_Sys_Ply:IsPlayer() or v.Admin_Sys_Ply:Alive() then
               continue
            end
            if (v.Admin_Sys_Ply == Admin_Sys_Ply) then
                v.Admin_Sys_Name = v.Admin_Sys_Name.. "" ..Admin_System_Global.lang["ticket_creatorown"]
            else
                v.Admin_Sys_Name = v.Admin_Sys_Name.. "" ..Admin_System_Global.lang["huddeath"]
            end
            local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption(v.Admin_Sys_Name, function()
                net.Start("Admin_Sys:Action")
                net.WriteUInt(5, 4)
                net.WriteEntity(v.Admin_Sys_Ply)
                net.WriteBool(false)
                net.SendToServer()

                Admin_Sys_DermaMenu:Remove()
            end)
        end
        Admin_Sys_DermaMenu:Open()
    end},

    {Admin_Sys_String = Admin_System_Global.lang["ticket_spec"], Admin_Sys_Func = function(Admin_Sys_Ply)
        net.Start("FSpectateTarget")
        net.WriteEntity(Admin_Sys_Ply)
        net.SendToServer()
    end},
    
    {Admin_Sys_String = Admin_System_Global.lang["ticket_copy"], Admin_Sys_Func = function(Admin_Sys_Ply)
        local Admin_Sys_DermaMenu = DermaMenu()

        local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption(Admin_System_Global.lang["ticket_copysteam"], function()
            SetClipboardText(Admin_Sys_Ply:SteamID())
            LocalPlayer():PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"])
        end)
        local Admin_Sys_AddOption_1 = Admin_Sys_DermaMenu:AddOption(Admin_System_Global.lang["ticket_copynom"], function()
            SetClipboardText(Admin_Sys_Ply:Nick())
            LocalPlayer():PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["ticket_copynom_t"])
        end)
        Admin_Sys_DermaMenu:Open()
    end}
}

---- Load fonts
local function ipr_font_size(font_size)
    local ipr_height, ipr_base_h = ScrH(), 1080
    font_size = font_size * (ipr_height / ipr_base_h)
    if (ipr_height <= 600) then
        font_size = 13
    end

    return font_size
end

local function ipr_create_font()
    local ipr_font_create = {{ipr_n = "Admin_Sys_Font_T1", ipr_f = "Lexend Medium", ipr_s = 23, weight = 300}, {ipr_n = "Admin_Sys_Font_T2", ipr_f = "Lexend Medium", ipr_s = 15, ipr_w = 300}, {ipr_n = "Admin_Sys_Font_T3", ipr_f = "Lexend Medium", ipr_s = 17, ipr_w = 100}, {ipr_n = "Admin_Sys_Font_T4", ipr_f = "Lexend", ipr_s = 22, ipr_w = 1}, {ipr_n = "Admin_Sys_Font_T6", ipr_f = "Lexend", ipr_s = 18, ipr_w = 1}}

    for _, v in pairs(ipr_font_create) do
        surface.CreateFont(v.ipr_n, {
            font = v.ipr_f,
            size = Admin_System_Global.Admin_System_AutoRdm and ipr_font_size(v.ipr_s) or v.ipr_s,
            weight = v.ipr_w,
            antialias = true
        })
    end
end

local function ipr_resp_onscreen(oldWidth, oldHeight)
    local ipr_w = ScrH()

    if (ipr_w ~= oldHeight) then
        ipr_create_font()
    end 
end

ipr_create_font()
hook.Add("OnScreenSizeChanged", "ipr_resp_onscreen", ipr_resp_onscreen)