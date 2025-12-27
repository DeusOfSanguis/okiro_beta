/*---------------------------------------------------------------------------
	Construct the training table
	This function manages the way the table is being created
	This also takes in consideration if playerData is nil 
---------------------------------------------------------------------------*/

function Diablos.TS:ConstructTrainingTable(ply, playerData)

	if not playerData then
		playerData = {}
		playerData.strengthXP = 0
		playerData.strengthDate = 0

		playerData.staminaXP = 0
		playerData.staminaDate = 0

		playerData.runningspeedXP = 0
		playerData.runningspeedDate = 0

		playerData.attackspeedXP = 0
		playerData.attackspeedDate = 0
	end

	if not playerData.subValidDate and Diablos.TS.SubSystem then
		playerData.subValidDate = 0
	end
	if not Diablos.TS.SubSystem then -- If there is no sub, then the subValidDate will be at its maximum
		playerData.subValidDate = 2147483647 -- 2^31-1
	end

	ply.Training = {
		Trainings = {
			strength = {
				xp = tonumber(playerData.strengthXP),
				date = tonumber(playerData.strengthDate),
			},
			stamina = {
				xp = tonumber(playerData.staminaXP),
				date = tonumber(playerData.staminaDate),
			},
			runningspeed = {
				xp = tonumber(playerData.runningspeedXP),
				date = tonumber(playerData.runningspeedDate),
			},
			attackspeed = {
				xp = tonumber(playerData.attackspeedXP),
				date = tonumber(playerData.attackspeedDate),
			},
		},
		Badge = {
			subdate = tonumber(playerData.subValidDate),
		},
	}

	ply:TSTrainingDataLaunched()

end


/*---------------------------------------------------------------------------
	Transforms a saved table to a SQL table for the syntax
---------------------------------------------------------------------------*/

function Diablos.TS:TransformSavedTableToSQLTable(savedTable)
	if not savedTable then return nil end

	local sqlTable = {}
	sqlTable.subValidDate = savedTable.Badge.subdate

	sqlTable.strengthXP = savedTable.Trainings.strength.xp
	sqlTable.strengthDate = savedTable.Trainings.strength.date

	sqlTable.staminaXP = savedTable.Trainings.stamina.xp
	sqlTable.staminaDate = savedTable.Trainings.stamina.date

	sqlTable.runningspeedXP = savedTable.Trainings.runningspeed.xp
	sqlTable.runningspeedDate = savedTable.Trainings.runningspeed.date

	sqlTable.attackspeedXP = savedTable.Trainings.attackspeed.xp
	sqlTable.attackspeedDate = savedTable.Trainings.attackspeed.date

	return sqlTable
end

/*---------------------------------------------------------------------------
	Get the format of the osDate (shown in some interfaces)
---------------------------------------------------------------------------*/

function Diablos.TS:GetOSFormat()
	return "%d/%m - %H:%M"
end

/*---------------------------------------------------------------------------
	Get if the entity class is a training entity or not
	Used to verify you're editing a training entity when using the toolgun or dropping object with the physgun
---------------------------------------------------------------------------*/

local trainingEntities = {
	["diablos_weigh_balance"] = true,
	["diablos_card_reader"] = true,
	["diablos_turnstile"] = true,
	["diablos_treadmill"] = true,
	["diablos_dumbbell"] = true,
	["diablos_punching_base"] = true,
	["diablos_punching_ball"] = true,
}

function Diablos.TS:IsTrainingEntity(class)
	return trainingEntities[class]
end


/*---------------------------------------------------------------------------
	Get the trainings enabled on the server
---------------------------------------------------------------------------*/

function Diablos.TS:GetTrainings()
	local trainings = {}

	if Diablos.TS:IsTrainingEnabled("strength") then
		table.insert(trainings, "strength")
	end
	if Diablos.TS:IsTrainingEnabled("attackspeed") then
		table.insert(trainings, "attackspeed")
	end
	if Diablos.TS:IsTrainingEnabled("stamina") then
		table.insert(trainings, "stamina")
	end
	if Diablos.TS:IsTrainingEnabled("runningspeed") then
		table.insert(trainings, "runningspeed")
	end

	return trainings
end

