Diablos.TS.Data.TableName = "training_table"

/*---------------------------------------------------------------------------
	Create the table
---------------------------------------------------------------------------*/

function Diablos.TS.Data:CreateTable()

	local createTableStr = Diablos.TS.Data.GetQueryText[Diablos.TS.SQLType]["createTable"]
	local createTableQuery = string.format(createTableStr, Diablos.TS.Data.TableName)

	Diablos.TS.Query(createTableQuery)
end


/*---------------------------------------------------------------------------
	Delete the table
---------------------------------------------------------------------------*/

function Diablos.TS.Data:DeleteTable()
	local dropStr = "DROP TABLE %s"
	local dropQuery = string.format(dropStr, Diablos.TS.Data.TableName)
	Diablos.TS.Query(dropQuery)
end

/*---------------------------------------------------------------------------
	Check if the table exists
---------------------------------------------------------------------------*/

function Diablos.TS.Data:TableExists(func)
	local existStr = Diablos.TS.Data.GetQueryText[Diablos.TS.SQLType]["existsTable"]
	local existQuery = string.format(existStr, Diablos.TS.Data.TableName)
	Diablos.TS.Query(existQuery, function(result)
		-- For SQLite, we should ensure there is atleast one occurence
		if result and #result >= 1 then
			func(true)
		else
			func(false)
		end
	end, function(fail)
		func(false)
	end)
end

/*---------------------------------------------------------------------------
	Save training information -> from the table creation to the insertion/update
---------------------------------------------------------------------------*/

Diablos.TS.Data.GetQueryText = {
	["mysql"] = {
		["createTable"] = "CREATE TABLE %s(uid varchar(17) primary key not null, strengthXP int, strengthDate int, staminaXP int, staminaDate int, runningspeedXP int, runningspeedDate int, attackspeedXP int, attackspeedDate int, subValidDate int)",
		["updateIfInsert"] =  "ON DUPLICATE KEY UPDATE subValidDate = %u, strengthXP = %u, strengthDate = %u, staminaXP = %u, staminaDate = %u, runningspeedXP = %u, runningspeedDate = %u, attackspeedXP = %u, attackspeedDate = %u",
		["existsTable"] = "SHOW TABLES LIKE '%s';"
	},
	["sqlite"] = {
		["createTable"] = "CREATE TABLE %s(uid text primary key not null, strengthXP int, strengthDate int, staminaXP int, staminaDate int, runningspeedXP int, runningspeedDate int, attackspeedXP int, attackspeedDate int, subValidDate int)",
		["updateIfInsert"] =  "ON CONFLICT(uid) DO UPDATE SET subValidDate = %u, strengthXP = %u, strengthDate = %u, staminaXP = %u, staminaDate = %u, runningspeedXP = %u, runningspeedDate = %u, attackspeedXP = %u, attackspeedDate = %u",
		["existsTable"] = "SELECT name FROM sqlite_master WHERE type='table' AND name='%s';"
	}
}

/*---------------------------------------------------------------------------
	Save the training data regarding a player
	Works for both SQLite and MySQL thanks to the Diablos.TS.Data.GetQueryText global variable
	This manages INSERT INTO as well as UPDATE if the player is always registered in the database
---------------------------------------------------------------------------*/

function Diablos.TS.Data:SaveTrainingInfo(ply)
	local id = ply:SteamID64()
	local strength = ply:TSGetTrainingInfo("Strength")
	local stamina = ply:TSGetTrainingInfo("Stamina")
	local runningSpeed = ply:TSGetTrainingInfo("RunningSpeed")
	local attackSpeed = ply:TSGetTrainingInfo("AttackSpeed")
	local badge = ply:TSGetTrainingInfo("Badge")

	Diablos.TS.Data:TableExists(function(created)
		if not created then
			Diablos.TS.Data:CreateTable()
		end

		local insertStr = "INSERT INTO %s(uid, subValidDate, strengthXP, strengthDate, staminaXP, staminaDate, runningspeedXP, runningspeedDate, attackspeedXP, attackspeedDate) VALUES (%s, %u, %u, %u, %u, %u, %u, %u, %u, %u) "

		local subDate = badge.subdate
		-- We don't save the maximum number for badge sub date, in case the server owner decides to enable sub system
		if not Diablos.TS.SubSystem then
			subDate = 0
		end

		local insertQuery = string.format(insertStr, Diablos.TS.Data.TableName,
			id, subDate,
			strength.xp, strength.date,
			stamina.xp, stamina.date,
			runningSpeed.xp, runningSpeed.date,
			attackSpeed.xp, attackSpeed.date
		)

		local updateStr = Diablos.TS.Data.GetQueryText[Diablos.TS.SQLType]["updateIfInsert"]

		local updateQuery = string.format(updateStr,
			subDate,
			strength.xp, strength.date,
			stamina.xp, stamina.date,
			runningSpeed.xp, runningSpeed.date,
			attackSpeed.xp, attackSpeed.date
		)

		local entireQuery = insertQuery .. updateQuery

		Diablos.TS.Query(entireQuery)
	end)
end

/*---------------------------------------------------------------------------
	Get training information -> using a select
	This will send the data result in a success function - however, this will send the failure function
---------------------------------------------------------------------------*/

function Diablos.TS.Data:TSGetTrainingInfo(ply, success, failure)

	local id = ply:SteamID64()
	local selectQuery = string.format("SELECT * FROM %s WHERE uid=%s", Diablos.TS.Data.TableName, id)
	Diablos.TS.Query(selectQuery, function(result)
		success(result)
	end, function(fail)
		failure()
	end)
end

/*---------------------------------------------------------------------------
	Get training information of people who have a date expired -> using a select
---------------------------------------------------------------------------*/

function Diablos.TS.Data:GetTrainingExpired(date, success)

	local selectStr = "SELECT * FROM %s WHERE staminaDate <= %u OR runningspeedDate <= %u OR strengthDate <= %u OR attackspeedDate <= %u"
	local selectQuery = string.format(selectStr, Diablos.TS.Data.TableName, date, date, date, date)

	Diablos.TS.Query(selectQuery, function(result)
		success(result)
	end, function(failure)
		-- failure()
	end)
end

/*---------------------------------------------------------------------------
	Update a training information (fieldName takes the newValue value and fieldName"Date" takes the newDate value)
---------------------------------------------------------------------------*/

function Diablos.TS.Data:UpdateField(id, fieldName, newValue, newDate)

	Diablos.TS.Data:TableExists(function(created)
		if not created then return end

		local updateStr = "UPDATE %s SET %s=%u, %s=%u where uid=%s"
		local updateQuery = string.format(updateStr, Diablos.TS.Data.TableName, fieldName .. "XP", newValue, fieldName .. "Date", newDate, id)

		Diablos.TS.Query(updateQuery)
	end)
end