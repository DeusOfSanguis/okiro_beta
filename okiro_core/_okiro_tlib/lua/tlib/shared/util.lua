--[[

    IsMaterial

]]--

function IsMaterial( xObject )
    return ( type( xObject ) == "IMaterial" )
end

--[[

    TLib:BitsToUInt
        - Desc: Converts a unsigned bitcount to it's maximal value
        - Params: Unsigned bitcount (number)
        - Return: Max value (number)

]]--

function TLib:BitsToNumber( iBitCount )
    return ( ( 2 ^ iBitCount ) - 1 )
end

--[[

    TLib:StringifyKeys
        - Desc: Converts all keys of an array to strings (only works with uni-dimensional arrays)
        - Params: tTarget (table)
        - Return: "Stringified" array (table)

]]--

function TLib:StringifyKeys( tTarget )
    local tArray = {}
    for k, v in pairs( tTarget ) do
        tArray[ tostring( k ) ] = v
    end

    return tArray
end

--[[

    TLib:C
        - Params: ID (number)
        - Return: Color object (color)

]]--

function TLib:C( iID )
    return self.Cfg.Colors[ iID ]
end

--[[

    TLib:SetBrightness
        - Desc: Changes the brightness of a color
        - Params: Color object (color), New brightness level (number)
        - Return: Color object (color)

]]--

function TLib:SetBrightness( tCol, iLevel )
    if ( iLevel == 100 ) then
        return tCol
    end

    local i = ( iLevel * .01 )
    return Color( ( tCol.r * i ), ( tCol.g * i ), ( tCol.b * i ), ( tCol.a or 255 ) )
end

--[[

    TLib:ForceNumeric
        Args: Input (any type)[, Value returned on fail {default: 0} (number)]
        Return: Numerical value (number)

]]--

function TLib:ForceNumeric( xValue, iFail )
    local iFail = ( iFail or 0 )
    if not xValue then
        return iFail
    end

    if isnumber( xValue ) then
        return xValue
    end

    if istable( xValue ) then
        local iMin, iMax = false, false
        for k, v in ipairs( table.ClearKeys( xValue ) ) do
            if isnumber( v ) then
                iMin = math.min( ( iMin or v ), v )
                iMax = math.max( ( iMax or v ), v )
            end
        end

        if not iMin or not iMax then
            return iFail
        end

        return math.random( iMin, iMax )
    end

    return iFail
end

--[[

    TLib:LerpColor
        - Desc: Run interpolations between two colors
        - Params: Time (number), Starting color (color), Target color (color)
        - Return: Lerps result (color)

]]--

function TLib:LerpColor( fTime, tFrom, tTo )
    return Color(
        Lerp( fTime, tFrom.r, tTo.r ),
        Lerp( fTime, tFrom.g, tTo.g ),
        Lerp( fTime, tFrom.b, tTo.b ),
        Lerp( fTime, tFrom.a, tTo.a )
    )
end
