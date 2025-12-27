--[[
-----------------------------------------------------------
                    Informations
-----------------------------------------------------------
Ce fichier provient du site web https://aide-serveur.fr/ et a été publié et créé par Autorun__.
Toute forme de revente, de republication, d'envoi à des tiers, etc. est strictement interdite, car cet addon est payant.
Discord : Autorun__
Serveur Discord : Discord.gg/GgH8eKmFpt
-----------------------------------------------------------
--]]

include("sh_config_taxi_teleport.lua")

util.AddNetworkString("TaxiTeleportRequest")
util.AddNetworkString("OpenTaxiMenu")

net.Receive("TaxiTeleportRequest", function(len, ply)
    if TaxiTeleportConfig.ActivateTeleportTaxi then
        for _, v in ipairs(player.GetAll()) do
            if v:getJobTable() and table.HasValue(TaxiTeleportConfig.TaxiJobs, v:getJobTable().name) and v != ply then
                ply:ChatPrint(TaxiTeleportConfig.TaxiInServiceMessage)
                return
            end
        end
    end

    local destIndex = net.ReadInt(32)
    local dest = TaxiTeleportConfig.Destinations[destIndex]

    if not dest then
        ply:ChatPrint("Destination invalide.")
        return
    end

    if ply:getDarkRPVar("money") >= dest.Price then
        if ply:GetUserGroup() != "vip" then
            ply:addMoney(-dest.Price)
        end

        local taxiPos = ply:GetPos()
        local taxiTimerName = ply:SteamID() .. "_TaxiTimer"
        local distanceCheckTimerName = ply:SteamID() .. "_DistanceCheck"

        ply:ChatPrint(TaxiTeleportConfig.Messages.CourseTaken .. dest.Name .. ". " .. TaxiTeleportConfig.Messages.TimeLeftBeforeTeleport .. TaxiTeleportConfig.TimerDelay .. " secondes.")

        timer.Create(taxiTimerName, TaxiTeleportConfig.TimerDelay, 1, function()
            if IsValid(ply) and ply:IsPlayer() then
                -- Fondu d'entrée
                ply:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 1, 2)
                ply:SetPos(dest.Pos)
                ply:SetEyeAngles(dest.Angle)
                ply:ChatPrint(TaxiTeleportConfig.Messages.TeleportedTo .. dest.Name)
            end
            timer.Remove(distanceCheckTimerName)
        end)

        timer.Create(distanceCheckTimerName, 1, 0, function()
            if not IsValid(ply) or not ply:IsPlayer() or ply:GetPos():Distance(taxiPos) > TaxiTeleportConfig.MaxDistance then
                ply:ChatPrint(TaxiTeleportConfig.Messages.TooFarAway)
                
                if ply:GetUserGroup() != "vip" then
                    ply:addMoney(dest.Price)
                end

                timer.Remove(taxiTimerName)
                timer.Remove(distanceCheckTimerName)
                return
            end
        end)

        hook.Add("PlayerDisconnected", taxiTimerName, function(disconnectedPly)
            if ply == disconnectedPly then
                timer.Remove(taxiTimerName)
                timer.Remove(distanceCheckTimerName)
            end
        end)

        hook.Add("PlayerDeath", taxiTimerName, function(deadPly)
            if ply == deadPly then
                timer.Remove(taxiTimerName)
                timer.Remove(distanceCheckTimerName)
            end
        end)
    else
        ply:ChatPrint(TaxiTeleportConfig.Messages.NotEnoughMoney)
    end
end)