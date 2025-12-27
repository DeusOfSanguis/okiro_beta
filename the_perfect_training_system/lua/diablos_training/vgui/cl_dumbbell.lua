function Diablos.TS:OpenDumbbellPanel(ply, ent)

	local trainingWeight = ent:GetWeight()
	local trainingData = Diablos.TS.DumbbellSizeEquivalence[trainingWeight]

	local frame = vgui.Create("DFrame")
	frame:SetSize(800, 500)
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

		draw.SimpleText(Diablos.TS:GetLanguageString("dumbbellFrameTitle"), "Diablos:Font:TS:30", 5, (h - 4) / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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
	docker.Paint = function(s, w, h)

	end

	local trainingInfo = vgui.Create("DPanel", docker)
	trainingInfo:Dock(TOP)
	trainingInfo:DockPadding(0, 0, 0, 0)
	trainingInfo:DockMargin(0, 0, 0, 10)
	trainingInfo:SetTall(60)
	trainingInfo.Paint = function(s, w, h)
		draw.SimpleText(Diablos.TS:GetLanguageString("dumbbellChooseExerciceTip1"), "Diablos:Font:TS:30", w / 2, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(Diablos.TS:GetLanguageString("dumbbellChooseExerciceTip2"), "Diablos:Font:TS:25", w / 2, h, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end

	local SIZE_HEIGHT = 310

	local buttonPanel = vgui.Create("DPanel", docker)
	buttonPanel:Dock(TOP)
	buttonPanel:DockPadding(0, 0, 0, 0)
	buttonPanel:DockMargin(0, 0, 0, 10)
	buttonPanel:SetTall(SIZE_HEIGHT)
	buttonPanel.Paint = function(s, w, h) end

	local dumbbellType = vgui.Create("DPanel", buttonPanel)
	dumbbellType:Dock(LEFT)
	dumbbellType:DockMargin(0, 0, 0, 0)
	dumbbellType:DockPadding(10, 10, 10, 10)
	dumbbellType:SetWide(200)
	dumbbellType.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.TS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(Diablos.TS.Colors.Header) surface.DrawRect(0, h - 4, w, 4)

		draw.SimpleText(Diablos.TS:GetLanguageString("yourChoice"), "Diablos:Font:TS:35", w / 2, 5, Diablos.TS.Colors.bl, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)


		local weightValue = trainingData.kg
		if Diablos.TS.IsLbs then
			weightValue = trainingData.lbs
		end
		draw.SimpleText(string.format("%u %s", weightValue, Diablos.TS:GetWeightText()), "Diablos:Font:TS:35", w / 2, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

		local dataKeyText = string.format("%u %s", trainingData.nbKeys, Diablos.TS:GetLanguageString("keys"))
		local dataSecText = string.format("%u %s", trainingData.time, Diablos.TS:GetLanguageString("seconds"))
		draw.SimpleText(dataKeyText, "Diablos:Font:TS:20", 5, 45, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(dataSecText, "Diablos:Font:TS:20", 5, 65, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

		local keyPerSecond = trainingData.nbKeys / trainingData.time
		draw.SimpleText(string.format("%4.2f %s/s", keyPerSecond, Diablos.TS:GetLanguageString("key")), "Diablos:Font:TS:20", w - 5, 45, Diablos.TS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	end

	local icon = vgui.Create("DModelPanel", dumbbellType)
	icon:Dock(TOP)
	icon:DockMargin(0, 10, 0, 50)
	icon:SetTall(250)
	icon:SetModel("models/tptsa/dumbbell/dumbbell.mdl")
	icon.Entity:SetBodygroup(0, trainingWeight - 1)
	Diablos.TS:UpdateRenderBounds(icon, 30)

	local otherChoices = vgui.Create("DPanel", buttonPanel)
	otherChoices:Dock(RIGHT)
	otherChoices:DockMargin(0, 0, 0, 0)
	otherChoices:DockPadding(0, 0, 0, 0)
	otherChoices:SetWide(500)
	otherChoices.Paint = function(s, w, h) end


	local horizontalPanel

	local i = 0
	local amountEntitiesShown = 0
	for k,v in ipairs(Diablos.TS.DumbbellSizeEquivalence) do
		if k == trainingWeight then continue end
		amountEntitiesShown = amountEntitiesShown + 1

		local marginLeft = 0
		if amountEntitiesShown % 3 == 1 then
			horizontalPanel = vgui.Create("DPanel", otherChoices)
			horizontalPanel:Dock(TOP)
			horizontalPanel:DockPadding(0, 0, 0, 0)
			horizontalPanel:DockMargin(0, 0, 0, 10)
			horizontalPanel:SetTall(SIZE_HEIGHT / 2 - 5)
			horizontalPanel.Paint = function(s, w, h) end

			i = i + 1
			marginLeft = 0
		end


		local otherDumbbellType = vgui.Create("DPanel", horizontalPanel)
		otherDumbbellType:Dock(LEFT)
		otherDumbbellType:DockPadding(0, 0, 0, 0)
		otherDumbbellType:DockMargin(marginLeft, 0, 80, 0)
		otherDumbbellType:SetWide(115)
		otherDumbbellType:SetTall(SIZE_HEIGHT / 2 - 5)
		otherDumbbellType.Paint = function(s, w, h)
			surface.SetDrawColor(Diablos.TS.Colors.FrameLeft) surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(Diablos.TS.Colors.rl) surface.DrawRect(0, h - 4, w, 4)

			local weightValue = v.kg
			if Diablos.TS.IsLbs then
				weightValue = v.lbs
			end
			draw.SimpleText(string.format("%u %s", weightValue, Diablos.TS:GetWeightText()), "Diablos:Font:TS:25", w / 2, h - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

			local dataKeyText = string.format("%u %s", v.nbKeys, Diablos.TS:GetLanguageString("keys"))
			local dataSecText = string.format("%u %s", v.time, Diablos.TS:GetLanguageString("seconds"))
			draw.SimpleText(dataKeyText, "Diablos:Font:TS:15", 5, 5, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText(dataSecText, "Diablos:Font:TS:15", 5, 20, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			local keyPerSecond = v.nbKeys / v.time
			draw.SimpleText(string.format("%4.2f %s/s", keyPerSecond, Diablos.TS:GetLanguageString("key")), "Diablos:Font:TS:15:I", w / 2, 35, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local otherIcon = vgui.Create("DModelPanel", otherDumbbellType)
		otherIcon:Dock(TOP)
		otherIcon:SetTall(SIZE_HEIGHT / 2)
		otherIcon:SetModel("models/tptsa/dumbbell/dumbbell.mdl")
		otherIcon.Entity:SetBodygroup(0, k - 1)
		Diablos.TS:UpdateRenderBounds(otherIcon, 40)
	end

	local startTraining = vgui.Create("DButton", docker)
	startTraining:Dock(TOP)
	startTraining:DockMargin(0, 0, 0, 0)
	startTraining:SetText(Diablos.TS:GetLanguageString("trainNow"))
	startTraining:SetFont("Diablos:Font:TS:35")
	startTraining:SetTall(50)
	startTraining.Paint = function(s, w, h)
		local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
		s:SetTextColor(curColor)
		surface.SetDrawColor(Diablos.TS.Colors.g) surface.DrawRect(0, 0, w, h)
	end
	startTraining.DoClick = function(s)
		local blocklistNumber = Diablos.TS:GetKeyReference(Diablos.TS:GetKeyNameReference(Diablos.TS.StopTrainingKey))
		net.Start("TPTSA:BeginTraining")
			net.WriteEntity(ent)
			net.WriteUInt(blocklistNumber, 5) -- blocklisted number (stop training key)
		net.SendToServer()
		frame:Close()
	end
end