--- // SCRIPT BY INJ3
--- // https://steamcommunity.com/id/Inj3/
--- // Improved Admin System
 
Admin_System_Global = Admin_System_Global or {}   
Admin_System_Global.Gen_Ticket = Admin_System_Global.Gen_Ticket or {}
Admin_System_Global.Version = "2.9.7" 

local ipr_Nw = {}
if (CLIENT) then
    Admin_System_Global.SysCloakStatus = Admin_System_Global.SysCloakStatus or false
    Admin_System_Global.SysGodModeStatus = Admin_System_Global.SysGodModeStatus or false
    Admin_System_Global.SysStreamerMod = Admin_System_Global.SysStreamerMod or false
    Admin_System_Global.Admin_System_AutoRdm = Admin_System_Global.Admin_System_AutoRdm or false

    do
        local ipr_Bkey = {}

        function Admin_System_Global:AddCmdBut(ipr_pos, ipr_name, ipr_cmds, ipr_icon, ipr_ret)
            if (ipr_ret) then
                return ipr_Bkey
            end

            ipr_Bkey = (ipr_pos <= 1) and {} or ipr_Bkey
            ipr_Bkey[ipr_pos] = {Name = ipr_name, Commands = ipr_cmds, Icon = ipr_icon}
        end
    end

    net.Receive("admin_sys:updatenw", function()
        local ipr_readUi = net.ReadUInt(1)
        local ipr_readPlayer = net.ReadEntity()

        if (ipr_readUi == 0) then
            if (ipr_Nw[ipr_readPlayer]) then
                ipr_Nw[ipr_readPlayer] = nil
            end
        else
            if not ipr_Nw[ipr_readPlayer] then
                ipr_Nw[ipr_readPlayer] = {}
            end
            
            ipr_Nw[ipr_readPlayer].Statut = net.ReadBool()
        end
    end)

    net.Receive("admin_sys:sendnw", function()
        local ipr_ReadInt = net.ReadUInt(7)

        for i = 1, ipr_ReadInt do
            local ipr_ReadEnt = net.ReadEntity()
            
            if not ipr_Nw[ipr_ReadEnt] then
               ipr_Nw[ipr_ReadEnt] = {}
            end
            ipr_Nw[ipr_ReadEnt].Statut = net.ReadBool()
        end
    end)

    net.Receive("admin_sys:syncvalue", function()
        local ipr_int = net.ReadUInt(3)
        local ipr_bool = net.ReadBool()

        if (ipr_int == 1) then
            Admin_System_Global.SysCloakStatus = ipr_bool
        elseif (ipr_int == 2) then
            Admin_System_Global.SysGodModeStatus = ipr_bool
        elseif (ipr_int == 3) then
            Admin_System_Global.SysStreamerMod = ipr_bool
        elseif (ipr_int == 4) then
            Admin_System_Global.SysCloakStatus = ipr_bool
            Admin_System_Global.SysGodModeStatus = ipr_bool
        end
    end)
    do
        local ipr_Gui = {}
        function Admin_System_Global:AddGui(int, gui)
            ipr_Gui[int] = {}
            ipr_Gui[int].gui = gui
        end

        net.Receive("admin_sys:managegui", function()
            local ipr_int = net.ReadUInt(4)
            ipr_Gui[ipr_int].gui()
        end)
    end
else
    Admin_System_Global.Stats_Save =  "improvedticketsystem/sauvegarde/"
    Admin_System_Global.ZoneAdmin_Save = "improvedticketsystem/position/"

    function Admin_System_Global:ReturnNw()
        return ipr_Nw
    end

    ---- GUI Manage / No data sent
    util.AddNetworkString("admin_sys:managegui") -- Client

    ---- GUI / Several data are sent to the client
    util.AddNetworkString("Admin_Sys:Cmd_Remb") -- Client
    util.AddNetworkString("Admin_Sys:Log") -- Client
    util.AddNetworkString("Admin_Sys:ReloadZone") -- Client
    util.AddNetworkString("Admin_Sys:ChatAdmin") -- Client/Server

    ---- Context Action
    util.AddNetworkString("Admin_Sys:Action") -- Server

    ---- Rating
    util.AddNetworkString("Admin_Sys:Rate") -- Client/Server
    util.AddNetworkString("Admin_Sys:DeleteRate") -- Server
    util.AddNetworkString("Admin_Sys:R_Send_Data") -- Server

    ---- Zone Admin
    util.AddNetworkString("Admin_Sys:TP_Reset") -- Server
    util.AddNetworkString("Admin_Sys:ZNAdmin") -- Server
    util.AddNetworkString("Admin_Sys:Manage_Pos") -- Server

    ---- Remb
    util.AddNetworkString("Admin_Sys:Restore") -- Server

    ---- Notif / Mssg
    util.AddNetworkString("Admin_Sys:Notif") -- Client/Server

    ---- Ticket
    util.AddNetworkString("Admin_Sys:Gen_Tick") -- Client/Server
    util.AddNetworkString("Admin_Sys:Take_Tick") -- Client/Server
    util.AddNetworkString("Admin_Sys:Remv_Tick") -- Client/Server

    ---- Synchronization(cloak, god, noclip)
    util.AddNetworkString("admin_sys:syncvalue") -- Client

    ---- NW Status
    util.AddNetworkString("admin_sys:updatenw") -- Client
    util.AddNetworkString("admin_sys:sendnw") -- Client
