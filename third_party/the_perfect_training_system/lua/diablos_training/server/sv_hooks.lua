/*---------------------------------------------------------------------------
	Construct the training table at startup (when the client is fully loaded)
	Dirty hack found at https://wiki.facepunch.com/gmod/GM:PlayerInitialSpawn
---------------------------------------------------------------------------*/

-- If the code available here doesn't exist yet: https://wiki.facepunch.com/gmod/GM:PlayerInitialSpawn
hook.Add("PlayerInitialSpawn","TPTSA:FullLoadSetupSpawn",function(ply)
	hook.Add("SetupMove", ply, function(self, pl, _, cmd)
		if self == pl and not cmd:IsForced() then
			hook.Run("PlayerFullLoad", self)
			hook.Remove("SetupMove", self)
		end
	end)
end)

hook.Add("PlayerFullLoad", "TPTSA:FullLoadSetupHook", function(ply)
	Diablos.TS:DebugConsoleMsg(2, "--- Launching Client Spawn Detection ---")
	if not Diablos.TS.Joining[ply] then
		hook.Run("TPTSA:ClientSpawn", ply)
		Diablos.TS.Joining[ply] = true
	end
end)



hook.Add("TPTSA:ClientSpawn", "TPTSA:SpawnMuscleInfos", function(ply)
	ply.TS_RUN_SPEED_UPD_STAMINA = true -- Update the stamina when calling SetRunSpeed
	Diablos.TS:DebugConsoleMsg(2, "--- Client Spawn Detection ---")
	if not Diablos.TS:IsUsingCharacterSystem() then
		Diablos.TS:DebugConsoleMsg(2, "--- Client Spawn Detection Without Char System ---")
		Diablos.TS:ConstructTrainingDataWithDatabase(ply)
	end
end)


/*---------------------------------------------------------------------------
	Update the bones if a player changes the team so potentially the model
	Warning: we should update bones when the model changes, but there isnt a PlayerChangedModel hook 
	so I do it there (for DarkRP this is often the same thing)
---------------------------------------------------------------------------*/

hook.Add("PlayerChangedTeam", "TPTSA:UpdateModelBone", function(ply, oldTeam, newTeam)
	if ply:TSGetTrainingInfo() then
		if oldTeam != newTeam then
			-- Waiting for the other PlayerChangedTeam hooks to be launched
			timer.Simple(0.5, function()
				if not IsValid(ply) then return end
				-- If the job is blocklisted, then we reset the bones - otherwise, we set them depending on the value
				Diablos.TS:UpdateTrainingBones(ply, Diablos.TS.TrainingsChangingBone, ply:TSIsBlocklistedFromTraining())
			end)
		end
	end
end)

/*---------------------------------------------------------------------------
	Update the bones if a player spawns so changing the model
	Warning: we should update bones when the model changes, but there isnt a PlayerChangedModel hook 
	so I do it there
---------------------------------------------------------------------------*/

hook.Add("PlayerSpawn", "TPTSA:SpawnUpdBoneAndSpeed", function(ply)
	if ply:TSGetTrainingInfo() then
		-- Waiting for the other PlayerChangedTeam hooks to be launched
		timer.Simple(0.5, function()
			if not IsValid(ply) then return end
			-- If the job is blocklisted, then we reset the bones - otherwise, we set them depending on the value
			Diablos.TS:UpdateTrainingBones(ply, Diablos.TS.TrainingsChangingBone, ply:TSIsBlocklistedFromTraining())
		end)
	end
end)


/*---------------------------------------------------------------------------
	Reset training data when a player changes team, is dead or is disconnected. Training data are:
		- Removing terminal machines you own if you were a coach
		- Ending the training if you were doing a training
---------------------------------------------------------------------------*/

hook.Add("PlayerChangedTeam", "TPTSA:SubHook:ChangedTeam", function(ply, oldTeam, newTeam)
	if ply:TSIsSportCoach() then
		ply:TSRemoveTerminalMachines()
	end
	if IsValid(ply.TrainingMachine) then
		ply.TrainingMachine:WorkEnd()
	end
end)

hook.Add("PlayerDeath", "TPTSA:SubHook:Death", function(ply, inf, att)
	if ply:TSIsSportCoach() then
		ply:TSRemoveTerminalMachines()
	end
	if IsValid(ply.TrainingMachine) then
		ply.TrainingMachine:WorkEnd()
	end
end)

hook.Add("PlayerDisconnected", "TPTSA:SubHook:Disconnect", function(ply)
	if ply:TSIsSportCoach() then
		ply:TSRemoveTerminalMachines()
	end
	if IsValid(ply.TrainingMachine) then
		ply.TrainingMachine:WorkEnd()
	end
end)

/*---------------------------------------------------------------------------
	Force the trained fists SWEP when you are training with the punching ball
	trained_fists are the default fists with the attack speed / strength took into consideration
---------------------------------------------------------------------------*/

hook.Add( "PlayerSwitchWeapon", "TPTSA:PunchingHook:SelectFists", function( ply, oldWeapon, newWeapon )
	if IsValid(ply.TrainingMachine) and ply.TrainingMachine:GetClass() == "diablos_punching_ball" then
		if newWeapon:GetClass() != "trained_fists" then
			ply:SelectWeapon("trained_fists")
		end
	end
end )



/*---------------------------------------------------------------------------
	Spawn training entities on start and after a cleanup
---------------------------------------------------------------------------*/

hook.Add("InitPostEntity", "TPTSA:Init", Diablos.TS.GetEntities)
hook.Add("PostCleanupMap", "TPTSA:Cleanup", Diablos.TS.GetEntities)

/*---------------------------------------------------------------------------
	Update training entities data when those entities have been created using the toolgun
---------------------------------------------------------------------------*/

hook.Add("PhysgunDrop", "TPTSA:AutoRefresh", function(ply, ent)
	if IsValid(ply) and IsValid(ent) then
		if Diablos.TS:IsTrainingEntity(ent:GetClass()) then
			if not Diablos.TS:IsAdmin(ply) then return end

			local id = ent:GetTrainingID()
			if id > 0 then -- We don't save the entity if the id is invalid
				local newPos = ent:GetPos()
				local newAng = ent:GetAngles()

				Diablos.TS:InitDefaultFile()

				local filePath, fileContent = Diablos.TS:GetDataFile()

				local tableContent = util.JSONToTable(fileContent)
				tableContent[id].pos = newPos
				tableContent[id].ang = newAng

				local newContent = util.TableToJSON(tableContent, true)
				file.Write(filePath, newContent)

				if isfunction(ent.ResetCameras) then
					ent:ResetCameras()
				end

				Diablos.TS:Notify(ply, 0, "New position & angle of this training entity have been updated!")
			end
		end
	end
end)

