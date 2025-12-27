---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

local ipr_AntiSpam = {}
function Admin_System_Global:AntiSpam()
    return ipr_AntiSpam
end

local function Admin_Sys_AntiSpam_Net(Admin_Sys_Admin, Admin_Sys_NetString, Admin_Sys_NetDelay, Admin_Sys_NetMessage)
    if not IsValid(Admin_Sys_Admin) then
        return false
    end
    if not ipr_AntiSpam[Admin_Sys_Admin] then
        ipr_AntiSpam[Admin_Sys_Admin]  = {}
    end

    local ipr_cur = CurTime()
    if (ipr_AntiSpam[Admin_Sys_Admin][Admin_Sys_NetString]) then
        if (ipr_cur <= ipr_AntiSpam[Admin_Sys_Admin][Admin_Sys_NetString].cur) then
            return false, Admin_System_Global:Notification(Admin_Sys_Admin, (Admin_Sys_NetMessage or Admin_System_Global.lang["notif_antispamgen"]).. " " ..math.Round(ipr_AntiSpam[Admin_Sys_Admin][Admin_Sys_NetString].cur - ipr_cur, 1).. "" ..Admin_System_Global.lang["net_sec"])
        end
        for t, f in pairs(ipr_AntiSpam[Admin_Sys_Admin]) do
            if (ipr_cur > f.cur) then
                ipr_AntiSpam[Admin_Sys_Admin][t] = nil
            end
        end
    end
    if not ipr_AntiSpam[Admin_Sys_Admin][Admin_Sys_NetString] then
        ipr_AntiSpam[Admin_Sys_Admin][Admin_Sys_NetString] = {}
        ipr_AntiSpam[Admin_Sys_Admin][Admin_Sys_NetString].cur = ipr_cur + (Admin_Sys_NetDelay or Admin_System_Global.AntiSpam_Gen)
        return true
    end
end

local function Admin_Sys_CheckFrame(p)
    if IsValid(p) and (p.Admin_Sys_CheckBool) then
        return true
    end
    return false
end

