AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


function ENT:Initialize()
	self:SetModel("models/tptsa/treadmill/treadmill.mdl")

	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local floorTreadmill = ents.Create("prop_dynamic")
	if not IsValid(floorTreadmill) then return end
	floorTreadmill:SetModel("models/hunter/plates/plate1x2.mdl")
	floorTreadmill:SetSolid(SOLID_VPHYSICS)
	floorTreadmill:SetPos(self:GetPos())
	floorTreadmill:SetRenderMode(RENDERMODE_TRANSCOLOR)
	floorTreadmill:SetColor(Color(255, 255, 255, Diablos.TS.DebugDev and 255 or 0))
	floorTreadmill:SetParent(self)
	floorTreadmill:SetLocalPos(Vector(-9, 0, 4.2))
	floorTreadmill:DrawShadow(false)
	floorTreadmill:Spawn()
	floorTreadmill:Activate()
	self.floorTreadmill = floorTreadmill
	floorTreadmill.treadmill = self

	self:ResetState()
	self.cameras = Diablos.TS:CreateCameras(self, Vector(-100, -100, 100))

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Sleep() phys:EnableMotion(false) end
end

function ENT:SpawnFunction(ply, tr, classname)
	if not tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create(classname)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:ResetState()
	self:SetTrainingPlayer(nil)
	self:SetTrainingSpeed(0)

	self.speed = 0
	self.speedTime = 0
	self.isDown = false
	self.isInactive = false

	self.activeplayer = nil
	self.beginTime = 0

	// Defined by the type of exercice
	self.typeAbility = ""
	self.typeExercice = -1

	self.trainingDuration = -1
	self.speedIncrement = -1
	self.speedDecrement = -1
	self.speedDecrementTime = -1

	self.ragdoll = nil
end

function ENT:ResetCameras()
	Diablos.TS:RemoveCameras(self)
	self.cameras = Diablos.TS:CreateCameras(self, Vector(-100, -100, 100))
end

/*
	Incline the treadmill by changing the bodygroup and creating a new floortreadmill ent
*/

function ENT:UpdateAngle(newAngle)
	self:SetBodygroup(self:GetAngleBodygroup(), newAngle - 1)

	local incAngZ = 0 + 5 * (newAngle - 1)

	-- the treadmill floor pos should also change according to the bodygroup
	if IsValid(self.floorTreadmill) then
		self.floorTreadmill:SetLocalAngles(Angle(0, 90, incAngZ))
		self.floorTreadmill:SetLocalPos(Vector(-9, 0, 4.2 + newAngle * 2))

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then phys:Sleep() end
	end
end


/*
	Set the type of exercice depending on the choice of the person
*/

function ENT:SetTypeExercice(typeExercice)

	local typeTraining
	if typeExercice == 0 then -- 1: exercice based on speed
		typeTraining = "runningspeed"
	elseif typeExercice == 1 then -- 2: exercice based on stamina
		typeTraining = "stamina"
	end
	self.typeAbility = typeTraining
	self.typeExercice = Diablos.TS:GetIntegerFromTraining(typeTraining)
end

/*
	WORK FUNCTION
*/

function ENT:Work(ply)
	if not Diablos.TS:IsNear(ply, self) then return end
	if not ply:TSCanTrain(self.typeAbility) then return end
	if not ply:TSHasLevel(self.typeAbility, self:GetLevel()) then return end
	self.activeplayer = ply
	if Diablos.TS.CameraViews then
		Diablos.TS:UpdateActiveCamera(self, ply)
	end

	ply.typeTraining = self.typeAbility

	-- Set training attributes

	local trainingData
	if ply.typeTraining == "stamina" then
		trainingData = Diablos.TS.StaminaEquivalence[self:GetLevel()]
	elseif ply.typeTraining == "runningspeed" then
		trainingData = Diablos.TS.RunningSpeedEquivalence[self:GetLevel()]
	end

	if not trainingData then return end

	self.trainingDuration = trainingData.time
	self.speedIncrement = trainingData.speedIncrement
	self.speedDecrement = trainingData.speedDecrement
	self.speedDecrementTime = trainingData.speedDecrementTime


	-- Set the ragdoll

	local ragdoll = ents.Create("diablos_treadmill_npc")
	if not IsValid(ragdoll) then return end
	ragdoll:SetModel(ply:GetModel())
	ragdoll:SetSkin(ply:GetSkin())
	ragdoll:SetPos(self:LocalToWorld(Vector(10, 0, 3)))
	ragdoll:SetAngles(self:LocalToWorldAngles(Angle(0, 180, 0)))
	for key, value in pairs(ply:GetBodyGroups()) do
		ragdoll:SetBodygroup(value.id, ply:GetBodygroup(value.id))
	end
	ragdoll:SetColor(ply:GetColor())
	-- ragdoll:SetParent(self)
	ragdoll:Spawn()
	ragdoll:Activate()
	ragdoll:ResetSequence("menu_walk")

	self.ragdoll = ragdoll
	self.speed = 5

	ply:SetNoDraw(true)
	local activeWep = ply:GetActiveWeapon() if IsValid(activeWep) then activeWep:SetNoDraw(true) end
	ply:SetPos(self:LocalToWorld(Vector(10, 0, 10)))

	self.beginTime = CurTime() + Diablos.TS.TimeBeforeTraining

	ply.MusculationMachine = self
	self:UpdateNetworkSpeed()

	self:SetTrainingPlayer(ply)
	self:SetTrainingSpeed(1)

	net.Start("TPTSA:StartTraining")
		net.WriteUInt(self.typeExercice, 2)
		net.WriteUInt(self.trainingDuration, 8)
	net.Send(ply)

	hook.Run("TPTSA:Hook:StartTraining", ply, self.typeAbility)
