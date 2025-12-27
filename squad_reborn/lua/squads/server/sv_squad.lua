util.AddNetworkString( "Squad.SyncGroups" )
util.AddNetworkString( "Squad.QuickSyncGroups" )
util.AddNetworkString( "Squad.Verify" )
util.AddNetworkString( "Squad.AssignGroup" )
util.AddNetworkString( "Squad.CreateSquad" )
util.AddNetworkString( "Squad.PurgeGroup" )
util.AddNetworkString( "Squad.ExitSquad" )
util.AddNetworkString( "Squad.GiveWeapon" )
util.AddNetworkString( "Squad.SendMoney" )
util.AddNetworkString( "Squad.SendMessage" )
util.AddNetworkString( "Squad.SendPlyDamage" )
util.AddNetworkString( "Squad.SendInvitation" )
util.AddNetworkString( "Squad.VerifyIfAvailable" )
util.AddNetworkString( "Squad.ReplyInvitation" )
util.AddNetworkString( "Squad.FailedJoin" )
util.AddNetworkString( "Squad.CanInvite" )
util.AddNetworkString( "Squad.CanView" )
util.AddNetworkString( "Squad.SendTip" )
util.AddNetworkString( "Squad.ForceRemove" )

resource.AddWorkshop("1123483997")

function SQUAD:SyncGroups( ply , delta , tags )

    if (delta ~= nil or delta ~= "") then
        self:SyncForSquad(delta, ply)
        return
    end

    net.Start( "Squad.SyncGroups" )
    net.WriteString( delta or "" )

    if ( not tags ) then
        net.WriteTable( delta and self.Groups[ delta ] or self.Groups )
    else
        local tbl = { }

        for k , v in pairs( delta and self.Groups[ delta ] or self.Groups ) do
            local nT = { }
            nT.Name = v.Name
            nT.Creator = v.Creator
            tbl[ k ] = nT
        end

        net.WriteTable( tbl )
    end

    if ( not ply ) then
        net.Broadcast( )
    else
        net.Send( ply )
    end

end

