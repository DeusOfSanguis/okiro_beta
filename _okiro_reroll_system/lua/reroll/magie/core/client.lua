local vgui_Create = vgui.Create
local net_Receive = net.Receive

function MagieReroll.OpenMenu()
    local frame = vgui_Create('MagieReroll_Frame')
    return frame
end

net_Receive('MagieReroll_OpenMenu', function()
    MagieReroll.OpenMenu()
end)