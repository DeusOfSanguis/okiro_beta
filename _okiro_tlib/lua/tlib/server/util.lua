--[[

    TLib:RecursiveFolderDL
        - Desc: Recursively finds all folders and files in the specified root and make them downloadable to the client from the server
        - Params: Root path (string)

]]--

function TLib:RecursiveFolderDL( sRoot )
    local tFiles, tFolders = file.Find( sRoot .. "/*", "GAME" )

    for _, sFile in pairs( tFiles ) do
        resource.AddFile( sRoot .. "/" .. sFile )
    end

    for _, sFolder in pairs( tFolders ) do
        self:RecursiveFolderDL( sRoot .. "/" .. sFolder )
    end
end

TLib:RecursiveFolderDL( "sound/tlib" )
TLib:RecursiveFolderDL( "materials/tlib" )

resource.AddFile( "resource/fonts/Rajdhani-Bold.ttf" )
resource.AddFile( "resource/fonts/Rajdhani-Regular.ttf" )