end

local function ipr_SendFile(tbl, tbl_)
    local ipr_tb = tbl.file
    if string.find(tbl.file, "*") then ipr_tb = string.Replace(ipr_tb, "*", "") else tbl_ = "" end

    if (CLIENT) then
        include(ipr_tb.. "" ..tbl_)
        return
    end
    if (tbl.send.include) then
        include(ipr_tb.. "" ..tbl_)
    end
    if (tbl.send.addcs) then
        AddCSLuaFile(ipr_tb.. "" ..tbl_)
    end
end

local function ipr_AddFile(tbl)
    if (CLIENT and tbl.only_sv) then
        return
    end
    local ipr_find = file.Find(tbl.file, "LUA")
    local ipr_find_c = #ipr_find
    local ipr_tx = {
        s = SERVER and "SERVER" or "CLIENT",
        c = SERVER and Color(3, 169, 244) or Color(222, 169, 9),
    }

    local ipr_Lang = tbl.ex and Admin_System_Global.Mode_Lang
    for c, f in ipairs (ipr_find) do
        if (c == 1) then
            MsgC(ipr_tx.c, "\nFile found [" ..tbl.text.. "] :")
        end
        local ipr_m = ipr_Lang and 100 or math.Round((c/ipr_find_c) * 100)
        MsgC(ipr_tx.c, "\n-> File loading " ..f.. " - " ..c.."/" ..ipr_find_c.." - 100% - progress : " ..ipr_m.. "%")

        if (ipr_Lang ~= nil) then
                ipr_Lang = string.lower(ipr_Lang)
            if (f ~= ipr_Lang ..".lua") then
                continue
            else
                ipr_SendFile(tbl, f)
                MsgC(ipr_tx.c, "\nImproved Admin System " ..tbl.text.. " - " ..ipr_tx.s.. " - 1 file(s) loaded correctly \n")
                break
            end
        end

        ipr_SendFile(tbl, f)
        if (c == ipr_find_c) then
            MsgC(ipr_tx.c, "\nImproved Admin System " ..tbl.text.. " - " ..ipr_tx.s.. " - " ..ipr_find_c.. " file(s) loaded correctly \n")
        end
    end
end

