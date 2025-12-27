
local routineCheck = Diablos.TS.RoutineCheck * 60 * 60
local repetition = 0

if routineCheck == 0 then
	routineCheck = 0.1
	repetition = 1 -- launched once
end

timer.Create("TPTSA:RoutineLoseLevel", routineCheck, repetition, function()

	if Diablos.TS.RetroLevel then

		local osDate = os.time() + Diablos.TS.RetroTime * 60 * 60

		local trainings = Diablos.TS:GetTrainings()

		Diablos.TS.Data:GetTrainingExpired(osDate, function(dateExpired)
			for _, dataPly in ipairs(dateExpired) do
				local steamid64 = dataPly.uid

				for _, training in ipairs(trainings) do
					local xp, date
					local properTitle = Diablos.TS:GetLanguageString(training)
					if training == "stamina" then
						xp = dataPly.staminaXP
						date = dataPly.staminaDate
					elseif training == "runningspeed" then
						xp = dataPly.runningspeedXP
						date = dataPly.runningspeedDate
					elseif training == "strength" then
						xp = dataPly.strengthXP
						date = dataPly.strengthDate
					elseif training == "attackspeed" then
						xp = dataPly.attackspeedXP
						date = dataPly.attackspeedDate
					end
					xp = tonumber(xp)
					date = tonumber(date)

					if date != 0 and xp != 0 and date <= osDate then
						local newXP = math.max(xp - Diablos.TS.LoseXP, 0)
						Diablos.TS.Data:UpdateField(steamid64, training, newXP, os.time())

						local plyConnected = player.GetBySteamID64(steamid64)
						if plyConnected and IsValid(plyConnected) then
							local text = string.format(Diablos.TS:GetLanguageString("lossOfTraining"), properTitle)
							Diablos.TS:Notify(plyConnected, 1, text)
							Diablos.TS:ConstructTrainingDataWithDatabase(plyConnected)
						end
						hook.Run("TPTSA:Hook:LosingXP", plyConnected, steamid64, training, xp, newXP)
					end
				end
			end
		end)
	else
		timer.Remove("TPTSA:RoutineLoseLevel")
	end
end)

/*---------------------------------------------------------------------------
	Notify a player (uses the DarkRP.notify if the gamemode is DarkRP)
----------------------------------------------------------------------------*/

function Diablos.TS:Notify(ply, type, text)
	if DarkRP then
		DarkRP.notify(ply, type, 5, text)
	else
		net.Start("TPTSA:Notify")
			net.WriteUInt(type, 3)
			net.WriteString(text)
		net.Send(ply)
	end
end


/*---------------------------------------------------------------------------
	Returns two variables:
		- the file path
		- the file content
---------------------------------------------------------------------------*/

Diablos.TS.Data.FolderName = "training"
Diablos.TS.Data.MapName = string.lower(game.GetMap())

function Diablos.TS:GetDataFile()
	local filePath = string.format("diablos/%s/%s.txt", Diablos.TS.Data.FolderName, Diablos.TS.Data.MapName)
	local contentFile = file.Read(filePath)

	return filePath, contentFile
end

/*---------------------------------------------------------------------------
	Initialize folders and an empty file
---------------------------------------------------------------------------*/

function Diablos.TS:InitDefaultFile()
	if not file.IsDir("diablos", "DATA") then file.CreateDir("diablos") end
	if not file.IsDir(string.format("diablos/%s", Diablos.TS.Data.FolderName), "DATA") then file.CreateDir(string.format("diablos/%s", Diablos.TS.Data.FolderName)) end
	local filePath = string.format("diablos/%s/%s.txt", Diablos.TS.Data.FolderName, Diablos.TS.Data.MapName)
	if not file.Exists(filePath, "DATA") then file.Write(filePath, "") end
end

/*---------------------------------------------------------------------------
	Empty the file to remove everything on it
---------------------------------------------------------------------------*/

function Diablos.TS:EraseEntityFile()
	if not file.IsDir("diablos", "DATA") then return end
	if not file.IsDir(string.format("diablos/%s", Diablos.TS.Data.FolderName), "DATA") then return end
	local filePath = string.format("diablos/%s/%s.txt", Diablos.TS.Data.FolderName, Diablos.TS.Data.MapName)
	if file.Exists(filePath, "DATA") then file.Write(filePath, "") end
end

/*---------------------------------------------------------------------------
	Get the entities on startup

---------------------------------------------------------------------------*/

function Diablos.TS:GetEntities()
	local _, fileContent = Diablos.TS:GetDataFile()

	if not fileContent then return end
	table.Empty(Diablos.TS.Entities)

	local bigTable = util.JSONToTable(fileContent) or {}
	for k,v in ipairs(bigTable) do
		local entName = Diablos.TS:GetEntityFromInteger(v.typeEnt)
		local ent = ents.Create(entName)
		if not IsValid(ent) then continue end
		ent:SetPos(v.pos)
		ent:SetAngles(v.ang)
		ent:SetTrainingID(k)
		ent:Spawn()
		ent:Activate()

		-- Set the orientation for treadmill
		if v.typeEnt == 4 then
			ent:UpdateAngle(v.orientation)
		-- Set the weight for dumbbells and punching balls
		elseif v.typeEnt == 5 or v.typeEnt == 6 then
			ent:SetWeight(v.weight)
		end

		table.insert(Diablos.TS.Entities, k, ent)
	end
