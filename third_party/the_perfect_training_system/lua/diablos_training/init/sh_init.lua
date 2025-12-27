Diablos = Diablos or {}
Diablos.TS = Diablos.TS or {}
Diablos.TS.Entities = Diablos.TS.Entities or {}
Diablos.TS.Colors = Diablos.TS.Colors or {}
Diablos.TS.Joining = Diablos.TS.Joining or {}
Diablos.TS.Languages = Diablos.TS.Languages or {}
Diablos.TS.Languages.AvailableLanguages = Diablos.TS.Languages.AvailableLanguages or {}

Diablos.TS.Data = Diablos.TS.Data or {}
Diablos.TS.Parameters = Diablos.TS.Parameters or {}
Diablos.TS.CameraViews = true
Diablos.TS.CameraViewsPos = {
	["diablos_treadmill"] = 225,
	["diablos_dumbbell"] = 45,
}


Diablos.TS.DebugSupport = false -- !!! Set it to true if Diablos told you to do so. This will throw messages in server / client consoles. You need to set it back to false once your issue is being fixed. !!!


Diablos.TS.DebugDev = false -- !!!!! For Diablos only, don't touch this line !!!!!


Diablos.TS.Download = Diablos.TS.Download or {}
Diablos.TS.Strings = Diablos.TS.Strings or {}



Diablos.TS.Colors = {
	CurLevelBox = Color(65, 65, 65, 250),
	StaminaBar = Color(100, 100, 100, 255),

	-- Red light and basic red colors
	rl = Color(200, 100, 100, 200),
	r = Color(100, 40, 40, 100),

	-- Green light and basic green colors
	gl = Color(0, 200, 0, 200),
	g = Color(40, 100, 40, 100),

	-- Blue light colors (for mouse effect when hovering/clicking)
	bl = Color(100, 100, 200, 255),
	bl2 = Color(60, 60, 220, 100),
	bl3 = Color(40, 40, 240, 100),

	regular = Color(200, 200, 100, 255),

	-- Colors to draw on the panel ontop of the dumbbells
	drawColor = Color(40, 40, 40, 250),

	-- Colors applied on the panel when you're doing a training
	barBackground = Color(100, 100, 100, 250),
	barFill = Color(200, 200, 200, 240),

	-- Colors applied when hovering/selecting a proposal in the left menu for training & admin client panels
	navbarSelection = Color(220, 140, 18),
}

Diablos.TS.Materials = {
	home =  Material("diablos/tptsa/home.png", "smooth mips"),
	humanBody = Material("diablos/tptsa/human_body.png", "smooth mips"),
	humanBodyReliefStrength = Material("diablos/tptsa/human_body_relief_strength.png", "smooth mips"),
	humanBodyReliefStamina = Material("diablos/tptsa/human_body_relief_stamina.png", "smooth mips"),
	humanBodyReliefRunningSpeed = Material("diablos/tptsa/human_body_relief_runningspeed.png", "smooth mips"),
	humanBodyReliefAttackSpeed = Material("diablos/tptsa/human_body_relief_attackspeed.png", "smooth mips"),
	sub = Material("diablos/tptsa/sub.png", "smooth mips"),
	treadmill = Material("diablos/tptsa/treadmill.png", "smooth mips"),
	treadmillOrientation = Material("diablos/tptsa/treadmill_orientation.png", "smooth mips"),
	stamina = Material("diablos/tptsa/stamina.png", "smooth mips"),
	runningSpeed = Material("diablos/tptsa/running_speed.png", "smooth mips"),
	strength = Material("diablos/tptsa/strength.png", "smooth mips"),
	attackSpeed = Material("diablos/tptsa/punching_ball.png", "smooth mips"),

	downKey = Material("diablos/tptsa/down_key.png", "smooth mips"),
	circle = Material("diablos/tptsa/circle.png", "smooth mips"),
	dumbbellBackground = Material("diablos/tptsa/dumbbell_background.png", "smooth mips"),
	close = Material("diablos/tptsa/close.png", "smooth mips"),
	checked = Material("diablos/tptsa/checked.png", "smooth mips"),

	sportbadgeRecto = Material("diablos/tptsa/sportbadge_recto.png", "smooth mips"),
	sportbadgeVerso = Material("diablos/tptsa/sportbadge_verso.png", "smooth mips"),

	zero = Material("diablos/tptsa/zero.png", "smooth mips"),
	one = Material("diablos/tptsa/one.png", "smooth mips"),
	rightArrow = Material("diablos/tptsa/right_arrow.png", "smooth"),
	price = Material("diablos/tptsa/price.png", "smooth mips"),
}


/* Sounds */

sound.Add(
	{
		name = "Diablos:Sound:TS:Correct",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "tptsa/correct.wav" -- taken at https://www.youtube.com/watch?v=KDGq81bDclE
	}
)

sound.Add(
	{
		name = "Diablos:Sound:TS:Incorrect",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = "tptsa/incorrect.wav" -- taken at https://www.youtube.com/watch?v=PdNb0r_n2mo
	}
)

/*---------------------------------------------------------------------------
	Write a message (msg) to the console, with a color depending on the type of the message (typeMsg)
---------------------------------------------------------------------------*/

function Diablos.TS:ConsoleMsg(typeMsg, msg)
	local col
	if typeMsg == 0 then
		col = Diablos.TS.Colors.gl
	elseif typeMsg == 1 then
		col = Diablos.TS.Colors.rl
	elseif typeMsg == 2 then
		col = Diablos.TS.Colors.regular
	end

	MsgC(col, "[Training System] " .. msg .. "\n")
end

/*---------------------------------------------------------------------------
	Call Diablos.TS:ConsoleMsg above if we are in debug mode
---------------------------------------------------------------------------*/

function Diablos.TS:DebugConsoleMsg(typeMsg, msg)
	if Diablos.TS.DebugSupport then
		Diablos.TS:ConsoleMsg(typeMsg, msg)
	end
end

/*---------------------------------------------------------------------------
	Set the current language used
---------------------------------------------------------------------------*/

function Diablos.TS:UpdateCurrentLanguage()
	Diablos.TS.Languages.CurrentLanguage = ""
	local languageName = Diablos.TS.Language
	languageName = string.lower(languageName)
	if not Diablos.TS.Languages.AvailableLanguages[languageName] then
		Diablos.TS:ConsoleMsg(2, "Language entered is incorrect; back to English language.")
		languageName = "english"
	end
	if languageName != Diablos.TS.Languages.CurrentLanguage then
		Diablos.TS.Strings = Diablos.TS.Languages.AvailableLanguages[languageName]
		Diablos.TS.Languages.CurrentLanguage = languageName
	end
end

/*---------------------------------------------------------------------------
	Retrieve the languages used
---------------------------------------------------------------------------*/

hook.Add("gmodstore:UpdateAddon", "TPTSA:UpdateLanguage", function(ID, variables)
	if ID == "736838731494260737" then
		Diablos.TS:UpdateCurrentLanguage()
	end
end)