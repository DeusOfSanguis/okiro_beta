-- Addon by Diablos
-- Configuration file

-- General Configuration

Diablos.TS.Language = "french" -- Addon language. Languages are retrieved by the name of the file in languages/ folder.

Diablos.TS.AdminGroups = { -- Admin groups able to use the Training Manager toolgun.
	["superadmin"] = true,
	["admin"] = true,
}

Diablos.TS.Optimization = 800 -- Value for optimization. The lower the value will be, near a training entity the player will have to be to see the draw information above ents.

Diablos.TS.SQLType = "sqlite" -- sqlite = stored in sv.db / mysql = mysql parameters

-- If Diablos.TS.SQLType is set to "mysql"

	Diablos.TS.MySQLData = { -- MySQL data parameters
		host = "diadia.mysql.db",
		username = "diablosdb",
		password = "Thepassword",
		database = "diadia.mysql.db",
		port = 3306,
	}

-- End of this If

-- The amount of cameras turning around treadmill/dumbbell when training
-- You can set this value to 1 if you want a fixed camera. In this case, the camera will be
-- at the back (for treadmill) and in front of the player (for the dumbbell), which are the best views 
Diablos.TS.AmountCameras = 4

-- List of jobs (with job names) not able to train.
-- Blocklisted jobs also have default bones and CAN'T have upper bones
Diablos.TS.BlocklistedJobs = {
	"Hobo"
}


Diablos.TS.ChangeBones = false -- Are bones affected by your training?

-- If Diablos.TS.ChangeBones is set to true

	-- List of models blocklisted for the bones. Models who don't respect some Source rules have bones with wrong positions, which can create a weird effect on playermodel!
	Diablos.TS.BoneModelBlocklist = {
		["models/error.mdl"] = true,
	}

-- End of this If

-- List of keys blocklisted for the dumbbell training
Diablos.TS.DumbbellKeyBlocklist = {
	KEY_0 -- 0 confusion with O
}

Diablos.TS.RetroLevel = true -- true = you can loose XP/level if you don't maintain your good health by training regularly

-- If Diablos.TS.RetroLevel is set to true

	Diablos.TS.MuscleRest = 5 -- The amount of hours you need to wait before training again (for the same muscle). Set it to 0 if you want people to never take muscle rest.

	Diablos.TS.RetroTime = 120 -- Amount of hours without any training before losing some muscle.

	Diablos.TS.RoutineCheck = 2 -- Routine trigger time interval to check if someone should lose some XP because of loss of training. You can set it to 0 if you only want one check at the startup of the server.

	Diablos.TS.LoseXP = 1 -- Amount of XP you can lose for lack of training every RetroTime hour

-- End of this If

Diablos.TS.IsLbs = false -- true = lbs / false = kg

Diablos.TS.IsMph = false -- true = mph / false = kmh

Diablos.TS.HardestTrainingOnly = true -- true = you can't train on the first easiest machines - you are only allowed to train on the hardest machine depending only your level. false = even in the last muscle level, you can train on all machines.

Diablos.TS.PunchingPointInstantSpawn = true -- true = when touching a red point on a punching ball training, another point is reappearing instantly. false = the lot of points are reappearing when you have touched all the points.

-- .png/.jpg file representing a logo, used for some VGUI and the punching ball. Leave it empty to have no logo.
-- You can put a URL by beginning with http(s), or a local file as "diablos/test.png" considering this file is in materials/diablos/test.png (don't include the "materials" folder)
Diablos.TS.IconLogo = "https://diablosdev.com/logo/diablos.jpg"

Diablos.TS.SubSystem = true -- true = you need to subscribe using a card reader (or with a credit) to access the turnstile / false = you don't need it (everyone can access the turnstile or you don't want to use a turnstile/sport badge at all)

-- If Diablos.TS.SubSystem is set to true

	Diablos.TS.CoachJob = "Coach" -- Job names representing the coaches. They will be allowed to sell subs (through card readers) and give credits for people to train! Can be a string or a table!

	Diablos.TS.SubDefaultPrice = 25000 -- Default price if you are allowed to and you can purchase a sub

	Diablos.TS.SubMinPrice = 25000 -- Subscription minimum price a coach can set to be purchased

	Diablos.TS.SubMaxPrice = 50000 -- Subscription maximum price a coach can set to be purchased

	Diablos.TS.SubTime = 2 -- The amount of HOURS the subscription is valid when purchasing one

	Diablos.TS.PurchaseSubWithoutCoach = true -- true = you can purchase a sub (at the default price) if there is no coach on the map / false = you can access to the turnstile if there is no coach on the map

	Diablos.TS.MaximumSubTime = 3 -- The maximum amount of hours from which you're no more able to renew your sub - this value is made to avoid abuses and people who have a badge valid for years!

	-- If you are using Pointshop2 currency system!

	Diablos.TS.PointshopPremium = false -- False: using "Points" system / true = using "Premium Points" system

