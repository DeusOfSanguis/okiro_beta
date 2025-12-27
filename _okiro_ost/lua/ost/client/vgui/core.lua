local PANEL = {}
local frame

if not GlobalOST then
	GlobalOST = {
		currentTrack = nil,
		isPlaying = false,
		currentVolume = 100,
		currentSong = "Sélectionnez une musique",
		currentIndex = nil,
		currentTime = "0:00",
		totalTime = "0:00",
		soundDuration = nil
	}
end

local gmaterials = {
	background = Material("okiro/ost/background.png"),
	title = Material("okiro/ost/title.png"),
	close_background = Material("okiro/ost/close_background.png"),
	close = Material("okiro/ost/close.png"),
	scroll = Material("okiro/ost/scroll.png"),
	music = Material("okiro/ost/music.png"),
	prev = Material("okiro/ost/prev.png"),
	play = Material("okiro/ost/play.png"),
	pause = Material("okiro/ost/pause.png"),
	next = Material("okiro/ost/next.png")
}

local sounds = {
	liste = {
		{
			name = "Combine Theme",
			url = "music/hl2_song20_submix0.mp3"
		},
		{
			name = "Triage at Dawn",
			url = "music/hl2_song12_long.mp3"
		},
		{
			name = "CP Violation",
			url = "music/hl2_song14.mp3"
		},
		{
			name = "Laboratory",
			url = "music/stingers/hl1_stinger_song7.mp3"
		},
		{
			name = "tristesse",
			url = "mad_sfx_sololeveling/music/OST_Mianmoto_Tristesse.mp3"
		},
	},
	anims = {
		hover = "ui/buttonrollover.wav",
		click = "ui/buttonclickrelease.wav"
	}
}

local function GetSoundDuration(soundName)
	local sound = Sound(soundName)
	local duration = SoundDuration(soundName)
	
	if duration and duration > 0 then
		local minutes = math.floor(duration / 60)
		local seconds = math.floor(duration % 60)
		return string.format("%d:%02d", minutes, seconds)
	else
		return "..."
	end
end

for _, sound in ipairs(sounds.liste) do
	sound.duration = GetSoundDuration(sound.url)
end

function TogglePlayPause()
	if not GlobalOST.isPlaying then
		if GlobalOST.currentIndex then
			PlayOST(GlobalOST.currentIndex)
		elseif #sounds.liste > 0 then
			PlayOST(1)
		end
	else
		if GlobalOST.currentTrack and GlobalOST.currentTrack.Stop then
			GlobalOST.currentTrack:Stop()
			GlobalOST.currentTrack = nil
		end
		GlobalOST.isPlaying = false
		
		if IsValid(frame) then
			frame.isPlaying = false
		end
	end
end

function PlayOST(index)
	if GlobalOST.currentTrack then
		if GlobalOST.currentTrack.Stop then
			GlobalOST.currentTrack:Stop()
		end
		GlobalOST.currentTrack = nil
	end

	if index > #sounds.liste then index = 1 end
	if index < 1 then index = #sounds.liste end
	
	local sound = sounds.liste[index]

	local rawDuration = SoundDuration(sound.url)
	GlobalOST.soundDuration = rawDuration

	if rawDuration and rawDuration > 0 then
		local minutes = math.floor(rawDuration / 60)
		local seconds = math.floor(rawDuration % 60)
		GlobalOST.totalTime = string.format("%d:%02d", minutes, seconds)
	else
		GlobalOST.totalTime = sound.duration or "..."
	end

	GlobalOST.currentTrack = CreateSound(LocalPlayer(), sound.url)

	if GlobalOST.currentTrack and GlobalOST.currentTrack.Play then
		GlobalOST.currentTrack:Play()
	end

	GlobalOST.isPlaying = true
	GlobalOST.currentSong = sound.name
	GlobalOST.currentTime = "0:00"
	GlobalOST.currentIndex = index

	if IsValid(frame) then
		frame.currentTime = GlobalOST.currentTime
		frame.totalTime = GlobalOST.totalTime
		frame.currentSong = GlobalOST.currentSong
		frame.isPlaying = true

		for i, btn in ipairs(frame.musicButtons or {}) do
			if IsValid(btn) then
				btn.isPlaying = (i == index)
			end
		end
	end

	if timer.Exists("GlobalOST_TimeUpdate") then
		timer.Remove("GlobalOST_TimeUpdate")
	end

	timer.Create("GlobalOST_TimeUpdate", 1, 0, function()
		if GlobalOST.isPlaying then
			local min, sec = string.match(GlobalOST.currentTime, "(%d+):(%d+)")
			local minutes = tonumber(min) or 0
			local seconds = tonumber(sec) or 0
			
			seconds = seconds + 1
			if seconds >= 60 then
				seconds = 0
				minutes = minutes + 1
			end
			
			GlobalOST.currentTime = string.format("%d:%02d", minutes, seconds)

			if IsValid(frame) then
				frame.currentTime = GlobalOST.currentTime
			end

			if GlobalOST.soundDuration then
				local totalSeconds = minutes * 60 + seconds
				if totalSeconds >= GlobalOST.soundDuration then
					PlayOST(GlobalOST.currentIndex + 1)
				end
			end
		end
	end)
