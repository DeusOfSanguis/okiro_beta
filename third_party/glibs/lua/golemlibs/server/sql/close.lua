function gCloseMySQL()
	if GOLEM.SQL.usingSQLite then
		sql.Query("COMMIT")
		return
	end

	if GOLEM.SQL.db then
		GOLEM.SQL.db:disconnect()
	end
end