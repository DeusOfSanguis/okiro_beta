local table_Copy = table.Copy
local FrameTime = FrameTime
local vgui_Register = vgui.Register

local mats, colors = MagieReroll.UI.Config.mats, MagieReroll.UI.Config.colors

local PANEL = {}

function PANEL:Init()
    self:SetSize(scale(45), scale(45))
    self:SetText('')

    self.colors = {
        rect = {
            normal = colors.main,
            hover = colors.hover
        };
    }
    
    self.currentColors = {
        rect = table_Copy(self.colors.rect.normal)
    }
end

local imageSize = scale(24)
function PANEL:Paint(w, h)
    local isHovered = self:IsHovered()
    local targetRect = isHovered and self.colors.rect.hover or self.colors.rect.normal
    
    self.currentColors.rect = LerpColor(FrameTime() * 10, self.currentColors.rect, targetRect)

    MagieReroll.UI.Outline(0, 0, w, h, self.currentColors.rect)
    
    MagieReroll.UI.Image(w * .5 - imageSize * .5, h * .5 - imageSize * .5, imageSize, imageSize, mats.back, self.currentColors.rect)
    return true
end

vgui_Register('MagieReroll_Return', PANEL, 'DButton')