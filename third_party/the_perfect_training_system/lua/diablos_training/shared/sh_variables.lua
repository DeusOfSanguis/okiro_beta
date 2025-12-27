/*---------------------------------------------------------------------------
	List of the trainings which are changing bones
	They are the trainings which induct bigger bones, and therefore more data to network

	Currently, all the trainings are changing bones!
---------------------------------------------------------------------------*/

Diablos.TS.TrainingsChangingBone = {
	"strength", 
	"stamina",
	"runningspeed",
	"attackspeed",
}

/*---------------------------------------------------------------------------
	Key = class name / Value = Nice Name
	Used for the toolgun when creating an entity
---------------------------------------------------------------------------*/
Diablos.TS.NiceNames = {
	["diablos_card_reader"] = "Card Reader",
	["diablos_dumbbell"] = "Dumbbell",
	["diablos_punching_ball"] = "Punching Ball",
	["diablos_punching_base"] = "Punching Ball", -- we still consider the punching base as the punching ball
	["diablos_treadmill"] = "Treadmill",
	["diablos_turnstile"] = "Turnstile",
	["diablos_weigh_balance"] = "Weigh Balance & Television",
}

/*---------------------------------------------------------------------------
	/!\ Equivalence variables
	These variables are here as they are level values for every training
	Each training has an equivalence table, with the amount of occurences being the amount of bodygroups for the entity for the training
	Treadmill = Stamina & Running Speed - 4 bodygroups
	Dumbbell - Strength - 7 bodygroups
	Punching ball - Attack Speed - 4 bodygroups
---------------------------------------------------------------------------*/


// Time = training time
// Speed increment = the speed 'incremented' when pressing the key
// Speed decrement = the speed 'decremented' if you don't do anything
// Speed decrement time = amount of seconds before we decrement the speed of the speedDecrement value 
Diablos.TS.StaminaEquivalence = {
	{time = 120, speedIncrement = 0.02, speedDecrement = 0.1, speedDecrementTime = 2},
	{time = 140, speedIncrement = 0.015, speedDecrement = 0.12, speedDecrementTime = 1.5},
	{time = 160, speedIncrement = 0.01, speedDecrement = 0.14, speedDecrementTime = 1},
	{time = 180, speedIncrement = 0.005, speedDecrement = 0.16, speedDecrementTime = 0.75},
}

// Time = training time
// Speed increment = the speed 'incremented' when pressing the key
// Speed decrement = the speed 'decremented' if you don't do anything
// Speed decrement time = amount of seconds before we decrement the speed of the speedDecrement value 
Diablos.TS.RunningSpeedEquivalence = {
	{time = 30, speedIncrement = 0.075, speedDecrement = 0.3, speedDecrementTime = 0.5},
	{time = 45, speedIncrement = 0.055, speedDecrement = 0.35, speedDecrementTime = 0.45},
	{time = 60, speedIncrement = 0.035, speedDecrement = 0.4, speedDecrementTime = 0.4},
	{time = 90, speedIncrement = 0.02, speedDecrement = 0.5, speedDecrementTime = 0.3},
}

// Angle = the angle in degrees for each bodygroup (for the treadmill)
Diablos.TS.TreadmillSizeEquivalence = {
	{angle = 0},
	{angle = 5},
	{angle = 10},
	{angle = 15},
}

// kg = the weight in kg
// lbs = the weight in lbs
// nbKeys = the amount of keys you'll have for the training
// time = training time
Diablos.TS.DumbbellSizeEquivalence = {
	{kg = 3, lbs = 6.6, nbKeys = 15, time = 30},
	{kg = 5, lbs = 11, nbKeys = 30, time = 50},
	{kg = 7, lbs = 15.4, nbKeys = 50, time = 70},
	{kg = 9, lbs = 19.8, nbKeys = 65, time = 90},
	{kg = 11, lbs = 24.2, nbKeys = 90, time = 110},
	{kg = 13, lbs = 28.6, nbKeys = 110, time = 130},
	{kg = 15, lbs = 33, nbKeys = 150, time = 150},
}

// kg = the weight in kg
// lbs = the weight in lbs
// mass = the mass of the entity (doesn't change anything in the training itself, just a value for physics)
// time = training time
// nbPoints = the amount of points you have to touch on the punching ball
// note: the more points there is, the easier it is to "grab" a good score
Diablos.TS.PunchingBallSizeEquivalence = {
	{kg = 10, lbs = 22, mass = 30, nbPoints = 8, time = 30,},
	{kg = 20, lbs = 44, mass = 50, nbPoints = 6, time = 60},
	{kg = 30, lbs = 66, mass = 70, nbPoints = 4, time = 120},
	{kg = 40, lbs = 88, mass = 95, nbPoints = 2, time = 200},
}

// Derma buttons used for the training + admin panel
Diablos.TS.DermaButtons = {
	{icon = Diablos.TS.Materials.home, str = "home"},
	{icon = Diablos.TS.Materials.strength, str = "strength"},
	{icon = Diablos.TS.Materials.attackSpeed, str = "attackspeed"},
	{icon = Diablos.TS.Materials.stamina, str = "stamina"},
	{icon = Diablos.TS.Materials.runningSpeed, str = "runningspeed"},
}