-- End of this If

Diablos.TS.StopTrainingKey = IN_RELOAD -- The key to stop all the trainings possible - it is by default set to IN_RELOAD because the right click would cause an issue with the punching ball!

Diablos.TS.TimeBeforeTraining = 5 -- Amount of seconds a player needs to wait before the training is beginning - act as a "3 2 1 GO"

Diablos.TS.StaminaEnabled = false -- Enable / disable the stamina

-- If Diablos.TS.StaminaEnabled is set to true

	/*
		STAMINA LEVELS
		Stamina levels can be improved using a TREADMILL and doing a long exercice based on stamina. A better stamina will improve the top speed time.
		xp: The XP you need to reach that level. NOTE: The first occurence needs to have the XP value set to 0 !!
		timeduration: The timeduration value is the amount of seconds you can run at the top speed.
	*/

	Diablos.TS.StaminaLevels = {
		{xp = 0, timeduration = 6},
		{xp = 15, timeduration = 8},
		{xp = 30, timeduration = 10},
		{xp = 50, timeduration = 12},
		{xp = 75, timeduration = 14},
		{xp = 110, timeduration = 16},
		{xp = 150, timeduration = 18},
		{xp = 200, timeduration = 20},
	}

	-- You can specify specific values for different jobs. Here, the Civil Protection job has a better stamina.
	-- The amount of entries should be the same than the amount of entries in the StaminaLevels table above.
	Diablos.TS.StaminaJobAbilities = {
		["Civil Protection"] = {
			{timeduration = 15},
			{timeduration = 20},
			{timeduration = 25},
			{timeduration = 30},
			{timeduration = 35},
			{timeduration = 40},
			{timeduration = 45},
			{timeduration = 50},
		}
	}

	Diablos.TS.ShowStaminaOnRun = false -- true = you have a little panel showing your current stamina when running / false = you don't have it

	-- If Diablos.TS.ShowStaminaOnRun is set to true

		Diablos.TS.StaminaPanelPosX = 0.02 -- X position of the stamina panel. From 0 to 1 if you want relative to screen, otherwise it is absolute.

		Diablos.TS.StaminaPanelPosY = 0.72 -- Y position of the stamina panel. From 0 to 1 if you want relative to screen, otherwise it is absolute.

	-- End of this If

	Diablos.TS.MinimalisticPanel = false -- true = the panel is just a simple bar / false = the panel displays the time in top speed as well as the top speed

	-- If Diablos.TS.MinimalisticPanel is set to true

		Diablos.TS.MinimalisticBarX = 200 -- X size of the minimalistic stamina bar (200 is the X size for a 1920x1080 screen but it is relative anyway).

		Diablos.TS.MinimalisticBarY = 40 -- Y size of the minimalistic stamina bar (200 is the X size for a 1920x1080 screen but it is relative anyway).

	-- End of this If

-- End of this If

Diablos.TS.RunningSpeedEnabled = true -- Enable / disable the running speed

-- If Diablos.TS.RunningSpeedEnabled is set to true

	/*
		RUNNING SPEED LEVELS
		Running speed levels can be improved using a TREADMILL and doing a quick exercice based on speed. A better speed will improve your top speed when running. It can be merged with stamina to run fast during a long time.
		xp: The XP you need to reach that level. NOTE: The first occurence needs to have the XP value set to 0 !!
		runspeed: The runspeed value is the runspeed added to the current runspeed of the server.
	*/

	Diablos.TS.RunningSpeedLevels = {
		{xp = 0, runspeed = 5},
		{xp = 15, runspeed = 10},
		{xp = 35, runspeed = 15},
		{xp = 50, runspeed = 20},
		{xp = 65, runspeed = 25},
		{xp = 75, runspeed = 30},
		{xp = 90, runspeed = 35},
		{xp = 120, runspeed = 40},
	}

	-- You can specify specific values for different jobs. Here, the Civil Protection job has a better runspeed.
	-- The amount of entries should be the same than the amount of entries in the RunningSpeedLevels table above.
	Diablos.TS.RunningSpeedJobAbilities = {
		["Civil Protection"] = {
			{runspeed = 50},
			{runspeed = 60},
			{runspeed = 70},
			{runspeed = 80},
			{runspeed = 90},
			{runspeed = 100},
			{runspeed = 110},
			{runspeed = 125},
		}
	}

-- End of this If

