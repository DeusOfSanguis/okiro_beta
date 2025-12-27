---- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

local ipr_VNet = {}
ipr_VNet.R = Admin_System_Global:ReturnNw()
ipr_VNet.M = FindMetaTable("Player")

local function ipr_CreateNwValue(p)
    ipr_VNet.R[p] = {}
    ipr_VNet.R[p].Statut = false

    net.Start("admin_sys:sendnw")
    local ipr_Count = table.Count(ipr_VNet.R)
    net.WriteUInt(ipr_Count, 7)
    for pl, v in pairs(ipr_VNet.R) do
        if not IsValid(pl) then
            continue
        end
        net.WriteEntity(pl)
        net.WriteBool(v.Statut)
    end
    net.Send(p)
end
    
function ipr_VNet.M:UpdateNw(b, i, c)
    if (i ~= 0) then
        if not ipr_VNet.R[self] then
           ipr_CreateNwValue(self)
        else
            ipr_VNet.R[self].Statut = b
        end
    else
        if (ipr_VNet.R[self]) then
            ipr_VNet.R[self] = nil
        end
    end
    
    for p in pairs(ipr_VNet.R) do
        if not IsValid(p) or (c) and (p == self) then
           continue
        end

        net.Start("admin_sys:updatenw")
        net.WriteUInt(i, 1)
        net.WriteEntity(self)
        net.WriteBool(b)
        net.Send(p)
    end
end

hook.Add("PlayerInitialSpawn","Admin_Sys:InitSpawn_Nw", function(ply)
    timer.Simple(1, function()
        if not IsValid(ply) then
            return
        end
        if not Admin_System_Global:Sys_Check(ply) then
            return
        end

        ply:UpdateNw(false, 1, true)
    end)
end)

hook.Add("PlayerDisconnected","Admin_Sys:Ply_Disconnected_NW",function(ply)
    if not ipr_VNet.R[ply] then
        return
    end
    
    ply:UpdateNw(false, 0)
end)