end

/*
	END OF THE WORK FUNCTION
*/

function ENT:WorkEnd()
	local ply = self.activeplayer
	if IsValid(ply) then
		ply:SetViewEntity(ply)
		ply.UsingCamera = nil
		ply.MusculationMachine = nil
		ply.typeTraining = nil
		ply:SetNoDraw(false)
		ply:SetPos(self:GetPos() + self:GetForward() * 80)
		local activeWep = ply:GetActiveWeapon() if IsValid(activeWep) then activeWep:SetNoDraw(false) end
		self:UpdateNetworkSpeed()
		net.Start("TPTSA:StopTraining") net.WriteUInt(self.typeExercice, 2) net.Send(ply)
		hook.Run("TPTSA:Hook:StopTraining", ply, self.typeAbility)
	end

	if Diablos.TS.CameraViews then
		Diablos.TS:RemoveActiveCameraUpdate(self)
	end

	if IsValid(self.ragdoll) then self.ragdoll:Remove() end

	/*
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	*/

	self:ResetState()
end

/*
	Toggle timer
*/

function ENT:UpdateNetworkSpeed()
	local ply = self.activeplayer
	if not IsValid(ply) then return end
	local timerName = ply:SteamID64() .. "trainingUpdate"
	if timer.Exists(timerName) then
		timer.Remove(timerName)
	else
		timer.Create(timerName, 0.2, 0, function()
			net.Start("TPTSA:RefreshTraining")
				net.WriteUInt(self.typeExercice, 2)
				net.WriteUInt(self.speed * 10, 8)
			net.Send(ply)
		end)
	end
end

function ENT:Use(act, ply)
	if IsValid(ply) and ply:IsPlayer() then
		if not IsValid(self.activeplayer) then
			net.Start("TPTSA:OpenTrainingExercicePanel")
				net.WriteEntity(self)
			net.Send(ply)
		else
			if self.activeplayer == ply then
				Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("leftMachine"))
				self:WorkEnd()
			else
				Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("currentlyUsingMachine"))
			end
		end
	end
end

function ENT:Think()
	local ply = self.activeplayer
	local ragdoll = self.ragdoll
	if IsValid(ply) and IsValid(ragdoll) then
		local curtime = CurTime()

		if ply:KeyDown(Diablos.TS.StopTrainingKey) then
			Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("leftMachine"))
			self:WorkEnd()
		end

		if self.typeExercice == -1 then return end

		if self.beginTime > curtime then -- begin training
			self.speedTime = curtime
		else
			if ply:KeyDown(IN_FORWARD) then
				if not self.isDown then
					self.speed = self.speed + self.speedIncrement
					self.speedTime = curtime
					self.isDown = true
					self.isInactive = false
				end
			else
				self.isDown = false
			end

			if self.speedTime + 1 < curtime then
				self.isInactive = true
			end

			if self.speedTime + self.speedDecrementTime < curtime and self.isInactive then
				self.speed = self.speed - self.speedDecrement
				self.speedTime = curtime

				self:SetTrainingSpeed(math.ceil(self.speed * 2))
			end

			if self.speed < 0 then
				Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("needFasterTreadmill"))
				self:WorkEnd()
				return
			end
			ragdoll:SetPlaybackRate(self.speed / 10)

			local timePassed = curtime - self.beginTime
			if timePassed > self.trainingDuration then
				local xpEarn = self.speed * self.trainingDuration / 40
				-- Lower the xp earn if this is a long exercice
				if self.typeAbility == "stamina" then
					xpEarn = xpEarn / 4
				end
				ply:TSEndTraining(self.typeAbility, xpEarn)
				self:WorkEnd()
			end
		end
	end


	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	self:WorkEnd()
end