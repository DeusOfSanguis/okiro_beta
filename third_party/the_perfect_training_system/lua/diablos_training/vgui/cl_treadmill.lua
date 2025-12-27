function Diablos.TS:OpenRunningPanel(ply, ent)

	local frame = vgui.Create("DFrame")
	frame:SetSize(650, 350)
	frame:DockPadding(0, 0, 0, 0)
	frame:Center()
	frame:SetTitle("")
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame.Paint = function(s, w, h)
		if Diablos.TS.Colors.Blurs then Derma_DrawBackgroundBlur(s, 1) end
		surface.SetDrawColor(Diablos.TS.Colors.Frame) surface.DrawRect(0, 0, w, h)
	end

	frame:MakePopup()

	local header = vgui.Create("DPanel", frame)
	header:Dock(TOP)
	header:DockMargin(0, 0, 0, 0)
	header:SetTall(40)
	header.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.TS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(Diablos.TS.Colors.Header) surface.DrawRect(0, h - 4, w, 4)

		draw.SimpleText(Diablos.TS:GetLanguageString("treadmillFrameTitle"), "Diablos:Font:TS:30", 5, (h - 4) / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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

	local trainingInfo = vgui.Create("DPanel", docker)
	trainingInfo:Dock(TOP)
	trainingInfo:DockPadding(0, 0, 0, 0)
	trainingInfo:DockMargin(0, 0, 0, 10)
	trainingInfo:SetTall(60)
	trainingInfo.Paint = function(s, w, h)
		draw.SimpleText(Diablos.TS:GetLanguageString("treadmillChooseExerciceTip1"), "Diablos:Font:TS:30", w / 2, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(Diablos.TS:GetLanguageString("treadmillChooseExerciceTip2"), "Diablos:Font:TS:25", w / 2, h, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end

	local SIZE_HEIGHT = 220

	local buttonPanel = vgui.Create("DPanel", docker)
	buttonPanel:Dock(TOP)
	buttonPanel:DockPadding(0, 0, 0, 0)
	buttonPanel:DockMargin(0, 0, 0, 10)
	buttonPanel:SetTall(SIZE_HEIGHT)
	buttonPanel.Paint = function(s, w, h)

	end

	local SIZE_MATERIAL_ICON = 100

	if Diablos.TS.RunningSpeedEnabled then
		local runningSpeedData = Diablos.TS.RunningSpeedEquivalence[ent:GetAngle()]

		local dockButton = LEFT
		if not Diablos.TS.StaminaEnabled then
			dockButton = FILL
		end

		local speedExercice = vgui.Create("DButton", buttonPanel)
		speedExercice:Dock(dockButton)
		speedExercice:DockMargin(0, 0, 0, 0)
		speedExercice:SetText("")
		speedExercice:SetFont("Diablos:Font:TS:35")
		speedExercice:SetWide(310)
		speedExercice.Paint = function(s, w, h)
			local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Colors.bl, Diablos.TS.Colors.bl2, Diablos.TS.Colors.bl3, true)
			surface.SetDrawColor(curColor)
			surface.DrawRect(0, 0, w, h)

			draw.SimpleText(Diablos.TS:GetLanguageString("quickExerciceSpeed"), "Diablos:Font:TS:25", w / 2, 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			draw.SimpleText(string.format("%s: %u %s", Diablos.TS:GetLanguageString("runningTime"), runningSpeedData.time, Diablos.TS:GetLanguageString("seconds")), "Diablos:Font:TS:20", w / 2, 40, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)


			draw.SimpleText(string.format("%s: %4.2f %s/%s", Diablos.TS:GetLanguageString("increaseSpeed"), runningSpeedData.speedIncrement, Diablos.TS:GetSpeedText(), Diablos.TS:GetLanguageString("key")), "Diablos:Font:TS:15", w / 2, 70, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			local decrementPerSecond = 1 / runningSpeedData.speedDecrementTime
			local decreaseSpeed = runningSpeedData.speedDecrement * decrementPerSecond
			draw.SimpleText(string.format("%s: %4.2f %s/s", Diablos.TS:GetLanguageString("decreaseSpeed"), decreaseSpeed, Diablos.TS:GetSpeedText()), "Diablos:Font:TS:15", w / 2, 90, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			surface.SetDrawColor(color_white)
			surface.SetMaterial(Diablos.TS.Materials.runningSpeed)
			surface.DrawTexturedRect(w / 2 - SIZE_MATERIAL_ICON / 2, h - SIZE_MATERIAL_ICON - 5, SIZE_MATERIAL_ICON, SIZE_MATERIAL_ICON)
		end
		speedExercice.DoClick = function(s)
			net.Start("TPTSA:BeginTraining")
				net.WriteEntity(ent)
				net.WriteUInt(0, 5) -- type of exercice
			net.SendToServer()
			frame:Close()
		end
	end

	if Diablos.TS.StaminaEnabled then
		local staminaData = Diablos.TS.StaminaEquivalence[ent:GetAngle()]

		local dockButton = RIGHT
		if not Diablos.TS.RunningSpeedEnabled then
			dockButton = FILL
		end

		local staminaExercice = vgui.Create("DButton", buttonPanel)
		staminaExercice:Dock(dockButton)
		staminaExercice:DockMargin(0, 0, 0, 0)
		staminaExercice:SetText("")
		staminaExercice:SetFont("Diablos:Font:TS:35")
		staminaExercice:SetWide(310)
		staminaExercice.Paint = function(s, w, h)
			local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Colors.bl, Diablos.TS.Colors.bl2, Diablos.TS.Colors.bl3, true)
			surface.SetDrawColor(curColor)
			surface.DrawRect(0, 0, w, h)

			draw.SimpleText(Diablos.TS:GetLanguageString("longExerciceStamina"), "Diablos:Font:TS:25", w / 2, 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			draw.SimpleText(string.format("%s: %u %s", Diablos.TS:GetLanguageString("runningTime"), staminaData.time, Diablos.TS:GetLanguageString("seconds")), "Diablos:Font:TS:20", w / 2, 40, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)


			draw.SimpleText(string.format("%s: %4.2f %s/%s", Diablos.TS:GetLanguageString("increaseSpeed"), staminaData.speedIncrement, Diablos.TS:GetSpeedText(), Diablos.TS:GetLanguageString("key")), "Diablos:Font:TS:15", w / 2, 70, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			local decrementPerSecond = 1 / staminaData.speedDecrementTime
			local decreaseSpeed = staminaData.speedDecrement * decrementPerSecond

			draw.SimpleText(string.format("%s: %4.2f %s/s", Diablos.TS:GetLanguageString("decreaseSpeed"), decreaseSpeed, Diablos.TS:GetSpeedText()), "Diablos:Font:TS:15", w / 2, 90, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

			surface.SetDrawColor(color_white)
			surface.SetMaterial(Diablos.TS.Materials.stamina)
			surface.DrawTexturedRect(w / 2 - SIZE_MATERIAL_ICON / 2, h - SIZE_MATERIAL_ICON - 5, SIZE_MATERIAL_ICON, SIZE_MATERIAL_ICON)
		end
		staminaExercice.DoClick = function()
			net.Start("TPTSA:BeginTraining")
				net.WriteEntity(ent)
				net.WriteUInt(1, 5) -- type of exercice
			net.SendToServer()
			frame:Close()
		end
	end
end