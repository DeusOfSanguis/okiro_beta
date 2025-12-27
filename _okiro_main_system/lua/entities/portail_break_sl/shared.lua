ENT.Base	    			= "base_ai"
ENT.Type	    			= "ai"
ENT.PrintName				= "Portail"
ENT.Author					= "Okiro"
ENT.Category                = "Okiro - SL"
ENT.Instructions			= "Appuyez sur votre touche [USE]"
ENT.Spawnable				= true
ENT.AdminSpawnable			= true

game.AddParticles( "particles/mad_sololeveling3.pcf" )
PrecacheParticleSystem( "[2]sololeveling_portal" )

function ENT:Initialize()
	ParticleEffectAttach("[2]sololeveling_portal", 4, self, 0)
end