local function Admin_Sys_GenTick(len, ply)
     local Admin_Sys_Ply = ply
     if not IsValid(Admin_Sys_Ply) or not Admin_Sys_Ply:IsPlayer() or not Admin_Sys_CheckFrame(Admin_Sys_Ply) or not Admin_Sys_AntiSpam_Net(Admin_Sys_Ply, "Admin_Sys:Gen_Tick", Admin_System_Global.Ticket_EnvJoueur, Admin_System_Global.lang["notif_waittakecharge"]) then
         return
     end
     local Admin_Sys_StringTitle, Admin_Sys_StringText, Admin_Sys_C = net.ReadString(), net.ReadString(), false
     for i = 1, #Admin_System_Global.Gen_Ticket do
         if (Admin_System_Global.Gen_Ticket[i].NameButton == Admin_Sys_StringTitle) then
               Admin_Sys_C = true
               break
         end
     end
     if not (Admin_Sys_C) then
         Admin_System_Global:Notification(Admin_Sys_Ply, Admin_System_Global.lang["net_noexploitpl"])
         return
     elseif (string.len(Admin_Sys_StringText) - 1 > Admin_System_Global.CharMax) then
         Admin_System_Global:Notification(Admin_Sys_Ply, Admin_System_Global.lang["net_exceedstring"])
         return
     end
     local Admin_Sys_FindClass_Ply, Admin_SysSendTbl_Cl = ents.FindByClass("player"), {Admin_Sys_StringTitle, Admin_Sys_StringText}
     for _ , v in ipairs(Admin_Sys_FindClass_Ply) do
         if Admin_System_Global:Sys_Check(v) then
             if not Admin_System_Global.Ticket_Bool and not v:AdminStatusCheck() or (v == Admin_Sys_Ply) and not Admin_System_Global.Ticket_Bool_1 or v.SysStreamerMod then
                continue
             end
             
             local Admin_Sys_idv = v:AccountID()
             net.Start("Admin_Sys:Gen_Tick")
             net.WriteEntity(Admin_Sys_Ply)
             net.WriteUInt(#Admin_SysSendTbl_Cl, 8)
             for d, t in ipairs(Admin_SysSendTbl_Cl) do
                 net.WriteString(t)
             end
             net.Send(v)
         end
     end
     Admin_System_Global:Notification(ply, Admin_System_Global.Ticket_Text)
end 

local function Admin_SysSendData(Admin_Sys_ReadTable, Admin_Sys_Admin, Admin_Sys_Start, Admin_Sys_TblTo)
    if not (Admin_Sys_ReadTable) then
        print("error no table exists !")
        return
    end
    local Admin_Sys_Compress = util.Compress(Admin_Sys_ReadTable)
    local Admin_Sys_CompressSize = Admin_Sys_TblTo or #Admin_Sys_Compress

    net.Start(Admin_Sys_Start ~= 1 and "Admin_Sys:Log" or "Admin_Sys:Cmd_Remb")
    net.WriteUInt(Admin_Sys_CompressSize, 32)
    net.WriteData(Admin_Sys_Compress, #Admin_Sys_Compress)
    net.Send(Admin_Sys_Admin)
end

local function Admin_Sys_TakeTick(len, ply)
    local Admin_Sys_Admin = ply
    local Admin_Sys_Ent = net.ReadEntity()
    
    if Admin_System_Global:Sys_Check(Admin_Sys_Admin) then
        if not IsValid(Admin_Sys_Admin) or not IsValid(Admin_Sys_Ent) then
            return
        end
        if timer.Exists("Admin_SysPreventTakeTick" ..Admin_Sys_Ent:UserID()) then
            Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["notif_notakech"].. " " ..math.Round(timer.TimeLeft("Admin_SysPreventTakeTick" ..Admin_Sys_Ent:UserID())).. " secs.")
            return
        end
        timer.Create("Admin_SysPreventTakeTick" ..Admin_Sys_Ent:UserID(), Admin_System_Global.Take_Ticket, 1, function() end)
        local ipr_class = ents.FindByClass("player")
        for _, v in ipairs(ipr_class) do
            if not Admin_System_Global:Sys_Check(v) then
               continue
            end
            net.Start("Admin_Sys:Take_Tick")
            for i = 1, 2 do
                net.WriteEntity(((i == 1 and Admin_Sys_Admin) or Admin_Sys_Ent))
            end
            net.Send(v)
        end
        if not Admin_System_Global.Ticket_CachePCharge_Jr then
            Admin_System_Global:Notification(Admin_Sys_Ent, Admin_System_Global.lang["net_admin"].. "" ..Admin_Sys_Admin:Nick().. "" ..Admin_System_Global.lang["net_takecharge"])
        end
        Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_takechargeatr"].. "" ..Admin_Sys_Ent:Nick())
    end
end 

local function Admin_Sys_SQLite_(Admin_Sys_Admin, Admin_SysType, Admin_Sys_Rate, Admin_Sys_P, Admin_Sys_C)
    local Admin_Sys_SteamID = Admin_Sys_Admin:SteamID()

    if (Admin_SysType == 1) then
        local Admin_Sys_SQlite_Name = Admin_Sys_Admin:Nick()
        local Admin_Sys_SQliteGrp = Admin_Sys_Admin:GetUserGroup()
        local Admin_Sys_SQlite_TickQuery = sql.QueryValue("SELECT Central_NumbTicket FROM Improved_Ticket_System WHERE Central_SteamID = " ..sql.SQLStr( Admin_Sys_SteamID ) ) or 1
        local Admin_Sys_SQlite_SteamQuery = sql.QueryValue("SELECT Central_SteamID FROM Improved_Ticket_System WHERE Central_SteamID = " ..sql.SQLStr( Admin_Sys_SteamID ) ) or 0
        local Admin_Sys_SQlite_OS = os.time()

        if (Admin_Sys_SQlite_SteamQuery ~= Admin_Sys_SteamID) then
            sql.Query("INSERT INTO Improved_Ticket_System ('Central_SteamID', 'Central_Admin', 'Central_Horodatage', 'Central_NumbTicket', 'Central_Grp')VALUES ('"..sql.SQLStr( Admin_Sys_SteamID, true ).."', '"..sql.SQLStr( Admin_Sys_SQlite_Name, true ).."', '"..sql.SQLStr( Admin_Sys_SQlite_OS, true ).."', '1', '"..sql.SQLStr( Admin_Sys_SQliteGrp, true ).."') ")
        else
            Admin_Sys_SQlite_TickQuery = Admin_Sys_SQlite_TickQuery + 1
            sql.Query("UPDATE Improved_Ticket_System SET Central_NumbTicket = '"..sql.SQLStr( Admin_Sys_SQlite_TickQuery, true ).."' WHERE Central_SteamID = '"..sql.SQLStr( Admin_Sys_SteamID, true ).."'")
            sql.Query("UPDATE Improved_Ticket_System SET Central_Horodatage = '"..sql.SQLStr( Admin_Sys_SQlite_OS, true ).."' WHERE Central_SteamID = '"..sql.SQLStr( Admin_Sys_SteamID, true ).."'")
            sql.Query("UPDATE Improved_Ticket_System SET Central_Admin = '"..sql.SQLStr( Admin_Sys_SQlite_Name, true ).."' WHERE Central_SteamID = '"..sql.SQLStr( Admin_Sys_SteamID, true ).."'")
            sql.Query("UPDATE Improved_Ticket_System SET Central_Grp = '"..sql.SQLStr( Admin_Sys_SQliteGrp, true ).."' WHERE Central_SteamID = '"..sql.SQLStr( Admin_Sys_SteamID, true ).."'")
        end
        Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_ticket_savereso"].. "" ..Admin_Sys_SQlite_TickQuery)
    elseif (Admin_SysType == 2) then
        if not (Admin_System_Global.RateAdminEnable) then
            return
        end
        local Admin_Sys_SqlRate = sql.QueryValue("SELECT Central_Target FROM Improved_Ticket_Rating WHERE Central_SteamID = " ..sql.SQLStr(Admin_Sys_SteamID)) or nil
        local Admin_Sys_SteamID_p, Admin_Sys_SQlite_SteamQuery_Note = Admin_Sys_P:SteamID()
        if not (Admin_Sys_SqlRate) then
            Admin_Sys_SqlRate = {}
        else
            Admin_Sys_SqlRate = util.JSONToTable(Admin_Sys_SqlRate)
        end
        if not (Admin_Sys_SqlRate[Admin_Sys_SteamID_p]) then
            Admin_Sys_SqlRate[Admin_Sys_SteamID_p] = {Central_R = Admin_Sys_Rate, Central_C = Admin_Sys_C, Central_P = Admin_Sys_P:Nick()}
        else
            local Admin_SysCount, Admin_SysClcnote = 0, 0
            Admin_Sys_SQlite_SteamQuery_Note = sql.QueryValue("SELECT Central_Note FROM Improved_Ticket_Rating WHERE Central_SteamID = " ..sql.SQLStr( Admin_Sys_SteamID ) ) or 5
            Admin_Sys_SqlRate[Admin_Sys_SteamID_p] = {Central_R = Admin_Sys_Rate, Central_C = Admin_Sys_C, Central_P = Admin_Sys_P:Nick()}
            
            for _, v in pairs(Admin_Sys_SqlRate) do
                Admin_SysClcnote = Admin_SysClcnote + v.Central_R
                Admin_SysCount = Admin_SysCount + 1
            end
            Admin_SysClcnote = Admin_SysClcnote / Admin_SysCount
            Admin_Sys_SQlite_SteamQuery_Note = math.Round(Admin_SysClcnote, 1)
        end
        local Admin_Sys_SQlite_SteamQuery_Rate = sql.QueryValue("SELECT Central_SteamID FROM Improved_Ticket_Rating WHERE Central_SteamID = " ..sql.SQLStr( Admin_Sys_SteamID ) ) or 0
        if (Admin_Sys_SQlite_SteamQuery_Rate ~= Admin_Sys_SteamID) then
            sql.Query("INSERT INTO Improved_Ticket_Rating ('Central_SteamID', 'Central_Target', 'Central_Note')VALUES ('"..sql.SQLStr(Admin_Sys_SteamID, true).."', '"..sql.SQLStr(util.TableToJSON(Admin_Sys_SqlRate), true).."', '"..sql.SQLStr( Admin_Sys_Rate, true ).."') ")
        else
            sql.Query("UPDATE Improved_Ticket_Rating SET Central_Note = '"..sql.SQLStr(Admin_Sys_SQlite_SteamQuery_Note, true ).."' WHERE Central_SteamID = '"..sql.SQLStr(Admin_Sys_SteamID, true).."'")
            sql.Query("UPDATE Improved_Ticket_Rating SET Central_Target = '"..sql.SQLStr(util.TableToJSON(Admin_Sys_SqlRate), true ).."' WHERE Central_SteamID = '"..sql.SQLStr(Admin_Sys_SteamID, true).."'")
        end
    end
end

local function Admin_Sys_Data_(Admin_Sys_Admin, Admin_SysType, Admin_Sys_Rate, Admin_Sys_P, Admin_Sys_C)
     if not file.Exists(Admin_System_Global.Stats_Save .. "rating.json", "DATA") then
         if IsValid(Admin_Sys_Admin) and Admin_Sys_Admin:IsSuperAdmin() then
             Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["notif_errorfilereloadserver"])
         end
         return
     end

     if (Admin_SysType == 1) then
         local Admin_Sys_Data_Json = util.JSONToTable(file.Read(Admin_System_Global.Stats_Save.. "sv.json","DATA"))
         if not Admin_Sys_Data_Json then
             Admin_Sys_Data_Json = {}
         end
         local Admin_Sys_Data_Name = Admin_Sys_Admin:Nick()
         local Admin_Sys_SteamID = Admin_Sys_Admin:SteamID()
         local Admin_Sys_Grp = Admin_Sys_Admin:GetUserGroup()
         local Admin_Sys_Data_OS = os.time()

         if not istable(Admin_Sys_Data_Json[Admin_Sys_SteamID]) then
             Admin_Sys_Data_Json[Admin_Sys_SteamID] = {Central_Admin = Admin_Sys_Data_Name, Central_Horodatage = Admin_Sys_Data_OS, Central_NumbTicket = 1, Central_G = Admin_Sys_Grp}
         else
             Admin_Sys_Data_Json[Admin_Sys_SteamID] = {Central_Admin = Admin_Sys_Data_Name, Central_Horodatage = Admin_Sys_Data_OS, Central_NumbTicket = Admin_Sys_Data_Json[Admin_Sys_SteamID].Central_NumbTicket + 1, Central_G = Admin_Sys_Grp}
         end
         file.Write(Admin_System_Global.Stats_Save.. "sv.json", util.TableToJSON(Admin_Sys_Data_Json))
         Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_ticket_savereso"].. "" ..Admin_Sys_Data_Json[Admin_Sys_SteamID].Central_NumbTicket)
     elseif (Admin_SysType == 2) then
         if not (Admin_System_Global.RateAdminEnable) then
             return
         end
         local Admin_Sys_SteamID_, Admin_Sys_Data_JsonRate = Admin_Sys_Admin:SteamID(), util.JSONToTable(file.Read(Admin_System_Global.Stats_Save.. "rating.json","DATA"))
         if not (Admin_Sys_Data_JsonRate) then
             Admin_Sys_Data_JsonRate = {}
         end
         if not istable(Admin_Sys_Data_JsonRate[Admin_Sys_SteamID_]) then
             Admin_Sys_Data_JsonRate[Admin_Sys_SteamID_] = {Admin_Sys_N = Admin_Sys_Rate}
             Admin_Sys_Data_JsonRate[Admin_Sys_SteamID_][Admin_Sys_P:SteamID()] = {Central_R = Admin_Sys_Rate, Central_C = Admin_Sys_C, Central_P = Admin_Sys_P:Nick()}
         else
             local Admin_SysCount, Admin_SysClcnote = 0, 0
             Admin_Sys_Data_JsonRate[Admin_Sys_SteamID_][Admin_Sys_P:SteamID()] = {Central_R = Admin_Sys_Rate, Central_C = Admin_Sys_C, Central_P = Admin_Sys_P:Nick()}
             for k, v in pairs(Admin_Sys_Data_JsonRate[Admin_Sys_SteamID_]) do
                 if istable(v) then
                     Admin_SysClcnote = Admin_SysClcnote + v.Central_R
                     Admin_SysCount = Admin_SysCount + 1
                 end
             end
             Admin_SysClcnote = Admin_SysClcnote / Admin_SysCount
             Admin_Sys_Data_JsonRate[Admin_Sys_SteamID_].Admin_Sys_N = math.Round(Admin_SysClcnote, 1)
         end
         file.Write(Admin_System_Global.Stats_Save.. "rating.json", util.TableToJSON(Admin_Sys_Data_JsonRate) )
     end
