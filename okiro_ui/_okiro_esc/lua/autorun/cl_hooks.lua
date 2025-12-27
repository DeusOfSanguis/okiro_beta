hook.Add("PreRender", "esss", function()
    if not IsValid(esc.menu) and gui.IsGameUIVisible() then
        if gui.IsConsoleVisible() then return end 
        vgui.Create("esc")
    end
end)