/*---------------------------------------------------------------------------
	Get the trainings orders on the server
---------------------------------------------------------------------------*/

function Diablos.TS:GetTrainingOrder(typeTraining)
	local result = 0

	local trainings = Diablos.TS:GetTrainings()
	for i = 1, #trainings do
		if trainings[i] == typeTraining then
			result = i
		end
	end

	return result
end

/*---------------------------------------------------------------------------
	Get if a specific training is enabled
---------------------------------------------------------------------------*/
function Diablos.TS:IsTrainingEnabled(trainingName)
	local trainingEnabled = false
	if trainingName == "strength" then
		trainingEnabled = Diablos.TS.StrengthEnabled
	elseif trainingName == "attackspeed" then
		trainingEnabled = Diablos.TS.AttackSpeedEnabled
	elseif trainingName == "stamina" then
		trainingEnabled = Diablos.TS.StaminaEnabled
	elseif trainingName == "runningspeed" then
		trainingEnabled = Diablos.TS.RunningSpeedEnabled
	end
	return trainingEnabled
end

/*---------------------------------------------------------------------------
	Get the training level table, which returns the table you want to use depending on the typeTraining variable
---------------------------------------------------------------------------*/

function Diablos.TS:GetTrainingLevelTable(typeTraining)
	typeTraining = string.lower(typeTraining)

	if typeTraining == "stamina" then
		return Diablos.TS.StaminaLevels
	elseif typeTraining == "runningspeed" then
		return Diablos.TS.RunningSpeedLevels
	elseif typeTraining == "strength" then
		return Diablos.TS.StrengthLevels
	elseif typeTraining == "attackspeed" then
		return Diablos.TS.AttackSpeedLevels
	end
end

/*---------------------------------------------------------------------------
	Get the training bodygroup table, which returns the table you want to use depending on the typeTraining variable
---------------------------------------------------------------------------*/

function Diablos.TS:GetTrainingBodygroupTable(typeTraining)
	typeTraining = string.lower(typeTraining)

	if typeTraining == "stamina" then
		return Diablos.TS.StaminaEquivalence
	elseif typeTraining == "runningspeed" then
		return Diablos.TS.RunningSpeedEquivalence
	elseif typeTraining == "strength" then
		return Diablos.TS.DumbbellSizeEquivalence
	elseif typeTraining == "attackspeed" then
		return Diablos.TS.PunchingBallSizeEquivalence
	end
end

/*---------------------------------------------------------------------------
	Get the training level with arguments:
		- typeTraining: a specific type of training 
		- data: a player OR a integer meaning the XP we want to check the level for
---------------------------------------------------------------------------*/

function Diablos.TS:GetTrainingLevel(typeTraining, data)

	local levelTab = Diablos.TS:GetTrainingLevelTable(typeTraining)

	local xp = Diablos.TS:GetXPFromData(typeTraining, data)

	local level = 1
	if levelTab then
		for k, v in ipairs(levelTab) do
			if v.xp <= xp then
				level = k
			else
				break
			end
		end
	end

	return level
end

/*---------------------------------------------------------------------------
	Get the training XP from data with:
		- typeTraining: a specific type of training
		- data: a player, in which case we'll get its xp with GetTrainingInfo
		OR a integer, in which case we won't do anything as this is already the XP
---------------------------------------------------------------------------*/

function Diablos.TS:GetXPFromData(typeTraining, data)
	local xp = 0
	if IsEntity(data) then
		local trainingInfo = data:TSGetTrainingInfo(typeTraining)
		-- Calling GetXPFromData with a disabled typeTraining would have a nil trainingInfo table
		if trainingInfo then
			xp = trainingInfo.xp
		end
	elseif isnumber(data) then
		xp = data
	end
	return xp
end

/*---------------------------------------------------------------------------
	Get the training percentage with arguments:
		- typeTraining: a specific type of training 
		- data: a player OR a integer meaning the XP we want to check the level for

	This returns a percentage (from 0 to 100)
---------------------------------------------------------------------------*/

