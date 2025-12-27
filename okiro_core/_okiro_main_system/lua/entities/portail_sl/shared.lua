ENT.Base	    			= "base_ai"
ENT.Type	    			= "ai"
ENT.PrintName				= "Portail"
ENT.Author					= "Okiro"
ENT.Category                = "Okiro - SL"
ENT.Instructions			= "Appuyez sur votre touche [USE]"
ENT.Spawnable				= true
ENT.AdminSpawnable			= true

game.AddParticles( "particles/mad_sololeveling1.pcf" )
PrecacheParticleSystem( "[1]sololeveling_portal" )
game.AddParticles( "particles/mad_sololeveling3.pcf" )
PrecacheParticleSystem( "[2]sololeveling_portal" )

function ENT:Initialize()
	timer.Simple(0.5, function()
		if self:GetNWInt("Rang") == "S" then
			ParticleEffectAttach("[2]sololeveling_portal", 4, self, 0)
		else
			ParticleEffectAttach("[1]sololeveling_portal", 4, self, 0)
		end
	end)
end