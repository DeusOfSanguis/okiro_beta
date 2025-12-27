TLib.Cfg.DefaultCurrency = "$"                                      -- Default currency (for non-registered gamemodes)
TLib.Cfg.Use24hCycle = true                                         -- true: use 24h cycle, false: use 12h cycle
TLib.Cfg.Max2DSounds = 5                                            -- Maximum amount of 2D sounds playable at the same time
TLib.Cfg.OverrideGMNotifs = false                                   -- true: TLib notif design will be used when TLib:Notify is called, false: Only used for gamemode compatibility

--[[

    Colors

]]--

TLib.Cfg.Colors = {
    [ 0 ] = Color( 22, 23, 27 ),                                    -- Background
    [ 1 ] = Color( 29, 30, 34 ),                                    -- Container
    [ 2 ] = Color( 76, 82, 85 ),                                    -- Highlight
    [ 3 ] = Color( 46, 204, 113 ),                                  -- Positive
    [ 4 ] = Color( 255, 65, 67 ),                                   -- Negative
    [ 5 ] = Color( 236, 240, 241 ),                                 -- Text
    [ 6 ] = Color( 46, 204, 113 ),                                  -- Main
    [ 7 ] = Color( 0, 0, 0, 150 )                                   -- Shadow
}