AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()

    self:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
	self:PhysicsInitBox( Vector(-18,-18,0), Vector(18,18,72) )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	self:SetRenderMode(RENDERMODE_TRANSALPHA)
    self:SetColor(Color(255, 255, 255, 1))  -- Couleur transparente (alpha à 0)
end

function ENT:OnTakeDamage()
	return false
end

function ENT:Use( activator )
	if activator:IsPlayer() then
        activator:ActualiseClient_SL()

		if activator:GetNWInt("Classe") == "porteur" then
			
			activator:AddDataCrystauxSL_INV(self:GetNWInt("item"), 1)
			activator:Say("/me prend un cristal dans son sac.")

			net.Start("SL:Notification")
			net.WriteString("+1 Cristal")
			net.Send(activator)

			self:Remove()
		else
			if activator:Verif_CrystalFull() == false then

				print(self:GetNWInt("item"))

				activator:AddDataCrystauxSL_INV(self:GetNWInt("item"), 1)
				activator:Say("/me prend un cristal dans sa poche.")

				net.Start("SL:Notification")
				net.WriteString("+1 Cristal")
				net.Send(activator)

				self:Remove()
			else
				net.Start("SL:ErrorNotification")
				net.WriteString("ERREUR: Votre poche à cristaux est pleine.")
				net.Send(activator)
			end
		end

	end
end