function Diablos.TS:GetTrainingPercentage(typeTraining, data)
	local xp = Diablos.TS:GetXPFromData(typeTraining, data)

	local levelTab = Diablos.TS:GetTrainingLevelTable(typeTraining)
	-- get the level with the GetTrainingLevel function with XP
	local level = Diablos.TS:GetTrainingLevel(typeTraining, xp)

	local percentage = 0
	if levelTab then

		local xpCurrentLevel = levelTab[level].xp

		local isLastLevel = level == #levelTab
		if isLastLevel then
			percentage = 100 -- last level
		else
			local xpNextLevel = levelTab[level + 1].xp

			local xpDifference = math.max(xp - xpCurrentLevel, 0)
			percentage = xpDifference / (xpNextLevel - xpCurrentLevel) * 100
		end
	end

	return percentage
end

/*---------------------------------------------------------------------------
	Get an integer from the type of training
	Used to send a UInt for network between client and server
---------------------------------------------------------------------------*/

function Diablos.TS:GetIntegerFromTraining(typeTraining)
	local toReturn = -1
	if typeTraining == "strength" then
		toReturn = 0
	elseif typeTraining == "attackspeed" then
		toReturn = 1
	elseif typeTraining == "stamina" then
		toReturn = 2
	elseif typeTraining == "runningspeed" then
		toReturn = 3
	end
	return toReturn
end

/*---------------------------------------------------------------------------
	Get the type of training from an integer
	Used to get the training from a UInt received with network between client and server
---------------------------------------------------------------------------*/

function Diablos.TS:GetTrainingFromInteger(integer)

	local toReturn = ""
	if integer == 0 then
		toReturn = "strength"
	elseif integer == 1 then
		toReturn = "attackspeed"
	elseif integer == 2 then
		toReturn = "stamina"
	elseif integer == 3 then
		toReturn = "runningspeed"
	end
	return toReturn
end

/*---------------------------------------------------------------------------
	Get an integer from the ENTITY
	Used by the toolgun to act differently depending on the entity you're editing
---------------------------------------------------------------------------*/

function Diablos.TS:GetIntegerFromEntity(entity)
	local toReturn = -1
	if entity == "diablos_weigh_balance" then
		toReturn = 1
	elseif entity == "diablos_card_reader" then
		toReturn = 2
	elseif entity == "diablos_turnstile" then
		toReturn = 3
	elseif entity == "diablos_treadmill" then
		toReturn = 4
	elseif entity == "diablos_dumbbell" then
		toReturn = 5
	elseif entity == "diablos_punching_base" then
		toReturn = 6
	end
	return toReturn
end

/*---------------------------------------------------------------------------
	Get an entity from an INTEGER
	Used to get the entity from a UInt received with network when an admin is editing an entity
---------------------------------------------------------------------------*/

function Diablos.TS:GetEntityFromInteger(integer)
	local toReturn = ""
	if integer == 1 then
		toReturn = "diablos_weigh_balance"
	elseif integer == 2 then
		toReturn = "diablos_card_reader"
	elseif integer == 3 then
		toReturn = "diablos_turnstile"
	elseif integer == 4 then
		toReturn = "diablos_treadmill"
	elseif integer == 5 then
		toReturn = "diablos_dumbbell"
	elseif integer == 6 then
		toReturn = "diablos_punching_base"
	end
	return toReturn
end


/*---------------------------------------------------------------------------
	Get a random number representing a key which:
		* can't be the key entered in parameter 
		* neither a blocklisted key in the Diablos.TS.DumbbellKeyBlocklist table
	Keys are going from 1 to 36, 1 being the KEY_0 and 36 being KEY_Z
---------------------------------------------------------------------------*/

function Diablos.TS:GetRandomKey(blocklistedNumber)
	local numb = math.ceil(math.Rand(0, 36))
	while (table.HasValue(Diablos.TS.DumbbellKeyBlocklist, numb) || numb == blocklistedNumber) do
		numb = math.ceil(math.Rand(0, 36))
	end
	return numb
end

/*---------------------------------------------------------------------------
	Get the mile conversion from a unit number
---------------------------------------------------------------------------*/

function Diablos.TS:GetMPHFromUnit(unit)
	return unit * 15 / 352 -- written at https://developer.valvesoftware.com/wiki/Dimensions	
end

/*---------------------------------------------------------------------------
	Get the kilometer conversion from a unit number
---------------------------------------------------------------------------*/

