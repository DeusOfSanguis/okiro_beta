AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/tptsa/dumbbell/dumbbell.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Sleep() phys:EnableMotion(false) end

	self.typeAbility = "strength"
	self.typeExercice = Diablos.TS:GetIntegerFromTraining(self.typeAbility)

	self:ResetState()
	self.cameras = Diablos.TS:CreateCameras(self, Vector(-80, -80, 90))
end

function ENT:SpawnFunction(ply, tr, classname)
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create(classname)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end


function ENT:ResetState()
	self.dumbbellL = nil
	self.dumbbellR = nil

	self.activeplayer = nil
	self.beginTime = 0
	self.trainingDuration = -1
	self.nbKeys = -1 -- amount of keys
	self.keyTable = {}

	self.blocklistedKey = -1 -- the "Stop Training" key can't appear as a generated key
end

function ENT:ResetCameras()
	Diablos.TS:RemoveCameras(self)
	self.cameras = Diablos.TS:CreateCameras(self, Vector(-80, -80, 90))
end

function ENT:GenerateKey()
	table.Empty(self.keyTable)
	for i = 1, self.nbKeys do
		table.insert(self.keyTable, Diablos.TS:GetRandomKey(self.blocklistedKey))
	end
end

function ENT:SetStopTrainingKey(dumbbellKey)
	self.blocklistedKey = dumbbellKey
end

function ENT:Work(ply)
	if not Diablos.TS:IsNear(ply, self) then return end
	if not ply:TSCanTrain(self.typeAbility) then return end
	if not ply:TSHasLevel(self.typeAbility, self:GetLevel()) then return end

	local trainingData = Diablos.TS.DumbbellSizeEquivalence[self:GetWeight()]
	self.nbKeys = trainingData.nbKeys
	self.trainingDuration = trainingData.time

	self.activeplayer = ply
	if Diablos.TS.CameraViews then
		Diablos.TS:UpdateActiveCamera(self, ply)
	end

	ply.TrainingMachine = self
	ply.typeTraining = self.typeAbility

	local LHandBoneNum = ply:LookupBone("ValveBiped.Bip01_L_Hand")
	local RHandBoneNum = ply:LookupBone("ValveBiped.Bip01_R_Hand")

	ply:ManipulateBoneAngles(LHandBoneNum, Angle(0, 0, 270))
	ply:ManipulateBoneAngles(RHandBoneNum, Angle(0, 0, 90))

	local LHandBone = ply:GetBonePosition(LHandBoneNum)
	local RHandBone = ply:GetBonePosition(RHandBoneNum)

	for i = 1, 2 do

		local dumbbellEnt = ents.Create("prop_dynamic")
		if not IsValid(dumbbellEnt) then return end

		local posDumbbell, boneToFollow, localPos
		if i == 1 then
			posDumbbell = LHandBone
			boneToFollow = LHandBoneNum
			localPos = Vector(5, 0, 2)
			self.dumbbellL = dumbbellEnt
		elseif i == 2 then
			posDumbbell = RHandBone
			boneToFollow = RHandBoneNum
			localPos = Vector(3, 0, -1)
			self.dumbbellR = dumbbellEnt
		end

		dumbbellEnt:SetModel(self:GetModel())
		dumbbellEnt:SetPos(posDumbbell)
		dumbbellEnt:FollowBone(ply, boneToFollow)
		dumbbellEnt:SetLocalPos(localPos)
		dumbbellEnt:SetLocalAngles(Angle(0, 0, 0))
		dumbbellEnt:SetBodygroup(self:GetWeightBodygroup(), self:GetWeight() - 1)
		dumbbellEnt:SetModelScale(0.5)
		dumbbellEnt:PhysicsInit(SOLID_NONE)
		dumbbellEnt:Spawn()
		dumbbellEnt:Activate()

	end

	self.beginTime = CurTime() + Diablos.TS.TimeBeforeTraining

	self:GenerateKey()

	ply:Give("trained_fists")
	ply:SelectWeapon("trained_fists")

	-- Send the data that the player will make an animation
	net.Start("TPTSA:UpdateAnimation")
		net.WriteEntity(ply)
		net.WriteBool(true)
	net.Broadcast()

	net.Start("TPTSA:StartTraining")
		net.WriteUInt(self.typeExercice, 2)
		net.WriteUInt(self.trainingDuration, 8)
		-- Strength information
		net.WriteUInt(self.nbKeys, 8)
		for k,v in ipairs(self.keyTable) do
			net.WriteUInt(v, 6)
		end
	net.Send(ply)
	hook.Run("TPTSA:Hook:StartTraining", ply, self.typeAbility)
end


function ENT:WorkEnd()
	local ply = self.activeplayer
	if IsValid(ply) then
		ply:SetViewEntity(ply)
		ply.UsingCamera = nil
		ply.TrainingMachine = nil
		ply.typeTraining = nil

		local LHandBoneNum = ply:LookupBone("ValveBiped.Bip01_L_Hand")
		local RHandBoneNum = ply:LookupBone("ValveBiped.Bip01_R_Hand")

		ply:ManipulateBoneAngles(LHandBoneNum, angle_zero)
		ply:ManipulateBoneAngles(RHandBoneNum, angle_zero)
		net.Start("TPTSA:StopTraining") net.WriteUInt(self.typeExercice, 2) net.Send(ply)
		hook.Run("TPTSA:Hook:StopTraining", ply, self.typeAbility)

		net.Start("TPTSA:UpdateAnimation")
			net.WriteEntity(ply)
			net.WriteBool(false)
		net.Broadcast()
	end

	if Diablos.TS.CameraViews then
		Diablos.TS:RemoveActiveCameraUpdate(self)
	end

	if IsValid(self.dumbbellL) then
		self.dumbbellL:Remove()
	end

	if IsValid(self.dumbbellR) then
		self.dumbbellR:Remove()
	end

	self:ResetState()
end


function ENT:Use(act, ply)
	if IsValid(ply) and ply:IsPlayer() then
		if not IsValid(self.activeplayer) then
			net.Start("TPTSA:OpenTrainingExercicePanel")
				net.WriteEntity(self)
			net.Send(ply)
		else
			if self.activeplayer != ply then 
				Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("currentlyUsingMachine"))
			end
		end
	end
end

function ENT:Think()
	local ply = self.activeplayer
	if IsValid(ply) then
		if ply:KeyDown(Diablos.TS.StopTrainingKey) then -- on peut pas le faire sur la touche R avec BindPress !!
			Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("leftMachine"))
			self:WorkEnd()
		end
	end
end


function ENT:OnRemove()
	self:WorkEnd()
end