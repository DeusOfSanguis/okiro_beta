


local meta = FindMetaTable("Player")

if ( !sql.TableExists( "SquadDB" ) ) then
	sql.Query( "CREATE TABLE IF NOT EXISTS SquadDB ( id TEXT NOT NULL PRIMARY KEY, name TEXT, players TEXT );" )
end

function meta:_saveSquad(tag, rejoin)

	if (rejoin) then return end

    local tbl = {}
    for k,v in pairs((SQUAD.Groups[ tag ] or {Members = {}}).Members) do
        tbl[k] = v:SteamID64()
    end
	if(#tbl > 0) then
    	local t = sql.Query( "REPLACE INTO SquadDB ( id, name, players ) VALUES ( "..SQLStr(tag)..", "..SQLStr(SQUAD.Groups[tag].Name)..", " ..SQLStr(util.TableToJSON(tbl)).." ) WHERE id="..SQLStr(tag)..";" )
	else
		sql.Query( "DELETE FROM SquadDB WHERE id = "..SQLStr(tag)..";")
	end

	MsgN("Changed squad to ",tag)
	self:SetPData("PlayerSquad",tag)
end

function SQUAD:_sqlAlreadyExists(id)
	local val = sql.QueryValue( "SELECT * FROM SquadDB WHERE id = " .. SQLStr(id) .. " LIMIT 1" )
	return val != nil
end

function SQUAD:_sqlReturnTable(id)
	local val = sql.Query( "SELECT * FROM SquadDB WHERE id = " .. SQLStr(id) .. " LIMIT 1"  )
	return val != nil and val[1] or nil
end


function SQUAD:_sqlAddSquad(id,name,ply)

	if(self:_sqlAlreadyExists(id)) then MsgN("ALREADY EXISTS") return false end;

    if(istable(ply)) then
        for k,v in pairs(ply) do
            ply[k] = v:SteamID64()
        end
    else
        ply = {ply:SteamID64()}
    end
    sql.Query( "INSERT INTO SquadDB ( id, name, players ) VALUES ( " .. SQLStr( id ) .. ", " .. SQLStr( name ) .. ", "..SQLStr(util.TableToJSON(ply)).." )" )

	return true
end

function SQUAD:SetupInitialPlayer(ply)
	if(ply:GetPData("PlayerSquad","") != "") then
		local tag = ply:GetPData("PlayerSquad","")
		if(SQUAD.Groups[tag]) then
			SQUAD:AskJoin( tag , ply, true )
			MsgN("Join?")
		else
			local tbl = SQUAD:_sqlReturnTable(tag)
			if(tbl != nil) then
				MsgN("Create?")
				SQUAD:CreateGroup( tag , tbl.name , ply, true )
			end
		end
	end
end

hook.Add("PlayerInitialSpawn","SquadSetter", function(ply)
	timer.Simple(15, function()
		SQUAD:SetupInitialPlayer(ply)
	end)
end)
