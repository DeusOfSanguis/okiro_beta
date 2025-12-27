initsl_data2 = {
    ["pts"] = 0,
    ["rerollstats"] = 0,
    ["force"] = 1,
    ["agilite"] = 1,
    ["sens"] = 1,
    ["vitalite"] = 1,
    ["intelligence"] = 1
}

initsl_data3 = {
    ["classe"] = 1,
    ["magie"] = 1,
    ["rang"] = 1
}

function formatCount(amount)
    local suffix = ""
    local absAmount = math.abs(amount)
    local formattedAmount = absAmount

    if absAmount >= 1e9 then
        formattedAmount = absAmount / 1e9
        suffix = "B"
    elseif absAmount >= 1e6 then
        formattedAmount = absAmount / 1e6
        suffix = "M"
    elseif absAmount >= 1e3 then
        formattedAmount = absAmount / 1e3
        suffix = "k"
    else
        suffix = ""
    end

    if formattedAmount % 1 ~= 0 then
        formattedAmount = string.format("%.2f", formattedAmount)
    end

    if amount < 0 then
        return "-" .. formattedAmount .. suffix
    else
        return formattedAmount .. suffix
    end
end

function formatMoney(amount)
    local suffix = ""
    local absAmount = math.abs(amount)
    local formattedAmount = absAmount

    if absAmount >= 1e9 then
        formattedAmount = absAmount / 1e9
        suffix = "B ₩"
    elseif absAmount >= 1e6 then
        formattedAmount = absAmount / 1e6
        suffix = "M ₩"
    elseif absAmount >= 1e3 then
        formattedAmount = absAmount / 1e3
        suffix = "k ₩"
    else
        suffix = " ₩"
    end

    if formattedAmount % 1 ~= 0 then
        formattedAmount = string.format("%.2f", formattedAmount)
    end

    if amount < 0 then
        return "-" .. formattedAmount .. suffix
    else
        return formattedAmount .. suffix
    end
end


local hook_Add = hook.Add
local timer_Simple = timer.Simple
local key_table = {IN_ATTACK,IN_FORWARD,IN_BACK,IN_MOVELEFT,IN_MOVERIGHT,IN_ATTACK2,IN_RUN,IN_SPEED}

hook_Add( "SetupMove", "SDA:PainSysteme", function( ply, mv, cmd )
    local ratio = ply:Health()/ply:GetMaxHealth()
    if ratio > 0.1 then return end

    local pressed = false
    for _, key in ipairs(key_table) do
        if cmd:KeyDown( key ) then 
            pressed = true
            break
        end
    end

    if not pressed or ply.debounce then return end
    ply.debounce = true

    if not ply:IsValid() then return end

    if SERVER then
        if not ply:Alive() then return end
        ply:TakeDamage(10)
        ply:EmitSound( "player/pl_pain"..math.random(5,7)..".wav" )
    else
        if not ply:Alive() then return end
        ply:ChatPrint( "Vous êtes gravement blessé, ne bougez pas si vous ne voulez pas aggravé davantage vos blessures !" )
    end

    timer_Simple(1, function() if IsValid(ply) then ply.debounce = false end end)
end)

ACHAT_SL = {
    
    ["rerollrang"] = {
        name = "Реролл Ранга",
        price = 65000000,
    },

    ["rerollclasse"] = {
        name = "Реролл Класса",
        price = 65000000,
    },

    ["rerollmagie"] = {
        name = "Реролл Магии",
        price = 65000000,
    },

    ["rerollstats"] = {
        name = "Реролл Статистики",
        price = 100000,
    },

}

if SERVER then
    util.AddNetworkString("CheckPurchase")

    local function getPlayerMoney(ply)
        return ply:getDarkRPVar("money")
    end

    local function addItemToPlayer(ply, itemKey)
        if itemKey == "rerollclasse" then
            ply:AddRerollClasse(1)
        elseif itemKey == "rerollrang" then
            ply:AddRerollRang(1)
        elseif itemKey == "rerollmagie" then
            ply:AddRerollMagie(1)
        elseif itemKey == "rerollstats" then
            ply:AddResetStats(1)
        end
    end

    net.Receive("CheckPurchase", function(len, ply)
        local itemKey = net.ReadString()
        local item = ACHAT_SL[itemKey]
        local money = getPlayerMoney(ply)

        if money >= item.price then
            ply:addMoney(-item.price)
            addItemToPlayer(ply, itemKey)

            net.Start("SL:Notification")
            net.WriteString("Vous venez d'acheter : x1 " .. item.name)
            net.Send(ply)
        else
            net.Start("SL:ErrorNotification")
            net.WriteString("ERREUR: Vous n'avez pas assez d'argent !")
            net.Send(ply)
        end
    end)

    hook.Add("PlayerSay", "OpenShop", function(ply, text)
        if string.lower(text) == "!boutique" then
            ply:ConCommand("open_shop")
        end
    end)
