local draw = draw
local surface = surface

-- Static vars
NOTIFY_GENERIC	= ( NOTIFY_GENERIC or 0 )
NOTIFY_ERROR	= ( NOTIFY_ERROR or 1 )
NOTIFY_UNDO		= ( NOTIFY_UNDO or 2 )
NOTIFY_HINT		= ( NOTIFY_HINT or 3 )
NOTIFY_CLEANUP	= ( NOTIFY_CLEANUP or 4 )

local PANEL = {}
local iMargin = 0
local iRoundness = 0

local tBgColor = TLib:C( 0 )
local tTextColor = TLib:C( 5 )
local tShadowColor = TLib:C( 7 )

-- Notif types materials
local tTypeMaterial = {
    [ 0 ] = Material( "tlib/notify_generic.png", "smooth" ),
    [ 1 ] = Material( "tlib/notify_error.png", "smooth" ),
    [ 2 ] = Material( "tlib/notify_undo.png", "smooth" ),
    [ 3 ] = Material( "tlib/notify_hint.png", "smooth" ),
    [ 4 ] = Material( "tlib/notify_cleanup.png", "smooth" )
}

-- Notif types colors
local tTypeColors = {
    [ 0 ] = TLib:C( 3 ),
    [ 1 ] = TLib:C( 4 ),
    [ 2 ] = TLib:C( 3 ),
    [ 3 ] = TLib:C( 3 ),
    [ 4 ] = Color( 52, 152, 219 )
}

--[[

    PANEL:Paint

]]--

function PANEL:Init()
    iMargin, iRoundness = TLib:ScaleVGUI()
    iMargin = iMargin

    self.iType = 0

    self:SetFont( "TLib.Standard" )
    self:SetTextColor( tTextColor )
    self:ParentToHUD()
end

--[[

    PANEL:Paint

]]--


function PANEL:SetNotificationLayout()
    self:SetText( string.gsub( self:GetText(), "\n", "" ) )
    self:SizeToContents()

    local iNotifH = ( draw.GetFontHeight( self:GetFont() ) ) + ( iMargin * .75 )   
    local iNotifW = ( self:GetWide() + iNotifH + ( iMargin * 2 ) )
    local iNotifX = ( ( ScrW() - iNotifW ) - iMargin )
    local iNotifY = ( ScrH() - ( iNotifH * 4 ) )

    self:SetSize( iNotifW, iNotifH )
    self:SetTextInset( ( iNotifH + iMargin ), -1 )
    self:SetPos( ScrW(), iNotifY - ( table.Count( TLib.tNotifPanels ) * ( iNotifH + iMargin ) ) )

    self.iEndX = iNotifX
    if not self.iEndY then
        local _, iPosY = self:GetPos()
        self.iEndY = iPosY
    end

    self.fIconH = math.ceil( iNotifH * .56 ) - 2

    self.fIconX = -iNotifH
    self.fLerpIconX = self.fIconX

    self:MoveTo( self.iEndX, self.iEndY, .1, 0, 1, function()
        if IsValid( self ) then
            self.iEndX = nil
            self.iEndY = nil
            self.fIconX = ( iMargin + ( iNotifH  * .5 ) )

            TLib:Play2DSound( "tlib/notify_01.mp3", .6 )
        end
    end )

    function self:OnRemove()
        local iProccessedNotif = -1
        for iPanel, dPanel in pairs( TLib.tNotifPanels ) do
            if not IsValid( dPanel )  then
                TLib.tNotifPanels[ iPanel ] = nil
                continue
            end

            iProccessedNotif = ( iProccessedNotif + 1 )

            dPanel.iEndY = iNotifY - ( iProccessedNotif * ( iNotifH + iMargin ) )
            if not dPanel.iEndX then
                dPanel.iEndX = dPanel:GetPos()
            end

            dPanel:MoveTo( dPanel.iEndX, dPanel.iEndY, .1, 0, 1, function()
                if IsValid( dPanel ) then
                    dPanel.iEndX, dPanel.iEndY = nil, nil
                end
            end )
        end
    end

    self.bLayoutReady = true
end

--[[

    PANEL:SetNotificationType

]]--

function PANEL:SetNotificationType( iType )
    local iType = iType
    if not iType or not tTypeMaterial[ iType ] then
        iType = 0
    end

    self.tColor = tTypeColors[ iType ]
    self.iMaterial = tTypeMaterial[ iType ]    
end

--[[

    PANEL:SetNotificationTime

]]--

function PANEL:SetNotificationTime( fTime )
    self.fNotifTime = math.Clamp( ( fTime or 3 ), 1, 63 )
    self.fEndTime = ( CurTime() + self.fNotifTime )
end

--[[

    PANEL:Paint

]]--

function PANEL:Paint( iW, iH )
    if not self.bLayoutReady then
        return
    end

    self.fLerpIconX = Lerp( RealFrameTime() * 8, self.fLerpIconX, self.fIconX )
    local iProgW = ( ( self.fEndTime - CurTime() ) * ( iW - iMargin ) / self.fNotifTime )

    surface.SetDrawColor( tBgColor )
    surface.DrawRect( iMargin, 0, ( iW - iMargin ), iH )

    surface.SetDrawColor( TLib:C( 2 ) )
    surface.SetMaterial( self.iMaterial )
    surface.DrawTexturedRectRotated( self.fLerpIconX, ( iH * .5 ) - 1, self.fIconH, self.fIconH, 0 )

    draw.RoundedBoxEx( iRoundness, 0, 0, iMargin, iH, self.tColor, true, false, true, false )

    surface.SetDrawColor( tShadowColor )
    surface.SetMaterial( TLib.Mat[ 3 ] )
    surface.DrawTexturedRect( iMargin, 0, ( iW - iMargin ), iH - 2 )

    surface.SetDrawColor( self.tColor )
    surface.DrawRect( iMargin, iH - 2, iProgW, 2 )
end

--[[

    PANEL:Think

]]--

function PANEL:Think()
    if not self.fEndTime then
        return
    end

    if not self.bRemoving and ( CurTime() >= self.fEndTime ) then
        self.bRemoving = true

        local _, iY = self:GetPos()

        self:SetZPos( 0 )
        self:AlphaTo( 0, 3, .1 )
        self:MoveTo( ScrW(), iY, .2, .1, .5, function()
            if IsValid( self ) then
                self:Remove()
            end
        end )
    end
end

-- Register VGUI element
vgui.Register( "TLNotify", PANEL, "DLabel" )
PANEL = nil