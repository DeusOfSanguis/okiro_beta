--[[

    TLib:FrameTest
        Descr: VGUI elements exemple 

]]--

function TLib:FrameTest( bRemove )
    if IsValid( self.dTest ) then
        self.dTest:Remove()
        if bRemove then
            self.dTest = nil
            return
        end
    end

    local iMargin, iRoundness = self:ScaleVGUI()

    self.dTest = vgui.Create( "TLFrame" )
    self.dTest:SetSize( math.ceil( ScrH() * .5 ), math.ceil( ScrH() * .52 ) )
    self.dTest:Center()
    self.dTest:MakePopup()
    self.dTest:ShowCloseButton( true )
    self.dTest:SetHeader( "UI Title" )--, "This is a subtitle", "TLib.Title", "TLib.Subtitle" )

    -- function self.dTest:OnCloseClick()
    --     if IsValid( self ) then
    --         self:Remove()
    --     end
    -- end

    local iCBoxW = math.ceil( ScrH() * .036 )
    local iCBoxH = math.ceil( ScrH() * .015 )
    local iCBoxX = ( self.dTest:GetWide() - iCBoxW - iMargin )
    local iCBoxY = ( self.dTest:GetHeaderHeight() + iMargin )

    for i = 1, 18 do
        local dCheckbox = vgui.Create( "TLCheckBox", self.dTest )
        dCheckbox:SetSize( iCBoxW, iCBoxH )
        dCheckbox:SetPos( iCBoxX, iCBoxY + ( ( iCBoxH + iMargin ) * ( i - 1 ) ) )

        if ( i == 15 ) then
            dCheckbox:SetCheckedColor( TLib:C( 3 ) )
            dCheckbox:SetUncheckedColor( TLib:C( 4 ) )
        elseif ( i < 4 ) then
            dCheckbox:SetCheckedColor( TLib:C( 2 ) )
        elseif ( i > 10 ) then
            dCheckbox:SetCheckedColor( TLib:C( 4 ) )
        end
    end

    local dTextEntry = vgui.Create( "TLTextEntry", self.dTest )
    dTextEntry:SetSize( self.dTest:GetWide() * .6, ( self.dTest:GetTall() * .06 ) )
    dTextEntry:SetPos( iMargin, ( self.dTest:GetHeaderHeight() + iMargin ) )
    dTextEntry:SetPlaceholderText( "This is a placeholder" )

    local dScroll = vgui.Create( "TLScroll", self.dTest )
    dScroll:SetSize( self.dTest:GetWide() - iCBoxW - ( iMargin * 3 ), ( self.dTest:GetTall() * .6 ) )
    dScroll:AlignLeft( iMargin )
    dScroll:AlignBottom( iMargin )

    local iBtnW = ( dScroll:GetWide() - dScroll:GetVBar():GetWide() - 1 )
    for i = 1, 22 do
        local dBtn = dScroll:Add( "TLButton" )
        dBtn:SetSize( iBtnW, ( self.dTest:GetTall() * .06 ) )
        dBtn:SetText( "Default TLButton" )

        if ( i > 20 ) then
            dBtn:SetBgColor( TLib:C( 3 ) )
            dBtn:SetBgHoverColor( TLib:C( 4 ) )
            dBtn:SetTitleColor( TLib:C( 5 ) )
            dBtn:SetFontHover( "TLib.Standard" )
        end
    end

    dScroll:AlignContents( 6 )

    local dCBox = vgui.Create( "TLComboBox", self.dTest )
    dCBox:SetSize( self.dTest:GetWide() - iCBoxW - ( iMargin * 3 ), ( self.dTest:GetTall() * .06 ) )
    dCBox:AlignLeft( iMargin )
    dCBox:AlignBottom( dScroll:GetTall() + ( iMargin * 2 ) )

    for i = 1, 12 do
        dCBox:AddChoice( i, i )
    end
end


local function createTLToast()
    local dToast = vgui.Create( "TLToast" )
    dToast:SetSize( ( ScrH() * .32 ), ( ScrH() * .2 ) )
    dToast:Center()
    dToast:MakePopup()
    dToast:SetHeader( "VENDOR", "What would you like to do?" )
    dToast:AddChoice( "Sell wine", function( dChoice )  print( dChoice ) end )
    dToast:AddChoice( "Visit shop", function( dChoice )  print( dChoice ) end )
    -- function dToast:OnChoiceClicked( dChoice )
    --     if IsValid( dToast.dClose ) then
    --         dToast.dClose:DoClickInternal()
    --     end
    -- end

    print( dToast:GetHeaderHeight() )
end

--[[

    OnPlayerChat

]]--

hook.Add( "OnPlayerChat", "TLib_OnPlayerChat", function( pPlayer, sText, bTeam, bDead )
    if ( pPlayer ~= LocalPlayer() ) then
        return
    end

    if ( string.lower( sText ) == "/tlib" ) then
        TLib:FrameTest()    
    end

    if ( string.lower( sText ) == "/tltoast" ) then
        createTLToast()
    end
end )

--DEBUG
    -- if IsValid( TLib.dTest ) then
    --     TLib.dTest:Remove()
    --     if bRemove then
    --         TLib.dTest = nil
    --         return
    --     end
    -- end