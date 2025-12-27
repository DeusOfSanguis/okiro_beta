-- The Ingame config system for gmodstore is no more used. I suggest not touching this file. This isn't the DEFAULT config file.
-- DEFAULT config file you need to edit is in config/ directory (training_config.lua file).

local ADDON = gmodstore:CreateAddon()

ADDON.Name = "Training System"
ADDON.ID   = "736838731494260737"
ADDON.Version = "1.0.0"
ADDON.GlobalTable = Diablos.TS

ADDON.Variables = {
	["Language"] = {
		Category = "General",
		Order = 1,
		Tip = {
			["en"] = "Addon language",
			["fr"] = "Langue de l'addon",
		},
		Default = "English",
		Elements = {"English", "French", "German", "Russian", "Turkish", "Spanish", "Dutch"},
	},

	["AdminGroups"] = {
		Category = "General",
		Order = 2,
		Tip = {
			["en"] = "Admin groups able to use the Training Manager toolgun",
			["fr"] = "Groupes administrateur capables d'utiliser le toolgun Training Manager",
		},
		Elements = "usergroups",
		Default = {"superadmin"},
		SingleRange = false,
		O1Table = true,
	},

	["Optimization"] = {
		Category = "General",
		Order = 3,
		Tip = {
			["en"] = "Value for optimization. The lower the value will be, near a training entity the player will have to be to see the draw information above ents.",
			["fr"] = "Valeur pour l'optimisation. Le plus bas cette valeur est, le plus proche d'une entité le joueur devra être pour voir les informations écrites sur les entités.",
		},
		Default = 800,
	},

	["RetroLevel"] = {
		Category = "General",
		Order = 4,
		Tip = {
			["en"] = "true = you can loose XP/level if you don't maintain your good health by training regularly",
			["fr"] = "true = vous perdez de l'XP / un niveau si vous ne maintenez pas votre bonne santé en s'entraînant régulièrement",
		},
		Default = true,
	},

	["MuscleRest"] = {
		Category = "General",
		Order = 5,
		Tip = {
			["en"] = "The amount of hours you need to wait before training again (for the same muscle). Set it to 0 if you want people to never take muscle rest.",
			["fr"] = "Le nombre d'heures vous devez attendre avant de s'entraîner de nouveau (pour un même muscle). Mettez à 0 pour ne pas définir de repos musculaire nécessaire.",
		},
		MinRange = 0,
		Default = 5,
		Cond = function() return Diablos.TS.RetroLevel == true end
	},

	["RetroTime"] = {
		Category = "General",
		Order = 6,
		Tip = {
			["en"] = "Amount of hours without any training before losing some muscle.",
			["fr"] = "Nombre d'heures sans entraînement avant de perdre du muscle.",
		},
		MinRange = 0,
		Default = 120,
		Cond = function() return Diablos.TS.RetroLevel == true end
	},

	["RoutineCheck"] = {
		Category = "General",
		Order = 7,
		Tip = {
			["en"] = "Routine trigger time interval to check if someone should lose some XP because of loss of training. You can set it to 0 if you only want one check at the startup of the server.",
			["fr"] = "Interval de temps de déclenchement de la routine vérifiant si quelqu'un doit perdre de l'XP par manque d'entraînement. Définir à 0 si vous souhaitez uniquement une vérification au lancement du serveur.",
		},
		MinRange = 0,
		Default = 2,
		Cond = function() return Diablos.TS.RetroLevel == true end
	},
	["LoseXP"] = {
		Category = "General",
		Order = 8,
		Tip = {
			["en"] = "Amount of XP you can lose for lack of training every RetroTime hour",
			["fr"] = "Nombre d'XP que l'on peut perdre par manque d'entraînement tous les RetroTime heures",
		},
		MinRange = 0,
		Default = 10,
		Cond = function() return Diablos.TS.RetroLevel == true end
	},

	["IsLbs"] = {
		Category = "General",
		Order = 9,
		Tip = "true = lbs / false = kg",
		Default = false
	},

	["IsMph"] = {
		Category = "General",
		Order = 10,
		Tip = "true = mph / false = kmh",
		Default = false
	},

	["HardestTrainingOnly"] = {
		Category = "General",
		Order = 11,
		Tip = {
			["en"] = "true = you can't train on the first easiest machines - you are only allowed to train on the hardest machine depending only your level. false = even in the last muscle level, you can train on all machines.",
			["fr"] = "true = vous ne pouvez pas vous entraîner sur les premières machines trop faciles - vous pouvez uniquement vous entraîner sur la machine la plus difficile en fonction de votre niveau. false = même sur le dernier niveau d'entraînement, vous pouvez vous entraîner sur toutes les machines.",
		},
		Default = true,
	},

	["ChangeBones"] = {
		Category = "General",
		Order = 12,
		Tip = {
			["en"] = "Are bones (for muscles) affected by your training?",
			["fr"] = "Est-ce que les os (pour les muscles) sont affectés par les entraînements ?",
		},
		Default = true,
	},

	["BoneModelBlocklist"] = {
		Category = "General",
		Order = 13,
		Tip = {
			["en"] = "List of models blocklisted for the bones. Models who don't respect some Source rules have bones with wrong positions, which can create a weird effect on playermodel!",
			["fr"] = "Liste des modèles blocklistés pour les os. Les modèles qui ne respectent pas les directives du moteur Source ont des os mal positionnés, ce qui peut créer un effet étrange sur le playermodel !",
		},
		Default = {"models/error.mdl"},
		Cond = function() return Diablos.TS.ChangeBones == true end,
		FreeWriting = true,
		O1Table = true
	},

	["SubSystem"] = {
		Category = "Subscription",
		Order = 1,
		Tip = {
			["en"] = "true = you need to subscribe using a card reader (or with a credit) to access the turnstile / false = you don't need it (everyone can access the turnstile or you don't want to use a turnstile/sport badge at all)",
			["fr"] = "true = vous devez être abonné en utilisant un lecteur de carte (ou avec un crédit) pour accéder au tourniquet / false = vous n'en avez pas besoin (tout le monde peut accéder au tourniquet ou vous ne voulez pas utiliser de tourniquet/badge)",
		},
		Default = true
	},

	--[[ If Diablos.TS.SubSystem is set to true ]] --

	["CoachJob"] = {
		Category = "Subscription",
		Order = 2,
		Tip = {
			["en"] = "Job names representing the coaches. They will be allowed to sell subs (through card readers) and give credits for people to train!",
			["fr"] = "Nom des jobs représentant les coachs. Ils seront autorisés à vendre des abonnements (via des lecteurs de carte) et à donner des crédits pour que les gens s'entraînent !",
		},
		Elements = "darkrp_jobs",
		Default = {"Coach"},
		SingleRange = false,
		Cond = function() return Diablos.TS.SubSystem == true end
	},

	["SubDefaultPrice"] = {
		Category = "Subscription",
		Order = 3,
		Tip = {
			["en"] = "The default price of a subscription",
			["fr"] = "Le prix par défaut d'un abonnement",
		},
		MinRange = 0,
		Default = 200,
		Cond = function() return Diablos.TS.SubSystem == true end
	},

	["SubMinPrice"] = {
		Category = "Subscription",
		Order = 4,
		Tip = {
			["en"] = "Subscription minimum price a coach can set to be purchased",
			["fr"] = "Prix minimum d'un abonnement qu'un coach peut définir pour être acheté",
		},
		MinRange = 0,
		Default = 50,
		Cond = function() return Diablos.TS.SubSystem == true end
	},

	["SubMaxPrice"] = {
		Category = "Subscription",
		Order = 5,
		Tip = {
			["en"] = "Subscription maximum price a coach can set to be purchased",
			["fr"] = "Prix maximum d'un abonnement qu'un coach peut définir pour être acheté",
		},
		MinRange = 0,
		Default = 500,
		Cond = function() return Diablos.TS.SubSystem == true end
	},

	["SubTime"] = {
		Category = "Subscription",
		Order = 6,
		Tip = {
			["en"] = "The amount of HOURS the subscription is valid when purchasing one",
			["fr"] = "Le nombre d'HEURES de validité de l'abonnement lorsqu'on en achète un",
		},
		MinRange = 0,
		MaxRange = 2048,
		Default = 2
	},

	["PurchaseSubWithoutCoach"] = {
		Category = "Subscription",
		Order = 7,
		Tip = {
			["en"] = "true = you can purchase a sub (at the default price) if there is no coach on the map / false = you can access to the turnstile if there is no coach on the map",
			["fr"] = "true = vous pouvez acheter un abonnement (au prix par défaut) si il n y a pas de coach sur la map / false = vous pouvez accéder au tourniquet si il n y a pas de coach sur la map",
		},
		Default = true,
		Cond = function() return Diablos.TS.SubSystem == true end
	},

	["MaximumSubTime"] = {
		Category = "Subscription",
		Order = 8,
		Tip = {
			["en"] = "The maximum amount of hours from which you're no more able to renew your sub - this value is made to avoid abuses and people who have a badge valid for years!",
			["fr"] = "Le nombre maximum d'heures à partir duquel vous ne pourrez plsu recharger votre abonnement - cette valeur permet d'éviter l'abus et les gens qui achètent un badge valide pour des années !",
		},
		MinRange = 0,
		Default = 3
	},

	["StopTrainingKey"] = {
		Category = "General",
		Order = 22,
		Tip = {
			["en"] = "The key to stop all the trainings possible - it is by default set to IN_RELOAD because the right click would cause an issue with the punching ball!",
			["fr"] = "La touche pour arrêter tous les trainings - la valeur est par défaut mise à IN_RELOAD car le clic droit poserait soucis avec le punching ball !",
		},
		Elements = "IN_ENUM",
		Default = IN_RELOAD
	},

	["TimeBeforeTraining"] = {
		Category = "General",
		Order = 23,
		Tip = {
			["en"] = "Amount of seconds a player needs to wait before the training is beginning - act as a \"3 2 1 GO\"",
			["fr"] = "Nombre de secondes un joueur doit attendre avant de commencer l'entraînement - c'est une forme de \"3 2 1 GO\"",
		},
		Default = 5
	},

	["IconLogo"] = {
		Category = "General",
		Order = 24,
		Tip = {
			["en"] = ".png/.jpg file representing a logo, used for some VGUI and the punching ball. Leave it empty to have no logo. You can put a URL by beginning with http(s), or a local file as \"diablos/test.png\" considering this file is in materials/diablos/test.png (don't include the \"materials\" folder)",
			["fr"] = "Un fichier .png/.jpg représentant un logo, utilisé pour des interfaces et pour le punching ball. Laissez vide pour ne pas avoir de logo. Vous pouvez mettre une URL en commençant par http(s), ou un fichier local comme \"diablos/test.png\" en considérant que ce fichier est dans materials/diablos/test.png (ne pas inclure le dossier \"materials\")",
		},
		Default = "https://diablosdev.com/logo/diablos.jpg"
	},

	["SQLType"] = {
		Category = "Database",
		Order = 1,
		Tip = {
			["en"] = "sqlite = stored in sv.db / mysql = mysql parameters.",
			["en"] = "sqlite = stocké dans le fichier sv.db / mysql = paramètres mysql.",
		},
		Elements = {"sqlite", "mysql"},
		Default = "sqlite"
	},

	["MySQLData"] = {
		Category = "Database",
		Order = 2,
		Tip = {
			["en"] = "MySQL data parameters",
			["fr"] = "Paramètres pour les données MySQL",
		},
		OneOccurence = true,
		Cond = function() return Diablos.TS.SQLType == "mysql" end,
		Structure = {
			["host"] = {
				Default = "diadia.mysql.db"
			},
			["username"] = {
				Default = "diablosdb"
			},
			["password"] = {
				Default = "Thepassword"
			},
			["database"] = {
				Default = "diadia.mysql.db"
			},
			["port"] = {
				Default = 3306
			},
		},
		Default = {
			{
				host = "diadia.mysql.db",
				username = "diablosdb",
				password = "Thepassword",
				database = "diadia.mysql.db",
			}
		}
	},

	["StaminaEnabled"] = {
		Category = "Stamina",
		Order = 1,
		Tip = {
			["en"] = "Enable / disable the stamina",
			["fr"] = "Activer / désactiver la stamina",
		},
		Default = true,
	},

	["StaminaLevels"] = {
		Category = "Stamina",
		Order = 2,
		Tip = {
			["en"] = "Stamina levels can be improved using a TREADMILL and doing a long exercice based on stamina. A better stamina will improve the top speed time.",
			["fr"] = "Les niveaux de Stamina peuvent être améliorés en utilisant un TAPIS DE COURSE et en faisant un exercice long basé sur la stamina. Une meilleure stamina va augmenter le temps en vitesse de pointe.",
		},
		Cond = function() return Diablos.TS.StaminaEnabled == true end,
		Structure = {
			["xp"] = {
				Default = 10,
				Tip = {
					["en"] = "The XP you need to reach that level. NOTE: The first occurence needs to have the XP value set to 0 !!",
					["fr"] = "L'XP dont vous avez besoin pour atteindre ce niveau. NOTE: La première occurence doit avoir la valeur XP à 0 !!",
				},
			},
			["timeduration"] = {
				Default = 5,
				Tip = {
					["en"] = "The timeduration value is the amount of seconds you can run at the top speed.",
					["fr"] = "La valeur timeduration représente le nombre de secondes où vous pouvez courir à la vitessse de pointe.",
				},
			},
		},

		Default = {
			{xp = 0, timeduration = 6},
			{xp = 15, timeduration = 8},
			{xp = 30, timeduration = 10},
			{xp = 50, timeduration = 12},
			{xp = 75, timeduration = 14},
			{xp = 110, timeduration = 16},
			{xp = 150, timeduration = 18},
			{xp = 200, timeduration = 20},
		},
	},

	["ShowStaminaOnRun"] = {
		Category = "Stamina",
		Order = 3,
		Tip = {
			["en"] = "true = you have a little panel showing your current stamina when running / false = you don't have it",
			["fr"] = "true = vous avez un petit panel affichant la stamina lorsque vous courez / false = pas de panel",
		},
		Cond = function() return Diablos.TS.StaminaEnabled == true end,
		Default = true
	},

	["MinimalisticPanel"] = {
		Category = "Stamina",
		Order = 4,
		Tip = {
			["en"] = "true = the panel is just a simple bar / false = the panel displays the time in top speed as well as the top speed",
			["fr"] = "true = le panel est une simpe barre / false = le panel affiche le temps en vitesse de pointe ainsi que la vitesse de pointe",
		},
		Default = false,
		Cond = function() return Diablos.TS.StaminaEnabled == true and Diablos.TS.ShowStaminaOnRun == true end
	},


	-- [[ If Diablos.TS.ShowStaminaOnRun is set to true ]] --

	["StaminaPanelPosX"] = {
		Category = "Stamina",
		Order = 5,
		Tip = {
			["en"] = "X position of the stamina panel. From 0 to 1 if you want relative to screen, otherwise it is absolute.",
			["fr"] = "Position X du panel de stamina. De 0 à 1 pour être relatif à l'écran, sinon c'est absolu.",
		},
		Default = 0.02,
		Cond = function() return Diablos.TS.StaminaEnabled == true and Diablos.TS.ShowStaminaOnRun == true end
	},
	["StaminaPanelPosY"] = {
		Category = "Stamina",
		Order = 6,
		Tip = {
			["en"] = "Y position of the stamina panel. From 0 to 1 if you want relative to screen, otherwise it is absolute.",
			["fr"] = "Position Y du panel de stamina. De 0 à 1 pour être relatif à l'écran, sinon c'est absolu.",
		},
		Default = 0.72,
		Cond = function() return Diablos.TS.StaminaEnabled == true and Diablos.TS.ShowStaminaOnRun == true end
	},


	["RunningSpeedEnabled"] = {
		Category = "RunningSpeed",
		Order = 1,
		Tip = {
			["en"] = "Enable / disable the running speed",
			["fr"] = "Activer / désactiver la vitesse de course",
		},
		Default = true,
	},

	["RunningSpeedLevels"] = {
		Category = "RunningSpeed",
		Order = 2,
		Tip = {
			["en"] = "Running speed levels can be improved using a TREADMILL and doing a quick exercice based on speed. A better speed will improve your top speed when running. It can be merged with stamina to run fast during a long time.",
			["fr"] = "Les niveaux de Vitesse de course peuvent être améliorés en utilisant un TAPIS DE COURSE et en faisant un court exercice basé sur la vitesse. Une meilleure vitesse améliorera votre vitesse de pointe. Il peut être combiné avec de la stamina pour courir vite pendant longtemps.",
		},
		Cond = function() return Diablos.TS.RunningSpeedEnabled == true end,
		Structure = {
			["xp"] = {
				Default = 10,
				Tip = {
					["en"] = "The XP you need to reach that level. NOTE: The first occurence needs to have the XP value set to 0 !!",
					["fr"] = "L'XP dont vous avez besoin pour atteindre ce niveau. NOTE: La première occurence doit avoir la valeur XP à 0 !!",
				},
			},
			["runspeed"] = {
				Default = 5,
				Tip = {
					["en"] = "The runspeed value is the runspeed added to the current runspeed of the server.",
					["fr"] = "La valeur runspeed représente la runspeed ajoutée à la runspeed actuelle du serveur.",
				},
			},
		},

		Default = {
			{xp = 0, runspeed = 5},
			{xp = 15, runspeed = 10},
			{xp = 30, runspeed = 15},
			{xp = 50, runspeed = 20},
			{xp = 75, runspeed = 25},
			{xp = 110, runspeed = 30},
			{xp = 150, runspeed = 35},
			{xp = 200, runspeed = 40},
		},
	},


	["StrengthEnabled"] = {
		Category = "Strength",
		Order = 1,
		Tip = {
			["en"] = "Enable / disable the strength",
			["fr"] = "Activer / désactiver la force",
		},
		Default = true,
	},

	["StrengthLevels"] = {
		Category = "Strength",
		Order = 2,
		Tip = {
			["en"] = "Strength levels can be improved using a DUMBBELL in a weight made for your level. A better strength allows to punch more louder using the \"Trained Fists\".",
			["fr"] = "Les niveaux de Force peuvent être améliorés en utilisant un HALTÈRE d'un poids correspondant à votre niveau. Une meilleure force permettra de taper plus fort en utilisant les \"Trained Fists\".",
		},
		Cond = function() return Diablos.TS.StrengthEnabled == true end,
		Structure = {
			["xp"] = {
				Default = 10,
				Tip = {
					["en"] = "The XP you need to reach that level. NOTE: The first occurence needs to have the XP value set to 0 !!",
					["fr"] = "L'XP dont vous avez besoin pour atteindre ce niveau. NOTE: La première occurence doit avoir la valeur XP à 0 !!",
				},
			},
			["damage"] = {
				Default = 5,
				Tip = {
					["en"] = "The damage value is the percentage of improvement (10 means it's 10% better than usually) for damage when using your \"Trained Fists\".",
					["fr"] = "La valeur damage correspond au pourcentage d'amélioration (10 signifie que c'est 10% meilleur que la normale) pour les dommages lorsque vous utilisez les \"Trained Fists\"",
				},
			},
		},

		Default = {
			{xp = 0, damage = 0},
			{xp = 20, damage = 10},
			{xp = 40, damage = 20},
			{xp = 60, damage = 30},
			{xp = 80, damage = 50},
			{xp = 100, damage = 60},
			{xp = 120, damage = 70},
			{xp = 140, damage = 80},
			{xp = 160, damage = 100},
			{xp = 180, damage = 125},
			{xp = 200, damage = 150},
		},
	},

	["DumbbellKeyBlocklist"] = {
		Category = "Strength",
		Order = 3,
		Tip = {
			["en"] = "List of keys blocklisted for the dumbbell training",
			["fr"] = "Liste des touches blocklistés pour l'entraînement des haltères",
		},
		Elements = "KEY_ENUM",
		Default = {KEY_F1, KEY_F4, KEY_0},
		Cond = function() return Diablos.TS.StrengthEnabled == true end,
		SingleRange = false
	},

	["AttackSpeedEnabled"] = {
		Category = "AttackSpeed",
		Order = 1,
		Tip = {
			["en"] = "Enable / disable the attack speed",
			["fr"] = "Activer / désactiver la vitesse d'attaque",
		},
		Default = true,
	},

	["AttackSpeedLevels"] = {
		Category = "AttackSpeed",
		Order = 2,
		Tip = {
			["en"] = "Attack speed levels can be improved using a PUNCHING BALL. A better attack speed will improve the delay when punching people using your fists.",
			["fr"] = "Les niveaux de Vitese d'attaque peuvent être améliorés en utilisant un PUNCHING BALL. Une meilleure vitesse d'attaque améliore (diminue) la durée entre chaque frappe en utilisant les \"Trained Fists\".",
		},
		Cond = function() return Diablos.TS.AttackSpeedEnabled == true end,
		Structure = {
			["xp"] = {
				Default = 10,
				Tip = {
					["en"] = "The XP you need to reach that level. NOTE: The first occurence needs to have the XP value set to 0 !!",
					["fr"] = "L'XP dont vous avez besoin pour atteindre ce niveau. NOTE: La première occurence doit avoir la valeur XP à 0 !!",
				},
			},
			["attackspeed"] = {
				Default = 5,
				Tip = {
					["en"] = "The attackspeed value is the percentage of improvement (10 means it's 10% better than usually) for the delay to punch faster when using your \"Trained Fists\".",
					["fr"] = "La valeur attackspeed correspond au pourcentage d'amélioration (10 signifie que c'est 10% meilleur que la normale) pour le délai pour frapper plus rapidement lorsque vous utilisez les \"Trained Fists\"",
				},
			},
		},

		Default = {
			{xp = 0, attackspeed = 0},
			{xp = 10, attackspeed = 10},
			{xp = 25, attackspeed = 20},
			{xp = 40, attackspeed = 25},
			{xp = 75, attackspeed = 30},
			{xp = 100, attackspeed = 35},
			{xp = 150, attackspeed = 40},
			{xp = 200, attackspeed = 45},
			{xp = 300, attackspeed = 50},
		},
	},

	["PunchingPointInstantSpawn"] = {
		Category = "AttackSpeed",
		Order = 3,
		Tip = {
			["en"] = "true = when touching a red point on a punching ball training, another point is reappearing instantly. false = the lot of points are reappearing when you have touched all the points.",
			["fr"] = "true = lorsqu'on touche un point rouge sur un entraînement de punching ball, un autre point apparaît immédiatement. false = le lot de points réapparaît lorsque vous avez touché tous les points.",
		},
		Cond = function() return Diablos.TS.AttackSpeedEnabled == true end,
		Default = true
	},

	["Blurs"] = {
		Category = "ColorScheme",
		Order = 1,
		Tip = {
			["en"] = "true = enable blur effects (around the frames NOT in them).",
			["fr"] = "true = activer les effets de flou (autour des fenêtres ET NON à l'intérieur de celles-ci).",
		},
		Default = true,
		FixedTable = ADDON.GlobalTable.Colors
	},

	["Frame"] = {
		Category = "ColorScheme",
		Order = 2,
		Tip = {
			["en"] = "Color of the frame.",
			["fr"] = "Couleur de la fenêtre.",
		},
		Default = Color(50, 50, 50, 200),
		FixedTable = ADDON.GlobalTable.Colors
	},

	["FrameLeft"] = {
		Category = "ColorScheme",
		Order = 3,
		Tip = {
			["en"] = "Color of the frame menu, the left part with buttons.",
			["fr"] = "Couleur du menu de la fenêtre, la partie gauche avec les boutons.",
		},
		Default = Color(40, 40, 40, 255),
		FixedTable = ADDON.GlobalTable.Colors
	},

	["Panel"] = {
		Category = "ColorScheme",
		Order = 4,
		Tip = {
			["en"] = "Color of the panels in the frame.",
			["fr"] = "Couleur des panels de la fenêtre.",
		},
		Default = Color(100, 100, 100, 40),
		FixedTable = ADDON.GlobalTable.Colors
	},

	["Header"] = {
		Category = "ColorScheme",
		Order = 5,
		Tip = {
			["en"] = "Color of the headers.",
			["fr"] = "Couleur des entêtes.",
		},
		Default = Color(80, 80, 140, 200),
		FixedTable = ADDON.GlobalTable.Colors
	},

	["Label"] = {
		Category = "ColorScheme",
		Order = 6,
		Tip = {
			["en"] = "Color of the labels (text in frames).",
			["fr"] = "Couleur des labels (les textes dans les fenêtres).",
		},
		Default = Color(220, 220, 220, 220),
		FixedTable = ADDON.GlobalTable.Colors
	},

	["LabelHovered"] = {
		Category = "ColorScheme",
		Order = 7,
		Tip = {
			["en"] = "For buttons - color of the labels when they are in the \"hovered\" mode (there is the mouse on a button).",
			["fr"] = "Pour les boutons - couleur des labels en mode \"hovered\" (il y a la souris sur un bouton).",
		},
		Default = Color(120, 120, 120, 220),
		FixedTable = ADDON.GlobalTable.Colors
	},

	["LabelDown"] = {
		Category = "ColorScheme",
		Order = 8,
		Tip = {
			["en"] = "For buttons - color of the labels when they are in the \"down\" mode (you press left click on a button).",
			["fr"] = "Pour les boutons - couleur des labels en mode \"down\" (vous faites clic gauche sur un bouton).",
		},
		Default = Color(0, 0, 0, 220),
		FixedTable = ADDON.GlobalTable.Colors
	},


	["FastDL"] = {
		Category = "Download",
		Order = 1,
		Tip = {
			["en"] = "true = clients install the contents via FastDL.",
			["fr"] = "true = les clients installent les contenus via FastDL.",
		},
		Default = false,
		FixedTable = ADDON.GlobalTable.Download
	},

	["Workshop"] = {
		Category = "Download",
		Order = 2,
		Tip = {
			["en"] = "true = clients install the contents via Workshop.",
			["fr"] = "true = les clients installent les contenus via Workshop.",
		},
		Default = true,
		FixedTable = ADDON.GlobalTable.Download
	},
}

ADDON.Categories = {
	["General"] = 1,
	["Database"] = 8,
	["AttackSpeed"] = 6,
	["Stamina"] = 3,
	["Strength"] = 5,
	["RunningSpeed"] = 4,
	["ColorScheme"] = 9,
	["Download"] = 7,
	["Subscription"] = 2,
}

gmodstore:AddAddon(ADDON)