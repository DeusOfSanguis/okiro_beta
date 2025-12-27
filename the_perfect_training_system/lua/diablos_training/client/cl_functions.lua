/*---------------------------------------------------------------------------
	Paint functions to paint a panel depending on the effect (none, hovered, down)
	If none of the colors are specified, then it means this is a "classic" label color scheme
	Return the great color
---------------------------------------------------------------------------*/

local DEFAULT_COLOR_PATH = Diablos.TS.Colors
function Diablos.TS:PaintFunctions(panel, panelNone, panelHover, panelDown)
	local panelColor = panelNone
	local panelHoverColor = panelHover
	local panelDownColor = panelDown
	if not panelColor then
		panelColor = DEFAULT_COLOR_PATH.Label
	end
	if not panelHoverColor then
		panelHoverColor = DEFAULT_COLOR_PATH.LabelHovered
	end
	if not panelDownColor then
		panelDownColor = DEFAULT_COLOR_PATH.LabelDown
	end

	local colorValue

	if panel:IsHovered() then
		if panel:IsDown() then
			colorValue = panelDownColor
		else
			colorValue = panelHoverColor
		end
	else
		colorValue = panelColor
	end

	return colorValue
end

/*---------------------------------------------------------------------------
	Write a progress bar with the fill according to the percent
---------------------------------------------------------------------------*/

function Diablos.TS:WriteProgressBar(posX, posY, WIDTH, HEIGHT, percent)
	surface.SetDrawColor(Diablos.TS.Colors.barBackground)
	surface.DrawRect(posX, posY - HEIGHT / 2, WIDTH, HEIGHT)
	surface.SetDrawColor(Diablos.TS.Colors.barFill)
	surface.DrawRect(posX, posY - HEIGHT / 2, math.min(WIDTH * percent, WIDTH), HEIGHT)
end


/*---------------------------------------------------------------------------
	Draw a key onto the screen
---------------------------------------------------------------------------*/

function Diablos.TS:DrawKey(key, posX, posY, fontSize, borderSize, isArrow, keyIndex)
	local ply = LocalPlayer()
	local font = string.format("Diablos:Font:TS:%u", fontSize)
	surface.SetFont(font)
	local sizex, sizey = surface.GetTextSize(key)

	local colInside = color_black
	if not isArrow then
		if ply.keyTable != nil and #ply.keyTable > 0 then
			if ply.keyGreat[keyIndex] != nil then
				if ply.keyGreat[keyIndex] then
					colInside = Diablos.TS.Colors.gl
				else
					colInside = Diablos.TS.Colors.rl
				end
			end
		end
	end

	draw.RoundedBox(12, posX - sizex / 2 - borderSize, posY - sizey / 2 - borderSize / 2, sizex + borderSize * 2, sizey + borderSize, color_black)
	draw.RoundedBox(8, posX - sizex / 2 - borderSize / 2, posY - sizey / 2 - borderSize / 4, sizex + borderSize, sizey + borderSize / 2, Diablos.TS.Colors.Label)
	draw.RoundedBox(8, posX - sizex / 2 - borderSize / 2 + 1, posY - sizey / 2 - borderSize / 4 + 1, sizex + borderSize - 2, sizey + borderSize / 2 - 2, colInside)
	draw.SimpleText(key, font, posX, posY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if isArrow then
		local downState = 20 * math.sin(CurTime() * 10)
		surface.SetDrawColor(color_white)
		surface.SetMaterial(Diablos.TS.Materials.downKey)
		surface.DrawTexturedRect(posX - 30, posY - sizey / 2 - downState - 100, 60, 60)
	end
end

/*---------------------------------------------------------------------------
	Set the render bounds of the DModelPanel
---------------------------------------------------------------------------*/

function Diablos.TS:UpdateRenderBounds(icon, fov)
	local mn, mx = icon.Entity:GetRenderBounds()
	local size = 0
	size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
	size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
	size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

	icon:SetFOV(fov)
	icon:SetCamPos(Vector(size, size, size))
	icon:SetLookAt((mn + mx) * 0.5)

	function icon:LayoutEntity( Entity ) return end
end


/*---------------------------------------------------------------------------
	Update information clientside when the user is starting a training
---------------------------------------------------------------------------*/


function Diablos.TS:StartTraining(ply, typeTraining, timeTraining)

	ply.typeTraining = typeTraining

	ply.startTraining = CurTime() -- start the training experience
	ply.beginTraining = CurTime() + Diablos.TS.TimeBeforeTraining -- the training begins
	ply.EndTraining = ply.beginTraining + timeTraining -- the training ends

	if typeTraining == "stamina" or typeTraining == "runningspeed" then
		ply.keyTipTime = CurTime()
		ply.curSpeed = 0
	elseif typeTraining == "strength" then
		ply.keyGreat = {}
		ply.curnbKeysSucceed = 0

		ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_BECON, false)
	elseif typeTraining == "attackspeed" then
		ply.curHit = 0
	end
