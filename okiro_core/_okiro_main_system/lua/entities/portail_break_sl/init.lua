AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

    self:SetModel("models/hunter/blocks/cube4x4x4.mdl")

    self:SetMoveType(MOVETYPE_NONE)
    self:PhysicsInit(SOLID_NONE)
    self:SetSolid(SOLID_NONE)
    self:SetRenderMode( RENDERMODE_TRANSCOLOR ) 
    self:SetColor( Color( 0, 0, 0, 0 ) ) 

    local physObj = self:GetPhysicsObject()
    if IsValid(physObj) then
    physObj:EnableMotion(false)
    end
end

function ENT:OnTakeDamage()
	return false
end

function ENT:Use(activator)

end