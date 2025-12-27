AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

    self:SetModel( "models/breen.mdl" )
	self:PhysicsInitBox( Vector(-18,-18,0), Vector(18,18,72) )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

end

function ENT:OnTakeDamage()
	return false
end

function ENT:Use( activator )
	if activator:IsPlayer() then
        activator:ActualiseClient_SL()
        net.Start("SL:Mad - Coiffeur:Menu")
		net.Send(activator)
	end
end