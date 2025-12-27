local math_pow = math.pow
local draw_SimpleText = draw.SimpleText
local vgui_Register = vgui.Register

local mats, colors = MagieReroll.UI.Config.mats, MagieReroll.UI.Config.colors
local easeOutQuint = function(t) return 1 - math_pow(1 - t, 5) end

local PANEL = {}

function PANEL:Init()
    self.item = nil
    self.index = 0
    self.virtualIndex = 0
    self.isWinner = false
    self.animationFinished = false
end

function PANEL:SetItem(item)
    self.item = item
end

function PANEL:SetVirtualIndex(index)
    self.virtualIndex = index
end

function PANEL:SetAnimationFinished(finished)
    self.animationFinished = finished
end

function PANEL:CheckWinner(winningItem, winPosition)
    if not winningItem or not self.item then 
        self.isWinner = false
        return
    end
    
    local wasWinner = self.isWinner
    
    self.isWinner = MagieReroll.UI.ItemsAreEqual(self.item, winningItem) and 
                    self.virtualIndex == winPosition and 
                    self.animationFinished
end

local iconSize = scale(42)
function PANEL:Paint(w, h)
    if not self.item then return end
    
    local rarityColor = MagieReroll.GetRarityColor(self.item.rarity)
    local iconMat = MagieReroll.UI.GetMaterial(self.item.icon)
    
    MagieReroll.UI.Box(0, h - scale(45), w, scale(45), rarityColor)
    MagieReroll.UI.Outline(0, 0, w, h, colors.main)

    draw_SimpleText(self.item.name, 'mr.font3', w * .5, h - scale(20), colors.main, 1, 4)
    draw_SimpleText(self.item.rarity, 'mr.font2', w * .5, h - scale(5), colors.main, 1, 4)

    MagieReroll.UI.Image(w * .5 - iconSize * .5, scale(20), iconSize, iconSize, iconMat, rarityColor)
end

vgui_Register('MagieReroll_ItemPanel', PANEL, 'Panel')