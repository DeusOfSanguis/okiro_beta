MagieReroll = MagieReroll or {}
MagieReroll.Config = {}

MagieReroll.UI = MagieReroll.UI or {}
MagieReroll.Ranks = MagieReroll.Ranks or {}
MagieReroll.Ranks.Config = MagieReroll.Ranks.Config or {}

CardShuffle = CardShuffle or {}
CardShuffle.Config = CardShuffle.Config or {}

local include_sv = (SERVER) and include or function() end
local include_cl = (SERVER) and AddCSLuaFile or include
local include_sh = function(f)
	include_sv(f)
	include_cl(f)
end

include_sh( 'reroll/magie/config.lua' )
include_cl( 'reroll/magie/core/client.lua' )
include_sv( 'reroll/magie/core/server.lua' )

include_cl( 'reroll/magie/ui/util.lua')
include_cl( 'reroll/magie/ui/frame.lua')
include_cl( 'reroll/magie/ui/item_panel.lua')
include_cl( 'reroll/magie/ui/scroll.lua')
include_cl( 'reroll/magie/ui/button.lua')
include_cl( 'reroll/magie/ui/back.lua')


include_sh( 'reroll/ranks/config.lua' )
include_cl( 'reroll/ranks/core/client.lua' )
include_sv( 'reroll/ranks/core/server.lua' )

include_cl( 'reroll/ranks/ui/frame.lua')
include_cl( 'reroll/ranks/ui/item_panel.lua')
include_cl( 'reroll/ranks/ui/scroll.lua')
include_cl( 'reroll/ranks/ui/button.lua')


include_sh( 'reroll/cards/config.lua' )
include_cl( 'reroll/cards/core/client.lua' )
include_sv( 'reroll/cards/core/server.lua' )

include_cl( 'reroll/cards/ui/frame.lua')
include_cl( 'reroll/cards/ui/card.lua')
include_cl( 'reroll/cards/ui/button.lua')


if SERVER and MagieReroll.Config.DownloadFiles then
    function resource.AddFolder(dir, recurse, pattern)
        local files, folders = file.Find(dir .. (pattern and ("/".. pattern) or "/*"), "GAME")
    
        for i, fname in ipairs(files) do
            resource.AddSingleFile(dir .."/".. fname)
        end
    
        if recurse then
            for i, subdir in ipairs(folders) do
                resource.AddFolder(dir .."/".. subdir, recurse, pattern)
            end
        end
    end
    
    resource.AddFolder( 'materials/sincopa/reroll', true )

    resource.AddSingleFile( 'resource/fonts/albertsans-black.ttf' )
    resource.AddSingleFile( 'resource/fonts/albertsans-semibold.ttf' )
    resource.AddSingleFile( 'resource/fonts/lexend-medium.ttf' )
end