local PANEL = {}
local matClickAnim = TLib.Mat[ 0 ]

--[[

    PANEL:Init

]]--

function PANEL:Init()
    self.iMargin = TLib:ScaleVGUI()

    self:SetFont( "TLib.Small" )
    self:SetContentAlignment( 5 )

    self.tBgColor = TLib:C( 1 )
    self.tBgHColor = TLib:C( 2 )

    self.tTextColor = TLib:C( 2 )
    self.tTextHColor = TLib:C( 5 )

    self:SetTextColor( self.tTextColor )

    self.tEdgesColor = TLib:SetBrightness( self.tTextHColor, 200 )
    self.fLerpHover = 0
end

--[[

    PANEL:GetBgColor

]]--

function PANEL:GetBgColor()
    return self.tBgColor
end

--[[

    PANEL:SetBgColor
        Params: Background color (color), Background hover color (color)

]]--

function PANEL:SetBgColor( tColor )
    self.tBgColor = tColor
end

--[[

    PANEL:GetBgHoverColor

]]--

function PANEL:GetBgHoverColor()
    return self.tBgHColor
end

--[[

    PANEL:SetBgHoverColor

]]--

function PANEL:SetBgHoverColor( tColor )
    self.tBgHColor = tColor
end

--[[

    PANEL:SetTitleColor
        Params: Text color (color), Text hover color (color)

]]--

function PANEL:SetTitleColor( tColor )
    self.tTextColor = tColor

    if not self:IsHovered() then
        self:SetTextColor( tColor )
    end
end

--[[

    PANEL:SetTitleHoverColor

]]--

function PANEL:SetTitleHoverColor( tColor )
    self.tTextHColor = tColor

    if self:IsHovered() then
        self:SetTextColor( tColor )
    end
end

--[[

    PANEL:SetFontHover

]]--

function PANEL:SetFontHover( sFont )
    if not self.sFontHover then
        self.sFontOG = self:GetFont()
    end

    self.sFontHover = sFont

    if self:IsHovered() then
        self:SetFont( sFont )
    end
end

--[[

    PANEL:DoClickInternal

]]--

function PANEL:DoClickInternal()
    TLib:Play2DSound( "tlib/click_01.mp3" )

    if self.bDrawAnim then
        return
    end

    self.iCursorX, self.iCursorY = self:LocalCursorPos()
    self.fLayerAlpha = 50
    self.fLayerScale = 0
    self.fLayerScaleTo = math.max( self:GetWide(), self:GetTall() )
    self.bDrawAnim = true
end

--[[

    PANEL:Paint

]]--

function PANEL:Paint( iW, iH )
    surface.SetDrawColor( self.tBgColor )
    surface.DrawRect( 0, 0, iW, iH )

    if self.Hovered then
        self.fLerpHover = Lerp( RealFrameTime() * 16, self.fLerpHover, 100 )

        if not self:GetDisabled() and not self.bDisabling then
            self:SetTextColor( self.tTextHColor )
            if self.sFontHover and ( self:GetFont() ~= self.sFontHover ) then
                self:SetFont( self.sFontHover )
            end

            self.bDisabling = true
        end

        local fLerpW = ( ( self.fLerpHover > 99 ) and iW or ( self.fLerpHover * iW / 100 ) )

        surface.SetDrawColor( self.tBgHColor )
        surface.DrawRect( 0, 0, iW, iH )

        surface.SetDrawColor( self.tEdgesColor )
        TLib:DrawEdges( 0, 0, iW, iH, self.iMargin, self.iMargin, ( self.iMargin * .25 ) )
    else
        self.fLerpHover = Lerp( RealFrameTime() * 24, self.fLerpHover, 0 )

        if not self:GetDisabled() and self.bDisabling then
            self:SetTextColor( self.tTextColor )
            if self.sFontOG then
                self:SetFont( self.sFontOG )
            end

            self.bDisabling = nil
        end
    end

    --if ( self.fLerpHover > 1 ) then
        -- local fLerpW = ( ( self.fLerpHover > 99 ) and iW or ( self.fLerpHover * iW / 100 ) )

        -- surface.SetDrawColor( self.tBgHColor )
        -- surface.DrawRect( math.ceil( ( iW - fLerpW ) * .5 ), 0, fLerpW, iH )

        --surface.SetDrawColor( self.tEdgesColor )
        --TLib:DrawEdges( 0, 0, iW, iH, ( self.fLerpHover * self.iMargin / 100 ), ( self.fLerpHover * self.iMargin / 100 ), ( self.fLerpHover * ( self.iMargin * .25 ) / 100 ) )
    --end

    if self.bDrawAnim then
        self.fLayerAlpha = Lerp( RealFrameTime() * 8, self.fLayerAlpha, 0 )
        self.fLayerScale = Lerp( RealFrameTime() * 8, self.fLayerScale, self.fLayerScaleTo * 2 )
 
        surface.SetDrawColor( ColorAlpha( TLib:C( 5 ), self.fLayerAlpha ) )
        surface.SetMaterial( matClickAnim )
        surface.DrawTexturedRectRotated( self.iCursorX, self.iCursorY, self.fLayerScale, self.fLayerScale, 0 )

        if ( self.fLayerAlpha < 1 ) then
            self.iCursorX, self.iCursorY = nil, nil
            self.fLayerAlpha, self.fLayerScale, self.fLayerScaleTo  = nil, nil, nil
            self.bDrawAnim = nil
        end
    end
end

-- Register VGUI element
vgui.Register( "TLButton", PANEL, "DButton" )
PANEL = nil