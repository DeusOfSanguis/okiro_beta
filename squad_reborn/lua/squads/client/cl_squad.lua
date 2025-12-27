local outlines = CreateConVar("squad_outlines", 0, FCVAR_ARCHIVE, "Show outlines trhough walls")

hook.Add("PreDrawHalos", "Squad.DoHalos", function()
    if (outlines:GetInt() > 0 and LocalPlayer():GetSquadName() ~= "") then
        for k, v in pairs(LocalPlayer():GetSquadMembers()) do
            if (v ~= LocalPlayer() and IsValid(v)) then
                halo.Add({v}, Color(v:GetPlayerColor().x * 255, v:GetPlayerColor().y * 255, v:GetPlayerColor().z * 255), 2, 2, 1, v:GetPlayerColor():Length() > 0.15, true)
            elseif (not IsValid(v)) then
                table.RemoveByValue(SQUAD.Groups[LocalPlayer():GetSquadName()].Members,v)
                return
            end
        end
    end
end)

net.Receive("Squad.ForceRemove", function()
    local ent = net.ReadEntity()
    ent._squad = nil
    ent._squadLeader = nil

    if (IsValid(squad_window)) then
        squad_window:Recreate()
    end
end)

net.Receive("Squad.QuickSyncGroups", function()
    local delta = net.ReadString( )
    local name = net.ReadString()
    local creator = net.ReadEntity()
    local memberI = net.ReadInt(8)

    if (not SQUAD.Groups[delta]) then
        SQUAD.Groups[delta] = {}
    end

    SQUAD.Groups[delta].Members = {}
    SQUAD.Groups[delta].Name = name
    SQUAD.Groups[delta].Creator = creator
    creator._squadLeader = true

    for k = 1, memberI do
        local ply = net.ReadEntity()
        ply._squad = delta
        SQUAD.Groups[delta].Members[k] = ply
    end

    for k, v in pairs(player.GetAll()) do
        if (IsValid(v.AvatarImage)) then
            v.AvatarImage:Remove()
        end
    end

end)

net.Receive("Squad.SyncGroups", function()
    local delta = net.ReadString()

    if (delta ~= "") then
        SQUAD.Groups[delta] = net.ReadTable()
        for k, v in pairs(player.GetAll()) do
            if (v._squad == delta and not table.HasValue(SQUAD.Groups[delta].Members,v)) then
                v._squad = nil
                v._squadLeader = nil
            end
        end
    else
        SQUAD.Groups = net.ReadTable()
    end

    for tag, group in pairs(SQUAD.Groups or {}) do
        if (not istable(group)) then continue end
        for _, member in pairs(group.Members or {}) do
            member._squad = tag

            if (group.Creator == member) then
                member._squadLeader = true
            end
        end
    end

    if (not LocalPlayer():IsValid()) then return end

    if ((LocalPlayer():GetSquadName() or "") == delta and not table.HasValue(LocalPlayer():GetSquadMembers(), LocalPlayer())) then
        LocalPlayer()._squad = nil
        LocalPlayer()._squadLeader = nil
    end

    for k, v in pairs(player.GetAll()) do
        if (IsValid(v.AvatarImage)) then
            v.AvatarImage:Remove()
        end
    end

    if (IsValid(squad_window)) then
        squad_window:Recreate()
    end
end)

net.Receive("Squad.AssignGroup", function()
    LocalPlayer()._squad = net.ReadString()
    LocalPlayer()._squadLeader = net.ReadBool()
end)

net.Receive("Squad.PurgeGroup", function()
    local tag = net.ReadString()
    LocalPlayer()._squad = LocalPlayer()._squad == tag and "" or LocalPlayer()._squad
    SQUAD.Groups[tag] = nil
end)

net.Receive("Squad.SendMessage", function()
    local txt = net.ReadString()
    local ent = net.ReadEntity()
    chat.AddText(Color(155, 89, 182), "(", string.upper(ent:GetSquadName()), ") ", team.GetColor(ent:Team()), ent:Nick(), color_white, ": ", txt)
end)

net.Receive("Squad.SendInvitation", function()
    local trg = net.ReadEntity()
    if _invitation then
        _invitation:Remove()
        _invitation = nil
    end
    _invitation = vgui.Create("dSquadInvitation")
    _invitation:SetPlayer(trg, net.ReadString())
end)

net.Receive("Squad.FailedJoin", function()
    local reason = net.ReadInt(8)

    if (reason == 1) then
        reason = " " .. SQUAD.Language.MaxMembers
    end

    chat.AddText(Color(235, 100, 50), "[SQUAD]", color_white, reason)
end)

hook.Add("PlayerStartVoice", "Squad.SenseVoice", function(ply)
    if (ply:GetSquad() ~= "" and ply:GetSquad() == LocalPlayer():GetSquad()) then
        ply.DoingVoice = true
    end
end)

hook.Add("PlayerEndVoice", "Squad.SenseVoice", function(ply)
    if (ply:GetSquad() ~= "" and ply:GetSquad() == LocalPlayer():GetSquad()) then
        ply.DoingVoice = false
    end
end)

hook.Add( "PlayerButtonDown" , "Squad.BringMenu.Down" , function( ply , key )
    if ( key == SQUAD.Config.KeyBringSquadMenu ) then
        if (IsValid(squad_window)) then
            squad_window:GetParent():Remove()
        end

        squad_window_frame = vgui.Create("DFrame")
        squad_window_frame:SetSize(600,500)
        squad_window_frame:Center()
        squad_window_frame:MakePopup()

        if ( LocalPlayer( )._squad ~= "" ) then
            squad_window = vgui.Create( "dSquadPanel" , squad_window_frame )
        else
            squad_window_frame.Paint = function( ) end
            net.Start( "Squad.Verify" )
            net.WriteString( LocalPlayer( )._squad or "" )
            net.SendToServer( )
        end
    end
end )

concommand.Add("squad_create", function(_, _, args)
    net.Start("Squad.CreateSquad")
    net.WriteString(args[1])
    net.WriteString(args[2])
    net.SendToServer()
end)

concommand.Add("squad_exit", function()
    net.Start("Squad.ExitSquad")
    net.SendToServer()
end)

concommand.Add("squad_invite", function(_, _, args)
    net.Start("Squad.InviteSquad")
    net.WriteString(args[1])
    net.SendToServer()
end)