end

/*---------------------------------------------------------------------------
	Update animation gesture for all the players
	AnimRestartGesture needs to be broadcasted to the clients as this is not networked by default
---------------------------------------------------------------------------*/

function Diablos.TS:UpdateAnimation(plyAnim, isStarting)
	if isStarting then
		plyAnim:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_BECON, false)
	else
		plyAnim:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
	end
end

/*---------------------------------------------------------------------------
	Update information clientside to refresh some data about the training
---------------------------------------------------------------------------*/

function Diablos.TS:RefreshTraining(ply, typeTraining, newNumber)
	if typeTraining == "stamina" or typeTraining == "runningspeed" then
		ply.curSpeed = newNumber / 10
	elseif typeTraining == "strength" then
		ply.curnbKeysSucceed = newNumber
	elseif typeTraining == "attackspeed" then
		ply.curHit = (ply.curHit or 0) + newNumber
	end
end


/*---------------------------------------------------------------------------
	Reset all the data when the training has ended
---------------------------------------------------------------------------*/

function Diablos.TS:StopTraining(ply, typeTraining)
	ply.startTraining = 0
	ply.beginTraining = 0
	ply.EndTraining = 0
	ply.typeTraining = ""

	if typeTraining == "stamina" then
		ply.keyTipTime = 0
		ply.curSpeed = 0
	elseif typeTraining == "runningspeed" then
		ply.keyTipTime = 0
		ply.curSpeed = 0
	elseif typeTraining == "strength" then
		ply.keyTable = {}
		ply.keyGreat = {}
		ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
	elseif typeTraining == "attackspeed" then
		ply.curHit = 0
	end
end


/*---------------------------------------------------------------------------
	Self-explanatory function (called a lot of times on RefreshBones and is much smoother to read)
---------------------------------------------------------------------------*/

local function ScaleBone(ply, index, vec)
	if index != nil then
		-- ply:ManipulateBoneScale(index, vec)
	end
end

/*---------------------------------------------------------------------------
	Self-explanatory function, again (to reset bones to a default size)
---------------------------------------------------------------------------*/

local vec_one = Vector(1, 1, 1)
local function ResetBonesToOrigin(ply, listBones)
	for _, bone in ipairs(listBones) do
		-- ScaleBone(ply, bone, vec_one)
	end
end

/*---------------------------------------------------------------------------
	Self-explanatory function to scale the vector by the quota
---------------------------------------------------------------------------*/

local function ScaleVector(vec, quota)
	return vec_one + vec * quota
end

