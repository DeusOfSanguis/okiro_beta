-- AddMoney (1: DarkRP, 2: Nutscript, 3: Helix)
local tAddMoney = {
    [ 1 ] = function( pPlayer, iMoney ) pPlayer:addMoney( iMoney ) end,
    [ 2 ] = function( pPlayer, iMoney ) pPlayer:getChar():giveMoney( iMoney ) end,
    [ 3 ] = function( pPlayer, iMoney )
        local iWallet = ( pPlayer:GetCharacter():GetMoney() or 0 )
        pPlayer:GetCharacter():SetMoney( iWallet + iMoney )
    end
}
-- Notify (1: DarkRP, 2: Nutscript, 3: Helix)
local tNotify = {
    [ 1 ] = function( pPlayer, sNotif, iType, iTime ) DarkRP.notify( pPlayer, ( iType or 0 ), ( iTime or 4 ), sNotif ) end,
    [ 2 ] = function( pPlayer, sNotif ) nut.util.notify( sNotif, pPlayer ) end,
    [ 3 ] = function( pPlayer, sNotif ) pPlayer:Notify( sNotif ) end
}
-- AddXP (1: GlorifiedLeveling, 2: Vrondakis, 3: EliteXP)
local tAddXP = {
    [ 1 ] = function( pPlayer, iXP ) GlorifiedLeveling.AddPlayerXP( pPlayer, iXP ) end,
    [ 2 ] = function( pPlayer, iXP ) pPlayer:addXP( iXP ) end,
    [ 3 ] = function( pPlayer, iXP ) EliteXP.CheckXP( pPlayer, iXP ) end
}

--[[

    TLib:AddMoney
        - Desc: Add money to the targeted player, helper functions for gamemode compatibilities
        - Params: Target (player), Money amount (number)

]]--

function TLib:AddMoney( pPlayer, iMoney )
    if DarkRP then return tAddMoney[ 1 ]( pPlayer, iMoney ) end
    if nut then return tAddMoney[ 2 ]( pPlayer, iMoney ) end
    if ix then return tAddMoney[ 3 ]( pPlayer, iMoney ) end
end

--[[

    TLib:Notify
        - Desc: Send a notification to the targeted player, helper functions for gamemode compatibilities
        - Params: Target (player), Notification (string), DarkRP notif type (number), DarkRP notif time (number)

]]--

function TLib:Notify( pPlayer, sNotif, iType, iTime )
    if DarkRP then return tNotify[ 1 ]( pPlayer, sNotif, iType, iTime ) end
    if nut then return tNotify[ 2 ]( pPlayer, sNotif ) end
    if ( ix and ix.currency ) then return tNotify[ 3 ]( pPlayer, sNotif ) end
end

--[[

    TLib:AddXP
        - Desc: Add XP if a leveling system is found
        - Params: Target (player), XP amount (number)

]]--

function TLib:AddXP( pPlayer, iXP )
    if GlorifiedLeveling then return tAddXP[ 1 ]( pPlayer, iXP ) end
    if LevelSystemConfiguration  then return tNotify[ 2 ]( pPlayer, iXP ) end
    if EliteXP then return tNotify[ 3 ]( pPlayer, iXP ) end
end

--[[

    TLib:SetEntOwner
        - Desc: Universal method to set the owner of an entity
        - Params: Owned entity (entity), Owner (player)

]]--

function TLib:SetEntOwner( eEntity, pOwner )
    if not IsValid( eEntity ) or eEntity:IsPlayer() then
        return
    end

    if IsValid( pOwner ) and pOwner:IsPlayer() then
        eEntity.pOwner = pOwner
    end

    if DarkRP then
        eEntity:CPPISetOwner( pOwner )
    end
end

--[[

    TLib:GetEntOwner

]]--

function TLib:GetEntOwner( eEntity )
    if not IsValid( eEntity ) then
        return
    end

    return eEntity.pOwner
end