end

function PANEL:Init()
	self:gSetSize(715, 702)
	self:ShowCloseButton(false)
	self:SetDraggable(false)
	self:SetTitle("")
	self:Center()
	self:MakePopup()
	self:gFadeIn(0.5)
	
	self.musicButtons = {}

	self.currentTime = GlobalOST.currentTime
	self.totalTime = GlobalOST.totalTime
	self.currentVolume = GlobalOST.currentVolume
	self.isPlaying = GlobalOST.isPlaying
	self.currentSong = GlobalOST.currentSong
	self.currentIndex = GlobalOST.currentIndex
	
	self.UpdateElements = function()
		self:gSetSize(715, 702)
		self:Center()
		
		self.close:gSetSize(42, 38)
		self.close:gSetPos(566, 67)
		
		self.scrollPanel:gSetSize(517, 334)
		self.scrollPanel:gSetPos(91, 115)
		
		if self.playerPanel then
			self.playerPanel:gSetSize(530, 160)
			self.playerPanel:gSetPos(91, 460)
		end
	end
	
	self.close = vgui.Create("DButton", self)
	self.close:gSetPos(566, 67)
	self.close:gSetSize(42, 38)
	self.close:SetText("")
	self.close.Paint = function(self, w, h)
		pMaterials(gmaterials.close_background, 0, 0, w, h)
		if self:IsHovered() then 
			pMaterials(gmaterials.close, gRespX(5), gRespY(3), gRespX(33), gRespY(32), Color(255, 255, 255, 255))
		else
			pMaterials(gmaterials.close, gRespX(5), gRespY(3), gRespX(33), gRespY(32), Color(255, 255, 255, 150))
		end
	end
	self.close.OnCursorEntered = function()
		surface.PlaySound(sounds.anims.hover)
	end
	self.close.DoClick = function()
		surface.PlaySound(sounds.anims.click)
		self:Close()
	end
	
	self.scrollPanel = vgui.Create("DScrollPanel", self)
	self.scrollPanel:gSetPos(91, 115)
	self.scrollPanel:gSetSize(517, 334)
	self.scrollPanel.Paint = function(self, w, h)
		pMaterials(gmaterials.scroll, 0, 0, w, h)
	end
	
	local vbar = self.scrollPanel:GetVBar()
	vbar:SetHideButtons(true)
	vbar:SetWide(gRespX(5))
	vbar.Paint = function() end
	vbar.btnGrip.Paint = function(s, w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(200, 200, 200, 150))
	end
	
	self:PopulateMusicList()
	self:CreatePlayerPanel()
	
	hook.Add("OnScreenSizeChanged", self, function()
		if IsValid(self) then
			self.UpdateElements()
		end
	end)
	
	timer.Simple(0.1, function()
		if IsValid(self) then
			self.UpdateElements()
		end
	end)
end

function PANEL:Think()
	self.currentTime = GlobalOST.currentTime
	self.totalTime = GlobalOST.totalTime
	self.isPlaying = GlobalOST.isPlaying
	self.currentSong = GlobalOST.currentSong
	self.currentIndex = GlobalOST.currentIndex
