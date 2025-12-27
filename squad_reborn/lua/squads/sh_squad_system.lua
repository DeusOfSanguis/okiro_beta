
SQUAD.Groups = SQUAD.Groups or {}
SQUAD.PlyMeta = FindMetaTable("Player")

if SERVER then
    include("server/sv_squad.lua")
end

function SQUAD:Sync()
end

function SQUAD.PlyMeta:GetSquad()
    if (not SQUAD.Groups) then
        SQUAD.Groups = {}
    end

    return SQUAD.Groups[self:GetSquadName()] or nil
end

function SQUAD.PlyMeta:GetSquadName()
    return self._squad or ""
end

function SQUAD.PlyMeta:SameSquad(ply)
    if (ply:GetSquadName() == "") then return false end
    return ply:GetSquadName() == self:GetSquadName()
end

function SQUAD.PlyMeta:GetSquadMembers()
    if (not self:GetSquad()) then return {} end

    return self:GetSquad().Members or {}
end

function SQUAD.PlyMeta:SendTip(msg, icon, time)
    if SERVER then
        net.Start("Squad.SendTip")
        net.WriteString(msg)
        net.WriteInt(icon or 0, 4)
        net.WriteFloat(time or 3)
        net.Send(self)
    else
        notification.AddLegacy(msg, icon, time)
    end
end

net.Receive("Squad.SendTip", function()
    local msg = net.ReadString()
    local icon = net.ReadInt(4)
    local time = net.ReadFloat()
    LocalPlayer():SendTip(msg, icon, time)
end)
