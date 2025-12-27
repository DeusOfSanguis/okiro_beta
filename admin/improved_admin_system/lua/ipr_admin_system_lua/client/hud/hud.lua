---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

local ipr = {}
ipr.tnotif = {}
ipr.notif_delay = 5
ipr.color = {
  white = Color(236, 240, 241),
  green = Color(76, 209, 55),
  blue = Color(52, 73, 94),
  orange = Color(211, 84, 0),
}
ipr.font = "Admin_Sys_Font_T1"
ipr.arrow = "➔ "
ipr.target = "♦"
ipr.reso = {
  scrw = ScrW(),
  scrh = ScrH(),
}
ipr.dist_ply = 500000
ipr.dist_veh = 1000000
ipr.dist_gen = 100000000
ipr.engine = (engine.ActiveGamemode() == "darkrp")

local function ipr_OnScreen()
    ipr.reso.scrw, ipr.reso.scrh = ScrW(), ScrH()
    if not Admin_System_Global.Mode_Bool and not Admin_System_Global.SysStreamerMod then
        return
    end

    ipr.phud = {
        {"❘",
            w = {
                ["droite"] = ipr.reso.scrw - 100,
                ["gauche"] = 125,
                ["milieu"] = ipr.reso.scrw / 2,
            },
            h = {
                ["bas"] = ipr.reso.scrh - 50,
                ["milieu"] = ipr.reso.scrh / 2 - 35,
                ["haut"] = 10,
            },
        },
        {"Cloak",
            w = {
                ["droite"] = ipr.reso.scrw - 170,
                ["gauche"] = 55,
                ["milieu"] = ipr.reso.scrw / 2 - 75,
            },
            h = {
                ["bas"] = ipr.reso.scrh - 28,
                ["milieu"] = ipr.reso.scrh / 2 - 35,
                ["haut"] = 35,
            },
        },
        {"Godmode",
            w = {
                ["droite"] = ipr.reso.scrw - 100,
                ["gauche"] = 120,
                ["milieu"] = ipr.reso.scrw / 2,
            },
            h = {
                ["bas"] = ipr.reso.scrh - 28,
                ["milieu"] = ipr.reso.scrh / 2,
                ["haut"] = 35,
            },
        },
        {"Noclip",
            w = {
                ["droite"] = ipr.reso.scrw - 35,
                ["gauche"] = 185,
                ["milieu"] = ipr.reso.scrw / 2 + 77,
            },
            h = {
                ["bas"] = ipr.reso.scrh - 28,
                ["milieu"] = ipr.reso.scrh / 2,
                ["haut"] = 35,
            },
        },
        {"Mode streamer activé",
            w = {
                ["droite"] = 100,
                ["gauche"] = 115,
                ["milieu"] = ipr.reso.scrw / 2 - 10,
            },
            h = {
                ["bas"] = ipr.reso.scrh - 15,
                ["milieu"] = ipr.reso.scrh / 2 + 15,
                ["haut"] = 55,
            },
        },
    }
end
ipr_OnScreen()

