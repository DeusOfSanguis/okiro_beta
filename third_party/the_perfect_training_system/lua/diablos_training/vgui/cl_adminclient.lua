/*---------------------------------------------------------------------------
	Updates the "label" vgui element to see how many elements you have selected
---------------------------------------------------------------------------*/

local function UpdateAmountPlayersSelected(label, val)
	if IsValid(label) then
		label:SetText(string.format(Diablos.TS:GetLanguageString("updateSelection"), val))
	end
end

/*---------------------------------------------------------------------------
	Returns a proper string with the table which contains player indexes
---------------------------------------------------------------------------*/

local function GetStringFromSelectedPlayers(tab)
	local str = ""
	local i = 1
	for _, ply in ipairs(tab) do
		if IsValid(ply) then
			if i != 1 then
				str = str .. ", "
			end
			str = str .. ply:Nick()
			i = i + 1
		end
	end
	if str == "" then str = "None" end

	return str
end

net.Receive("TPTSA:OpenAdminClientPanel", function(len, _)
	local ply = LocalPlayer()
	if not Diablos.TS:IsAdmin(ply) then return end
	local idopen

	local trainings = Diablos.TS:GetTrainings()
	local playersData = {}
	local sumValues = {}
	local averageValues = {}


	local playerCount = net.ReadUInt(8)
	for i = 1, playerCount do
		local curPlayer = net.ReadEntity()

		local globalTableTraining = Diablos.TS:ReadTrainingInfo(curPlayer)

		local tableTraining = globalTableTraining["Trainings"]

		for typeTraining, trainingData in pairs(tableTraining) do
			sumValues[typeTraining] = (sumValues[typeTraining] or 0) + tableTraining[typeTraining].xp

			trainingData.ID = table.KeyFromValue(trainings, typeTraining)
		end

		table.SortByMember(tableTraining, "ID", false)

		playersData[curPlayer] = globalTableTraining
	end



	for typeTraining, total in pairs(sumValues) do
		averageValues[typeTraining] = total / playerCount
	end

	local updateInfo
	local players = {}

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

		draw.SimpleText("ADMIN CLIENT", "Diablos:Font:TS:30", 5, (h - 4) / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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
	end

	local docker = vgui.Create("DPanel", frame)
	docker:Dock(FILL)
	docker:DockPadding(10, 10, 10, 10)
	docker:DockMargin(0, 0, 0, 0)
	docker.Paint = function(s, w, h) end

	local function changePanel(numPanel, numTraining)
		docker:Clear()
		players = {}

		if numPanel == 1 then

			local timeLaunch = CurTime()

			local trainingInfoPanel = vgui.Create("DPanel", docker)
			trainingInfoPanel:Dock(TOP)
			trainingInfoPanel:DockMargin(50, 0, 50, 10)
			trainingInfoPanel:SetTall(195)
			trainingInfoPanel.Paint = function(s, w, h)

				draw.SimpleText(Diablos.TS:GetLanguageString("globalStatistics"), "Diablos:Font:TS:30", w / 2, 0, Diablos.TS.Colors.gl, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				local transition = math.min((CurTime() - timeLaunch) * 2, 1)


				for k, typeTraining in ipairs(trainings) do
					local posY = 55 + (k - 1) * 40
					draw.SimpleText(Diablos.TS:GetLanguageString(typeTraining), "Diablos:Font:TS:25:B", 5, posY, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

					local trainingTable = Diablos.TS:GetTrainingLevelTable(typeTraining)
					local maxXP = trainingTable[#trainingTable].xp
					local percent = math.min(averageValues[typeTraining] /  maxXP, 1)
					Diablos.TS:WriteProgressBar(200, posY, 600, 25, percent * transition)

					draw.SimpleText(string.format("%2.f/%2.f", averageValues[typeTraining], maxXP), "Diablos:Font:TS:25:B", w - 5, posY, Diablos.TS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

				end
			end

			local globalInfo = vgui.Create("DPanel", docker)
			globalInfo:Dock(TOP)
			globalInfo:DockPadding(0, 0, 0, 0)
			globalInfo:DockMargin(0, 0, 0, 10)
			globalInfo:SetTall(70)
			globalInfo.Paint = function(s, w, h)
				draw.SimpleText(Diablos.TS:GetLanguageString("onlineStatistics"), "Diablos:Font:TS:30", w / 2, 0, Diablos.TS.Colors.gl, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)


				local posx = 190
				for k, typeTraining in ipairs(trainings) do
					draw.SimpleText(Diablos.TS:GetLanguageString(typeTraining), "Diablos:Font:TS:25", posx, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					posx = posx + 180
				end
				--draw.SimpleText(Diablos.TS:GetLanguageString("strength"), "Diablos:Font:TS:25", 370, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				--draw.SimpleText(Diablos.TS:GetLanguageString("stamina"), "Diablos:Font:TS:25", 550, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				--draw.SimpleText(Diablos.TS:GetLanguageString("runningspeed"), "Diablos:Font:TS:25", 730, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(Diablos.TS:GetLanguageString("activebadge"), "Diablos:Font:TS:25", posx, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			end

			local playersPanel = vgui.Create("DScrollPanel", docker)
			playersPanel:Dock(TOP)
			playersPanel:DockPadding(0, 0, 0, 0)
			playersPanel:DockMargin(0, 0, 0, 10)
			-- playersPanel:GetCanvas():DockPadding(0, 0, 0, 0)
			-- playersPanel:GetCanvas():DockMargin(0, 0, 0, 10)
			playersPanel:SetTall(305)
			playersPanel.Paint = function(s, w, h) end
			local playersPanelVBar = playersPanel:GetVBar()
			playersPanelVBar.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.TS.Colors.barBackground)
				surface.DrawRect(5, 0, w - 5, h)
			end
			playersPanelVBar.btnGrip.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.TS.Colors.barFill)
				surface.DrawRect(5, 0, w - 5, h)
			end
			playersPanelVBar.btnUp.Paint = function(s, w, h) end
			playersPanelVBar.btnDown.Paint = function(s, w, h) end


			for curPly, trainingInfo in pairs(playersData) do

				local playerPanel = vgui.Create("DPanel", playersPanel)
				playerPanel:Dock(TOP)
				playerPanel:DockPadding(0, 0, 0, 0)
				playerPanel:DockMargin(0, 0, 0, 10)
				playerPanel:SetTall(110)
				playerPanel.Paint = function(s, w, h)
					surface.SetDrawColor(Diablos.TS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
					surface.SetDrawColor(Diablos.TS.Colors.bl) surface.DrawRect(0, h - 2, w, 2)


					local k = 1
					local posX = 0
					for typeTraining, training in pairs(trainingInfo.Trainings) do

						local levelData = Diablos.TS:GetTrainingLevel(typeTraining, training.xp)
						local percentageData = Diablos.TS:GetTrainingPercentage(typeTraining, training.xp)

						local order = Diablos.TS:GetTrainingOrder(typeTraining)
						posX = 190 + (order - 1) * 180
						draw.SimpleText(string.format(Diablos.TS:GetLanguageString("xpPoint"), training.xp), "Diablos:Font:TS:25", posX, 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
						draw.SimpleText(string.format("(%s - %u%%)", string.format(Diablos.TS:GetLanguageString("currentLevel"), levelData), percentageData), "Diablos:Font:TS:20", posX, 35, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
						if training.date != 0 then
							draw.SimpleText(string.format("%s: ", Diablos.TS:GetLanguageString("lastTraining")), "Diablos:Font:TS:20", posX, h - 5 - 20, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
						end
						local dateText
						if training.date == 0 then
							dateText = Diablos.TS:GetLanguageString("neverTrained")
						else
							local date = training.date - Diablos.TS.MuscleRest * 60 * 60
							dateText = os.date(Diablos.TS:GetOSFormat(), date)
						end
						draw.SimpleText(dateText, "Diablos:Font:TS:20", posX, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

						k = k + 1
					end

					local badge = trainingInfo.Badge

					posX = posX + 180

					local yesNoText, yesNoColor
					if badge.subdate > os.time() then
						yesNoText = Diablos.TS:GetLanguageString("yes")
						yesNoColor = Diablos.TS.Colors.gl
					else
						yesNoText = Diablos.TS:GetLanguageString("no")
						yesNoColor = Diablos.TS.Colors.rl
					end
					draw.SimpleText(yesNoText, "Diablos:Font:TS:25:B", posX, 5, yesNoColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

					local dateText
					if badge.subdate == 0 then
						dateText = Diablos.TS:GetLanguageString("neverSubscribed")
					else
						dateText = os.date(Diablos.TS:GetOSFormat(), badge.subdate)
					end
					draw.SimpleText(dateText, "Diablos:Font:TS:20", posX, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

					k = k + 1

				end

				local leftBox = vgui.Create("DPanel", playerPanel)
				leftBox:Dock(LEFT)
				leftBox:DockPadding(0, 0, 0, 30)
				leftBox:DockMargin(0, 0, 0, 0)
				leftBox:SetWide(100)
				leftBox.Paint = function(s, w, h)
					local nameText = Diablos.TS:GetLanguageString("undefined")
					if IsValid(curPly) then
						nameText = curPly:Nick()
					end

					draw.SimpleText(nameText, "Diablos:Font:TS:20", w / 2, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				end


				local icon = vgui.Create("DModelPanel", leftBox)
				icon:Dock(FILL)
				icon:DockMargin(5, 5, 5, 5)
				icon:SetModel(curPly:GetModel())
				Diablos.TS:UpdateRenderBounds(icon, 45)

				icon.DoClick = function(s)
				end


			end

			local buttonBottomPanel = vgui.Create("DPanel", docker)
			buttonBottomPanel:Dock(TOP)
			buttonBottomPanel:DockPadding(0, 0, 0, 0)
			buttonBottomPanel:DockMargin(0, 0, 0, 0)
			buttonBottomPanel:SetTall(40)
			buttonBottomPanel.Paint = function(s, w, h)
			end

			local resetPlayerData = vgui.Create("DButton", buttonBottomPanel)
			resetPlayerData:Dock(LEFT)
			resetPlayerData:DockMargin(0, 0, 0, 0)
			resetPlayerData:SetText(Diablos.TS:GetLanguageString("resetPlayerData"))
			resetPlayerData:SetFont("Diablos:Font:TS:30")
			resetPlayerData:SetWide(450)
			resetPlayerData.Paint = function(s, w, h)
				local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
				s:SetTextColor(curColor)
				surface.SetDrawColor(Diablos.TS.Colors.bl) surface.DrawRect(0, 0, w, h)
			end
			resetPlayerData.DoClick = function()
				Diablos.TS:OpenConfirmationBoxPanel(ply, function()
					net.Start("TPTSA:ResetTrainingData")
					net.SendToServer()
					frame:Close()
				end)
			end

			local resetEntityData = vgui.Create("DButton", buttonBottomPanel)
			resetEntityData:Dock(RIGHT)
			resetEntityData:DockMargin(0, 0, 0, 0)
			resetEntityData:SetText(Diablos.TS:GetLanguageString("resetEntityData"))
			resetEntityData:SetFont("Diablos:Font:TS:30")
			resetEntityData:SetWide(450)
			resetEntityData.Paint = function(s, w, h)
				local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
				s:SetTextColor(curColor)
				surface.SetDrawColor(Diablos.TS.Colors.bl) surface.DrawRect(0, 0, w, h)
			end
			resetEntityData.DoClick = function()
				Diablos.TS:OpenConfirmationBoxPanel(ply, function()
					net.Start("TPTSA:ResetEntityData")
					net.SendToServer()
					frame:Close()
				end)
			end

		elseif (numPanel >= 2 and numPanel <= 5) then

			local strings = {}
			local typeTraining = trainings[numPanel-1]

			strings.titleTraining = Diablos.TS:GetLanguageString(typeTraining)

			local trainingTable = Diablos.TS:GetTrainingLevelTable(typeTraining)

			local globalInfo = vgui.Create("DPanel", docker)
			globalInfo:Dock(TOP)
			globalInfo:DockPadding(0, 0, 0, 0)
			globalInfo:DockMargin(0, 0, 0, 10)
			globalInfo:SetTall(25)
			globalInfo.Paint = function(s, w, h)
				draw.SimpleText(Diablos.TS:GetLanguageString("xp"), "Diablos:Font:TS:25", 200, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText(Diablos.TS:GetLanguageString("level"), "Diablos:Font:TS:25", 400, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText(Diablos.TS:GetLanguageString("percentage"), "Diablos:Font:TS:25", 600, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				draw.SimpleText(Diablos.TS:GetLanguageString("lastTraining"), "Diablos:Font:TS:25", 800, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end

			local playersPanel = vgui.Create("DScrollPanel", docker)
			playersPanel:Dock(TOP)
			playersPanel:DockPadding(0, 0, 0, 0)
			playersPanel:DockMargin(0, 0, 0, 10)
			playersPanel:SetTall(455)
			playersPanel.Paint = function(s, w, h) end
			local playersPanelVBar = playersPanel:GetVBar()
			playersPanelVBar.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.TS.Colors.barBackground)
				surface.DrawRect(5, 0, w - 5, h)
			end
			playersPanelVBar.btnGrip.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.TS.Colors.barFill)
				surface.DrawRect(5, 0, w - 5, h)
			end
			playersPanelVBar.btnUp.Paint = function(s, w, h) end
			playersPanelVBar.btnDown.Paint = function(s, w, h) end


			for curPly, trainingInfo in pairs(playersData) do

				local isSelected = false

				local training = trainingInfo["Trainings"][typeTraining]
				local trainingLevel = Diablos.TS:GetTrainingLevel(typeTraining, training.xp)
				local trainingPercentage = Diablos.TS:GetTrainingPercentage(typeTraining, training.xp)

				local playerPanel = vgui.Create("DPanel", playersPanel)
				playerPanel:Dock(TOP)
				playerPanel:DockPadding(0, 0, 0, 0)
				playerPanel:DockMargin(0, 0, 0, 10)
				playerPanel:SetTall(80)
				playerPanel.Paint = function(s, w, h)
					surface.SetDrawColor(Diablos.TS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
					local colorAvailability = Diablos.TS.Colors.rl
					if isSelected then
						colorAvailability = Diablos.TS.Colors.gl
					end
					surface.SetDrawColor(colorAvailability) surface.DrawRect(0, h - 2, w, 2)

					if not IsValid(curPly) then
						if isSelected then
							isSelected = false
							table.RemoveByValue(players, curPly)
						end
					end

					for i = 1, 4 do -- 4 information: xp, level, percentage, date
						local posX = 200 + (i - 1) * 200

						local text = ""
						if i == 1 then
							text = string.format("%u/%u", training.xp, trainingTable[#trainingTable].xp)
						elseif i == 2 then
							text = string.format("%u", trainingLevel)
						elseif i == 3 then
							text = string.format("%u%%", trainingPercentage)
						elseif i == 4 then
							if training.date == 0 then
								text = Diablos.TS:GetLanguageString("neverTrained")
							else
								local date = training.date - Diablos.TS.MuscleRest * 60 * 60
								text = string.format("%s", os.date(Diablos.TS:GetOSFormat(), date))
							end
						end

						draw.SimpleText(text, "Diablos:Font:TS:25", posX, h / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end

					surface.SetDrawColor(color_white)
					surface.SetMaterial(Diablos.TS.Materials.circle)
					local size = 60
					surface.DrawTexturedRect(w - size - 10, h / 2 - size / 2, size, size)
					if isSelected then
						surface.SetMaterial(Diablos.TS.Materials.checked)
						surface.DrawTexturedRect(w - size - 10 + 10, h / 2 - size / 2 + 10, size - 20, size - 20)
					end
				end

				local changeSelectState = vgui.Create("DButton", playerPanel)
				changeSelectState:Dock(FILL)
				changeSelectState:SetText("")
				changeSelectState:SetFont("Diablos:Font:TS:35")
				changeSelectState.Paint = function(s, w, h)

				end

				changeSelectState.DoClick = function(s)
					if IsValid(curPly) then
						isSelected = not isSelected
						if isSelected then
							table.insert(players, curPly)
						else
							table.RemoveByValue(players, curPly)
						end
						UpdateAmountPlayersSelected(updateInfo, #players)
					end
				end

				local leftBox = vgui.Create("DPanel", playerPanel)
				leftBox:Dock(LEFT)
				leftBox:DockPadding(0, 0, 0, 30)
				leftBox:DockMargin(0, 0, 0, 0)
				leftBox:SetWide(100)
				leftBox.Paint = function(s, w, h)
					local nameText = Diablos.TS:GetLanguageString("undefined")
					if IsValid(curPly) then
						nameText = curPly:Nick()
					end

					draw.SimpleText(nameText, "Diablos:Font:TS:20", w / 2, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				end


				local icon = vgui.Create("DModelPanel", leftBox)
				icon:Dock(FILL)
				icon:DockMargin(5, 5, 5, 5)
				icon:SetModel(curPly:GetModel())
				Diablos.TS:UpdateRenderBounds(icon, 80)

				icon.DoClick = function(s)
					if IsValid(curPly) then
						isSelected = not isSelected
						if isSelected then
							table.insert(players, curPly)
						else
							table.RemoveByValue(players, curPly)
						end
						UpdateAmountPlayersSelected(updateInfo, #players)
					end
				end
			end

			local setVariables = vgui.Create("DPanel", docker)
			setVariables:Dock(TOP)
			setVariables:DockPadding(0, 0, 0, 0)
			setVariables:DockMargin(0, 0, 0, 10)
			setVariables:SetTall(50)
			setVariables.Paint = function(s, w, h)
				draw.SimpleText(string.format(Diablos.TS:GetLanguageString("peopleSelected"), GetStringFromSelectedPlayers(players)), "Diablos:Font:TS:25", w / 2, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				draw.SimpleText(Diablos.TS:GetLanguageString("peopleSelectedTip"), "Diablos:Font:TS:20", w / 2, h, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			end

			local trainingPanel = vgui.Create("DPanel", docker)
			trainingPanel:Dock(TOP)
			trainingPanel:DockPadding(250, 0, 0, 0)
			trainingPanel:DockMargin(0, 0, 0, 10)
			trainingPanel:SetTall(30)
			trainingPanel.Paint = function(s, w, h)
				draw.SimpleText(string.format(Diablos.TS:GetLanguageString("setTo"), strings.titleTraining), "Diablos:Font:TS:30", 5, h / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				draw.SimpleText(Diablos.TS:GetLanguageString("xp"), "Diablos:Font:TS:25", w - 5, h / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end

			local valueToChange = vgui.Create("DNumberWang", trainingPanel)
			valueToChange:Dock(RIGHT)
			valueToChange:DockMargin(0, 0, 50, 0)
			valueToChange:SetMinMax(0, 65535)
			valueToChange:HideWang()
			valueToChange:SetValue(0)
			valueToChange:SetFont("Diablos:Font:TS:35")
			valueToChange:SetWide(80)
			valueToChange.Paint = function(s, w, h)
				surface.SetDrawColor(Diablos.TS.Colors.bl2)
				surface.DrawRect(0, 0, w, h)
				s:DrawTextEntryText(Diablos.TS.Colors.Label, Diablos.TS.Colors.LabelHovered, Diablos.TS.Colors.LabelDown)
			end
			valueToChange.OnValueChanged = function(s, val)
			end

			updateInfo = vgui.Create("DButton", docker)
			updateInfo:Dock(TOP)
			updateInfo:DockMargin(0, 0, 0, 0)
			updateInfo:SetTall(40)
			updateInfo:SetText(string.format(Diablos.TS:GetLanguageString("updateSelection"), 0))
			updateInfo:SetFont("Diablos:Font:TS:35")
			updateInfo.Paint = function(s, w, h)
				local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
				s:SetTextColor(curColor)
				local colorGreenRed = Diablos.TS.Colors.g
				if #players == 0 then
					colorGreenRed = Diablos.TS.Colors.r
				end
				surface.SetDrawColor(colorGreenRed) surface.DrawRect(0, 0, w, h)
			end
			updateInfo.DoClick = function(s)
				if #players > 0 then
					net.Start("TPTSA:EditTrainingData")
						net.WriteUInt(#players, 8)
						for k, v in ipairs(players) do
							net.WriteEntity(v)
						end
						-- Send trainingtype:
						-- 0: stamina / 1: running speed / 2: strength / 3: attack speed
						net.WriteUInt(numTraining, 2)
						-- The new value
						net.WriteUInt(valueToChange:GetValue(), 32)
					net.SendToServer()
					frame:Close()
				end
			end

		end

		idopen = numPanel

	end

	changePanel(1)

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

			local font = "Diablos:Font:TS:20"
			if idopen == new_k then
				font = "Diablos:Font:TS:20:B"
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
			changePanel(new_k, k - 2)
		end

		num = num + 1
	end

	frame:MakePopup()
end)