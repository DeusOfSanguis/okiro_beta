AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

    self:SetModel( "models/mad_models/woojinchul_pm.mdl" )
	self:PhysicsInitBox( Vector(-18,-18,0), Vector(18,18,72) )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup( COLLISION_GROUP_NPC )

end

function ENT:OnTakeDamage()
	return false
end

local cooldown = 1
local lastPress = 0

function ENT:Use( activator )
    if IsValid(activator) and activator:IsPlayer() and CurTime() - lastPress >= cooldown then
		if activator:HasWeapon("idcard") then
			net.Start("SL:ErrorNotification")
			net.WriteString("ERREUR: Vous avez déjà une carte de chasseur.")
			net.Send(activator)
			lastPress = CurTime()
		else
			activator:Give("idcard")
			RunConsoleCommand("perm_sweps_add", activator:SteamID(), "idcard")
	
			net.Start("SL:Notification")
			net.WriteString("Vous venez de recevoir votre carte de chasseur.")
			net.Send(activator)
			lastPress = CurTime()
		end
    end
end