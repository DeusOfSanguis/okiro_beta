TLib.tNotifPanels = ( TLib.tNotifPanels or {} )
local tPlayedSounds = {}

--[[-------------------------------------------------------------------------------------------------------------------------

    NOTIFY FUNCTIONS

-------------------------------------------------------------------------------------------------------------------------]]--

--[[

    TLib:Notify

]]--

function TLib:Notify( sNotif, iType, iLen )
    local dNotif = vgui.Create( "TLNotify" )
    if not IsValid( dNotif ) then
        return
    end

    dNotif:SetText( string.Trim( sNotif or "" ) )
    dNotif:SetNotificationType( ( iType or 0 ) )
    dNotif:SetNotificationTime( ( iLen or 3 ) )
    dNotif:SetNotificationLayout()

    table.insert( self.tNotifPanels, dNotif )
end

-- Override all notifs with TLib's notifs
if TLib.Cfg.OverrideGMNotifs then
    function notification.AddLegacy( sNotif, iType, iLen )
        return TLib:Notify( sNotif, iType, iLen )
    end
end

--[[-------------------------------------------------------------------------------------------------------------------------

    SOUND RELATED FUNCTIONS

-------------------------------------------------------------------------------------------------------------------------]]--

--[[

    TLib:Get2DSound
        Params: Sound ID (number)
        Return: Sound object (CSound)

]]--

function TLib:Get2DSound( iID )
    return tPlayedSounds[ iID ]
end

--[[

    TLib:Stop2DSound
        Params: Sound ID (number) {If no ID is passed all 2D sounds will be stopped}
        Return: Success (boolean)

]]--

function TLib:Stop2DSound( iID )
    if not iID then
        for k, v in ipairs( tPlayedSounds ) do
            v:Stop()
        end

        tPlayedSounds = {}
        return true
    end

    local CSound = self:Get2DSound( iSound )
    if not CSound then
        return
    end

    CSound:Stop()
    return true
end

--[[

    TLib:Play2DSound
        Desc: Plays a sound locally, can handle up to TLib.Cfg.Max2DSounds sounds at the same time
        Params: Sound path (string), Volume (number)
        Return: {On fail: nil, On sucess: Sound object (CSound), Sound ID (number)}

]]--

function TLib:Play2DSound( sPath, iVolume )
    if not sPath or not isstring( sPath ) or not IsValid( LocalPlayer() ) then
        return
    end

    local iCount = table.Count( tPlayedSounds )
    local iSound = math.Clamp( ( iCount + 1 ), 1, ( self.Cfg.Max2DSounds + 1 ) )

    if ( iSound > self.Cfg.Max2DSounds ) then
        iSound = 1
    end

    local CSound = self:Get2DSound( iSound )
    if CSound then
        CSound:Stop()
    end

    CSound = CreateSound( LocalPlayer(), ( sPath or "" ) )
    CSound:PlayEx( ( iVolume or 1 ), 100 )

    tPlayedSounds[ iSound ] = CSound

    return CSound, iSound
end

--[[

    TLib:DrawStencilMask
        Desc: function that allows you to remove the entire stencil part to focus only on drawing the mask and its contents.
        Params: fcMask (function), fcRender (function), bInvert (boolean)

]]--

function TLib:DrawStencilMask(fcMask, fcRender, bInvert)

    if not isfunction(fcMask) or not isfunction(fcRender) then return end

    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
    render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    fcMask()

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(bInvert and STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
    render.SetStencilFailOperation(STENCILOPERATION_KEEP)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(bInvert and 0 or 1)

    fcRender()

    render.SetStencilEnable(false)
    render.ClearStencil()

end

--[[

    TLib:DrawCircle
        Desc: Draw a simple Circle.
        Params: x (number), y (number), iRadius (number), iSeg (number)

]]--

function TLib:DrawCircle(x, y, iRadius, iSeg)

    local tCircle = {}

    for i = 1, iSeg do

        local iRad = math.rad((i / iSeg) * -360)

        table.insert(tCircle, {

            x = x + math.sin(iRad) * iRadius,
            y = y + math.cos(iRad) * iRadius

        })

    end

    surface.DrawPoly(tCircle)

end