end
 
local function Admin_SysReload_Zone(Admin_Sys_Admin, Admin_Sys_ReadTable)
     net.Start("Admin_Sys:ReloadZone")
     net.WriteUInt(#Admin_Sys_ReadTable, 8)
     for _, t in ipairs(Admin_Sys_ReadTable) do
         if t.Central_NomZone then
             net.WriteString(t.Central_NomZone)
         end
         if t.Central_PlayerPOS then
             net.WriteVector(Vector(t.Central_PlayerPOS))
         end
     end
     net.Send(Admin_Sys_Admin)
end

local function Admin_Sys_DataRedir(len, ply)
     local Admin_Sys_Admin = ply
     if not Admin_Sys_AntiSpam_Net(Admin_Sys_Admin, "Admin_Sys:R_Send_Data", 0.5, Admin_System_Global.lang["net_waitting"]) then
         return
     end

     local Admin_Sys_TblTo = #table.ToString(Admin_Sys_RembTable, nil, true)
     local Admin_Sys_Json = util.TableToJSON(Admin_Sys_RembTable)
     Admin_SysSendData(Admin_Sys_Json, Admin_Sys_Admin, 1, Admin_Sys_TblTo)
end

local function Admin_Sys_ChatSendData(len, ply)
     local Admin_SysReadTt = net.ReadString()
     Admin_System_Global:AddChatAdmin(ply, Admin_SysReadTt)
end
 
function Admin_System_Global:Notification(Admin_Sys_Ply, Admin_Sys_Msg)
     net.Start("Admin_Sys:Notif")
     net.WriteString(Admin_Sys_Msg)
     net.Send(Admin_Sys_Ply)
end

local ipr_GameMode, ipr_Meta = engine.ActiveGamemode(), FindMetaTable("Player") 
function ipr_Meta:Status_()
    if not IsValid(self) then
        return
    end
    if not Admin_Sys_AntiSpam_Net(self, "Admin_System_Global:Status_") then
        return
    end

    local Admin_Sys_FindClass_Ply = ents.FindByClass("player")
    local Admin_Sys_idv = self:AccountID()
    if (self:AdminStatusCheck()) then
        Admin_System_Global:Notification(self, Admin_System_Global.lang["cmd_disabadmin"])
        if Admin_System_Global.SwitchOldJob and AdminSys_StatusSwitch[Admin_Sys_idv] then
            if AdminSys_StatusSwitch[Admin_Sys_idv].teamid then
                local Admin_Sys_PosStatus_Disabled, ipr_t = self:GetPos(), team.GetName(self:Team())
                if (Admin_System_Global.SwitchAutoJobTbl == ipr_t) then
                    self:SetTeam(AdminSys_StatusSwitch[Admin_Sys_idv].teamid)
                end
                self:StripWeapons()
                self:Spawn()
                self:SetPos(Admin_Sys_PosStatus_Disabled + Vector(0,0,25))

                if (ipr_GameMode == "darkrp") then
                    self:updateJob(team.GetName(self:Team()))
                end
            end
            if AdminSys_StatusSwitch[Admin_Sys_idv][1] then
                for i = 1, #AdminSys_StatusSwitch[Admin_Sys_idv][1] do
                    self:Give(AdminSys_StatusSwitch[Admin_Sys_idv][1][i].weapons)
                end

                self:SetHealth( AdminSys_StatusSwitch[Admin_Sys_idv][1].health )
                self:SetArmor( AdminSys_StatusSwitch[Admin_Sys_idv][1].armor )
            end
        end
        for _, v in ipairs(Admin_Sys_FindClass_Ply) do
            if (v ~= self) and Admin_System_Global:Sys_Check(v) and not Admin_System_Global.Admin_System_HideNotifAdm then
                Admin_System_Global:Notification(v, "[Admin] "..self:Nick().. "" ..Admin_System_Global.lang["cmd_modadmin"])
            end
        end
        self:UpdateNw(false, 1)
        self:SysGlobalDisabled()

        AdminSys_StatusSwitch[Admin_Sys_idv] = nil
    else
        Admin_System_Global:Notification(self, Admin_System_Global.lang["cmd_actbadmin"])
        local Admin_Sys_Team = self:Team()
        local Admin_SysWeap = self:GetWeapons()
        local Admin_Sys_Health = self:Health()
        local Admin_Sys_Armor = self:Armor()

        if (Admin_System_Global.SwitchAutoJob) and (Admin_System_Global.SwitchAutoJobTbl) then
            local Admin_Sys_PosStatusEnabled = self:GetPos()
            for numb, tbl in pairs(RPExtraTeams) do
                if (tbl.name == Admin_System_Global.SwitchAutoJobTbl) then
                    local Admin_SysOldCustomcheck = tbl.customCheck
                    tbl.customCheck = function(ply)
                        if not Admin_System_Global:Sys_Check(ply) then
                            return false
                        end
                    end
                    if (ipr_GameMode == "darkrp") then
                        self:updateJob(tbl.name)
                    end

                    self:SetTeam(numb)
                    self:Spawn()
                    tbl.customCheck = Admin_SysOldCustomcheck
                    break
                end
            end
            self:SetPos(Admin_Sys_PosStatusEnabled + Vector(0,0,25))
        end
        if (Admin_System_Global.SwitchOldJob) then
            local Admin_SysInsTbl = {health = Admin_Sys_Health, armor = Admin_Sys_Armor}
            AdminSys_StatusSwitch[Admin_Sys_idv] = {teamid = Admin_Sys_Team}
            if (#Admin_SysWeap >= 1) then
                for _, wp in pairs(Admin_SysWeap) do
                    local Admin_Sys_Class = wp:GetClass()
                    Admin_SysInsTbl[#Admin_SysInsTbl + 1] = {weapons = Admin_Sys_Class}
                end
            end
            AdminSys_StatusSwitch[Admin_Sys_idv][#AdminSys_StatusSwitch[Admin_Sys_idv] + 1] = Admin_SysInsTbl
            Admin_SysInsTbl = nil
        end
        for _, v in ipairs(Admin_Sys_FindClass_Ply) do
            if (v ~= self) and Admin_System_Global:Sys_Check(v) and not (Admin_System_Global.Admin_System_HideNotifAdm) then
                Admin_System_Global:Notification(v, "[Admin] "..self:Nick().. "" ..Admin_System_Global.lang["cmd_nomodadmin"])
            end
        end
        if (ConfigurationMedicMod) and timer.Exists("MedicMod"..self:EntIndex()) then
            self:SetBleeding(false)
            self:SetHeartAttack(false)
            self:SetPoisoned(false)

            local ipr_GFracture = self:GetFractures()
            if (ipr_GFracture) then
                for k, v in pairs(ipr_GFracture) do
                    self:SetFracture(false, k)
                end
            end
            timer.Remove("MedicMod"..self:EntIndex())
        end
        self:UpdateNw(true, 1)
        self:SysGlobalEnabled()
    end
end

for _, v in ipairs(player.GetAll()) do
    if not v:IsBot() then
        continue
    end

    v:UpdateNw(true, 1)
end

hook.Add("PostGamemodeLoaded", "ipr_Admin:Post_Hunger", function()
    if timer.Exists("HMThink") then
        local function ipr_hunger_mod()
            local ipr_hunger_player = ents.FindByClass("player")
            for _, v in ipairs(ipr_hunger_player) do
                if not v:Alive() or v:AdminStatusCheck() then
                   continue
                end
                v:hungerUpdate()
            end
        end
        timer.Remove("HMThink")
        timer.Create("HMThink", 10, 0, ipr_hunger_mod)
    end
end)

function Admin_System_Global:AddChatAdmin(Admin_SysPly, Admin_SysReadTt, Admin_Sys_Exclude)
     if ((not Admin_Sys_Exclude and Admin_System_Global:Sys_Check(Admin_SysPly)) or Admin_Sys_Exclude) then
         if not Admin_Sys_AntiSpam_Net(Admin_SysPly, "Admin_Sys:ChatAdmin") or not Admin_Sys_Exclude and (string.len(Admin_SysReadTt) - 1 > 150 or string.len(Admin_SysReadTt) - 1 < 1)  then
             return
         end
         local Admin_Sys_Nom = Admin_Sys_Exclude and "Command @ : [" ..Admin_SysPly:Nick().. "] " or Admin_SysPly:Nick().. " "
         local Admin_Sys_Groupe = Admin_SysPly:GetUserGroup()
         local Admin_Sys_Data_OS = os.time()
         local Admin_Sys_FindClass_Ply, Admin_Sys_Data_Tbl = ents.FindByClass("player"), {Admin_Sys_Nom, Admin_Sys_Groupe, Admin_Sys_Data_OS, Admin_SysReadTt}
         
         for _, v in ipairs(Admin_Sys_FindClass_Ply) do
             if Admin_System_Global:Sys_Check(v) then
                 net.Start("Admin_Sys:ChatAdmin")
                 net.WriteUInt(#Admin_Sys_Data_Tbl, 8)
                 for _, t in ipairs(Admin_Sys_Data_Tbl) do
                     net.WriteString(t)
                 end
                 net.Send(v)

                 if not (Admin_Sys_Exclude) and (Admin_SysPly ~= v) then
                     Admin_System_Global:Notification(v, Admin_System_Global.lang["chat_newmssg"].. " " ..Admin_SysPly:Nick())
                 end
             end
         end
     end
end

local ipr_GM = game.GetMap()
function Admin_System_Global:Sys_Cmd(Admin_Sys_Admin, Admin_Sys_Nb)
    local Admin_Sys_Group, Admin_Sys_ReadTable = Admin_Sys_Admin:GetUserGroup()
    
    if (Admin_Sys_Nb == 2) then
        if Admin_System_Global.ZoneAdmin_Groupe[Admin_Sys_Group] then
            if Admin_System_Global:Sys_Check(Admin_Sys_Admin) then
                Admin_Sys_ReadTable =  util.JSONToTable(file.Read(Admin_System_Global.ZoneAdmin_Save.. "" ..ipr_GM.. "/pos.txt","DATA"))
                Admin_SysReload_Zone(Admin_Sys_Admin, Admin_Sys_ReadTable)
            end
        else
            Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["chat_notif"])
        end
    elseif (Admin_Sys_Nb == 1) then
        if Admin_System_Global.Stats_Groupe[Admin_Sys_Group] then
            if Admin_System_Global:Sys_Check(Admin_Sys_Admin) then
                if (Admin_System_Global.Admin_System_Save == 1) then
                    Admin_Sys_ReadTable = file.Read(Admin_System_Global.Stats_Save.. "sv.json","DATA")
                    Admin_SysSendData(Admin_Sys_ReadTable, Admin_Sys_Admin)
                elseif (Admin_System_Global.Admin_System_Save == 2) then
                    sql.Begin()
                    Admin_Sys_ReadTable = sql.Query("SELECT * FROM Improved_Ticket_System")
                    sql.Commit()
                    Admin_Sys_ReadTable = (Admin_Sys_ReadTable) and util.TableToJSON(Admin_Sys_ReadTable) or util.TableToJSON({})
                    Admin_SysSendData(Admin_Sys_ReadTable, Admin_Sys_Admin)
                end
                timer.Create("ImprovedSysRat_S" ..Admin_Sys_Admin:SteamID(), 2, 1, function()
                    if not IsValid(Admin_Sys_Admin) then
                        return
                    end
                    if (Admin_System_Global.Admin_System_Save == 1) then
                        Admin_Sys_ReadTable = file.Read(Admin_System_Global.Stats_Save.. "rating.json","DATA")
                        Admin_SysSendData(Admin_Sys_ReadTable, Admin_Sys_Admin)
                    elseif (Admin_System_Global.Admin_System_Save == 2) then
                        sql.Begin()
                        Admin_Sys_ReadTable = sql.Query("SELECT * FROM Improved_Ticket_Rating")
                        sql.Commit()
                        local Admin_Sys_TableSort = {}
                        local Admin_Sys_InitChecking = false
                        if (Admin_Sys_ReadTable) then
                            for k, v in ipairs(Admin_Sys_ReadTable) do
                                local t = v.Central_Target
                                t = util.JSONToTable(t)
                                if (v.Central_Note == "nil") then
                                    if not Admin_Sys_InitChecking then
                                        print("------------------------------- \n[Improved Admin System]\n[Error : Unreadable value] It seems that an error occurred in the database when calculating the overall averages of your administrators.")
                                        print("\nAutomatic fix in progress, please wait...")
                                        Admin_Sys_InitChecking = true
                                    end
                                    local Admin_SysCount, Admin_SysClcnote = 0, 0
                                    print(v.Central_SteamID, "STEAM ID")
                                    for i, j in pairs(t) do
                                        Admin_SysClcnote = Admin_SysClcnote + j.Central_R
                                        Admin_SysCount = Admin_SysCount + 1
                                    end
                                    Admin_SysClcnote = math.Round(Admin_SysClcnote / Admin_SysCount, 1)
                                    v.Central_Note = Admin_SysClcnote
                                    sql.Query("UPDATE Improved_Ticket_Rating SET Central_Note = '"..sql.SQLStr( Admin_SysClcnote, true ).."' WHERE Central_SteamID = '"..sql.SQLStr( v.Central_SteamID, true ).."'")
                                    print("--> FIXED")
                                end
                                Admin_Sys_TableSort[v.Central_SteamID] = {Admin_Sys_N = v.Central_Note}
                                for o, p in pairs(t) do
                                    Admin_Sys_TableSort[v.Central_SteamID][o] = {Central_R = t[o].Central_R, Central_C = t[o].Central_C, Central_P = t[o].Central_P}
                                end
                            end
                            if (Admin_Sys_InitChecking) then
                                print("-------------------------------")
                            end
                        end
                        Admin_Sys_ReadTable = util.TableToJSON(Admin_Sys_TableSort)
                        Admin_SysSendData(Admin_Sys_ReadTable, Admin_Sys_Admin)
                        Admin_Sys_TableSort = nil
                    end
                end)
            end
        else
            Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["chat_notif"])
        end
    elseif (Admin_Sys_Nb == 3) then
        if not Admin_System_Global.Remb_On then 
            Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_rembdisable"]) 
            return 
        end
        if  Admin_System_Global.Remb_Groupe[Admin_Sys_Group] then
            Admin_Sys_DataRedir(nil, Admin_Sys_Admin)
        else
            Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["chat_notif"])
        end
    end

    if not Admin_System_Global:Sys_Check(Admin_Sys_Admin) then 
        return Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["chat_notif"])
    end
    if (Admin_Sys_Nb == 5) then
            net.Start("admin_sys:managegui")
            net.WriteUInt(0, 4)
            net.Send(Admin_Sys_Admin)
    elseif (Admin_Sys_Nb == 4) then
            net.Start("admin_sys:managegui")
            net.WriteUInt(1, 4)
            net.Send(Admin_Sys_Admin)
    elseif (Admin_Sys_Nb == 6) then
            net.Start("admin_sys:managegui")
            net.WriteUInt(2, 4)
            net.Send(Admin_Sys_Admin)
    elseif (Admin_Sys_Nb == 7) then
            net.Start("Admin_Sys:ChatAdmin")
            net.Send(Admin_Sys_Admin)
    end
end

net.Receive("Admin_Sys:DeleteRate", function(len, ply)
     if Admin_System_Global.RateAdminDelete[ply:GetUserGroup()] then
         local Admin_Sys_ReadST, Admin_Sys_ReadSTA = net.ReadString(), net.ReadString()
         
         if (Admin_System_Global.Admin_System_Save == 1) then
             local Admin_Sys_Data_JsonRate = util.JSONToTable(file.Read(Admin_System_Global.Stats_Save.. "rating.json","DATA"))
             Admin_Sys_Data_JsonRate[Admin_Sys_ReadSTA][Admin_Sys_ReadST] = nil
             if (table.Count(Admin_Sys_Data_JsonRate[Admin_Sys_ReadSTA]) - 1) < 1 then
                 Admin_Sys_Data_JsonRate[Admin_Sys_ReadSTA] = nil
             end
             
             file.Write(Admin_System_Global.Stats_Save.. "rating.json", util.TableToJSON(Admin_Sys_Data_JsonRate) )
             Admin_System_Global:Notification(ply, Admin_System_Global.lang["net_deleterating"])
         elseif (Admin_System_Global.Admin_System_Save == 2) then
             local Admin_Sys_RmvTable = sql.QueryValue("SELECT Central_Target FROM Improved_Ticket_Rating WHERE Central_SteamID = " ..sql.SQLStr( Admin_Sys_ReadSTA ) )
             Admin_Sys_RmvTable = util.JSONToTable(Admin_Sys_RmvTable)
             
             for k in pairs(Admin_Sys_RmvTable) do
                 if (k == Admin_Sys_ReadST) then
                     Admin_Sys_RmvTable[k] = nil
                     break
                 end
             end
             local Admin_Sys_Count = table.Count(Admin_Sys_RmvTable)
             if (Admin_Sys_Count >= 1) then
                 sql.Query("UPDATE Improved_Ticket_Rating SET Central_Target = '"..sql.SQLStr( util.TableToJSON(Admin_Sys_RmvTable), true ).."' WHERE Central_SteamID = '"..sql.SQLStr( Admin_Sys_ReadSTA, true ).."'")
             else
                 sql.Query("DELETE FROM Improved_Ticket_Rating WHERE Central_SteamID = '"..sql.SQLStr( Admin_Sys_ReadSTA, true ).."'")
             end
             Admin_System_Global:Notification(ply, Admin_System_Global.lang["net_deleterating"])
         end
     end
end)

net.Receive("Admin_Sys:Remv_Tick", function(len, ply)
     local Admin_Sys_Admin = ply
     if not IsValid(Admin_Sys_Admin) then
         return
     end
     local ipr_check = Admin_System_Global:Sys_Check(Admin_Sys_Admin)

     if Admin_System_Global.Ticket_TakePerm and ipr_check and Admin_Sys_Admin:AdminStatusCheck() or ipr_check then
         local Admin_Sys_Ply = net.ReadEntity()
         if not IsValid(Admin_Sys_Ply) then 
            return 
         end

         local Admin_Sys_Bool = net.ReadBool()
         if (Admin_Sys_Bool) then
             local Admin_Sys_FindClass_Ply = ents.FindByClass("player")

             for _, v in ipairs(Admin_Sys_FindClass_Ply) do
                 if Admin_System_Global:Sys_Check(v) or (Admin_Sys_Ply == v) then
                     Admin_System_Global:Notification(v, Admin_System_Global.lang["net_ticket_title_d"].. "" ..Admin_Sys_Ply:Nick().. "" ..Admin_System_Global.lang["net_ticket_title_dp"].. "" ..Admin_Sys_Admin:Nick())
                 end

                 net.Start("Admin_Sys:Remv_Tick")
                 net.WriteEntity(Admin_Sys_Ply)
                 net.Send(v)
             end
             if (Admin_Sys_Admin ~= Admin_Sys_Ply) then
                 if (Admin_System_Global.Admin_System_Save == 1) then
                     Admin_Sys_Data_(Admin_Sys_Admin, 1)
                 elseif (Admin_System_Global.Admin_System_Save == 2) then
                     Admin_Sys_SQLite_(Admin_Sys_Admin, 1)
                 end
             end

             local Admin_Sys_Acc = Admin_Sys_Admin:AccountID()
             if (Admin_System_Global.RateAdminEnable) and not timer.Exists("ImprovedAdminSysRvRate" ..Admin_Sys_Acc) then

                 local Admin_SysCheckRating, Admin_Sys_String = false, net.ReadString()
                 for i = 1, #Admin_System_Global.Gen_Ticket do
                     if (Admin_System_Global.Gen_Ticket[i].NameButton == Admin_Sys_String) and Admin_System_Global.Gen_Ticket[i].Rating then
                           Admin_SysCheckRating = true
                         
                           break
                     end
                 end
                 if (Admin_SysCheckRating) then
                     if Admin_System_Global.RateAdmin and Admin_System_Global:Sys_Check(Admin_Sys_Ply) then
                         return
                     end
                     if Admin_SysRate[Admin_Sys_Ply] then
                         return
                     end
                     Admin_SysRate[Admin_Sys_Ply] = Admin_SysRate[Admin_Sys_Ply] or {}
                     Admin_SysRate[Admin_Sys_Ply] = {Admin_SysVerif = Admin_Sys_Admin}

                     net.Start("Admin_Sys:Rate")
                     net.Send(Admin_Sys_Ply)

                     timer.Create("ImprovedAdminSysRvRate" ..Admin_Sys_Acc, Admin_System_Global.RateAdminDelay * 60, 1, function()
                         if IsValid(Admin_Sys_Ply) then
                             if Admin_SysRate[Admin_Sys_Ply] then
                                 Admin_SysRate[Admin_Sys_Ply] = nil
                             end
                         end
                     end)
                 end
             end
         else
             if Admin_Sys_CheckFrame(Admin_Sys_Ply)  then
                 Admin_Sys_Ply.Admin_Sys_CheckBool = false
             end
         end
     end
end)

net.Receive("Admin_Sys:Rate", function(len, ply)
    if not IsValid(ply) then
        return
    end
    if not Admin_SysRate[ply] or not IsValid(Admin_SysRate[ply].Admin_SysVerif) then
        Admin_System_Global:Notification(ply, Admin_System_Global.lang["net_timelimitrate"])
        return
    end
    local Admin_Sys_RateFRead = net.ReadFloat()
    if not isnumber(Admin_Sys_RateFRead) or (Admin_Sys_RateFRead == nil) then
        return
    end
    local Admin_Sys_RateNRead = net.ReadString()
    if (string.len(Admin_Sys_RateNRead) - 1 > 45) then
        Admin_System_Global:Notification(ply, Admin_System_Global.lang["net_strglong"])
        return
    end
    if (Admin_System_Global.Admin_System_Save == 1) then
        Admin_Sys_Data_(Admin_SysRate[ply].Admin_SysVerif, 2, Admin_Sys_RateFRead, ply, Admin_Sys_RateNRead)
    elseif (Admin_System_Global.Admin_System_Save == 2) then
        Admin_Sys_SQLite_(Admin_SysRate[ply].Admin_SysVerif, 2, Admin_Sys_RateFRead, ply, Admin_Sys_RateNRead)
    end

    Admin_SysRate[ply] = nil
    Admin_System_Global:Notification(ply, Admin_System_Global.lang["net_ratevoting"])
end)

local Admin_SysBits = 4
net.Receive("Admin_Sys:Manage_Pos", function(len, ply)
     local Admin_Sys_Admin = ply
     if Admin_System_Global.ZoneAdmin_Groupe[Admin_Sys_Admin:GetUserGroup()] then
         if not Admin_Sys_AntiSpam_Net(Admin_Sys_Admin, "Admin_Sys:Action", 0.5) then
             return
         end
         local Admin_Sys_PlayerString, Admin_Sys_Bool, Admin_Sys_Int, Admin_SysEnt = net.ReadString(), net.ReadBool(), net.ReadUInt(Admin_SysBits), net.ReadEntity()
         if (Admin_Sys_Bool) then
             local Admin_Sys_Ply = Admin_SysEnt:GetClass() ~= "worldspawn" and Admin_SysEnt or Admin_Sys_Admin
             if (string.len(Admin_Sys_PlayerString) > 20) then Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_zone_long"])
                 return
             end
             if (string.len(Admin_Sys_PlayerString) < 1) then Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_zone_short"])
                 return
             end

             local Admin_Sys_AddPos = false
             if not (IsValid(Admin_Sys_Ply) and Admin_Sys_Ply:IsPlayer()) then
                 return
             end
             Admin_Sys_Ply = Admin_Sys_Ply:GetPos()
             local Admin_Sys_Json = util.JSONToTable(file.Read(Admin_System_Global.ZoneAdmin_Save.. "" ..ipr_GM.. "/pos.txt","DATA"))
             if (#Admin_Sys_Json >= 8) then
                 Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["zoneadmin_maxzone"])
                 return
             end
             for i= 1, #Admin_Sys_Json do
                 if Admin_Sys_Json[i].Central_PlayerPOS:Distance(Admin_Sys_Admin:GetPos()) < Admin_System_Global.Admin_System_ZoneAdminSize * 2 then Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["zoneadmin_notifpos"].. "" ..Admin_Sys_Json[i].Central_NomZone.. "" ..Admin_System_Global.lang["zoneadmin_notifpos_"]) Admin_Sys_AddPos = true break end
                 if Admin_Sys_Json[i].Central_PlayerPOS == Admin_Sys_Ply then Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_zone_posext"].. "" ..Admin_Sys_Json[i].Central_NomZone) Admin_Sys_AddPos = true break end
                 if Admin_Sys_Json[i].Central_NomZone == Admin_Sys_PlayerString then Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_zone_posalrsave"].. "" ..Admin_Sys_Json[i].Central_NomZone) Admin_Sys_AddPos = true break end
             end
             if not Admin_Sys_AddPos then
                 Admin_Sys_Json[#Admin_Sys_Json + 1] = {Central_PlayerPOS = Admin_Sys_Ply, Central_NomZone = Admin_Sys_PlayerString}
                 file.Write(Admin_System_Global.ZoneAdmin_Save.. "" ..ipr_GM.. "/pos.txt", util.TableToJSON(Admin_Sys_Json))
                 
                 timer.Simple(0.1, function()
                     if not IsValid(Admin_Sys_Admin) then
                         return
                     end
                     
                     Admin_SysReload_Zone(Admin_Sys_Admin, Admin_Sys_Json)
                     Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_zone_posadd"])
                 end)
             end
         else
             local Admin_Sys_Json = util.JSONToTable(file.Read(Admin_System_Global.ZoneAdmin_Save.. "" ..ipr_GM.. "/pos.txt","DATA"))
             table.RemoveByValue(Admin_Sys_Json, Admin_Sys_Json[Admin_Sys_Int])
             file.Write(Admin_System_Global.ZoneAdmin_Save.. "" ..ipr_GM.. "/pos.txt", util.TableToJSON(Admin_Sys_Json))

             timer.Simple(0.1, function()
                 Admin_SysReload_Zone(Admin_Sys_Admin, Admin_Sys_Json)
             end)
         end
     end
end)

net.Receive("Admin_Sys:Action", function(len, ply)
    if not IsValid(ply) then
        return
    end
    if not Admin_System_Global:Sys_Check(ply) then
        return
    end
    if not Admin_Sys_AntiSpam_Net(ply, "Admin_Sys:Action", 0.5, Admin_System_Global.lang["net_waitting"]) then
        return
    end
    local Admin_Sys_Int = net.ReadUInt(Admin_SysBits)
    local Admin_Sys_Ent = net.ReadEntity()
    local Admin_Sys_Bool = net.ReadBool()
    if (Admin_Sys_Ent:GetPos():DistToSqr(ply:GetPos()) >= 7000000) then
        return Admin_System_Global:Notification(ply, "Vous êtes trop loin !")
    end

    if (Admin_Sys_Bool) then
        if not IsValid(Admin_Sys_Ent) or not Admin_Sys_Ent:IsVehicle() or not isnumber(Admin_Sys_Int) then
            Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_cartoofar"])
            return
        end
        if (vcmod1 or SVMOD) then
            if (Admin_Sys_Int == 6) then
                if (vcmod1) then
                    local Admin_Sys_Health = Admin_Sys_Ent:VC_getHealthMax()
                    if Admin_Sys_Ent:VC_getHealth() >= Admin_Sys_Health then Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_noenginerepair"]) end
                    if table.IsEmpty(Admin_Sys_Ent:VC_getDamagedParts()) then Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_nodamagedpart"]) end
                    if (Admin_Sys_Ent:VC_getHealth() >= Admin_Sys_Health) and table.IsEmpty(Admin_Sys_Ent:VC_getDamagedParts()) then return end

                    Admin_Sys_Ent:EmitSound("vehicles/Crane/crane_magnet_release.wav", 75, 25, 1, CHAN_AUTO)
                    Admin_Sys_Ent:VC_repairHealth(Admin_Sys_Health)

                    if (Admin_Sys_Ent:IsOnFire()) then
                        Admin_Sys_Ent:Extinguish()
                    end
                    for k, v in pairs(Admin_Sys_Ent:VC_getDamagedParts()) do
                        local Admin_Sys_VehiclePart = k
                        table.foreach(Admin_Sys_Ent:VC_getDamagedParts()[Admin_Sys_VehiclePart], function( key, value )
                            Admin_Sys_Ent:VC_repairPart(Admin_Sys_VehiclePart, key)
                        end)
                    end
                end
                if (SVMOD) then
                    if (Admin_Sys_Ent:IsOnFire()) then
                        Admin_Sys_Ent:Extinguish()
                    end
                    Admin_Sys_Ent:SV_FullRepair()
                end
                Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_repairwaitting"])
            elseif (Admin_Sys_Int == 7) then
                if (vcmod1) then
                    if Admin_Sys_Ent:VC_fuelGet() == 100 or Admin_Sys_Ent:VC_fuelGet() == Admin_Sys_Ent:VC_fuelGetMax() then Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_fullfuel"]) return end
                    Admin_Sys_Ent:EmitSound("ambient/water/water_spray" ..math.random(1,3).. ".wav", 75, 25, 1, CHAN_AUTO)
                    timer.Simple(1.5,function()
                        if not IsValid(Admin_Sys_Ent) then return end
                        Admin_Sys_Ent:EmitSound("ambient/water/water_spray" ..math.random(1,3).. ".wav", 75, 25, 1, CHAN_AUTO)
                    end)
                    Admin_Sys_Ent:VC_fuelSet(100)
                    Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_fuel"])
                end
                if (SVMOD) then
                    if (Admin_Sys_Ent:SV_GetFuel() == Admin_Sys_Ent:SV_GetMaxFuel()) then
                        return
                    end
                    Admin_Sys_Ent:SV_SetFuel(Admin_Sys_Ent:SV_GetMaxFuel())
                end
            end
        else
            Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_vcmoderror"])
        end
        if (Admin_Sys_Int == 8) then
            local Admin_SysDriver = Admin_Sys_Ent:GetDriver()
            if Admin_SysDriver:InVehicle() and Admin_System_Global:LevelCheck(ply, Admin_SysDriver) then
                Admin_SysDriver:ExitVehicle()
                Admin_System_Global:Notification(ply, Admin_System_Global.lang["net_remb_ply"].. "" ..Admin_SysDriver:Nick().. "" ..Admin_System_Global.lang["notif_ejectcar"])
            end
        elseif (Admin_Sys_Int == 9) then
            Admin_Sys_Ent:Remove()
            Admin_Sys_Ent:EmitSound("physics/body/body_medium_break" ..math.random(1,3).. ".wav", 75, 25, 1, CHAN_AUTO)
            Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_deletecar"])
        end
    else
        if IsValid(Admin_Sys_Ent) and Admin_Sys_Ent:IsPlayer() then
            if (Admin_Sys_Int == 1) and Admin_System_Global:LevelCheck(ply, Admin_Sys_Ent) then
                if Admin_Sys_Ent:GetCollisionGroup() == COLLISION_GROUP_PLAYER then
                    Admin_Sys_Ent:Lock()
                    Admin_Sys_Ent:SetMoveType(MOVETYPE_NONE)
                    Admin_Sys_Ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
                    Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_nowfreezeaction"])
                else
                    Admin_Sys_Ent:UnLock()
                    Admin_Sys_Ent:SetMoveType(MOVETYPE_WALK)
                    Admin_Sys_Ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
                    Admin_Sys_Ent:SetLocalVelocity(Vector(0, 0, 0))
                    Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_nowunfreezeaction"])
                end

            elseif (Admin_Sys_Int == 2) then
                if Admin_Sys_Ent:Health() == Admin_Sys_Ent:GetMaxHealth() then Admin_System_Global:Notification(ply, Admin_System_Global.lang["net_actionfreeze"].. "" ..Admin_Sys_Ent:Health())
                    return
                end

                Admin_Sys_Ent:SetHealth( Admin_Sys_Ent:GetMaxHealth() )
                Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_healthpv"].. "" ..Admin_Sys_Ent:Health().. " pv")
            elseif (Admin_Sys_Int == 3) and Admin_System_Global:LevelCheck(ply, Admin_Sys_Ent) then
                if (#Admin_Sys_Ent:GetWeapons() <= 0) then Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_noweap"])
                    return
                end

                Admin_Sys_Ent:StripWeapons()
                Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_nostripweap"].. "" ..Admin_Sys_Ent:Nick())
            elseif (Admin_Sys_Int == 4) then
                if (Admin_Sys_Ent:Armor() == 100) then Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_fullarmoral"]) return end

                Admin_Sys_Ent:SetArmor(100)
                Admin_System_Global:Notification(ply, Admin_System_Global.lang["notif_fullarmor"])
            end
            if (Admin_Sys_Int == 5) then
                if not Admin_Sys_Ent:Alive() then
                    local Admin_Sys_Pos = Admin_Sys_Ent:GetPos()

                    Admin_Sys_Ent:Spawn()
                    Admin_Sys_Ent:SetPos(Admin_Sys_Pos + Vector(0,10,50))
                else
                    Admin_System_Global:Notification(ply, Admin_System_Global.lang["net_respawn"].. "" ..Admin_Sys_Ent:Nick().. "" ..Admin_System_Global.lang["net_respawn_v"])
                end
            end
        end
        if (Admin_Sys_Int == 10) then
            if (Realistic_Police) then
                if ply.WeaponRPT["Cuff"] then
                    Realistic_Police.UnCuff(ply, ply)
                end
            end
        end
        if (Admin_Sys_Int == 11) then
            if (BES) and ply:GetNWBool("BES_CUFFED", false) then
                ply:SetWalkSpeed(ply:GetNWInt( "BES_OLDWSPEED", 25))
                ply:SetRunSpeed(ply:GetNWInt( "BES_OLDRSPEED", 100))
                ply:SetNWBool("BES_CUFFED", false)

                if (ply.OldSWEPs) then
                    for k, v in pairs( ply.OldSWEPs ) do
                        ply:Give(k)
                    end
                end
            end
        end
        if (Admin_Sys_Int == 12) then
            if (RHandcuffsConfig) then
                if not ply.CuffedBy then
                    return
                end
                ply:RHCRestrain(ply.CuffedBy)
            end
        end
    end
end)
 
net.Receive("Admin_Sys:Notif", function(len, ply)
     local Admin_Sys_Admin = ply
     if not IsValid(Admin_Sys_Admin) then
         return
     end
     local ipr_Check = Admin_System_Global:Sys_Check(Admin_Sys_Admin)
     if Admin_System_Global.Ticket_TakePerm and ipr_Check and Admin_Sys_Admin:AdminStatusCheck() or ipr_Check then
         if not Admin_Sys_AntiSpam_Net(Admin_Sys_Admin, "Admin_Sys:Mssg") then
             return
         end
         local Admin_Sys_EntMess = net.ReadEntity()
         local Admin_Sys_Int = net.ReadUInt(8)
         if not IsValid(Admin_Sys_EntMess) or not isnumber(Admin_Sys_Int) then
             return
         end
         if (Admin_Sys_Int >= 1) then
             Admin_System_Global:Notification(Admin_Sys_EntMess, Admin_System_Global.Notif_Gen[Admin_Sys_Int].Message_Notification)
             Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_zone_posnotif"])
         end
     end
end)
 
net.Receive("Admin_Sys:ZNAdmin", function(len, ply)
     local Admin_Sys_Admin = ply
     if not IsValid(Admin_Sys_Admin) then
         return
     end

     if Admin_System_Global.Ticket_TakePerm and Admin_System_Global:Sys_Check(Admin_Sys_Admin) and Admin_Sys_Admin:AdminStatusCheck() or Admin_System_Global:Sys_Check(Admin_Sys_Admin) then
         if not Admin_Sys_AntiSpam_Net(Admin_Sys_Admin, "Admin_Sys:ZNAdmin", 0.5) then
             return
         end
         local Admin_Sys_Bool = net.ReadBool()
         local Admin_Sys_PlyTp = net.ReadEntity()
         local Admin_Sys_Int = net.ReadUInt(Admin_SysBits)
         local Admin_Sys_OwnerTick = net.ReadEntity()
         if not IsValid(Admin_Sys_PlyTp) then
             return
         end
         local Admin_Sys_NotAvailableZone, Admin_SysPosPly = false, Admin_Sys_PlyTp:GetPos()
         if (Admin_Sys_Int == 1) or (Admin_Sys_Int == 3)then
             Admin_Sys_OwnerTick = Admin_Sys_PlyTp
         end
         local Admin_Sys_AccountAdminID = Admin_Sys_Admin:AccountID()
         if not Admin_System_Global:LevelCheck(Admin_Sys_Admin, Admin_Sys_OwnerTick) then
             return
         end
         local Admin_Sys_OwnID  = Admin_Sys_OwnerTick:AccountID()
         local Admin_Sys_CheckTable = false
         if Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID] and Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID][Admin_Sys_OwnID] then
             for _, v in pairs (Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID][Admin_Sys_OwnID]) do
                 if not (v.Central_Pos or v.Admin_Sys_PlyTp) then
                    continue
                 end
                 if (v.Admin_Sys_PlyTp == Admin_Sys_PlyTp) then
                     Admin_Sys_CheckTable = true
                     break
                 end
             end
         end
         if (Admin_Sys_Bool) then
             local Admin_Sys_Json = util.JSONToTable(file.Read(Admin_System_Global.ZoneAdmin_Save.. "" ..ipr_GM.. "/pos.txt","DATA")) or {}
             local Admin_Sys_JsonNb = #Admin_Sys_Json

             if (Admin_Sys_JsonNb <= 0) then
                 Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_zone_noconfig"].. "" ..Admin_System_Global.ZoneAdmin_Cmd.. "" ..Admin_System_Global.lang["net_zone_console"])
             end
             for i = 1, Admin_Sys_JsonNb do
                 Admin_Sys_NotAvailableZone = false

                 for _, playerpos in pairs( ents.FindInSphere(Admin_Sys_Json[i].Central_PlayerPOS, Admin_System_Global.Admin_System_ZoneAdminSize) ) do
                     if playerpos:IsPlayer() then
                         Admin_Sys_NotAvailableZone = true
                     end
                 end
                 if not (Admin_Sys_NotAvailableZone) then
                     if not Admin_Sys_PlyTp:Alive() then
                         local Admin_Sys_PlyTp = Admin_Sys_PlyTp:GetPos()
 
                         Admin_Sys_PlyTp:Spawn()
                         Admin_Sys_PlyTp:SetPos(Admin_Sys_Pos + Vector(0,10,50))
                     end
                     if Admin_Sys_PlyTp:InVehicle() then
                         Admin_Sys_PlyTp:ExitVehicle()
                     end
                     Admin_Sys_PlyTp:SetPos(Admin_Sys_Json[i].Central_PlayerPOS)
                     Admin_Sys_Admin:SetPos(Admin_Sys_Json[i].Central_PlayerPOS + Vector(0,100,0))
                     Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_zone_pos_text"].. "" ..Admin_Sys_Json[i].Central_NomZone.. "" ..Admin_System_Global.lang["net_zone_pos_lib"])
                     break
                 end
                 if (i == #Admin_Sys_Json) and Admin_Sys_NotAvailableZone then
                     Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_zone_nolib"])
                 end
             end
         else
             if not Admin_Sys_PlyTp:Alive() then
                 local Admin_Sys_Pos = Admin_Sys_PlyTp:GetPos()
                 Admin_Sys_PlyTp:Spawn()
                 Admin_Sys_PlyTp:SetPos(Admin_Sys_Pos + Vector(0,10,50))
             end
             if Admin_Sys_PlyTp:InVehicle() then
                 Admin_Sys_PlyTp:ExitVehicle()
             end
             Admin_Sys_PlyTp:SetPos(Admin_Sys_Admin:GetEyeTrace().HitPos)
         end
         if not Admin_Sys_CheckTable then
             if (Admin_Sys_NotAvailableZone) then
                 return
             end
             Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID] = Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID] or {}
             Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID][Admin_Sys_OwnID] = Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID][Admin_Sys_OwnID] or {}
             Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID][Admin_Sys_OwnID][#Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID][Admin_Sys_OwnID] + 1] = {Admin_Sys_PlyTp = Admin_Sys_PlyTp, Central_Pos = Admin_SysPosPly}
         end
     end
end)
 
