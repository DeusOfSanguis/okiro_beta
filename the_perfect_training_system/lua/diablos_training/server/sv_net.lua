util.AddNetworkString("TPTSA:Notify")
util.AddNetworkString("TPTSA:OpenAdminToolgunPanel")
util.AddNetworkString("TPTSA:OpenAdminClientPanel")
util.AddNetworkString("TPTSA:OpenTrainingPanel")
util.AddNetworkString("TPTSA:CardReaderPurchase")
util.AddNetworkString("TPTSA:CardReaderEdit")
util.AddNetworkString("TPTSA:CardReaderGive")
util.AddNetworkString("TPTSA:OpenTrainingExercicePanel")
util.AddNetworkString("TPTSA:SaveAdminEntity")
util.AddNetworkString("TPTSA:ResetTrainingData")
util.AddNetworkString("TPTSA:EditTrainingData")
util.AddNetworkString("TPTSA:ResetEntityData")
util.AddNetworkString("TPTSA:SaveSubData")
util.AddNetworkString("TPTSA:PurchaseSub")
util.AddNetworkString("TPTSA:GiveCreditSub")
util.AddNetworkString("TPTSA:UpdateAnimation")
util.AddNetworkString("TPTSA:StartTraining")
util.AddNetworkString("TPTSA:BeginTraining")
util.AddNetworkString("TPTSA:RefreshTraining")
util.AddNetworkString("TPTSA:StopTraining")
util.AddNetworkString("TPTSA:UpdClientInfo")
util.AddNetworkString("TPTSA:UpdClientBone")
util.AddNetworkString("TPTSA:DumbbellResult")
util.AddNetworkString("TPTSA:UpdateRunSpeedTeam")


/*---------------------------------------------------------------------------
	Save a training entity using the toolgun
	Arguments taken:
		- typeEnt: [for creation only] the type of entity
			* 1: Weigh balance
			* 2: Card reader
			* 3: Turnstile
			* 4: Treadmill
			* 5: Dumbbell
			* 6: Punching ball
		- value: specific custom value depending on the entity you are creating/editing
			* dumbbell: weight [1 to 7]
			* punching ball: weight [1 to 4]
			* treadmill: orientation [1 to 4]
		- ent: [for editing/removing only] the entity you want to edit/remove
		- isEdit: true = you're editing / false = you're removing
---------------------------------------------------------------------------*/

net.Receive("TPTSA:SaveAdminEntity", function(len, ply)
	if not Diablos.TS:IsAdmin(ply) then return end

	local typeEnt = net.ReadUInt(3)
	local value = net.ReadUInt(8)
	local ent = net.ReadEntity()
	local isEdit = net.ReadBool()

	Diablos.TS:InitDefaultFile()
	local filePath, fileContent = Diablos.TS:GetDataFile()
	local tableContent = util.JSONToTable(fileContent) or {}
	local tableContentCount = table.Count(tableContent)


	if IsValid(ent) then
		-- Edit / Remove

		-- We need the punching base to edit data
		if ent:GetClass() == "diablos_punching_ball" then
			ent = ent.punchingBase
		end
		if not IsValid(ent) then return end

		local id = ent:GetTrainingID()

		if isEdit then

			local newPos = ent:GetPos()
			local newAng = ent:GetAngles()

			tableContent[id].pos = newPos
			tableContent[id].ang = newAng

			if tableContent[id].weight then
				tableContent[id].weight = value
				ent:SetWeight(value)
				ent:Activate() -- refresh PhysObj
			end
			if tableContent[id].orientation then
				tableContent[id].orientation = value
				ent:UpdateAngle(value)
			end
		else

			if tableContentCount > 1 then
				-- Latest value takes the 'id' place
				tableContent[id] = tableContent[tableContentCount]
				tableContent[tableContentCount] = nil

				Diablos.TS.Entities[tableContentCount]:SetTrainingID(id)
				Diablos.TS.Entities[id] = Diablos.TS.Entities[tableContentCount]
				table.remove(Diablos.TS.Entities, tableContentCount)
			else
				tableContent[id] = nil
				table.remove(Diablos.TS.Entities, id)
			end

			if ent:GetClass() == "diablos_punching_base" then
				local punchingBall = ent.punchingBall
				if IsValid(punchingBall) then
					punchingBall:Remove()
				end
			end
			ent:Remove()
		end
	else
		-- Create
		local entName = Diablos.TS:GetEntityFromInteger(typeEnt)
		local newEnt = ents.Create(entName)
		if not IsValid(newEnt) then return end
		local newID = tableContentCount + 1
		local posToAdd = Vector(0, 0, 8)
		if typeEnt == 6 then
			posToAdd = Vector(0, 0, -1)
		end
		local pos = ply:GetEyeTrace().HitPos + posToAdd
		local ang = ply:GetAngles()
		newEnt:SetPos(pos)
		newEnt:SetAngles(ang)
		newEnt:SetTrainingID(newID)
		newEnt:Spawn()
		newEnt:Activate()

		tableContent[newID] = {}
		tableContent[newID].pos = pos
		tableContent[newID].ang = ang
		tableContent[newID].typeEnt = typeEnt

		if typeEnt == 4 then
			-- If this is the treadmill, we need to update the angle
			newEnt:UpdateAngle(value)
			tableContent[newID].orientation = value
		elseif typeEnt == 5 or typeEnt == 6 then
			-- If this is a dumbbell or punching ball, we need to update the weight
			newEnt:SetWeight(value)
			tableContent[newID].weight = value
		end

		table.insert(Diablos.TS.Entities, newID, newEnt)
	end

	Diablos.TS:Notify(ply, 0, Diablos.TS:GetLanguageString("entitiesUpdated"))

	local newContent = util.TableToJSON(tableContent, true)
	file.Write(filePath, newContent)
end)

