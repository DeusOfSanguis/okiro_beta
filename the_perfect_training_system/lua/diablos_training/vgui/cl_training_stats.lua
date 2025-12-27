local reliefMaterials = {
	["strength"] = Diablos.TS.Materials.humanBodyReliefStrength,
	["stamina"] = Diablos.TS.Materials.humanBodyReliefStamina,
	["runningspeed"] = Diablos.TS.Materials.humanBodyReliefRunningSpeed,
	["attackspeed"] = Diablos.TS.Materials.humanBodyReliefAttackSpeed,
}

net.Receive("TPTSA:OpenTrainingPanel", function(len, _)
	local ply = LocalPlayer()
	ply.trainingDerma = true
	local idopen

	local frame = vgui.Create("DFrame")
	frame:SetSize(1200, 700)
	frame:DockPadding(0, 0, 0, 0)
	frame:Center()
	frame:SetTitle("")
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame.Paint = function(s, w, h)
		if Diablos.TS.Colors.Blurs then Derma_DrawBackgroundBlur(s, 1) end
		surface.SetDrawColor(Diablos.TS.Colors.Frame) surface.DrawRect(0, 0, w, h)
	end

	local header = vgui.Create("DPanel", frame)
	header:Dock(TOP)
	header:DockMargin(0, 0, 0, 0)
	header:SetTall(40)
	header.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.TS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(Diablos.TS.Colors.Header) surface.DrawRect(0, h - 4, w, 4)

		draw.SimpleText(Diablos.TS:GetLanguageString("trainingStatistics"), "Diablos:Font:TS:30", 5, (h - 4) / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	local closeButton = vgui.Create("DButton", header)
	closeButton:Dock(RIGHT)
	closeButton:SetText("")
	closeButton:SetWide(40)
	closeButton.Paint = function(s, w, h)
		local size = h * 0.8
		local curColor = Diablos.TS:PaintFunctions(s, color_white, Diablos.TS.Label, Diablos.TS.LabelHovered)
		surface.SetDrawColor(curColor)
		surface.SetMaterial(Diablos.TS.Materials.close)
		surface.DrawTexturedRect(w / 2 - size / 2, (h - 4) / 2 - size / 2, size, size)
	end

	closeButton.DoClick = function(s)
		frame:Close()
		ply.trainingDerma = false
	end

	local bodies = {}

	local docker = vgui.Create("DPanel", frame)
	docker:Dock(FILL)
	docker:DockPadding(10, 10, 10, 10)
	docker.Paint = function(s, w, h)
	end


	local function changePanel(numPanel)
		docker:Clear()

		local trainings = Diablos.TS:GetTrainings()

		if numPanel == 1 then

			docker.Paint = function(s, w, h)
				draw.SimpleText(Diablos.TS:GetLanguageString("trainingAdv"), "Diablos:Font:TS:25", w / 2, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				surface.SetDrawColor(color_white)

				local posY = 10 + 60 + 75

				-- Strength lines
				if Diablos.TS:IsTrainingEnabled("strength") then
					surface.DrawLine(250, posY, 460, posY)
				end

				posY = posY + 150 + 30

				-- Stamina lines
				if Diablos.TS:IsTrainingEnabled("stamina") then
					surface.DrawLine(250, posY, 475, posY)
				end

				posY = 10 + 150 + 75

				-- Attack speed lines
				if Diablos.TS:IsTrainingEnabled("attackspeed") then
					surface.DrawLine(w - 250 - 10, posY, 610, posY)
				end

				posY = posY + 150 + 60

				-- Running speed lines
				if Diablos.TS:IsTrainingEnabled("runningspeed") then
					surface.DrawLine(w - 250 - 10, posY, 572, posY)
				end
			end


			local trainingButtonLeft = vgui.Create("DPanel", docker)
			trainingButtonLeft:Dock(LEFT)
			trainingButtonLeft:DockMargin(0, 0, 0, 0)
			trainingButtonLeft:SetWide(250)
			trainingButtonLeft.Paint = function(s, w, h)

			end

			local trainingButtonRight = vgui.Create("DPanel", docker)
			trainingButtonRight:Dock(RIGHT)
			trainingButtonRight:DockMargin(0, 0, 0, 0)
			trainingButtonRight:SetWide(250)
			trainingButtonRight.Paint = function(s, w, h)

			end

			for i = 1, #trainings do
				local typeTraining = string.lower(trainings[i])
				local trainingData = ply:TSGetTrainingInfo(typeTraining)
				local trainingLevel = Diablos.TS:GetTrainingLevel(typeTraining, trainingData.xp)

				local strings = {}
				local parent, marginTop

				table.insert(bodies, {name = typeTraining, date = trainingData.date})

				strings.training = Diablos.TS:GetLanguageString(typeTraining)
				typeTraining = string.lower(typeTraining)
				if typeTraining == "stamina" then
					strings.result = string.format("%u %s", ply:TSGetStaminaTimeDuration(), Diablos.TS:GetLanguageString("seconds"))
					parent = trainingButtonLeft
					marginTop = 30
					if not Diablos.TS:IsTrainingEnabled("strength") then
						marginTop = marginTop + 60 + 150
					end
				elseif typeTraining == "runningspeed" then
					strings.result = string.format("%4.2f %s", Diablos.TS:GetSpeedFromUnit(ply:GetRunSpeed()), Diablos.TS:GetSpeedText())
					parent = trainingButtonRight
					marginTop = 60
					if not Diablos.TS:IsTrainingEnabled("attackspeed") then
						marginTop = marginTop + 150 + 150
					end
				elseif typeTraining == "strength" then
					strings.result = string.format("+%u%%", ply:TSGetStrengthDamage())
					parent = trainingButtonLeft
					marginTop = 60
				elseif typeTraining == "attackspeed" then
					strings.result = string.format("+%u%%", ply:TSGetAttackSpeed())
					parent = trainingButtonRight
					marginTop = 150
				end
				strings.muscle = Diablos.TS:GetLanguageString(typeTraining .. "Muscle")
				strings.benefit = Diablos.TS:GetLanguageString(typeTraining .. "Benefit")

				local trainingPanel = vgui.Create("DButton", parent)
				trainingPanel:Dock(TOP)
				trainingPanel:DockMargin(0, marginTop, 0, 0)
				trainingPanel:SetText("")
				trainingPanel:SetTall(150)
				trainingPanel.Paint = function(s, w, h)
					local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Colors.bl, Diablos.TS.Colors.bl2, Diablos.TS.Colors.bl3, true)
					surface.SetDrawColor(curColor)
					surface.DrawRect(0, 0, w, h)

					draw.SimpleText(strings.training, "Diablos:Font:TS:30:B", w / 2, 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					draw.SimpleText(string.format(Diablos.TS:GetLanguageString("currentLevel"), trainingLevel), "Diablos:Font:TS:25", w / 2, 35, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					draw.SimpleText(strings.muscle, "Diablos:Font:TS:20:I", w / 2, h / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					draw.SimpleText(strings.benefit, "Diablos:Font:TS:25:I", w / 2, h - 35, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					draw.SimpleText(strings.result, "Diablos:Font:TS:35:B", w / 2, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				end
				trainingPanel.DoClick = function(s)
					changePanel(i + 1) -- the first one is home
				end
			end

			local bodyInfos = vgui.Create("DPanel", docker)
			bodyInfos:Dock(FILL)
			bodyInfos:DockMargin(0, 0, 0, 0)
			bodyInfos:SetWide(500)
			bodyInfos.Paint = function(s, w, h)

				local SIZE_BODY_Y = h - 15 - 10
				local SIZE_BODY_X = SIZE_BODY_Y * 1097 / 2246

				surface.SetDrawColor(color_white)
				surface.SetMaterial(Diablos.TS.Materials.humanBody)
				surface.DrawTexturedRect(w / 2 - SIZE_BODY_X / 2, 20, SIZE_BODY_X, SIZE_BODY_Y)

				for _, body in ipairs(bodies) do
					local name = body.name
					if not reliefMaterials[name] then continue end
					local date = body.date

					local nextTrain = date - os.time()
					local losingMuscle = (date + Diablos.TS.RetroTime * 24 * 60 * 60) - os.time()

					local cosTime = math.abs(math.cos(CurTime())) * 255
					local curColor
					-- if this is <= 0 it means you've already lose some muscle
					if (losingMuscle <= 0) then
						curColor = Diablos.TS.Colors.rl
					elseif (nextTrain <= 0) then
						curColor = Diablos.TS.Colors.bl
					elseif nextTrain > 0 then
						curColor = Diablos.TS.Colors.gl
					end
					surface.SetDrawColor(Color(curColor.r, curColor.g, curColor.b, cosTime))
					surface.SetMaterial(reliefMaterials[name])
					surface.DrawTexturedRect(w / 2 - SIZE_BODY_X / 2, 20, SIZE_BODY_X, SIZE_BODY_Y)
				end
			end

			local trainingDataBottom = vgui.Create("DPanel", docker)
			trainingDataBottom:Dock(BOTTOM)
			trainingDataBottom:DockMargin(0, 0, 0, 0)
			trainingDataBottom:DockPadding(10, 0, 10, 0)
			trainingDataBottom:SetTall(120)
			trainingDataBottom.Paint = function(s, w, h)

			end

			local badgeSubPanel = vgui.Create("DPanel", trainingDataBottom)
			badgeSubPanel:Dock(LEFT)
			badgeSubPanel:DockMargin(0, 0, 0, 0)
			badgeSubPanel:SetWide(250)
			badgeSubPanel.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.TS.Colors.drawColor)
				surface.DrawRect(0, 0, w, h)

				draw.SimpleText(Diablos.TS:GetLanguageString("badgeSubscription"), "Diablos:Font:TS:30:B", w / 2, 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				local sub = ply:TSGetTrainingSubscription()

				local subDate, subColor
				if sub == 0 then
					subDate = Diablos.TS:GetLanguageString("neverSubscribed")
					subColor = Diablos.TS.Colors.bl
				else
					subDate = os.date(Diablos.TS:GetOSFormat(), sub)
					local expirationDate
					if sub < os.time() then
						subColor = Diablos.TS.Colors.rl
						expirationDate = "expired"
					else
						subColor = Diablos.TS.Colors.gl
						expirationDate = "expirationDate"
					end
					draw.SimpleText(Diablos.TS:GetLanguageString(expirationDate), "Diablos:Font:TS:25:I", w / 2, 45, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end

				draw.SimpleText(subDate, "Diablos:Font:TS:25", w / 2, h - 5, subColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			end
			badgeSubPanel.DoClick = function(s)
				changePanel(i + 1) -- the first one is home
			end

			local captionPanel = vgui.Create("DPanel", trainingDataBottom)
			captionPanel:Dock(RIGHT)
			captionPanel:DockMargin(0, 0, 0, 0)
			captionPanel:SetWide(250)
			captionPanel.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.TS.Colors.FrameLeft)
				surface.DrawRect(0, 0, w, h)



				local captionPosX = w - 200
				local captionPosY


				captionPosY = 10
				surface.SetDrawColor(Diablos.TS.Colors.gl) surface.DrawRect(captionPosX, captionPosY, 20, 10)
				draw.SimpleText(Diablos.TS:GetLanguageString("captionFine"), "Diablos:Font:TS:25:I", captionPosX + 25, captionPosY + 5, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				captionPosY = h / 2 - 5
				surface.SetDrawColor(Diablos.TS.Colors.bl) surface.DrawRect(captionPosX, captionPosY, 20, 10)
				draw.SimpleText(Diablos.TS:GetLanguageString("captionShouldTrain"), "Diablos:Font:TS:25:I", captionPosX + 25, captionPosY + 5, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				captionPosY = h - 10 - 10
				surface.SetDrawColor(Diablos.TS.Colors.rl) surface.DrawRect(captionPosX, captionPosY, 20, 10)
				draw.SimpleText(Diablos.TS:GetLanguageString("captionMuscleLoss"), "Diablos:Font:TS:25:I", captionPosX + 25, captionPosY + 5, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

		elseif (numPanel >= 2 and numPanel <= 5) then

			docker.Paint = function(s, w, h)

			end

			local strings = {}
			local typeTraining = trainings[numPanel - 1]

			strings.increase = Diablos.TS:GetLanguageString(typeTraining .. "Benefit")

			local specificAbilities = ply:TSGetSpecificAbilities(typeTraining)
			local trainingTable = Diablos.TS:GetTrainingLevelTable(typeTraining)
			local trainingData = ply:TSGetTrainingInfo(typeTraining)
			local trainingLevel = Diablos.TS:GetTrainingLevel(typeTraining, trainingData.xp)
			local trainingPercentage = Diablos.TS:GetTrainingPercentage(typeTraining, trainingData.xp)

			local trainingTableCount = #trainingTable

			local timeOnPanel = CurTime()

			local trainingPercent = vgui.Create("DPanel", docker)
			trainingPercent:Dock(TOP)
			trainingPercent:DockMargin(50, 0, 50, 10)
			trainingPercent:SetTall(150)
			trainingPercent.time = CurTime()
			trainingPercent.Paint = function(s, w, h)

				-- Body draw

				local SIZE_BODY_Y = h
				local SIZE_BODY_X = SIZE_BODY_Y * 1097 / 2246
				local SIZE_TITLE = 0

				surface.SetDrawColor(color_white)
				surface.SetMaterial(Diablos.TS.Materials.humanBody)
				surface.DrawTexturedRect(w - SIZE_BODY_X, SIZE_TITLE, SIZE_BODY_X, SIZE_BODY_Y)

				for _, body in ipairs(bodies) do
					local name = body.name
					if name != typeTraining then continue end
					if not reliefMaterials[name] then continue end

					surface.SetDrawColor(Diablos.TS.Colors.navbarSelection)
					surface.SetMaterial(reliefMaterials[name])
					surface.DrawTexturedRect(w - SIZE_BODY_X, SIZE_TITLE, SIZE_BODY_X, SIZE_BODY_Y)
				end

				local BAR_SIZE = 500

				draw.SimpleText(Diablos.TS:GetLanguageString("levelProgression"), "Diablos:Font:TS:30", w / 2 - BAR_SIZE / 2 - 20, h / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

				local barPercentWithTime = math.Clamp(0, CurTime() - timeOnPanel, 1)
				Diablos.TS:WriteProgressBar(w / 2 - BAR_SIZE / 2, h / 2, BAR_SIZE, 30, trainingPercentage / 100 * barPercentWithTime)
				draw.SimpleText(string.format("%u%%", math.Round(trainingPercentage, 2)), "Diablos:Font:TS:30", w / 2 + BAR_SIZE / 2 + 30, h / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				local nextLevel = trainingLevel + 1
				local isLastLevel = false
				if nextLevel > trainingTableCount then
					nextLevel = trainingTableCount
					isLastLevel = true
				end
				if trainingData.xp < trainingTable[1].xp then
					nextLevel = nextLevel - 1
				end

				draw.SimpleText(trainingTable[trainingLevel].xp, "Diablos:Font:TS:30:B", w / 2 - BAR_SIZE / 2, h / 2 + 15 + 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				if not isLastLevel then
					draw.SimpleText(trainingTable[nextLevel].xp, "Diablos:Font:TS:30:B", w / 2 + BAR_SIZE / 2, h / 2 + 15 + 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end

				if s.time + 1 < CurTime() then
					draw.SimpleText(trainingData.xp, "Diablos:Font:TS:30:B", w / 2 - BAR_SIZE / 2 + BAR_SIZE * (trainingPercentage / 100), h / 2 + 15 + 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				end
			end

			local trainingTabTime = vgui.Create("DPanel", docker)
			trainingTabTime:Dock(TOP)
			trainingTabTime:DockMargin(0, 0, 0, 10)
			trainingTabTime:SetTall(150)

			trainingTabTime.Paint = function(s, w, h)

				-- If you already trained
				if trainingData.date != 0 then

					local diffTimeRest = trainingData.date - os.time()

					local sideCenter = w / 2 - w / 2 / 2

					surface.SetDrawColor(Diablos.TS.Colors.FrameLeft)
					surface.DrawRect(0, 0, w / 2 - 5, h)

					draw.SimpleText(Diablos.TS:GetLanguageString("muscleRest"), "Diablos:Font:TS:30:B", sideCenter, 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)



					if diffTimeRest > 0 then
						draw.SimpleText(Diablos.TS:GetLanguageString("waitUntil"), "Diablos:Font:TS:25", sideCenter, h / 2, Diablos.TS.Colors.gl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText(os.date(Diablos.TS:GetOSFormat(), trainingData.date), "Diablos:Font:TS:25", sideCenter, h - 30, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
						draw.SimpleText(Diablos.TS:NiceTimeFormat(trainingData.date - os.time(), true), "Diablos:Font:TS:20", sideCenter, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					else
						draw.SimpleText(Diablos.TS:GetLanguageString("freeToWorkout"), "Diablos:Font:TS:25", sideCenter, h / 2, Diablos.TS.Colors.gl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end

					sideCenter = sideCenter + w / 2

					surface.SetDrawColor(Diablos.TS.Colors.FrameLeft)
					surface.DrawRect(w / 2 + 5, 0, w / 2 - 5, h)

					draw.SimpleText(Diablos.TS:GetLanguageString("losingMuscle"), "Diablos:Font:TS:30:B", sideCenter, 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)


					local muscleLossDate = trainingData.date + Diablos.TS.RetroTime * 60 * 60
					local diffTimeLoss = muscleLossDate - os.time()

					if diffTimeLoss > 0 then

						draw.SimpleText(Diablos.TS:GetLanguageString("needTrainBeforeLosingMuscle"), "Diablos:Font:TS:25", sideCenter, h / 2, Diablos.TS.Colors.gl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText(os.date(Diablos.TS:GetOSFormat(), muscleLossDate), "Diablos:Font:TS:25", sideCenter, h - 30, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
						draw.SimpleText(Diablos.TS:NiceTimeFormat(muscleLossDate - os.time(), true), "Diablos:Font:TS:20", sideCenter, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

					else
						draw.SimpleText(Diablos.TS:GetLanguageString("currentlyLosing"), "Diablos:Font:TS:25", sideCenter, h / 2, Diablos.TS.Colors.rl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				else

					surface.SetDrawColor(Diablos.TS.Colors.FrameLeft)
					surface.DrawRect(0, 0, w, h)

					draw.SimpleText(Diablos.TS:GetLanguageString("neverTrained"), "Diablos:Font:TS:40:B", w / 2, h / 2, Diablos.TS.Colors.rl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end

			local trainingTabLevels = vgui.Create("DScrollPanel", docker)
			trainingTabLevels:Dock(TOP)
			trainingTabLevels:DockMargin(0, 0, 0, 10)
			trainingTabLevels:SetTall(330)
			trainingTabLevels:GetCanvas():DockPadding(0, 0, 0, 10)
			-- trainingTabLevels:SetVerticalScrollbarEnabled(false)
			local trainingTabLevelsVBar = trainingTabLevels:GetVBar()
			trainingTabLevelsVBar.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.TS.Colors.barBackground)
				surface.DrawRect(5, 0, w - 5, h)
			end
			trainingTabLevelsVBar.btnGrip.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.TS.Colors.barFill)
				surface.DrawRect(5, 0, w - 5, h)
			end
			trainingTabLevelsVBar.btnUp.Paint = function(s, w, h) end
			trainingTabLevelsVBar.btnDown.Paint = function(s, w, h) end
			local levelData = "76561198298484274"

			trainingTabLevels.Paint = function(s, w, h)
			end

			local trainingLevelLine

			for k, info in ipairs(trainingTable) do


				if (k - 1) % 4 == 0 then
					trainingLevelLine = vgui.Create("DPanel", trainingTabLevels)
					trainingLevelLine:Dock(TOP)
					trainingLevelLine:DockPadding(0, 0, 0, 0)
					trainingLevelLine:DockMargin(0, 0, 0, 10)
					trainingLevelLine:SetTall(155)
					trainingLevelLine.Paint = function(s, w, h)

					end
				end

				local trainingLevelElem = vgui.Create("DPanel", trainingLevelLine)
				trainingLevelElem:Dock(LEFT)
				trainingLevelElem:DockMargin(0, 0, 10, 0)
				trainingLevelElem:SetWide(250)
				trainingLevelElem.Paint = function(s, w, h)

					if k != trainingLevel then
						surface.SetDrawColor(Diablos.TS.Colors.Panel)
						surface.DrawRect(0, 0, w, h)
					else
						surface.SetDrawColor(Diablos.TS.Colors.bl)
						surface.DrawRect(0, 0, w, h)

						surface.SetDrawColor(Diablos.TS.Colors.Panel)
						for _ = 1, 4 do
							surface.DrawRect(2, 2, w - 4, h - 4)
						end
					end


					local benefitValue
					if typeTraining == "stamina" then
						if specificAbilities then
							info.timeduration = specificAbilities[k].timeduration
						end
						benefitValue = string.format("%u %s", info.timeduration, Diablos.TS:GetLanguageString("seconds"))
					elseif typeTraining == "runningspeed" then
						if specificAbilities then
							info.runspeed = specificAbilities[k].runspeed
						end
						local unitSpeed = ply.TS_JOB_RUN_SPEED + info.runspeed
						benefitValue = string.format("%4.2f %s", Diablos.TS:GetSpeedFromUnit(unitSpeed), Diablos.TS:GetSpeedText())
					elseif typeTraining == "strength" then
						if specificAbilities then
							info.damage = specificAbilities[k].damage
						end
						benefitValue = string.format("%u%%", 100 + info.damage)
					elseif typeTraining == "attackspeed" then
						if specificAbilities then
							info.attackspeed = specificAbilities[k].attackspeed
						end
						benefitValue = string.format("%u%%", 100 + info.attackspeed)
					end
					draw.SimpleText(string.format(Diablos.TS:GetLanguageString("currentLevel"), k), "Diablos:Font:TS:25:B", w / 2, 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
					draw.SimpleText(string.format(Diablos.TS:GetLanguageString("xpPoint"), info.xp), "Diablos:Font:TS:20:I", w / 2, 40, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					draw.SimpleText(strings.increase, "Diablos:Font:TS:25", w / 2, h - 35, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					draw.SimpleText(benefitValue, "Diablos:Font:TS:25:B", w / 2, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

				end

			end
		end

		idopen = numPanel

	end

	changePanel(1) -- default panel

	-- Left panel for buttons

	local leftPanel = vgui.Create("DPanel", frame)
	leftPanel:Dock(LEFT)
	leftPanel:SetWide(150)
	leftPanel:DockPadding(0, 10, 0, 0)
	leftPanel:DockMargin(0, 0, 0, 0)
	leftPanel.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.TS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
	end

	-- Assign buttons to the left panel

	local num = 1
	for k, v in ipairs(Diablos.TS.DermaButtons) do
		if k > 1 and not Diablos.TS:IsTrainingEnabled(v.str) then continue end
		local time_anim, end_anim = 0, 0

		local new_k = num

		local panel = vgui.Create("DPanel", leftPanel)
		panel:Dock(TOP)
		panel:DockMargin(0, 0, 0, 0)
		panel:SetTall(50)
		panel.Paint = function(s, w, h)
			if idopen == new_k then
				surface.SetDrawColor(Diablos.TS.Colors.navbarSelection) surface.DrawRect(0, 0, 2, h)
			else
				local curtime = CurTime()
				surface.SetDrawColor(Diablos.TS.Colors.navbarSelection)

				if end_anim != 0 then
					local val = curtime - end_anim
					surface.DrawRect(0, 0, 2 - 8 * val, h)
					if val >= 0.25 then time_anim, end_anim = 0, 0 end
				elseif time_anim != 0 then
					local val = math.min(curtime - time_anim, 1) * 2
					surface.DrawRect(0, 0, math.min(8 * val, 2), h)
				end
			end
		end

		local button = vgui.Create("DButton", panel)
		button:Dock(FILL)
		button:SetText("")
		button.Paint = function(s, w, h)
			local size = 20
			surface.SetDrawColor(color_white)
	        surface.SetMaterial(v.icon)
	        surface.DrawTexturedRect(10, h / 2 - size / 2, size, size)

			local isBold = false
			local font = "Diablos:Font:TS:20"
			if idopen == new_k then
				font = "Diablos:Font:TS:20:B"
				isBold = true
			end

			surface.SetFont(font)
			local textSize = surface.GetTextSize(Diablos.TS:GetLanguageString(v.str))
			if textSize > w - 40 then
				if isBold then
					font = "Diablos:Font:TS:15:B"
				else
					font = "Diablos:Font:TS:15"
				end
			end


			draw.SimpleText(Diablos.TS:GetLanguageString(v.str), font, 40, h / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		button.OnCursorEntered = function(s)
			time_anim = CurTime()
		end
		button.OnCursorExited = function(s)
			end_anim = CurTime()
		end
		button.DoClick = function(s)
			if idopen == new_k then return end
			changePanel(new_k)
		end

		num = num + 1
	end

	frame:MakePopup()
end)