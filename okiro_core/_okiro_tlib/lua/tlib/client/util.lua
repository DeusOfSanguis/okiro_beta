local draw = draw
local math = math

local CurTime = CurTime
local LocalPlayer = LocalPlayer

local tBgColor = TLib:C( 0 )
local tMainColor = TLib:C( 6 )
local tShadowColor = ColorAlpha( color_black, 240 )

--[[

    TLib:IsEntityInRange
        Desc: Performs optimized distance checks between LocalPlayer and an entity, can be called every tick without much CPU impact
        Params: Target (entity), Range (number), Delay (number)
        Return: Entity in range (boolean)

]]--

function TLib:IsEntityInRange( eEnt, iRange, fDelay )
    if not IsValid( eEnt ) then
        return
    end

    if ( CurTime() > ( eEnt.iNextDistCheck or 0 ) ) then
        if not IsValid( LocalPlayer() ) then
            return
        end

        eEnt.iLastDist = LocalPlayer():GetPos():DistToSqr( eEnt:GetPos() )
        eEnt.iNextDistCheck = ( CurTime() + ( fDelay or 1 ) )
    end

    return ( eEnt.iLastDist <= iRange )
end

--[[

    TLib:DrawEdges (1: Top left, 2: Top right, 3: Bottom right, 4: Bottom left)

]]--

local tCornerPoly = {
    [ 1 ] = function( iX, iY, iW, iH, iBarW, iBarH, iBarS )
        local iX1, iX2 = ( iX + iBarW ), ( iX + iBarS )
        local iY1, iY2 = ( iY + iBarS ), ( iY + iBarH )
        return {
            { x = iX, y = iY }, { x = iX1, y = iY }, { x = iX1, y = iY1 }, { x = iX2, y = iY1 }, { x = iX2, y = iY2 }, { x = iX, y = iY2 }
        }
    end,
    [ 2 ] = function( iX, iY, iW, iH, iBarW, iBarH, iBarS )
        local iX1, iX2 = ( iX + ( iW - iBarS ) ), ( iX + ( iW - iBarW ) )
        local iY1, iY2 = ( iY + iBarS ), ( iY + iBarH )
        return {
            { x = iX1, y = iY1 }, { x = iX2, y = iY1 }, { x = iX2, y = iY }, { x = iX + iW, y = iY }, { x = iX + iW, y = iY2 }, { x = iX1, y = iY2 }
        }
    end,
    [ 3 ] = function( iX, iY, iW, iH, iBarW, iBarH, iBarS )
        local iX1, iX2 = ( iX + ( iW - iBarS ) ), ( iX + ( iW - iBarW ) )
        local iY1, iY2 = ( iY + ( iH - iBarS ) ), ( iY + ( iH - iBarH ) )
        return {
            { x = iX1, y = iY1 }, { x = iX1, y = iY2 }, { x = iX + iW, y = iY2 }, { x = iX + iW, y = iY + iH }, { x = iX2, y = iY + iH }, { x = iX2, y = iY1 }
        }
    end,
    [ 4 ] = function( iX, iY, iW, iH, iBarW, iBarH, iBarS )
        local iX1, iX2 = ( iX + iBarS ), ( iX + iBarW )
        local iY1, iY2 = ( iY + ( iH - iBarS ) ), ( iY + ( iH - iBarH )  )
        return {
            { x = iX, y = iY + iH }, { x = iX, y = iY2 }, { x = iX1, y = iY2 }, { x = iX1, y = iY1 }, { x = iX2, y = iY1 }, { x = iX2, y = iY + iH }
        }
    end,
}

function TLib:DrawEdges( iX, iY, iW, iH, iBarW, iBarH, iBarS )
    draw.NoTexture()
    for k, v in ipairs( tCornerPoly ) do
        surface.DrawPoly( v( iX, iY, iW, iH, iBarW, iBarH, iBarS ) )
    end
end

--[[

    TLib:DrawProgressBar

]]--

function TLib:DrawProgressBar( iX, iY, iW, iH, iProg, tColor )
    local iProgW = ( math.Clamp( 0, iProg, 100 ) * iW / 100 )

    surface.SetDrawColor( tBgColor )
    surface.DrawRect( iX, iY, iW, iH )

    surface.SetDrawColor( tColor or tMainColor )
    surface.DrawRect( iX, iY, ( iW - iProgW ), iH )
