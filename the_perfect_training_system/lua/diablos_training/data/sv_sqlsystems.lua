/*---------------------------------------------------------------------------
    Default Query function
    If everything is alright, it is replaced below by the custom one for "mysql" or for "sqlite"
---------------------------------------------------------------------------*/
Diablos.TS.Query = function(str)
    Diablos.TS:ConsoleMsg(1, "Trying to success a query but the query is not valid\n")
end


if Diablos.TS.SQLType == "mysql" then
    require( "mysqloo" )

    local sqldata = Diablos.TS.MySQLData

    local db = mysqloo.connect(sqldata.host, sqldata.username, sqldata.password, sqldata.database, sqldata.port)

    function db:onConnected()

        Diablos.TS.Query = function(str, success, failure)
            local q = db:query(str)
            q.onSuccess = function(qr, data)
                if success then
                    success(data)
                end
            end

            q.onError = function(tr, err)
                if failure then
                    failure(tr, err)
                end
            end

            q:start()
        end

        Diablos.TS:ConsoleMsg(0, "Connection to the MySQL database successfully worked")
    end

    function db:onConnectionFailed(err)
        Diablos.TS:ConsoleMsg(1, "Connection to the MySQL database didn't work")
        Diablos.TS:ConsoleMsg(1, "Error: " .. err)
    end

    db:connect()

elseif Diablos.TS.SQLType == "sqlite" then
    Diablos.TS.Query = function(str, success, failure)
        local result = sql.Query(str)

        -- error
        if result == false then
            if failure then
                failure(sql.LastError(), str)
            end
        else
            if success then
                result = result or {}
                success(result)
            end
        end
    end

    Diablos.TS:ConsoleMsg(0, "Connection to the SQLite database successfully worked")

else
    Diablos.TS:ConsoleMsg(1, "The value inserted for SQLType is wrong: should be mysql or sqlite")
end