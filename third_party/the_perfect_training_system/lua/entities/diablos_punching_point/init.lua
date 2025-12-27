AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Wake() end

	self:SetHealth(1)

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
	self:ResetHealth()
end


function ENT:OnTakeDamage( dmginfo )
	if not IsValid(self.punchingBall) then return end
	local punchingBall = self.punchingBall
	if punchingBall.beginTime < CurTime() then
		local attacker = dmginfo:GetAttacker()
		if IsValid(attacker) and attacker == punchingBall.activeplayer then
			net.Start("TPTSA:RefreshTraining")
				net.WriteUInt(punchingBall.typeExercice, 2)
				net.WriteUInt(1, 8)
			net.Send(attacker)
			self.punchingBall:TouchedPoint(self)
		end
	end
	return 1 -- took one damage
end