net.Receive("Admin_Sys:TP_Reset", function(len, ply)
     local Admin_Sys_Admin = ply
     if not IsValid(Admin_Sys_Admin) then
         return
     end
     local ipr_Check = Admin_System_Global:Sys_Check(Admin_Sys_Admin)
     if Admin_System_Global.Ticket_TakePerm and ipr_Check and Admin_Sys_Admin:AdminStatusCheck() or ipr_Check then
         local Admin_Sys_Int = net.ReadUInt(Admin_SysBits)
         local Admin_Sys_Ply = net.ReadEntity()
         if (Admin_Sys_Int == 3) then
             if not IsValid(Admin_Sys_Ply) or (Admin_Sys_Ply == Admin_Sys_Admin) then
                 Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_notponu"])
                 return
             end
             local Admin_Sys_Pos = Admin_Sys_Ply:GetPos()
             Admin_Sys_Admin:SetPos(Admin_Sys_Pos + Vector(0,50,50))
             return
         end
         local Admin_Sys_AccountAdminID  = Admin_Sys_Admin:AccountID()
         local Admin_Sys_OwnID = Admin_Sys_Ply:AccountID()
         if (Admin_Sys_Int == 1) then
             local ipr_AdPlayer = Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID]
             if (ipr_AdPlayer) and ipr_AdPlayer[Admin_Sys_OwnID] then
                 for _, ad in pairs (ipr_AdPlayer[Admin_Sys_OwnID]) do
                     if not IsValid(ad.Admin_Sys_PlyTp) then
                        continue
                     end
                     Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_retposori"].. "" ..string.upper(ad.Admin_Sys_PlyTp:Nick()) or "Offline")
                     ad.Admin_Sys_PlyTp:SetPos(ad.Central_Pos)
 
                     local ipr_Ac = (ad.Admin_Sys_PlyTp.AccountID) and ad.Admin_Sys_PlyTp:AccountID()
                     if (ipr_Ac) then
                        if (ipr_AdPlayer[ipr_Ac]) then
                            Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID][ipr_Ac] = nil
                        end
                     end
                 end
                 Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_tickcreaown"].. "" ..string.upper(Admin_Sys_Ply:Nick()) or "Offline".. "" ..Admin_System_Global.lang["net_retposorival"])
             else
                 Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_zone_nopossave"])
             end
         elseif (Admin_Sys_Int == 2) then
             if (ipr_AdPlayer) and ipr_AdPlayer[Admin_Sys_OwnID] then
                Admin_Sys_TeleportCheck[Admin_Sys_AccountAdminID][Admin_Sys_OwnID] = nil
             end
         end
     end
