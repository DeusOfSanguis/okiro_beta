net.Receive("TPTSA:OpenAdminToolgunPanel", function(len, _)

	local ent = net.ReadEntity()
	local typeEnt = net.ReadUInt(3)

	if IsValid(ent) then
		local class = ent:GetClass()
		if class == "diablos_punching_ball" then class = "diablos_punching_base" end
		typeEnt = Diablos.TS:GetIntegerFromEntity(class)
	end

	local className = Diablos.TS:GetEntityFromInteger(typeEnt)
	local niceClassName = Diablos.TS.NiceNames[className]

	local height = 135
	if typeEnt == 4 then
		height = 295
	elseif typeEnt == 5 then
		height = 415
	elseif typeEnt == 6 then
		height = 295
	end


	local frame = vgui.Create("DFrame")
	frame:SetSize(510, height)
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

		draw.SimpleText("ADMIN CONFIGURATION - TRAINING ENTITY", "Diablos:Font:TS:30", 5, (h - 4) / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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

	local globalInfo = vgui.Create("DPanel", docker)
	globalInfo:Dock(TOP)
	globalInfo:DockPadding(0, 0, 0, 0)
	globalInfo:DockMargin(0, 0, 0, 10)
	globalInfo:SetTall(25)
	globalInfo.Paint = function(s, w, h)
		local text = "You are configuring the entity:"
		local wholeText = string.format("%s: %s", text, niceClassName)

		surface.SetFont("Diablos:Font:TS:25")
		local sizextotal = surface.GetTextSize(wholeText)
		local sizexnotent = surface.GetTextSize(text)

		draw.SimpleText(text, "Diablos:Font:TS:25", w / 2 - sizextotal / 2, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText(niceClassName, "Diablos:Font:TS:25", w / 2 - sizextotal / 2 + sizexnotent + 5, 0, Diablos.TS.Colors.gl, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	-- We have a parameter if you configure a treadmill, a dumbbell or a punching ball

	local valueBtn = -1
	if typeEnt == 4 or typeEnt == 5 or typeEnt == 6 then
		local tab
		if typeEnt == 4 then
			tab = Diablos.TS.TreadmillSizeEquivalence
		elseif typeEnt == 5 then
			tab = Diablos.TS.DumbbellSizeEquivalence
		elseif typeEnt == 6 then
			tab = Diablos.TS.PunchingBallSizeEquivalence
		end


		local layout = vgui.Create("DListLayout", docker)
		layout:Dock(TOP)
		layout:DockPadding(0, 0, 0, 0)
		layout:DockMargin(0, 0, 0, 10)


		local buttons = {}
		valueBtn = 0
		for k, value in pairs(tab) do
			local btn = vgui.Create("DButton", layout)
			btn:Dock(TOP)
			btn:DockMargin(0, 0, 0, 10)
			if typeEnt == 4 then
				btn:SetText(string.format("Angle: %u°", value.angle))
			else
				local weightValue = value.kg
				if Diablos.TS.IsLbs then
					weightValue = value.lbs
				end
				btn:SetText(string.format("%u %s", weightValue, Diablos.TS:GetWeightText()))
			end
			btn:SetFont("Diablos:Font:TS:25")
			btn:SetTall(30)
			btn.clicked = false
			btn.Paint = function(s, w, h)
				local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
				s:SetTextColor(curColor)
				if btn.clicked then
					surface.SetDrawColor(Diablos.TS.Colors.bl) surface.DrawRect(0, 0, w, h)
				else
					surface.SetDrawColor(Diablos.TS.Colors.g) surface.DrawRect(0, 0, w, h)
				end
			end
			btn.DoClick = function(s)
				valueBtn = k
				if s.clicked then
					s.clicked = false
					valueBtn = 0
				else
					for _, button in pairs(buttons) do
						button.clicked = false
					end
					s.clicked = true
				end
			end
			table.insert(buttons, btn)
		end

		if IsValid(ent) then
			local bodygroupType = 0
			if typeEnt == 4 then
				bodygroupType = ent:GetAngle()
			else
				bodygroupType = ent:GetWeight()
			end

			valueBtn = bodygroupType
			buttons[bodygroupType].clicked = true
		end
	end

	local buttonBottomPanel = vgui.Create("DPanel", docker)
	buttonBottomPanel:Dock(TOP)
	buttonBottomPanel:DockPadding(0, 0, 0, 0)
	buttonBottomPanel:DockMargin(0, 0, 0, 0)
	buttonBottomPanel:SetTall(40)
	buttonBottomPanel.Paint = function(s, w, h)

	end

	if IsValid(ent) then

		local edit = vgui.Create("DButton", buttonBottomPanel)
		edit:Dock(LEFT)
		edit:DockMargin(0, 0, 0, 0)
		edit:SetText("EDIT")
		edit:SetFont("Diablos:Font:TS:35")
		edit:SetWide(200)
		edit.Paint = function(s, w, h)
			local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
			s:SetTextColor(curColor)
			if valueBtn != 0 then
				surface.SetDrawColor(Diablos.TS.Colors.g) surface.DrawRect(0, 0, w, h)
			else
				surface.SetDrawColor(Diablos.TS.Colors.rl) surface.DrawRect(0, 0, w, h)
			end
		end
		edit.DoClick = function()
			if valueBtn != 0 then
				net.Start("TPTSA:SaveAdminEntity")
					net.WriteUInt(0, 3) -- only for creation
					net.WriteUInt(valueBtn, 8) -- if information have changed, then we save them
					net.WriteEntity(ent)
					net.WriteBool(true) -- true = edit / false = remove
				net.SendToServer()
				frame:Close()
			end
		end

		local remove = vgui.Create("DButton", buttonBottomPanel)
		remove:Dock(RIGHT)
		remove:DockMargin(0, 0, 0, 0)
		remove:SetText("REMOVE")
		remove:SetFont("Diablos:Font:TS:35")
		remove:SetWide(200)
		remove.Paint = function(s, w, h)
			local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
			s:SetTextColor(curColor)
			surface.SetDrawColor(Diablos.TS.Colors.g) surface.DrawRect(0, 0, w, h)
		end
		remove.DoClick = function()
			net.Start("TPTSA:SaveAdminEntity")
				net.WriteUInt(0, 3) -- only for creation
				net.WriteUInt(0, 8) -- only for creation / edition
				net.WriteEntity(ent)
				net.WriteBool(false) -- true = edit / false = remove
			net.SendToServer()
			frame:Close()
		end

	else

		local save = vgui.Create("DButton", buttonBottomPanel)
		save:Dock(FILL)
		save:DockMargin(0, 0, 0, 0)
		save:SetText("SAVE")
		save:SetFont("Diablos:Font:TS:35")
		save.Paint = function(s, w, h)
			local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
			s:SetTextColor(curColor)
			if valueBtn != 0 then
				surface.SetDrawColor(Diablos.TS.Colors.g) surface.DrawRect(0, 0, w, h)
			else
				surface.SetDrawColor(Diablos.TS.Colors.rl) surface.DrawRect(0, 0, w, h)
			end
		end
		save.DoClick = function()
			if valueBtn != 0 then
				net.Start("TPTSA:SaveAdminEntity")
					net.WriteUInt(typeEnt, 3)
					net.WriteUInt(valueBtn, 8)
					net.WriteEntity(nil)
					net.WriteBool(false) -- true = edit / false = remove
				net.SendToServer()
				frame:Close()
			end
		end

	end
end)