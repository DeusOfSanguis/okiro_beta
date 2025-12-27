local PANEL = {}

--[[

    PANEL:Init

]]--

function PANEL:Init()
    self.iMargin, self.iRoundness = TLib:ScaleVGUI()
    self.tChoices = ( self.tChoices or {} )
end

--[[

    PANEL:AddChoice

]]--

function PANEL:AddChoice( sChoice, fCallback )
    local sChoice = ( sChoice and isstring( sChoice ) ) and sChoice or ""
    local fCallback = ( fCallback and isfunction( fCallback ) ) and fCallback or function() end

    self.tChoices[ ( #self.tChoices + 1 ) ] = true

    local dChoice = vgui.Create( "TLButton", self )
    dChoice:SetSize( self:GetWide() - ( self.iMargin * 2 ), ( ScrH() * .032 ) )
    dChoice:SetPos( self.iMargin, self:GetHeaderHeight() + self.iMargin + ( ( #self.tChoices - 1 ) * ( dChoice:GetTall() + ( self.iMargin * .5 ) ) ) )
    dChoice:SetText( sChoice )
    dChoice.fCBack = fCallback

    dChoice.DoClick = function( dButton )
        dButton.fCBack( dButton )

        if self.OnChoiceClicked then
            self.OnChoiceClicked( dChoice )
        end
    end

    self:SizeToChildren( false, true )
    self:SetTall( self:GetTall() + self.iMargin )

    return dChoice
end

-- Register VGUI element
vgui.Register( "TLToast", PANEL, "TLFrame" )
PANEL = nil