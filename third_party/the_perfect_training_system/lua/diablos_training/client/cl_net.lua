
/*---------------------------------------------------------------------------
	Notify someone
---------------------------------------------------------------------------*/

net.Receive("TPTSA:Notify", function(len, ply)
	local type = net.ReadUInt(3)
	local text = net.ReadString()
	notification.AddLegacy(text, type, 5)
end)

/*---------------------------------------------------------------------------
	Starting a training
	Arguments sent:
		- type of training
		- duration of the training
		- [optional] the amount of keys followed by the key numbers for the strength training
---------------------------------------------------------------------------*/

net.Receive("TPTSA:StartTraining", function(len, _)
	local ply = LocalPlayer()

	local typeTrainingInt = net.ReadUInt(2)
	local typeTraining = Diablos.TS:GetTrainingFromInteger(typeTrainingInt)

	local timeTraining = net.ReadUInt(8)

	local keyTableStrength = {}
	if typeTraining == "strength" then
		local nbKeys = net.ReadUInt(8)
		for i = 1, nbKeys do
			table.insert(keyTableStrength, net.ReadUInt(6))
		end
		ply.keyTable = keyTableStrength
	end

	Diablos.TS:StartTraining(ply, typeTraining, timeTraining)
end)

/*---------------------------------------------------------------------------
	A training has ended
	Arguments sent:
		- type of training
---------------------------------------------------------------------------*/

net.Receive("TPTSA:StopTraining", function(len, _)
	local ply = LocalPlayer()
	local typeTrainingInt = net.ReadUInt(2)
	local typeTraining = Diablos.TS:GetTrainingFromInteger(typeTrainingInt)

	Diablos.TS:StopTraining(ply, typeTraining)
end)

/*---------------------------------------------------------------------------
	Refresh clientside values when you're doing a training
	Arguments sent:
		- type of training
		- a refreshed value of your training, which is:
			* treadmill: the current speed
			* dumbbell: not used
			* punching ball: the amount of redpoints touched on the punching ball
---------------------------------------------------------------------------*/

net.Receive("TPTSA:RefreshTraining", function(len, _)
	local ply = LocalPlayer()
	local typeTrainingInt = net.ReadUInt(2)
	local typeTraining = Diablos.TS:GetTrainingFromInteger(typeTrainingInt)
	local newNumber = net.ReadUInt(8)

	Diablos.TS:RefreshTraining(ply, typeTraining, newNumber)
end)


/*---------------------------------------------------------------------------
	Update the animation for a specific player
	Used for the dumbbell when the player is training
---------------------------------------------------------------------------*/

net.Receive("TPTSA:UpdateAnimation", function(len, _)
	local plyAnim = net.ReadEntity()
	local isStarting = net.ReadBool()

	Diablos.TS:UpdateAnimation(plyAnim, isStarting)
end)

/*---------------------------------------------------------------------------
	Open a frame according to the machine you want to train for
	Arguments sent:
		- the entity to train for

	It isn't the type of entity (which would be a UInt(2)) because the treadmill has two type of exercices,
	and the user would need to choose which exercice he wants to do with this frame.
---------------------------------------------------------------------------*/

net.Receive("TPTSA:OpenTrainingExercicePanel", function(len, _)
	local ply = LocalPlayer()

	local ent = net.ReadEntity()
	if IsValid(ent) then
		local class = ent:GetClass()

		-- same condition for stamina and runningspeed at the moment
		if class == "diablos_treadmill" then
			Diablos.TS:OpenRunningPanel(ply, ent)
		elseif class == "diablos_dumbbell" then
			Diablos.TS:OpenDumbbellPanel(ply, ent)
		elseif class == "diablos_punching_base" or class == "diablos_punching_ball" then
			Diablos.TS:OpenPunchingPanel(ply, ent)
		end
	end

end)

/*---------------------------------------------------------------------------
	Called when the client spawn to update the Training table clientside 
---------------------------------------------------------------------------*/

net.Receive("TPTSA:UpdClientInfo", function(len, _)
	local ply = LocalPlayer()

	ply.Training = Diablos.TS:ReadTrainingInfo(ply)

	if Diablos.TS.DebugSupport then
		Diablos.TS:DebugConsoleMsg(2, "--- Beg Table Retrieve for Client ---")
		PrintTable(ply.Training)
		Diablos.TS:DebugConsoleMsg(2, "--- End Table Retrieve for Client ---")
	end

	if not ply:TSIsTrainingDataLaunched() then
		ply:TSTrainingDataLaunched()
	end

	ply:TSUpdateTrainings()
end)


/*---------------------------------------------------------------------------
	Broadcasted to everyone when someone:
	* spawns (and has training data so he has bigger bones)
	* changes his model
	* ended a training which changes the bones sizes
---------------------------------------------------------------------------*/

net.Receive("TPTSA:UpdClientBone", function(len, _)
	if not Diablos.TS.ChangeBones then return end

	local plyBone = net.ReadEntity()
	if not IsValid(plyBone) then return end

	local trainings = {}

	local amountOfTrainingsToUpdate = net.ReadUInt(2) + 1

	for i = 1, amountOfTrainingsToUpdate do
		local typeMuscleInt = net.ReadUInt(2)
		local typeMuscle = Diablos.TS:GetTrainingFromInteger(typeMuscleInt)
		local curLevel = net.ReadUInt(8)
		local forceReset = net.ReadBool()

		trainings[typeMuscle] = {level = curLevel, reset = forceReset}
	end

	Diablos.TS:RefreshBones(plyBone, trainings)
end)

/*---------------------------------------------------------------------------
	Update the default "run speed" value when changing team. Called when:
	* changing team

---------------------------------------------------------------------------*/


net.Receive("TPTSA:UpdateRunSpeedTeam", function(len, _)
	local ply = LocalPlayer()

	ply.TS_JOB_RUN_SPEED = net.ReadUInt(10)

	if Diablos.TS.DebugSupport then
		print("New speed client : ", ply.TS_JOB_RUN_SPEED)
	end
end)