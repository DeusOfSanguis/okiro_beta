local function loadSH( sPath )
    if SERVER then
        AddCSLuaFile( "tlib/" .. sPath )
        include( "tlib/" .. sPath )
    end

    if CLIENT then
        include( "tlib/" .. sPath )
    end
end

local function loadSV( sPath )
    if SERVER then
        include( "tlib/" .. sPath )
    end
end

local function loadCL( sPath, bAddOnly )
    if SERVER then
        AddCSLuaFile( "tlib/" .. sPath )
    end
    if CLIENT and not bAddOnly then
        include( "tlib/" .. sPath )
    end
end

--[[

     Init file loading

]]--

if TLib then
    loadSH, loadSV, loadCL = nil, nil, nil
    return
end

if SERVER then
    MsgC( Color( 0, 255, 0 ), "\n[TLib] ", color_white, "Initialization...\n" )
end

loadSH( "shared/init.lua" )
loadSH( "config.lua" )

-- local sLang = ( TLib.Cfg.Language or "en" )
-- loadSH( "shared/i18n/" .. sLang .. ".lua" )

-- if SERVER then
--     MsgC( Color( 0, 255, 0 ), "[TLib] ", color_white, "Language set to " .. string.upper( sLang ) .. "\n" )
-- end

loadSH( "shared/util.lua" )
loadSH( "shared/functions.lua" )

loadSV( "server/init.lua" )
loadSV( "server/util.lua" )
loadSV( "server/functions.lua" )
loadSV( "server/commands.lua" )

loadCL( "client/init.lua" )
loadCL( "client/util.lua" )
loadCL( "client/functions.lua" )

loadCL( "client/derma/frame.lua" )
loadCL( "client/derma/button.lua" )
loadCL( "client/derma/checkbox.lua" )
loadCL( "client/derma/combobox.lua" )
loadCL( "client/derma/notify.lua" )
loadCL( "client/derma/scroll.lua" )
loadCL( "client/derma/textentry.lua" )
loadCL( "client/derma/toast.lua" )
loadCL( "client/derma/test.lua" )

-- Clear cached funcs
loadSH, loadSV, loadCL = nil, nil, nil

-- TLib is loaded at this point
hook.Run( "OnTLibLoaded" )

if SERVER then
    MsgC( Color( 0, 255, 0 ), "[TLib] ", color_white, "Successfully loaded TLib!\n\n" )
end