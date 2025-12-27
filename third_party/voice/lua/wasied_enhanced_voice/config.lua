EVoice.Config = {}

--[[ WARNING ]]--
--[[ This an advanced configuration. The script will work without you editing anything here. ]]--
--[[ Don't try to do anything you don't understand in the configuration file. ]]--
--[[ WARNING ]]--

-- Key used by players to change their voice mode
-- See more here: https://wiki.facepunch.com/gmod/Enums/KEY
EVoice.Config.VoiceKey = KEY_G

-- Voices modes configuration
-- You can add/remove as many modes as you want
EVoice.Config.Modes = {

	{ -- Whisper mode
		ModeName = "Chuchotement",
		ModeColor = Color(46, 204, 113),
		HearingDistance = 150
	},
	
	{ -- Normal mode
		ModeName = "Normale",
		ModeColor = Color(52, 152, 219),
		HearingDistance = 300
	},
	
	{ -- Yell mode
		ModeName = "Hurlement",
		ModeColor = Color(231, 76, 60),
		HearingDistance = 600
	},

}

-- Restricted frequencies for jobs
-- Example: Frequency 199 is restricted to Police jobs
EVoice.Config.RestrictedFrequencies = {
	[1] = {"Police Département", "S.W.A.T.", "Maire", "E.M.S." },
	[2] = {"Police Département", "S.W.A.T.", "Maire" },
	[3] = {"E.M.S.", "Maire" }
}

-- Duration of the circle animation while switching mode
EVoice.Config.AnimDuration = 3

-- Enable the circle animation for the megaphone (this can be ugly on some maps)
EVoice.Config.MegaphoneAnim = true

-- Language configuration
EVoice.Config.Language = {
	[1] = "Son",
	[2] = "Microphone",
	[3] = "Fréquence",
	[4] = "Clic molette",
	[5] = "Fréquence radio",
	[6] = "Choisir une fréquence radio",
	[7] = "Confirmer",
	[8] = "Désactiver la radio",
	[9] = "Vous êtes maintenant en mode",
	[10] = "Vous devez utiliser une fréquence entre %i et %i !",
	[11] = "Fermer le menu",
	[12] = "Vous n'avez pas accès à ces fréquences restreintes !"
}