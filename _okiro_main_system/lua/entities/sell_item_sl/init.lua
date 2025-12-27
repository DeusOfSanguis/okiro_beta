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
		-- Si le joueur est de l'équipe TEAM_CRISTAUX, il peut toujours ouvrir le menu
		if activator:Team() == TEAM_CRISTAUX then
			activator:ActualiseClient_SL()
			net.Start("SL:OpenSell")
			net.Send(activator)
			return
		end

		-- Vérifier si quelqu'un de l'équipe TEAM_CRISTAUX est présent
		local cristauxPresent = false

		for _, pl in ipairs(player.GetAll()) do
			if pl:Team() == TEAM_CRISTAUX then
				cristauxPresent = true
				activator:ChatPrint("Un vendeur de crystal est disponible en ville, veuillez lui vendre les crystaux à lui.")
				break
			end
		end

		-- Si quelqu'un avec TEAM_CRISTAUX est présent, on empêche les autres d'ouvrir le menu
		if cristauxPresent then
			return
		end

		-- Si personne n'est dans TEAM_CRISTAUX, on permet l'action
		activator:ActualiseClient_SL()
		net.Start("SL:OpenSell")
		net.Send(activator)
	end
end
