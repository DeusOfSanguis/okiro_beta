local math_pow = math.pow
local vgui_Create = vgui.Create
local draw_RoundedBox = draw.RoundedBox
local ipairs = ipairs
local IsValid = IsValid
local table_insert = table.insert
local math_floor = math.floor
local CurTime = CurTime
local math_random = math.random
local math_ceil = math.ceil
local surface_PlaySound = surface.PlaySound
local timer_Create = timer.Create
local timer_Remove = timer.Remove
local math_min = math.min
local vgui_Register = vgui.Register

local mats, colors = MagieReroll.Ranks.UI.mats, MagieReroll.Ranks.UI.colors
local VISIBLE_ITEM_COUNT = 7
local FRAME_WIDTH, FRAME_HEIGHT = scale(126), scale(126)
local ITEM_SPACING = scale(17)
local TOTAL_ITEM_WIDTH = FRAME_WIDTH + ITEM_SPACING
local easeOutQuint = function(t) return 1 - math_pow(1 - t, 5) end

local PANEL = {}

function PANEL:Init()
    self.itemPanels = {}
    self.centerOffset = FRAME_WIDTH * .5
    self.items = {}
    self.winningItem = nil
    self.winningItemPosition = 0
    self.currentPosition = 0
    self.targetPosition = 0
    self.isRolling = false
    self.animationFinished = false
    self.animStartTime = 0
    self.animDuration = 5
    
    self:CreateItemPanels()
    
    self:LoadPreviewItems()

    self.indicator = vgui_Create('Panel', self)
    self.indicator:SetSize(scale(4), FRAME_HEIGHT)

    self.indicator.Paint = function(_, w, h)
        draw_RoundedBox(0, 0, 0, w, h, colors.white)
    end
end

function PANEL:PerformLayout(w, h)
    local indicatorX = w * .5
    self.indicator:SetPos(indicatorX - 2, 0)
    
    self:UpdatePanels()
end

function PANEL:CreateItemPanels()
    for _, panel in ipairs(self.itemPanels) do
        if IsValid(panel) then
            panel:Remove()
        end
    end
    self.itemPanels = {}
    
    for i = 1, VISIBLE_ITEM_COUNT + 4 do
        local panel = vgui_Create('MagieRanks_ItemPanel', self)
        panel:SetSize(FRAME_WIDTH, FRAME_HEIGHT)

        panel:SetPos((i - 1) * TOTAL_ITEM_WIDTH, 0)
        panel.index = i
        
        table_insert(self.itemPanels, panel)
    end
end

function PANEL:LoadPreviewItems()
    self.items = MagieReroll.Ranks.GetPreviewItems()
    
    self.currentPosition = 150
    self:UpdatePanels()
end

function PANEL:UpdatePanels()
    if #self.items == 0 then return end
    
    local visibleStartIdx = math_floor(self.currentPosition / TOTAL_ITEM_WIDTH)
    
    for i, panel in ipairs(self.itemPanels) do
        local virtualIdx = visibleStartIdx + i - 1
        
        local itemIdx = (virtualIdx % #self.items)
        if itemIdx == 0 then itemIdx = #self.items end
        
        panel:SetVirtualIndex(virtualIdx)
        
        panel:SetItem(self.items[itemIdx])

        panel:SetAnimationFinished(self.animationFinished)
        panel:CheckWinner(self.winningItem, self.winningItemPosition)
        
        local panelX = (i - 1) * TOTAL_ITEM_WIDTH - (self.currentPosition % TOTAL_ITEM_WIDTH)
        panel:SetPos(panelX, 0)
    end
end

function PANEL:StartRolling(items, winItem, winPosition)
    self.items = items
    self.winningItem = winItem
    self.winningItemPosition = winPosition
    self.isRolling = true
    self.animationFinished = false
    self.animStartTime = CurTime()
    
    self.currentPosition = 0
    
    local additionalScrolls = math_random(15, 25)
    
    local centerPanelIndex = math_ceil(VISIBLE_ITEM_COUNT *.5)
    
    self.targetPosition = (winPosition - centerPanelIndex) * TOTAL_ITEM_WIDTH + TOTAL_ITEM_WIDTH *.5 + scale(90)
    
    if self.targetPosition < additionalScrolls * TOTAL_ITEM_WIDTH then
        self.targetPosition = self.targetPosition + (additionalScrolls * #items * TOTAL_ITEM_WIDTH)
    end
    
    surface_PlaySound('ui/buttonrollover.wav')
end

function PANEL:FinishAnimation(frame)
    self.isRolling = false
    self.animationFinished = true
    
    self.currentPosition = self.targetPosition
    self:UpdatePanels()
    
    surface_PlaySound('garrysmod/content_downloaded.wav')
    
    if IsValid(frame) then
        local intensity = 5
        local shakeDuration = 0.5
        local shakeStart = CurTime()
        
        local origX, origY = frame:GetPos()
        
        timer_Create('MagieRanks_ShakeEffect', 0.01, shakeDuration * 100, function()
            if not IsValid(frame) then timer_Remove('MagieRanks_ShakeEffect') return end
            
            local shakeProgress = (CurTime() - shakeStart) / shakeDuration
            if shakeProgress >= 1 then
                frame:SetPos(origX, origY)
                timer_Remove('MagieRanks_ShakeEffect')
                return
            end
            
            local factor = 1 - shakeProgress
            local offsetX = math_random(-intensity, intensity) * factor
            local offsetY = math_random(-intensity, intensity) * factor
            
            frame:SetPos(origX + offsetX, origY + offsetY)
        end)
    end
end

function PANEL:Think()
    if not self.isRolling then return end
    
    local timeElapsed = CurTime() - self.animStartTime
    local progress = math_min(timeElapsed / self.animDuration, 1)
    
    self.currentPosition = self.targetPosition * easeOutQuint(progress)
    
    self:UpdatePanels()
    
    if progress >= 1 and not self.animationFinished then
        self:FinishAnimation(self:GetParent())
    end
end

function PANEL:Paint(w, h)
    MagieReroll.UI.Outline(0, 0, w, h, colors.main )
end

vgui_Register('MagieRanks_ScrollContainer', PANEL, 'Panel')