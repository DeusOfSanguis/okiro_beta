
local meta = FindMetaTable("Player")


/*---------------------------------------------------------------------------
	Check if the training data has been initialized for the player
---------------------------------------------------------------------------*/

function meta:TSIsTrainingDataLaunched()
	return self.TrainingInit
end

/*---------------------------------------------------------------------------
	Set the value as the training data has been initialized for the player
---------------------------------------------------------------------------*/

function meta:TSTrainingDataLaunched()
	self.TrainingInit = true
end



/*---------------------------------------------------------------------------
	Get the training information (taken from the global table) for the player.
		- typeTraining: the type of training you want to extract information from - could also be "badge" to get badge information
			if typeTraining is not set, then we get teh whole table
	If you want a training information not specific, then it returns the whole table
---------------------------------------------------------------------------*/

function meta:TSGetTrainingInfo(typeTraining)
	if not self.Training then return end -- if the training content is not loaded

	typeTraining = typeTraining or ""
	typeTraining = string.lower(typeTraining)

	if typeTraining == "stamina" then
		return self.Training.Trainings.stamina
	elseif typeTraining == "runningspeed" then
		return self.Training.Trainings.runningspeed
	elseif typeTraining == "strength" then
		return self.Training.Trainings.strength
	elseif typeTraining == "attackspeed" then
		return self.Training.Trainings.attackspeed
	elseif typeTraining == "badge" then
		return self.Training.Badge
	else
		return self.Training
	end
end

/*---------------------------------------------------------------------------
	Returns if the player is in a coach job
	This manages if Diablos.TS.CoachJob is a string or a table
---------------------------------------------------------------------------*/

function meta:TSIsSportCoach()
	local teamName = team.GetName(self:Team())
	local isSportCoach = false
	if type(Diablos.TS.CoachJob) == "string" then
		isSportCoach = teamName == Diablos.TS.CoachJob
	elseif type(Diablos.TS.CoachJob) == "table" then
		isSportCoach = table.HasValue(Diablos.TS.CoachJob, teamName)
	end
	return isSportCoach
end

/*---------------------------------------------------------------------------
	Returns if the player is in a blocklisted job for training
	This manages if Diablos.TS.BlocklistedJobs exists or not (new version)
---------------------------------------------------------------------------*/

function meta:TSIsBlocklistedFromTraining()
	local teamName = team.GetName(self:Team())
	local isBlocklisted = false
	if istable(Diablos.TS.BlocklistedJobs) then
		isBlocklisted = table.HasValue(Diablos.TS.BlocklistedJobs, teamName)
	end
	return isBlocklisted
end

/*---------------------------------------------------------------------------
	Get the training subscription
---------------------------------------------------------------------------*/

function meta:TSGetTrainingSubscription()
	return self:TSGetTrainingInfo("Badge").subdate
end


/*---------------------------------------------------------------------------
	Check if the training subscription of the current player is still valid
---------------------------------------------------------------------------*/

function meta:TSHasTrainingSubscription()
	return self:TSGetTrainingSubscription() >= os.time()
end

/*---------------------------------------------------------------------------
	Check if the player is still able to purchase a training subscription
---------------------------------------------------------------------------*/

function meta:TSCanPurchaseTrainingSubscription()
	return self:TSGetTrainingSubscription() < os.time() + Diablos.TS.MaximumSubTime * 60 * 60
end

/*---------------------------------------------------------------------------
	Check if the player has a credit (and therefore is able to access a turnstile once)
---------------------------------------------------------------------------*/

function meta:TSHasTrainingBadgeCredit()
	return (self.badgeCreditSub or 0) > 0
end

/*---------------------------------------------------------------------------
	Check if the player has different abilities (due to his job) than what you can have if you are a "regular player"
---------------------------------------------------------------------------*/

function meta:TSGetSpecificAbilities(typeTraining)
	local jobAbilityTable
	if typeTraining == "stamina" then
		jobAbilityTable = Diablos.TS.StaminaJobAbilities
	elseif typeTraining == "runningspeed" then
		jobAbilityTable = Diablos.TS.RunningSpeedJobAbilities
	elseif typeTraining == "strength" then
		jobAbilityTable = Diablos.TS.StrengthJobAbilities
	elseif typeTraining == "attackspeed" then
		jobAbilityTable = Diablos.TS.AttackSpeedJobAbilities
	end

	if not jobAbilityTable then return end
	local teamName = team.GetName(self:Team())
	return jobAbilityTable[teamName]
end


/*---------------------------------------------------------------------------
	Get the values useful for trainings depending on your level
---------------------------------------------------------------------------*/

function meta:TSGetStaminaTimeDuration()
	if not Diablos.TS:IsTrainingEnabled("stamina") then return 0 end
	local level = Diablos.TS:GetTrainingLevel("stamina", self)
	local levelTable = Diablos.TS:GetTrainingLevelTable("stamina")

	local timeduration = levelTable[level].timeduration

	local specificAbility = self:TSGetSpecificAbilities("stamina")
	if specificAbility then
		timeduration = specificAbility[level].timeduration
	end

	return timeduration