end

--[[

    TLib:DrawLoader

]]--

function TLib:DrawLoader( iX, iY, iW, iH, iPoints )
    local iPoints = ( iPoints or 6 )
    local iBranchH = ( iW / ( iPoints * 2 ) )

    for i = 1, iPoints do
        local iBranchX = ( iX + ( ( i - 1 ) * ( iBranchH * 2 ) ) )
        local iBranchY = ( iY + TimedSin( 1, ( iH * .5 ), 0, ( i /2 ) ) )
        local iScale = ( iBranchY * iBranchH / iH )

        surface.DrawRect( iBranchX, iBranchY, iScale, iScale )
    end
end

--[[

    TLib:DrawEntOverhead

]]--

local iOffsetY = 20

function TLib:DrawEntOverhead( eEnt, sText1, sText2, sText3 )
    if ( CurTime() > ( eEnt.iNextOHCheck or 0 ) ) then
        iOffsetY = ( ScrH() * .02 )
        eEnt.iMaxZ = ( eEnt.iMaxZ or eEnt:OBBMaxs().z )
        eEnt.iNextOHCheck = ( CurTime() + 5 )
    end

    local tToScreen = ( eEnt:GetPos() + ( eEnt:GetUp() * eEnt.iMaxZ ) ):ToScreen()

    cam.Start2D()
        if sText1 then
            TLib:TextShadow( sText1, "TLib.Small", tToScreen.x, ( tToScreen.y - ( iOffsetY * 2 ) ), color_white, 1, 1 )
        end
        if sText2 then
            TLib:TextShadow( sText2, "TLib.Big", tToScreen.x, ( tToScreen.y - iOffsetY ), color_white, 1, 1 )
        end
        if sText3 then
            TLib:TextShadow( sText3, "TLib.Small", tToScreen.x, tToScreen.y, color_white, 1, 1 )
        end
    cam.End2D()

    return tToScreen
end

--[[

    TLib:KeyTooltip

]]--

local tKeysTT = {}
hook.Add( "OnScreenSizeChanged", "TLib_ClearKeysTT", function( iOldW, iOldH )
	tKeysTT = {}
end )

function TLib:KeyTooltip( sKey, sText, iX, iY )
    if not tKeysTT[ sKey ] then
        surface.SetFont( "TLib.Big" )
        local iKeyW, iKeyH = surface.GetTextSize( sKey )
        tKeysTT[ sKey ] = { w = iKeyW + ( iKeyH * .5 ), h = ( iKeyH * .8 ) }
        return
    end

    local tKey = tKeysTT[ sKey ]

    draw.RoundedBox( ( tKey.h * .25 ), iX - ( tKey.w * .5 ), iY - ( tKey.h * .5 ) + 3, tKey.w, tKey.h, TLib:C( 2 ) )
    draw.RoundedBox( ( tKey.h * .25 ), iX - ( tKey.w * .5 ) + 1, iY - ( tKey.h * .5 ) + 1, tKey.w - 2, tKey.h - 1, TLib:C( 5 ) )

    draw.SimpleText( sKey, "TLib.Big", iX, iY + 1, TLib:C( 2 ), 1, 1 )

    if sText then
        TLib:TextShadow( sText, "TLib.Standard", iX + ( tKey.w * .5 ) + 6, iY, TLib:C( 5 ), 0, 1 )
    end
end

--[[

    TLib:TextShadow

]]--



function TLib:TextShadow( sText, sFont, iX, iY, tTextCol, iAlignX, iAlignY, iDist, iAlpha )
    -- local tText = { text = sText, font = sFont, pos = { iX, iY }, xalign = iAlignX, yalign = iAlignY, color = tTextCol }

    -- draw.TextShadow( tText, 2, 240 )
    -- draw.Text( tText )

    draw.SimpleText( sText, sFont, iX + 2, iY + 2, tShadowColor, iAlignX, iAlignY )
    draw.SimpleText( sText, sFont, iX, iY, tTextCol, iAlignX, iAlignY )
end