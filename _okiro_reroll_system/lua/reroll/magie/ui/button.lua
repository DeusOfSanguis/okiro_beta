local Color = Color
local table_Copy = table.Copy
local LocalPlayer = LocalPlayer
local FrameTime = FrameTime
local surface_PlaySound = surface.PlaySound
local net_Start = net.Start
local net_SendToServer = net.SendToServer
local vgui_Register = vgui.Register

local mats, colors = MagieReroll.UI.Config.mats, MagieReroll.UI.Config.colors

local PANEL = {}

function PANEL:Init()
    self:SetSize(scale(300), scale(50))
    self:SetText('')
    
    self.parentFrame = nil
    
    self.scrollContainer = nil
    
    self.isRolling = false
    self.animationFinished = false

    self.colors = {
        rect = {
            normal = colors.main,
            hover = colors.hover,
            disabled = Color(100, 100, 100, 150),
            rolling = Color(150, 150, 150, 150)
        };
    }
    
    self.currentColors = {
        rect = table_Copy(self.colors.rect.normal)
    }
end

function PANEL:SetParentFrame(frame)
    self.parentFrame = frame
end

function PANEL:SetScrollContainer(container)
    self.scrollContainer = container
end

function PANEL:SetRollingState(isRolling, animationFinished)
    self.isRolling = isRolling
    self.animationFinished = animationFinished
end

local imageSize = scale(32)
function PANEL:Paint(w, h)
    local isHovered = self:IsHovered()
    local targetRect
    
    if self.isRolling then
        targetRect = self.colors.rect.rolling
    elseif not MagieReroll.CanAfford(LocalPlayer()) and not self.animationFinished then
        targetRect = self.colors.rect.disabled
    elseif isHovered then
        targetRect = self.colors.rect.hover
    else
        targetRect = self.colors.rect.normal
    end
    
    self.currentColors.rect = LerpColor(FrameTime() * 10, self.currentColors.rect, targetRect)

    MagieReroll.UI.Text( 'REROLL', 'mr.font1', scale(20), h*.5, self.currentColors.rect, 0, 1)
    MagieReroll.UI.Outline(0, 0, w, h, self.currentColors.rect)
    
    MagieReroll.UI.Text( sl_data3["magie"] or 0, 'mr.font1', w*.5, h*.5, self.currentColors.rect, 1, 1)

    -- MagieReroll.UI.Image(w - imageSize - scale(20), h * .5 - imageSize * .5, imageSize, imageSize, mats.coin, colors.white)
    -- MagieReroll.UI.Text(MagieReroll.Config.Price.. 'M ₩', 'mr.font1', w - scale(60), h*.5, self.currentColors.rect, 2, 1)

    return true
end

function PANEL:DoClick()
    if self.isRolling then return end
    
    surface_PlaySound("ui/buttonclick.wav")
    
    if self.animationFinished then
        self.animationFinished = false
        
        net_Start('MagieReroll_DoReroll')
        net_SendToServer()
        return
    end
    
    if not MagieReroll.CanAfford(LocalPlayer()) then
        surface_PlaySound('buttons/button10.wav')
        return
    end
    
    if LocalPlayer().sl_data3 and LocalPlayer().sl_data3["magie"] < 1 then
        surface_PlaySound('buttons/button10.wav')
        net.Start("SL:ErrorNotification")
            net.WriteString("ERREUR: Vous n'avez pas de rerolls de magie.")
        net.SendToServer()
        return
    end
    
    net_Start('MagieReroll_DoReroll')
    net_SendToServer()
end

vgui_Register('MagieReroll_Button', PANEL, 'DButton')