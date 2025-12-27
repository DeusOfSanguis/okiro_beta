AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube05x2x025.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetTrigger(true)

	self.turnstile = nil
	self.typeButton = ""
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
	Setters
*/

function ENT:SetTurnstile(newTurnstile)
	self.turnstile = newTurnstile
end

function ENT:SetTypeDirection(newTypeDirection)
	self.typeDirection = newTypeDirection
end

function ENT:StartTouch(ent)
	if IsValid(ent) and ent:IsPlayer() then
		if IsValid(self.turnstile) then
			if self.typeDirection == "middle" then
				-- if you reached the middle, then you can't go back behind
				self.turnstile:CloseBehind()
				self.turnstile:LaunchAnimation()
			elseif (self.typeDirection == "forward" and self.turnstile.curDirection == "backward")
			or (self.typeDirection == "backward" and self.turnstile.curDirection == "forward") then
				-- if you passed the 3 walls
				self.turnstile:SuccessfullyPassed()
			end
		end
	end
end