end

function PANEL:CreatePlayerPanel()
	if IsValid(self.playerPanel) then return end

	self.playerPanel = vgui.Create("DPanel", self)
	self.playerPanel:gSetPos(91, 460)
	self.playerPanel:gSetSize(530, 160)
	self.playerPanel.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))

		draw.SimpleText(self.currentTime .. " / " .. self.totalTime, "DeathScreen:Font18:Lexend", gRespX(w/2), gRespY(25), Color(219, 227, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.currentSong, "DeathScreen:Font18:Lexend", gRespX(w/2), gRespY(50), Color(219, 227, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Volume", "DeathScreen:Font16:Lexend", gRespX(50), gRespY(100), Color(219, 227, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("100%", "DeathScreen:Font16:Lexend", gRespX(w-50), gRespY(100), Color(219, 227, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local volumeBar = vgui.Create("DPanel", self.playerPanel)
	volumeBar:gSetPos(100, 115)
	volumeBar:gSetSize(330, 20)
	volumeBar.Paint = function(s, w, h)
		draw.RoundedBox(8, 0, gRespY(h/2-1), w, gRespY(2), Color(100, 100, 100, 150))
		draw.RoundedBox(8, 0, gRespY(h/2-1), w, gRespY(2), Color(219, 227, 255, 255))

		draw.RoundedBox(8, gRespX(w-10), gRespY(-4), gRespX(10), gRespY(10), Color(219, 227, 255, 255))
	end

	local buttonSize = 30
	local spacing = 10
	local totalWidth = (buttonSize * 3) + (spacing * 2)
	local startX = (self.playerPanel:GetWide() - totalWidth) / 2

	self.prevButton = vgui.Create("DButton", self.playerPanel)
	self.prevButton:gSetPos(startX, 75)
	self.prevButton:gSetSize(buttonSize, buttonSize)
	self.prevButton:SetText("")
	self.prevButton.Paint = function(s, w, h)
		local color = Color(219, 227, 255, 200)
		if s:IsHovered() then
			color = Color(219, 227, 255, 255)
		end
		
		pMaterials(gmaterials.prev, 0, 0, w, h, color)
	end
	self.prevButton.OnCursorEntered = function() surface.PlaySound(sounds.anims.hover) end
	self.prevButton.DoClick = function()
		surface.PlaySound(sounds.anims.click)
		if GlobalOST.currentIndex then
			PlayOST(GlobalOST.currentIndex - 1)
		else
			PlayOST(#sounds.liste)
		end
	end

	self.playButton = vgui.Create("DButton", self.playerPanel)
	self.playButton:gSetPos(startX + buttonSize + spacing, 75)
	self.playButton:gSetSize(buttonSize, buttonSize)
	self.playButton:SetText("")
	self.playButton.Paint = function(s, w, h)
		local color = Color(219, 227, 255, 200)
		if s:IsHovered() then
			color = Color(219, 227, 255, 255)
		end
		
		if self.isPlaying then
			pMaterials(gmaterials.pause, 0, 0, w, h, color)
		else
			pMaterials(gmaterials.play, 0, 0, w, h, color)
		end
	end
	self.playButton.OnCursorEntered = function() surface.PlaySound(sounds.anims.hover) end
	self.playButton.DoClick = function()
		surface.PlaySound(sounds.anims.click)
		TogglePlayPause()
	end

	self.nextButton = vgui.Create("DButton", self.playerPanel)
	self.nextButton:gSetPos(startX + (buttonSize * 2) + (spacing * 2), 75)
	self.nextButton:gSetSize(buttonSize, buttonSize)
	self.nextButton:SetText("")
	self.nextButton.Paint = function(s, w, h)
		local color = Color(219, 227, 255, 200)
		if s:IsHovered() then
			color = Color(219, 227, 255, 255)
		end
		
		pMaterials(gmaterials.next, 0, 0, w, h, color)
	end
	self.nextButton.OnCursorEntered = function() surface.PlaySound(sounds.anims.hover) end
	self.nextButton.DoClick = function()
		surface.PlaySound(sounds.anims.click)
		if GlobalOST.currentIndex then
			PlayOST(GlobalOST.currentIndex + 1)
		else
			PlayOST(1)
		end
	end
end

function PANEL:PopulateMusicList()
	for i, sound in ipairs(sounds.liste) do
		local itemButton = vgui.Create("DButton", self.scrollPanel)
		itemButton:Dock(TOP)
		itemButton:gSetHeight(56)
		itemButton:gDockMargin(8, 8, 8, 0)
		itemButton:SetText("")
		itemButton.soundInfo = sound
		itemButton.index = i
		itemButton.isPlaying = (GlobalOST.currentIndex == i)

		itemButton.Paint = function(self, w, h)
			pMaterials(gmaterials.music, 0, 0, w, h)

			local textColor = Color(219, 227, 255, 255)
			if self:IsHovered() then
				textColor = Color(255, 255, 255, 255)
			elseif self.isPlaying then
				textColor = Color(100, 255, 100, 255)
			end

			draw.SimpleText(sound.name, "DeathScreen:Font18:Lexend", gRespX(25), gRespY(28), textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			if sound.duration then
				draw.SimpleText(sound.duration, "DeathScreen:Font16:Lexend", gRespX(w-25), gRespY(28), textColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
		end

		itemButton.Think = function(s)
			s.isPlaying = (GlobalOST.currentIndex == i)
		end

		itemButton.OnCursorEntered = function()
			surface.PlaySound(sounds.anims.hover)
		end

		itemButton.DoClick = function()
			surface.PlaySound(sounds.anims.click)
			PlayOST(i)
		end

		table.insert(self.musicButtons, itemButton)
	end
end

function PANEL:OnRemove()
	hook.Remove("OnScreenSizeChanged", self)
	frame = nil
end

function PANEL:Paint(w, h)
	pMaterials(gmaterials.background, 0, 0, w, h)
	pMaterials(gmaterials.title, gRespX(91), gRespY(67), gRespX(468), gRespY(38))
	draw.SimpleText("Menu OST", "DeathScreen:Font24:Lexend", gRespX(105), gRespY(85), Color(219, 227, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:Close()
	self:gFadeOut(0.3, 0, function()
		self:Remove()
	end)
end

vgui.Register("ost_vgui", PANEL, "DFrame")

local function StopOST()
	if GlobalOST.currentTrack then
		if GlobalOST.currentTrack.Stop then
			GlobalOST.currentTrack:Stop()
		end
		GlobalOST.currentTrack = nil
	end

	if timer.Exists("GlobalOST_TimeUpdate") then
		timer.Remove("GlobalOST_TimeUpdate")
	end

	GlobalOST.isPlaying = false
	GlobalOST.currentSong = "Sélectionnez une musique"
	GlobalOST.currentTime = "0:00"
	GlobalOST.totalTime = "0:00"
	GlobalOST.currentIndex = nil

	if IsValid(frame) then
		frame.isPlaying = false
		frame.currentSong = GlobalOST.currentSong
		frame.currentTime = GlobalOST.currentTime
		frame.totalTime = GlobalOST.totalTime
	end
end

local function OpenOSTMenu(ply, text)
	if ply != LocalPlayer() then return end
	if string.lower(text) == "!ost" or string.lower(text) == "/ost" then
		if IsValid(frame) then
			frame:Close()
			timer.Simple(0.3, function()
				frame = vgui.Create("ost_vgui")
			end)
		else
			frame = vgui.Create("ost_vgui")
		end
		return ""
	elseif string.lower(text) == "!stopmusic" or string.lower(text) == "/stopmusic" then
		StopOST()
		return ""
	end
end

hook.Add("OnPlayerChat", "OST:Hook:OpenMenu", OpenOSTMenu)

concommand.Add("ost_play", function(ply, cmd, args)
	local index = tonumber(args[1]) or 1
	PlayOST(index)
end)

concommand.Add("ost_pause", function()
	TogglePlayPause()
end)

concommand.Add("ost_stop", function()
	StopOST()
end)

hook.Add("PlayerDisconnected", "OST:Cleanup", function(ply)
	if ply == LocalPlayer() then
		StopOST()
	end
end)