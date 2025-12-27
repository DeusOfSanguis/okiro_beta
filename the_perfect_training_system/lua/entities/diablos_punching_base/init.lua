AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/tptsa/punching_ball/punching_ball_base.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Sleep() phys:EnableMotion(false) end

	self.punchingBall = nil
	self.ropes = {}

	self:ResetState()
	-- self.cameras = Diablos.TS:CreateCameras(self.punchingCameraEnt, Vector(-100, -100, 20))
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

	self.activeplayer = nil
	self.beginTime = 0

	if IsValid(self.punchingBall) then
		self.punchingBall:ResetHealth()
	end
end


function ENT:CreatePunchingBall()

	if IsValid(self.punchingBall) then self.punchingBall:Remove() end

	local punchingBall = ents.Create("diablos_punching_ball")
	if not IsValid(punchingBall) then return end
	punchingBall:SetModel("models/tptsa/punching_ball/punching_ball.mdl")
	punchingBall:SetSolid(SOLID_VPHYSICS)
	punchingBall:SetPos(self:GetPos() + Vector(0, 0, -55))
	punchingBall:Spawn()
	punchingBall:Activate()

	local phys = punchingBall:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableDrag(true)
		phys:EnableGravity(true)
		phys:SetDragCoefficient(500)
		phys:SetAngleDragCoefficient(1000000)
	end

	self.punchingBall = punchingBall
	punchingBall.punchingBase = self

	self:CreateRopes()

end

function ENT:CreateRopes()
	self.ropes = {}

	local valueE = 6
	local pos1 = valueE
	local pos2 = valueE
	for i = 1, 4 do
		if i == 2 then pos2 = -valueE end
		if i == 3 then pos1 = -valueE end
		if i == 4 then pos2 = valueE end
		local _, rope = constraint.Rope(self, self.punchingBall, 0, 0, Vector(0, 0, -5), Vector(pos1, pos2, 35), 0, -500, 0, 1, "models/effects/vol_light001", true, color_white)
		table.insert(self.ropes, rope)
	end

end

function ENT:SpawnFunction(ply, tr, classname)
	if !tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 32 + Vector(0, 0, 40)
	local ent = ents.Create(classname)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end


function ENT:Use(act, ply)
	if IsValid(self.punchingBall) then
		self.punchingBall:Use(act, ply)
	end
end

/*
	Get and set weight of the entity (which changes the bodygroup)
*/

function ENT:GetWeight()
	return self.weight
end


function ENT:SetWeight(newWeight)
	self.weight = newWeight
	self:CreatePunchingBall()
	if IsValid(self.punchingBall) then
		self.punchingBall:SetWeight(newWeight)
	end
end