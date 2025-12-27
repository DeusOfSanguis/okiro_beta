local meta = FindMetaTable("Player")

/*---------------------------------------------------------------------------
	Verify that the player is able to start a specific training of type "typeTraining"
	(by checking the time needed to start again a training)
---------------------------------------------------------------------------*/

function meta:TSCanTrain(typeTraining)
	local date = self:TSGetTrainingInfo(typeTraining).date

	if date != nil then
		local osTime = os.time()
		local allowedTime = os.difftime(osTime, date)/5
		if allowedTime > 0 then
			return true
		else
			Diablos.TS:Notify(self, 1, string.format(Diablos.TS:GetLanguageString("alreadyTrained"), Diablos.TS:NiceTimeFormat(math.abs(allowedTime))))
		end
	end
	
	return false
end

/*---------------------------------------------------------------------------
	Verify that the player is able to start a specific training of type "typeTraining" with a specific level "level"
	(by checking the player has the level you need for that)

	This will see the amount of levels there is in the training,
	the amount of different machines you have for this type of training
	to calculate a ratio.
	The most "difficult" machine is available only if you have the last level.
---------------------------------------------------------------------------*/

function meta:TSHasLevel(typeTraining, level)
	local playerLevel = Diablos.TS:GetTrainingLevel(typeTraining, self)

	local levelTable = Diablos.TS:GetTrainingLevelTable(typeTraining)
	local bodygroupTable = Diablos.TS:GetTrainingBodygroupTable(typeTraining)

	local ratio = #levelTable / #bodygroupTable

	local maxLevelForEnt = math.floor(level * ratio)
	-- First machine should always be accessible
	if level == 1 then
		maxLevelForEnt = 1
	end
	-- Verify that the machine you want to train on is in your level range
	if playerLevel >= maxLevelForEnt then
		-- Block the training for machines which are too easy
		if Diablos.TS.HardestTrainingOnly then
			-- Last entity is only for last level - If this is not the last level, then it is not the last entity
			if playerLevel < #levelTable then 
				local nextLevelForEnt = math.floor((level + 1) * ratio)

				if playerLevel >= nextLevelForEnt then
					Diablos.TS:Notify(self, 1, Diablos.TS:GetLanguageString("tooEasy"))
					return false
				end
			end
		end
		return true
	else
		Diablos.TS:Notify(self, 1, string.format(Diablos.TS:GetLanguageString("needMoreLevel"), maxLevelForEnt))
	end


	return false
end

/*---------------------------------------------------------------------------
	Training "typeTraining" has ended for self, with nbPoints earned
	This will update training data as well as bones if necessary (if the level has changed)
---------------------------------------------------------------------------*/

function meta:TSEndTraining(typeTraining, nbPoints)
	Diablos.TS:Notify(self, 0, Diablos.TS:GetLanguageString("endTraining"))
	nbPoints = math.ceil(nbPoints)
	Diablos.TS:Notify(self, 0, string.format(Diablos.TS:GetLanguageString("xpAdded"), nbPoints))

	local previousLevel = Diablos.TS:GetTrainingLevel(typeTraining, self)

	self:TSAddScore(typeTraining, nbPoints)

	local newLevel = Diablos.TS:GetTrainingLevel(typeTraining, self)

	-- Update training data clientside
	Diablos.TS:UpdateTrainingData(self)
	if previousLevel != newLevel then
		Diablos.TS:Notify(self, 0, string.format(Diablos.TS:GetLanguageString("newLevel"), newLevel))

		-- If this is a training which induct bones (well - currently, all the trainings induct bones)
		if table.HasValue(Diablos.TS.TrainingsChangingBone, typeTraining) then
			-- Update bones
			Diablos.TS:UpdateTrainingBones(self, {typeTraining})
		end
	end
end

/*---------------------------------------------------------------------------
	Add a player on the training_card_reader terminal
---------------------------------------------------------------------------*/

function meta:TSAddTerminalMachine(terminal)
	if IsValid(terminal) then
		self.terminalMachines = self.terminalMachines or {}

		self.terminalMachines[terminal] = true

		terminal:AddTerminalOwner(self)
	end
end

/*---------------------------------------------------------------------------
	Remove a player on the training_card_reader terminal
---------------------------------------------------------------------------*/

function meta:TSRemoveTerminalMachine(terminal)
	if IsValid(terminal) then
		terminal:RemoveTerminalOwner(self)

		self.terminalMachines[terminal] = nil
	end
end

/*---------------------------------------------------------------------------
	Remove a player from all the terminals
	Used when:
		- the player changed team and is no more a coach
		- the player died
		- the player disconnected
---------------------------------------------------------------------------*/

function meta:TSRemoveTerminalMachines()
	local terminalMachines = self.terminalMachines
	if self.terminalMachines then
		for terminal, _ in pairs(terminalMachines) do
			self:TSRemoveTerminalMachine(terminal)
		end
	end
end