function SQUAD:SyncForSquad( tag, ply )
    if (tag == nil) then return end
    net.Start( "Squad.QuickSyncGroups" )
    net.WriteString( tag )
    net.WriteString( self.Groups[tag].Name )
    net.WriteEntity(self.Groups[tag].Creator)
    net.WriteInt( #self.Groups[tag].Members, 8)
    for i = 1,#self.Groups[tag].Members do
        net.WriteEntity( self.Groups[tag].Members[i] )
    end
    if (IsValid(ply)) then
        net.Send(ply)
    else
        net.Broadcast( )
    end
end

function SQUAD:CreateGroup( tag , name , creator, force )

    name = string.sub( name , 1 , SQUAD.Config.NameMaxSize )
    tag = string.sub( tag , 1 , SQUAD.Config.TagMaxSize )

    local b = self:_sqlAddSquad(tag,name,creator)
    if (force) then b = true end

    if(!b) then
        net.Start( "Squad.VerifyIfAvailable" )
        net.WriteInt( 2 , 4 )
        net.Send( creator )
        return
    end

    if ( self.Groups[ tag ] ) then
        net.Start( "Squad.VerifyIfAvailable" )
        net.WriteInt( 2 , 4 )
        net.Send( creator )
        MsgN( "Squad already exists" )

        return
    end

    if ( creator._squad ~= "" and creator._squad ~= nil) then
        net.Start( "Squad.VerifyIfAvailable" )
        net.WriteInt( 3 , 4 )
        net.Send( creator )
        MsgN( "How did you get here" )

        return
    end

    local tbl = { }
    tbl.Name = name
    tbl.Creator = creator
    tbl.Members = { creator }
    self.Groups[ tag ] = tbl
    self:SyncGroups( nil , tag )
    creator._squad = tag
    creator._squadLeader = true

    net.Start( "Squad.AssignGroup" )
    net.WriteString( tag )
    net.WriteBool( true )
    net.Send( creator )
    net.Start( "Squad.VerifyIfAvailable" )
    net.WriteInt( 1 , 4 )
    net.Send( creator )


end

function SQUAD:AskJoin( tag , ply, rejoin )
    if ( not self.Groups[ tag ] ) then return end

    if ( #self.Groups[ tag ].Members < self.Config.MaxMembers ) then
        table.insert( self.Groups[ tag ].Members , ply )
        ply._squadLeader = false
        ply._squad = tag
        net.Start( "Squad.AssignGroup" )
        net.WriteString( tag )
        net.WriteBool( false )
        net.Send( ply )
        self:SyncForSquad( tag )

        ply:_saveSquad(tag, rejoin)
    else
        net.Start( "Squad.FailedJoin" )
        net.WriteInt( 1 , 8 )
        net.Send( ply )
    end
end

function SQUAD.PlyMeta:RemoveFromSquad(disc)
    local tag = self:GetSquadName( )
    if ( not SQUAD.Groups[ tag ] ) then return end
    table.RemoveByValue( SQUAD.Groups[ tag ].Members , self )
    self._squad = nil
    self._squadLeader = false
    net.Start( "Squad.ForceRemove" )
    net.WriteEntity( self )
    net.Broadcast( )

    if ( #SQUAD.Groups[ tag ].Members == 0 ) then
        SQUAD.Groups[ tag ] = nil
        net.Start( "Squad.PurgeGroup" )
        net.WriteString( tag )
        net.Broadcast( )
    else
        if ( SQUAD.Groups[ tag ].Creator == self ) then
            local newLeader, _ = table.Random( SQUAD.Groups[ tag ].Members )
            if (IsValid(newLeader)) then
                newLeader._squadLeader = true
                SQUAD.Groups[ tag ].Creator = newLeader
                net.Start( "Squad.AssignGroup" )
                net.WriteString( tag )
                net.WriteBool( true )
                net.Send( newLeader )
            end
        end

        SQUAD:SyncForSquad( tag )
    end

    self:_saveSquad(tag, disc)
end

net.Receive( "Squad.Verify" , function( _ , ply )
    local str = net.ReadString( )

    if ( ply:GetSquadName( ) ~= "" and ply:GetSquadName( ) ~= str ) then
        SQUAD:SyncForSquad( ply:GetSquadName( ), ply )
    end

    net.Start("Squad.Verify")
    net.Send(ply)

end )

net.Receive( "Squad.CreateSquad" , function( _ , ply )
    if ( ply:GetSquadName( ) == "" ) then
        SQUAD:CreateGroup( net.ReadString( ) , net.ReadString( ) , ply )
    end
end )

net.Receive( "Squad.SendMessage" , function( _ , ply )
    if ( ( ply._squadMsg or 0 ) < CurTime( ) ) then
        ply._squadMsg = CurTime( ) + 5
        local sms = net.ReadString( )
        local ent = net.ReadEntity( )
        if (ply:SameSquad(ent)) then
            net.Start( "Squad.SendMessage" )
            net.WriteString( sms )
            net.WriteEntity( ply )
            net.Send( ent )
        end
    end
end )

net.Receive( "Squad.ExitSquad" , function( _ , ply )
    local ent = net.ReadEntity( )
    if ( ply:GetSquadName( ) == "" ) then return end

    if ( ply == ent or ply:GetSquad( ).Creator == ply ) then
        for k , v in pairs( ply:GetSquad( ).Members ) do
            if ( v ~= ent ) then
                v:SendTip( ent:Nick( ) .. " " .. SQUAD.Language.LeavedSquad , NOTIFY_ERROR )
            end
        end

        ent:RemoveFromSquad( )
    end
end )

net.Receive( "Squad.SendMoney" , function( _ , ply )
    if ( not SQUAD.Config.CanShareMoney or not ply:Alive()) then return end
    local am = net.ReadFloat( )
    local ent = net.ReadEntity( )

    if ( ply:canAfford( am ) and ply ~= ent and ply:SameSquad(ent)) then
        ent:addMoney( am )
        ply:addMoney( -am )
        ent:SendTip( ply:Nick( ) .. " " .. SQUAD.Language.Sent .. " $" .. tostring( am ) )
    end
end )

net.Receive( "Squad.GiveWeapon" , function( _ , ply )
    if ( not SQUAD.Config.CanShareWeapons or not ply:Alive()) then return end
    local ent = net.ReadEntity( )
    local str = net.ReadString( )
    if ( GAMEMODE.Config.DisallowDrop[ str ] ) then return end

    if ( ply:HasWeapon( str ) and ply:SameSquad(ent)) then
        local amm = ply:GetAmmoCount( ply:GetWeapon( str ):GetPrimaryAmmoType( ) )
        local clip = ply:GetWeapon( str ):Clip1( )

        if ( ent:HasWeapon( str ) ) then
            ent:GiveAmmo( amm + clip , ply:GetWeapon( str ):GetPrimaryAmmoType( ) , false )
        else
            ent:Give( str , false )
            ent:GiveAmmo( amm , ply:GetWeapon( str ):GetPrimaryAmmoType( ) , false )
            ent:GetWeapon( str ):SetClip1( clip )
        end

        ply:SetAmmo( ply:GetWeapon( str ):GetPrimaryAmmoType( ) , 0 )
        ply:StripWeapon( str )
        ent:SendTip( ply:Nick( ) .. " " .. SQUAD.Language.Sent .. " " .. str )
    end
end )

net.Receive( "Squad.SendInvitation" , function( _ , ply )
    local ent = net.ReadEntity( )

    if ( ent:IsBot( ) ) then
        SQUAD:AskJoin( ply:GetSquadName( ) , ent )
    end

    if ( ply:GetSquadName( ) ~= "" and ent:GetSquadName( ) == "" and ent:GetNWBool( "Squad.CanHire" , true ) and #ply:GetSquadMembers( ) < SQUAD.Config.MaxMembers and (ply.SquadInvitationCooldown or 0) < CurTime()) then
        ply.SquadInvitationCooldown = CurTime() + 2
        net.Start( "Squad.SendInvitation" )
        net.WriteEntity( ply )
        net.WriteString( ply:GetSquad( ).Name )
        net.Send( ent )
        ent.SquadInvitation = ply
    end
end )

net.Receive( "Squad.ReplyInvitation" , function( _ , ply )
    local ent = net.ReadEntity( )
    local reply = net.ReadBool( )

    if ( ply.SquadInvitation == ent and reply and ent:GetSquadName( ) ~= "" ) then
        SQUAD:AskJoin( ent:GetSquadName( ) , ply )
    end

    ent.SquadInvitation = nil
end )

net.Receive( "Squad.CanInvite" , function( _ , ply )
    local b = net.ReadBool( )
    ply:SetNWBool( "Squad.CanHire" , b )
end )

net.Receive( "Squad.CanView" , function( _ , ply )
    local b = net.ReadBool( )
    ply:SetNWBool( "Squad.CanShareView" , b )
end )

hook.Add( "PlayerDisconnected" , "Squad.RemoveMember" , function( _ply )
    if ( _ply:GetSquadName( ) ~= "" ) then
        _ply:RemoveFromSquad(true)
    end
end )

hook.Add( "PlayerInitialSpawn" , "Squad.SyncInitalGroups" , function( _ply )
    timer.Simple( 1 , function( )
        SQUAD:SyncGroups( _ply , nil , true )
    end )
end )

hook.Add( "EntityTakeDamage" , "Squad.SendPlyDamage" , function( ent , _ )
    if ( ent:IsPlayer( ) and ent:GetSquadName( ) ~= "" ) then
        net.Start( "Squad.SendPlyDamage" )
        net.WriteEntity( ent )
        net.Send( ent:GetSquadMembers( ) )
    end
end )

hook.Add( "PlayerButtonUp" , "Squad.VoiceButton.Up" , function( ply , key )
    if ( ply:GetSquadName( ) ~= "" and key == SQUAD.Config.VoiceKey ) then
        if SERVER and ply.IsSquadVoice then
            ply:SetNWBool( "Squad.Voice" , false )
        end

        ply.IsSquadVoice = false
    end
end )

hook.Add( "PlayerButtonDown" , "Squad.VoiceButton.Down" , function( ply , key )
    if ( ply:GetSquadName( ) ~= "" and key == SQUAD.Config.VoiceKey ) then
        if SERVER and not ply.IsSquadVoice then
            ply:SetNWBool( "Squad.Voice" , true )
        end

        ply.IsSquadVoice = true
    end
end )

hook.Add( "PlayerCanHearPlayersVoice" , "Squad.VoiceSystem" , function( listener , talker )
    if ( talker.IsSquadVoice and listener:GetSquadName( ) ~= "" ) then return listener:GetSquadName( ) == talker:GetSquadName( ) end
end )

hook.Add( "PlayerSay" , "Squad.ChatSystem" , function( ply , text )
    if ( ply:GetSquadName( ) ~= "" and ( text[ 1 ] == "!" or text[ 1 ] == "/" ) and string.StartWith( string.sub( text , 2 ) , SQUAD.Config.ChatPrefix ) ) then
        local msg = string.sub( text , #SQUAD.Config.ChatPrefix + 2 , #text )
        net.Start( "Squad.SendMessage" )
        net.WriteString( msg )
        net.WriteEntity( ply )
        net.Send( ply:GetSquadMembers( ) )

        return ""
    end
end )

hook.Add( "EntityTakeDamage" , "Squad.DamageControl" , function( ply , dmg )
    if ( SQUAD.Config.DamageBetweenTeam ) then return end

    if ( dmg:GetAttacker( ) ~= ply and ply:IsPlayer( ) and dmg:GetAttacker( ):IsPlayer( ) and ply:GetSquadName( ) ~= "" and ply:GetSquadName( ) == dmg:GetAttacker( ):GetSquadName( ) ) then
        dmg:SetDamage( 0 )

        return true
    end
end )