end

function meta:TSGetRunningSpeed()
	if not Diablos.TS:IsTrainingEnabled("runningspeed") then return 0 end
	local level = Diablos.TS:GetTrainingLevel("runningspeed", self)
	local levelTable = Diablos.TS:GetTrainingLevelTable("runningspeed")

	local runspeed = levelTable[level].runspeed

	local specificAbility = self:TSGetSpecificAbilities("runningspeed")
	if specificAbility then
		runspeed = specificAbility[level].runspeed
	end

	return runspeed
end

function meta:TSGetStrengthDamage()
	if not Diablos.TS:IsTrainingEnabled("strength") then return 100 end
	local level = Diablos.TS:GetTrainingLevel("strength", self)
	local levelTable = Diablos.TS:GetTrainingLevelTable("strength")

	local damage = levelTable[level].damage + 100

	local specificAbility = self:TSGetSpecificAbilities("strength")
	if specificAbility then
		damage = specificAbility[level].damage + 100
	end

	return damage
end

function meta:TSGetAttackSpeed()
	if not Diablos.TS:IsTrainingEnabled("attackspeed") then return 100 end
	local level = Diablos.TS:GetTrainingLevel("attackspeed", self)
	local levelTable = Diablos.TS:GetTrainingLevelTable("attackspeed")

	local attackspeed = levelTable[level].attackspeed + 100

	local specificAbility = self:TSGetSpecificAbilities("attackspeed")
	if specificAbility then
		attackspeed = specificAbility[level].attackspeed + 100
	end

	return attackspeed
end


/*---------------------------------------------------------------------------
	Add a specific score for the player:
		- typeTraining: the type of training we're adding the score on
		- scoreValue: the score (points) we're adding for that training
---------------------------------------------------------------------------*/

function meta:TSAddScore(typeTraining, scoreValue)
	self:TSGetTrainingInfo(typeTraining).xp = self:TSGetTrainingInfo(typeTraining).xp + scoreValue
	self:TSGetTrainingInfo(typeTraining).date = os.time() + Diablos.TS.MuscleRest * 60 * 60
	Diablos.TS.Data:SaveTrainingInfo(self) -- Update SQL data
	self:TSUpdateTrainingValues(typeTraining) -- refresh percentage and XP information
end

/*---------------------------------------------------------------------------
	Add a badge subscription time
---------------------------------------------------------------------------*/

function meta:TSAddBadgeSubTime(timeToAdd)
	timeToAdd = timeToAdd * 60 * 60
	self:TSGetTrainingInfo("badge").subdate = math.max(self:TSGetTrainingSubscription(), os.time()) + timeToAdd
end

/*---------------------------------------------------------------------------
	Add a badge credit
---------------------------------------------------------------------------*/

function meta:TSAddBadgeCredit()
	self.badgeCreditSub = 1
end

/*---------------------------------------------------------------------------
	Get the amount of credits (currently, you can only have 0 or 1 credit)
---------------------------------------------------------------------------*/

function meta:TSGetBadgeCredit()
	return self.badgeCreditSub or 0
end

/*---------------------------------------------------------------------------
	Use a credit
---------------------------------------------------------------------------*/

function meta:TSUseBadgeCredit()
	self.badgeCreditSub = self.badgeCreditSub - 1
end


/*---------------------------------------------------------------------------
	Refresh level data (percentage/level value) when the XP value has been changed
	Called:
		- when the player joins
		- when an admin is editing training data on the player
		- when the player ended his training
---------------------------------------------------------------------------*/

function meta:TSUpdateTrainingValues(typeTraining)
	typeTraining = string.lower(typeTraining)
	if typeTraining == "runningspeed" then
		self:TSRefreshRunSpeed()
	elseif typeTraining == "stamina" then
		self:TSRefreshStamina()
	end
end

/*---------------------------------------------------------------------------
	Called on startup to update all the trainings by launching updateTrainingValues()
---------------------------------------------------------------------------*/

function meta:TSUpdateTrainings()
	local trainings = Diablos.TS:GetTrainings()
	for _, typeTraining in ipairs(trainings) do
		self:TSUpdateTrainingValues(typeTraining)
	end
end


-- _G["tc"]["player"]["SetRunSpeed"]
local func = meta.SetRunSpeed
function meta:SetRunSpeed(runspeed)
	func(self, runspeed)

	-- This value is always true to set the runspeed with the stamina EXCEPT when calling SetRunSpeed with the "stamina speed" to avoid stack overflow
	if self.TS_RUN_SPEED_UPD_STAMINA then
		self.TS_JOB_RUN_SPEED = runspeed

		if SERVER then
			net.Start("TPTSA:UpdateRunSpeedTeam")
				net.WriteUInt(runspeed, 10) -- send the runspeed without the stamina abilities
			net.Send(self)
		end

		self:TSRefreshRunSpeed()
	end
end