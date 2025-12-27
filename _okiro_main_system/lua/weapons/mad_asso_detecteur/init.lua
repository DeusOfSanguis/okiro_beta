AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local timer_Simple = timer.Simple
local ents_FindInSphere = ents.FindInSphere

local cooldown = {}

function SWEP:OnDrop()
    self:Remove() -- You can't drop fists
end

function SWEP:PrimaryAttack()
if not self:IsValid() then return end
local ply = self:GetOwner()

local pos = ply:GetShootPos()
local aim = ply:GetAimVector()
local vector = 150 + 50
local radius = 50 + 20

local slash = {}
slash.start = self:GetOwner():GetShootPos()
slash.endpos = self:GetOwner():GetShootPos() + (self:GetOwner():GetAimVector() * vector)
slash.filter = self:GetOwner()
slash.mins = Vector(-radius, -radius, 0)
slash.maxs = Vector(radius, radius, 0)
local tr = util.TraceHull(slash)
	
if tr.Hit then
	if IsValid(tr.Entity) then

		local portail = tr.Entity
		
		if tr.Entity:GetClass() == "portail_sl" then
			ply:ChatPrint("Le rang du portail est : ".. portail.rangportail)
		end

	end
end

self:SetNextPrimaryFire( CurTime() + 1 )
end

function SWEP:SecondaryAttack()
	if not self:IsValid() then return end
	local ply = self:GetOwner()
	
	local pos = ply:GetShootPos()
	local aim = ply:GetAimVector()
	local vector = 150 + 50
	local radius = 50 + 20
	
	local slash = {}
	slash.start = self:GetOwner():GetShootPos()
	slash.endpos = self:GetOwner():GetShootPos() + (self:GetOwner():GetAimVector() * vector)
	slash.filter = self:GetOwner()
	slash.mins = Vector(-radius, -radius, 0)
	slash.maxs = Vector(radius, radius, 0)
	local tr = util.TraceHull(slash)
		
	if tr.Hit then
		if IsValid(tr.Entity) then
	
			local portail = tr.Entity
			
			if tr.Entity:GetClass() == "portail_sl" and portail.ouvert == false then
				ply:ChatPrint("Le portail est désormais ouvert.")
				portail.ouvert = true

				local cfg=nordahl_cfg_3905
				local log_t = {
					ct = "ini",
					webhook = cfg.portailurl
				}
			
				cfg.SD(log_t, ply:Nick() .. " [".. ply:SteamID64().."]".. " a ouvert un portail via le detecteur")    
			elseif tr.Entity:GetClass() == "portail_sl" and portail.ouvert == true then
				ply:ChatPrint("Le portail est désormais fermé.")
				portail.ouvert = false

				local cfg=nordahl_cfg_3905
				local log_t = {
					ct = "ini",
					webhook = cfg.portailurl
				}
			
				cfg.SD(log_t, ply:Nick() .. " [".. ply:SteamID64().."]".. " a fermer un portail via le detecteur")    
			end
	
		end
	end
	
	self:SetNextSecondaryFire( CurTime() + 5 )
	end

	function SWEP:Reload()
		local ply = self:GetOwner()
		if cooldown[ply] and cooldown[ply] > CurTime() then
			ply:ChatPrint("Veuillez attendre encore " .. math.ceil(cooldown[ply] - CurTime()) .. " secondes.")
			return
		end
	
		cooldown[ply] = CurTime() + 5
	
		net.Start("ASSO:OpenMenu")
		net.Send(ply)
	end