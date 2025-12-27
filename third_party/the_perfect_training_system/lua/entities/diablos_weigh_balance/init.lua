AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/tptsa/weighing_machine/weighing_machine.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local television = ents.Create("diablos_weigh_television")
	if not IsValid(television) then return end
	television:SetPos(self:GetPos())
	television:SetParent(self)
	television:SetLocalPos(Vector(40, 0, 70))
	television:SetLocalAngles(Angle(0, 0, 0))
	television:Spawn()
	television:Activate()
	self.television = television
	self.television.balance = self

	self.balanceTime = 0


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

function ENT:Use(act, ply)
	if not IsValid(ply) or not ply:IsPlayer() then return end
	if not IsValid(self.television) then return end
	if ply == self.television:GetActivePlayer() then
		net.Start("TPTSA:OpenTrainingPanel")
		net.Send(ply)
	end
end

function ENT:StartTouch(ent)
	if self.balanceTime + 1 < CurTime() then
		if IsValid(ent) and ent:IsPlayer() then
			if IsValid(self.television) then
				self.television:SetActivePlayer(ent)
				self.balanceTime = CurTime()
			end
		end
	end
end

function ENT:Think()
	if not IsValid(self.television) then return end
	local activePly = self.television:GetActivePlayer()
	if not IsValid(activePly) then return end
	if self.balanceTime + 1 < CurTime() then
		local dist = activePly:GetPos():DistToSqr(self:GetPos())
		if dist > 650 then
			self.television:SetActivePlayer(nil)
		end
		self.balanceTime = CurTime()
	end
end