Diablos.TS.StrengthEnabled = true -- Enable / disable the strength

-- If Diablos.TS.StrengthEnabled is set to true

	/*
		STRENGTH LEVELS
		Strength levels can be improved using a DUMBBELL in a weight made for your level. A better strength allows to punch more louder using the "Trained Fists".
		xp: The XP you need to reach that level. NOTE: The first occurence needs to have the XP value set to 0 !!
		damage: The damage value is the percentage of improvement (10 means it's 10% better than usually) for damage when using your "Trained Fists".
	*/

	Diablos.TS.StrengthLevels = {
		{xp = 0, damage = 0},
		{xp = 15, damage = 15},
		{xp = 30, damage = 30},
		{xp = 50, damage = 50},
		{xp = 75, damage = 70},
		{xp = 110, damage = 100},
		{xp = 150, damage = 125},
		{xp = 200, damage = 150},
	}

	-- You can specify specific values for different jobs. Here, the Civil Protection job has a better strength.
	-- The amount of entries should be the same than the amount of entries in the StrengthLevels table above.
	Diablos.TS.StrengthJobAbilities = {
		["Civil Protection"] = {
			{damage = 50},
			{damage = 75},
			{damage = 100},
			{damage = 125},
			{damage = 150},
			{damage = 175},
			{damage = 200},
			{damage = 250},
		}
	}

-- End of this If

Diablos.TS.AttackSpeedEnabled = true -- Enable / disable the attack speed

-- If Diablos.TS.AttackSpeedEnabled is set to true

	/*
		ATTACK SPEED LEVELS
		Attack speed levels can be improved using a PUNCHING BALL. A better attack speed will improve the delay when punching people using your fists.
		xp: The XP you need to reach that level. NOTE: The first occurence needs to have the XP value set to 0 !!
		attackspeed: The attackspeed value is the percentage of improvement (10 means it's 10% better than usually) for the delay to punch faster when using your "Trained Fists".
	*/

	Diablos.TS.AttackSpeedLevels = {
		{xp = 0, attackspeed = 0},
		{xp = 15, attackspeed = 15},
		{xp = 30, attackspeed = 30},
		{xp = 50, attackspeed = 50},
		{xp = 75, attackspeed = 75},
		{xp = 110, attackspeed = 100},
		{xp = 150, attackspeed = 125},
		{xp = 200, attackspeed = 150},
	}

	-- You can specify specific values for different jobs. Here, the Civil Protection job has a better attackspeed.
	-- The amount of entries should be the same than the amount of entries in the AttackSpeedLevels table above.
	Diablos.TS.AttackSpeedJobAbilities = {
		["Civil Protection"] = {
			{attackspeed = 50},
			{attackspeed = 75},
			{attackspeed = 100},
			{attackspeed = 125},
			{attackspeed = 150},
			{attackspeed = 175},
			{attackspeed = 200},
			{attackspeed = 250},
		}
	}

-- End of this If

-- Color Theme Configuration

Diablos.TS.Colors.Blurs = true -- true = enable blur effects (around the frames NOT in them).

Diablos.TS.Colors.Frame = Color(50, 50, 50, 230) -- Color of the frame.

Diablos.TS.Colors.FrameLeft = Color(40, 40, 40, 255) -- Color of the frame menu, the left part with buttons.

Diablos.TS.Colors.Panel = Color(100, 100, 100, 40) -- Color of the panels in the frame.

Diablos.TS.Colors.Header = Color(80, 80, 140, 200) -- Color of the headers.

Diablos.TS.Colors.Label = Color(220, 220, 220, 220) -- Color of the labels (text in frames).

Diablos.TS.Colors.LabelHovered = Color(120, 120, 120, 220) -- For buttons - color of the labels when they are in the \"hovered\" mode (there is the mouse on a button).

Diablos.TS.Colors.LabelDown = Color(0, 0, 0, 220) -- For buttons - color of the labels when they are in the \"down\" mode (you press left click on a button).

-- Content Download Configuration

Diablos.TS.Download.FastDL = false -- true = clients install the contents via FastDL.

Diablos.TS.Download.Workshop = true -- true = clients install the contents via Workshop.

-- End of the configuration file


/*
-- You can add the card reader to buy to the sport coach (this job needs to be created!) by taking the lines below and putting them onto your DarkRP entities.lua:
-- Card reader
DarkRP.createEntity("Training Card Reader", {
ent = "diablos_card_reader",
model = "models/tptsa/training_card_reader/training_card_reader.mdl",
price = 100,
max = 3,
cmd = "buytrainingcardreader",
allowed = {TEAM_SPORTCOACH}
})
*/

Diablos.TS:UpdateCurrentLanguage()