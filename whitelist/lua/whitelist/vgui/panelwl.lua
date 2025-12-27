local PANEL = {}
local frame = nil
local storage = {}

local COLORS = {
	BACKGROUND = Color(40, 40, 40, 255),
	BACKGROUND_DARK = Color(30, 30, 30, 255),
	TEXT = Color(230, 230, 230, 255),
	TEXT_DARK = Color(50, 50, 50, 255),
	HIGHLIGHT = Color(70, 70, 70, 255),
	ACCENT = Color(120, 120, 120, 255)
}

local function CreateFonts()
	gCreateRespFont("Okiro.WL.Normal", "Arial", 16, 400)
	gCreateRespFont("Okiro.WL.Button", "Arial", 18, 600)
	gCreateRespFont("Okiro.WL.Title", "Arial", 20, 800)
end

hook.Add("Initialize", "Okiro:Whitelist:CreateFonts", CreateFonts)
hook.Add("OnScreenSizeChanged", "Okiro:Whitelist:RecreateWLFonts", CreateFonts)

function PANEL:Init()
	self:gSetSize(1280, 690)
	self:ShowCloseButton(false)
	self:SetDraggable(true)
	self:SetTitle("")
	self:MakePopup()
	self:Center()

	self:SetPaintBackgroundEnabled(false)

	self.CloseButton = vgui.Create("DButton", self)
	self.CloseButton:gSetSize(24, 24)
	self.CloseButton:gSetPos(1252, 3)
	self.CloseButton:SetText("X")
	self.CloseButton.Paint = function() end
	self.CloseButton.DoClick = function()
		self:Close()
	end

	self.ResponsiveManager = function()
		if IsValid(self) then
			self:gSetSize(1280, 690)
			self:Center()
		end

		if IsValid(self.CloseButton) then
			self.CloseButton:gSetPos(1252, 3)
		end

		if IsValid(self.SearchLabel) then
			self.SearchLabel:gSetPos(35, 65)
			self.SearchLabel:SizeToContents()
		end

		if IsValid(self.Search) then
			self.Search:gSetPos(120, 60)
			self.Search:gSetSize(1140, 30)
		end

		if IsValid(self.List) then
			self.List:gSetPos(20, 100)
			self.List:gSetSize(1240, 520)
		end

		if IsValid(self.Entry) then
			self.Entry:gSetPos(20, 630)
			self.Entry:gSetSize(500, 40)
		end

		if IsValid(self.NameEntry) then
			self.NameEntry:gSetPos(530, 630)
			self.NameEntry:gSetSize(490, 40)
		end

		if IsValid(self.AddButton) then
			self.AddButton:gSetPos(1030, 630)
			self.AddButton:gSetSize(230, 40)
		end
	end

	hook.Add("OnScreenSizeChanged", self, self.ResponsiveManager)

	self.SearchLabel = vgui.Create("DLabel", self)
	self.SearchLabel:gSetPos(35, 65)
	self.SearchLabel:SetText("Recherche :")
	self.SearchLabel:SetFont("Okiro.WL.Normal")
	self.SearchLabel:SetTextColor(COLORS.TEXT)
	self.SearchLabel:SizeToContents()

	self.Search = vgui.Create("DTextEntry", self)
	self.Search:gSetPos(120, 60)
	self.Search:gSetSize(1140, 30)
	self.Search:SetPlaceholderText("Rechercher un SteamID...")
	self.Search:SetFont("Okiro.WL.Normal")
	self.Search:SetTextColor(COLORS.TEXT)
	self.Search.OnChange = function(self)
		if IsValid(frame) then
			frame:FilterList(self:GetValue())
		end
	end
	self.Search.Paint = function(self, w, h)
		draw.RoundedBox(8, 0, 0, w, h, COLORS.BACKGROUND_DARK)
		self:DrawTextEntryText(COLORS.TEXT, COLORS.HIGHLIGHT, COLORS.TEXT)

		if self:GetText() == "" and self:GetPlaceholderText() then
			draw.SimpleText(self:GetPlaceholderText(), self:GetFont(), gRespX(5), gRespY(h/2), COLORS.TEXT_DARK, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end

	self.List = vgui.Create("DListView", self)
	self.List:gSetPos(20, 100)
	self.List:gSetSize(1240, 520)
	self.List:SetMultiSelect(false)
	self.List:AddColumn("SteamID")
	self.List:AddColumn("Nom")
	self.List:SetHeaderHeight(30)
	self.List:SetSortable(true)

	self.List.Paint = function(self, w, h)
		draw.RoundedBox(8, 0, 0, w, h, COLORS.BACKGROUND_DARK)
	end

	if self.List.Columns and self.List.Columns[1] and self.List.Columns[1].Header then
		self.List.Columns[1].Header:SetFont("Okiro.WL.Button")
		self.List.Columns[1].Header:SetTextColor(COLORS.TEXT)

		self.List.Columns[1].Header.Paint = function(self, w, h)
			draw.RoundedBoxEx(8, 0, 0, w, h, COLORS.ACCENT, true, false, false, false)
		end
	end
	
	if self.List.Columns and self.List.Columns[2] and self.List.Columns[2].Header then
		self.List.Columns[2].Header:SetFont("Okiro.WL.Button")
		self.List.Columns[2].Header:SetTextColor(COLORS.TEXT)

		self.List.Columns[2].Header.Paint = function(self, w, h)
			draw.RoundedBoxEx(8, 0, 0, w, h, COLORS.ACCENT, false, true, false, false)
		end
	end

	local oldAddLine = self.List.AddLine
	function self.List:AddLine(...)
		local line = oldAddLine(self, ...)
		if IsValid(line) then
			line.Paint = function(self, w, h)
				if self:IsSelected() then
					draw.RoundedBox(0, 0, 0, w, h, COLORS.HIGHLIGHT)
				elseif self:IsHovered() then
					draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
				elseif self.m_iID % 2 == 1 then
					draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35))
				else
					draw.RoundedBox(0, 0, 0, w, h, COLORS.BACKGROUND_DARK)
				end
			end

			for _, column in pairs(line.Columns) do
				column:SetTextColor(COLORS.TEXT)
			end
		end
		return line
	end

	self.Entry = vgui.Create("DTextEntry", self)
	self.Entry:gSetPos(20, 630)
	self.Entry:gSetSize(500, 40)
	self.Entry:SetPlaceholderText("Entrez un SteamID64...")
	self.Entry:SetFont("Okiro.WL.Normal")
	self.Entry:SetTextColor(COLORS.TEXT)
	self.Entry.Paint = function(self, w, h)
		draw.RoundedBox(8, 0, 0, w, h, COLORS.BACKGROUND_DARK)
		self:DrawTextEntryText(COLORS.TEXT, COLORS.HIGHLIGHT, COLORS.TEXT)

		if self:GetText() == "" and self:GetPlaceholderText() then
			draw.SimpleText(self:GetPlaceholderText(), self:GetFont(), gRespX(5), gRespY(h/2), COLORS.TEXT_DARK, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
	
	self.NameEntry = vgui.Create("DTextEntry", self)
	self.NameEntry:gSetPos(530, 630)
	self.NameEntry:gSetSize(490, 40)
	self.NameEntry:SetPlaceholderText("Nom du joueur (optionnel)")
	self.NameEntry:SetFont("Okiro.WL.Normal")
	self.NameEntry:SetTextColor(COLORS.TEXT)
	self.NameEntry.Paint = function(self, w, h)
		draw.RoundedBox(8, 0, 0, w, h, COLORS.BACKGROUND_DARK)
		self:DrawTextEntryText(COLORS.TEXT, COLORS.HIGHLIGHT, COLORS.TEXT)

		if self:GetText() == "" and self:GetPlaceholderText() then
			draw.SimpleText(self:GetPlaceholderText(), self:GetFont(), gRespX(5), gRespY(h/2), COLORS.TEXT_DARK, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end

	self.AddButton = vgui.Create("DButton", self)
	self.AddButton:gSetPos(1030, 630)
	self.AddButton:gSetSize(230, 40)
	self.AddButton:SetText("Ajouter à la whitelist")
	self.AddButton:SetFont("Okiro.WL.Button")
	self.AddButton:SetTextColor(COLORS.TEXT)
	self.AddButton.Paint = function(self, w, h)
		local bgColor = self:IsHovered() and COLORS.HIGHLIGHT or COLORS.ACCENT
		draw.RoundedBox(8, 0, 0, w, h, bgColor)
	end
	self.AddButton.DoClick = function()
		local steamid = self.Entry:GetValue()
		if not steamid then return end

		steamid = string.Trim(steamid)
		if steamid:len() < 10 then return end
		
		local name = self.NameEntry:GetValue()
		name = string.Trim(name or "")

		net.Start("Okiro:Whitelist:AddToWhitelist")
			net.WriteString(steamid)
			net.WriteString(name)
		net.SendToServer()
		
		self.Entry:SetValue("")
		self.NameEntry:SetValue("")
	end

	self.List.OnRowRightClick = function(panel, lineID, line)
		if not IsValid(line) then return end

		local menu = DermaMenu()
		local option = menu:AddOption("Supprimer de la whitelist", function()
			local steamid = line:GetValue(1)
			if not steamid or steamid == "" then return end

			net.Start("Okiro:Whitelist:RemoveFromWhitelist")
				net.WriteString(steamid)
			net.SendToServer()
		end)

		if IsValid(option) then
			option:SetFont("Okiro.WL.Normal")
			option:SetTextColor(COLORS.TEXT_DARK)
		end

		menu:Open()
	end

	net.Start("Okiro:Whitelist:RequestWlList")
	net.SendToServer()

	self:gFadeIn(0.5)
end

function PANEL:Paint(w, h)
	draw.RoundedBoxEx(8, 0, 0, w, h, COLORS.BACKGROUND, true, true, true, true)
	draw.RoundedBoxEx(8, 0, 0, w, gRespY(30), COLORS.ACCENT, true, true, false, false)
	draw.SimpleText("Okiro - Whitelist", "Okiro.WL.Title", gRespX(10), gRespY(15), COLORS.TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:FilterList(searchText)
	if not IsValid(self.List) then return end
	if not storage or type(storage) ~= "table" then return end

	self.List:Clear()
	searchText = string.lower(searchText or "")

	for _, data in ipairs(storage) do
		if type(data) == "table" and data.steamid then
			local steamid = tostring(data.steamid)
			local name = tostring(data.name or "")
			
			if searchText == "" or 
			   string.find(string.lower(steamid), searchText, 1, true) or
			   string.find(string.lower(name), searchText, 1, true) then
				self.List:AddLine(steamid, name)
			end
		end
	end
end

function PANEL:Think()
	if not IsValid(self.List) then return end
	if not storage or type(storage) ~= "table" or #storage == 0 then return end
	if not self.List.GetLineCount or type(self.List.GetLineCount) ~= "function" then return end

	if self.List:GetLineCount() == 0 and (not self.Search or self.Search:GetValue() == "") then
		self:RefreshList()
	end
end

function PANEL:RefreshList()
	if not IsValid(self.List) then return end
	if not storage or type(storage) ~= "table" then return end

	self.List:Clear()

	for _, data in ipairs(storage) do
		if type(data) == "table" and data.steamid then
			self.List:AddLine(data.steamid, data.name or "")
		end
	end
end

function PANEL:OnRemove()
	hook.Remove("OnScreenSizeChanged", self)
end

function PANEL:Close()
	if IsValid(self) then
		self:gFadeOut(0.5, 0, function()
			self:Remove()
		end)
	end
end

vgui.Register("okiroPanelWl", PANEL, "DFrame")

net.Receive("Okiro:Whitelist:SendWlList", function()
	local jsonData = net.ReadString()
	if not jsonData or jsonData == "" then
		storage = {}
		return
	end

	local success, result = pcall(util.JSONToTable, jsonData)
	if not success or not result then
		storage = {}
		return
	end

	storage = result

	if IsValid(frame) and frame.RefreshList and type(frame.RefreshList) == "function" then
		frame:RefreshList()
	end
end)

net.Receive("Okiro:Whitelist:NotifyError", function()
	local errorMsg = net.ReadString()
	notification.AddLegacy(errorMsg, NOTIFY_ERROR, 5)
	surface.PlaySound("buttons/button10.wav")
end)

net.Receive("Okiro:Whitelist:NotifySuccess", function()
	local msg = net.ReadString()
	notification.AddLegacy(msg, NOTIFY_GENERIC, 5)
	surface.PlaySound("buttons/button14.wav")
end)

hook.Add("OnPlayerChat", "Okiro:Whitelist:CallPanelWl", function(ply, text)
	if not IsValid(ply) or not ply:Alive() then return end
	if ply != LocalPlayer() then return end
	if not ply:IsSuperAdmin() then return end

	local lowerText = string.lower(text)
	if lowerText == "/okirowl" or lowerText == "!okirowl" then
		if IsValid(frame) then
			frame:Close()
		end
		frame = vgui.Create("okiroPanelWl")
		return true
	end
end)