local PANEL = {}

--[[

    PANEL:Init

]]--

function PANEL:Init()
    self.iMargin, self.iRoundness = TLib:ScaleVGUI()

    self:SetFont( "TLib.Small" )
    self:SetTextColor( TLib:C( 2 ) )

    self.tBgColor = TLib:C( 1 )
    self.tBgHColor = TLib:C( 1 )
    self.tBoxColor = self.tBgColor

    self.fLerpHover = 0

    self.DropButton:SetVisible( true )
end

--[[

    PANEL:DoClick

]]--

function PANEL:DoClick()
    TLib:Play2DSound( "tlib/click_01.mp3" )

    if self:IsMenuOpen() then
        self:CloseMenu()
        return
    end

    self:OpenMenu()

    local dMenu = self.Menu
    if not IsValid( dMenu ) then
        return
    end

    local iMargin = self.iMargin
    local iRoundness = self.iRoundness

    -- Menu
    local iX, iH = dMenu:GetPos()
    dMenu:SetPos( iX, ( iH + 3 ) )

    function dMenu:Paint( iW, iH )
        surface.SetDrawColor( TLib:C( 0 ) )
        self:DrawFilledRect()

        surface.SetDrawColor( TLib:C( 1 ) )
        surface.DrawOutlinedRect( 0, 0, iW, iH )
    end

    -- VBar
    local dVBar = dMenu:GetVBar()
    dVBar:SetWidth( ScrH() * .008 )
    dVBar:SetHideButtons( true )
    
    function dVBar:Paint( iW, iH )
        surface.SetDrawColor( dPanel.tBgColor )
        self:DrawFilledRect()
    end

    function dVBar.btnGrip:Paint( iW, iH )
        surface.SetDrawColor( dPanel.tGripColor )
        self:DrawFilledRect()
    end

    -- Menu canvas
    for k, v in pairs( dMenu:GetCanvas():GetChildren() ) do
        v:SetTextColor( TLib:C( 5 ) )
        v:SetFont( self:GetFont() )
        v:SetTextInset( iMargin, 0 )
        v.fLerp = 0
    
        function v:DoClickInternal()
            TLib:Play2DSound( "tlib/click_01.mp3" )
        end

        function v:Paint( iW, iH )
            v.fLerp = Lerp( RealFrameTime() * 12, v.fLerp, self.Hovered and ( iW - 2 ) or 0 )
            if ( v.fLerp < 1 ) then
                return
            end

            surface.SetDrawColor( TLib:C( 2 ) )
            surface.DrawRect( 1, 1, v.fLerp, ( iH - 2 ) )
        end
    end
end

--[[

    PANEL:SetBgColor

]]--

function PANEL:SetBgColor( tColor )
    self.tBgColor = tColor
end

--[[

    PANEL:SetBgHoverColor

]]--

function PANEL:SetBgHoverColor( tColor )
    self.tBgHColor = tColor
end

--[[

    PANEL:Paint

]]--

function PANEL:Paint( iW, iH )
    surface.SetDrawColor( self.tBoxColor )
    self:DrawFilledRect()

    if self.Hovered then
        self.fLerpHover = Lerp( RealFrameTime() * 12, self.fLerpHover, ( self.Hovered and iW or 0 ) )
        self:SetTextColor( TLib:C( 5 ) )
    else
        self.fLerpHover = Lerp( RealFrameTime() * 12, self.fLerpHover, 0 )
        self:SetTextColor( TLib:C( 2 ) )
    end

    if ( self.fLerpHover > 0 ) then
        surface.SetDrawColor( TLib:C( 2 ) )
        surface.DrawRect( math.ceil( ( iW - self.fLerpHover ) * .5 ), 0, self.fLerpHover, iH )
    end

    if self:IsMenuOpen() or self.bHighlight then
        if not self.bSelected then
            self:SetTextColor( TLib:C( 5 ) )
            self.tBoxColor = self.tBgHColor
            self.bSelected = true
        end

        return
    end

    if self.bSelected then
        self:SetTextColor( TLib:C( 2 ) )
        self.tBoxColor = self.tBgColor
        self.bSelected = nil
    end
end

-- Register VGUI element
vgui.Register( "TLComboBox", PANEL, "DComboBox" )
PANEL = nil