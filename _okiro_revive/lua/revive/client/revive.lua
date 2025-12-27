local REVIVE = {}
local frame

local gmaterials = {
	background = Material("okiro/relever/background.png", "noclamp smooth"),
	revive = Material("okiro/relever/revive.png", "noclamp smooth"),
	die = Material("okiro/relever/die.png", "noclamp smooth")
}

local sounds = {
	hover = Sound("UI/buttonrollover.wav"),
	click = Sound("UI/buttonclick.wav")
}

function REVIVE:Init()
	self:gSetSize(783, 270)
	self:ShowCloseButton(false)
	self:SetDraggable(false)
	self:SetTitle("")
	self:Center()
	self:MakePopup()
	self:gFadeIn(0.1)
	self.UpdateElements = function()
		self:gSetSize(783, 270)
		self:Center()
		
		self.reviveButton:gSetSize(196, 38)
		self.reviveButton:gSetPos(190, 170)
		
		self.dieButton:gSetSize(196, 38)
		self.dieButton:gSetPos(395, 170)
	end

	self.reviveButton = vgui.Create("DButton", self)
	self.reviveButton:gSetSize(196, 38)
	self.reviveButton:gSetPos(190, 170)
	self.reviveButton:SetText("Relever")
	self.reviveButton:SetFont("Revive:Font24:Lexend")
	self.reviveButton:SetTextColor(Color(219, 255, 223))
	self.reviveButton.hovered = false
	self.reviveButton.Paint = function(self, w, h)
		if self:IsHovered() and not self.hovered then
			surface.PlaySound(sounds.hover)
			self.hovered = true
		elseif not self:IsHovered() then
			self.hovered = false
		end

		pMaterials(gmaterials.revive, 0, 0, w, h, self:IsHovered() and Color(200, 200, 200) or color_white)
	end
	self.reviveButton.DoClick = function()
		if IsValid(self.Ragdoll) then
			surface.PlaySound(sounds.click)
			net.Start("Revive:Net:RequestRevive")
			net.WriteEntity(self.Ragdoll)
			net.SendToServer()
			self:Close()
		else
			surface.PlaySound(sounds.click)
			self:Close()
		end
	end

	self.dieButton = vgui.Create("DButton", self)
	self.dieButton:gSetSize(196, 38)
	self.dieButton:gSetPos(395, 170)
	self.dieButton:SetText("Ne rien faire")
	self.dieButton:SetFont("Revive:Font24:Lexend")
	self.dieButton:SetTextColor(Color(255, 219, 219))
	self.dieButton.hovered = false
	self.dieButton.Paint = function(self, w, h)
		if self:IsHovered() and not self.hovered then
			surface.PlaySound(sounds.hover)
			self.hovered = true
		elseif not self:IsHovered() then
			self.hovered = false
		end

		pMaterials(gmaterials.die, 0, 0, w, h, self:IsHovered() and Color(200, 200, 200) or color_white)
	end
	self.dieButton.DoClick = function()
		if IsValid(self.Ragdoll) then
			self:Close()
		end
	end

	hook.Add("OnScreenSizeChanged", self, function()
		if IsValid(self) then
			self.UpdateElements()
		end
	end)
end

function REVIVE:OnRemove()
	hook.Remove("OnScreenSizeChanged", self)
end

function REVIVE:SetRagdoll(ragdoll)
	self.Ragdoll = ragdoll
end

function REVIVE:Paint(w, h)
	pMaterials(gmaterials.background, 0, 0, w, h)
end

function REVIVE:Close()
	self:gFadeOut(0.1, 0, function()
		self:Remove()
	end)
end

vgui.Register("revive_vgui", REVIVE, "DFrame")

net.Receive("Revive:Net:OpenInteractionMenu", function()
	if IsValid(frame) then frame:Close() end
	frame = vgui.Create("revive_vgui")
	frame:SetRagdoll(net.ReadEntity())
end)