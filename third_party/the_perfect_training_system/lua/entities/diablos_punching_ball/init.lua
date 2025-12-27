AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/tptsa/punching_ball/punching_ball.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Wake() end

	self:SetBodygroup(self:GetChainBodygroup(), 1) -- enable chain

	local img = 1
	if Diablos.TS.IconLogo == "" then
		img = 0
	end
	self:SetBodygroup(self:GetImageBodygroup(), img)

	self.typeAbility = "attackspeed"
	self.typeExercice = Diablos.TS:GetIntegerFromTraining(self.typeAbility)

	self.punchingBase = nil
	self.punchingPoints = {}

	self.amountPointsTouched = 0

	self:ResetState()
	-- No cameras for the punching ball
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


/*
	Vectors are specific positions of a "quarter" of a punching ball
	For the other quarters, we just need to minus the x or y value of the vector
	The height doesn't matter, as it will be generated randomly
	This is not a math calculation because this isn't a perfect cylinder
	It remains symmetrical from the center, though
*/

local vectors = {
	Vector(12, 0, 0),
	Vector(11, 4, 0),
	Vector(10, 6.5, 0),
	Vector(9, 7.5, 0),
	Vector(8, 8.5, 0),
	Vector(7, 9.2, 0),
	Vector(6, 9.7, 0),
	Vector(5, 10.2, 0),
	Vector(4, 10.7, 0),
	Vector(3, 11.2, 0),
	Vector(2, 11.5, 0),
	Vector(1, 11.7, 0),
	Vector(0, 12, 0),
}

function ENT:RandomizePunchingPoint(punchingPoint)
	local rand = {
		x = math.random(1, 2), -- x value = - x value if x is set to 2
		y = math.random(1, 2), -- y value = - y value if y is set to 2
		z = math.Rand(-1, 0.5), -- random height can be from -1 to 1 * a specific height
	}

	-- Choose a random pos for the punching point
	local randomNumber = math.random(1, #vectors)
	local randomVec = vectors[randomNumber]

	if rand.x == 2 then
		randomVec.x = - randomVec.x
	end
	if rand.y == 2 then
		randomVec.y = - randomVec.y
	end

	-- Random height
	randomVec.z = rand.z * 25

	punchingPoint:SetPos(self:GetPos() + randomVec)
end

/*
	Create amountPunchingPoint punching points
	A punching point is here to indicate where you should hit the punching ball to earn points
*/

function ENT:CreatePunchingPoints(amountPunchingPoint)
	for i = 1, amountPunchingPoint do
		local punchingPoint = ents.Create("diablos_punching_point")
		if not IsValid(punchingPoint) then return end
		punchingPoint:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		punchingPoint:SetSolid(SOLID_VPHYSICS)
		punchingPoint:SetColor(Color(255, 0, 0))
		punchingPoint:SetParent(self)
		punchingPoint:SetModelScale(0.1)
		-- punchingPoint:SetPos(self:GetPos() + vectors[i]) -- To place them manually
		self:RandomizePunchingPoint(punchingPoint)
		punchingPoint:Spawn()
		punchingPoint:Activate()

		self.punchingPoints[punchingPoint] = true
		punchingPoint.punchingBall = self
	end
end

function ENT:TouchedPoint(point)
	self.punchingPoints[point] = nil
	self.amountPointsTouched = self.amountPointsTouched + 1
	point:Remove()
	if Diablos.TS.PunchingPointInstantSpawn then
		self:CreatePunchingPoints(1)
	end
	if not Diablos.TS.PunchingPointInstantSpawn and table.IsEmpty(self.punchingPoints) then
		self:CreatePunchingPoints(self.nbPoints)
	end
end

function ENT:ResetState()

	self.activeplayer = nil
	self.beginTime = 0
	self.amountPointsTouched = 0

	for punchingPoint, _ in pairs(self.punchingPoints) do
		if IsValid(punchingPoint) then punchingPoint:Remove() end
	end
	table.Empty(self.punchingPoints)

end


function ENT:Work(ply)
	if not Diablos.TS:IsNear(ply, self) then return end
	if not ply:TSCanTrain(self.typeAbility) then return end
	if not ply:TSHasLevel(self.typeAbility, self:GetLevel()) then return end

	local trainingData = Diablos.TS.PunchingBallSizeEquivalence[self:GetWeight()]
	self.nbPoints = trainingData.nbPoints
	self.trainingDuration = trainingData.time

	table.Empty(self.punchingPoints)
	self:CreatePunchingPoints(self.nbPoints)

	self.activeplayer = ply

	self.beginTime = CurTime() + Diablos.TS.TimeBeforeTraining

	ply.TrainingMachine = self
	ply.typeTraining = self.typeAbility

	ply:Give("trained_fists")
	ply:SelectWeapon("trained_fists")

	net.Start("TPTSA:StartTraining")
		net.WriteUInt(self.typeExercice, 2)
		net.WriteUInt(self.trainingDuration, 8)
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
		ply:SetNoDraw(false)
		local activeWep = ply:GetActiveWeapon() if IsValid(activeWep) then activeWep:SetNoDraw(false) end
		net.Start("TPTSA:StopTraining") net.WriteUInt(self.typeExercice, 2) net.Send(ply)
		hook.Run("TPTSA:Hook:StopTraining", ply, self.typeAbility)
	end

	self.activeplayer = nil

	self:ResetState()
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
	if IsValid(ply) then
		local curtime = CurTime()

		if ply:KeyDown(Diablos.TS.StopTrainingKey) then
			Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("leftMachine"))
			self:WorkEnd()
		end

		if self.activeplayer == nil then return end

		local timePassed = curtime - self.beginTime
		if timePassed > self.trainingDuration then
			local amountOfPoints = self.amountPointsTouched
			local xpEarn = amountOfPoints * 0.7
			ply:TSEndTraining(self.typeAbility, xpEarn)
			self:WorkEnd()
		end
	end
end

function ENT:OnRemove()
	self:WorkEnd()
end