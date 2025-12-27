-- TLib:GetMoney
local tGetWallet = {
    [ 1 ] = function( pPlayer ) return ( pPlayer:getDarkRPVar( "money" ) or 0 ) end,
    [ 2 ] = function( pPlayer ) return ( pPlayer:getChar():getMoney() or 0 ) end,
    [ 3 ] = function( pPlayer ) return ( pPlayer:GetCharacter():GetMoney() or 0 ) end
}

-- TLib:FormatMoney (1: DarkRP, 2: Nutscript, 3: Helix)
local tGetMoneyStr = {
    [ 1 ] = function( iMoney ) return DarkRP.formatMoney( iMoney or 0 ) end,
    [ 2 ] = function( iMoney ) return nut.currency.get( iMoney ) end,
    [ 3 ] = function( iMoney ) return ix.currency.Get( iMoney or 0 ) end
}

-- TLib:GetBankMoney (1: SlownLS ATM, 2: DarkRP foundation, 3: Glorified Banking)
local tGetBank = {
    [ 1 ] = function( pPlayer ) return ( pPlayer:SlownLS_ATM_Balance() or 0 ) end,
    [ 2 ] = function( pPlayer ) return ( pPlayer:DRPF_BankingGet().AccountBalance or 0 ) end,
    [ 3 ] = function( pPlayer ) return ( pPlayer:GetBankBalance() or 0 ) end,
}

-- TLib:GetFormattedTime (1: Real time, 2: StormFox time)
local tGetTime = {
    [ 1 ] = function( bCircatidal ) return os.date( ( bCircatidal and "%I" or "%H" ) .. ":%M", os.time() ) end,
    [ 2 ] = function( bCircatidal ) return os.date( ( bCircatidal and "%I" or "%H" ) .. ":%M", ( StormFox.GetTime( true ) * 60 ) ) end
}

-- TLib:GetFormattedDate (1: Real date, 2: StormFox date)
local tGetDate = {
    [ 1 ] = function() return os.date( "%x", os.time() ) end,
    [ 2 ] = function()
        local iDD, iMM = StormFox.GetDate()
        return ( ( ( iDD > 9 ) and iDD or ( "0" .. iDD ) ) .. "/" .. ( ( iMM > 9 ) and iMM or ( "0" .. iMM ) ) )
    end
}

--[[-------------------------------------------------------------------------------------------------------------------------

    FUNCTIONS

-------------------------------------------------------------------------------------------------------------------------]]--

--[[

    TLib:GetMoney
        - Params: Target (player)
        - Return: Wallet bank money (number)

]]--

function TLib:GetMoney( pPlayer )
    if DarkRP then
        return tGetWallet[ 1 ]( pPlayer )
    elseif nut then
        return tGetWallet[ 2 ]( pPlayer )
    elseif ix then
        return tGetWallet[ 3 ]( pPlayer )
    end

    return 0
end

--[[

    TLib:GetBankMoney
        - Params: Target (player)
        - Return: Player bank money (number)

]]--

function TLib:GetBankMoney( pPlayer )
    local pPlayer = ( CLIENT and LocalPlayer() or pPlayer )

    if pPlayer.SlownLS_ATM_Balance then
        return tGetBank[ 1 ]( pPlayer )
    elseif pPlayer.DRPF_BankingGet then
        return tGetBank[ 2 ]( pPlayer )
    elseif pPlayer.GetBankBalance then
        return tGetBank[ 3 ]( pPlayer )
    elseif BATM then
        return tGetBank[ 4 ]( pPlayer )
    end
end

--[[

    TLib:FormatMoney
        - Desc:
        - Params:
        - Return: 

]]--

function TLib:FormatMoney( iMoney )
    if DarkRP then
        return tGetMoneyStr[ 1 ]( iMoney )
    elseif nut then
        return tGetMoneyStr[ 2 ]( iMoney )
    elseif ix then
        return tGetMoneyStr[ 3 ]( iMoney )
    end

    return ( self:L( 1 ) .. string.Comma( iMoney ) )
end

--[[

    TLib:CanAfford
        - Desc: Performs a money check
        - Params: Target (player), Required money (number)
        - Return: Can afford (boolean)

]]--

function TLib:CanAfford( pPlayer, iPrice )
    return ( self:GetMoney( pPlayer ) >= ( iPrice or 0 ) )
end



--[[

    TLib:GetFormattedTime
        Params: Force real time even if addons like SF are installed (boolean)[, Force circatidal cycle (boolean) ]
        Return: Formatted time ("HH:MM")

]]--

function TLib:GetFormattedTime( bForceReal, bCircatidal )
    if bForceReal then
        return tGetTime[ 1 ]( bCircatidal )
    elseif StormFox then
        return tGetTime[ 2 ]( bCircatidal )
    end

    return tGetTime[ 1 ]( bCircatidal )
end

--[[

    TLib:GetFormattedDate
        Params: Force real date even if addons like SF are installed (boolean)
        Return: Formatted date ("MM:DD" )

]]--

function TLib:GetFormattedDate( bForceReal )
    if bForceReal then
        return tGetDate[ 1 ]()

    elseif StormFox then
        return tGetDate[ 2 ]()
    end

    return tGetDate[ 1 ]()
end

--[[

    TLib:FormatTime
        - Desc:
        - Params:
        - Return: 

]]--

function TLib:FormatTime( iTime )
    if not iTime or ( iTime <= 0 ) then
        return "00:00"
    end

    local iHour = string.format( "%02.f", math.floor( ( iTime / 3600 ) ) )
    local iMin = string.format( "%02.f", math.floor( ( ( iTime / 60 ) - ( iHour * 60 ) ) ) )
    local iSec = string.format( "%02.f", math.floor( ( iTime - ( iHour * 3600 ) - ( iMin * 60 ) ) ) )

    if ( iTime < 3600 ) then
        return ( iMin .. ":" .. iSec )
    end

    return ( iHour .. ":" .. iMin .. ":" .. iSec )
end

--[[

    TLib:FormatWeight
        - Desc:
        - Params:
        - Return: 

]]--

function TLib:FormatWeight( iWeightGrams )
    if ( iWeightGrams < 1000 ) then
        return ( iWeightGrams .. "g" )
    end

    return ( math.Round( ( iWeightGrams / 1000 ), 2 ) .. "kg" )
end