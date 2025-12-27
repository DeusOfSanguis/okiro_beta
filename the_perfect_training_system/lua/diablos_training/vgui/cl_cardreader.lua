function Diablos.TS:OpenCardReaderPlayerPanel(ply, ent, subPrice)

	local frame = vgui.Create("DFrame")
	frame:SetSize(800, 350)
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

		draw.SimpleText(string.format("%s - %s", Diablos.TS:GetLanguageString("cardReaderTitle"), Diablos.TS:GetLanguageString("cardReaderPurchaseSub")), "Diablos:Font:TS:30", 5, (h - 4) / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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

	local subDate = ply:TSGetTrainingSubscription()

	local explanationPanel = vgui.Create("DPanel", docker)
	explanationPanel:Dock(TOP)
	explanationPanel:DockPadding(0, 0, 0, 0)
	explanationPanel:DockMargin(0, 0, 0, 10)
	explanationPanel:SetTall(240)
	explanationPanel.Paint = function(s, w, h)
		draw.SimpleText(Diablos.TS:GetLanguageString("cardReaderPurchaseSubTip1"), "Diablos:Font:TS:30", w / 2, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		local sizeIcon = 60
		local priceText = Diablos.TS:GetCurrencyFormatType(subPrice)
		if priceText == 0 then
			priceText = Diablos.TS:GetLanguageString("free")
		end

		surface.SetFont("Diablos:Font:TS:45:B")
		local sizexprice = surface.GetTextSize(priceText)
		local sizetotal = sizeIcon + sizexprice

		draw.SimpleText(priceText, "Diablos:Font:TS:45:B", w / 2 - sizetotal / 2 + sizeIcon + 5, 40 + sizeIcon / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)


		surface.SetDrawColor(color_white)
		surface.SetMaterial(Diablos.TS.Materials.price)
		surface.DrawTexturedRect(w / 2 - sizetotal / 2, 40, sizeIcon, sizeIcon)

		sizeIcon = 100 -- Middle arrow size

		-- Left side
		local dateText
		if subDate == 0 then
			dateText = Diablos.TS:GetLanguageString("neverSubscribed")
		else
			dateText = os.date(Diablos.TS:GetOSFormat(), math.max(subDate, os.time()))
			if not ply:TSHasTrainingSubscription() then
				local previousSubText = string.format("%s:", Diablos.TS:GetLanguageString("previousSub"))
				surface.SetFont("Diablos:Font:TS:25:I")
				local sizexprevioussub = surface.GetTextSize(previousSubText)

				draw.SimpleText(previousSubText, "Diablos:Font:TS:25:I", 10, 160 + sizeIcon / 2 + 5, Diablos.TS.Colors.bl, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				draw.SimpleText(os.date(Diablos.TS:GetOSFormat(), subDate), "Diablos:Font:TS:25:I", 10 + sizexprevioussub + 5, 160 + sizeIcon / 2 + 5 + 1, Diablos.TS.Colors.rl, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			end
		end

		draw.SimpleText(dateText, "Diablos:Font:TS:45", 10, 160, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		-- Right side
		local timeAdded = Diablos.TS.SubTime * 60 * 60
		local niceTimeAdded = Diablos.TS:NiceTimeFormat(timeAdded)
		local newDate = os.date(Diablos.TS:GetOSFormat(), math.max(os.time(), subDate) + timeAdded)
		draw.SimpleText(newDate, "Diablos:Font:TS:45", w - 10, 160, Diablos.TS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)


		-- Middle arrow

		surface.SetMaterial(Diablos.TS.Materials.rightArrow)
		surface.DrawTexturedRect(w / 2 - sizeIcon / 2, 160 - sizeIcon / 2, sizeIcon, sizeIcon)


		draw.SimpleText(niceTimeAdded, "Diablos:Font:TS:30:I", w / 2, 160 + sizeIcon / 2 + 5, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	if ply:TSCanPurchaseTrainingSubscription() then

		local apply = vgui.Create("DButton", docker)
		apply:Dock(TOP)
		apply:DockMargin(0, 0, 0, 0)
		apply:SetText(Diablos.TS:GetLanguageString("cardReaderPurchaseSub"))
		apply:SetFont("Diablos:Font:TS:35")
		apply:SetTall(40)
		apply.Paint = function(s, w, h)
			local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
			s:SetTextColor(curColor)
			surface.SetDrawColor(Diablos.TS.Colors.g) surface.DrawRect(0, 0, w, h)
		end
		apply.DoClick = function()
			net.Start("TPTSA:PurchaseSub")
				net.WriteEntity(ent)
			net.SendToServer()
			frame:Close()
		end

	end
end

/*---------------------------------------------------------------------------
	Give a credit
---------------------------------------------------------------------------*/

function Diablos.TS:OpenCardReaderGivePanel(ply, otherPlayer)

	local frame = vgui.Create("DFrame")
	frame:SetSize(700, 370)
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

		draw.SimpleText(string.format("%s - %s", Diablos.TS:GetLanguageString("cardReaderTitle"), Diablos.TS:GetLanguageString("cardReaderGiveCredit")), "Diablos:Font:TS:30", 5, (h - 4) / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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

	local explanationPanel = vgui.Create("DPanel", docker)
	explanationPanel:Dock(TOP)
	explanationPanel:DockPadding(0, 0, 0, 0)
	explanationPanel:DockMargin(0, 0, 0, 10)
	explanationPanel:SetTall(260)
	explanationPanel.Paint = function(s, w, h)
		draw.SimpleText(Diablos.TS:GetLanguageString("cardReaderGiveCreditTip1"), "Diablos:Font:TS:30", w / 2, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(Diablos.TS:GetLanguageString("cardReaderGiveCreditTip2"), "Diablos:Font:TS:25", w / 2, 30, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		local sizey = 150
		local sizex = sizey * 742 / 529
		local posx = 0
		local posy = 80

		surface.SetDrawColor(color_white)

		-- Left side
		surface.SetMaterial(Diablos.TS.Materials.sportbadgeRecto)
		surface.DrawTexturedRect(posx, posy, sizex, sizey)

		surface.SetMaterial(Diablos.TS.Materials.zero)
		surface.DrawTexturedRect(posx + sizex - 30, posy + sizey - 30, 60, 60)

		-- Right side
		posx = w - sizex - 30

		surface.SetMaterial(Diablos.TS.Materials.sportbadgeRecto)
		surface.DrawTexturedRect(posx, posy, sizex, sizey)

		surface.SetMaterial(Diablos.TS.Materials.one)
		surface.DrawTexturedRect(posx + sizex - 30, posy + sizey - 30, 60, 60)

		-- Middle arrow
		sizex = 80
		sizey = 80
		posx = w / 2 - sizex / 2
		posy = posy + sizey / 2

		surface.SetMaterial(Diablos.TS.Materials.rightArrow)
		surface.DrawTexturedRect(posx, posy, sizex, sizey)
	end


	local apply = vgui.Create("DButton", docker)
	apply:Dock(TOP)
	apply:DockMargin(0, 0, 0, 0)
	apply:SetText(Diablos.TS:GetLanguageString("cardReaderGiveCreditBtn"))
	apply:SetFont("Diablos:Font:TS:35")
	apply:SetTall(40)
	apply.Paint = function(s, w, h)
		local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
		s:SetTextColor(curColor)
		surface.SetDrawColor(Diablos.TS.Colors.g) surface.DrawRect(0, 0, w, h)
	end
	apply.DoClick = function()
		net.Start("TPTSA:GiveCreditSub")
			net.WriteEntity(otherPlayer)
		net.SendToServer()
		frame:Close()
	end
end


/*---------------------------------------------------------------------------
	Edit terminal data
---------------------------------------------------------------------------*/

function Diablos.TS:OpenCardReaderEditPanel(ply, ent, subPrice, owners)

	local frame = vgui.Create("DFrame")
	frame:SetSize(900, 360)
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

		draw.SimpleText(string.format("%s - %s", Diablos.TS:GetLanguageString("cardReaderTitle"), Diablos.TS:GetLanguageString("cardReaderEditTerminal")), "Diablos:Font:TS:30", 5, (h - 4) / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
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

	local explanationPanel = vgui.Create("DPanel", docker)
	explanationPanel:Dock(TOP)
	explanationPanel:DockPadding(0, 0, 0, 0)
	explanationPanel:DockMargin(0, 0, 0, 10)
	explanationPanel:SetTall(70)
	explanationPanel.Paint = function(s, w, h)
		draw.SimpleText(Diablos.TS:GetLanguageString("cardReaderEditTerminalTip1"), "Diablos:Font:TS:30", w / 2, 0, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(Diablos.TS:GetLanguageString("cardReaderEditTerminalTip2"), "Diablos:Font:TS:25", w / 2, 30, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	-- [[ Sub price ]] --

	local subPricePanel = vgui.Create("DPanel", docker)
	subPricePanel:Dock(TOP)
	subPricePanel:DockPadding(0, 0, 0, 0)
	subPricePanel:DockMargin(0, 0, 0, 10)
	subPricePanel:SetTall(40)
	subPricePanel.Paint = function(s, w, h)
	end

	local subBadgePrice = vgui.Create("DLabel", subPricePanel)
	subBadgePrice:Dock(LEFT)
	subBadgePrice:SetText(Diablos.TS:GetLanguageString("cardReaderBadgePrice"))
	subBadgePrice:SetFont("Diablos:Font:TS:35")
	subBadgePrice:SetWidth(200)

	local subCurrency = vgui.Create("DLabel", subPricePanel)
	subCurrency:Dock(LEFT)
	subCurrency:DockMargin(175, 0, 10, 0)
	subCurrency:SetText(Diablos.TS:GetCurrencySymbol())
	subCurrency:SetFont("Diablos:Font:TS:30")
	subCurrency:SetWidth(20)


	local subPriceEntry = vgui.Create("DNumberWang", subPricePanel)
	subPriceEntry:Dock(LEFT)
	subPriceEntry:DockMargin(0, 0, 0, 0)
	subPriceEntry:SetMinMax(Diablos.TS.SubMinPrice, Diablos.TS.SubMaxPrice)
	subPriceEntry:SetValue(subPrice)
	subPriceEntry:SetFont("Diablos:Font:TS:35")
	subPriceEntry:SetWide(100)
	subPriceEntry.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.TS.Colors.g)
		surface.DrawRect(0, 0, w, h)
		s:DrawTextEntryText(Diablos.TS.Colors.Label, Diablos.TS.Colors.LabelHovered, Diablos.TS.Colors.LabelDown)
	end
	subPriceEntry.OnValueChanged = function(s, val)

	end

	local subMinPrice = Diablos.TS:GetCurrencyFormatType(Diablos.TS.SubMinPrice)
	local subMaxPrice = Diablos.TS:GetCurrencyFormatType(Diablos.TS.SubMaxPrice)

	-- If there is a "paid" system
	if subMinPrice != "" and subMaxPrice != "" then
		local subPriceInfo = vgui.Create("DLabel", subPricePanel)
		subPriceInfo:Dock(RIGHT)
		subPriceInfo:SetText(string.format(Diablos.TS:GetLanguageString("cardReaderEditTerminalSetPrice"), subMinPrice, subMaxPrice))
		subPriceInfo:SetFont("Diablos:Font:TS:20:I")
		subPriceInfo:SizeToContents()
	end


	-- [[ Owner panel ]] -- 

	local nbCoach = 0

	local ownerPanel = vgui.Create("DScrollPanel", docker)
	ownerPanel:Dock(TOP)
	ownerPanel:DockPadding(0, 0, 0, 0)
	ownerPanel:DockMargin(0, 0, 0, 10)
	ownerPanel:SetTall(120)
	ownerPanel.Paint = function(s, w, h) end
	local ownerPanelVBar = ownerPanel:GetVBar()
	ownerPanelVBar.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.TS.Colors.barBackground)
		surface.DrawRect(5, 0, w - 5, h)
	end
	ownerPanelVBar.btnGrip.Paint = function(s, w, h)
		surface.SetDrawColor(Diablos.TS.Colors.barFill)
		surface.DrawRect(5, 0, w - 5, h)
	end
	ownerPanelVBar.btnUp.Paint = function(s, w, h) end
	ownerPanelVBar.btnDown.Paint = function(s, w, h) end

	local plypos = ply:GetPos()

	local playerLine

	for k,v in ipairs(player.GetAll()) do
		if not v:TSIsSportCoach() then continue end
		local isOwner = owners[v]

		if not isOwner and plypos:DistToSqr(v:GetPos()) > 20000 then continue end

		if nbCoach % 4 == 0 then
			playerLine = vgui.Create("DPanel", ownerPanel)
			playerLine:Dock(TOP)
			playerLine:DockMargin(0, 0, 0, 10)
			-- playerLine:DockPadding(10, 10, 10, 10)
			playerLine:SetTall(120)
			playerLine.Paint = function(s, w, h)

			end
		end

		local owner = vgui.Create("DPanel", playerLine)
		owner:Dock(LEFT)
		owner:DockMargin(0, 0, 10, 0)
		owner:SetWide(213)
		owner.Paint = function(s, w, h)
			surface.SetDrawColor(Diablos.TS.Colors.Panel)
			surface.DrawRect(0, 0, w, h)
		end

		local iconSpace = vgui.Create("DPanel", owner)
		iconSpace:Dock(TOP)
		iconSpace:DockPadding(5, 5, 5, 5)
		iconSpace:DockMargin(0, 0, 0, 0)
		iconSpace:SetTall(100)
		iconSpace.Paint = function(s, w, h)
			if IsValid(v) then
				draw.SimpleText(v:Nick(), "Diablos:Font:TS:25", w - 5, h / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
		end

		local icon = vgui.Create("DModelPanel", iconSpace)
		icon:Dock(LEFT)
		icon:SetModel(v:GetModel())
		Diablos.TS:UpdateRenderBounds(icon, 30)

		local ownerButton = vgui.Create("DButton", owner)
		ownerButton:Dock(BOTTOM)
		ownerButton:DockMargin(0, 0, 0, 0)
		ownerButton:SetTall(25)
		if isOwner then
			ownerButton:SetText(Diablos.TS:GetLanguageString("cardReaderOwnerRemove"))
		else
			ownerButton:SetText(Diablos.TS:GetLanguageString("cardReaderOwnerAdd"))
		end
		ownerButton:SetFont("Diablos:Font:TS:25")
		ownerButton.Paint = function(s, w, h)
			local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
			s:SetTextColor(curColor)

			local colorRedGreen = Diablos.TS.Colors.g
			if owners[v] then
				colorRedGreen = Diablos.TS.Colors.r
			end
			surface.SetDrawColor(colorRedGreen)
			surface.DrawRect(0, 0, w, h)
		end
		ownerButton.DoClick = function(s)
			if owners[v] then
				owners[v] = nil
				ownerButton:SetText(Diablos.TS:GetLanguageString("cardReaderOwnerAdd"))
			else
				owners[v] = true
				ownerButton:SetText(Diablos.TS:GetLanguageString("cardReaderOwnerRemove"))
			end
		end
		nbCoach = nbCoach + 1
	end


	local apply = vgui.Create("DButton", docker)
	apply:Dock(TOP)
	apply:DockMargin(0, 0, 0, 0)
	apply:SetText(Diablos.TS:GetLanguageString("cardReaderApply"))
	apply:SetFont("Diablos:Font:TS:35")
	apply:SetTall(40)
	apply.Paint = function(s, w, h)
		local curColor = Diablos.TS:PaintFunctions(s, Diablos.TS.Label, Diablos.TS.LabelHovered, Diablos.TS.LabelDown)
		s:SetTextColor(curColor)
		surface.SetDrawColor(Diablos.TS.Colors.g) surface.DrawRect(0, 0, w, h)
	end
	apply.DoClick = function()
		local countOwner = table.Count(owners)
		-- Send the new terminal data to the server
		net.Start("TPTSA:SaveSubData")
			net.WriteEntity(ent)
			net.WriteUInt(subPriceEntry:GetValue(), 16)
			net.WriteUInt(countOwner, 8)
			for pl, _ in pairs(owners) do
				net.WriteEntity(pl)
			end
		net.SendToServer()
		frame:Close()
	end
end

/*---------------------------------------------------------------------------
	Called when a player is about to purchase a subscription
	i.e. when taking the training badge and pointing a card reader
---------------------------------------------------------------------------*/

net.Receive("TPTSA:CardReaderPurchase", function(len, _)
	local ply = LocalPlayer()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		local subPrice = net.ReadUInt(16)

		Diablos.TS:OpenCardReaderPlayerPanel(ply, ent, subPrice)
	end
end)

/*---------------------------------------------------------------------------
	Called when a coach is about to edit terminal data
	i.e. when pressing +USE on a card reader
---------------------------------------------------------------------------*/

net.Receive("TPTSA:CardReaderEdit", function(len, _)
	local ply = LocalPlayer()
	local ent = net.ReadEntity()
	if IsValid(ent) then
		local subPrice = net.ReadUInt(16)
		local ownerCount = net.ReadUInt(8)
		local owners = {}
		for i = 1, ownerCount do
			owners[net.ReadEntity()] = true
		end

		Diablos.TS:OpenCardReaderEditPanel(ply, ent, subPrice, owners)
	end
end)

/*---------------------------------------------------------------------------
	Called when a coach is about to give a credit to a player
	i.e. when pressing +USE in front of a player
---------------------------------------------------------------------------*/

net.Receive("TPTSA:CardReaderGive", function(len, _)
	local ply = LocalPlayer()
	local otherPlayer = net.ReadEntity()
	if IsValid(otherPlayer) then
		Diablos.TS:OpenCardReaderGivePanel(ply, otherPlayer)
	end
end)