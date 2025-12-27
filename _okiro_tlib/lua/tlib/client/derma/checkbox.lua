local PANEL = {}

--[[

    PANEL:Paint

]]--

function PANEL:Init()
    self.tBgColor = TLib:C( 1 )
    self.tCheckedColor = TLib:C( 6 )
    self.tUncheckedColor = TLib:C( 2 )

    if self:GetChecked() then
    	self.fLerpX = ( self:GetWide() - self:GetTall() )
        return
    end
    
    self.fLerpX = 0
end

function PANEL:DoClickInternal()
    TLib:Play2DSound( "tlib/click_01.mp3" )
end

--[[

    PANEL:SetBgColor

]]--

function PANEL:SetBgColor( tColor )
    self.tBgColor = tColor
end

--[[

    PANEL:SetCheckedColor

]]--

function PANEL:SetCheckedColor( tColor )
    self.tCheckedColor = tColor
end

--[[

    PANEL:SetUncheckedColor

]]--

function PANEL:SetUncheckedColor( tColor )
    self.tUncheckedColor = tColor
end

--[[

    PANEL:Paint

]]--

function PANEL:Paint( iW, iH )
    draw.RoundedBox( ( iH * .5 ), 0, 0, iW, iH, self.tBgColor )

	if self:GetChecked() then
        self.fLerpX = Lerp( ( RealFrameTime() * 10 ), self.fLerpX, ( iW - iH ) )
        draw.RoundedBox( ( iH * .5 ), self.fLerpX, 0, iH, iH, self.tCheckedColor )

        return
    end

    self.fLerpX = Lerp( ( RealFrameTime() * 10 ), self.fLerpX, 0 )
    draw.RoundedBox( ( iH * .5 ), self.fLerpX, 0, iH, iH, self.tUncheckedColor )
end

-- Register VGUI element
vgui.Register( "TLCheckBox", PANEL, "DCheckBox" )
PANEL = nil