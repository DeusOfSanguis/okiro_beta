local LocalPlayer = LocalPlayer
local vgui_Create = vgui.Create
local timer_Create = timer.Create
local IsValid = IsValid
local timer_Remove = timer.Remove
local os_time = os.time
local math_random = math.random
local net_ReadTable = net.ReadTable
local net_ReadInt = net.ReadInt
local net_Receive = net.Receive
local timer_Exists = timer.Exists
local pcall = pcall
local vgui_Register = vgui.Register

local mats, colors = MagieReroll.Ranks.UI.mats, MagieReroll.Ranks.UI.colors

local PANEL = {}

function PANEL:Init()
    self:SetSize(scale(1325), scale(532))
    self:Center()
    self:MakePopup()
    self:SetAlpha( 0 )
    self:AlphaTo( 255, 0.2 )
    
    self.money = LocalPlayer():getDarkRPVar('money') or 0
    -- self.rerolls = sl_data3["rang"] or 0

    self.isRolling = false
    self.animationFinished = false
    self.winningItem = nil

    self.back = vgui_Create('MagieReroll_Return', self)
    self.back:SetPos(self:GetWide() - self.back:GetWide() - scale(191), scale(105))
    
    self.back.DoClick = function()
        MagieReroll.Ranks.Config.BackButtonFunction()

        self:SafetyRemove()
    end

    self.scrollContainer = vgui_Create('MagieRanks_ScrollContainer', self)
    self.scrollContainer:SetPos(scale(191), scale(190))
    self.scrollContainer:SetSize(self:GetWide() - scale(382), scale(126))
    
    self.rerollButton = vgui_Create('MagieRanks_Button', self)
    self.rerollButton:SetPos(self:GetWide() * .5 - self.rerollButton:GetWide() * .5, self:GetTall() - scale(165))
    self.rerollButton:SetParentFrame(self)
    self.rerollButton:SetScrollContainer(self.scrollContainer)
    
    self:SetupNetworkHooks()
    
    timer_Create("MagieRanks_MoneyUpdate_"..LocalPlayer():EntIndex(), 1, 0, function()
        if IsValid(self) then
            self.money = LocalPlayer():getDarkRPVar('money') or 0
        else
            timer_Remove("MagieRanks_MoneyUpdate_"..LocalPlayer():EntIndex())
        end
    end)
end

function PANEL:SetupNetworkHooks()
    self.uniqueID = 'MagieRanks_Frame_' .. os_time() .. '_' .. math_random(1000, 9999)
    
    local function HandleRollResult()
        local items = net_ReadTable()
        local winItem = net_ReadTable()
        local winPos = net_ReadInt(16)
        
        self.winningItem = winItem
        
        self.isRolling = true
        self.animationFinished = false
        
        self.rerollButton:SetRollingState(self.isRolling, self.animationFinished)
        
        self.scrollContainer:StartRolling(items, winItem, winPos)
    end
    
    net_Receive('MagieRanks_SendResult', HandleRollResult)
end

local imageSize = scale(32)
local wBoxW = scale(175)
function PANEL:Paint(w, h)
    MagieReroll.UI.Image(0, 0, w, h, mats.bg, colors.white)
    
    MagieReroll.UI.Text('Menu Reroll - Ranks', 'mr.font1', scale(210), scale(111), colors.main, 0, 3)
    MagieReroll.UI.Outline(scale(191), scale(105), scale(687), scale(45), colors.main)

    MagieReroll.UI.Outline(w - wBoxW - scale(250), scale(105), wBoxW, scale(45), colors.main)

    MagieReroll.UI.Outline(scale(191), scale(160), scale(944), scale(186), colors.main)
    MagieReroll.UI.Outline(scale(191), scale(344), scale(944), scale(100), colors.main)

    MagieReroll.UI.Text(MagieReroll.UI.FormatMoney(self.money), 'mr.font1', w - scale(300), scale(111), colors.main, 2, 3)
    MagieReroll.UI.Image(w - imageSize - scale(260), scale(111), imageSize, imageSize, mats.coin, colors.white)

    -- MagieReroll.UI.Text('Rerolls: ' .. self.rerolls, 'mr.font1', scale(450), scale(111), colors.main, 0, 3)
end

function PANEL:Think()
    if self.scrollContainer.animationFinished and not self.animationFinished then
        self.animationFinished = true
        self.isRolling = false
        self.rerollButton:SetRollingState(self.isRolling, self.animationFinished)
    end
end

function PANEL:OnRemove()
    if timer_Exists("MagieRanks_MoneyUpdate_"..LocalPlayer():EntIndex()) then
        timer_Remove("MagieRanks_MoneyUpdate_"..LocalPlayer():EntIndex())
    end
end

function PANEL:SafetyRemove()
    if IsValid(self) then
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end) 
    end
end

function PANEL:OnKeyCodeReleased(key)
    if key == KEY_ESCAPE then
        self:SafetyRemove()
        pcall(RunConsoleCommand, 'gamemenucommand', 'resumegame')
    end
end

vgui_Register('MagieRanks_Frame', PANEL, 'EditablePanel')