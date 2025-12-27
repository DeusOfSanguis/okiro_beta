local vgui_Create = vgui.Create
local LocalPlayer = LocalPlayer
local hook_Add = hook.Add
local net_Start = net.Start
local net_WriteUInt = net.WriteUInt
local net_SendToServer = net.SendToServer
local surface_PlaySound = surface.PlaySound
local IsValid = IsValid
local hook_Remove = hook.Remove
local pcall = pcall
local vgui_Register = vgui.Register
local mats, colors = CardShuffle.Config.UI.mats, CardShuffle.Config.UI.colors
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local draw_RoundedBox = draw.RoundedBox
local draw_SimpleText = draw.SimpleText
local ScrW, ScrH = ScrW, ScrH
local timer_Simple = timer.Simple
local CurTime = CurTime
local Color = Color
local cardSizeW = scale(296)
local padding = scale(26)

local PANEL = {}

function PANEL:Init()
    self:SetSize( scale(1308.36), scale(708.72) )
    self:Center()
    self:MakePopup()
    self:SetAlpha( 0 )
    self:AlphaTo( 255, 0.2 )

    self.back = vgui_Create('MagieReroll_Return', self)
    self.back:SetPos(self:GetWide() - self.back:GetWide() - scale(191), scale(105))

    self.back.DoClick = function()
        CardShuffle.Config.BackButtonFunction()

        self:SafetyRemove()
    end

    self.rerollButton = vgui_Create('MagieCards_Button', self)
    self.rerollButton:SetPos(self:GetWide() * .5 - self.rerollButton:GetWide() * .5, self:GetTall() - scale(125))
    self.rerollButton:SetParentFrame( self )

    self.money = LocalPlayer():getDarkRPVar('money') or 0
    -- self.rerolls = sl_data3["classe"] or 0

    self.cards = {}
    self.selectedCardIndex = nil
    self.rewards = nil
    self.IsCardShuffleFrame = true

    self.cardContainer = vgui_Create('Panel', self)
    self.cardContainer:SetPos(scale(191), scale(160))
    self.cardContainer:SetSize(self:GetWide() - scale(382), scale(419))
    
    for i = 1, 3 do
        local cardX = (i-1) * (cardSizeW + padding)
        local cardY = 0
        
        self.cards[i] = vgui_Create('CardShuffleCard', self.cardContainer)
        self.cards[i]:Setup(i, cardX, cardY)
        self.cards[i]:SetParentFrame(self)
    end
    
    hook_Add('CardShuffle_RevealResults', self, function(_, selectedIndex, rewards)
        self:RevealResults(selectedIndex, rewards)
    end)
end

function PANEL:ResetCards()
    self.selectedCardIndex = nil
    
    for i = 1, 3 do
        if IsValid(self.cards[i]) then
            self.cards[i]:Remove()
        end
    end
    
    self.cards = {}
    
    for i = 1, 3 do
        local cardX = (i-1) * (cardSizeW + padding)
        local cardY = 0
        
        self.cards[i] = vgui_Create('CardShuffleCard', self.cardContainer)
        self.cards[i]:Setup(i, cardX, cardY)
        self.cards[i]:SetParentFrame(self)
    end
end

function PANEL:OnCardSelected(cardIndex)
    if self.selectedCardIndex then return end
    
    self.selectedCardIndex = cardIndex
    
    net_Start('CardShuffle_SelectCard')
    net_WriteUInt(cardIndex, 4)
    net_SendToServer()
    
    surface_PlaySound('ui/buttonclickrelease.wav')
end

function PANEL:RevealResults(selectedIndex, rewards)
    self.rewards = rewards
    
    for i = 1, 3 do
        if IsValid(self.cards[i]) then
            self.cards[i]:SetReward(rewards[i])
            
            if i == selectedIndex then
                self.cards[i]:SetSelected(true)
            end
        end
    end
    
    if IsValid(self.cards[selectedIndex]) then
        self.cards[selectedIndex]:StartFlip()
    end
    
    timer_Simple(CardShuffle.Config.AnimationSpeed * 1.5, function()
        if not IsValid(self) then return end
        
        for i = 1, 3 do
            if i ~= selectedIndex and IsValid(self.cards[i]) then
                timer_Simple((i - 1) * 0.2, function()
                    if IsValid(self.cards[i]) then
                        self.cards[i]:StartFlip()
                    end
                end)
            end
        end
        
        timer_Simple(CardShuffle.Config.AnimationSpeed, function()
            if IsValid(self) then
                surface_PlaySound(CardShuffle.Config.Sounds.Win)
            end
        end)
    end)
end

function PANEL:OnRemove()
    hook_Remove('CardShuffle_RevealResults', self)
    
    net_Start('CardShuffle_CloseMenu')
    net_SendToServer()
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

local imageSize = scale(32)
local wBoxW = scale(175)
function PANEL:Paint(w, h)
    MagieReroll.UI.Image(0, 0, w, h, mats.bg, colors.white)
    
    MagieReroll.UI.Text('Menu Reroll - Classe', 'mr.font1', scale(210), scale(111), colors.main, 0, 3)
    MagieReroll.UI.Outline(scale(191), scale(105), scale(687), scale(45), colors.main)

    MagieReroll.UI.Outline(w - wBoxW - scale(250), scale(105), wBoxW, scale(45), colors.main)

    MagieReroll.UI.Text(MagieReroll.UI.FormatMoney(self.money), 'mr.font1', w - scale(300), scale(111), colors.main, 2, 3)
    MagieReroll.UI.Image(w - imageSize - scale(260), scale(111), imageSize, imageSize, mats.coin, colors.white)

    -- MagieReroll.UI.Text('Rerolls: ' .. self.rerolls, 'mr.font1', scale(450), scale(111), colors.main, 0, 3)
end

vgui_Register( 'CardShuffleFrame', PANEL, 'EditablePanel' )