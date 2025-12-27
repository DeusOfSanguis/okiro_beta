local PANEL = {}

--[[

    PANEL:Init

]]--

function PANEL:Init()
    local iMargin, iRoundness = TLib:ScaleVGUI()

    self.tBgColor = TLib:C( 1 )
    self.tGripColor = TLib:C( 2 )

    self.Paint = nil

    local dPanel = self
    local dVBar = self:GetVBar()

    dVBar:SetHideButtons( true )
    dVBar:SetWide( iMargin * .5 )

    -- Background
    function dVBar:Paint( iW, iH )
        surface.SetDrawColor( dPanel.tBgColor )
        surface.DrawRect( 0, 0, iW, iH )
    end

    -- Grip
    function dVBar.btnGrip:Paint( iW, iH )
        surface.SetDrawColor( dPanel.tGripColor )
        surface.DrawRect( 0, 0, iW, iH )
    end
end

--[[

    PANEL:AlignContents

]]--

function PANEL:AlignContents( iMargin, iMarginH )
    local iMargin = ( iMargin or 0 )
    local bEnabled = self:GetVBar().Enabled
    local iW = false

    for k, v in ipairs( self:GetCanvas():GetChildren() ) do
        v:Dock( TOP )

        if bEnabled then
            iW = ( iW or ( v:GetWide() - self:GetVBar():GetWide() - iMargin ) )
            v:SetWide( iW )

            v:DockMargin( 0, 0, iMargin, ( iMarginH or iMargin ) )
        else
            v:DockMargin( 0, 0, 0, ( iMarginH or iMargin ) )
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

    PANEL:SetGripColor

]]--

function PANEL:SetGripColor( tColor )
    self.tGripColor = tColor
end

-- Register VGUI element
vgui.Register( "TLScroll", PANEL, "DScrollPanel" )
PANEL = nil