end

if CLIENT then
    concommand.Add("open_shop", function()
        local frame = vgui.Create("TLFrame")
        frame:gSetSize(400, 360)
        frame:ShowCloseButton(true)
        frame:SetHeader("Boutique")
        frame:Center()
        frame:MakePopup()

        local y = 80
        for key, item in pairs(ACHAT_SL) do
            local nameLabel = vgui.Create("DLabel", frame)
            nameLabel:SetFont("M_Font3")
            nameLabel:gSetPos(10 + 20, y)
            nameLabel:SetText(item.name)
            nameLabel:SizeToContents()

            local priceLabel = vgui.Create("DLabel", frame)
            priceLabel:SetFont("M_Font5")
            priceLabel:gSetPos(10 + 20, y + 20)
            priceLabel:SetText("Prix: " .. item.price .. " ₩")
            priceLabel:SizeToContents()

            local buyButton = vgui.Create("TLButton", frame)
            buyButton:SetFont("M_Font5")
            buyButton:gSetPos(250 + 20, y)
            buyButton:SetText("Acheter")
            buyButton:gSetSize(100, 40)
            buyButton.DoClick = function()
                net.Start("CheckPurchase")
                net.WriteString(key)
                net.SendToServer()

                frame:Close()
            end

            y = y + 70
        end
    end)
end

if CLIENT then
local function CreateEntMenu()

if LocalPlayer():GetUserGroup() == "anim" or LocalPlayer():GetUserGroup() == "modo" or LocalPlayer():IsAdmin() then

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Spawn Entities")
    frame:gSetSize(800, 600)
    frame:Center()
    frame:MakePopup()

    local leftPanel = vgui.Create("DPanel", frame)
    leftPanel:Dock(LEFT)
    leftPanel:gSetWidth(200)

    local rightPanel = vgui.Create("DPanel", frame)
    rightPanel:Dock(FILL)

    local categoryList = vgui.Create("DListView", leftPanel)
    categoryList:Dock(FILL)
    categoryList:AddColumn("Categories")

    local entityList = vgui.Create("DIconLayout", rightPanel)
    entityList:Dock(FILL)
    entityList:SetSpaceY(5)
    entityList:SetSpaceX(5)

    local entities = list.Get("SpawnableEntities")
    local categories = {}

    for _, ent in pairs(entities) do
        local category = ent.Category or "Other"
        if not categories[category] then
            categories[category] = {}
            categoryList:AddLine(category)
        end
        table.insert(categories[category], ent)
    end

    categoryList.OnRowSelected = function(_, _, row)
        entityList:Clear()
        local selectedCategory = row:GetColumnText(1)
        for _, ent in ipairs(categories[selectedCategory]) do
            local icon = vgui.Create("SpawnIcon", entityList)
            icon:SetModel(ent.Model)
            icon:SetToolTip(ent.PrintName or ent.ClassName)
            icon.DoClick = function()
                net.Start("SpawnSelectedEntity")
                net.WriteString(ent.ClassName)
                net.SendToServer()
            end
        end
    end
end
end

concommand.Add("open_entmenu", CreateEntMenu)

end

if SERVER then
    util.AddNetworkString("SpawnSelectedEntity")
end


if SERVER then
net.Receive("SpawnSelectedEntity", function(len, ply)
    local entClass = net.ReadString()

    if ply:GetUserGroup() == "anim" or ply:GetUserGroup() == "modo" or ply:IsAdmin() then

    local trace = ply:GetEyeTrace()
    local spawnPos = trace.HitPos + trace.HitNormal * 16

    local ent = ents.Create(entClass)
    if not IsValid(ent) then
        ply:ChatPrint("Invalid entity.")
        return
    end

    ent:SetPos(spawnPos)
    ent:Spawn()
    ent:Activate()

    if ent.CPPISetOwner then
        ent:CPPISetOwner(ply)
    else
        ent:SetOwner(ply)
    end

    undo.Create(entClass)
    undo.AddEntity(ent)
    undo.SetPlayer(ply)
    undo.Finish()

    ply:AddCleanup("entities", ent)
    end
end)
end