local vgui_Create = vgui.Create
local net_Receive = net.Receive

function MagieReroll.Ranks.OpenMenu()
    local frame = vgui_Create('MagieRanks_Frame')
    return frame
end

net_Receive('MagieRanks_OpenMenu', function()
    MagieReroll.Ranks.OpenMenu()
end)