end

/*---------------------------------------------------------------------------
	Construct training data on startup
	The GetTrainingInfo() could return a success function but the result being nil if nothing is selected
	We will then call ConstructTrainingData with the proper data
---------------------------------------------------------------------------*/

function Diablos.TS:ConstructTrainingData(ply, muscleInfos, updBones)
	if not IsValid(ply) then return end

	-- Diablos.TS:DebugConsoleMsg(typeMsg, msg)

	-- Construct the table serverside
	Diablos.TS:ConstructTrainingTable(ply, muscleInfos)

	if Diablos.TS.DebugSupport then
		Diablos.TS:DebugConsoleMsg(2, "--- Beg Table Generation ---")
		PrintTable(ply.Training)
		Diablos.TS:DebugConsoleMsg(2, "--- End Table Generation ---")
	end

	-- Update trainings calculations (calculate the level and the percentage of your current level before the next one etc.)
	ply:TSUpdateTrainings()

	-- Update training data by sending information clientside
	Diablos.TS:UpdateTrainingData(ply)

	-- Update training bone
	timer.Simple(0, function()
		if IsValid(ply) then
			if updBones then
				Diablos.TS:UpdateTrainingBones(ply, Diablos.TS.TrainingsChangingBone)
			end
		end
	end)
end

function Diablos.TS:ConstructTrainingDataWithDatabase(ply)

	-- Function is being sent when results are get
	Diablos.TS.Data:TSGetTrainingInfo(ply, function(muscleInfos)

		local data = true
		if not muscleInfos then
			muscleInfos = {}
			muscleInfos[1] = nil
			data = false -- we don't need to update his bones, he never trained
		end

		if Diablos.TS.DebugSupport then
			Diablos.TS:DebugConsoleMsg(2, "--- Beg SQL Result ---")
			Diablos.TS:DebugConsoleMsg(0, "SUCCESS")
			Diablos.TS:DebugConsoleMsg(2, tostring(data))
			PrintTable(muscleInfos)
			Diablos.TS:DebugConsoleMsg(2, "--- End SQL Result ---")
		end

		Diablos.TS:ConstructTrainingData(ply, muscleInfos[1], data)
	
	end, function(fail)

		local muscleInfos = {}
		muscleInfos[1] = nil
		local data = false -- we don't need to update his bones, he never trained

		if Diablos.TS.DebugSupport then
			Diablos.TS:DebugConsoleMsg(2, "--- Beg SQL Result ---")
			Diablos.TS:DebugConsoleMsg(1, "FAIL")
			PrintTable(muscleInfos)
			Diablos.TS:DebugConsoleMsg(2, "--- End SQL Result ---")
		end

		Diablos.TS:ConstructTrainingData(ply, muscleInfos[1], data)

	end)
end

/*---------------------------------------------------------------------------
	Update training data from server to client
	Happens:
		- When a client joins
		- When a training has ended
		- When your XP has changed through the admin panel
---------------------------------------------------------------------------*/

function Diablos.TS:UpdateTrainingData(ply)
	Diablos.TS:DebugConsoleMsg(2, "--- Updating training data to the client (" .. ply:Nick() .. ") ---")
	net.Start("TPTSA:UpdClientInfo")
		Diablos.TS:WriteTrainingInfo(ply)
	net.Send(ply)
end

/*---------------------------------------------------------------------------
	Update the bones for the "trainings" specified for a player
	The bones are not being updated if the feature is disabled or if the model is blocklisted
	There is also an optional parameter called toReset, which, if unset, is default to false, and if set to true, will reset all bones to the default state
---------------------------------------------------------------------------*/

