---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

do
    local Admin_Sys_OverrideCommand, Admin_Sys_OverrideCommand_AR = "///", "@"
    timer.Simple(1, function()
        if (FAdmin) and (Admin_System_Global.TicketLoad) and (Admin_System_Global.OverrideOpenTick) then
            FAdmin.Commands.List["//"] = nil
        end
        hook.Add("PlayerSay", "Admin_Sys:Chat_Cmd",function(ply, text)
            local ipr_cmds = Admin_System_Global:cmds_tbl()

            if (Admin_System_Global.TicketLoad and Admin_System_Global.OverrideOpenTick) then
                if (text[1].. "" ..text[2].. "" ..text[3] == Admin_Sys_OverrideCommand) then
                    return "", ipr_cmds[Admin_System_Global.Ticket_Cmd].func(ply)
                elseif (text[1] == Admin_Sys_OverrideCommand_AR and text[2] ~= "") then
                    return Admin_System_Global:AddChatAdmin(ply, string.Replace(text, Admin_Sys_OverrideCommand_AR, ""), true)
                end
            end
            for cmd, tbl in pairs(ipr_cmds) do
                if (string.lower(text) == Admin_System_Global.Ticket_Cmd) and not (Admin_System_Global.TicketLoad) then
                    break
                end
                if (string.lower(text) ~= string.lower(cmd)) then
                    continue
                end
                return "", tbl.func(ply)
            end
        end)
    end)
end

hook.Add("PlayerNoClip", "Admin_Sys:ForceNoClip", function(ply, desiredState)
    if not Admin_System_Global.Admin_System_ForceNoClip or not IsValid(ply) then
        return
    end
    local ipr_UserGrp = ply:GetUserGroup()
    if Admin_System_Global.ForceNoClip_WhiteList[ipr_UserGrp] then
        return
    end
    if (desiredState) and Admin_System_Global:Sys_Check(ply) and ply:AdminStatusCheck() then
        return true
    end
    return false
end)

do
    local function ipr_sam_func()  ---- SAM uses the same command and it's annoying
        timer.Simple(1, function()
            if (sam) and (sam.command) and sam.command.get_command("admin") then
                for _, v in pairs(sam.__commands) do
                    if (v.name ~= "admin") then
                       continue
                    end

                    v.name = "admin_run"
                    break
                end
            end
        end)
    end

    local ipr_Cur = false
    local function ipr_wk_func()
        local ipr_admin_cur = CurTime()

        if (ipr_admin_cur > (ipr_Cur or 0)) then
            local ipr_class = ents.FindByClass("player")

            for _, v in ipairs(ipr_class) do
                if not v:GetNWBool("CamoEnabled") then
                   continue
                end
                v:SetNoDraw((v:GetVelocity():Length() <= 1) and true or false)
            end
            ipr_Cur = ipr_admin_cur + 1
        end
    end
    hook.Add("Initialize", "AdminSys_FixAddon", function() 
        ipr_sam_func() 

        if not Admin_System_Global.Fix_Addon_Workshop_1 then
            return
        end
        hook.Remove("Think", "SetPlayerCamoAlpha")
        hook.Add("Think", "SetPlayerCamoAlpha", ipr_wk_func)
    end)
end

hook.Add("PlayerSwitchWeapon", "Admin_Sys:SwitchWeap", function(ply)
    if not IsValid(ply) then
        return
    end

    if (ply:AdminStatusCheck()) then
        local ipr_ID = ply:SteamID()

        timer.Create("Admin_Sys_Switch" ..ipr_ID, 0.00001, 1, function()
            if not IsValid(ply) then
                return
            end
            for _, v in pairs(ply:GetWeapons()) do
                v:SetNoDraw(true)
            end
        end)
    end
end)

hook.Add("PlayerShouldTakeDamage", "Admin_System_Global:GodModeSys", function(victim, attacker)
    if Admin_System_Global:Sys_Check(victim) and (victim.SysGodMode) then
        return false
    end
end)

