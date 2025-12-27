AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

    self:SetModel("models/hunter/blocks/cube4x4x4.mdl")

    self:SetMoveType(MOVETYPE_NONE)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetRenderMode( RENDERMODE_TRANSCOLOR ) 
    self:SetColor( Color( 0, 0, 0, 0 ) ) 
    
    local physObj = self:GetPhysicsObject()
    if IsValid(physObj) then
    physObj:EnableMotion(false)
    end

    timer.Simple(MADSL_TIMER_PORTAIL, function()
        if IsValid(self) then
            self:Remove()
        end
    end)
end

function ENT:OnTakeDamage()
	return false
end

function ENT:Use( activator )
	if activator:IsPlayer() then
        activator:SetPos(Vector(activator:GetNWInt("Teleport_Pos_Return")))
	end
end