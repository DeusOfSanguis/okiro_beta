local IsValid = IsValid
local surface_PlaySound = surface.PlaySound
local vgui_Create = vgui.Create
local net_Receive = net.Receive
local net_ReadUInt = net.ReadUInt
local net_ReadString = net.ReadString
local hook_Run = hook.Run

local selectedCard = nil
local rewardResults = {}
local cardPanels = {}

local frame
function CardShuffle.OpenMenu()
    if IsValid( frame ) then return end
    
    surface_PlaySound("ui/buttonclick.wav")
    
    frame = vgui_Create("CardShuffleFrame")
    frame:Show()
end

net_Receive("CardShuffle_RevealResult", function()
    local selectedIndex = net_ReadUInt(4)
    
    local rewards = {}
    for i = 1, 3 do
        local rewardName = net_ReadString()
        local rewardIcon = net_ReadString()
        local rewardRarity = net_ReadString()
        
        rewards[i] = {
            Name = rewardName,
            Icon = rewardIcon,
            Rarity = rewardRarity
        }
    end
    
    hook_Run("CardShuffle_RevealResults", selectedIndex, rewards)
end)

net_Receive("CardShuffle_OpenMenu", function()
    if IsValid(frame) then
        for i = 1, 3 do
            if IsValid(frame.cards[i]) then
                frame.cards[i]:Reset()
            end
        end
        frame.selectedCardIndex = nil
    else
        CardShuffle.OpenMenu()
    end
end)