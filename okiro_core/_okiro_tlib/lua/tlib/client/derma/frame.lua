local draw = draw
local surface = surface

local PANEL = {}

--[[

    PANEL:Init

]]--

function PANEL:Init()
    self.iMargin, self.iRoundness = TLib:ScaleVGUI()

    self.tBgColor = TLib:C( 0 )
    self.tHeaderColor = TLib:C( 1 )
    self.tTextColor = TLib:C( 5 )
    self.tShadowColor = TLib:C( 7 )

    self.bBgBlur = true
    self.bBgShadow = true
    self.iHeaderH = math.ceil( ScrH() * .04 )
    self.fSysTime = SysTime()

    self.bInitialized = true

    self:ShowCloseButton( true )
end

--[[

    PANEL:GetHeaderHeight
        Return: Panel's header height

]]--

function PANEL:GetHeaderHeight()
    return ( self.iHeaderH or 0 )
end

--[[

    PANEL:SetBgBlur
        Params: Enable background blur (boolean) {default: true} 

]]--

function PANEL:SetBgBlur( bBgBlur )
    self.bBgBlur = tobool( bBgBlur )
end

--[[

    PANEL:SetDrawShadow
        Params: Enable background shadow (boolean) {default: true} 

]]--

function PANEL:SetBgShadow( bShadow )
    self.bBgShadow = tobool( bShadow )
end

--[[

    PANEL:SetHeader
        Params: Header title (string) {nil to disable header} [, Header height (number) {default: Auto}, Title font (string) {default: "TLib.Subtitle"}]

]]--

function PANEL:SetHeader( sTitle, sSubtitle, sTitleFont, sSubtitleFont )
    if not sTitle then
        self.sTitle = nil

        if IsValid( self.dHeader ) then
            self.dHeader:Remove()
            self.dHeader = nil
        end

        if IsValid( self.dClose ) then
            self:ShowCloseButton( true )
        end

        return
    end

    self.sTitle = sTitle
    self.sSubtitle = ( sSubtitle and sSubtitle or nil )

    local dPanel = self
    local sTitleFont = ( sTitleFont or "TLib.Title" )
    local sSubtitleFont = ( sSubtitleFont or "TLib.Standard" )

    surface.SetFont( sTitleFont )
    local _, iTextH = surface.GetTextSize( sTitle )
    self.iHeaderH = ( iTextH + self.iMargin )

    if self.sSubtitle then
        surface.SetFont( sSubtitleFont )
        _, iTextH = surface.GetTextSize( sSubtitleFont )

        self.iHeaderH = ( self.iHeaderH + iTextH )
    end

    self.dHeader = vgui.Create( "DPanel", self )
    self.dHeader:SetSize( self:GetWide(), self.iHeaderH )    
    self.dHeader:SetZPos( 50 )

    local iShadowH = math.ceil( self.iHeaderH - ( self.iMargin * .5 ) )
    local iMargin, iRoundness = dPanel.iMargin, dPanel.iRoundness

    function self.dHeader:Paint( iW, iH )
        if not dPanel.bInitialized then
            return
        end

        draw.RoundedBoxEx( iRoundness, 0, 0, iW, iH, dPanel.tHeaderColor, true, true, false, false )

        surface.SetDrawColor( dPanel.tShadowColor )
        surface.SetMaterial( TLib.Mat[ 3 ] )
        surface.DrawTexturedRect( 0, ( iH - iShadowH - 1 ), iW, iShadowH )

        if dPanel.sSubtitle then
            draw.SimpleText( dPanel.sTitle, sTitleFont, iMargin, ( iH * .35 ), dPanel.tTextColor, 0, 1 )
            draw.SimpleText( dPanel.sSubtitle, sSubtitleFont, iMargin, ( iH * .65 ), dPanel.tTextColor, 0, 1 )
        else
            draw.SimpleText( dPanel.sTitle, sTitleFont, iMargin, ( iH * .5 ), dPanel.tTextColor, 0, 1 )
        end
    end

    if IsValid( self.dClose ) then
        self:ShowCloseButton( true )
    end
end

--[[

    PANEL:ShowCloseButton
        Params: Enable close button (boolean) {default: true}

]]--

function PANEL:ShowCloseButton( bShow )
    if IsValid( self.dClose ) then
        self.dClose:Remove()
        self.dClose = nil
    end

    if not bShow then
        return
    end

    local dPanel = self
    local dParent = ( IsValid( self.dHeader ) and self.dHeader or self )

    self.dClose = vgui.Create( "DButton", dParent )
    self.dClose:SetSize( self.iHeaderH, self.iHeaderH )
    self.dClose:SetPos( ( dParent:GetWide() - self.dClose:GetWide() ) - self.iMargin, 0 )
    self.dClose:SetText( "✖" )
    self.dClose:SetFont( "TLib.Small" )
    self.dClose:SetTextColor( TLib:C( 2 ) )
    self.dClose:SetTextInset( -1, 0 )
    self.dClose:SetContentAlignment( 6 )
    self.dClose:SetZPos( 49 )
    self.dClose.Paint = nil

    -- Close button: On start hover
    function self.dClose:OnCursorEntered()
        self:SetTextColor( TLib:C( 4 ) )
    end

    -- Close button: On stop hover
    function self.dClose:OnCursorExited()
        self:SetTextColor( TLib:C( 2 ) )
    end

    -- Close button: On click
    function self.dClose:DoClickInternal()
        TLib:Play2DSound( "tlib/click_02.mp3" )

        local iX, iY = dPanel:GetPos()
        dPanel:MoveTo( iX, ScrH(), .3, 0, .3, function()
            if IsValid( dPanel ) then
                dPanel:Remove()
            end
        end )
    end
end

--[[

    PANEL:Paint

]]--

function PANEL:Paint( iW, iH )  
    if not self.bInitialized then
        return
    end

    -- Background shadow
    if self.bBgShadow then
        DisableClipping( true )
            draw.RoundedBox( self.iRoundness, 1, 1, iW, iH, self.tShadowColor )
        DisableClipping( false )
    end

    -- Background blue
    if self.bBgBlur then
        Derma_DrawBackgroundBlur( self, self.fSysTime )
    end

    draw.RoundedBox( self.iRoundness, 0, 0, iW, iH, self.tBgColor )
end

-- Register VGUI element
vgui.Register( "TLFrame", PANEL, "DFrame" )
PANEL = nil