function Diablos.TS:GetKMHFromUnit(unit)
	return Diablos.TS:GetMPHFromUnit(unit) * 1.60934
end

/*---------------------------------------------------------------------------
	Get the speed conversion depending on the server owner's choice
---------------------------------------------------------------------------*/

function Diablos.TS:GetSpeedFromUnit(unit)
	local result = 0
	if Diablos.TS.IsMph then
		result = Diablos.TS:GetMPHFromUnit(unit)
	else
		result = Diablos.TS:GetKMHFromUnit(unit)
	end
	return result
end

/*---------------------------------------------------------------------------
	Get the speed text depending on the server owner's choice
---------------------------------------------------------------------------*/
function Diablos.TS:GetSpeedText()
	local result = ""
	if Diablos.TS.IsMph then
		result = "mph"
	else
		result = "kmh"
	end
	return result
end

/*---------------------------------------------------------------------------
	We don't have a kg to lbs conversion function, as I directly wrote the values in the equivalence variables above
	Otherwise, it would have been
		* local lbsToKg = 0.453592 * val
		* local kgToLbs = 2.20462 * val
---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
	Get the weight text depending on the server owner's choice
---------------------------------------------------------------------------*/

function Diablos.TS:GetWeightText()
	local result = ""
	if Diablos.TS.IsLbs then
		result = Diablos.TS:GetLanguageString("lbs")
	else
		result = Diablos.TS:GetLanguageString("kg")
	end
	return result
end


/*---------------------------------------------------------------------------
	Returns if ply is an admin for the training addon
---------------------------------------------------------------------------*/

function Diablos.TS:IsAdmin(ply)
	return Diablos.TS.AdminGroups[ply:GetUserGroup()]
end


/*---------------------------------------------------------------------------
	Get the string depending on the language
---------------------------------------------------------------------------*/

function Diablos.TS:GetLanguageString(key)
	-- key = string.lower(key)
	local str = Diablos.TS.Strings[key]
	if not str then
		str = "UNDEFINED STRING - MAKE SURE YOU HAVE THE LATEST ADDON VERSION OR CONTACT THE AUTHOR"
	end
	return str
end

/*---------------------------------------------------------------------------
	Get a proper time format
	Work the same way than string.NiceTime but with more features and language integration
	Functions inspiration taken at https://stackoverflow.com/questions/42472876/convert-int-in-to-nice-time-format
---------------------------------------------------------------------------*/

function Diablos.TS:TimeFormat(text, name, delta, time)
	if (delta >= time) then
		if #text > 0 then
			text = text .. " " .. Diablos.TS:GetLanguageString("andStr") .. " "
		end

		local timeCalc = math.floor(delta / time)

		if delta >= time * 2 then
			name = name .. "s"
		end
		Diablos.TS:GetLanguageString(name)

		text = text .. timeCalc .. " " .. Diablos.TS:GetLanguageString(name)
		delta = delta % time;
	end
	return text, delta
end

function Diablos.TS:NiceTimeFormat(seconds, hideSecond, hideMinute, hideHour, hideDay, hideMonth, hideYear)
	local second = 1
	local minute = 60 * second
	local hour = 60 * minute
	local day = 24 * hour
	local month = 30 * day
	local year = 365 * day

	local text = ""
	local delta = seconds

	if not hideYear then
		text, delta = Diablos.TS:TimeFormat(text, "year", delta, year)
	end
	if not hideMonth then
		text, delta = Diablos.TS:TimeFormat(text, "month", delta, month)
	end
	if not hideDay then
		text, delta = Diablos.TS:TimeFormat(text, "day", delta, day)
	end
	if not hideHour then
		text, delta = Diablos.TS:TimeFormat(text, "hour", delta, hour)
	end
	if not hideMinute then
		text, delta = Diablos.TS:TimeFormat(text, "minute", delta, minute)
	end
	if not hideSecond then
		text, delta = Diablos.TS:TimeFormat(text, "second", delta, second)
	end

	return text
end

/*---------------------------------------------------------------------------
	Get the currency symbol depending on your gamemode
----------------------------------------------------------------------------*/

