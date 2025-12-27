AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/tptsa/reload_device/reload_device.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Wake() end

	self.owners = {}
	self.subPrice = Diablos.TS.SubDefaultPrice
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

function ENT:Use(act, ply)
	if IsValid(ply) and ply:IsPlayer() then

		-- Edit the terminal for the sport coach

		if ply:TSIsSportCoach() then
			if table.Count(self:GetOwners()) == 0 then
				ply:TSAddTerminalMachine(self)
				Diablos.TS:Notify(ply, 0, Diablos.TS:GetLanguageString("becomeOwner"))
			end

			local amountOfOwners = table.Count(self:GetOwners())
			if amountOfOwners > 0 and not self:GetOwners()[ply] then
				Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("someoneElseOwner"))
			else
				net.Start("TPTSA:CardReaderEdit")
					net.WriteEntity(self)
					net.WriteUInt(self:GetSubPrice(), 16)
					net.WriteUInt(amountOfOwners, 8)
					for owner, _ in pairs(self:GetOwners()) do
						net.WriteEntity(owner)
					end
				net.Send(ply)
			end
		else
			local activeWep = ply:GetActiveWeapon()
			if IsValid(activeWep) then
				if activeWep:GetClass() != "diablos_sport_badge" then
					Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("approachBadge"))
				end
			end
		end
	end
end

-- [[ Owner ]] --

function ENT:GetOwners()
	return self.owners
end

function ENT:AddTerminalOwner(ply)
	self.owners[ply] = true
end

function ENT:RemoveTerminalOwner(ply)
	self.owners[ply] = nil
end

function ENT:UpdateOwners(updatedOwners)
	for pl, _ in pairs(self.owners) do
		pl:TSRemoveTerminalMachine(self)
	end
	self.owners = updatedOwners
	for pl, _ in pairs(self.owners) do
		pl:TSAddTerminalMachine(self)
	end
end

function ENT:IsTerminalOwner(ply)
	return self.owners[ply]
end

-- [[ Sub price ]] --

function ENT:GetSubPrice()
	return self.subPrice
end

function ENT:SetSubPrice(price)
	if (price >= Diablos.TS.SubMinPrice or Diablos.TS.SubMinPrice == 0) and (price <= Diablos.TS.SubMaxPrice or Diablos.TS.SubMaxPrice == 0) then 
		self.subPrice = price
	end
end