hook.Add("PlayerLeaveVehicle", "Admin_Sys:Leave_Veh", function(ply)
    if not IsValid(ply) then
        return
    end

    if (ply:AdminStatusCheck()) then
        timer.Create("Admin_Sys_LeaveVeh" .. ply:SteamID(), 0.00001, 1, function()
            if not IsValid(ply) then
                return
            end

            ply:SysGlobalEnabled()
        end)
    end
end)

do
    local function ipr_Origin(AdminSys_Ent, AdminSys_Ply, AdminSysPos_Old)
        local ipr_admin_pos = AdminSys_Ent:GetPos()
        local ipr_admin_trace = util.TraceLine({start = ipr_admin_pos, endpos = ipr_admin_pos * 50000})

        if (ipr_admin_trace.HitPos:Distance(ipr_admin_pos) < 45) and (ipr_admin_trace.HitPos:Distance(AdminSysPos_Old) > 145) then
            local AdminSys_vPoint = ipr_admin_pos
            local AdminSys_EffectData = EffectData()

            AdminSys_EffectData:SetOrigin(AdminSys_vPoint)
            util.Effect("StunstickImpact", AdminSys_EffectData)

            AdminSys_Ent:SetLocalVelocity(Vector(0, 0, 0))
            if (timer.Exists("ImprovedAdminSysChkGrnd" ..AdminSys_Ply:AccountID())) then
                timer.Remove("ImprovedAdminSysChkGrnd" ..AdminSys_Ply:AccountID())
            end
        end
    end
    hook.Add("PhysgunDrop", "Admin_Sys:PhysDrop", function(ply, ent)
        if not IsValid(ply) then
            return
        end

        if Admin_System_Global:Sys_Check(ply) and IsValid(ent) and ent:IsPlayer() then
            if ply:KeyPressed(Admin_System_Global.PhysGun_Touche) then
                if Admin_System_Global:LevelCheck(ply, ent) then
                    if Admin_System_Global.PhysGun_Freeze then
                        timer.Simple(0.00001,function()
                            ent:Lock()
                            ent:SetMoveType(MOVETYPE_NONE)
                            ent:SetCollisionGroup(COLLISION_GROUP_WORLD)

                            Admin_System_Global:Notification(ply, "[Improved Admin System - PhysGun Freeze] Le joueur " ..ent:Nick().. " est maintenant freeze !")
                        end)
                    end

                    if timer.Exists("ImprovedAdminSysChkGrnd" ..ply:AccountID()) then
                        timer.Remove("ImprovedAdminSysChkGrnd" ..ply:AccountID())
                    end
                end
            else
                if (Admin_System_Global.PhysGun_Freeze) then
                    ent:UnLock()
                    ent:SetMoveType(MOVETYPE_WALK)
                    ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
                end

                if (Admin_System_Global.PhysGun_ProtectImpactGround) then
                    local Admin_SysPosOldCached = ent:GetPos()

                    timer.Create("ImprovedAdminSysChkGrnd" ..ply:AccountID(), 0, 0, function()
                        if not IsValid(ply) then
                            return
                        end
                        if not IsValid(ent) then
                            timer.Remove("ImprovedAdminSysChkGrnd" ..ply:AccountID())
                            return
                        end
                        ipr_Origin(ent, ply, Admin_SysPosOldCached)
                    end)
                end
            end
        end
    end)
end
Admin_Sys_RembTable = Admin_Sys_RembTable or {}
Admin_SysRate = Admin_SysRate or {}
Admin_Sys_TeleportCheck = Admin_Sys_TeleportCheck or {}
AdminSys_StatusSwitch = AdminSys_StatusSwitch or {}

