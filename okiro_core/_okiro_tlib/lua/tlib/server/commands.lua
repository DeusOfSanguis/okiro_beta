local tCommand = {}

--[[

    mapcreationid

]]--

tCommand[ "mapcreationid" ] = function( pPlayer, sCommand, tArgs )
    if not pPlayer:IsAdmin() then
        return
    end

    local tTrace = pPlayer:GetEyeTrace()
    local iMapID = tTrace.Entity:MapCreationID()

    if not IsValid( tTrace.Entity ) or ( iMapID == -1 ) then
        pPlayer:ChatPrint( "This entity is invalid or isn't compiled into the map" )
        return
    end

    pPlayer:ChatPrint( "Map creation ID: " .. iMapID )
end

--[[

    tptopos

]]--

tCommand[ "tptopos" ] = function( pPlayer, sCommand, tArgs )
    if not pPlayer:IsAdmin() then
        return
    end

    if tArgs[ 1 ] and tArgs[ 2 ] and tArgs[ 3 ] then
        local tVect = Vector( tonumber( tArgs[ 1 ] ), tonumber( tArgs[ 2 ] ), tonumber( tArgs[ 3 ] ) )
        if not isvector( tVect ) then
            return
        end

        pPlayer:SetPos( tVect )
    end
end

local fAddCommand = concommand.Add

for sCmd, fCBack in pairs( tCommand ) do
    concommand.Add( sCmd, fCBack )
end

fAddCommand = nil
tCommand = nil