/*---------------------------------------------------------------------------
	Reset training entities
	This will remove entities from the map and from the data files
---------------------------------------------------------------------------*/

net.Receive("TPTSA:ResetEntityData", function(len, ply)
	if not Diablos.TS:IsAdmin(ply) then return end

	Diablos.TS:EraseEntityFile()
	for _, ent in ipairs(Diablos.TS.Entities) do
		if IsValid(ent) then
			ent:Remove()
		end
	end

	table.Empty(Diablos.TS.Entities)
	Diablos.TS:Notify(ply, 0, Diablos.TS:GetLanguageString("entitiesRemoved"))
end)

/*---------------------------------------------------------------------------
	Reset training data for everyone
	This will reset everything in database and update the training data for everyone
	Training entities are not being affected
---------------------------------------------------------------------------*/

net.Receive("TPTSA:ResetTrainingData", function(len, ply)
	if not Diablos.TS:IsAdmin(ply) then return end

	Diablos.TS.Data:TableExists(function(created)
		if created then
			Diablos.TS.Data:DeleteTable()
			for _, pl in ipairs(player.GetAll()) do
				Diablos.TS:ConstructTrainingDataWithDatabase(pl) -- we need to reconstruct the whole training data table
			end
		end
	end)

	Diablos.TS:Notify(ply, 0, Diablos.TS:GetLanguageString("playerDataRemoved"))
end)

/*---------------------------------------------------------------------------
	Edit the experience of people for a specific training
	Arguments taken:
		- amountOfPlayers: the amount of players you're editing the data from
		- players: amountOfPlayers players in this table, which are the players we're editing the data from
		- typeAction: 
				* 0: stamina
				* 1: running speed
				* 2: strength
				* 3: attack speed
		- newValue: the new experience we set the players to

	This will save the new values in database
---------------------------------------------------------------------------*/

net.Receive("TPTSA:EditTrainingData", function(len, ply)
	if not Diablos.TS:IsAdmin(ply) then return end

	local amountOfPlayers = net.ReadUInt(8)
	local players = {}
	for i = 1, amountOfPlayers do
		table.insert(players, net.ReadEntity())
	end
	local typeAction = net.ReadUInt(2)
	local newValue = net.ReadUInt(32)

	local trainingName = Diablos.TS:GetTrainingFromInteger(typeAction)

	if not Diablos.TS:IsTrainingEnabled(trainingName) then return end

	for _, pl in ipairs(players) do
		if IsValid(pl) then
			pl:TSGetTrainingInfo(trainingName).xp = newValue
			Diablos.TS.Data:SaveTrainingInfo(pl) -- Update SQL data
			pl:TSUpdateTrainingValues(trainingName) -- Refresh percentage and XP information
			Diablos.TS:UpdateTrainingData(pl) -- Update training data clientside
		end
	end

	Diablos.TS:Notify(ply, 0, Diablos.TS:GetLanguageString("playerDataUpdated"))
end)

/*---------------------------------------------------------------------------
	Dumbbell result when the dumbbell training has ended, as this is managed clientside
	A lot of verifications are made to ensure clients don't abuse the "game" to grant XP/levels
	Arguments taken:
		- nbKeys: the amount of keys this level had
		- nbKeys booleans: if the key has been properly pressed (in the right time)
	
	This will calculate a ratio and give him a certain amount of points
---------------------------------------------------------------------------*/


net.Receive("TPTSA:DumbbellResult", function(len, ply)

	local trainingEnt = ply.TrainingMachine
	if not IsValid(trainingEnt) then return end -- if he is really doing a training
	if trainingEnt:GetClass() != "diablos_dumbbell" then return end -- training is dumbbell
	if not ply:TSCanTrain("strength") then return end
	if not ply:TSHasLevel("strength", trainingEnt:GetLevel()) then return end

	local nbKeys = net.ReadUInt(8)
	local amountResult = 0
	local total = 0
	for i = 1, nbKeys do
		if net.ReadBool() then
			amountResult = amountResult + 1
		end
		total = total + 1
	end
	ply.keyTable = keyTable

	local ratio = amountResult / total

	local xpEarn = (ratio * total) * 0.5 -- XP you earn depend on the total, which is increasing with more dumbbells

	ply:TSEndTraining("strength", xpEarn)

	ply.TrainingMachine:WorkEnd()
end)


