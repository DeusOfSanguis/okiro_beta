ENT.Base	    			= "base_ai"
ENT.Type	    			= "ai"
ENT.PrintName				= "Portail de Retour"
ENT.Author					= "Okiro"
ENT.Category                = "Okiro - SL"
ENT.Instructions			= "Appuyez sur votre touche [USE]"
ENT.Spawnable				= true
ENT.AdminSpawnable			= true

game.AddParticles( "particles/mad_sololeveling1.pcf" )
PrecacheParticleSystem( "[1]sololeveling_portal" )

function ENT:Initialize()
	ParticleEffectAttach("[1]sololeveling_portal", 4, self, 0)
end