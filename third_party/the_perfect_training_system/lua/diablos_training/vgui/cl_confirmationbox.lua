function Diablos.TS:OpenConfirmationBoxPanel(ply, func)

	local frame = vgui.Create("DFrame")
	frame:SetSize(600, 180)
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

		draw.SimpleText(Diablos.TS:GetLanguageString("confirmationBox"), "Diablos:Font:TS:30", 5, (h - 4) / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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
	trainingInfo:SetTall(40)
	trainingInfo.Paint = function(s, w, h)
		draw.SimpleText(Diablos.TS:GetLanguageString("areYouSure"), "Diablos:Font:TS:35", w / 2, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end


	local buttonPanel = vgui.Create("DPanel", docker)
	buttonPanel:Dock(BOTTOM)
	buttonPanel:DockPadding(0, 0, 0, 0)
	buttonPanel:DockMargin(0, 0, 0, 0)
	buttonPanel:SetTall(70)
	buttonPanel.Paint = function(s, w, h) end


	local yes = vgui.Create("DButton", buttonPanel)
	yes:Dock(LEFT)
	yes:DockMargin(0, 0, 0, 0)
	yes:SetText(Diablos.TS:GetLanguageString("yes"))
	yes:SetFont("Diablos:Font:TS:65")
	yes:SetWidth(250)
	yes.Paint = function(s, w, h)
		local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
		s:SetTextColor(curColor)

		surface.SetDrawColor(Diablos.TS.Colors.g)
		surface.DrawRect(0, 0, w, h)
	end
	yes.DoClick = function(s)
		func()
		frame:Close()
	end

	local no = vgui.Create("DButton", buttonPanel)
	no:Dock(RIGHT)
	no:DockMargin(0, 0, 0, 0)
	no:SetText(Diablos.TS:GetLanguageString("no"))
	no:SetFont("Diablos:Font:TS:65")
	no:SetWidth(250)
	no.Paint = function(s, w, h)
		local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
		s:SetTextColor(curColor)

		surface.SetDrawColor(Diablos.TS.Colors.r)
		surface.DrawRect(0, 0, w, h)
	end
	no.DoClick = function(s)
		frame:Close()
	end
end