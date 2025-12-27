local draw = draw
local surface = surface

local PANEL = {}
local matPlaceholder = TLib.Mat[ 5 ]

--[[

    PANEL:Init

]]--

function PANEL:Init()
    self.iMargin, self.iRoundness = TLib:ScaleVGUI()

    self:SetFont( "TLib.Small" )
    self:SetDrawLanguageID( false )
    self:SetPaintBackground( false )

    self:SetTextColor( TLib:C( 2 ) )
    self:SetCursorColor( TLib:C( 2 ) )
    self:SetHighlightColor( TLib:C( 2 ) )

    self.tBgColor = TLib:C( 1 )
    self.tFocusColor = TLib:C( 5 )
    self.tUnfocusColor = TLib:C( 2 )
end

--[[

    PANEL:OnGetFocus

]]--

function PANEL:OnGetFocus()
    self:SetTextColor( self.tFocusColor )
end

--[[

    PANEL:OnLoseFocus

]]--

function PANEL:OnLoseFocus()
    self:SetTextColor( self.tUnfocusColor )
end

--[[

    PANEL:IsPlaceholderVisible

]]--

function PANEL:IsPlaceholderVisible()
    if not self:HasFocus() and ( self:GetText() == "" ) and self.m_txtPlaceholder then
        return true
    end
end

--[[

    PANEL:Init

]]--

function PANEL:Paint( iW, iH )
    draw.RoundedBox( self.iRoundness, 0, 0, iW, iH, self.tBgColor )
    draw.RoundedBox( self.iRoundness, 1, 1, iW - 2, iH - 2, TLib:C( 0 ) )

    self:DrawTextEntryText( self.m_colText, self.m_colHighlight, self.m_colCursor )

    if not self:IsPlaceholderVisible() then
        return
    end

    if not self.iIconH then
        self.iIconH = ( draw.GetFontHeight( self:GetFont() ) * .8 )
        return
    end

    self.iOffset = ( self.iOffset or math.ceil( ( iH - self.iIconH ) * .5 ) )

    self.fLerpOffset = ( self.fLerpOffset or -iW ) 
    self.fLerpOffset = Lerp( RealFrameTime() * 6, self.fLerpOffset, self.iOffset )

    surface.SetDrawColor( self.tUnfocusColor )
    surface.SetMaterial( matPlaceholder )
    surface.DrawTexturedRect( self.fLerpOffset, self.iOffset, self.iIconH, self.iIconH )

    draw.SimpleText( self.m_txtPlaceholder, self:GetFont(), self.iIconH + self.fLerpOffset + ( self.iOffset * .5 ), math.ceil( iH * .5 ), self.tUnfocusColor, 0, 1 )
end

-- Register VGUI element
vgui.Register( "TLTextEntry", PANEL, "DTextEntry" )
PANEL = nil
