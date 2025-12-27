local tUnknownData = {}

net.Receive("Okiro:Unknown:AllFriends", function()

    tUnknownData = net.ReadTable()
    PrintTable(tUnknownData)

end)

hook.Add("PostDrawOpaqueRenderables", "Okiro:Unknown:HeadText", function()

    local vPos = LocalPlayer():GetPos()
    local pPlayer = LocalPlayer()

    for k, v in pairs(player.GetAll()) do

        if v:GetPos():DistToSqr(vPos) < 10000 and v:Alive() and v != pPlayer then

            cam.Start3D2D(v:GetPos() + Vector(0, 0, 82 + (math.sin(CurTime() * 2 ) * 1.5)), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.2)

                if table.HasValue(tUnknownData, v:SteamID64()) then

                    draw.SimpleText(v:Nick(), "Presentation:Text", 0, 0, color_white, TEXT_ALIGN_CENTER)

                else

                    draw.SimpleText("???", "Presentation:Text", 0, 0, Color(255, 255, 255, 50), TEXT_ALIGN_CENTER)

                end

            cam.End3D2D()

        end

    end

end)

hook.Add("PlayerButtonDown", "Okiro:Unknown:ButtonDown", function(ply, button)

    if button != KEY_P then return end

    if CLIENT and not IsFirstTimePredicted() then return end

    local vTr = util.TraceLine( util.GetPlayerTrace( ply ) )

    PrintTable(vTr)

    net.Start("Okiro:Unknown:SendRequest")
        net.WriteEntity(vTr.Entity)
    net.SendToServer()

end)