function Diablos.TS:UpdateTrainingBones(ply, trainings, toReset)
	if not Diablos.TS.ChangeBones then return end
	if Diablos.TS.BoneModelBlocklist[ply:GetModel()] then return end
	if #trainings == 0 then return end
	if toReset == nil then toReset = false end

	net.Start("TPTSA:UpdClientBone")
		net.WriteEntity(ply)
		net.WriteUInt(#trainings - 1, 2)
		for _, training in pairs(trainings) do
			net.WriteUInt(Diablos.TS:GetIntegerFromTraining(training), 2) -- type
			net.WriteUInt(Diablos.TS:GetTrainingLevel(training, ply), 8)
			net.WriteBool(toReset) -- if we should reset muscle to the default state
		end
	net.Broadcast()
end

/*---------------------------------------------------------------------------
	Write training information about the player
---------------------------------------------------------------------------*/

function Diablos.TS:WriteTrainingInfo(ply)
	local trainings = Diablos.TS:GetTrainings()
	for _, training in ipairs(trainings) do
		local trainingData = ply:TSGetTrainingInfo(training)
		net.WriteUInt(trainingData.xp, 32)
		net.WriteUInt(trainingData.date, 32)
	end
	net.WriteUInt(ply:TSGetTrainingInfo("Badge").subdate, 32)
end


/*---------------------------------------------------------------------------
	Rotate an object around the origin for a certain angle
		- originObject: the origin
		- objectToRotate: the object we'll rotate
		- angleToRotate: the angle we'll rotate him

	This is used when creating cameras when training
---------------------------------------------------------------------------*/

function Diablos.TS:RotateObject(originObject, objectToRotate, angleToRotate)
	if not IsValid(originObject) or not IsValid(objectToRotate) then return end

	local centerPos = originObject:GetPos()

	local pointPos = objectToRotate:GetPos()

	local ANGLE = angleToRotate * math.pi / 180

	local x1 = pointPos.x - centerPos.x
	local y1 = pointPos.y - centerPos.y

	local x2 = x1 * math.cos(ANGLE) - y1 * math.sin(ANGLE)
	local y2 = x1 * math.sin(ANGLE) + y1 * math.cos(ANGLE)

	local newPos = Vector(x2 + centerPos.x, y2 + centerPos.y, pointPos.z)

	objectToRotate:SetPos(newPos)
end


Diablos.TS.TIMER_CAMERA = 3

/*-------------------------------------------------------------------------
	Returns if the camera feature is a "fixed camera",
	meaning there is only one camera total
---------------------------------------------------------------------------*/
function Diablos.TS:IsFixedCamera()
	return Diablos.TS.AmountCameras == 1
end

/*-------------------------------------------------------------------------
	Create the cameras for a training entity "ent", with a specific vector "relativeVector"
---------------------------------------------------------------------------*/

function Diablos.TS:CreateCameras(ent, relativeVector)
	if not IsValid(ent) then return end

	local cameras = {}
	for i = 1, Diablos.TS.AmountCameras do
		local camera = ents.Create("gmod_cameraprop")
		if not IsValid(camera) then return end
		local pos = ent:GetPos() + relativeVector
		local ang = ent:GetAngles()
		camera:SetPos(pos)
		camera:SetAngles(Angle(0, ang.y, 0))
		camera:SetTracking(ent, Vector(10, 0, 50))
		--camera:SetLocked(true)

		local rotationVal = 90
		if Diablos.TS:IsFixedCamera() then
			rotationVal = Diablos.TS.CameraViewsPos[ent:GetClass()]
		end

		rotationVal = rotationVal - 30 * (i - 1)
		Diablos.TS:RotateObject(ent, camera, rotationVal)	
		
		table.insert(cameras, camera)
	end

	return cameras
end

/*-------------------------------------------------------------------------
	Change the active camera regularly
---------------------------------------------------------------------------*/

function Diablos.TS:UpdateActiveCamera(ent, ply)
	if not IsValid(ent) or not IsValid(ply) then return end

	ply:SetViewEntity(ent.cameras[1])
	ply.UsingCamera = ent.cameras[1]

	local timerName = ent:EntIndex() .. "cameratraining"

	timer.Create(timerName, Diablos.TS.TIMER_CAMERA, 0, function()
		if not IsValid(ent) then return end

		local randomNum = math.ceil(math.Rand(0, #ent.cameras))
		local cameraToSee = ent.cameras[randomNum]
		if not IsValid(cameraToSee) then return end


		local ply = ent.activeplayer
		if not IsValid(ply) then return end
		ply:SetViewEntity(cameraToSee)
		ply.UsingCamera = cameraToSee
	end)
end

/*-------------------------------------------------------------------------
	Remove the cameras from a training entity
---------------------------------------------------------------------------*/

function Diablos.TS:RemoveCameras(ent)
	if not IsValid(ent) then return end

	local cameras = ent.cameras
	for _, camera in pairs(cameras) do
		if IsValid(camera) then
			camera:Remove()
		end
	end
	ent.cameras = nil
end

/*-------------------------------------------------------------------------
	Remove the camera update timer
---------------------------------------------------------------------------*/

function Diablos.TS:RemoveActiveCameraUpdate(ent)
	if not IsValid(ent) then return end

	local timerName = ent:EntIndex() .. "cameratraining"
	if timer.Exists(timerName) then
		timer.Remove(timerName)
	end
end

/*-------------------------------------------------------------------------
	Returns if the player is near the entity and therefore able to train
---------------------------------------------------------------------------*/

local MAX_DIST = 50000

function Diablos.TS:IsNear(ply, ent)
	if not IsValid(ply) or not IsValid(ent) then return end
	local dist = ply:GetPos():DistToSqr(ent:GetPos())
	local isNear = dist < MAX_DIST
	if not isNear then
		Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("farFromMachine"))
	end
	return isNear
end