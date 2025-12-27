local table_Copy = table.Copy
local FrameTime = FrameTime
local vgui_Register = vgui.Register

local mats, colors = MagieReroll.UI.Config.mats, MagieReroll.UI.Config.colors

local PANEL = {}

function PANEL:Init()
    self:SetSize(scale(300), scale(50))
    self:SetText('')

    self.colors = {
        rect = {
            normal = colors.main,
            hover = colors.hover,
        };
    }
    
    self.currentColors = {
        rect = table_Copy(self.colors.rect.normal)
    }
end

function PANEL:SetParentFrame(frame)
    self.parentFrame = frame
end

function PANEL:DoClick()
    if not self.parentFrame then return end
    
    surface.PlaySound("ui/buttonclick.wav")
    
    -- Проверяем, есть ли у игрока доступные рероллы
    if LocalPlayer().sl_data3 and LocalPlayer().sl_data3["classe"] < 1 then
        surface.PlaySound('buttons/button10.wav')
        net.Start("SL:ErrorNotification")
        net.WriteString("ERREUR: Vous n'avez pas de rerolls de classe.")
        net.SendToServer()
        return
    end
    
    -- Сбрасываем состояние карт и запрашиваем новые
    self.parentFrame:ResetCards()
    
    net.Start('CardShuffle_DoReroll')
    net.SendToServer()
end

local imageSize = scale(32)
function PANEL:Paint(w, h)
    local isHovered = self:IsHovered()
    local targetRect = isHovered and self.colors.rect.hover or self.colors.rect.normal
    
    self.currentColors.rect = LerpColor(FrameTime() * 10, self.currentColors.rect, targetRect)

    MagieReroll.UI.Text( 'REROLL', 'mr.font1', scale(20), h*.5, self.currentColors.rect, 0, 1)
    MagieReroll.UI.Outline(0, 0, w, h, self.currentColors.rect)
    
    MagieReroll.UI.Text( sl_data3["classe"] or 0, 'mr.font1', w*.5, h*.5, self.currentColors.rect, 1, 1)

    -- MagieReroll.UI.Image(w - imageSize - scale(20), h * .5 - imageSize * .5, imageSize, imageSize, mats.coin, colors.white)
    -- MagieReroll.UI.Text(MagieReroll.Config.Price.. 'M ₩', 'mr.font1', w - scale(60), h*.5, self.currentColors.rect, 2, 1)

    return true
end

vgui_Register( 'MagieCards_Button', PANEL, 'DButton' )