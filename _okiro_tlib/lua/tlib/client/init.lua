local iLastH = 0
local iMargin = 0
local iRoundness = 0

--[[

    Materials

]]--

TLib.Mat = {
    [ 0 ] = Material( "tlib/circle_filled.png", "smooth" ),
    [ 1 ] = Material( "vgui/gradient-r", "smooth" ),
    [ 2 ] = Material( "vgui/gradient-l", "smooth" ),
    [ 3 ] = Material( "vgui/gradient-d", "smooth" ),
    [ 4 ] = Material( "vgui/gradient-u", "smooth" ),
    [ 5 ] = Material( "tlib/info.png", "smooth" ),
}

--[[

    Absolute fonts

]]--

for i = 16, 96, 8 do
    surface.CreateFont( "TLib.R." .. i, { font = "Rajdhani Regular", size = i } )
    surface.CreateFont( "TLib.B." .. i, { font = "Rajdhani Bold", size = i } )
end

--[[

    TLib:ScaleVGUI
        Desc: Creates (or recreate if screen size has changed) responsive fonts and define VGUI margin and roundness
        Return: Margin (number), Roundness (number), Screen height (number)

]]--

function TLib:ScaleVGUI()
    local iH = ScrH()
    if ( iLastH == iH ) then
        return iMargin, iRoundness
    end

    -- Responsive fonts
    local ceil = math.ceil
    local iH5, iH4, iH3, iH2, iH1 = ceil( iH * .02 ), ceil( iH * .024 ), ceil( iH * .026 ), ceil( iH * .03 ), ceil( iH * .04 )

    surface.CreateFont( "TLib.Small", { font = "Rajdhani Regular", size = iH5 } )
    surface.CreateFont( "TLib.SmallItalic", { font = "Rajdhani Regular", size = iH5, italic = true } )

    surface.CreateFont( "TLib.Standard", { font = "Rajdhani Regular", size = iH4 } )
    surface.CreateFont( "TLib.StandardItalic", { font = "Rajdhani Regular", size = iH4, italic = true } )

    surface.CreateFont( "TLib.Big", { font = "Rajdhani Bold", size = iH3 } )
    surface.CreateFont( "TLib.BigItalic", { font = "Rajdhani Bold", size = iH3, italic = true } )

    surface.CreateFont( "TLib.Subtitle", { font = "Rajdhani Regular", size = iH2 } )
    surface.CreateFont( "TLib.SubtitleItalic", { font = "Rajdhani Regular", size = iH2, italic = true } )

    surface.CreateFont( "TLib.Title", { font = "Rajdhani Bold", size = iH1 } )
    surface.CreateFont( "TLib.TitleItalic", { font = "Rajdhani Bold", size = iH1, italic = true } )    

    iLastH, iMargin, iRoundness = iH, ceil( iH * .008 ), ceil( iH * .006 )

    return iMargin, iRoundness
end

TLib:ScaleVGUI()