-- can be several type of trainings
function Diablos.TS:RefreshBones(plyBone, trainingsToUpdate)
	if not Diablos.TS.ChangeBones then return end

	for typeMuscle, values in pairs(trainingsToUpdate) do

		local curLevel = values.level
		local reset = values.reset

		local maxLevel = table.Count(Diablos.TS:GetTrainingLevelTable(typeMuscle))


		local levelQuota = curLevel / maxLevel
		-- levelQuota = 1 -- WARN: To uncomment only if you want to see the maximum realistic muscles you could have

		local bones = {}

		if typeMuscle == "strength" then
			-- Increase Shoulder / Trapezius / Upperarm
			-- bicep & elbow are useless here

			local shoulderL = plyBone:LookupBone("ValveBiped.Bip01_L_Shoulder") table.insert(bones, shoulderL)
			local shoulderR = plyBone:LookupBone("ValveBiped.Bip01_R_Shoulder") table.insert(bones, shoulderR)
			local trapeziusL = plyBone:LookupBone("ValveBiped.Bip01_L_Trapezius") table.insert(bones, trapeziusL)
			local trapeziusR = plyBone:LookupBone("ValveBiped.Bip01_R_Trapezius") table.insert(bones, trapeziusR)
			local upperarmL = plyBone:LookupBone("ValveBiped.Bip01_L_Upperarm") table.insert(bones, upperArmL)
			local upperarmR = plyBone:LookupBone("ValveBiped.Bip01_R_Upperarm") table.insert(bones, upperArmR)

			if not reset then
				ScaleBone(plyBone, shoulderL, ScaleVector(Vector(1, 0.4, 2), levelQuota))
				ScaleBone(plyBone, shoulderR, ScaleVector(Vector(1, 0.4, 2), levelQuota))
				ScaleBone(plyBone, trapeziusL, ScaleVector(Vector(1, 1, 1), levelQuota))
				ScaleBone(plyBone, trapeziusR, ScaleVector(Vector(1, 1, 1), levelQuota))
				ScaleBone(plyBone, upperarmL, ScaleVector(Vector(0, 0, 1), levelQuota))
				ScaleBone(plyBone, upperarmR, ScaleVector(Vector(0, 0, 1), levelQuota))
			end
		elseif typeMuscle == "stamina" then
			-- Increase Thigh


			local thighL = plyBone:LookupBone("ValveBiped.Bip01_L_Thigh") table.insert(bones, thighL)
			local thighR = plyBone:LookupBone("ValveBiped.Bip01_R_Thigh") table.insert(bones, thighR)

			if not reset then
				ScaleBone(plyBone, thighL, ScaleVector(Vector(0, 0.3, 0.6), levelQuota))
				ScaleBone(plyBone, thighR, ScaleVector(Vector(0, 0.3, 0.6), levelQuota))
			end

		elseif typeMuscle == "runningspeed" then
			-- Increase Calf

			local calfL = plyBone:LookupBone("ValveBiped.Bip01_L_Calf") table.insert(bones, calfL)
			local calfR = plyBone:LookupBone("ValveBiped.Bip01_R_Calf") table.insert(bones, calfR)

			if not reset then
				ScaleBone(plyBone, calfL, ScaleVector(Vector(0.3, 0.3, 0.6), levelQuota))
				ScaleBone(plyBone, calfR, ScaleVector(Vector(0.3, 0.3, 0.6), levelQuota))
			end

		elseif typeMuscle == "attackspeed" then -- doesn't do anything
			-- Increase Forearm
			-- wrist and ulna increases do nothing, and hand should not be increased because the viewmodels will also be!

			local forearmL = plyBone:LookupBone("ValveBiped.Bip01_L_Forearm") table.insert(bones, forearmL)
			local forearmR = plyBone:LookupBone("ValveBiped.Bip01_R_Forearm") table.insert(bones, forearmR)

			if not reset then
				ScaleBone(plyBone, forearmL, ScaleVector(Vector(0, 0.5, 0.5), levelQuota))
				ScaleBone(plyBone, forearmR, ScaleVector(Vector(0, 0.5, 0.5), levelQuota))
			end
		end

		if reset then
			-- If we need to reset bones
			ResetBonesToOrigin(plyBone, bones)
		end
	end

end

/*---------------------------------------------------------------------------
	Read the training information of a player
	This will recreate the training table clientside with the values sent: 
		- a pair of (xp, date) for every training enabled on the server
		- a UInt for the subscription date validity
---------------------------------------------------------------------------*/

function Diablos.TS:ReadTrainingInfo(ply)
	local trainings = Diablos.TS:GetTrainings()
	local tableToReturn = {["Trainings"] = {}}
	for _, training in ipairs(trainings) do
		local curXP = net.ReadUInt(32)
		local curDate = net.ReadUInt(32)

		tableToReturn["Trainings"][training] = {xp = curXP, date = curDate}
	end

	tableToReturn["Badge"] = {subdate = net.ReadUInt(32)}

	return tableToReturn
end