end)

net.Receive("Admin_Sys:Restore", function(len, ply)
    local Admin_Sys_Admin = ply

    if IsValid(Admin_Sys_Admin) and Admin_System_Global.Remb_Groupe[Admin_Sys_Admin:GetUserGroup()] then
        local Admin_Sys_ReadUI = net.ReadUInt(3)
        local Admin_Sys_ReadEnt = net.ReadEntity()
        if not IsValid(Admin_Sys_ReadEnt) then
            return
        end
        if not Admin_Sys_ReadEnt:Alive() then
            local ipr_GetPos = Admin_Sys_ReadEnt:GetPos()
            Admin_Sys_ReadEnt:Spawn()
            Admin_Sys_ReadEnt:SetPos(ipr_GetPos)
        end
        local Admin_Sys_ID = Admin_Sys_ReadEnt:AccountID()
        local ipr_TRemb = Admin_Sys_RembTable[Admin_Sys_ID]
        if (ipr_TRemb) then
            local ipr_TRembAll = (Admin_Sys_ReadUI == 0)

            if (Admin_Sys_ReadUI == 2) or (ipr_TRembAll) then
                if isnumber(ipr_TRemb.money) then
                    if ipr_TRemb.money then
                        Admin_Sys_ReadEnt:addMoney(ipr_TRemb.money)
                        ipr_TRemb.money = nil
                    end
                else
                    ipr_TRemb.money = nil
                end
            end
            if (Admin_Sys_ReadUI == 3) or (ipr_TRembAll) then
                if ipr_TRemb.health then
                    if Admin_Sys_ReadEnt:Health() <= ipr_TRemb.health  then
                        Admin_Sys_ReadEnt:SetHealth(ipr_TRemb.health)
                    end
                    ipr_TRemb.health = nil
                end
            end
            if (ipr_TRemb.weapon) then
                if (Admin_Sys_ReadUI == 1) or (ipr_TRembAll) then
                    for _, v in pairs(ipr_TRemb.weapon) do
                        Admin_Sys_ReadEnt:Give(v, false)
                    end
                    ipr_TRemb.weapon = nil
                end
                if (Admin_Sys_ReadUI == 6) then
                    local Admin_Sys_String = net.ReadString()
                    for _, v in pairs(ipr_TRemb.weapon) do
                        if (v ~= Admin_Sys_String) then
                           continue
                        end
                        Admin_Sys_ReadEnt:Give(v, false)
                    end
                    local u = 0
                    for i = 1, #ipr_TRemb.weapon do
                        u = i
                        if ipr_TRemb.weapon[i] == Admin_Sys_String then
                            table.RemoveByValue(ipr_TRemb.weapon, Admin_Sys_String)
                        end
                    end
                    if (u <= 1) then
                        ipr_TRemb.weapon = nil
                    end
                end
            end
            if (Admin_Sys_ReadUI == 4) or (ipr_TRembAll) then
                if ipr_TRemb.model then

                    if ipr_TRemb.model ~= Admin_Sys_ReadEnt:GetModel() then
                        Admin_Sys_ReadEnt:SetModel(ipr_TRemb.model)
                        Admin_Sys_ReadEnt:SetupHands()
                    end
                    ipr_TRemb.model = nil
                end
            end
            if (Admin_Sys_ReadUI == 5) or (ipr_TRembAll) then
                if ipr_TRemb.job then
                    if  ipr_TRemb.job ~= Admin_Sys_ReadEnt:Team() then
                        Admin_Sys_ReadEnt:SetTeam(ipr_TRemb.job)
                        Admin_Sys_ReadEnt:Spawn()
                    end
                    ipr_TRemb.job = nil
                end
            end
            timer.Create("Timer_remb_" ..Admin_Sys_Admin:SteamID(), 0.00001, 1, function()
                if not IsValid(Admin_Sys_Admin) then
                    return
                end
                local Admin_Sys_Count = 0
                if (Admin_Sys_RembTable) and istable(ipr_TRemb) then
                    for k, v in pairs(ipr_TRemb) do
                        Admin_Sys_Count = Admin_Sys_Count + 1
                        if (k == "weapon")  then
                            if table.IsEmpty(v) then
                                ipr_TRemb.weapon = nil
                            end
                        end
                    end
                    if (Admin_Sys_Count <= 1) then
                        ipr_TRemb = nil
                    end
                end
                Admin_Sys_DataRedir(nil, Admin_Sys_Admin)
                local ipr_NotifRemb = (ipr_TRembAll) and Admin_System_Global.lang["net_remb_ply_text_t"] or Admin_System_Global.lang["net_remb_ply_text_c"]
                Admin_System_Global:Notification(Admin_Sys_Admin, Admin_System_Global.lang["net_remb_ply"].. "" ..Admin_Sys_ReadEnt:Name().. "" ..ipr_NotifRemb)
            end)
        end
    end
end)

net.Receive("admin_sys:updatenw", function(len, ply)
    ply:EnabledStatus()
end)

net.Receive("Admin_Sys:ChatAdmin", Admin_Sys_ChatSendData)
net.Receive("Admin_Sys:R_Send_Data", Admin_Sys_DataRedir)
net.Receive("Admin_Sys:Gen_Tick", Admin_Sys_GenTick)
net.Receive("Admin_Sys:Take_Tick", Admin_Sys_TakeTick)