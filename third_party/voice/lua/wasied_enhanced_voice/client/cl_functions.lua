EVoice.Fonts = {}

-- Automatic responsive functions
RX = RX or function(x) return x / 1920 * ScrW() end
RY = RY or function(y) return y / 1080 * ScrH() end

-- Automatic font-creation function
function EVoice:Font(iSize, iWidth)

	iSize = iSize or 15
	iWidth = iWidth or 500

	local sName = ("EVoice:Font:%i:%i"):format(iSize, iWidth)
	if not EVoice.Fonts[sName] then

		surface.CreateFont(sName, {
			font = "Roboto",
			size = RX(iSize),
			width = iWidth,
			extended = false
		})

		EVoice.Fonts[sName] = true

	end

	return sName

end

-- Create the radio channel interface
function EVoice:CreateChannel()

	if IsValid(self.vRadioFrame) then
		self.vRadioFrame:Remove()
	end

	local vFrame = vgui.Create("DFrame")
	vFrame:SetSize(RX(400), RY(250))
	vFrame:Center()
	vFrame:SetTitle("")
	vFrame:MakePopup()
	vFrame:ShowCloseButton(false)
	vFrame:SetDraggable(false)
	function vFrame:Paint(w, h)

		draw.RoundedBox(8, 0, 0, w, h, Color(21, 28, 36))

		draw.SimpleText(EVoice.Config.Language[5], EVoice:Font(40), w / 2, RY(50), color_white, 1, 1)
		draw.SimpleText(EVoice.Config.Language[6], EVoice:Font(20), w / 2, RY(80), Color(200, 200, 200), 1, 1)

	end
	self.vRadioFrame = vFrame

	local vMiddlePanel = vgui.Create("DPanel", vFrame)
	vMiddlePanel:SetSize(vFrame:GetWide(), RY(45))
	vMiddlePanel:SetY(RY(115))
	vMiddlePanel:CenterHorizontal()
	vMiddlePanel.Paint = nil

	local vTextPanel = vgui.Create("DPanel", vMiddlePanel)
	vTextPanel:Dock(LEFT)
	vTextPanel:SetWide(RX(100))
	function vTextPanel:Paint(w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(38, 49, 61))
	end

	local vText = vgui.Create("DTextEntry", vTextPanel)
	vText:Dock(FILL)
	vText:DockMargin(RX(28), 0, RX(25), 0)
	vText:SetDrawLanguageID(false)
	vText:SetPaintBackground(false)
	vText:SetFont(EVoice:Font(25))
	vText:SetTextColor(color_white)
	vText:SetPlaceholderText("127")
	vText:SetNumeric(true)
	vText:SetCursorColor(color_white)
	function vText:AllowInput(sInput)
		return #self:GetValue() >= 3
	end
	
	local iFrequency = LocalPlayer():GetLocalNWVar("RadioFrequency")
	if iFrequency then
		vText:SetText(tostring(iFrequency))
	end

	local vConfirm = vgui.Create("DButton", vMiddlePanel)
	vConfirm:Dock(LEFT)
	vConfirm:DockMargin(RX(20), 0, 0, 0)
	vConfirm:SetWide(RX(150))
	vConfirm:SetText("")
	function vConfirm:Paint(w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(46, 204, 113))
		draw.SimpleText(EVoice.Config.Language[7], EVoice:Font(25), w / 2, h / 2, color_white, 1, 1)
	end
	function vConfirm:DoClick()

		local iFrequency = tonumber(vText:GetValue())
		
		if isnumber(iFrequency) then
			
			net.Start("EVoice:UpdateLocalVar")
				net.WriteUInt(1, 4)
				net.WriteUInt(iFrequency, 32)
			net.SendToServer()

		end
			
		vFrame:Remove()

	end

	vMiddlePanel:SetWide(vTextPanel:GetWide() + vConfirm:GetWide() + vConfirm:GetDockMargin())
	vMiddlePanel:CenterHorizontal()

	local vDisable = vgui.Create("DButton", vFrame)
	vDisable:SetSize(vMiddlePanel:GetWide(), vMiddlePanel:GetTall())
	vDisable:SetY(vMiddlePanel:GetY() + vMiddlePanel:GetTall() + RY(10))
	vDisable:CenterHorizontal()
	vDisable:SetText("")
	if not LocalPlayer():GetRadioEnabled() then
		vDisable.bDisabled = true
	end
	function vDisable:Paint(w, h)
		draw.RoundedBox(8, 0, 0, w, h, (vDisable.bDisabled and Color(133, 131, 131) or Color(231, 76, 60)))
		draw.SimpleText((vDisable.bDisabled and EVoice.Config.Language[11] or EVoice.Config.Language[8]), EVoice:Font(25), w / 2, h / 2, color_white, 1, 1)
	end
	function vDisable:DoClick()

		if not vDisable.bDisabled then
			
			net.Start("EVoice:UpdateLocalVar")
				net.WriteUInt(0, 4)
				net.WriteBool(false)
			net.SendToServer()

		end

		vFrame:Remove()

	end

end