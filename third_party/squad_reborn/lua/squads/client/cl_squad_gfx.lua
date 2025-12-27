surface.CreateFont( "bebas_48" , {
    font = "Lexend" ,
    size = 48
} )

surface.CreateFont( "bebas_18" , {
    font = "Lexend Medium" ,
    size = 20
} )

function createFonts( )
    surface.CreateFont( "bebas_48_hud" , {
        font = "Lexend" ,
        size = 48 * SQUAD.Config.HUDScale
    } )

    surface.CreateFont( "bebas_18_hud" , {
        font = "Lexend" ,
        size = 20
    } )
end

createFonts( )

for k , v in pairs( player.GetAll( ) ) do
    if ( IsValid( v.AvatarImage ) ) then
        v.AvatarImage:Remove( )
    end
end

local space = 0
local posX = 64
local posY = 96
local tX = 0
local ply = nil
local mic = Material( "icon16/sound.png" )

hook.Add( "HUDPaint" , "Squad.HUDPaint" , function( )
    if ( not IsValid( ply ) and IsValid( LocalPlayer( ) ) ) then
        ply = LocalPlayer( )
    end

    local sc = SQUAD.Config.HUDScale

    if ( LocalPlayer( ):GetSquadName( ) ~= "" ) then
        local alpha = SQUAD.Config.HUDOpacity
        local members = ply:GetSquadMembers( ) or { }
        local biggerX = 0
        local fx , _ = draw.SimpleText( LocalPlayer( ):GetSquadName( ) , "bebas_48_hud" , posX , posY , Color( 170 , 255 , 100 , alpha ) , TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM )
        draw.SimpleText( LocalPlayer( ):GetSquad( ).Name , "bebas_48_hud" , posX + fx + 8 , posY , Color( 255 , 255 , 255 , alpha ) , TEXT_ALIGN_LEFT , TEXT_ALIGN_BOTTOM )

        for k , v in pairs( members ) do
            k = k - 1

            if ( IsValid( v.AvatarImage ) ) then
                v.AvatarImage:PaintManual( )
                v.AvatarImage:SetPos( posX + k * space , posY + ( 64 * sc ) * k - 38 )
            elseif ( IsValid( v ) ) then
                v.AvatarImage = vgui.Create( "AvatarImage" )
                v.AvatarImage:SetSize( 32 * sc , 32 * sc )
                v.AvatarImage:SetPlayer( v , 32 )
                v.AvatarImage:SetPaintedManually( true )
                v.AvatarImage:SetPos( posX + k * space , posY + ( 64 * sc ) * k )
                v.AvatarImage.Player = v

                v.AvatarImage.Think = function( s )
                    if ( not IsValid( s.Player ) ) then
                        s:Remove( )

                        return
                    end

                    if ( not IsValid( s ) ) then
                        s:Remove( )

                        return
                    end

                    s:SetPos( posX + k * space , posY + ( 62 * sc ) * k + 48 * sc - 32 * sc - 4 )

                    if ( s.Player:GetSquadName( ) ~= LocalPlayer( ):GetSquadName( ) or s.Player:GetSquadName( ) == "" ) then
                        s:Remove( )
                    end
                end
            else
                table.RemoveByValue( SQUAD.Groups[ LocalPlayer( )._squad ].Members , v )

                return
            end

            k = k + 0.5
            tX , _ = draw.SimpleText( "- " .. v:Name( ) , "bebas_48_hud" , posX + k * space + 42 * sc , posY + ( 62 * sc ) * k + 48 * sc - 74 * sc , Color( 255 , 255 , 255 , v:Alive( ) and alpha - math.min( v.DamageHUD or 0 , alpha ) or 50 ) , TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP )

            if ( ( v.DamageHUD or 0 ) > 0 ) then
                draw.SimpleText( "- " .. v:Name( ) , "bebas_48_hud" , posX + k * space + 42 * sc , posY + ( 62 * sc ) * k + 48 * sc - 74 * sc , Color( 255 , 0 , 0 , math.min( v.DamageHUD , alpha ) ) , TEXT_ALIGN_LEFT , TEXT_ALIGN_TOP )
                v.DamageHUD = Lerp( FrameTime( ) * 2 , v.DamageHUD , -5 )
            end

            k = k - 0.5
            local wdx = math.max( tX + 42 + 48 , ScrW( ) / 8 )

            if ( wdx > biggerX ) then
                biggerX = wdx
            else
                wdx = biggerX
            end

            surface.SetDrawColor( 255 , 255 , 255 , alpha / 5 )
            surface.DrawRect( posX + k * space , posY + ( 62 * sc ) * k + 48 * sc , wdx , 1 )
            local tbX , _ = draw.SimpleText( math.max( v:Health( ) , 0 ) , "bebas_18_hud" , posX + k * space + wdx , posY + ( 62 * sc ) * k + 48 * sc - 16 , v:GetHealthColor( v:Alive( ) and alpha or 50 ) , TEXT_ALIGN_RIGHT , TEXT_ALIGN_BOTTOM )
            draw.SimpleText( v:Armor( ) , "bebas_18_hud" , posX + k * space + wdx , posY + ( 62 * sc ) * k + 48 * sc , Color( 255 , 255 , 255 , v:Alive( ) and ( alpha * 0.75 ) or 50 ) , TEXT_ALIGN_RIGHT , TEXT_ALIGN_BOTTOM )
            draw.SimpleText( "HP: " , "bebas_18_hud" , posX + k * space + wdx - tbX , posY + ( 62 * sc ) * k + 48 * sc - 16 , Color( 255 , 255 , 255 , v:Alive( ) and ( alpha * 0.75 ) or 50 ) , TEXT_ALIGN_RIGHT , TEXT_ALIGN_BOTTOM )
            draw.SimpleText( "AP: " , "bebas_18_hud" , posX + k * space + wdx - tbX , posY + ( 62 * sc ) * k + 48 * sc , Color( 255 , 255 , 255 , v:Alive( ) and ( alpha * 0.75 ) or 50 ) , TEXT_ALIGN_RIGHT , TEXT_ALIGN_BOTTOM )

            if ( v:GetNWBool( "Squad.Voice" , false ) and v.DoingVoice ) then
                draw.NoTexture( )
                local x = posX + k * space + wdx + 12
                local y = posY + ( 62 * sc ) * k + 48 * sc - 24
                draw.gsArc( x + 12 , y + 8 , 0 , 16 * v:VoiceVolume( ) , 0 , 361 , 1 , Color( 255 , 255 , 255 , alpha * 0.8 + math.cos( RealTime( ) * 8 ) * 55 ) )
                surface.SetDrawColor( color_white )
                surface.SetMaterial( mic )
                surface.DrawTexturedRect( x + 4 , y , 16 , 16 )
            end
        end

        render.SetBlend( 1 )
    end
end )