/*---------------------------------------------------------------------------
	Begin a training
	Arguments taken:
		- ent: the entity you're training on
		- extraData: extra data depending on the training
			* a UInt(1) for the type of exercice for the treadmill
			* a UInt(5) for the key to blocklist for the dumbbell
		Therefore extraData is a UInt(5)
---------------------------------------------------------------------------*/

net.Receive("TPTSA:BeginTraining", function(len, ply)
	if ply:TSIsBlocklistedFromTraining() then
		Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("notAllowedJob"))
		return
	end
	local ent = net.ReadEntity()
	local extraData = net.ReadUInt(5)
	if not IsValid(ent) then return end
	if isfunction(ent.SetTypeExercice) then -- only for the treadmill
		ent:SetTypeExercice(extraData)
	elseif isfunction(ent.SetStopTrainingKey) then -- only for the dumbbell
		ent:SetStopTrainingKey(extraData)
	end
	ent:Work(ply)
end)

-- [[ Badge & Subscription Space ]] --

/*---------------------------------------------------------------------------
	Save new data of a terminal
	Arguments taken:
		- terminal: the terminal which will be edited
		- newSubPrice: the new subscription price for this terminal
			* should be between Diablos.TS.SubMinPrice and Diablos.TS.SubMaxPrice otherwise the price won't change in SetSubPrice(price)
		- ownerCount: the amount of owners of the terminal
		- owners: a table filled with ownerCount entities (the owners of the terminal)

	Call to SetSubPrice and UpdateOwners will update terminal data
---------------------------------------------------------------------------*/

net.Receive("TPTSA:SaveSubData", function(len, ply)
	local terminal = net.ReadEntity()
	if IsValid(terminal) then
		local newSubPrice = net.ReadUInt(16)

		local ownerCount = net.ReadUInt(8)
		local owners = {}
		for i = 1, ownerCount do
			owners[net.ReadEntity()] = true
		end

		terminal:SetSubPrice(newSubPrice)
		terminal:UpdateOwners(owners)

		Diablos.TS:Notify(ply, 0, Diablos.TS:GetLanguageString("subDataUpdated"))
	end
end)

/*---------------------------------------------------------------------------
	Purchase a subscription using a terminal
	Arguments taken:
		- terminal: the terminal you purchased the subscription on

	The net will check that your card can be recharged and that you have enough money,
	then the money taken from the subscription will be shared between terminal owners
---------------------------------------------------------------------------*/

net.Receive("TPTSA:PurchaseSub", function(len, ply)
	if not ply:TSCanPurchaseTrainingSubscription() then
		Diablos.TS:Notify(ply, 2, string.format(Diablos.TS:GetLanguageString("cardReaderFullyRecharged"), os.date(Diablos.TS:GetOSFormat(), ply:TSGetTrainingSubscription())))
		return
	end
	local terminal = net.ReadEntity()
	if IsValid(terminal) then
		local terminalPrice = terminal:GetSubPrice()
		if Diablos.TS:HasEnoughMoney(ply, terminalPrice) then
			Diablos.TS:RemoveMoney(ply, terminalPrice)

			local terminalOwners = terminal:GetOwners()
			local amountOfOwners = table.Count(terminalOwners)
			if amountOfOwners > 0 then
				local pricePerPerson = terminalPrice / amountOfOwners
				for owner, _ in pairs(terminalOwners) do
					if IsValid(owner) then
						Diablos.TS:AddMoney(owner, pricePerPerson)
						Diablos.TS:Notify(owner, 0, string.format(Diablos.TS:GetLanguageString("subPurchased"), Diablos.TS:GetCurrencyFormatType(pricePerPerson), ply:Nick()))
					end
				end
			end
		else
			Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("subNotEnoughMoney"))
			return
		end

		Diablos.TS:Notify(ply, 0, Diablos.TS:GetLanguageString("subRenewed"))

		ply:TSAddBadgeSubTime(Diablos.TS.SubTime) -- Adding time on the badge
		Diablos.TS.Data:SaveTrainingInfo(ply) -- Update SQL data
		Diablos.TS:UpdateTrainingData(ply) -- Update training data clientside
	end
end)

/*---------------------------------------------------------------------------
	Give a credit for a badge
	A credit allows you to use a turnstile once: this is like a one-time training
	The access is given by a sport coach (well, we allow it if you are admin)
---------------------------------------------------------------------------*/

net.Receive("TPTSA:GiveCreditSub", function(len, ply)
	if not ply:TSIsSportCoach() and not Diablos.TS:IsAdmin(ply) then return end
	local otherPlayer = net.ReadEntity()
	if IsValid(otherPlayer) then
		Diablos.TS:Notify(ply, 0, Diablos.TS:GetLanguageString("creditGiven"))
		Diablos.TS:Notify(otherPlayer, 0, Diablos.TS:GetLanguageString("creditReceived"))
		otherPlayer:TSAddBadgeCredit() -- Add one credit to access a turnstile once	
	end
end)