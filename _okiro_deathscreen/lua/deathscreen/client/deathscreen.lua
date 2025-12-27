local DEATHSCREEN = {}
local frame

local gmaterials = {
	background = Material("okiro/deathscreen/background.png", "noclamp smooth"),
	sep = Material("okiro/deathscreen/sep.png", "noclamp smooth"), 
	panel = Material("okiro/deathscreen/panel.png", "noclamp smooth"),
	respawn = Material("okiro/deathscreen/respawn.png", "noclamp smooth"),
	die = Material("okiro/deathscreen/die.png", "noclamp smooth")
}

local sounds = {
	hover = Sound("UI/buttonrollover.wav"),
	click = Sound("UI/buttonclick.wav"),
	fade = Sound("UI/achievement_earned.wav")
}

net.Receive("PlayDeathSound", function()
    if LocalPlayer():GetNWInt("Creation_Genre") == "male" then
		surface.PlaySound("mad_sfx_sololeveling/voice/death_male.wav")
	elseif LocalPlayer():GetNWInt("Creation_Genre") == "female" then
		surface.PlaySound("shavkat/death_female.wav")
	else
		surface.PlaySound("mad_sfx_sololeveling/voice/death_male.wav")
	end
end)


function DEATHSCREEN:Init()
	self:gSetSize(1920, 1080)
	self:Center()
	self:SetTitle("")
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	self:MakePopup()
	self:gFadeIn(1)
	self.UpdateElements = function()
		self:gSetSize(1920, 1080)
		self:Center()

		self.respawnPanel:gSetSize(783, 270)
		self.respawnPanel:Center()

		self.respawnButton:gSetSize(196, 38)
		self.respawnButton:gSetPos(190, 170)

		self.dieButton:gSetSize(196, 38)
		self.dieButton:gSetPos(395, 170)

		self.diePanel:gSetSize(1920, 1080)
	end

	self.respawnPanel = vgui.Create("DPanel", self)
	self.respawnPanel:gSetSize(783, 270)
	self.respawnPanel:Center()
	
	self.respawnPanel.Paint = function(self, w, h)
		pMaterials(gmaterials.panel, 0, 0, w, h)
	end

	self.respawnButton = vgui.Create("DButton", self.respawnPanel)
	self.respawnButton:gSetSize(196, 38)
	self.respawnButton:gSetPos(190, 170)
	self.respawnButton:SetText("Réapparaître")
	self.respawnButton:SetFont("DeathScreen:Font24:Lexend")
	self.respawnButton:SetTextColor(Color(219, 255, 223))
	self.respawnButton.hovered = false
	self.respawnButton.Paint = function(self, w, h)
		if self:IsHovered() and not self.hovered then
			surface.PlaySound(sounds.hover)
			self.hovered = true
		elseif not self:IsHovered() then
			self.hovered = false
		end
		
		if self:IsHovered() then
			pMaterials(gmaterials.respawn, 0, 0, w, h, Color(200, 200, 200))
		else
			pMaterials(gmaterials.respawn, 0, 0, w, h)
		end
	end
	self.respawnButton.DoClick = function()
		surface.PlaySound(sounds.click)
		net.Start("DeathScreen:Net:RequestRespawn")
		net.SendToServer()
		self:Close()
	end

	self.dieButton = vgui.Create("DButton", self.respawnPanel)
	self.dieButton:gSetSize(196, 38)
	self.dieButton:gSetPos(395, 170)
	self.dieButton:SetText("Décéder")
	self.dieButton:SetFont("DeathScreen:Font24:Lexend")
	self.dieButton:SetTextColor(Color(255, 219, 219))
	self.dieButton.hovered = false
	self.dieButton.Paint = function(self, w, h)
		if self:IsHovered() and not self.hovered then
			surface.PlaySound(sounds.hover)
			self.hovered = true
		elseif not self:IsHovered() then
			self.hovered = false
		end
		
		if self:IsHovered() then
			pMaterials(gmaterials.die, 0, 0, w, h, Color(200, 200, 200))
		else
			pMaterials(gmaterials.die, 0, 0, w, h)
		end
	end

	self.diePanel = vgui.Create("DPanel", self)
	self.diePanel:gSetSize(1920, 1080)
	self.diePanel:SetVisible(false)
	self.diePanel.Paint = function(self, w, h)
		pMaterials(gmaterials.sep, gRespX(820), gRespY(965), gRespX(280), gRespY(12))

		draw.SimpleTextOutlined(
			LocalPlayer():getDarkRPVar("rpname"),
			"DeathScreen:Font24:Lexend",
			gRespX(960),
			gRespY(930),
			Color(119, 225, 255),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER,
			1,
			Color(0, 0, 0, 255)
		)

		draw.SimpleText(
			"Je ne peux pas abandonner maintenant...",
			"DeathScreen:Font24:Lexend",
			gRespX(960),
			gRespY(1000),
			Color(219, 227, 255),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER
		)
	end
	
	self.dieButton.DoClick = function()
		surface.PlaySound(sounds.click)
		surface.PlaySound(sounds.fade)
		self.diePanel:SetVisible(true)
		self.diePanel:gFadeIn(0.3)
		timer.Simple(1, function()
			if IsValid(self.diePanel) then
				surface.PlaySound(sounds.fade)
				self.diePanel:gFadeOut(0.3)
				timer.Simple(0.3, function()
					if IsValid(self.diePanel) then
						self.diePanel:SetVisible(false)
					end
				end)
			end
		end)
	end

	timer.Create("DeathScreen:Timer:RespawnTimer", 0.1, 0, function()
		if not IsValid(self) then
			timer.Remove("DeathScreen:Timer:RespawnTimer")
			return
		end

		if LocalPlayer():Alive() then
			self:Close()
		end
	end)

	hook.Add("OnScreenSizeChanged", self, function()
		if IsValid(self) then
			self.UpdateElements()
		end
	end)
end

function DEATHSCREEN:OnRemove()
	hook.Remove("OnScreenSizeChanged", self)
end

function DEATHSCREEN:Paint(w, h)
	pMaterials(gmaterials.background, 0, 0, w, h)
end

function DEATHSCREEN:Close()
	timer.Remove("DeathScreen:Timer:RespawnTimer")
	self:gFadeOut(0.5, 0, function()
		self:Remove()
	end)
end

net.Receive("DeathScreen:Net:OpenInteractionMenu", function()
	gui.HideGameUI()
	if IsValid(frame) then
		frame:Close()
	end
	frame = vgui.Create("deathscreen_vgui")
end)

vgui.Register("deathscreen_vgui", DEATHSCREEN, "DFrame")