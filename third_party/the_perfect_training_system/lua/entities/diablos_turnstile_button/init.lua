AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

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

function ENT:SetTypeButton(newTypeButton)
	self.typeButton = newTypeButton
end


function ENT:AccessForward(ply)
	if IsValid(self.turnstile) then
		self.turnstile:Access(ply, "forward")
	end
end

function ENT:AccessBackward(ply)
	if IsValid(self.turnstile) then
		self.turnstile:Access(ply, "backward")
	end
end

function ENT:NFCError()
	if IsValid(self.turnstile) then
		self.turnstile:NFCError()
	end
end

function ENT:Use(act, ply)
	if IsValid(ply) and ply:IsPlayer() then
		if self.typeButton == "forward" then
			if Diablos.TS.SubSystem then
				Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("turnstileNeedBadge"))
			else
				self:AccessForward(ply)
			end

		elseif self.typeButton == "backward" then
			self:AccessBackward(ply)
		end
	end
end