local ipr_Conf = Admin_System_Global
local function ipr_DrawInfoHUD()
    if not Admin_System_Global.Mode_HUD then
        return
    end
    local ipr_Player = LocalPlayer()
    if not ipr_Player:AdminStatusCheck() then
        return
    end

    local ipr_Cur = CurTime()
    local ipr_Abs = math.abs(math.sin(ipr_Cur * 1.5) * 170)
    if (ipr_Conf.Mode_Bool) then
        draw.DrawText(ipr_Conf.lang["adminmode_text"], ipr.font, ipr.phud[1].w[ipr_Conf.Mode_Wide], ipr.phud[1].h[ipr_Conf.Mode_Height], ipr.color.white, TEXT_ALIGN_CENTER)
        draw.DrawText(ipr.phud[2][1], ipr.font, ipr.phud[2].w[ipr_Conf.Mode_Wide], ipr.phud[2].h[ipr_Conf.Mode_Height], (ipr_Conf.SysCloakStatus) and (ipr.color.green) or Color(ipr_Abs, 0, 0), TEXT_ALIGN_CENTER)
        draw.DrawText(ipr.phud[3][1], ipr.font,  ipr.phud[3].w[ipr_Conf.Mode_Wide], ipr.phud[3].h[ipr_Conf.Mode_Height],  (ipr_Player:HasGodMode() == true) and (ipr.color.green) or Color(ipr_Abs, 0, 0), TEXT_ALIGN_CENTER)
        draw.DrawText(ipr.phud[4][1], ipr.font, ipr.phud[4].w[ipr_Conf.Mode_Wide], ipr.phud[4].h[ipr_Conf.Mode_Height], (ipr_Player:GetMoveType() == MOVETYPE_NOCLIP) and (ipr.color.green) or  Color(ipr_Abs, 0, 0), TEXT_ALIGN_CENTER)
    end
    if (ipr_Conf.SysStreamerMod) then
        draw.DrawText(ipr.phud[5][1], ipr.font, ipr.phud[5].w[ipr_Conf.Mode_Wide], ipr.phud[5].h[ipr_Conf.Mode_Height], (ipr_Conf.SysStreamerMod) and (ipr.color.green) or Color(ipr_Abs, 0, 0), TEXT_ALIGN_CENTER)
    end

    local ipr_Ppos, ipr_ClassPly = ipr_Player:GetPos(), player.GetAll()
    for _, v in ipairs(ipr_ClassPly) do
        if not IsValid(v) then
           continue
        end
        if (v == ipr_Player) or ((ipr_Conf.Mode_Bypass_Player) and (ipr_Conf.Mode_Bypass[v:GetUserGroup()])) then
           continue
        end
        local Admin_Sys_PPos = v:EyePos()
        Admin_Sys_PPos = Admin_Sys_PPos:ToScreen()
        if not Admin_Sys_PPos.visible then
           continue
        end

        local ipr_PlayerName = v:GetName()
        local ipr_PlayerInVehicle = v:InVehicle()
        draw.DrawText(ipr.target, ipr.font, Admin_Sys_PPos.x-2 , not ipr_PlayerInVehicle and Admin_Sys_PPos.y - 30 or Admin_Sys_PPos.y, Color(0, 0, ipr_Abs), TEXT_ALIGN_CENTER)
        
        local ipr_Psqr = v:GetPos():DistToSqr(ipr_Ppos)
        if (ipr_Psqr < ipr.dist_gen) then
            draw.SimpleTextOutlined(ipr_PlayerName, ipr.font, Admin_Sys_PPos.x , not ipr_PlayerInVehicle and Admin_Sys_PPos.y - 40 or Admin_Sys_PPos.y - 3, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
        end
    
        if (ipr_Psqr > (not ipr_PlayerInVehicle and ipr.dist_ply or ipr.dist_veh)) then
            continue
        end
        draw.SimpleTextOutlined(team.GetName(v:Team()), ipr.font, Admin_Sys_PPos.x , not ipr_PlayerInVehicle and Admin_Sys_PPos.y - 72 or Admin_Sys_PPos.y - 20, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
        
        if (ipr_PlayerInVehicle) then
            local Admin_Sys_C = (v:GetVehicle():GetClass() == "prop_vehicle_jeep") and "Conducteur" or "Passager"
            draw.SimpleTextOutlined(Admin_Sys_C, ipr.font, Admin_Sys_PPos.x , Admin_Sys_PPos.y - 37, Admin_Sys_C and ipr.color.orange or ipr.color.blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
            continue
        end
        
        local ipr_PlayerAlive = v:Alive()
        local ipr_PlayerHealth = (ipr_PlayerAlive and v:Health()) or 0
        local ipr_PlayerArmor = (ipr_PlayerAlive and v:Armor()) or 0
        local ipr_PlayerFrags = string.Replace(v:Frags(), "-", "")
        local ipr_PlayerDeath = string.Replace(v:Deaths(), "-", "")
        local ipr_PlayerMoney = ((v.getDarkRPVar) and string.Comma(v:getDarkRPVar("money")) ..ipr_Conf.lang["remb_moneysymb"]) or ipr_Conf.lang["hudunknown"]

        draw.SimpleTextOutlined(ipr_Conf.lang["hudmoney"] ..ipr_PlayerMoney, ipr.font, Admin_Sys_PPos.x , Admin_Sys_PPos.y - 165, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
        draw.SimpleTextOutlined(ipr_Conf.lang["hudhealth"] ..ipr_PlayerHealth, ipr.font, Admin_Sys_PPos.x, Admin_Sys_PPos.y - 145, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
        draw.SimpleTextOutlined(ipr_Conf.lang["hudarmor"] ..ipr_PlayerArmor, ipr.font, Admin_Sys_PPos.x, Admin_Sys_PPos.y - 130, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
        draw.SimpleTextOutlined(ipr_Conf.lang["hudkilled"] ..ipr_PlayerFrags, ipr.font, Admin_Sys_PPos.x, Admin_Sys_PPos.y - 110, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
        draw.SimpleTextOutlined(ipr_Conf.lang["huddeath"] ..ipr_PlayerDeath, ipr.font, Admin_Sys_PPos.x, Admin_Sys_PPos.y - 95, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
    end

    local ipr_ClassVeh = ents.FindByClass("prop_vehicle_jeep")
    local ipr_GetVehicle = list.Get("Vehicles")
    for _, v in ipairs(ipr_ClassVeh) do
        if not IsValid(v) then
           continue
        end
        if not v:IsVehicle() then
           continue
        end
        local ipr_VPos = v:GetPos() + v:OBBCenter()
        local Admin_Sys_PosVeh = ipr_VPos
        Admin_Sys_PosVeh.z = Admin_Sys_PosVeh.z + 60
        Admin_Sys_PosVeh = Admin_Sys_PosVeh:ToScreen()
        if not Admin_Sys_PosVeh.visible then
           continue
        end

        local ipr_Owner = v.CPPIGetOwner and v:CPPIGetOwner()
        if (ipr_Owner and ipr_Owner ~= ipr_Player and ((ipr_Conf.Mode_Bypass_Veh) and (ipr_Conf.Mode_Bypass[ipr_Owner:GetUserGroup()]))) then
           continue
        end
        draw.DrawText(ipr.target, ipr.font, Admin_Sys_PosVeh.x - 10, Admin_Sys_PosVeh.y - 20, Color(ipr_Abs, 0, 0), TEXT_ALIGN_CENTER)

        ipr_Owner = ipr_Owner and ipr_Owner:Nick() or ipr_Conf.lang["hudunknown"]
        draw.SimpleTextOutlined(ipr_Conf.lang["hud_owner"] ..ipr_Owner, ipr.font, Admin_Sys_PosVeh.x - 15, Admin_Sys_PosVeh.y - 35, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
        
        local ipr_Dsqr = ipr_VPos:DistToSqr(ipr_Ppos)
        if (ipr_Dsqr < ipr.dist_gen) then
            local ipr_CarClass = ipr_GetVehicle[v:GetVehicleClass()]
            local ipr_CarName = (ipr_CarClass and ipr_CarClass.Name) or ipr_Conf.lang["hudunknown"]   
            draw.SimpleTextOutlined(ipr_CarName, ipr.font, Admin_Sys_PosVeh.x - 15, Admin_Sys_PosVeh.y - 50, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
        end

        if (ipr_Dsqr > ipr.dist_veh) then
           continue
        end
        local ipr_CarHealth = (v.SV_GetPercentHealth and v:SV_GetPercentHealth()) or (v.VC_getHealth and math.Round(v:VC_getHealth(true))) or ipr_Conf.lang["hudunknown"]
        local ipr_CarFuel = (v.VC_fuelGet and math.Round(v:VC_fuelGet(true))) or (v.SV_GetFuel and v:SV_GetFuel()) or ipr_Conf.lang["hudunknown"]
        local ipr_CarSpeed = math.Round(v:GetVelocity():LengthSqr() / 10936.132983)

        draw.SimpleTextOutlined(ipr_Conf.lang["hudhealth"] ..ipr_CarHealth, ipr.font, Admin_Sys_PosVeh.x - 15, Admin_Sys_PosVeh.y - 110, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
        draw.SimpleTextOutlined(ipr_Conf.lang["hudfuel"] ..ipr_CarFuel, ipr.font, Admin_Sys_PosVeh.x - 15, Admin_Sys_PosVeh.y - 95, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
        draw.SimpleTextOutlined(ipr_Conf.lang["hudspeed"] ..ipr_CarSpeed, ipr.font, Admin_Sys_PosVeh.x - 15, Admin_Sys_PosVeh.y - 80, ipr.color.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ipr.color.blue)
    end
end

local function ipr_Notification()
    local ipr_Tnotif = #ipr.tnotif

    if (ipr_Tnotif > 0) then
        local ipr_TnotifPop = Admin_System_Global.NotifPopup
        local ipr_cur_ = CurTime()
        
        for c, n in ipairs(ipr.tnotif) do
            local ipr_Rcur = (n.cur_sec - ipr_cur_ < 0)
            if (ipr_Rcur) then
                local ipr_tc = #ipr.tnotif
                for i = c, ipr_tc - 1 do
                    ipr.tnotif[i] = ipr.tnotif[i + 1]
                end

                ipr.tnotif[ipr_tc] = nil
                continue
            end
            surface.SetFont(ipr.font)

            local ipr_w, ipr_h = surface.GetTextSize(ipr.arrow.. ""  ..n.str)
            local ipr_rh = ipr.reso.scrh / 2 + 110 - 50 * c + 40 * math.Clamp(ipr_cur_ - n.cur, 0, 1)
            local ipr_rw = ipr.reso.scrw - 25 - ipr_w

            draw.RoundedBox(5, ipr_rw, ipr_rh , ipr_w + 20, 40, ipr_TnotifPop)
            draw.DrawText(ipr.arrow.. ""  ..n.str, ipr.font, ipr_rw + 10, ipr_rh + 40 / 2 - ipr_h / 2, ipr.color.white, TEXT_ALIGN_LEFT)
        end
    end
end

function Admin_System_Global:Notification(ipr_str)
    local ipr_Tnotif = #ipr.tnotif + 1
    local ipr_TnotifPop = Admin_System_Global.NotifPopup_Sound
    local ipr_Player = LocalPlayer()

    if not ipr.tnotif[ipr_Tnotif] then
        ipr.tnotif[ipr_Tnotif] = {}
    end

    ipr.tnotif[ipr_Tnotif].str = ipr_str

    local ipr_Cur = CurTime()
    ipr.tnotif[ipr_Tnotif].cur = ipr_Cur
    ipr.tnotif[ipr_Tnotif].cur_sec = ipr_Cur + ipr.notif_delay

    ipr_Player:EmitSound(ipr_TnotifPop, 100, 100, 0.25, CHAN_AUTO)
end

hook.Add("HUDPaint", "ipr_admin_DrawInfoHUD", ipr_DrawInfoHUD)
hook.Add("HUDPaint", "ipr_admin_Notification", ipr_Notification)
hook.Add("OnScreenSizeChanged", "ipr_admin_OnScreen", ipr_OnScreen)