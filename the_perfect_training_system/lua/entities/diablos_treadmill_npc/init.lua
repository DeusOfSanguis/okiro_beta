AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetSolid( SOLID_OBB )
end

function ENT:OnRemove()

end

function ENT:FixRagdoll()
	if ( CLIENT ) then return end
	local mins = self:OBBMins()
	local maxs = self:OBBMaxs()
	mins.z = 0
	self:PhysicsInitBox( mins, maxs )
	self:SetMoveType( MOVETYPE_NONE )

	self:SetNWBool( "Ragdoll", true )
end

function ENT:Think()
	self:NextThink( CurTime() )
	return true
end