local function ipr_LoaderExec()
    local ipr_loader = {
        {
            bcolor_sh = {
                file = "ipr_admin_system_lua/advanced_config/sh_color.lua",
                text = "Configuration Color_Sh",
                send = {
                    addcs = true,
                    include = true,
                }
            }
        },
        {
            clang_sh = {
                file = "ipr_admin_system_configuration/config_lang.lua",
                text = "Configuration Langue_Sh",
                send = {
                    addcs = true,
                    include = true,
                }
            }
        },
        {
            bfunc_sh = {
                file = "ipr_admin_system_lua/advanced_config/sh_command.lua",
                text = "Configuration Command_sh",
                send = {
                    addcs = true,
                    include = true,
                }
            }
        },
        {
            lang = {
                file = "ipr_admin_system_language/*",
                text = "Language",
                ex = true,
                send = {
                    addcs = true,
                    include = true,
                }
            }
        },
        {
            bfunc_cl = {
                file = "ipr_admin_system_lua/advanced_config/cl_config.lua",
                text = "Configuration Func",
                send = {
                    addcs = true,
                    include = false,
                }
            }
        },
        {
            configsys_cl = {
                file = "ipr_admin_system_configuration/cl_config/*",
                text = "Configuration_Cl",
                send = {
                    addcs = true,
                    include = false,
                }
            }
        },
        {
            configsys_sh = {
                file = "ipr_admin_system_configuration/sh_config/*",
                text = "Configuration_Sh",
                send = {
                    addcs = true,
                    include = true,
                }
            }
        },
        {
            configsys_sv = {
                file = "ipr_admin_system_configuration/sv_config/*",
                text = "Configuration_Sv",
                send = {
                    addcs = false,
                    include = true,
                }
            }
        },
        {
            serversys = {
                file = "ipr_admin_system_lua/server/*",
                text = "Server",
                only_sv = true,
                send = {
                    addcs = false,
                    include = true,
                }
            }
        },
        {
            clientsys = {
                file = "ipr_admin_system_lua/client/*",
                text = "Client",
                send = {
                    addcs = true,
                    include = false,
                }
            }
        },
        {
            hooksys = {
                file = "ipr_admin_system_lua/client/hud/*",
                text = "Hook",
                send = {
                    addcs = true,
                    include = false,
                }
            }
        },
        {
            vguisys = {
                file = "ipr_admin_system_lua/client/vgui/*",
                text = "Vgui",
                send = {
                    addcs = true,
                    include = false,
                }
            }
        },
    }
    MsgC("-----------\nImproved Admin System v" ..Admin_System_Global.Version.. " loading files..")

    for _, func in ipairs(ipr_loader) do
        for _, d in pairs(func) do
            ipr_AddFile(d)
        end
    end
end

function Admin_System_Global:AddTicketBut(ipr_pos, ipr_name, ipr_link, ipr_compl, ipr_rating)
    Admin_System_Global.Gen_Ticket = (ipr_pos <= 1) and {} or Admin_System_Global.Gen_Ticket
    Admin_System_Global.Gen_Ticket[ipr_pos] = {NameButton = ipr_name, WebLink = ipr_link, Complementary = ipr_compl, Rating = ipr_rating}
end

local ipr_Meta = FindMetaTable("Player")
function ipr_Meta:AdminStatusCheck()
    return IsValid(self) and ipr_Nw[self] and ipr_Nw[self].Statut or false
end
ipr_LoaderExec()

function Admin_System_Global:Sys_Check(p)
    if IsValid(p) then
        if (Admin_System_Global.OnlyJob_Perm) then
            local ipr_Team = team.GetName(p:Team())
            if Admin_System_Global.Job_GeneralPermission[ipr_Team] then
                return true
            end
        else
            local ipr_userGrp = p:GetUserGroup()
            if Admin_System_Global.General_Permission[ipr_userGrp] then
                return true
            end
        end
    end
    return false
end

if (SERVER) then
    function ipr_Meta:EnabledStatus()
        if not Admin_System_Global:Sys_Check(self) then
            return Admin_System_Global:Notification(self, Admin_System_Global.lang["chat_notif"])
        end
        self:Status_()
    end

    function Admin_System_Global:LevelCheck(p, a)
        if Admin_System_Global:Sys_Check(a) then
            if (Admin_System_Global.OnlyJob_Perm) then
                local Admin_TargAdminPlayerTeam = team.GetName(a:Team())
                local Admin_SysPlayerTeam = team.GetName(p:Team())

                if (Admin_System_Global.Job_GeneralPermission[Admin_SysPlayerTeam].Level < Admin_System_Global.Job_GeneralPermission[Admin_TargAdminPlayerTeam].Level) then
                    return false, Admin_System_Global:Notification(p, "L'action que vous tentez est impossible car votre groupe " ..string.upper(Admin_SysPlayerTeam).. " est inférieur(level) au groupe "  ..string.upper(Admin_TargAdminPlayerTeam)..  " du joueur " ..a:Nick())
                end
            else
                local Admin_TargAdminPlayerGrp = a:GetUserGroup()
                local Admin_SysPlayerGrp = p:GetUserGroup()

                if (Admin_System_Global.General_Permission[Admin_SysPlayerGrp].Level < Admin_System_Global.General_Permission[Admin_TargAdminPlayerGrp].Level) then
                    return false, Admin_System_Global:Notification(p, "L'action que vous tentez est impossible car votre groupe " ..string.upper(Admin_SysPlayerGrp).. " est inférieur(level) au groupe "  ..string.upper(Admin_TargAdminPlayerGrp)..  " du joueur " ..a:Nick())
                end
            end
        end
        return true
    end
end