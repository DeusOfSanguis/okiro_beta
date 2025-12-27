EVoice.Constants = {}

-- Configuration constants
EVoice.Constants["config"] = {

	-- Every *calculationCooldown* seconds, the addon will calculate the voice range. 
	-- Don't touch it if you don't know what you're doing.
	["calculationCooldown"] = 0.5,

	-- Radius of the circle that will be drawn around the player.
	["circleRadius"] = 15,

	-- Distance players can hear the megaphone
	["megaphoneRange"] = 1000
}

-- Colors constants
EVoice.Constants["colors"] = {
	["negativeStencil"] = Color(0, 0, 0, 0),
	["megaphoneCircle"] = Color(142, 68, 173)
}

-- Materials constants
EVoice.Constants["materials"] = {
	["rightClick"] = Material("evoice/right-click.png"),
	["leftClick"] = Material("evoice/left-click.png"),
	["frequency"] = Material("evoice/frequency.png")
}