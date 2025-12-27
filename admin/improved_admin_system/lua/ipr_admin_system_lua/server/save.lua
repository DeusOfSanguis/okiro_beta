---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

local ipr_GM = game.GetMap()

if not file.Exists(Admin_System_Global.ZoneAdmin_Save.. "" ..ipr_GM, "DATA") then
    file.CreateDir(Admin_System_Global.ZoneAdmin_Save.. "" ..ipr_GM)
end
if not file.Exists(Admin_System_Global.ZoneAdmin_Save.. "" ..ipr_GM.. "/pos.txt", "DATA") then
    file.Write(Admin_System_Global.ZoneAdmin_Save.. "" ..ipr_GM.. "/pos.txt", "[]")
end
if not file.Exists(Admin_System_Global.Stats_Save, "DATA") then
    file.CreateDir(Admin_System_Global.Stats_Save)
end
if not file.Exists(Admin_System_Global.Stats_Save.. "rating.json", "DATA") then
    file.Write(Admin_System_Global.Stats_Save.. "rating.json", "[]")
end

if (Admin_System_Global.Admin_System_Ressource == 1) then
    resource.AddWorkshop("2250503116")
elseif (Admin_System_Global.Admin_System_Ressource == 2) then
    resource.AddFile( "resource/fonts/Rajdhani-Bold.ttf" )
    resource.AddFile( "resource/fonts/Rajdhani-Medium.ttf" )
end

if (Admin_System_Global.Admin_System_Save == 1) then
    if not file.Exists(Admin_System_Global.Stats_Save .. "sv.json", "DATA") then
        file.Write(Admin_System_Global.Stats_Save .. "sv.json", "[]")
    end
elseif (Admin_System_Global.Admin_System_Save == 2) then
    if (sql.TableExists("Improved_Ticket_System")) then
        local Admin_Sys_SQlite_TickQuery = sql.QueryValue("SELECT Central_Grp from Improved_Ticket_System")
        
        if not (Admin_Sys_SQlite_TickQuery) then
            sql.Query("ALTER TABLE Improved_Ticket_System ADD Central_Grp varchar(20)")
        end
        Msg("Improved Admin System Stats SQlite chargé avec succès !")
    else
        sql.Query("CREATE TABLE Improved_Ticket_System (Central_SteamID varchar(20), Central_Admin varchar(20), Central_Horodatage INTEGER, Central_NumbTicket INTEGER, Central_Grp varchar(20))")
    end

    if (sql.TableExists("Improved_Ticket_Rating")) then
        Msg("Improved Admin System Rate SQlite chargé avec succès !")
    else
        sql.Query("CREATE TABLE Improved_Ticket_Rating (Central_SteamID varchar(20), Central_Target varchar(20), Central_Note varchar(20))")
    end
end