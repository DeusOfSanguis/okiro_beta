--  _______               __          _______  __                   __          _______  ______  ______        
-- |   |   |.---.-..----.|  |.-----. |     __||__|.--------..-----.|  |.-----. |    |  ||   __ \|      |.-----.
-- |       ||  _  ||  __| |_||__ --| |__     ||  ||        ||  _  ||  ||  -__| |       ||    __/|   ---||__ --|
-- |__|_|__||___._||____|    |_____| |_______||__||__|__|__||   __||__||_____| |__|____||___|   |______||_____|
--                                                          |__|      
-- Template moved to the documentation

MCS.Spawns["metro"] = {
	name = "Huju Mijanda",
	model = "models/player/dewobedil/persona/police/default_p.mdl",
	namepos = 80,
	theme = "Default",
	pos = {
		["rp_animeworld_v2"] = { Vector(-10153.764648438,-2949.9328613281,92.03125 ), Angle(0,91.819969177246,0 )},
	},
	sequence = "pose_standing_02",
	uselimit = false,
	skin = 1,
	bgr = {[2] = 1,[3] = 1,[4] = 1,[5] = 1,[6] = 1,[7] = 1,},
	dialogs = {
		[1] = {
			["Line"] = "Bonsoir, bienvenue a Kyoto ! Faite attention a vous si vous trainez vers les  Appartements !",
			["Sound"] = "",
			["Answers"] = {
				{"D'accord merci !", "close",},
				{"Que c'est t-il passez ?", 2,},
			},
		},
		[2] = {
			["Line"] = "Il y a eu un meurtre, les cause sont toujours innexpliquer, et nous ne pouvons en dire plus.",
			["Sound"] = "",
			["Answers"] = {
				{"D'accord merci !", "close",},
				{"Je vais eviter cette endroit.", "close",},
			},
		},
	}
}

MCS.Spawns["journal1"] = {
	name = "Journal *2016*",
	model = "models/props_junk/garbage_newspaper001a.mdl",
	namepos = 30,
	theme = "Hollow Knight",
	pos = {
		["rp_animeworld_v2"] = { Vector(-9814.439453125,-2581.0390625,163.14172363281 ), Angle(0,-89.460037231445,0 )},
	},
	sequence = "pose_standing_02",
	uselimit = false,
	skin = 1,
	bgr = {},
	dialogs = {
		[1] = {
			["Line"] = "News 1 : Un vieux fou accuse Mr,Speedwagon d'etre un Monstre venu d'une autre planete !",
			["Sound"] = "",
			["Answers"] = {
				{"Laisser le Journal.", "close",},
				{"Tournez la page", 2,},
			},
		},
		[2] = {
			["Line"] = "News 2 : Un tombeaux a ete retrouver dans les egouts, aucun specialiste n'ose s'en approcher dut a l'odeur.",
			["Sound"] = "",
			["Answers"] = {
				{"Laisser le Journal.", "close",},
				{"Tournez la page.", 3,},
			},
		},
		[3] = {
			["Line"] = "News 3 : Un convoie qui transportais de vieille antiquite a été attaquer, un masque aurais été voler.",
			["Sound"] = "",
			["Answers"] = {
				{"Laisser le Journal.", "close",},
			},
		},
	}
}

MCS.Spawns["monoko"] = {
	name = "Adam Smith",
	model = "models/weaman01/weaman01_pm.mdl",
	namepos = 82,
	theme = "Default",
	pos = {
		["rp_animeworld_v2"] = { Vector(-8940.9599609375,-2035.1480712891,84.03125 ), Angle(0,-90.339981079102,0 )},
	},
	sequence = "menu_combine",
	uselimit = false,
	skin = 1,
	bgr = {},
	dialogs = {
		[1] = {
			["Line"] = "Hi, pardon, bonjours, vous êtes l/homme que l/agence envoie ? Je suis vraiment maladroit pardonner moi.",
			["Sound"] = "",
			["Answers"] = {
				{"Oui exacte,emt, venez", "close",},
				{"Vous voulez que je vous montre la ville ?", 2,},
			},
		},
		[2] = {
			["Line"] = "Non thank you, je cherche surtout a voir le Directeur merci encore.",
			["Sound"] = "",
			["Answers"] = {
				{"D'accord venez !", "close",},
			},
		},
	}
}

MCS.Spawns["psiclor"] = {
	name = "Psiclor",
	model = "models/player/pes/pesci_pm/pesci_pm.mdl",
	namepos = 82,
	theme = "Default",
	pos = {
		["rp_animeworld_v2"] = { Vector(-1031.4096679688,-1567.7431640625,84.031356811523 ), Angle(0,173.69000244141,0 )},
	},
	sequence = "menu_combine",
	uselimit = false,
	skin = 1,
	bgr = {},
	dialogs = {
		[1] = {
			["Line"] = "Hé ! Tes un nouveaux toi ? Bienvenue dans le Desert. Si tes ici c'est soit que tes perdu, soit que tu cherche a faire de l'argent ?",
			["Sound"] = "",
			["Answers"] = {
				{"C'est pour une autre cause.. aurevoir.", "close",},
				{"Je veut faire de l'argent effectivement !", 2,},
			},
		},
		[2] = {
			["Line"] = "Ah ! Le meilleur business de notre fabuleux desert... Bah c'est la pierre. Devenez mineur sinon je voit pas comment vous pourriez devenir riche.",
			["Sound"] = "",
			["Answers"] = {
				{"D'accord merci !", "close",},
				{"Si je dois avoir la meme tete que toi pour devenir mineur...", "close",},
			},
		},
	}
}