do
    local function ipr_CleanTicket(ply, ipr_id)
        if (Admin_SysRate[ply]) then
            Admin_SysRate[ply] = nil
        end

        local ipr_class = ents.FindByClass("player")
        for _, v in ipairs(ipr_class) do
            if not Admin_System_Global:Sys_Check(v) then
               continue
            end
            net.Start("Admin_Sys:Remv_Tick")
            net.WriteEntity(ply)
            net.Send(v)

            local ipr_idv = v:AccountID()
            if not Admin_Sys_TeleportCheck[ipr_idv] or not Admin_Sys_TeleportCheck[ipr_idv][ipr_id] then
                continue
            end
            Admin_Sys_TeleportCheck[ipr_idv][ipr_id] = nil
        end
    end
    
    local function ipr_CleanValue(ipr_id)
        if (Admin_Sys_TeleportCheck[ipr_id]) then
            Admin_Sys_TeleportCheck[ipr_id] = nil
        end
        if (Admin_Sys_RembTable[ipr_id]) then
            Admin_Sys_RembTable[ipr_id] = nil
        end
        if (AdminSys_StatusSwitch[ipr_id]) then
            AdminSys_StatusSwitch[ipr_id] = nil
        end
    end

    hook.Add("PlayerDisconnected","Admin_Sys:Ply_Disconnected",function(ply)
        local ipr_antispam = Admin_System_Global:AntiSpam()
        if (ipr_antispam[ply]) then
            ipr_antispam[ply] = nil
        end

        local ipr_id = ply:AccountID()
        ipr_CleanTicket(ply, ipr_id)
        ipr_CleanValue(ipr_id)
    end)
end
 
hook.Add("OnPlayerChangedTeam", "Admin_Sys:ChangeTeam", function (ply, oldTeam, newTeam)
     timer.Simple(0.1, function()
         if not IsValid(ply) then
             return
         end
 
         if (ply:AdminStatusCheck()) then
             ply:Status_()
         end
     end)
end)

hook.Add( "PlayerDeath", "Admin_Sys:DeathPly", function (victim, inflictor, attacker)
     if victim:IsPlayer() and Admin_System_Global:Sys_Check(victim) and victim:AdminStatusCheck() then
         victim:Status_()

         local ipr_admin_victim = victim:AccountID()
         if (AdminSys_StatusSwitch[ipr_admin_victim]) then
             AdminSys_StatusSwitch[ipr_admin_victim] = nil
         end
     end
end)

local ipr_gm = engine.ActiveGamemode()
hook.Add( "DoPlayerDeath", "Admin_Sys:DoDeathPly", function(ply, attacker, dmg)
    if not Admin_System_Global.Remb_On then
        return
    end

    if (IsValid(ply) and ply:IsPlayer() and not ply:IsBot()) then
        if not Admin_System_Global.Remb_Death and (ply == attacker) then 
            return 
        end

        local Admin_Sys_ID = ply:AccountID()
        if (Admin_Sys_ID == Admin_Sys_RembTable[Admin_Sys_ID]) then
            Admin_Sys_RembTable[Admin_Sys_ID] = nil
        end
        Admin_Sys_RembTable[Admin_Sys_ID] = {health = ply:GetMaxHealth(), weapon = {}, money = {}, model = ply:GetModel(), job = ply:Team(), curtime = CurTime()}
        
        if (ipr_gm == "darkrp") then
            local Admin_Sys_Money = ply:getDarkRPVar("money")
            timer.Create("timer_"..ply:SteamID(), 0.5, 1, function()
                if IsValid(ply) then
                    Admin_Sys_RembTable[Admin_Sys_ID].money = Admin_Sys_Money - ply:getDarkRPVar("money")
                end
            end)
        end
        local ipr_weaps = ply:GetWeapons()
        if (#ipr_weaps >= 1) then
            for _, v in pairs(ipr_weaps) do
                Admin_Sys_RembTable[Admin_Sys_ID].weapon[#Admin_Sys_RembTable[Admin_Sys_ID].weapon + 1] = v:GetClass()
            end
        end
    end
end)