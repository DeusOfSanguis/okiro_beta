local math_pow = math.pow
local draw_SimpleText = draw.SimpleText
local vgui_Register = vgui.Register

local mats, colors = MagieReroll.Ranks.UI.mats, MagieReroll.Ranks.UI.colors
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
    
    self.isWinner = self:ItemsAreEqual(self.item, winningItem) and 
                    self.virtualIndex == winPosition and 
                    self.animationFinished
end

function PANEL:ItemsAreEqual(item1, item2)
    if not item1 or not item2 then return false end
    return item1.name == item2.name and item1.rarity == item2.rarity
end

local iconSize = scale(42)
function PANEL:Paint(w, h)
    if not self.item then return end
    
    local rarityColor = MagieReroll.Ranks.GetRarityColor(self.item.rarity)
    draw_SimpleText(self.item.name, 'mr.font4', w * .5, h * .5, rarityColor, 1, 1)
end

vgui_Register('MagieRanks_ItemPanel', PANEL, 'Panel')