local surface_PlaySound = surface.PlaySound
local draw_SimpleText = draw.SimpleText
local IsValid = IsValid
local vgui_Register = vgui.Register
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local draw_RoundedBox = draw.RoundedBox
local draw_SimpleText = draw.SimpleText
local CurTime = CurTime
local math = math
local Color = Color
local mats, colors = CardShuffle.Config.UI.mats, CardShuffle.Config.UI.colors

local PANEL = {}

function PANEL:Init()
    self:SetText("")
    
    self.isFlipped = false
    self.flipStartTime = 0
    self.flipProgress = 0
    self.cardIndex = 0
    self.originalX = 0
    self.originalY = 0
    self.reward = nil
    self.isSelected = false
    self.iconCreated = false
end

function PANEL:Setup(index, x, y)
    self.cardIndex = index
    self:SetPos(x, y)
    self:SetSize( scale(296), scale(419) )
end

function PANEL:SetReward(reward)
    self.reward = reward
end

function PANEL:SetSelected(selected)
    self.isSelected = selected
end

function PANEL:StartFlip()
    if self.flipStartTime == 0 then
        self.flipStartTime = CurTime()
        surface_PlaySound(CardShuffle.Config.Sounds.Open)
    end
end

function PANEL:Reset()
    self.isFlipped = false
    self.flipStartTime = 0
    self.flipProgress = 0
    self.reward = nil
    self.isSelected = false
    self.iconCreated = false
end

function PANEL:Paint(w, h)
    if not self.isFlipped then
        MagieReroll.UI.Image( 0, 0, w, h, mats.card, colors.white )
    else
        if self.reward then
            local rarityColor = CardShuffle.GetRarityColor(self.reward.Rarity)

            MagieReroll.UI.Image( 0, 0, w, h, MagieReroll.UI.GetMaterial(self.reward.Icon), colors.white )

            MagieReroll.UI.TextBox( scale(6), w * .5, h - scale(65), self.reward.Rarity, 'mr.font2', colors.white, rarityColor, 1, 4 )

            draw_SimpleText( self.reward.Name, 'mr.font1', w * .5, h - scale(30), colors.white, 1, 4 )
        end
    end
    
    if self.flipStartTime > 0 then
        self.flipProgress = math.min(1, (CurTime() - self.flipStartTime) / CardShuffle.Config.AnimationSpeed)
        
        if self.flipProgress >= 0.5 and not self.isFlipped then
            self.isFlipped = true
        end
        
        if self.flipProgress >= 1 then
            self.flipStartTime = 0
        end
    end

    MagieReroll.UI.Outline( 0, 0, w, h, colors.white )
end

function PANEL:SetParentFrame(frame)
    self.parentFrame = frame
end

function PANEL:DoClick()
    if self.isFlipped then return end
    
    if self.parentFrame and IsValid(self.parentFrame) then
        self.parentFrame:OnCardSelected(self.cardIndex)
    end
end

vgui_Register("CardShuffleCard", PANEL, "DButton")