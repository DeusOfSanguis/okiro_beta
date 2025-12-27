surface.CreateFont( "bebas_32" , {
    font = "Lexend" ,
    size = 32
} )

local PANEL = { }
local _creatorPanel = nil
local notifIndex = 1
squad_window_frame = nil
squad_window = nil

function PANEL:Init( )
    if ( not LocalPlayer( ):GetSquad( ) or LocalPlayer( ):GetSquad( ) == { } ) then
        LocalPlayer( )._squad = nil
        LocalPlayer( )._squadLeader = nil
    end

    if (not IsValid(self:GetParent( ))) then
        squad_window_frame = vgui.Create("DFrame")
        squad_window_frame:SetSize(500,256)
        squad_window_frame:Center()
        squad_window_frame:MakePopup()
        self:SetParent(squad_window_frame)
    end

    self:Dock( FILL )
    self:Center( )
    self:GetParent( ).Paint = self.PaintFrame
    self:GetParent( ):ShowCloseButton( false )
    self:GetParent( ):SetTitle( "" )
    self.cl = vgui.Create( "DButton" , self:GetParent( ) )
    self.cl:SetSize( 36 , 36 )
    self.cl:SetPos( self:GetParent( ):GetWide( ) - 36 , 0 )
    self.cl:SetText( "" )

    self.cl.DoClick = function( _ )
        self:GetParent( ):Remove( )
    end

    self.cl.Paint = function( s , w , h )
        surface.SetDrawColor( Color( 201 , 51 , 40 ) )
        surface.DrawRect( 0 , 0 , w , h )
        surface.SetDrawColor( Color( 231 , 76 , 60 ) )
        surface.DrawRect( 0 , 0 , w , h - 4 )
        draw.SimpleText( "✕" , "bebas_32" , w / 2 , h / 2 - 2 , Color( 255 , 255 , 255 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )

        if ( s:IsHovered( ) ) then
            surface.SetDrawColor( Color( 255 , 255 , 255 , 50 ) )
            surface.DrawRect( 0 , 0 , w , h )
        end
    end

    self.help = vgui.Create( "DButton" , self:GetParent( ) )
    self.help:SetSize( 36 , 36 )
    self.help:SetPos( self:GetParent( ):GetWide( ) - 36 - 42 , 0 )
    self.help:SetText( "" )

    self.help.DoClick = function( s )
        notifIndex = notifIndex + 1

        if ( notifIndex > #SQUAD.Tips ) then
            notifIndex = 1
        end

        s:SetTooltip( SQUAD.Tips[ notifIndex ] )
        ChangeTooltip( s )
    end

    self.help.OnRemove = function( s )
        if ( IsValid( s.Help ) ) then
            s.Help:Remove( )
        end
    end

    self.help:SetTooltip( SQUAD.Tips[ 1 ] )

    self.help.Paint = function( s , w , h )
        surface.SetDrawColor( Color( 142 , 68 , 173 ) )
        surface.DrawRect( 0 , 0 , w , h )
        surface.SetDrawColor( Color( 155 , 89 , 182 ) )
        surface.DrawRect( 0 , 0 , w , h - 4 )
        draw.SimpleText( "?" , "bebas_32" , w / 2 , h / 2 - 2 , Color( 255 , 255 , 255 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )

        if ( s:IsHovered( ) ) then
            surface.SetDrawColor( Color( 255 , 255 , 255 , 50 ) )
            surface.DrawRect( 0 , 0 , w , h )
        end
    end

    if ( LocalPlayer( ):IsAdmin( ) or table.HasValue( SQUAD.Config.AdminPanelView , LocalPlayer( ):GetUserGroup( ) ) ) then
        self.admin = vgui.Create( "DButton" , self:GetParent( ) )
        self.admin:SetSize( 36 , 36 )
        self.admin:SetPos( self:GetParent( ):GetWide( ) - 36 - 42 - 42 , 0 )
        self.admin:SetText( "" )

        self.admin.DoClick = function( _ )
            RunConsoleCommand( "squad_admin" )
        end

        self.admin:SetTooltip( "Open admin menu" )

        self.admin.Paint = function( s , w , h )
            surface.SetDrawColor( Color( 22 , 160 , 133 ) )
            surface.DrawRect( 0 , 0 , w , h )
            surface.SetDrawColor( Color( 26 , 188 , 156 ) )
            surface.DrawRect( 0 , 0 , w , h - 4 )
            draw.SimpleText( "!" , "bebas_32" , w / 2 , h / 2 - 2 , Color( 255 , 255 , 255 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )

            if ( s:IsHovered( ) ) then
                surface.SetDrawColor( Color( 255 , 255 , 255 , 50 ) )
                surface.DrawRect( 0 , 0 , w , h )
            end
        end
    end

    local extraY = 0

    if ( LocalPlayer( ):GetSquadName( ) == "" ) then
        extraY = 72
        self.cr = vgui.Create( "DButton" , self )
        self.cr:SetPos( self:GetParent( ):GetWide( ) / 2 - 96 , 96 )
        self.cr:SetSize( 96 * 2 , 48 )
        self.cr:SetText( "" )

        self.cr.Paint = function( s , w , h )
            surface.SetDrawColor( Color( 39 , 174 , 96 ) )
            surface.DrawRect( 0 , 0 , w , h )
            surface.SetDrawColor( Color( 46 , 204 , 113 ) )
            surface.DrawRect( 0 , 0 , w , h - 4 )

            if ( s:IsHovered( ) ) then
                surface.SetDrawColor( Color( 255 , 255 , 255 , 50 ) )
                surface.DrawRect( 0 , 0 , w , h )
            end

            draw.SimpleText( string.upper( SQUAD.Language.CreateOne ) , "bebas_48" , w / 2 , h / 2 , Color( 240 , 240 , 240 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
        end

        self.cr.DoClick = function( _ )
            if (SQUAD.Config.CustomCheck(LocalPlayer())) then
                self:GetParent( ):Remove( )
                _creatorPanel = vgui.Create( "dSquadCreate" )
                _creatorPanel:MakePopup( )
            else
                Derma_Message(SQUAD.Config.FailCheck,"Error","Ok")
            end
        end

        self:GetParent( ):SetTall( 292 )
        self:GetParent( ):Center( )
    else
        self:Recreate( )
    end

    self.CanInvite = vgui.Create( "dSquadToggle" , self )
    self.CanInvite:SetPos( 32 , extraY + ( IsValid( self.sq ) and ( self.sq:GetTall( ) + 96 ) or 96 ) )
    self.CanInvite:SetSize( 256 , 32 )
    self.CanInvite:SetToggled( true )
    self.CanInvite.Text = SQUAD.Language.AcceptInvitations

    self.CanInvite.OnValueChange = function( _ , b )
        net.Start( "Squad.CanInvite" )
        net.WriteBool( b )
        net.SendToServer( )
    end

end

function PANEL:PaintFrame( w , h )
    util.DrawBlur( self , 2 , 1 )
    surface.SetDrawColor( 0 , 0 , 0 , 100 )
    surface.DrawRect( 0 , 0 , w , h )
    surface.SetDrawColor( 0 , 0 , 0 , 150 )
    surface.DrawOutlinedRect( 0 , 0 , w , h )
    surface.SetDrawColor( Color( 200 , 200 , 200 ) )
    surface.DrawRect( 0 , 0 , w , 36 )
    surface.SetDrawColor( Color( 241 , 240 , 240 ) )
    surface.DrawRect( 0 , 0 , w , 32 )
    draw.SimpleText( "SQUADS" , "bebas_32" , 6 , 2 , Color( 120 , 120 , 120 ) )

    if ( LocalPlayer( ):GetSquadName( ) ~= "" ) then
        draw.SimpleText( "SQUADS" , "bebas_32" , 6 , 2 , Color( 120 , 120 , 120 ) )
    else
        draw.SimpleText( "- " .. SQUAD.Language.NotInSquad .. " -" , "bebas_48" , w / 2 , 64 , Color( 100 , 100 , 100 ) , TEXT_ALIGN_CENTER )
        draw.SimpleText( "- " .. SQUAD.Language.NotInSquad .. " -" , "bebas_48" , w / 2 , 62 , Color( 240 , 240 , 240 ) , TEXT_ALIGN_CENTER )
        draw.SimpleText( "✕" , "bebas_48" , w / 2 + 200 , 64 , Color( 201 , 51 , 40 ) , TEXT_ALIGN_CENTER )
        draw.SimpleText( "✕" , "bebas_48" , w / 2 + 200 , 62 , Color( 231 , 76 , 60 ) , TEXT_ALIGN_CENTER )
        draw.SimpleText( "✕" , "bebas_48" , w / 2 - 200 , 64 , Color( 201 , 51 , 40 ) , TEXT_ALIGN_CENTER )
        draw.SimpleText( "✕" , "bebas_48" , w / 2 - 200 , 62 , Color( 231 , 76 , 60 ) , TEXT_ALIGN_CENTER )
    end
end

function PANEL:Recreate( )
    if ( IsValid( self.sq ) ) then
        self.sq:Remove( )
    end

    self.sq = vgui.Create( "DPanel" , self )
    self.sq:SetSize( self:GetParent( ):GetWide( ) , 340 )
    self.sq:SetPos( 0 , 16 )
    local tx = 0

    self.sq.Paint = function( _ , w , _ )
        if ( LocalPlayer( ):GetSquadName( ) ~= "" and ( LocalPlayer( ):GetSquad( ) or {
            Name = "Error"
        } ).Name ) then
            tx , _ = draw.SimpleText( LocalPlayer( ):GetSquadName( ) .. " - " .. LocalPlayer( ):GetSquad( ).Name , "bebas_48" , w / 2 , 16 , Color( 240 , 240 , 240 ) , TEXT_ALIGN_CENTER )
            surface.SetDrawColor( color_white )
            surface.DrawRect( w / 2 - tx / 2 , 56 , tx , 2 )
        end
    end

    local bHeight = ( self.sq:GetWide( ) / 4 ) * math.ceil( SQUAD.Config.MaxMembers / 4 )
    self.sq:SetTall( 64 + bHeight )
    self.pl = vgui.Create( "DPanel" , self.sq )
    self.pl:SetSize( self.sq:GetWide( ) - 16 , bHeight )
    self.pl:SetPos( 8 , 72 )
    self.pl.Paint = function( ) end
    local size = self.sq:GetWide( ) / 4 - 4

    for k = 0 , SQUAD.Config.MaxMembers do
        local pl = vgui.Create( "dSquadMember" , self.pl )
        pl:SetSize( size , size )
        pl.Index = k

        if ( IsValid( LocalPlayer( ):GetSquadMembers( )[ k ] ) ) then
            pl:SetPlayer( LocalPlayer( ):GetSquadMembers( )[ k ] )
        end

        pl:SetPos( size * ( ( k + 3 ) % 4 ) , math.ceil( k / 4 ) * size - size - 32 )
    end

    self:GetParent( ):SetTall( bHeight + 286 )
    self:GetParent( ):Center( )
    self.inv = vgui.Create( "DButton" , self )
    self.inv:SetPos( self:GetParent( ):GetWide( ) / 2 - 116 , 64 + bHeight )
    self.inv:SetSize( 116 * 2 , 48 )
    self.inv:SetText( "" )

    self.inv.Paint = function( s , w , h )
        surface.SetDrawColor( Color( 142 , 68 , 173 ) )
        surface.DrawRect( 0 , 0 , w , h )
        surface.SetDrawColor( Color( 155 , 89 , 182 ) )
        surface.DrawRect( 0 , 0 , w , h - 4 )

        if ( s:IsHovered( ) ) then
            surface.SetDrawColor( Color( 255 , 255 , 255 , 50 ) )
            surface.DrawRect( 0 , 0 , w , h )
        end

        draw.SimpleText( SQUAD.Language.InvitePlayers , "bebas_48" , w / 2 , h / 2 , Color( 240 , 240 , 240 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
    end

    self.inv.DoClick = function( _ )
        vgui.Create( "dSquadList" )
    end
end

function PANEL:Paint( )
end

derma.DefineControl( "dSquadPanel" , "DSquads" , PANEL , "DPanel" )
local CONFIG = { }

function CONFIG:Init( )
    self:SetSize( 200 , 300 )
    self:Center( )
    self:MakePopup( )
end

function CONFIG:Paint( )
end

derma.DefineControl( "dSquadConfig" , "DSquads" , CONFIG , "DFrame" )
local CREATE = { }

function CREATE:Init( )
    self:SetSize( 226 , 256 )
    self:Center( )
    self:MakePopup( )
    self:SetTitle( "" )
    self:ShowCloseButton( false )
    self._start = SysTime( )
    self.cl = vgui.Create( "DButton" , self )
    self.cl:SetSize( 32 , 32 )
    self.cl:SetPos( 226 - 32 , 0 )
    self.cl:SetText( "" )

    self.cl.DoClick = function( )
        self:Remove( )
    end

    self.cl.Paint = function( s , w , h )
        surface.SetDrawColor( Color( 201 , 51 , 40 ) )
        surface.DrawRect( 0 , 0 , w , h )
        surface.SetDrawColor( Color( 231 , 76 , 60 ) )
        surface.DrawRect( 0 , 0 , w , h - 4 )
        draw.SimpleText( "✕" , "bebas_32" , w / 2 , h / 2 - 2 , Color( 255 , 255 , 255 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )

        if ( s:IsHovered( ) ) then
            surface.SetDrawColor( Color( 255 , 255 , 255 , 50 ) )
            surface.DrawRect( 0 , 0 , w , h )
        end
    end

    self.tag = vgui.Create( "DTextEntry" , self )
    self.tag:SetSize( 226 - 12 , 34 )
    self.tag:SetPos( 6 , 78 )
    self.tag:SetUpdateOnType( true )
    self.tag:SetFont( "bebas_32" )

    self.tag.OnValueChange = function( s , t )
        if ( #t > SQUAD.Config.TagMaxSize ) then
            s:SetText( string.sub( t , 1 , SQUAD.Config.TagMaxSize ) )
            s:SetCaretPos( SQUAD.Config.TagMaxSize )
        end
    end

    self.tag.Paint = function( s , w , h )
        surface.SetDrawColor( 75 , 75 , 75 )
        surface.DrawRect( 0 , 0 , w , h )
        surface.SetDrawColor( 30 , 30 , 30 )
        surface.DrawRect( 1 , 1 , w - 2 , h - 2 )
        s:DrawTextEntryText( Color( 175 , 175 , 175 ) , Color( 230 , 126 , 34 ) , Color( 52 , 152 , 219 ) )
    end

    self.name = vgui.Create( "DTextEntry" , self )
    self.name:SetSize( 226 - 12 , 34 )
    self.name:SetUpdateOnType( true )

    self.name.OnValueChange = function( s , t )
        if ( #t > SQUAD.Config.NameMaxSize ) then
            s:SetText( string.sub( t , 1 , SQUAD.Config.NameMaxSize ) )
            s:SetCaretPos( SQUAD.Config.NameMaxSize )
        end
    end

    self.name:SetPos( 6 , 78 + 66 )
    self.name:SetFont( "bebas_32" )

    self.name.Paint = function( s , w , h )
        surface.SetDrawColor( 75 , 75 , 75 )
        surface.DrawRect( 0 , 0 , w , h )
        surface.SetDrawColor( 30 , 30 , 30 )
        surface.DrawRect( 1 , 1 , w - 2 , h - 2 )
        s:DrawTextEntryText( Color( 175 , 175 , 175 ) , Color( 230 , 126 , 34 ) , Color( 52 , 152 , 219 ) )
    end

    self.cr = vgui.Create( "DButton" , self )
    self.cr:SetPos( 0 , 192 )
    self.cr:SetSize( 226 , 48 )
    self.cr:SetText( "" )

    self.cr.Paint = function( s , w , h )
        surface.SetDrawColor( Color( 39 , 174 , 96 ) )
        surface.DrawRect( 0 , 0 , w , h )
        surface.SetDrawColor( Color( 46 , 204 , 113 ) )
        surface.DrawRect( 0 , 0 , w , h - 4 )

        if ( s:IsHovered( ) ) then
            surface.SetDrawColor( Color( 255 , 255 , 255 , 50 ) )
            surface.DrawRect( 0 , 0 , w , h )
        end

        draw.SimpleText( SQUAD.Language.Create , "bebas_48" , w / 2 , h / 2 , Color( 240 , 240 , 240 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
    end

    self.cr.DoClick = function( )
        if ( self.tag:GetValue( ) ~= "" and self.name:GetValue( ) ~= "" ) then
            net.Start( "Squad.CreateSquad" )
            net.WriteString( self.tag:GetValue( ) )
            net.WriteString( self.name:GetValue( ) )
            net.SendToServer( )
            self.Wait = vgui.Create( "DPanel" , self )
            self.Wait.Paint = self.PaintBackground
            self.Wait:SetPos( 0 , 32 )
            self.Wait:SetSize( self:GetWide( ) , self:GetTall( ) - 32 )
        end
    end
end

function CREATE:Paint( w , h )
    Derma_DrawBackgroundBlur( self , self._start )
    surface.SetDrawColor( 20 , 20 , 20 )
    surface.DrawRect( 0 , 0 , w , h )
    surface.SetDrawColor( 50 , 50 , 50 )
    surface.DrawRect( 0 , 0 , w , h - 4 )
    draw.SimpleText( SQUAD.Language.D_Title , "bebas_32" , 6 , 2 , Color( 120 , 120 , 120 ) )
    draw.SimpleText( "TAG:" , "bebas_32" , 6 , 48 , Color( 120 , 120 , 120 ) )
    draw.SimpleText( "max " .. SQUAD.Config.TagMaxSize .. " " .. SQUAD.Language.Chars , "bebas_18" , w - 8 , 56 , Color( 120 , 120 , 120 , 100 ) , TEXT_ALIGN_RIGHT )
    draw.SimpleText( "Name:" , "bebas_32" , 6 , 48 + 66 , Color( 120 , 120 , 120 ) )
    draw.SimpleText( "max " .. SQUAD.Config.NameMaxSize .. " " .. SQUAD.Language.Chars , "bebas_18" , w - 8 , 56 + 66 , Color( 120 , 120 , 120 , 100 ) , TEXT_ALIGN_RIGHT )
end

function CREATE:PaintBackground( w , h )
    surface.SetDrawColor( 0 , 0 , 0 , 225 )
    surface.DrawRect( 0 , 0 , w , h )

    if ( self.Error == 1 ) then
        draw.SimpleText( SQUAD.Language.D_Created , "bebas_48" , w / 2 , h / 3 , Color( 46 , 204 , 113 , 255 + math.cos( RealTime( ) * 16 ) * 125 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
    elseif ( self.Error == 2 ) then
        draw.SimpleText( SQUAD.Language.D_Exists , "bebas_32" , w / 2 , h / 3 , Color( 231 , 76 , 60 , 255 + math.cos( RealTime( ) * 16 ) * 125 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
        draw.SimpleText( SQUAD.Language.D_ExistsB , "bebas_32" , w / 2 , h / 3 + 36 , Color( 231 , 76 , 60 , 255 + math.cos( RealTime( ) * 16 ) * 125 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
    elseif ( self.Error == 3 ) then
        draw.SimpleText( SQUAD.Language.D_Error , "bebas_32" , w / 2 , h / 3 , Color( 231 , 76 , 60 , 255 + math.cos( RealTime( ) * 16 ) * 125 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
    end
end

function CREATE:ShowResult( can )
    if ( can == 1 ) then
        self.Wait.Error = 1

        timer.Simple( 3 , function( )
            if (IsValid(self)) then
                self:Remove( )
            end
        end )
    elseif ( can == 2 ) then
        self.Wait.Error = 2

        timer.Simple( 3 , function( )
            if (IsValid(self.Wait)) then
                self.Wait:Remove( )
            end
        end )
    elseif ( can == 3 ) then
        self.Wait.error = 3

        timer.Simple( 3 , function( )
            if (IsValid(self.Wait)) then
                self.Wait:Remove( )
            end
        end )
    end
end

derma.DefineControl( "dSquadCreate" , "DSquads" , CREATE , "DFrame" )
local MEMBER = { }
MEMBER.Index = 0

function MEMBER:Init( )
end

local nextMessage = 0

function MEMBER:SetPlayer( ply )
    self.Avatar = vgui.Create( "AvatarImage" , self )
    self.Avatar:SetSize( 64 , 64 )
    self.Avatar:SetPlayer( ply , 64 )
    self.Avatar:Center( )
    self.Player = ply
    local isRemove = ply == LocalPlayer( ) or LocalPlayer( ):GetSquad( ).Creator == LocalPlayer( )
    self.bRemove = vgui.Create( "DImageButton" , self )
    self.bRemove:SetSize( 16 , 16 )
    self.bRemove:SetPos( 64 , 112 )
    self.bRemove:SetTooltip( "Options" )

    self.bRemove.DoClick = function( )
        local Menu = DermaMenu( )

        if ( ply ~= LocalPlayer( ) ) then
            Menu:AddOption( SQUAD.Language.Message , function( )
                Derma_StringRequest( SQUAD.Language.Message , SQUAD.Language.Message , "hey!" , function( val )
                    if ( nextMessage < CurTime( ) and #val <= 1024 ) then
                        nextMessage = CurTime( ) + 5
                        net.Start( "Squad.SendMessage" )
                        net.WriteString( val )
                        net.WriteEntity( ply )
                        net.SendToServer( )
                    else
                        chat.AddText( Color( 235 , 100 , 100 ) , SQUAD.Language.MessageWarning )
                    end
                end , function( ) end )
            end ):SetIcon( "icon16/user_comment.png" )

            if ( SQUAD.Config.CanShareMoney ) then
                Menu:AddOption( SQUAD.Language.Money , function( )
                    Derma_StringRequest( SQUAD.Language.Money , SQUAD.Language.MoneySubtitle .. "(Max " .. LocalPlayer( ):getDarkRPVar( "money" ) .. ")" , 100 , function( val )
                        if ( tonumber( val ) and LocalPlayer( ):canAfford( tonumber( val ) ) and tonumber( val ) > 0 ) then
                            net.Start( "Squad.SendMoney" )
                            net.WriteFloat( tonumber( val ) )
                            net.WriteEntity( ply )
                            net.SendToServer( )
                            notification.AddLegacy( "You sent $" .. tonumber( val ) .. "to " .. ply:Nick( ) , NOTIFY_GENERIC, 5 )
                        end
                    end , function( ) end )
                end ):SetIcon( "icon16/money.png" )
            end

            if ( SQUAD.Config.CanViewPlayerScreens ) then
                if ( SQUAD.Config.OnlyBossCanSee and not LocalPlayer( )._squadLeader ) then return end

                Menu:AddOption( SQUAD.Language.ScreenView , function( )
                    if ( ply:GetNWBool( "Squad.CanShareView" , false ) ) then
                        local screen = vgui.Create( "DFrame" , g_ContextMenu )
                        screen:SetSize( 320 , 240 )
                        screen:SetSizable( true )
                        screen:SetTitle( ply:Nick( ) .. " view" )
                        screen:Center( )
                        screen.Camera = vgui.Create( "DPanel" , screen )
                        screen.Camera:Dock( FILL )

                        screen.Camera.Paint = function( _ , w , h )
                            if ( not IsValid( ply ) ) then
                                screen:Remove( )
                                return
                            end

                            local x , y = screen:GetPos( )
                            local wh , hh = screen:GetSize( )

                            render.RenderView( {
                                origin = ply:EyePos( ) ,
                                angles = ply:EyeAngles( ) ,
                                x = x + 4 ,
                                y = y + 28 ,
                                w = w ,
                                h = h ,
                                drawviewmodel = false ,
                                drawviewer = true ,
                                aspectratio = wh / hh
                            } )
                        end
                    else
                        MsgN("!")
                        notification.AddLegacy("This player has share view option disabled", 1, 3)
                    end
                end ):SetIcon( "icon16/eye.png" )
            end

            if ( SQUAD.Config.CanShareWeapons ) then
                local SubMenu = Menu:AddSubMenu( SQUAD.Language.GiveGun )

                for k , v in pairs( LocalPlayer( ):GetWeapons( ) ) do
                    if ( GAMEMODE.Config and GAMEMODE.Config.DisallowDrop[ v:GetClass( ) ] ) then continue end

                    SubMenu:AddOption( v:GetPrintName( ) , function( )
                        net.Start( "Squad.GiveWeapon" )
                        net.WriteEntity( ply )
                        net.WriteString( v:GetClass( ) )
                        net.SendToServer( )
                    end ):SetIcon( "icon16/bullet_blue.png" )
                end
            end

            Menu:AddSpacer( )
        end

        if ( isRemove ) then
            local btnWithIcon = Menu:AddOption( ( LocalPlayer( ):GetSquad( ).Creator == LocalPlayer( ) and SQUAD.Language.RemoveLeave[1] or SQUAD.Language.RemoveLeave[2] ) .. " " .. SQUAD.Language.RemoveLeave[3] , function( )
                Derma_Query( SQUAD.Language.ExitMessage , SQUAD.Language.ExitConfirm , SQUAD.Language.Yeah , function( )
                    net.Start( "Squad.ExitSquad" )
                    net.WriteEntity( ply )
                    net.SendToServer( )

                    if ( IsValid( squad_window ) ) then
                        squad_window:GetParent( ):Remove( )
                        squad_window = nil
                    end
                end , "Cancel" , function( ) end )
            end )

            btnWithIcon:SetIcon( "icon16/door.png" )
        end

        Menu:Open( )
    end

    self.bRemove:SetImage( "icon16/cog.png" )
end

function MEMBER:Paint( w , h )
    if ( IsValid( self.Player ) ) then
        local col = Color( 40 , 40 , 40 )

        if ( self.Player == LocalPlayer( ) ) then
            col = Color( 243 , 156 , 18 )
        end

        if ( LocalPlayer( ):GetSquad( ) and LocalPlayer( ):GetSquad( ).Creator == self.Player ) then
            col = Color( 41 , 128 , 185 )
        end

        surface.SetDrawColor( Color( col.r * 1.6 , col.g * 1.6 , col.b * 1.6 ) )
        surface.DrawRect( w / 2 - 36 , h / 2 - 38 , 72 , 2 )
        surface.SetDrawColor( col )
        surface.DrawRect( w / 2 - 36 , h / 2 - 36 , 72 , 100 )
        surface.SetDrawColor( Color( col.r * 1.25 , col.g * 1.25 , col.b * 1.25 ) )
        surface.DrawRect( w / 2 - 36 , h / 2 - 36 , 72 , 96 )
        surface.SetDrawColor( Color( col.r * 1.6 , col.g * 1.6 , col.b * 1.6 ) )
        surface.DrawRect( w / 2 - 33 , h / 2 - 33 , 66 , 66 )
    else
        if ( IsValid( self.Avatar ) ) then
            self:GetParent( ):GetParent( ):GetParent( ):Recreate( )
            self:GetParent( ):GetParent( ):MakePopup( )
        end

        local wd = math.cos( RealTime( ) * 8 + self.Index ) * 4
        draw.RoundedBox( 8 , w / 2 - 17 - wd , h / 2 - 17 - wd , 34 + wd * 2 , 34 + wd * 2 , Color( 150 , 150 , 150 ) )
        draw.RoundedBox( 8 , w / 2 - 16 - wd , h / 2 - 16 - wd , 32 + wd * 2 , 32 + wd * 2 , Color( 75 , 75 , 75 ) )
        draw.RoundedBox( 8 , w / 2 - 12 - wd , h / 2 - 12 - wd , 24 + wd * 2 , 24 + wd * 2 , Color( 50 , 50 , 50 ) )
        draw.RoundedBox( 4 , w / 2 - 6 - wd , h / 2 - 6 - wd , 12 + wd * 2 , 12 + wd * 2 , Color( 100 , 100 , 100 ) )
    end
end

derma.DefineControl( "dSquadMember" , "DSQuads" , MEMBER , "DPanel" )
local LIST = { }

function LIST:Init( )
    self:SetSize( 104 * 3 + 16 , 300 )
    self:Center( )
    self:SetTitle( "" )
    self:MakePopup( )
    self:SetDraggable( false )
    self.List = vgui.Create( "DPanel" , self )
    self.List:SetSize( 104 * 3 , 256 )
    self.List:SetPos( 8 , 32 )

    self.List.Paint = function( _ , w , h )
        surface.SetDrawColor( 0 , 0 , 0 , 100 )
        surface.DrawRect( 0 , 0 , w , h )
        surface.SetDrawColor( 0 , 0 , 0 , 150 )
        surface.DrawOutlinedRect( 0 , 0 , w , h )
    end

    self.cl = vgui.Create( "DButton" , self )
    self.cl:SetSize( 24 , 24 )
    self.cl:SetPos( 104 * 3 - 18 , 4 )
    self.cl:SetText( "" )

    self.cl.DoClick = function( )
        self:Remove( )
    end

    self.cl.Paint = function( s , w , h )
        surface.SetDrawColor( Color( 201 , 51 , 40 ) )
        surface.DrawRect( 0 , 0 , w , h )
        surface.SetDrawColor( Color( 231 , 76 , 60 ) )
        surface.DrawRect( 0 , 0 , w , h - 2 )
        draw.SimpleText( "✕" , "bebas_32" , w / 2 - 1 , h / 2 , Color( 255 , 255 , 255 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )

        if ( s:IsHovered( ) ) then
            surface.SetDrawColor( Color( 255 , 255 , 255 , 50 ) )
            surface.DrawRect( 0 , 0 , w , h )
        end
    end

    self.Search = vgui.Create( "DTextEntry" , self )
    self.Search:SetPos( 136 , 4 )
    self.Search:SetSize( 96 , 24 )
    self.Search:SetUpdateOnType( true )

    self.Search.OnValueChange = function( )
        self:UpdateList( )
    end

    self:UpdateList( )
    self:ShowCloseButton( false )
end

function LIST:UpdateList( )
    for k , v in pairs( self.List.Models or { } ) do
        v:Remove( )
    end

    if IsValid( self.List.F ) then
        self.List.F:Remove( )
    end

    if IsValid( self.List.B ) then
        self.List.B:Remove( )
    end

    self.List.Models = { }
    local i = 0
    local playerList = { }
    local str = string.lower( self.Search:GetText( ) )

    for k , v in pairs( player.GetAll( ) ) do
        if ( string.find( string.lower( v:Nick( ) ) , str ) ~= nil ) then
            table.insert( playerList , v )
        end
    end

    for k , v in pairs( playerList ) do
        if ( v:GetSquadName( ) == "" and v ~= LocalPlayer( ) and v:GetNWBool( "Squad.CanHire" , true ) ) then
            local item = vgui.Create( "DPanel" , self.List )
            item:SetSize( 104 , 256 )
            item:SetPos( i * 104 , 0 )

            item.Paint = function( _ , w , h )
                surface.SetDrawColor( 0 , 0 , 0 , 100 )
                surface.DrawRect( 2 , 2 , w - 4 , h - 4 )
                surface.SetDrawColor( 0 , 0 , 0 , 150 )
                surface.DrawOutlinedRect( 2 , 2 , w - 4 , h - 4 )
            end

            item.Model = vgui.Create( "DModelPanel" , item )
            item.Model:SetModel( v:GetModel( ) )
            item.Model:SetSize( 100 , 256 )
            item.Model:SetPos( 4 , 0 )
            item.Model.i = math.random( 1 , 4 )

            item.Model.LayoutEntity = function( s , ent )
                if(ent:LookupSequence( "pose_standing_0" .. s.i ) > 0) then
                    ent:SetSequence( ent:LookupSequence( "pose_standing_0" .. s.i ) )
                end
                s:RunAnimation( )

                return
            end

            item.Model.OldPaint = item.Model.Paint

            item.Model.Paint = function( s , w , h )
                if ( not IsValid( v ) ) then
                    item:Remove( )

                    return
                end

                s:OldPaint( w , h )
                draw.SimpleText( v:Nick( ) , "bebas_18" , w / 2 , 20 , Color( 240 , 240 , 240 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
            end

            item.Model.Entity.GetPlayerColor = function( ) return Vector( v:GetPlayerColor( ).x , v:GetPlayerColor( ).y , v:GetPlayerColor( ).z ) end
            local bone = item.Model.Entity:LookupBone( "ValveBiped.Bip01_Head1" )
            local eyepos = Vector(0,0,60)
            if(bone and bone > 1) then
                eyepos = item.Model.Entity:GetBonePosition( bone)
            end
            eyepos:Add( Vector( 12 , 0 , -12 ) )
            item.Model:SetFOV( 40 )
            item.Model:SetLookAt( eyepos )
            item.Model:SetCamPos( eyepos - Vector( -16 , 0 , -1 ) )
            item.Model.Entity:SetEyeTarget( eyepos - Vector( -12 , 0 , 0 ) )
            item.Select = vgui.Create( "DButton" , item )
            item.Select:SetSize( 96 , 32 )
            item.Select:SetPos( 4 , 256 - 32 )
            item.Select:SetText( "" )

            item.Select.Paint = function( s , w , h )
                surface.SetDrawColor( s.Sent and Color( 142 , 68 , 173 ) or Color( 211 , 84 , 0 ) )
                surface.DrawRect( 0 , 0 , w , h )
                surface.SetDrawColor( s.Sent and Color( 155 , 89 , 182 ) or Color( 230 , 126 , 34 ) )
                surface.DrawRect( 0 , 0 , w , h - 4 )

                if ( s:IsHovered( ) ) then
                    surface.SetDrawColor( Color( 255 , 255 , 255 , 50 ) )
                    surface.DrawRect( 0 , 0 , w , h )
                end

                draw.SimpleText( s.Sent and SQUAD.Language.InvitationButtons[1] or SQUAD.Language.InvitationButtons[2] , "bebas_32" , w / 2 , h / 2 - 1 , Color( 240 , 240 , 240 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
            end

            item.Select.DoClick = function( s )
                net.Start( "Squad.SendInvitation" )
                net.WriteEntity( v )
                net.SendToServer( )
                s.Sent = true
            end

            self.List.Models[ i ] = item
            i = i + 1
        end
    end

    if ( i > 3 ) then
        self.List.Movement = 0
        self.List.F = vgui.Create( "DPanel" , self.List )
        self.List.F:SetSize( 12 , 256 )
        self.List.F:SetPos( 104 * 3 - 12 )
        self.List.F:SetCursor( "hand" )

        self.List.F.Paint = function( _ , w , h )
            surface.SetDrawColor( 0 , 0 , 0 , 200 )
            surface.DrawRect( 0 , 0 , w , h )
            surface.SetDrawColor( 0 , 0 , 0 , 235 )
            surface.DrawOutlinedRect( 0 , 0 , w , h )
            draw.SimpleText( ">" , "bebas_32" , w / 2 , h / 2 , Color( 240 , 240 , 240 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
        end

        self.List.F.OnCursorEntered = function( )
            self.List.Movement = self.List.Movement - 1
        end

        self.List.F.OnCursorExited = function( )
            self.List.Movement = self.List.Movement + 1
        end

        self.List.B = vgui.Create( "DPanel" , self.List )
        self.List.B:SetSize( 12 , 256 )
        self.List.B:SetPos( 0 )
        self.List.B:SetCursor( "hand" )

        self.List.B.Paint = function( _ , w , h )
            surface.SetDrawColor( 0 , 0 , 0 , 200 )
            surface.DrawRect( 0 , 0 , w , h )
            surface.SetDrawColor( 0 , 0 , 0 , 235 )
            surface.DrawOutlinedRect( 0 , 0 , w , h )
            draw.SimpleText( "<" , "bebas_32" , w / 2 , h / 2 , Color( 240 , 240 , 240 ) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER )
        end

        self.List.B.OnCursorEntered = function( )
            self.List.Movement = self.List.Movement + 1
        end

        self.List.B.OnCursorExited = function( )
            self.List.Movement = self.List.Movement - 1
        end

        self.List.Think = function( )
            if ( self.List.Movement ~= 0 ) then
                self.List.Extra = math.Clamp( ( self.List.Extra or 0 ) + self.List.Movement * ( input.IsMouseDown( 107 ) and 3 or 1 ) , -( i - 3 ) * 104 , 0 )

                for k , v in pairs( self.List.Models ) do
                    if ( not v.bPos ) then
                        v.bPos , _ = v:GetPos( )
                    end

                    v:SetPos( v.bPos + self.List.Extra , 0 )
                end
            end
        end
    end
end

function LIST:Paint( w , h )
    util.DrawBlur( self , 2 , 4 )
    surface.SetDrawColor( 0 , 0 , 0 , 100 )
    surface.DrawRect( 0 , 0 , w , h )
    surface.SetDrawColor( 0 , 0 , 0 , 150 )
    surface.DrawOutlinedRect( 0 , 0 , w , h )
    draw.SimpleText( SQUAD.Language.Filter , "bebas_32" , 8 , 2 , Color( 255 , 255 , 255 ) )
end

derma.DefineControl( "dSquadList" , "DSquads" , LIST , "DFrame" )
local INV = { }
INV.Player = nil

function INV:Init( )
    self:SetSize( 300 , 128 )
    self:SetPos( ScrW( ) , ScrH( ) / 2 - 64 )
end

function INV:SetPlayer( ply , squad )
    self.Avatar = vgui.Create( "AvatarImage" , self )
    self.Avatar:SetSize( 64 , 64 )
    self.Avatar:SetPos( 8 , 32 )
    self.Avatar:SetPlayer( ply , 64 )
    self.Player = ply
    self.Enabled = true
    self.Squad = squad
    self.CreateTime = 7.9
    surface.SetFont( "bebas_18" )
    local bX , _ = surface.GetTextSize( string.format( SQUAD.Language.Join , self.Player:Nick( ) ) )
    local dX , _ = surface.GetTextSize( self.Squad )
    local wide = ( bX > dX and bX or dX ) + 88
    self:SetSize( wide , 86 )
    self:MoveTo( ScrW( ) - wide , ScrH( ) / 2 - 64 , 0.25 , 0 , 5 )
end

function INV:Paint( w , h )
    if ( self.Enabled ) then
        if ( not IsValid( self.Player ) ) then
            self:Remove( )

            return
        else
            util.DrawBlur( self , 2 , 4 )
            surface.SetDrawColor( 0 , 0 , 0 , 100 )
            surface.DrawRect( 0 , 0 , w , h )
            surface.SetDrawColor( 0 , 0 , 0 , 150 )
            surface.DrawOutlinedRect( 0 , 0 , w , h )
            local dx , _ = draw.SimpleText( string.format( SQUAD.Language.Join , self.Player:Nick( ) ) , "bebas_18" , w - 8 , 8 , color_white , TEXT_ALIGN_RIGHT )
            draw.SimpleText( self.Squad , "bebas_32" , w - 8 - dx , 26 , color_white , TEXT_ALIGN_LEFT )
            self.Avatar:SetPos( w - 16 - dx - 64 , 8 )
            draw.SimpleText( "(O) " .. SQUAD.Language.Accept , "bebas_18" , w - 8 , 56 , Color( 150 , 255 , 50 ) , TEXT_ALIGN_RIGHT )
            draw.SimpleText( "(P) " .. SQUAD.Language.Refuse , "bebas_18" , w - 8 - 92 , 56 , Color( 255 , 100 , 50 ) , TEXT_ALIGN_RIGHT )
            surface.SetDrawColor( util.GetProgressColor( 255 , ( self.CreateTime / 8 ) * 100 ) )
            surface.DrawRect( 1 , h - 5 , w - 2 , 4 )
            surface.SetDrawColor( Color( 0 , 0 , 0 , 100 ) )
            surface.DrawRect( 1 , h - 5 , w - 2 , 4 )
            surface.SetDrawColor( util.GetProgressColor( 255 , ( self.CreateTime / 8 ) * 100 ) )
            surface.DrawRect( 1 , h - 5 , ( self.CreateTime / 8 ) * w - 2 , 4 )

            if ( self.CreateTime < 0 and not self.Removing ) then
                self:MoveTo( ScrW( ) , ScrH( ) / 2 - 64 , 0.25 , 0 , 5 , function( )
                    self:Remove( )
                end )

                self.Removing = true
            else
                self.CreateTime = self.CreateTime - FrameTime( )
            end
        end
    end
end

function INV:Think( )
    if ( not vgui.CursorVisible( ) and not self.Removing ) then
        if ( input.IsKeyDown( KEY_O ) ) then
            net.Start( "Squad.ReplyInvitation" )
            net.WriteEntity( self.Player )
            net.WriteBool( true )
            net.SendToServer( )
            self.CreateTime = -1
        end

        if ( input.IsKeyDown( KEY_P ) ) then
            net.Start( "Squad.ReplyInvitation" )
            net.WriteEntity( self.Player )
            net.WriteBool( false )
            net.SendToServer( )
            self.CreateTime = -1
        end
    end
end

function INV:OnRemove( )
    if ( self.Removing and self.CreateTime ~= -1 ) then
        net.Start( "Squad.ReplyInvitation" )
        net.WriteEntity( self.Player )
        net.WriteBool( false )
        net.SendToServer( )
    end
end

function util.GetProgressColor( a , am )
    local col = Color( 231 , 76 , 60 , a )

    if ( am > 30 ) then
        if ( am < 50 ) then
            col = Color( 230 , 126 , 34 , a )
        elseif ( am < 75 ) then
            col = Color( 241 , 196 , 15 , a )
        else
            col = Color( 46 , 204 , 113 , a )
        end
    end

    return col
end

derma.DefineControl( "dSquadInvitation" , "DSquads" , INV , "DPanel" )
local TG = { }
AccessorFunc( TG , "TG" , "Toggled" , FORCE_BOOL )

function TG:Init( )
    self:SetText( "" )
end

function TG:Paint( _ , h )
    surface.SetDrawColor( 100 , 100 , 100 )
    surface.DrawOutlinedRect( 1 , 1 , 64 , h - 2 )
    surface.SetDrawColor( 25 , 25 , 25 )
    surface.DrawRect( 2 , 2 , 62 , h - 4 )

    if ( self:GetToggled( ) ) then
        surface.SetDrawColor( Color( 46 , 204 , 113 ) )
        surface.DrawRect( 2 + 31 , 2 , 31 , h - 4 )
        surface.SetDrawColor( Color( 0 , 0 , 0 , 50 ) )
        surface.DrawRect( 2 , h - 6 , 31 , 4 )
    else
        surface.SetDrawColor( Color( 230 , 126 , 34 ) )
        surface.DrawRect( 2 , 2 , 31 , h - 4 )
        surface.SetDrawColor( Color( 0 , 0 , 0 , 50 ) )
        surface.DrawRect( 2 , h - 6 , 31 , 4 )
    end

    draw.SimpleText( self.Text or "TEST" , "bebas_32" , 72 , h / 2 , color_white , TEXT_ALIGN_LEFT , TEXT_ALIGN_CENTER )
end

function TG:DoClick( )
    self:SetToggled( not self:GetToggled( ) )
    self:OnValueChange( self:GetToggled( ) )
end

function TG:OnValueChange( )
end

derma.DefineControl( "dSquadToggle" , "DSquads" , TG , "DButton" )

net.Receive( "Squad.VerifyIfAvailable" , function( )
    if ( IsValid( _creatorPanel ) ) then
        local can = net.ReadInt( 4 )
        _creatorPanel:ShowResult( can )
    end
end )

concommand.Add( "squad_config" , function( ) end )
local png_icon = file.Exists( "materials/icon64/squad2.png" , "GAME" ) and "icon64/squad2.png" or "icon64/playermodel.png"

net.Receive( "Squad.Verify" , function( )
    if ( IsValid( squad_window_frame ) ) then
        squad_window = vgui.Create( "dSquadPanel" , squad_window_frame )
    end
end )

if (SQUAD.Config.UseCMenu) then

list.Set( "DesktopWindows" , "SquadInvitation" , {
    title = "Squads" ,
    icon = png_icon ,
    width = 600 ,
    height = 500 ,
    onewindow = true ,
    init = function( _ , wd )
        squad_window_frame = wd

        if ( LocalPlayer( )._squad ~= "" ) then
            squad_window = vgui.Create( "dSquadPanel" , squad_window_frame )
        else
            wd.Paint = function( ) end
            net.Start( "Squad.Verify" )
            net.WriteString( LocalPlayer( )._squad or "" )
            net.SendToServer( )
        end
    end
} )

end

concommand.Add( "squad_admin" , function( ply )
    if ( ply:IsAdmin( ) or table.HasValue( SQUAD.Config.AdminPanelView , ply:GetUserGroup( ) ) ) then
        local frame = vgui.Create( "DFrame" )
        frame:SetSize( 600 , 500 )
        frame:Center( )
        frame:MakePopup( )
        frame:SetTitle( "Squad Administration" )

        frame.Paint = function( _ , w , h )
            util.DrawBlur( frame , 2 , 4 )
            surface.SetDrawColor( 0 , 0 , 0 , 100 )
            surface.DrawRect( 0 , 0 , w , h )
            surface.SetDrawColor( 0 , 0 , 0 , 150 )
            surface.DrawOutlinedRect( 0 , 0 , w , h )
        end

        frame.Squads = vgui.Create( "DListView" , frame )
        frame.Squads:SetPos( 16 , 38 )
        frame.Squads:SetSize( 228 , 256 - 38 - 16 )
        frame.Squads:AddColumn( "Squad name" )
        frame.Member = vgui.Create( "DListView" , frame )
        frame.Member:SetPos( 500 - 16 - 228 , 38 )
        frame.Member:SetSize( 228 , 256 - 38 - 16 )
        frame.Member:AddColumn( "Members" )

        for k , v in pairs( SQUAD.Groups ) do
            if ( k ~= "" ) then
                local line = frame.Squads:AddLine( v.Name )
                line.Data = v
                line.Tag = k
                line.oM = line.OnMousePressed

                line.OnMousePressed = function( s , val )
                    s:oM( val )
                    frame.Member:Clear( )

                    if ( SQUAD.Groups[ s.Tag ] and SQUAD.Groups[ s.Tag ].Members ) then
                        if ( #( SQUAD.Groups[ s.Tag ] or {
                            Members = { }
                        } ).Members > 0 ) then
                            for _ , ply in pairs( SQUAD.Groups[ s.Tag ].Members ) do
                                if ( IsValid( ply ) ) then
                                    frame.Member:AddLine( ply:Nick( ) )
                                else
                                    table.RemoveByValue( SQUAD.Groups[ s.Tag ].Members , ply )
                                end
                            end
                        else
                            SQUAD.Groups[ s.Tag ] = nil
                        end
                    end
                end
            else
                SQUAD.Groups[ k ] = nil
                continue
            end
        end
    end
end )