local openFactor = 0

hook.Add( "PostDrawTranslucentRenderables" , "Squad.DrawMinimap" , function( )
    if ( IsValid( ply ) and ply:GetSquadName( ) ~= "" and not vgui.CursorVisible()) then
        if ( input.IsKeyDown( SQUAD.Config.MinimapKey ) ) then
            openFactor = Lerp( FrameTime( ) * 2 , openFactor , 0.2 )
        elseif ( openFactor > 0 ) then
            openFactor = Lerp( FrameTime( ) * 8 , openFactor , -0.25 )
        end

        if ( openFactor <= 0 ) then return end
        cam.IgnoreZ( true )
        cam.Start3D2D( ply:GetPos( ) , Angle( 0 , 180 , 180 ) , openFactor )
        draw.NoTexture( )

        draw.gsArc( 0 , 0 , 1024 , 32 , 0 , 368 , 0.8 , Color( 255 , 255 , 255 , 50 ) )

        for k , v in pairs( ply:GetSquadMembers( ) ) do
            if ( v:IsValid() and v ~= ply ) then
                local dist = math.Clamp( v:GetPos( ):Distance( ply:GetPos( ) ) , -1024 , 1024 )
                local ang = math.rad( angleBetweenPoints( ply:GetPos( ) , v:GetPos( ) ) + 180 )
                local angB = angleBetweenPoints( Vector( math.cos( ang ) * dist , math.sin( ang ) * dist , 0 ) , Vector( 0 , 0 , 0 ) )
                draw.gsArc( math.cos( ang ) * dist / 2 , math.sin( ang ) * dist / 2 , dist / 2 , 2 , -angB , -angB + 184 , 1 , Color( v:GetPlayerColor( ).x * 255 , v:GetPlayerColor( ).y * 255 , v:GetPlayerColor( ).z * 255 , 100 ) )
                draw.gsArc( math.cos( ang ) * dist , math.sin( ang ) * dist , 24 , 24 , 0 , 365 , 1 , Color( v:GetPlayerColor( ).x * 255 , v:GetPlayerColor( ).y * 255 , v:GetPlayerColor( ).z * 255 ) )
            end
        end

        draw.gsArc( 0 , 0 , 16 , 16 , 0 , 361 , 0.8 , Color( 255 , 255 , 255 , 255 ) )
        cam.End3D2D( )
        cam.IgnoreZ( false )

        for k , v in pairs( ply:GetSquadMembers( ) ) do
            local ang = math.rad( angleBetweenPoints( ply:GetPos( ) , v:GetPos( ) ) - 4 + 180 )
            local dist = math.Clamp( v:GetPos( ):Distance( ply:GetPos( ) ) , -1024 , 1024 ) * ( openFactor / 0.2 )
            cam.IgnoreZ( true )
            cam.Start3D2D( ply:GetPos( ) - Vector( math.cos( ang ) * dist / 5 , math.sin( ang ) * dist / 5 , 0 ) , Angle( 0 , math.deg( ang ) + 90 , 0 ) , openFactor )

            if ( v ~= ply ) then
                draw.SimpleText( v:Nick( ) , "bebas_48" , 4 , -24 , color_white )
            end

            cam.End3D2D( )
            cam.IgnoreZ( false )
        end
    end
end )

net.Receive( "Squad.SendPlyDamage" , function( )
    net.ReadEntity( ).DamageHUD = 255
end )

function SQUAD.PlyMeta:GetHealthColor( a )
    local col = Color( 231 , 76 , 60 , a )

    if ( self:Health( ) > 30 ) then
        if ( self:Health( ) < 50 ) then
            col = Color( 230 , 126 , 34 , a )
        elseif ( self:Health( ) < 75 ) then
            col = Color( 241 , 196 , 15 , a )
        else
            col = Color( 46 , 204 , 113 , a )
        end
    end

    return col
end

--https://facepunch.com/showthread.php?t=1509349&p=49878319&viewfull=1#post49878319
local blur = Material( "pp/blurscreen" )
local scrw = ScrW( )
local scrh = ScrH( )

function util.DrawBlur( p , a , d )
    local x , y = p:LocalToScreen( 0 , 0 )
    surface.SetDrawColor( 255 , 255 , 255 )
    surface.SetMaterial( blur )

    for i = 1 , d do
        blur:SetFloat( "$blur" , ( i / d ) * a )
        blur:Recompute( )
        render.UpdateScreenEffectTexture( )
        surface.DrawTexturedRect( x * -1 , y * -1 , scrw , scrh )
    end
end
