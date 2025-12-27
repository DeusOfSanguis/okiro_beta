function gInitializeMySQL()
	if not CONFIG_SQL then
		GOLEM.SQL.usingSQLite = true
		sql.Query("BEGIN TRANSACTION")
		return true
	end

	GOLEM.SQL.db = mysqloo.connect(
		CONFIG_SQL.MySQL.host,
		CONFIG_SQL.MySQL.username,
		CONFIG_SQL.MySQL.password,
		CONFIG_SQL.MySQL.database,
		CONFIG_SQL.MySQL.port,
		CONFIG_SQL.MySQL.socket
	)

	GOLEM.SQL.db.onConnected = function()
		GOLEM.SQL.usingSQLite = false
	end

	GOLEM.SQL.db.onConnectionFailed = function()
		GOLEM.SQL.usingSQLite = true
		sql.Query("BEGIN TRANSACTION")
	end

	GOLEM.SQL.db:connect()

	timer.Simple(0.1, function()
		if not GOLEM.SQL.db:status() == mysqloo.DATABASE_CONNECTED then
			GOLEM.SQL.usingSQLite = true
			sql.Query("BEGIN TRANSACTION")
		end
	end)

	return true
end