function Diablos.TS:GetCurrencySymbol()
	local result = ""
	if DarkRP then
		result = GAMEMODE.Config.currency
	elseif nut then
		result = nut.currency.symbol
	elseif ix then
		result = ix.currency.symbol
	elseif PS then
		result = PS.Config.PointsName
	elseif PointShop2 then
		if Diablos.TS.PointshopPremium then
			result = " Premium Points"
		else
			result = " Points"
		end
	end
	return result
end

/*---------------------------------------------------------------------------
	Get the currency format type depending on your gamemode
----------------------------------------------------------------------------*/

function Diablos.TS:GetCurrencyFormatType(money)
	local result = money
	if DarkRP then
		result = DarkRP.formatMoney(money)
	elseif nut then
		result = nut.currency.get(money)
	elseif ix then
		result = ix.currency.Get(money)
	elseif PS then
		result = money .. PS.Config.PointsName
	elseif PointShop2 then
		if Diablos.TS.PointshopPremium then
			result = money .. " Premium Points"
		else
			result = money .. " Points"
		end
	else -- No system at all
		if result == 0 then
			result = ""
		end
	end
	return result
end

/*---------------------------------------------------------------------------
	Get the way of adding money depending on your gamemode
----------------------------------------------------------------------------*/

function Diablos.TS:AddMoney(ply, money)
	if DarkRP then
		ply:addMoney(money)
	elseif nut then
		local char = ply:getChar()
		if IsValid(char) then
			char:giveMoney(money)
		end
	elseif ix then
		local char = ply:GetCharacter()
		if IsValid(char) then
			local curMoney = char:GetMoney()
			char:SetMoney(curMoney + money)
		end
	elseif PS then -- Pointshop1 (https://pointshop.burt0n.net/player-meta-functions/points)
		ply:PS_GivePoints(money)
	elseif Pointshop2 then -- Pointshop2 (http://pointshop2.kamshak.com/en/latest/developer/points.html)
		if Diablos.TS.PointshopPremium then
			ply:PS2_AddPremiumPoints(money)
		else
			ply:PS2_AddStandardPoints(money)
		end
	end
end

/*---------------------------------------------------------------------------
	Get the way of removing money depending on your gamemode
----------------------------------------------------------------------------*/

function Diablos.TS:RemoveMoney(ply, money)
	if DarkRP then
		ply:addMoney(-money)
	elseif nut then
		local char = ply:getChar()
		if IsValid(char) then
			char:takeMoney(money)
		end
	elseif ix then
		local char = ply:GetCharacter()
		if IsValid(char) then
			local curMoney = char:GetMoney()
			char:SetMoney(curMoney - money)
		end
	elseif PS then -- Pointshop1 (https://pointshop.burt0n.net/player-meta-functions/points)
		ply:PS_TakePoints(money)
	elseif Pointshop2 then -- Pointshop2 (http://pointshop2.kamshak.com/en/latest/developer/points.html)
		if Diablos.TS.PointshopPremium then
			ply:PS2_AddPremiumPoints(money)
		else
			ply:PS2_AddStandardPoints(money)
		end
	end
end

/*---------------------------------------------------------------------------
	Get the way of getting if the player has enough money depending on your gamemode
----------------------------------------------------------------------------*/

function Diablos.TS:HasEnoughMoney(ply, money)
	local result = false
	if DarkRP then
		result = ply:canAfford(money)
	elseif nut then
		local char = ply:getChar()
		if IsValid(char) then
			result = char:getMoney() >= money
		end
	elseif ix then
		local char = ply:GetCharacter()
		if IsValid(char) then
			result = char:GetMoney() >= money
		end
	elseif PS then
		result = ply:PS_HasPoints(money)
	elseif Pointshop2 then
		if ply.PS2_Wallet then
			if Diablos.TS.PointshopPremium then
				result = ply.PS2_Wallet.premiumPoints >= money
			else
				result = ply.PS2_Wallet.points >= money
			end
		end
	else -- No system at all
		result = true
	end
	return result
end


/*---------------------------------------------------------------------------
	Get if you're using the Kobralost Character Addon at https://www.gmodstore.com/market/view/character-creator-the-best-character-creation-script
----------------------------------------------------------------------------*/

function Diablos.TS:IsUsingCharacterSystem()
	return istable(CharacterCreator)
end