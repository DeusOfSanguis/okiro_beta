local ply = LocalPlayer()

net.Receive("SL:Anim_Play", function()
    local ply = net.ReadEntity()
    local seq = net.ReadString()
	if ( IsValid( ply ) ) then
		ply:AddVCDSequenceToGestureSlot( 6, ply:LookupSequence( seq ), 0, true)
	end
end)

net.Receive("SL:Okiro:ThirdPerson", function()
    RunConsoleCommand("simple_thirdperson_enable_toggle")
end)

net.Receive("SL:PO:ParticleEffectAttach", function(ply)
    local particletable = net.ReadTable()
    local attachType = net.ReadFloat()
    local entity = net.ReadEntity()
    local attachmentID = net.ReadInt()

    for _, particle in ipairs(particletable) do
        ParticleEffectAttach(particle, attachType, entity, attachmentID)
    end
end)

net.Receive("SL:PO:ParticleEffectPosPlayer", function()
    local particletable = net.ReadTable()
    local entity = net.ReadEntity()

    for _, particle in ipairs(particletable) do
        ParticleEffect(particle, entity:GetPos(), entity:GetAngles(), entity) 
    end
end)

net.Receive("SL:sendservertoclientdata_inv_equip", function(ply) 

    sl_data5 = net.ReadTable()

end)

net.Receive("SL:sendservertoclientdata_inv_banque", function(ply) 

    sl_data7 = net.ReadTable()

end)

net.Receive("SL:sendservertoclientdata", function(ply) 

    sl_data = net.ReadTable()

end)

net.Receive("SL:sendservertoclientdata_stats", function(ply) 

    sl_data2 = initsl_data2 or {}

    sl_data2["pts"] = net.ReadFloat()
    sl_data2["rerollstats"] = net.ReadFloat()
    sl_data2["force"] = net.ReadFloat()
    sl_data2["agilite"] = net.ReadFloat()
    sl_data2["sens"] = net.ReadFloat()
    sl_data2["vitalite"] = net.ReadFloat()
    sl_data2["intelligence"] = net.ReadFloat()

end)

net.Receive("SL:sendservertoclientdata_rerolls", function(ply) 

    sl_data3 = initsl_data3 or {}

    sl_data3["classe"] = net.ReadFloat()
    sl_data3["magie"] = net.ReadFloat()
    sl_data3["rang"] = net.ReadFloat()

end)

net.Receive("SL:sendservertoclientdata_skills", function(ply) 

    sl_data4 = net.ReadTable()

end)

net.Receive("SL:sendservertoclientdata_classe", function(ply) 
    
    Classe1 = net.ReadString()
    Classe2 = net.ReadString()
    Classe3 = net.ReadString()

end)

net.Receive("SL:sendservertoclientdata_rang", function(ply) 
    
    Rang = net.ReadString()

end)

net.Receive("SL:sendservertoclientdata_magie", function(ply) 
    
    Magie = net.ReadString()

end)

local hook_Add = hook.Add
local draw_RoundedBox = draw.RoundedBox
local draw_DrawText = draw.DrawText
local surface_PlaySound = surface.PlaySound

local options = {
    { type = "keybind", label = "", convar = "sl_attaque1", default = "1", pos = { gRespX(1093), gRespY(333) } },
    { type = "keybind", label = "", convar = "sl_attaque2", default = "2", pos = { gRespX(1093), gRespY(395) } },
    { type = "keybind", label = "", convar = "sl_attaque3", default = "3", pos = { gRespX(1093), gRespY(457) } },
    { type = "keybind", label = "", convar = "sl_attaque4", default = "4", pos = { gRespX(1093), gRespY(519) } },
    { type = "keybind", label = "", convar = "sl_attaque5", default = "5", pos = { gRespX(1093), gRespY(581) } },
}  


for _, option in ipairs(options) do
    if option.type == "checkbox" then
        CreateClientConVar(option.convar, option.default, true, true)
    elseif option.type == "keybind" then
        CreateClientConVar(option.convar, option.default, true, true)
    end
end

local function OpenOptionsMenu()
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")

    local Frame_Options = vgui.Create("DFrame")
    Frame_Options:gSetSize(1920, 1080)
    Frame_Options:SetTitle("")
    Frame_Options:MakePopup()
    Frame_Options:SetDraggable(false)
    Frame_Options:ShowCloseButton(false)
    Frame_Options:SlideDown(0.4)

    Frame_Options.Paint = function(s, w, h)
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/parametres/base.png","smooth","clamps"))
        surface.DrawTexturedRect(gRespX(621), gRespY(192.78), gRespX(699), gRespY(684.6))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/parametres/title.png","smooth","clamps"))
        surface.DrawTexturedRect(gRespX(712), gRespY(260), gRespX(468), gRespY(38))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/parametres/bg.png","smooth","clamps"))
        surface.DrawTexturedRect(gRespX(712), gRespY(308), gRespX(517), gRespY(515))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/parametres/cp1.png","smooth","clamps"))
        surface.DrawTexturedRect(gRespX(726), gRespY(323), gRespX(489), gRespY(56))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/parametres/cp2.png","smooth","clamps"))
        surface.DrawTexturedRect(gRespX(726), gRespY(385), gRespX(489), gRespY(56))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/parametres/cp3.png","smooth","clamps"))
        surface.DrawTexturedRect(gRespX(726), gRespY(447),gRespX(489), gRespY(56))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/parametres/cp4.png","smooth","clamps"))
        surface.DrawTexturedRect(gRespX(726), gRespY(509), gRespX(489), gRespY(56))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/parametres/cp5.png","smooth","clamps"))
        surface.DrawTexturedRect(gRespX(726), gRespY(571), gRespX(489), gRespY(56))

    end

    local CloseButton = vgui.Create("DButton", Frame_Options)
    CloseButton:SetText("")
    CloseButton:gSetPos(1187, 260)
    CloseButton:gSetSize(41.63, 38.34)
    CloseButton.DoClick = function()
        if IsValid(Frame_Options) then
            Frame_Options:Remove()
        end
    end
    CloseButton.Paint = function(s, w, h)
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/close.png","smooth","clamps"))
        surface.DrawTexturedRect(gRespX(0), gRespY(0), gRespX(41.63), gRespY(38.34))
    end

    local OptionPanel = vgui.Create("DPanel", Frame_Options)
    OptionPanel:gSetPos(774, 335)
    OptionPanel:gSetSize(362, 505)
    OptionPanel.Paint = function() end

    for _, option in ipairs(options) do
        local xPos, yPos = option.pos[1], option.pos[2]

        local Label = vgui.Create("DLabel", Frame_Options)
        Label:gSetPos(xPos - 220, yPos + 8)
        Label:SetText(option.label)
        Label:SetFont("M_Font5")
        Label:SetTextColor(Color(219, 227, 255))
        Label:SizeToContents()

        local KeyBindBinder = vgui.Create("DBinder", Frame_Options)
        KeyBindBinder:gSetPos(xPos, yPos)
        KeyBindBinder:gSetSize(113, 36)
        KeyBindBinder:SetConVar(option.convar)
        KeyBindBinder:SetFont("M_Font5")
        KeyBindBinder:SetTextColor(Color(219, 227, 255))
        KeyBindBinder.Paint = function(self, w, h)
        end
    end
end

function OpenF4Menu()
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/base.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(305.64),gRespY(186.14),gRespX(1308.36),gRespY(708.72))
        
        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/title_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(497),gRespY(275.95),gRespX(277.54),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/cp.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(781),gRespY(275.95),gRespX(178),gRespY(38))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/settings_button.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(966),gRespY(275.95),gRespX(41.63),gRespY(38.34))
        
        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1197.24),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1341),gRespY(284),gRespX(23.04),gRespY(21.91))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1014.79),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1160),gRespY(284),gRespX(23.04),gRespY(21.91))

        draw.SimpleText(LocalPlayer():getDarkRPVar("money") .. " ₩", "M_Font5", gRespX(1336), gRespY(294), Color(219, 227, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText("0" .. " OP", "M_Font5", gRespX(1155), gRespY(294), Color(219, 227, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    local function CreateZoomButton(parent, x, y, w, h, image, clickFunc, zoomFactor)
        local normalW, normalH = w, h
        local targetW, targetH = normalW, normalH
        local isHovered = false

        local btn = vgui.Create("DImageButton", parent)
        btn:SetPos(x, y)
        btn:SetSize(normalW, normalH)
        btn:SetImage(image)

        btn.OnCursorEntered = function(s)
            surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")
            targetW, targetH = normalW * zoomFactor, normalH * zoomFactor
            isHovered = true
        end

        btn.OnCursorExited = function(s)
            targetW, targetH = normalW, normalH
            isHovered = false
        end

        btn.Think = function(s)
            local curW, curH = s:GetSize()
            if isHovered then
                s:SetSize(Lerp(FrameTime() * 6, curW, targetW), Lerp(FrameTime() * 6, curH, targetH))
            else
                s:SetSize(Lerp(FrameTime() * 6, curW, normalW), Lerp(FrameTime() * 6, curH, normalH))
            end
            s:SetPos(x - (s:GetWide() - normalW) / 2, y - (s:GetTall() - normalH) / 2)
        end

        btn.DoClick = function()
            clickFunc()
            if IsValid(Frame_Status) then Frame_Status:Remove() end
        end
    end
    
    CreateZoomButton(Frame_Status, gRespX(496.76), gRespY(325.05), gRespX(650), gRespY(237), "okiro/f4/Inventory.png", OpenInventaire, 1.06)
    CreateZoomButton(Frame_Status, gRespX(1156.84), gRespY(325.05), gRespX(264.22), gRespY(479.79), "okiro/f4/Stats.png", OpenStatus, 1.06)
    CreateZoomButton(Frame_Status, gRespX(896.43), gRespY(573.06), gRespX(250.96), gRespY(231.79), "okiro/f4/Reroll.png", MainSkillMenu, 1.1)
    CreateZoomButton(
        Frame_Status,gRespX(496.76), gRespY(573.06), gRespX(391), gRespY(231.79),  "okiro/f4/Shop.png",
        function() 
        DisplayErrorNotification("ERREUR: Le Menu des Guildes n'est pas encore disponible !")
        end,
    1.1)

    local Btn_Skills = vgui.Create("DImageButton", Frame_Status)
    if IsValid(Btn_Skills) then
        Btn_Skills:gSetPos(781, 275.95)
        Btn_Skills:gSetSize(178, 38)
        
        Btn_Skills.DoClick = function()
            OpenSkillsMenu()
            if IsValid(Frame_Status) then Frame_Status:Remove() end
        end
    end
    

    local SettingsB = vgui.Create("DImageButton", Frame_Status)
    if IsValid(SettingsB) then
        SettingsB:gSetPos(966, 275.95)
        SettingsB:gSetSize(41.63, 38.34)
        
        SettingsB.DoClick = function()
            OpenOptionsMenu()
            if IsValid(Frame_Status) then Frame_Status:Remove() end
        end
    end

    local CloseB = vgui.Create("DButton", Frame_Status)
    CloseB:SetText("")
    CloseB:gSetPos(1379, 275.95)
    CloseB:gSetSize(41.63, 38.34)
    CloseB.DoClick = function()
        if IsValid(Frame_Status) then
            Frame_Status:Remove()
        end
    end
    CloseB.Paint = function(s, w, h)
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/close.png", "smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end
end

net.Receive("SL:MainMenu", OpenF4Menu )

function OpenInventaire()
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")

    Frame_Inventaire = vgui.Create("DFrame")
    Frame_Inventaire:gSetSize(1920, 1080)
    Frame_Inventaire:SetTitle("")
    Frame_Inventaire:MakePopup()
    Frame_Inventaire:SetDraggable(false)
    Frame_Inventaire:ShowCloseButton(false)
    Frame_Inventaire:SlideDown(0.4)
    Frame_Inventaire.Paint = function(s, self, w, h)

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/f4/base.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(305.64), gRespY(186.14), gRespX(1308.36), gRespY(708.72))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/title.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(497), gRespY(275.95), gRespX(311), gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/hdv.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(815), gRespY(274), gRespX(193), gRespY(41))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/Slots Inventory (1).png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(497), gRespY(325), gRespX(573.98), gRespY(486.03))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/charbg.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(1080), gRespY(325), gRespX(341), gRespY(486))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1197.24),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1341),gRespY(284),gRespX(23.04),gRespY(21.91))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1014.79),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1160),gRespY(284),gRespX(23.04),gRespY(21.91))

-------------------------------------------------- Equipements --------------------------------------------------

        // Armor
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/slot.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(1111), gRespY(472), gRespX(56), gRespY(56))

        // Weapon
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/slot.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(1111), gRespY(540), gRespX(56), gRespY(56))

        // Rings
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/slot.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(1111), gRespY(608), gRespX(56), gRespY(56))

        // Relics
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/slot.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(1334), gRespY(472), gRespX(56), gRespY(56))

        // Head
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/slot.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(1334), gRespY(540), gRespX(56), gRespY(56))

        // Accessory
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/slot.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(1334), gRespY(608), gRespX(56), gRespY(56))

        draw.SimpleText(LocalPlayer():getDarkRPVar("money") .. " ₩", "M_Font5", gRespX(1336), gRespY(294), Color(219, 227, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText("0" .. " OP", "M_Font5", gRespX(1155), gRespY(294), Color(219, 227, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)


        if (LocalPlayer():GetNWString("Classe") == "porteur" and LocalPlayer():IsSuperAdmin()) then
            draw.DrawText("Items max : " .. nb .. "/42", "MNew_Font5", gRespX(1094), gRespY(783), Color(219, 227, 255, 255), TEXT_ALIGN_LEFT)
        else
            if LocalPlayer():GetUserGroup() == "Monarch" then
                draw.DrawText("Items max : " .. nb .. "/10", "MNew_Font", gRespX(1094), gRespY(783), Color(219, 227, 255, 255), TEXT_ALIGN_LEFT)
            else
                draw.DrawText("Items max : " .. nb .. "/8", "MNew_Font5", gRespX(1094), gRespY(783), Color(219, 227, 255, 255), TEXT_ALIGN_LEFT)
            end
        end
        draw.DrawText("" .. LocalPlayer():Nick() .. "", "MNew_Font1", gRespX(1245), gRespY(351), Color(219, 227, 255, 255), TEXT_ALIGN_CENTER)
    end

    CloseB = vgui.Create("DButton", Frame_Inventaire)
    CloseB:SetText("")
    CloseB:gSetPos(1379.57, 275.95)
    CloseB:gSetSize(41.63, 38.34)
    CloseB.DoClick = function()
        if IsValid(Frame_Inventaire) then
            timer.Destroy("IconUpdate" .. LocalPlayer():SteamID64())
            Frame_Inventaire:Remove()
        end
    end
    CloseB.Paint = function(self, w, h) 
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/close.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end

    hdvb = vgui.Create("DButton", Frame_Inventaire)
    hdvb:SetText("")
    hdvb:gSetPos(815, 274)
    hdvb:gSetSize(193, 41)
    hdvb.DoClick = function(self, w, h)
        DisplayErrorNotification("ERREUR: L'Hôtel de Vente n'est pas encore disponible !")
    end
    hdvb.Paint = function() end

    icon = vgui.Create("DModelPanel", Frame_Inventaire)
    icon:gSetSize(200, 380)
    icon:gSetPos(1150, 390)
    icon:SetFOV(35)
    icon:SetAmbientLight(Color(0, 161, 255, 255))

    icon:SetModel(LocalPlayer():GetModel())

    local function GetPlayerBodygroups(player)
        local bodygroups = {}
        for i = 0, player:GetNumBodyGroups() - 1 do
            bodygroups[i] = player:GetBodygroup(i)
        end
        return bodygroups
    end

    local playerBodygroups = GetPlayerBodygroups(LocalPlayer())

    for index, value in pairs(playerBodygroups) do
        icon.Entity:SetBodygroup(index, value)
    end

    icon.Entity:SetSkin(LocalPlayer():GetSkin())
    function icon.Entity:GetPlayerColor()
        return (LocalPlayer():GetPlayerColor())
    end

    timer.Create("IconUpdate" .. LocalPlayer():SteamID64(), 1, 0, function()
        icon:SetModel(LocalPlayer():GetModel())

        local playerBodygroups = GetPlayerBodygroups(LocalPlayer())

        for index, value in pairs(playerBodygroups) do
            icon.Entity:SetBodygroup(index, value)
        end

        icon.Entity:SetSkin(LocalPlayer():GetSkin())
        function icon.Entity:GetPlayerColor()
            return (LocalPlayer():GetPlayerColor())
        end
    end)

    InvGrid = vgui.Create("DGrid", Frame_Inventaire)
    InvGrid:gSetPos(492, 325)
    InvGrid:gSetSize(74.06, 74.06)
    InvGrid:SetCols(7)
    InvGrid:SetColWide(gRespX(83))
    InvGrid:SetRowHeight(gRespY(83))

    InvEquipGrid = vgui.Create("DGrid", Frame_Inventaire)
    InvEquipGrid:gSetPos(1100, 472)
    InvEquipGrid:gSetSize(56, 56)
    InvEquipGrid:SetCols(1)
    InvEquipGrid:SetColWide(gRespX(56))
    InvEquipGrid:SetRowHeight(gRespY(56))

    local equippedItems = {}
    local unequippedItems = {}
    nb = 0

    for k, v in pairs(INV_SL) do
        if sl_data[k] and sl_data[k] >= 1 then
            nb = nb + 1
        end

        if sl_data[k] and sl_data[k] >= 1 then
            if sl_data5[k] and sl_data5[k] >= 1 then
                table.insert(equippedItems, k)
            else
                table.insert(unequippedItems, k)
            end
        end
    end

    local function RefreshInventory()
        InvGrid:Clear()
        InvEquipGrid:Clear()

        for _, k in ipairs(unequippedItems) do
            local v = INV_SL[k]
            local InvBut = CreateInventoryButton(k, v)
            if sl_data[k] > 0 then
                InvGrid:AddItem(InvBut)
            end
        end

        for _, k in ipairs(equippedItems) do
            local v = INV_SL[k]
            local InvBut = CreateInventoryButton(k, v)
            if sl_data[k] > 0 then
                InvEquipGrid:AddItem(InvBut)
            end
        end
    end

    function CreateInventoryButton(k, v)
        if string.StartWith(v.type, "item") then
            InvBut = vgui.Create("DImage")

            if v.name == "Cristal Blanc" then
                InvBut:SetImage("mad_sololeveling/crystal_icon.png","smooth","clamps")
            elseif v.name == "Cristal Bleu" then
                InvBut:SetImage("mad_sololeveling/crystal_icon2.png","smooth","clamps")
            elseif v.name == "Cristal Rouge" then
                InvBut:SetImage("mad_sololeveling/crystal_icon3.png","smooth","clamps")
            elseif v.name == "Cristal Violet" then
                InvBut:SetImage("mad_sololeveling/crystal_icon4.png","smooth","clamps")
            elseif v.name == "Minerai de Mana" then
                InvBut:SetImage("mad_sololeveling/minerai.png","smooth","clamps")
            else
                InvBut:SetImage("mad_sololeveling/crystal_icon.png","smooth","clamps")
            end

            InvBut:gSetSize(77, 60)

        else
            InvBut = vgui.Create("DModelPanel")

            if v.type == "armure" and LocalPlayer():GetNWInt("Genre") == "male" then
                InvBut:SetModel(v.playermodel_male)
            elseif v.type == "armure" and LocalPlayer():GetNWInt("Genre") == "female" then
                InvBut:SetModel(v.playermodel_female)
            else
                InvBut:SetModel(v.model)
            end

            InvBut:GetEntity():SetAngles(Angle(0, 0, 0))
            InvBut:GetEntity():SetModelScale(v.scale * 2)
            function InvBut:LayoutEntity(ent)
            end
            
            -- InvBut:SetText(v.name)
            InvBut:SetTooltip(v.name)

            InvBut:gSetSize(77, 77)

            InvBut:SetTextColor(Color(219, 227, 255))

            InvBut:SetFont("M_Font3")
            InvBut:SetLookAt(InvBut:GetEntity():GetPos())
            if v.type == "armure" then
                InvBut:SetFOV(15)
            else
                InvBut:SetFOV(60)
            end

            -------------------------------------- Armure - Derma Menu --------------------------------------

            InvBut.DoRightClick = function()
                local DetailsDMenu = DermaMenu()

                if table.HasValue(equippedItems, k) then
                    DetailsDMenu:AddOption("Déséquiper", function()
                        if INV_SL[k].classe ~= "none" then
                            if LocalPlayer():GetNWString("Classe") ~= INV_SL[k].classe then
                                DisplayErrorNotification("ERREUR: Vous ne pouvez pas équiper cela, vous n’êtes pas de la bonne classe !")
                                return
                            end
                        end
        
                        if INV_SL[k].type == "item" then DisplayErrorNotification("ERREUR: Vous ne pouvez pas équiper un objet.") return end
                        if not table.HasValue(unequippedItems, k) then
                            table.RemoveByValue(equippedItems, k)
                            table.insert(unequippedItems, k)
        
                            if INV_SL[k].type == "arme" then
                                net.Start("SL:Mad - Inv:DeEquipWeapon")
                                net.WriteString(k)
                                net.SendToServer()
                            elseif INV_SL[k].type == "armure" then
                                net.Start("SL:Mad - Inv:DeEquipArmure")
                                net.WriteString(k)
                                net.SendToServer()
                            end
                        end

                        RefreshInventory()
                    end)
                else
                    DetailsDMenu:AddOption("Équiper", function()
                        if INV_SL[k].classe ~= "none" then
                            if LocalPlayer():GetNWString("Classe") ~= INV_SL[k].classe then
                                DisplayErrorNotification("ERREUR: Vous ne pouvez pas équiper cela, vous n’êtes pas de la bonne classe !")
                                return
                            end
                        end

                        if INV_SL[k].type == "armure" and LocalPlayer():GetNWInt("EquipArmure") == true then
                            DisplayErrorNotification("ERREUR: Vous avez déjà une armure équipé, veuillez la déséquipé.")
                        return end
                        
                        if INV_SL[k].type == "arme" and LocalPlayer():GetNWInt("EquipWeapon") == true then 
                            DisplayErrorNotification("ERREUR: Vous avez déjà une arme équipé, veuillez la déséquipé.") 
                        return end
    
                        table.RemoveByValue(unequippedItems, k)
                        table.insert(equippedItems, k)
    
                        if INV_SL[k].type == "arme" then
                            net.Start("SL:Mad - Inv:EquipWeapon")
                            net.WriteString(k)
                            net.SendToServer()
                        elseif INV_SL[k].type == "armure" then
                            net.Start("SL:Mad - Inv:EquipArmure")
                            net.WriteString(k)
                            net.SendToServer()
                        end
    
                        RefreshInventory()
                    end)
                end

                DetailsDMenu:AddOption("Jeter", function() 
                    net.Start("SL:Mad - Inv:JeterItem")
                    net.WriteString(k)
                    net.SendToServer()

                    if sl_data[k] <= 1 then
                        table.RemoveByValue(equippedItems, k)
                        table.RemoveByValue(unequippedItems, k)
                    end

                    if IsValid(Frame_Inventaire) then
                        timer.Destroy("IconUpdate" .. LocalPlayer():SteamID64())
                        Frame_Inventaire:Remove()
                    end
                end)

                if LocalPlayer():GetUserGroup() == "superadmin" then
                    DetailsDMenu:AddOption("Copier l'ID", function() 
                        SetClipboardText(v.model or v.playermodel_male or v.playermodel_female) 
                    end)
                end
                DetailsDMenu:Open()
                DetailsDMenu.Paint = function(self, w, h)
                    draw.RoundedBox(6, 0, 0, w, h, Color(30, 34, 38))
                end
            end

        end


        InvBut:SetContentAlignment(2)
        InvBut.InternalValue = k

        InvBut.DLabel = vgui.Create("DLabel", InvBut)
        InvBut.DLabel:SetText(sl_data[k])
        InvBut.DLabel:gSetPos(InvBut:GetX() + 68, InvBut:GetY())
        InvBut.DLabel:SetFont("M_Font3")

        InvBut:Droppable("InventoryItem")

        InvBut.OnStopDragging = function(self)

            local mx, my = gui.MousePos()

            if mx >= gRespX(1080) and mx <= gRespX(1080 + 341) and my >= gRespY(325) and my <= gRespY(325 + 486) then



                if INV_SL[self.InternalValue].type == "item" then DisplayErrorNotification("ERREUR: Vous ne pouvez pas équipé un objet.") return end
                
                if INV_SL[self.InternalValue].classe ~= "none" then
                    if LocalPlayer():GetNWString("Classe") ~= INV_SL[self.InternalValue].classe then
                        DisplayErrorNotification("ERREUR: Vous ne pouvez pas équiper cela, vous n’êtes pas de la bonne classe !")
                        return
                    end
                end

                if not table.HasValue(equippedItems, self.InternalValue) then

                    if INV_SL[self.InternalValue].type == "armure" and LocalPlayer():GetNWInt("EquipArmure") == true then
                        DisplayErrorNotification("ERREUR: Vous avez déjà une armure équipé, veuillez la déséquipé.") 
                    return end
                    
                    if INV_SL[self.InternalValue].type == "arme" and LocalPlayer():GetNWInt("EquipWeapon") == true then 
                        DisplayErrorNotification("ERREUR: Vous avez déjà une arme équipé, veuillez la déséquipé.") 
                    return end

                    table.RemoveByValue(unequippedItems, self.InternalValue)
                    table.insert(equippedItems, self.InternalValue)

                    if INV_SL[self.InternalValue].type == "arme" then
                        net.Start("SL:Mad - Inv:EquipWeapon")
                        net.WriteString(self.InternalValue)
                        net.SendToServer()
                    elseif INV_SL[self.InternalValue].type == "armure" then
                        net.Start("SL:Mad - Inv:EquipArmure")
                        net.WriteString(self.InternalValue)
                        net.SendToServer()
                    end
                end
            elseif mx >= gRespX(497) and mx <= gRespX(497 + 573.98) and my >= gRespY(325) and my <= gRespY(325 + 486.03) then

                if not table.HasValue(unequippedItems, self.InternalValue) then
                    table.RemoveByValue(equippedItems, self.InternalValue)
                    table.insert(unequippedItems, self.InternalValue)

                    if INV_SL[self.InternalValue].type == "arme" then
                        net.Start("SL:Mad - Inv:DeEquipWeapon")
                        net.WriteString(self.InternalValue)
                        net.SendToServer()
                    elseif INV_SL[self.InternalValue].type == "armure" then
                        net.Start("SL:Mad - Inv:DeEquipArmure")
                        net.WriteString(self.InternalValue)
                        net.SendToServer()
                    end
                end
            else
                if mx < gRespX(316) or mx > gRespX(1606) or my < gRespY(122) or my > gRespY(988) then
                    net.Start("SL:Mad - Inv:JeterItem")
                    net.WriteString(self.InternalValue)
                    net.SendToServer()

                    if sl_data[self.InternalValue] <= 1 then
                        table.RemoveByValue(equippedItems, self.InternalValue)
                        table.RemoveByValue(unequippedItems, self.InternalValue)
                    end

                    if IsValid(Frame_Inventaire) then
                        timer.Destroy("IconUpdate" .. LocalPlayer():SteamID64())
                        Frame_Inventaire:Remove()
                    end
                end
            end

            RefreshInventory()
        end

        return InvBut
    end

    RefreshInventory()
end

net.Receive("SL:OpenInventaire", function( len, ply )
    OpenInventaire()
end)

function OpenStatus()
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")

    local inv_selec = ""

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:Center()
    Frame_Status:SetTitle("")
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:MakePopup()
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function(s, w, h)
    surface.SetDrawColor(219, 227, 255, 255)
    surface.SetMaterial(Material("okiro/stats/base.png", "smooth", "clamps"))
    surface.DrawTexturedRect(gRespX(621), gRespY(192.78), gRespX(699), gRespY(684.6))

    surface.SetDrawColor(219, 227, 255, 255)
    surface.SetMaterial(Material("okiro/stats/title.png", "smooth", "clamps"))
    surface.DrawTexturedRect(gRespX(712), gRespY(260), gRespX(468), gRespY(38))

    surface.SetDrawColor(219, 227, 255, 255)
    surface.SetMaterial(Material("okiro/stats/stats.png", "smooth", "clamps"))
    surface.DrawTexturedRect(gRespX(712), gRespY(308), gRespX(517), gRespY(221))

    
    surface.SetDrawColor(219, 227, 255, 255)
    surface.SetMaterial(Material("okiro/stats/pdc.png", "smooth", "clamps"))
    surface.DrawTexturedRect(gRespX(712), gRespY(540), gRespX(517), gRespY(277))


    draw.DrawText(LocalPlayer():Nick(), "MNew_Font3", gRespX(836), gRespY(349.5), Color(219, 227, 255), TEXT_ALIGN_LEFT)

    if LocalPlayer():GetNWString("Classe") != "Aucune" then
        draw.DrawText(CLASSES_SL[LocalPlayer():GetNWString("Classe")].name, "MNew_Font3", gRespX(821), gRespY(386.5), Color(219, 227, 255), TEXT_ALIGN_LEFT)
    else
        draw.DrawText("Нету Класса", "MNew_Font3", gRespX(821), gRespY(386.5), Color(219, 227, 255), TEXT_ALIGN_LEFT)
    end

    if LocalPlayer():GetNWInt("Rang") != "Aucune" then
        draw.DrawText(LocalPlayer():GetNWInt("Rang"), "MNew_Font3", gRespX(816), gRespY(460.5), Color(219, 227, 255), TEXT_ALIGN_LEFT)
    else
        draw.DrawText("Нету Ранга", "MNew_Font3", gRespX(816), gRespY(460.5), Color(219, 227, 255), TEXT_ALIGN_LEFT)
    end

    draw.DrawText(LocalPlayer():getDarkRPVar("level"), "MNew_Font3", gRespX(1093), gRespY(423.5), Color(219, 227, 255), TEXT_ALIGN_LEFT)

    draw.DrawText(LocalPlayer():GetNWInt("mad_stamina"), "MNew_Font3", gRespX(1096), gRespY(349.5), Color(219, 227, 255), TEXT_ALIGN_LEFT)

    local money = LocalPlayer():getDarkRPVar("money")
    draw.DrawText(formatMoney(money), "MNew_Font3", gRespX(1089), gRespY(386.5), Color(219, 227, 255), TEXT_ALIGN_LEFT)

    draw.DrawText(sl_data2["force"], "MNew_Font3", gRespX(838), gRespY(678), Color(219, 227, 255), TEXT_ALIGN_LEFT) 
    draw.DrawText(sl_data2["agilite"], "MNew_Font3", gRespX(1106), gRespY(612), Color(219, 227, 255), TEXT_ALIGN_LEFT) 
    draw.DrawText(sl_data2["sens"], "MNew_Font3", gRespX(1093), gRespY(645), Color(219, 227, 255), TEXT_ALIGN_LEFT) 
    draw.DrawText(sl_data2["vitalite"], "MNew_Font3", gRespX(851), gRespY(612), Color(219, 227, 255), TEXT_ALIGN_LEFT) 
    draw.DrawText(sl_data2["intelligence"], "MNew_Font3", gRespX(885), gRespY(645), Color(219, 227, 255), TEXT_ALIGN_LEFT) 

    draw.DrawText(sl_data2["pts"], "MNew_Font3", gRespX(875), gRespY(748.5), Color(219, 227, 255), TEXT_ALIGN_LEFT) 
    draw.DrawText(sl_data2["rerollstats"], "MNew_Font3", gRespX(1123), gRespY(748.5), Color(219, 227, 255), TEXT_ALIGN_LEFT) 
end

local closeButton = vgui.Create("DButton", Frame_Status)
closeButton:gSetSize(41.63, 38.34)
closeButton:gSetPos(1187, 260)
closeButton:SetText("")
closeButton.Paint = function(s, w, h)
    surface.SetDrawColor(219, 227, 255, 255)
    surface.SetMaterial(Material("okiro/inventaire/close.png", "smooth"))
    surface.DrawTexturedRect(0, 0, w, h)
end
closeButton.DoClick = function()
    Frame_Status:Close()
end

    local ResetStats_Button = vgui.Create( "DButton", Frame_Status )
	ResetStats_Button:SetText( "" )
	ResetStats_Button:gSetPos(1025, 748.5) 
	ResetStats_Button:gSetSize(130, 29) 
	ResetStats_Button.DoClick = function()
		if IsValid(Frame_Status) then
            net.Start("SL:Mad - Stats:ResetStats")
            net.SendToServer()
		end
	end
	ResetStats_Button.Paint = function( s, self, w, h )
	end
    
    local Up_Force = vgui.Create( "DButton", Frame_Status )
	Up_Force:SetText( "" )
	Up_Force:gSetPos( 751, 681 )
	Up_Force:gSetSize( 22.01, 22.87) 
	Up_Force.DoClick = function()
		if IsValid(Frame_Status) then
            net.Start("SL:Mad - Stats:Up")
            net.WriteString("force")
            net.SendToServer()
		end
	end
	Up_Force.Paint = function( s, self, w, h )
	end

    local Up_Agilite = vgui.Create( "DButton", Frame_Status )
	Up_Agilite:SetText( "" )
	Up_Agilite:gSetPos( 1014, 615 )
	Up_Agilite:gSetSize( 22.01, 22.87 )
	Up_Agilite.DoClick = function()
		if IsValid(Frame_Status) then
            net.Start("SL:Mad - Stats:Up")
            net.WriteString("agilite")
            net.SendToServer()
		end
	end
	Up_Agilite.Paint = function( s, self, w, h )
	end

    local Up_Sens = vgui.Create( "DButton", Frame_Status )
	Up_Sens:SetText( "" )
	Up_Sens:gSetPos( 1014, 647.87) 
	Up_Sens:gSetSize( 22.01, 22.87) 
	Up_Sens.DoClick = function()
		if IsValid(Frame_Status) then
            net.Start("SL:Mad - Stats:Up")
            net.WriteString("sens")
            net.SendToServer()
		end
	end
	Up_Sens.Paint = function( s, self, w, h )
	end

    local Up_Vitalite = vgui.Create( "DButton", Frame_Status )
	Up_Vitalite:SetText( "" )
	Up_Vitalite:gSetPos( 751, 615) 
	Up_Vitalite:gSetSize( 22.01, 22.87) 
	Up_Vitalite.DoClick = function()
		if IsValid(Frame_Status) then
            net.Start("SL:Mad - Stats:Up")
            net.WriteString("vitalite")
            net.SendToServer()
		end
	end
	Up_Vitalite.Paint = function( s, self, w, h )
	end

    local Up_Intelligence = vgui.Create( "DButton", Frame_Status )
	Up_Intelligence:SetText( "" )
	Up_Intelligence:gSetPos( 751, 648) 
	Up_Intelligence:gSetSize( 22.01, 22.87) 
	Up_Intelligence.DoClick = function()
		if IsValid(Frame_Status) then
            net.Start("SL:Mad - Stats:Up")
            net.WriteString("intelligence")
            net.SendToServer()
		end
	end
	Up_Intelligence.Paint = function( s, self, w, h )
	end

end

net.Receive("SL:OpenSell", function( len, ply )

    local achat_selec = ""

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetPos(0, 0)
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("okiro/f4/base.png","smooth", "clamps"))
		surface.DrawTexturedRect(gRespX(305.64), gRespY(186.14), gRespX(1308.36), gRespY(708.72))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("shavkat/marchand/title3.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(497), gRespY(276), gRespX(510), gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1197.24),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1341),gRespY(284),gRespX(23.04),gRespY(21.91))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1014.79),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1160),gRespY(284),gRespX(23.04),gRespY(21.91))

        draw.SimpleText(LocalPlayer():getDarkRPVar("money") .. " ₩", "M_Font5", gRespX(1336), gRespY(294), Color(219, 227, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText("0" .. " OP", "M_Font5", gRespX(1155), gRespY(294), Color(219, 227, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    CloseB = vgui.Create("DButton", Frame_Status)
    CloseB:SetText("")
    CloseB:gSetPos(1379.57, 275.95)
    CloseB:gSetSize(41.63, 38.34)
    CloseB.DoClick = function()
        if IsValid(Frame_Status) then
            timer.Destroy("IconUpdate" .. LocalPlayer():SteamID64())
            Frame_Status:Remove()
        end
    end
    CloseB.Paint = function(self, w, h) 
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/close.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end

    local ScrollPanel = vgui.Create("DScrollPanel", Frame_Status)
    ScrollPanel:gSetPos(497, 326.41)
    ScrollPanel:gSetSize(924, 458.41)
    
    local InvGrid = vgui.Create("DGrid", ScrollPanel)
    InvGrid:gSetPos(0, 0)
    InvGrid:gSetSize(77, 77)
    InvGrid:SetCols(10)
    InvGrid:SetColWide(gRespX(94.4))
    InvGrid:SetRowHeight(gRespY(94.4))

    InvGrid.Paint = function( s, self, w, h )
    end

    for k, v in pairs(INV_SL) do
        if INV_SL[k].type == "item" then

            local InvBut = vgui.Create("DModelPanel")
            local InvBut2 = vgui.Create("DModelPanel", InvBut)

            if string.StartWith(v.type, "item") then
                InvButCrystal = vgui.Create("DImage", InvBut)
                InvButCrystal:SetSize(W(77), H(77))
    
                if v.name == "Crystal Blanc" then
                    InvButCrystal:SetImage("mad_sololeveling/crystal_icon.png")
                elseif v.name == "Crystal Bleu" then
                    InvButCrystal:SetImage("mad_sololeveling/crystal_icon2.png")
                elseif v.name == "Crystal Rouge" then
                    InvButCrystal:SetImage("mad_sololeveling/crystal_icon3.png")
                elseif v.name == "Crystal Violet" then
                    InvButCrystal:SetImage("mad_sololeveling/crystal_icon4.png")
                elseif v.name == "Minerai de Mana" then
                    InvBut:SetImage("mad_sololeveling/minerai.png")
                else
                    InvButCrystal:SetImage("mad_sololeveling/crystal_icon.png")
                end

                InvBut:MoveToFront()
                InvBut2:MoveToFront()

                InvBut2:SetModel("")
                InvBut:SetModel("")
                
            else

                InvBut2:SetModel(v.model)
                InvBut:SetModel(v.model)

                InvBut:SetLookAt(InvBut:GetEntity():GetPos())
                InvBut:GetEntity():SetAngles(Angle(0, 0, 0))
                InvBut:GetEntity():SetModelScale(v.scale * 2)

                InvBut2:SetLookAt(InvBut:GetEntity():GetPos())
                InvBut2:GetEntity():SetAngles(Angle(0, 0, 0))
                InvBut2:GetEntity():SetModelScale(v.scale * 2)
            end

            local breen_img = vgui.Create("DImage", InvBut)
            breen_img:SetPos(InvBut:GetX(), InvBut:GetY())
            breen_img:gSetSize(77, 77)
            breen_img:SetImage("mad_sololeveling/menu/new/casse")
            breen_img.Paint = function( s, self, w, h )
                surface.SetDrawColor(219, 227, 255, 100)
                surface.DrawOutlinedRect(W(0), H(0), W(77), H(77), 1.75)
                surface.SetDrawColor(0, 0, 0, 90)
                surface.DrawRect(W(0), H(0), W(77), H(77))
            end
            
            InvBut:gSetSize(77, 77)
            InvBut:SetModel(v.model)

            InvBut2:SetFOV(77)
            InvBut:SetFOV(77)

            InvBut:SetText(formatMoney(v.sellprice))
            InvBut:SetTooltip(v.name)
            InvBut:SetTextColor(Color(255, 255, 255))
            InvBut:SetContentAlignment(2)
            InvBut:SetFont("M_Font3")
            InvBut.InternalValue = k

            function InvBut:LayoutEntity(ent)
            end

            InvBut.Paint = function( s, self, w, h )
            end

            InvBut2:gSetSize(77, 77)
            InvBut2:SetFOV(80)

            InvBut2:SetText(formatMoney(v.sellprice))
            InvBut2:SetTooltip(v.name)
            InvBut2:SetTextColor(Color(255, 255, 255))
            InvBut2:SetFont("M_Font3")
            InvBut2:SetContentAlignment(2)
            InvBut2.InternalValue = k

            function InvBut:LayoutEntity(ent)
            end

            function InvBut2:LayoutEntity(ent)
            end
        
            InvBut2.DoClick = function(self)
                achat_selec = k
                net.Start("SL:Mad - Shop:Vendre")
                net.WriteString(achat_selec)
                net.SendToServer()
                print(achat_selec)

                if IsValid(Frame_Status) then Frame_Status:Remove() end
            end
        
                InvGrid:AddItem(InvBut)
            end
    end
    
end)

net.Receive("SL:OpenShop", function( len, ply )

    local achat_selec = ""
    local arme_selec = true 
    local armure_selec = false

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetPos(0, 0)
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("okiro/f4/base.png","smooth", "clamps"))
		surface.DrawTexturedRect(gRespX(305.64), gRespY(186.14), gRespX(1308.36), gRespY(708.72))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("shavkat/marchand/title.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(497), gRespY(275.95), gRespX(241), gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1197.24),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1341),gRespY(284),gRespX(23.04),gRespY(21.91))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1014.79),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1160),gRespY(284),gRespX(23.04),gRespY(21.91))

        draw.SimpleText(LocalPlayer():getDarkRPVar("money") .. " ₩", "M_Font5", gRespX(1336), gRespY(294), Color(219, 227, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText("0" .. " OP", "M_Font5", gRespX(1155), gRespY(294), Color(219, 227, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    CloseB = vgui.Create("DButton", Frame_Status)
    CloseB:SetText("")
    CloseB:gSetPos(1379.57, 275.95)
    CloseB:gSetSize(41.63, 38.34)
    CloseB.DoClick = function()
        if IsValid(Frame_Status) then
            timer.Destroy("IconUpdate" .. LocalPlayer():SteamID64())
            Frame_Status:Remove()
        end
    end
    CloseB.Paint = function(self, w, h) 
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/close.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end

    local ScrollPanel = vgui.Create("DScrollPanel", Frame_Status)
    ScrollPanel:gSetPos(497, 326.41)
    ScrollPanel:gSetSize(924, 458.41)

    ArmeSelec = vgui.Create("DButton", Frame_Status)
    ArmeSelec:SetText("")
    ArmeSelec:gSetPos(747, 276)
    ArmeSelec:gSetSize(126, 38.34)
    ArmeSelec.DoClick = function()
        if not arme_selec then
            arme_selec = true
            armure_selec = false
            shopRefresh()
        end
    end
    ArmeSelec.Paint = function(self, w, h) 
        if arme_selec then
            surface.SetDrawColor(219, 227, 255, 255)
            surface.SetMaterial(Material("shavkat/marchand/armes_select.png","smooth", "clamps"))
            surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
        else
            surface.SetDrawColor(219, 227, 255, 255)
            surface.SetMaterial(Material("shavkat/marchand/armes.png","smooth", "clamps"))
            surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
        end
    end

    ArmureSelec = vgui.Create("DButton", Frame_Status)
    ArmureSelec:SetText("")
    ArmureSelec:gSetPos(881, 276)
    ArmureSelec:gSetSize(126, 38.34)
    ArmureSelec.DoClick = function()
        if not armure_selec then
            armure_selec = true
            arme_selec = false
            shopRefresh()
        end
    end
    ArmureSelec.Paint = function(self, w, h) 
        if armure_selec then
            surface.SetDrawColor(219, 227, 255, 255)
            surface.SetMaterial(Material("shavkat/marchand/armures_select.png","smooth", "clamps"))
            surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
        else
            surface.SetDrawColor(219, 227, 255, 255)
            surface.SetMaterial(Material("shavkat/marchand/armures.png","smooth", "clamps"))
            surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
        end
    end

    local InvGrid = vgui.Create("DGrid", ScrollPanel)
    InvGrid:gSetPos(0, 0)
    InvGrid:gSetSize(77, 77)
    InvGrid:SetCols(10)
    InvGrid:SetColWide(gRespX(94.4))
    InvGrid:SetRowHeight(gRespY(94.4))

    InvGrid.Paint = function( s, self, w, h )
    end

    local sortedItems = {}

    function shopRefresh()
        if IsValid(InvGrid) then
            InvGrid:Clear()
        end
        
        sortedItems = {}
        for k, v in pairs(INV_SL) do
            if INV_SL[k].type != "item" then
                if INV_SL[k].teambuy == false then
                    if INV_SL[k].isforaspecialclass == true then
                        if LocalPlayer():GetNWString("Classe") == INV_SL[k].classe then 
                        if (arme_selec and INV_SL[k].type == "arme" and INV_SL[k].canbebuy == true) or (armure_selec and INV_SL[k].type == "armure" and INV_SL[k].canbebuy == true) then
                                table.insert(sortedItems, { key = k, price = v.price })
                            end
                        end
                    else
                        if (arme_selec and INV_SL[k].type == "arme" and INV_SL[k].canbebuy == true) or (armure_selec and INV_SL[k].type == "armure" and INV_SL[k].canbebuy == true) then
                            table.insert(sortedItems, { key = k, price = v.price })
                        end
                    end
                else
    
                    if LocalPlayer():Team() == INV_SL[k].theteam then
                        if (arme_selec and INV_SL[k].type == "arme" and INV_SL[k].canbebuy == true) or (armure_selec and INV_SL[k].type == "armure") and INV_SL[k].canbebuy == true then
                            table.insert(sortedItems, { key = k, price = v.price })
                        end
                    end
    
                end
            end
        end
    
        table.sort(sortedItems, function(a, b) return a.price < b.price end)
        
        for _, entry in ipairs(sortedItems) do
            local k = entry.key
            local v = INV_SL[k]
    
            local InvBut = vgui.Create("DModelPanel", InvGrid)
    
            local breen_img = vgui.Create("DImage", InvBut)
            breen_img:gSetPos(InvBut:GetX(), InvBut:GetY())
            breen_img:gSetSize(77, 77)
            breen_img:SetImage("mad_sololeveling/menu/new/casse")
            breen_img.Paint = function( s, self, w, h )
                surface.SetDrawColor(219, 227, 255, 100)
                surface.DrawOutlinedRect(W(0), H(0), W(77), H(77), 1.75)
                surface.SetDrawColor(0, 0, 0, 90)
                surface.DrawRect(W(0), H(0), W(77), H(77))
            end
            
            InvBut:gSetSize(77, 77)
            if v.type == "armure" && LocalPlayer():GetNWInt("Genre") == "male" then
                InvBut:SetModel(v.playermodel_male)
            elseif v.type == "armure" and LocalPlayer():GetNWInt("Genre") == "female" then
                InvBut:SetModel(v.playermodel_female)
            else
                InvBut:SetModel(v.model)
            end
    
            if v.type == "armure" then
                InvBut:SetFOV(20)
            else
                InvBut:SetFOV(50)
            end
    
            InvBut:SetText(formatMoney(v.price))
            InvBut:SetTooltip(v.name)
            InvBut:SetTextColor(Color(255, 255, 255))
            InvBut:SetContentAlignment(2)
            InvBut:SetFont("M_Font3")
            InvBut:SetLookAt(InvBut:GetEntity():GetPos())
            InvBut:GetEntity():SetAngles(Angle(0, 0, 0))
            InvBut:GetEntity():SetModelScale(v.scale * 2)
            InvBut.InternalValue = k
    
            function InvBut:LayoutEntity(ent)
            end
    
            InvBut.Paint = function( s, self, w, h )
            end
    
            local InvBut2 = vgui.Create("DModelPanel", InvBut)
            InvBut2:gSetSize(77, 77)
            if v.type == "armure" && LocalPlayer():GetNWInt("Genre") == "male" then
                InvBut2:SetModel(v.playermodel_male)
            elseif v.type == "armure" and LocalPlayer():GetNWInt("Genre") == "female" then
                InvBut2:SetModel(v.playermodel_female)
            else
                InvBut2:SetModel(v.model)
            end
    
            if v.type == "armure" then
                InvBut2:SetFOV(20)
            else
                InvBut2:SetFOV(50)
            end
    
            InvBut2:SetText("")
            InvBut2:SetTooltip(v.name)
            InvBut2:SetTextColor(Color(255, 255, 255))
            InvBut2:SetFont("M_Font3")
            InvBut2:SetLookAt(InvBut2:GetEntity():GetPos())
            InvBut2:GetEntity():SetAngles(Angle(0, 0, 0))
            InvBut2:GetEntity():SetModelScale(v.scale * 2)
            InvBut2.InternalValue = k
    
            function InvBut:LayoutEntity(ent)
            end
    
            function InvBut2:LayoutEntity(ent)
            end
        
            InvBut2.DoClick = function(self)
                achat_selec = k
                net.Start("SL:Mad - Shop:Acheter")
                net.WriteString(achat_selec)
                net.SendToServer()
    
                if IsValid(Frame_Status) then Frame_Status:Remove() end
            end
        
            InvGrid:AddItem(InvBut)
        end    
    end

    shopRefresh()
end)

concommand.Add("open_classe_menu", function()
    OpenClasseMenu()
end)


net.Receive("SL:OpenRevendeur", function( len, ply )

    local achat_selec = ""

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetPos(0, 0)
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("okiro/f4/base.png","smooth", "clamps"))
		surface.DrawTexturedRect(gRespX(305.64), gRespY(186.14), gRespX(1308.36), gRespY(708.72))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("shavkat/marchand/title2.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(497), gRespY(276), gRespX(510), gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1197.24),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1341),gRespY(284),gRespX(23.04),gRespY(21.91))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1014.79),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1160),gRespY(284),gRespX(23.04),gRespY(21.91))

        draw.SimpleText(LocalPlayer():getDarkRPVar("money") .. " ₩", "M_Font5", gRespX(1336), gRespY(294), Color(219, 227, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText("0" .. " OP", "M_Font5", gRespX(1155), gRespY(294), Color(219, 227, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    CloseB = vgui.Create("DButton", Frame_Status)
    CloseB:SetText("")
    CloseB:gSetPos(1379.57, 275.95)
    CloseB:gSetSize(41.63, 38.34)
    CloseB.DoClick = function()
        if IsValid(Frame_Status) then
            timer.Destroy("IconUpdate" .. LocalPlayer():SteamID64())
            Frame_Status:Remove()
        end
    end
    CloseB.Paint = function(self, w, h) 
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/close.png","smooth", "clamps"))
        surface.DrawTexturedRect(gRespX(0), gRespY(0), w, h)
    end

    local ScrollPanel = vgui.Create("DScrollPanel", Frame_Status)
    ScrollPanel:gSetPos(497, 326.41)
    ScrollPanel:gSetSize(924, 458.41)
    
    local InvGrid = vgui.Create("DGrid", ScrollPanel)
    InvGrid:gSetPos(0, 0)
    InvGrid:gSetSize(77, 77)
    InvGrid:SetCols(10)
    InvGrid:SetColWide(gRespX(94.4))
    InvGrid:SetRowHeight(gRespY(94.4))

    InvGrid.Paint = function( s, self, w, h )
    end

    local sortedItems = {}

    for k, v in pairs(INV_SL) do

        if sl_data[k] != nil and sl_data[k] > 0 then

            if INV_SL[k].type != "item" then
                if INV_SL[k].isforaspecialclass == true then
                    table.insert(sortedItems, { key = k, price = v.price })
                else
                    table.insert(sortedItems, { key = k, price = v.price })
                end
            end

        end
    end

    table.sort(sortedItems, function(a, b) return a.price < b.price end)
    
    for _, entry in ipairs(sortedItems) do
        local k = entry.key
        local v = INV_SL[k]

        local InvBut = vgui.Create("DModelPanel")

        local breen_img = vgui.Create("DImage", InvBut)
        breen_img:SetPos(InvBut:GetX(), InvBut:GetY())
        breen_img:SetSize(W(77), H(77))
        breen_img.Paint = function( s, self, w, h )
            surface.SetDrawColor(219, 227, 255, 100)
            surface.DrawOutlinedRect(W(0), H(0), W(77), H(77), 1.75)
            surface.SetDrawColor(0, 0, 0, 90)
            surface.DrawRect(W(0), H(0), W(77), H(77))
        end
        
        InvBut:SetSize(ScrW() * 0.046875, ScrH() * 0.08333333333)
        if v.type == "armure" && LocalPlayer():GetNWInt("Genre") == "male" then
            InvBut:SetModel(v.playermodel_male)
        elseif v.type == "armure" and LocalPlayer():GetNWInt("Genre") == "female" then
            InvBut:SetModel(v.playermodel_female)
        else
            InvBut:SetModel(v.model)
        end

        if v.type == "armure" then
            InvBut:SetFOV(20)
        else
            InvBut:SetFOV(50)
        end

        InvBut:SetText(formatMoney(v.price/2))
        InvBut:SetTooltip(v.name)
        InvBut:SetTextColor(Color(255, 255, 255))
        InvBut:SetContentAlignment(2)
        InvBut:SetFont("M_Font3")
        InvBut:SetLookAt(InvBut:GetEntity():GetPos())
        InvBut:GetEntity():SetAngles(Angle(0, 0, 0))
        InvBut:GetEntity():SetModelScale(v.scale * 2)
        InvBut.InternalValue = k

        function InvBut:LayoutEntity(ent)
        end

        InvBut.Paint = function( s, self, w, h )
        end

        local InvBut2 = vgui.Create("DModelPanel", InvBut)
        InvBut2:SetSize(ScrW() * 0.046875, ScrH() * 0.08333333333)
        if v.type == "armure" && LocalPlayer():GetNWInt("Genre") == "male" then
            InvBut2:SetModel(v.playermodel_male)
        elseif v.type == "armure" and LocalPlayer():GetNWInt("Genre") == "female" then
            InvBut2:SetModel(v.playermodel_female)
        else
            InvBut2:SetModel(v.model)
        end

        if v.type == "armure" then
            InvBut2:SetFOV(20)
        else
            InvBut2:SetFOV(50)
        end

        InvBut2:SetText("")
        InvBut2:SetTooltip(v.name)
        InvBut2:SetTextColor(Color(255, 255, 255))
        InvBut2:SetFont("M_Font3")
        InvBut2:SetLookAt(InvBut2:GetEntity():GetPos())
        InvBut2:GetEntity():SetAngles(Angle(0, 0, 0))
        InvBut2:GetEntity():SetModelScale(v.scale * 2)
        InvBut2.InternalValue = k

        function InvBut:LayoutEntity(ent)
        end

        function InvBut2:LayoutEntity(ent)
        end
    
        InvBut2.DoClick = function(self)
            achat_selec = k
            net.Start("SL:Mad - Shop:Revendre")
            net.WriteString(achat_selec)
            net.SendToServer()
            print(achat_selec)

            if IsValid(Frame_Status) then Frame_Status:Remove() end
        end
    
            InvGrid:AddItem(InvBut)
        end
end)



function OpenClasseMenu()
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")

    LocalPlayer():ConCommand("actu_client")

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(true)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function(s, self, w, h)
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/f4/base.png"))
        surface.DrawTexturedRect(gRespX(305.64), gRespY(186.14), gRespX(1308.36), gRespY(708.72))

        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/rerollclasse/title.png"))
        surface.DrawTexturedRect(gRespX(496.64), gRespY(275.95), gRespX(511.57), gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1197.24),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1341),gRespY(284),gRespX(23.04),gRespY(21.91))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1014.79),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1160),gRespY(284),gRespX(23.04),gRespY(21.91))


        
        draw.SimpleText(LocalPlayer():getDarkRPVar("money") .. " ₩", "M_Font5", gRespX(1336), gRespY(294), Color(219, 227, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText("0" .. " OP", "M_Font5", gRespX(1155), gRespY(294), Color(219, 227, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        draw.DrawText(sl_data3["classe"], "MNew_Font6", gRespX(915), gRespY(782), Color(255,255,255), TEXT_ALIGN_LEFT)
    end

    local positions = {
        {x = 497, y = 325},
        {x = 811, y = 325},
        {x = 1125, y = 325}
    }

    local function CreateCard(img, posIndex, parent)
        local card = vgui.Create("DImage", parent)
        card:SetImage(img)
        card:SetSize(gRespX(296), gRespY(417.71))
        card:SetPos(gRespX(positions[posIndex].x), gRespY(positions[posIndex].y))
        card.posIndex = posIndex
        return card
    end

    local cardLeft = CreateCard("okiro/rerollclasse/verso_card.png", 1, Frame_Status)
    local cardMiddle = CreateCard("okiro/rerollclasse/verso_card.png", 2, Frame_Status)
    local cardRight = CreateCard("okiro/rerollclasse/verso_card.png", 3, Frame_Status)

    local cards = {cardLeft, cardMiddle, cardRight}

    local function ShuffleCards()
        local shuffleOrder = {
            {1, 3}, {2, 1}, {3, 2}, {1, 2}, {3, 1}
        }

        for i, swap in ipairs(shuffleOrder) do
            timer.Simple(i * 0.4, function()
                if not IsValid(Frame_Status) then return end

                local cardA, cardB = cards[swap[1]], cards[swap[2]]
                
                local tempPos = cardA.posIndex
                cardA.posIndex = cardB.posIndex
                cardB.posIndex = tempPos
                
                cardA:MoveTo(gRespX(positions[cardA.posIndex].x), gRespY(positions[cardA.posIndex].y), 0.4, 0, -1)
                cardB:MoveTo(gRespX(positions[cardB.posIndex].x), gRespY(positions[cardB.posIndex].y), 0.4, 0, -1)

                cards[swap[1]], cards[swap[2]] = cardB, cardA
            end)
        end

        timer.Simple(#shuffleOrder * 0.4 + 0.5, function()
            if IsValid(Frame_Status) then
                Frame_Status:Remove()
                net.Start("SL:Mad - Classe:Start")
                net.SendToServer()
                MenuClasse2()
            end
        end)
    end

    local RerollB = vgui.Create("DImageButton", Frame_Status)
    RerollB:SetImage("okiro/rerollclasse/rerollbutton.png")
    RerollB:SetSize(gRespX(288), gRespY(43))
    RerollB:SetPos(gRespX(831), gRespY(776))
    RerollB:SetColor(Color(219, 227, 255, 255))
    
    RerollB.DoClick = function(self)

        local rerollCount = tonumber(sl_data3 and sl_data3["classe"]) or 0

        print (rerollCount)

        if rerollCount <= 0 then 
            DisplayErrorNotification("ERREUR: Vous avez 0 reroll disponible !")
            return 
        end

        ShuffleCards()
    end

    local CloseB = vgui.Create("DImageButton", Frame_Status)
    CloseB:SetImage("okiro/inventaire/close.png")
    CloseB:SetSize(gRespX(41.63), gRespY(38.34))
    CloseB:SetPos(gRespX(1379.57), gRespY(275.95))
    CloseB:SetColor(Color(255, 255, 255, 255))
    
    CloseB.DoClick = function()
        if IsValid(Frame_Status) then
            Frame_Status:Remove()
        end
    end
end

net.Receive("SL:OpenClasseMenu", function()
    OpenClasseMenu()
end)

function MenuClasse2()

    if sl_data3["classe"] < 1 then return end

	local function GetPlayerBodygroups(player)
		local bodygroups = {}
		for i = 0, player:GetNumBodyGroups() - 1 do
			bodygroups[i] = player:GetBodygroup(i)
		end
		return bodygroups
	end

    local playerBodygroups = GetPlayerBodygroups(LocalPlayer())

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("mad_sololeveling/menu/new/classe4.png"))
		surface.DrawTexturedRect(gRespX(0),gRespY(0),gRespX(1920),gRespY(1080))
    end

    B1 = vgui.Create( "DButton", Frame_Status )
    B1:SetText( "" )
    B1:gSetPos(460, 360)
    B1:gSetSize( 300, 500) 
    B1.Paint = function( s, self, w, h )
    end
    timer.Simple(0.6, function()
        B1.Paint = function( s, self, w, h )
            if IsValid(B1) then
                surface.SetDrawColor(219, 227, 255, 255)
                surface.SetMaterial(Material(CLASSES_SL[Classe1].img))
                surface.DrawTexturedRect(0, 0, gRespX(300), gRespY(500))
                draw.DrawText( CLASSES_SL[Classe1].name, "MNew_Font6", gRespX(150), gRespY(40), Color(255,255,255), TEXT_ALIGN_CENTER )
                if IsValid(iconB1) then
                    iconB1:SetModel( CLASSES_SL[Classe1].mdl )
                end
            end
        end  

        iconB1.DoClick = function()
            if IsValid(Frame_Status) then
                surface.PlaySound( "buttons/button15.wav" )
                Frame_Status:Remove()
                OpenClasseMenu()
                net.Start("SL:Mad - Classe:Choix")
                net.WriteFloat(1)
                net.SendToServer()
            end
        end
    end)

    iconB1 = vgui.Create( "DModelPanel", Frame_Status )
    iconB1:gSetSize(300,500)
    iconB1:gSetPos(460,360)
    iconB1:SetFOV(45)
    timer.Simple(0.6, function()
        if IsValid(iconB1) then
            iconB1:SetModel( CLASSES_SL[Classe1].mdl )
            for index, value in pairs(playerBodygroups) do
                iconB1.Entity:SetBodygroup(index, value)
            end
            function iconB1.Entity:GetPlayerColor() return (LocalPlayer():GetPlayerColor()) end 
        end
    end)

    B2 = vgui.Create( "DButton", Frame_Status )
    B2:SetText( "" )
    B2:gSetPos(800, 360)
    B2:gSetSize(300, 500)
    B2.Paint = function( s, self, w, h )
    end
    timer.Simple(0.6, function()
        B2.Paint = function( s, self, w, h )
            if IsValid(B2) then
                surface.SetDrawColor(219, 227, 255, 255)
                surface.SetMaterial(Material(CLASSES_SL[Classe2].img))
                surface.DrawTexturedRect(0, 0, 300, 500)
                draw.DrawText( CLASSES_SL[Classe2].name, "MNew_Font6", gRespX(150), gRespY(40), Color(255,255,255), TEXT_ALIGN_CENTER ) 
                if IsValid(iconB2) then
                    iconB2:SetModel( CLASSES_SL[Classe2].mdl )
                end
            end
        end 
        
        iconB2.DoClick = function()
            if IsValid(Frame_Status) then
                surface.PlaySound( "buttons/button15.wav" )
                Frame_Status:Remove()
                OpenClasseMenu()
                net.Start("SL:Mad - Classe:Choix")
                net.WriteFloat(2)
                net.SendToServer()
            end
        end
    end)

    iconB2 = vgui.Create( "DModelPanel", Frame_Status )
    iconB2:gSetSize(300,500)
    iconB2:gSetPos(800,360)
    iconB2:SetFOV(45)
    timer.Simple(0.6, function()
        if IsValid(iconB2) then
            iconB2:SetModel( CLASSES_SL[Classe2].mdl )
            for index, value in pairs(playerBodygroups) do
                iconB2.Entity:SetBodygroup(index, value)
            end
            function iconB2.Entity:GetPlayerColor() return (LocalPlayer():GetPlayerColor()) end 
        end
    end)

    B3 = vgui.Create( "DButton", Frame_Status )
    B3:SetText( "" )
    B3:gSetPos(1140, 360)
    B3:gSetSize(300, 500)
    B3.Paint = function( s, self, w, h )
    end
    timer.Simple(0.6, function()
        B3.Paint = function( s, self, w, h )
            if IsValid(B3) then
                surface.SetDrawColor(219, 227, 255, 255)
                surface.SetMaterial(Material(CLASSES_SL[Classe3].img))
                surface.DrawTexturedRect(0, 0, 300, 500)
                draw.DrawText( CLASSES_SL[Classe3].name, "MNew_Font6", gRespX(150), gRespY(40), Color(255,255,255), TEXT_ALIGN_CENTER )
                if IsValid(iconB3) then
                    iconB3:SetModel( CLASSES_SL[Classe3].mdl )
                end
            end
        end  
    end)
    
    iconB3 = vgui.Create( "DModelPanel", Frame_Status )
    iconB3:gSetSize(300,500)
    iconB3:gSetPos(1140,360)
    iconB3:SetFOV(45)
    timer.Simple(0.6, function()
        if IsValid(iconB3) then
            iconB3:SetModel( CLASSES_SL[Classe3].mdl )
            for index, value in pairs(playerBodygroups) do
                iconB3.Entity:SetBodygroup(index, value)
            end
            function iconB3.Entity:GetPlayerColor() return (LocalPlayer():GetPlayerColor()) end
        end

        iconB3.DoClick = function()
            if IsValid(Frame_Status) then
                surface.PlaySound( "buttons/button15.wav" )
                Frame_Status:Remove()
                OpenClasseMenu()
                net.Start("SL:Mad - Classe:Choix")
                net.WriteFloat(3)
                net.SendToServer()
            end
        end
    end)
    
end

function OpenRangMenu()
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")

    LocalPlayer():ConCommand("actu_client")

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetPos(552, 232)
    Frame_Status:gSetSize(814, 611)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(true)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function(s, w, h)
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("mad_sololeveling/menu/new/rang5.png"))
        surface.DrawTexturedRect(gRespX(0), gRespY(0), gRespX(814), gRespY(611))
        draw.DrawText(sl_data3["rang"], "MNew_Font6", gRespX(295), gRespY(421), Color(255,255,255), TEXT_ALIGN_LEFT)
    end

    local CloseB = vgui.Create("DButton", Frame_Status)
    CloseB:SetText("")
    CloseB:gSetPos(1289-552, 330-280)
    CloseB:gSetSize(31, 35)
    CloseB.DoClick = function()
        if IsValid(Frame_Status) then Frame_Status:Remove() end
    end
    CloseB.Paint = function() end

    local RerollB = vgui.Create("DImageButton", Frame_Status)
    RerollB:SetImage("mad_sololeveling/menu/new/rerollbutton.png")
    RerollB:gSetPos(734-552, 598-250)
    RerollB:gSetSize(179, 60)
    RerollB:SetColor(Color(219, 227, 255, 255))

    local function SetButtonColor(r, g, b, a) RerollB:SetColor(Color(r, g, b, a)) end
    local function ResetButtonColor() SetButtonColor(219, 227, 255, 255) end

    RerollB.OnCursorEntered = function()
        RerollB:MoveTo(gRespX(719-552), gRespY(590-250), 0.2)
        RerollB:SizeTo(gRespX(220), gRespY(80), 0.2)
    end 
    RerollB.OnCursorExited = function()
        RerollB:MoveTo(gRespX(734-552), gRespY(598-250), 0.2)
        RerollB:SizeTo(gRespX(179), gRespY(60), 0.2)
    end

    RerollB.DoClick = function()
        timer.Simple(0.25, function()
            if IsValid(Frame_Status) then Frame_Status:Remove() end
            net.Start("SL:Mad - Rang:Start")
            net.SendToServer()
            MenuRang2()
        end)

        SetButtonColor(100, 100, 100, 255)
        timer.Simple(0.2, ResetButtonColor)
    end
end

net.Receive("SL:OpenRangMenu", function()
    OpenRangMenu()
end)


function CL_RandomRang()
    local totalPourcent = 0
    for _, rang in pairs(RANG_SL) do
        totalPourcent = totalPourcent + rang.pourcent
    end

    local randomValue = math.random() * totalPourcent
    local cumulative = 0

    for rank, data in pairs(RANG_SL) do
        cumulative = cumulative + data.pourcent
        if randomValue <= cumulative then
            return rank
        end
    end
end

function MenuRang2()

    if sl_data3["rang"] < 1 then return end

    timer.Create("RdmRangRoulette", 0.2, 20, function()
        random_rank = CL_RandomRang()
    end)
    timer.Simple(5, function()
        random_rank = LocalPlayer():GetNWInt("Rang_Reroll")
    end)

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetPos(552, 232)
    Frame_Status:gSetSize(814, 611)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("mad_sololeveling/menu/new/rang5.png"))
		surface.DrawTexturedRect(gRespX(0),gRespY(0),gRespX(814),gRespY(611))
        draw.DrawText( sl_data3["rang"], "MNew_Font6", gRespX(295), gRespY(421), Color(255,255,255), TEXT_ALIGN_LEFT ) 

        if random_rank and RANG_SL[random_rank] and RANG_SL[random_rank].color then
            draw.SimpleTextOutlined(RANG_SL[random_rank].name, "M_Font2", gRespX(734-460), gRespY(598-220), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1,RANG_SL[random_rank].color )        
        end
        
    end

    local RerollB = vgui.Create( "DImageButton", Frame_Status )
    RerollB:SetImage( "mad_sololeveling/menu/new/button.png" )	
	RerollB:gSetPos( 734-552, 598-250) 
	RerollB:gSetSize( 179, 60) 
    RerollB:SetColor(Color(219, 227, 255, 255))

    timer.Simple(7, function()
        Frame_Status:Remove()
        OpenRangMenu()
        DisplayNotification("Vous avez obtenu : ".. LocalPlayer():GetNWInt("Rang_Reroll"))

    end)

end

function OpenSkillsMenu()
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")

    local inv_selec = ""

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/skills/base.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(649),gRespY(256.88),gRespX(621),gRespY(565.23))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/skills/title.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(757.33),gRespY(326.6),gRespX(373.24),gRespY(40.76))

        surface.SetDrawColor(219, 227, 255, 100)
        surface.DrawOutlinedRect(gRespX(757.33),gRespY(378.08),gRespX(425.8),gRespY(390.41), 1.75)

    end
    
    local CloseB = vgui.Create( "DButton", Frame_Status )
	CloseB:SetText( "" )
	CloseB:gSetPos( 1138.08, 326.6)
	CloseB:gSetSize( 44.65, 41.12)
	CloseB.DoClick = function()
		if IsValid(Frame_Status) then
            timer.Destroy("IconUpdate"..LocalPlayer():SteamID64())
			Frame_Status:Remove()
		end
	end
	CloseB.Paint = function( s, self, w, h )
        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/skills/close.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(0),gRespY(0),gRespX(44.65),gRespY(40.76))
	end

    local A = vgui.Create( "DButton", Frame_Status )
	A:SetText( "" )
    A:gSetPos(768.41, 390.03)
    A:gSetSize(407.64, 367.06)
    A.Paint = function( s, self, w, h )
	end

    local DScrollPanel = vgui.Create( "DScrollPanel", A )
    DScrollPanel:Dock( FILL )

    local DScrollBar = DScrollPanel:GetVBar()
    DScrollBar:gSetSize(6, 367.06)
    DScrollBar:SetHideButtons(true) 
    function DScrollBar:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 219, 227, 255, 10 ) )
        surface.SetDrawColor(219, 227, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h, 1 )
    end
    function DScrollBar.btnGrip:Paint(w, h)
        draw.RoundedBox( 0, 0, 0, w, h, Color( 219, 227, 255, 255 ) )
    end

    local sortedItems = {}

    for k, v in pairs(SKILLS_SL) do
        v.level = v.level or 0
        if SKILLS_SL[k].ismagie == true then
            if SKILLS_SL[k].element == LocalPlayer():GetNWInt("Magie") then table.insert(sortedItems, { key = k, level = v.level }) end
        else
            table.insert(sortedItems, { key = k, level = v.level })
        end
    end

    table.sort(sortedItems, function(a, b) return a.level > b.level end)
    
    for _, entry in ipairs(sortedItems) do
        local k = entry.key
        local v = SKILLS_SL[k]
        if sl_data4[k] and sl_data4[k] >= 1 and LocalPlayer():GetNWString("Classe") == SKILLS_SL[k].classe then

            local Skill_IMG = DScrollPanel:Add( "DImageButton" )
            Skill_IMG:gSetSize(403.64, 57.08)
            Skill_IMG:Dock( TOP )
            Skill_IMG:DockMargin( 0, 0, 0, 5 )
            Skill_IMG:SetImage("okiro/skills/main.png")

            local Skill_Icon = vgui.Create("DImage", Skill_IMG)	
            Skill_Icon:gSetPos(10.6, 9)	
            Skill_Icon:gSetSize(39.96, 39.96)
            Skill_Icon:SetImage( v.icon )
            Skill_Icon:SetImageColor(Color(219, 227, 255, 255))
            Skill_Icon.Paint = function(self, w, h)
                surface.SetDrawColor(219, 227, 255, 255)
                surface.DrawOutlinedRect(gRespX(0),gRespY(0),gRespX(39.96),gRespY(39.96), 1)

                surface.SetDrawColor(219, 227, 255, 255)
                surface.SetMaterial(Material(v.icon, "smooth", "clamps"))
                surface.DrawTexturedRect(gRespX(4.08),gRespY(4.08),gRespX(31.77),gRespY(31.77))
            end

            local Skill_Label = vgui.Create( "DLabel", Skill_IMG )
            Skill_Label:gSetPos(64.42, 19)	
            Skill_Label:gSetSize(200, Skill_Label:GetTall())
            Skill_Label:SetFont("M_Font5")
            Skill_Label:SetTextColor(Color(219, 227, 255, 255))
            Skill_Label:SetText( v.name .. " (NIV. " .. v.level .. ")" )

            local Skill_Equipped = vgui.Create( "DLabel", Skill_IMG )
            -- Skill_Equipped:SetText("Non équipé")
            Skill_Equipped:gSetPos(312, 19)
            Skill_Equipped:gSetSize(90, Skill_Label:GetTall())
            Skill_Equipped:SetFont("M_Font5")
            Skill_Equipped:SetTextColor(Color(219, 227, 255, 255))

            local data = file.Read("sl_data/" .. LocalPlayer():SteamID64() .. "/binds_save.json", "DATA")
            if data then
                for _, option in ipairs(options) do
                    if string.find(data, k) then
                        Skill_Equipped:SetText("Équipé")
                        Skill_Equipped:gSetPos(340,19)
                    else    
                        Skill_Equipped:SetText("Non équipé")
                        Skill_Equipped:gSetPos(312, 19)
                    end
                end
            else
                Skill_Equipped:SetText("Non équipé")
                Skill_Equipped:gSetPos(312, 19)
            end

            function Skill_IMG:DoClick()

                if IsValid(Bind1) then Bind1:Remove() end
                if IsValid(Bind2) then Bind2:Remove() end
                if IsValid(Bind3) then Bind3:Remove() end
                if IsValid(Bind4) then Bind4:Remove() end
                if IsValid(Bind5) then Bind5:Remove() end
                if IsValid(Close) then Close:Remove() end

                timer.Simple(0.1, function()
                    Bind1 = vgui.Create( "DButton", Frame_Status )
                    Bind1:SetText( "" )
                    Bind1:gSetPos(1190, 378)
                    Bind1:SetText("1")
                    Bind1:SetFont("M_Font1")
                    Bind1:SetTextColor(Color(219, 227, 255, 255))
                    Bind1:gSetSize( 50, 50)
                    Bind1.DoClick = function()
                    end             
                    Bind1.Paint = function(self,w,h)
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(0, 0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(0, 0, w, h)
                    end
                    function Bind1:DoClick()
                        Skill_Equipped:SetText("Équipé")
                        Skill_Equipped:gSetPos(340, 19)
    
                        net.Start("SL:Mad - Skills:Bind")
                        net.WriteFloat(1)
                        net.WriteString(k)
                        net.SendToServer()
    
                        if IsValid(Bind1) then Bind1:Remove() end
                        if IsValid(Bind2) then Bind2:Remove() end
                        if IsValid(Bind3) then Bind3:Remove() end
                        if IsValid(Bind4) then Bind4:Remove() end
                        if IsValid(Bind5) then Bind5:Remove() end
                        if IsValid(Close) then Close:Remove() end
    
                    end
    
                    Bind2 = vgui.Create( "DButton", Frame_Status )
                    Bind2:SetText( "" )
                    Bind2:gSetPos(1190, 378 + 57.5)
                    Bind2:SetText("2")
                    Bind2:SetFont("M_Font1")
                    Bind2:SetTextColor(Color(219, 227, 255, 255))
                    Bind2:gSetSize( 50, 50) 
                    Bind2.DoClick = function()
                    end
                    Bind2.Paint = function(self,w,h)
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(0, 0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(0, 0, w, h)
                    end
                    function Bind2:DoClick()
                        Skill_Equipped:SetText("Équipé")
                        Skill_Equipped:gSetPos(340, 19)
    
                        net.Start("SL:Mad - Skills:Bind")
                        net.WriteFloat(2)
                        net.WriteString(k)
                        net.SendToServer()
    
                        if IsValid(Bind1) then Bind1:Remove() end
                        if IsValid(Bind2) then Bind2:Remove() end
                        if IsValid(Bind3) then Bind3:Remove() end
                        if IsValid(Bind4) then Bind4:Remove() end
                        if IsValid(Bind5) then Bind5:Remove() end
                        if IsValid(Close) then Close:Remove() end
    
                    end
    
                    Bind3 = vgui.Create( "DButton", Frame_Status )
                    Bind3:SetText( "" )
                    Bind3:gSetPos(1190, 378 + (57.5 * 2))
                    Bind3:SetText("3")
                    Bind3:SetFont("M_Font1")
                    Bind3:SetTextColor(Color(219, 227, 255, 255))
                    Bind3:gSetSize( 50, 50)
                    Bind3.DoClick = function()
                    end
                    Bind3.Paint = function(self,w,h)
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(0, 0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(0, 0, w, h)
                    end
                    function Bind3:DoClick()
                        Skill_Equipped:SetText("Équipé")
                        Skill_Equipped:gSetPos(340, 19)
    
                        net.Start("SL:Mad - Skills:Bind")
                        net.WriteFloat(3)
                        net.WriteString(k)
                        net.SendToServer()
    
                        if IsValid(Bind1) then Bind1:Remove() end
                        if IsValid(Bind2) then Bind2:Remove() end
                        if IsValid(Bind3) then Bind3:Remove() end
                        if IsValid(Bind4) then Bind4:Remove() end
                        if IsValid(Bind5) then Bind5:Remove() end
                        if IsValid(Close) then Close:Remove() end
    
                    end
    
                    Bind4 = vgui.Create( "DButton", Frame_Status )
                    Bind4:SetText( "" )
                    Bind4:gSetPos(1190, 378 + (57.5 * 3))
                    Bind4:SetText("4")
                    Bind4:SetFont("M_Font1")
                    Bind4:SetTextColor(Color(219, 227, 255, 255))
                    Bind4:gSetSize( 50, 50)
                    Bind4.DoClick = function()
                    end
                    Bind4.Paint = function(self,w,h)
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(0, 0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(0, 0, w, h)
                    end
                    function Bind4:DoClick()
                        Skill_Equipped:SetText("Équipé")
                        Skill_Equipped:gSetPos(340, 19)
    
                        net.Start("SL:Mad - Skills:Bind")
                        net.WriteFloat(4)
                        net.WriteString(k)
                        net.SendToServer()
    
                        if IsValid(Bind1) then Bind1:Remove() end
                        if IsValid(Bind2) then Bind2:Remove() end
                        if IsValid(Bind3) then Bind3:Remove() end
                        if IsValid(Bind4) then Bind4:Remove() end
                        if IsValid(Bind5) then Bind5:Remove() end
                        if IsValid(Close) then Close:Remove() end
    
                    end
    
                    Bind5 = vgui.Create( "DButton", Frame_Status )
                    Bind5:SetText( "" )
                    Bind5:gSetPos(1190, 378 + (57.5 * 4))
                    Bind5:SetText("5")
                    Bind5:SetFont("M_Font1")
                    Bind5:SetTextColor(Color(219, 227, 255, 255))
                    Bind5:gSetSize( 50, 50)
                    Bind5.DoClick = function()
                    end
                    Bind5.Paint = function(self,w,h)
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(0, 0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(0, 0, w, h)
                    end
                    function Bind5:DoClick()
                        Skill_Equipped:SetText("Équipé")
                        Skill_Equipped:gSetPos(340, 19)
    
                        net.Start("SL:Mad - Skills:Bind")
                        net.WriteFloat(5)
                        net.WriteString(k)
                        net.SendToServer()
    
                        if IsValid(Bind1) then Bind1:Remove() end
                        if IsValid(Bind2) then Bind2:Remove() end
                        if IsValid(Bind3) then Bind3:Remove() end
                        if IsValid(Bind4) then Bind4:Remove() end
                        if IsValid(Bind5) then Bind5:Remove() end
                        if IsValid(Close) then Close:Remove() end
    
                    end
    
                    Close = vgui.Create( "DButton", Frame_Status )
                    Close:SetText( "" )
                    Close:gSetPos(1190, 378 + (57.5 * 5))
                    Close:SetText("X")
                    Close:SetFont("M_Font1")
                    Close:SetTextColor(Color(219, 227, 255, 255))
                    Close:gSetSize(50, 50)
                    Close.DoClick = function()
                    end
                    Close.Paint = function(self,w,h)
                        surface.SetDrawColor(219, 227, 255, 255)
                        surface.DrawOutlinedRect(0, 0, w, h, 1.75)
                        surface.SetDrawColor(0, 0, 0, 100)
                        surface.DrawRect(0, 0, w, h)
                    end
                    function Close:DoClick()
                        if IsValid(Bind1) then Bind1:Remove() end
                        if IsValid(Bind2) then Bind2:Remove() end
                        if IsValid(Bind3) then Bind3:Remove() end
                        if IsValid(Bind4) then Bind4:Remove() end
                        if IsValid(Bind5) then Bind5:Remove() end
                        if IsValid(Close) then Close:Remove() end
    
                    end    
                end)
            end
        end
    end
end

function MainSkillMenu()
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")
    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)
    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/base.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(305.64),gRespY(186.14),gRespX(1308.36),gRespY(708.72))

        if LocalPlayer():GetNWString("Classe") ~= "mage" then
            surface.SetDrawColor(219, 227, 255, 255)
            surface.SetMaterial(Material("okiro/f4reroll/Reroll Magie.png","smooth","clamps"))
            surface.DrawTexturedRect(gRespX(497), gRespY(573), gRespX(923.63), gRespY(231.56))

            surface.SetDrawColor(0, 0, 0, 200)
            surface.DrawRect(gRespX(497), gRespY(573), gRespX(923.63), gRespY(231.56))

            surface.SetTextPos(gRespX(810), gRespY(670))
            surface.SetFont("M_Font3")
            surface.SetTextColor(Color(219, 227, 255, 255))
            surface.DrawText("Vous ne possédez pas la classe \"Mage\"", false)
        end

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4reroll/title.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(497),gRespY(275.95),gRespX(511.57),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1197.24),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/golds.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1341),gRespY(284),gRespX(23.04),gRespY(21.91))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op_bg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1014.79),gRespY(275.95),gRespX(175.76),gRespY(38.34))

        surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("okiro/f4/op.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1160),gRespY(284),gRespX(23.04),gRespY(21.91))

        draw.SimpleText(LocalPlayer():getDarkRPVar("money") .. " ₩", "M_Font5", gRespX(1336), gRespY(294), Color(219, 227, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText("0" .. " OP", "M_Font5", gRespX(1155), gRespY(294), Color(219, 227, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    local function CreateZoomButton(parent, x, y, w, h, image, clickFunc, zoomFactor)
        local normalW, normalH = gRespX(w), gRespY(h)
        local targetW, targetH = normalW, normalH
        local isHovered = false

        local btn = vgui.Create("DImageButton", parent)
        btn:SetPos(x, y)
        btn:SetSize(normalW, normalH)
        btn:SetImage(image)

        btn.OnCursorEntered = function(s)
            surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")
            targetW, targetH = normalW * zoomFactor, normalH * zoomFactor
            isHovered = true
        end

        btn.OnCursorExited = function(s)
            targetW, targetH = normalW, normalH
            isHovered = false
        end

        btn.Think = function(s)
            local curW, curH = s:GetSize()
            s:SetSize(Lerp(FrameTime() * 6, curW, targetW), Lerp(FrameTime() * 6, curH, targetH))
            s:SetPos(x - (s:GetWide() - normalW) / 2, y - (s:GetTall() - normalH) / 2)
        end

        btn.DoClick = function()
            clickFunc()
            if IsValid(Frame_Status) then Frame_Status:Remove() end
        end
    end

    CreateZoomButton(Frame_Status, gRespX(496.76), gRespY(325.05), 924.24, 236.56, "okiro/f4reroll/Reroll Classe.png", function()
        RunConsoleCommand( CardShuffle.Config.Command )
    end, 1.06)

    CreateZoomButton(Frame_Status, gRespX(497), gRespY(573), 923.63, 231.56, "okiro/f4reroll/Reroll Magie.png", function()
        RunConsoleCommand( MagieReroll.Config.Command )
    end, 1.06)

    local CloseB = vgui.Create("DButton", Frame_Status)
    CloseB:SetText("")
    CloseB:SetPos(gRespX(1379), gRespY(275.95))
    CloseB:SetSize(gRespX(41.63), gRespY(38.34))
    CloseB.DoClick = function()
        if IsValid(Frame_Status) then Frame_Status:Remove() end
    end
    CloseB.Paint = function(s, w, h)
        surface.SetDrawColor(219, 227, 255, 255)
        surface.SetMaterial(Material("okiro/inventaire/close.png", "smooth", "clamps"))
        surface.DrawTexturedRect(0, 0, w, h)
    end
end

net.Receive("SL:OpenSkillsMenu", function( len, ply )
    OpenSkillsMenu()
end)

local activeNotifications = {}

local function UpdateNotificationPositions(y)
    local yPos = gRespY(y)
    for _, panel in ipairs(activeNotifications) do
        panel:gSetPos(panel:GetPos(), yPos)
        yPos = yPos + panel:GetTall() + 5
    end
end

function DisplayNotification(message)
    local duration = 5

    surface_PlaySound("mad_sfx_sololeveling/voice/notification.wav")

    local notificationPanel = vgui.Create("DPanel")
    notificationPanel:gSetSize(848, 85)
    notificationPanel:SlideDown(0.1)
    notificationPanel:gSetPos(536, 29)

    notificationPanel.Paint = function(self, w, h)
        surface.SetMaterial(Material("okiro/notifications/notifbg2.png"))
        surface.SetDrawColor(219, 227, 255, 255)
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetMaterial(Material("okiro/notifications/notiftitle.png"))
        surface.SetDrawColor(219, 227, 255, 255)
        surface.DrawTexturedRect(gRespX(365.3), gRespY(13), gRespX(130), gRespY(27))

        draw.SimpleText(message, "M_Font1", w / 2, h / 1.5, Color(200, 212, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    table.insert(activeNotifications, notificationPanel)

    UpdateNotificationPositions(29)

    timer.Simple(duration-1, function()
        notificationPanel:MoveTo(gRespX(536), gRespY(29) -150, 0.15, 0, 1)
    end)

    timer.Simple(duration, function()
        if IsValid(notificationPanel) then
            notificationPanel:Remove()

            for i, panel in ipairs(activeNotifications) do
                if panel == notificationPanel then
                    table.remove(activeNotifications, i)
                    break
                end
            end

            UpdateNotificationPositions(29)
        end
    end)
end

function DisplayErrorNotification(message)
    surface_PlaySound("mad_sfx_sololeveling/voice/notification.wav")
    local duration = 5

    local notificationPanel = vgui.Create("DPanel")
    notificationPanel:gSetSize(750, 38)
    notificationPanel:SlideDown(0.1)
    notificationPanel:gSetPos(585, 32)

    notificationPanel.Paint = function(self, w, h)
        surface.SetMaterial(Material("shavkat/notifications/error.png"))
        surface.SetDrawColor(255, 219, 219, 255)
        surface.DrawTexturedRect(0, 0, w, h)

        draw.SimpleText(message, "M_Font5", w / 2, h / 2, Color(255, 219, 219), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    table.insert(activeNotifications, notificationPanel)

    UpdateNotificationPositions(32)

    timer.Simple(duration-1, function()
        notificationPanel:MoveTo(gRespX(585), gRespY(29) -150, 0.15, 0, 1)
    end)

    timer.Simple(duration, function()
        if IsValid(notificationPanel) then
            notificationPanel:Remove()

            for i, panel in ipairs(activeNotifications) do
                if panel == notificationPanel then
                    table.remove(activeNotifications, i)
                    break
                end
            end

            UpdateNotificationPositions(32)
        end
    end)
end

function DisplayLevelNotification(message)
    surface_PlaySound("mad_sfx_sololeveling/voice/notification.wav")
    local duration = 5

    local notificationPanel = vgui.Create("DPanel")
    
    notificationPanel:gSetSize(511.57, 38)
    notificationPanel:SlideDown(0.1)
    notificationPanel:gSetPos(704, 50)

    notificationPanel.Paint = function(self, w, h)
        surface.SetMaterial(Material("okiro/notifications/notifbg.png"))
        surface.SetDrawColor(219, 247, 219, 255)
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetMaterial(Material("okiro/notifications/notificon.png"))
        surface.SetDrawColor(219, 247, 219, 255)
        surface.DrawTexturedRect(gRespX(7),gRespY(1.5),gRespX(32),gRespY(36))

        draw.SimpleText(message, "M_Font5", w / 2, h / 2, Color(255, 247, 219), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    table.insert(activeNotifications, notificationPanel)

    UpdateNotificationPositions(50)

    timer.Simple(duration-1, function()
        notificationPanel:MoveTo(gRespX(704), gRespY(29) -150, 0.15, 0, 1)
    end)

    timer.Simple(duration, function()
        if IsValid(notificationPanel) then
            notificationPanel:Remove()

            for i, panel in ipairs(activeNotifications) do
                if panel == notificationPanel then
                    table.remove(activeNotifications, i)
                    break
                end
            end

            UpdateNotificationPositions(50)
        end
    end)
end

net.Receive("SL:Notification", function()
    local ply = LocalPlayer()
    local message = net.ReadString()
    timer.Simple(0.8, function()
        DisplayNotification(message)
    end)
end)

net.Receive("SL:LevelNotification", function()
    local ply = LocalPlayer()
    local message = net.ReadString()
    DisplayLevelNotification(message)
end)

net.Receive("SL:ErrorNotification", function()
    local ply = LocalPlayer()
    local message = net.ReadString()
    DisplayErrorNotification(message)
end)

function OpenMagieMenu_Choisir()
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")
    if sl_data3["magie"] < 1 then return end

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)
    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("mad_sololeveling/menu/new/new_magie2.png"))
		surface.DrawTexturedRect(gRespX(0),gRespY(0),gRespX(1920),gRespY(1080))
        draw.DrawText( "Rerolls restant : ".. sl_data3["magie"], "M_Font2", gRespX(500), gRespY(829), Color(255,255,255), TEXT_ALIGN_LEFT ) 
    end

    local FeuB = vgui.Create( "DButton", Frame_Status )
	FeuB:SetText( "" )
	FeuB:gSetPos( 638, 480 )
	FeuB:gSetSize( 93, 133 )
	FeuB.DoClick = function()
		if IsValid(Frame_Status) then
			Frame_Status:Remove()
		end
        net.Start("SL:Mad - Magie:Choisir")
        net.WriteString(1)
        net.SendToServer()
	end
	FeuB.Paint = function( s, self, w, h )
	end

    local EauB = vgui.Create( "DButton", Frame_Status )
	EauB:SetText( "" )
	EauB:gSetPos( 802, 483) 
	EauB:gSetSize( 121, 132) 
	EauB.DoClick = function()
		if IsValid(Frame_Status) then
			Frame_Status:Remove()
		end
        net.Start("SL:Mad - Magie:Choisir")
        net.WriteString(2)
        net.SendToServer()
	end
	EauB.Paint = function( s, self, w, h )
	end

    local TerreB = vgui.Create( "DButton", Frame_Status )
	TerreB:SetText( "" )
	TerreB:gSetPos( 993, 500) 
	TerreB:gSetSize( 140, 86)
	TerreB.DoClick = function()
		if IsValid(Frame_Status) then
			Frame_Status:Remove()
		end
        net.Start("SL:Mad - Magie:Choisir")
        net.WriteString(3)
        net.SendToServer()
	end
	TerreB.Paint = function( s, self, w, h )
	end

    local VentB = vgui.Create( "DButton", Frame_Status )
	VentB:SetText( "" )
	VentB:gSetPos( 1201, 483) 
	VentB:gSetSize( 115, 125) 
	VentB.DoClick = function()
		if IsValid(Frame_Status) then
			Frame_Status:Remove()
		end
        net.Start("SL:Mad - Magie:Choisir")
        net.WriteString(4)
        net.SendToServer()
	end
	VentB.Paint = function( s, self, w, h )
	end

end

function OpenMagieAleatoireMenu()
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetPos(552, 232)
    Frame_Status:gSetSize(814, 611)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(true)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)
    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("mad_sololeveling/menu/new/1new_magie3.png"))
		surface.DrawTexturedRect(gRespX(0),gRespY(0),gRespX(814),gRespY(611))
        draw.DrawText( sl_data3["magie"], "MNew_Font6", gRespX(295), gRespY(421), Color(255,255,255), TEXT_ALIGN_LEFT )
    end

    local CloseB = vgui.Create( "DButton", Frame_Status )
	CloseB:SetText( "" )
	CloseB:gSetPos( 1289-552, 330-280) 
	CloseB:gSetSize( 31, 35) 
	CloseB.DoClick = function()
		if IsValid(Frame_Status) then
			Frame_Status:Remove()
		end
	end
    CloseB.Paint = function( s, self, w, h )
    end

    local RerollB = vgui.Create( "DImageButton", Frame_Status )
    RerollB:SetImage( "mad_sololeveling/menu/new/rerollbutton.png" )	
	RerollB:gSetPos( gRespX(734-552), gRespY(598-250) )
	RerollB:gSetSize( gRespX(179), gRespY(60) )
    RerollB:SetColor(Color(219, 227, 255, 255))
    
    local function SetButtonColor(r, g, b, a)
        RerollB:SetColor(Color(r, g, b, a))
    end
    
    local function ResetButtonColor()
        SetButtonColor(219, 227, 255, 255)
    end

    RerollB.OnCursorEntered = function(self)
        self:MoveTo(gRespX(719-552), gRespY(590-250), 0.2)
        self:SizeTo(gRespX(220), gRespY(80), 0.2) 
    end
    
    RerollB.OnCursorExited = function(self)
        self:MoveTo(gRespX(734-552), gRespY(598-250), 0.2)
        self:SizeTo(gRespX(179), gRespY(60), 0.2) 
    end
    
    RerollB.DoClick = function(self)

        timer.Simple(0.25, function()
            if IsValid(Frame_Status) then
                Frame_Status:Remove()
            end

            net.Start("SL:Mad - Magie:Start")
            net.SendToServer()

            MenuMagie2()
        end)

        SetButtonColor(100, 100, 100, 255)

        timer.Simple(0.2, function()
            ResetButtonColor()
        end)
    end
    

end


MAGIE_RARITY_CHANCES = {
    ["commun"] = 75,
    ["rare"] = 20,
    ["legendaire"] = 5,
}

function GetRandomRarity_Magie()
    local totalChances = 0
    for rarity, chance in pairs(MAGIE_RARITY_CHANCES) do
        totalChances = totalChances + chance
    end

    local randNum = math.random(1, totalChances)

    local cumulativeChance = 0
    for rarity, chance in pairs(MAGIE_RARITY_CHANCES) do
        cumulativeChance = cumulativeChance + chance
        if randNum <= cumulativeChance then
            return rarity
        end
    end

    return "commun" 
end

function GetRandomMagieByRarity(rarity)
    local possibleMagies = {}

    for magieName, classData in pairs(MAGIE_SL) do
        if classData.rarete == rarity then
            table.insert(possibleMagies, magieName)
        end
    end

    if #possibleMagies > 0 then
        local randomMagieName = table.Random(possibleMagies)
        return randomMagieName
    else
        return "feu"
    end
end

function MenuMagie2()

    if sl_data3["magie"] < 1 then return end

    timer.Create("RdmMagieRoulette", 0.2, 20, function()
        random_magie = GetRandomMagieByRarity(GetRandomRarity_Magie())
    end)
    timer.Simple(4.2, function()
        random_magie = Magie
    end)

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetPos(552, 232)
    Frame_Status:gSetSize(814, 611)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("mad_sololeveling/menu/new/1new_magie3.png"))
		surface.DrawTexturedRect(gRespX(0),gRespY(0),gRespX(814),gRespY(611))
        draw.DrawText( sl_data3["magie"], "MNew_Font6", gRespX(295), gRespY(421), Color(255,255,255), TEXT_ALIGN_LEFT ) 

        if random_magie and MAGIE_SL[random_magie] and MAGIE_SL[random_magie].color then
            draw.SimpleTextOutlined(MAGIE_SL[random_magie].name, "M_Font2", gRespX(734-460), gRespY(598-220), Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1,MAGIE_SL[random_magie].color )        
        end
        
    end

    local RerollB = vgui.Create( "DImageButton", Frame_Status )
    RerollB:SetImage( "mad_sololeveling/menu/new/button.png" )	
	RerollB:gSetPos( 734-552, 598-250)
	RerollB:gSetSize( 179, 60) 
    RerollB:SetColor(Color(219, 227, 255, 255))

    timer.Simple(7, function()
        Frame_Status:Remove()

        DisplayNotification("Vous avez obtenu : "..MAGIE_SL[random_magie].name)

    end)

end

function OpenMagieMenu()
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")

    LocalPlayer():ConCommand("actu_client")

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("mad_sololeveling/menu/new/magie1.png"))
		surface.DrawTexturedRect(gRespX(0),gRespY(0),gRespX(1920),gRespY(1080))
        draw.DrawText( "Rerolls restant : ".. sl_data3["magie"], "M_Font2", gRespX(500), gRespY(829), Color(255,255,255), TEXT_ALIGN_LEFT ) 
    end

    local CloseB = vgui.Create( "DButton", Frame_Status )
	CloseB:SetText( "" )
	CloseB:gSetPos( 1433, 221) 
	CloseB:gSetSize( 26, 26) 
	CloseB.DoClick = function()
		if IsValid(Frame_Status) then
			Frame_Status:Remove()
		end
	end
	CloseB.Paint = function( s, self, w, h )
	end

    local ChoisirB = vgui.Create( "DButton", Frame_Status )
	ChoisirB:SetText( "" )
	ChoisirB:gSetPos( 709.54, 679.21) 
	ChoisirB:gSetSize( 222.64, 75.34) 
	ChoisirB.DoClick = function()
		if IsValid(Frame_Status) then
			Frame_Status:Remove()
		end
        OpenMagieMenu_Choisir()
	end
	ChoisirB.Paint = function( s, self, w, h )
	end

    local AleatoireB = vgui.Create( "DButton", Frame_Status )
	AleatoireB:SetText( "" )
	AleatoireB:gSetPos( 993.83, 676.73)
	AleatoireB:gSetSize(222.64, 75.34)
	AleatoireB.DoClick = function()
		if IsValid(Frame_Status) then
			Frame_Status:Remove()
		end

        OpenMagieAleatoireMenu()
	end
	AleatoireB.Paint = function( s, self, w, h )
	end

end

net.Receive("SL:OpenMagieMenu", function( len, ply )
    OpenMagieMenu()
end)

concommand.Add("openmagiemenu", function()
    OpenMagieMenu()
end)

function OpenCoiffeurMenu(entity)
    surface.PlaySound("mad_sfx_sololeveling/voice/ouverture.wav")

    local Frame_Status = vgui.Create("DFrame")
    Frame_Status:gSetSize(1920, 1080)
    Frame_Status:SetTitle("")
    Frame_Status:MakePopup()
    Frame_Status:SetDraggable(false)
    Frame_Status:ShowCloseButton(false)
    Frame_Status:SlideDown(0.4)

    Frame_Status.Paint = function( s, self, w, h )
		surface.SetDrawColor(219, 227, 255, 255)
		surface.SetMaterial(Material("mad_sololeveling/menu/new/menu_coiffeur.png"))
		surface.DrawTexturedRect(gRespX(0),gRespY(0),gRespX(1920),gRespY(1080))

        draw.DrawText( "Cheveux : ", "MNew_Font6", gRespX(563), gRespY(449), Color(255,255,255), TEXT_ALIGN_CENTER ) 
        draw.DrawText( "Prix : 20.000 ₩", "MNew_Font6", gRespX(563), gRespY(800), Color(255,255,255), TEXT_ALIGN_CENTER ) 
    end

    local CloseB = vgui.Create( "DButton", Frame_Status )
	CloseB:SetText( "" )
	CloseB:gSetPos( 1433, 221 )
	CloseB:gSetSize( 26, 26 )
	CloseB.DoClick = function()
		if IsValid(Frame_Status) then
			Frame_Status:Remove()
		end
	end
	CloseB.Paint = function( s, self, w, h )
	end

    mdl = vgui.Create("DModelPanel", Frame_Status)
    mdl:gSetSize(346, 439)
    mdl:gSetPos(1080, 411)
    mdl:SetFOV(50)
    function mdl:LayoutEntity(Entity)
    return
    end

    if LocalPlayer():GetNWInt("Genre") == "male" then

        mdl:SetModel("models/mad_models/mad_sl_male_civil1.mdl")

        CharacterCreator_SliderCheveux = vgui.Create( "DNumSlider", Frame_Status )
        CharacterCreator_SliderCheveux:gSetPos( 380, 457)				
        CharacterCreator_SliderCheveux:gSetSize( 600, 18)			
        CharacterCreator_SliderCheveux:SetText( "" )	
        CharacterCreator_SliderCheveux:SetMin( 0 )				 	
        CharacterCreator_SliderCheveux:SetMax( 42 )				
        CharacterCreator_SliderCheveux:SetDecimals( 0 )				
    
        CharacterCreator_SliderCheveux.OnValueChanged = function( self, value )
            mdl.Entity:SetBodygroup(3, value)
          LocalPlayer():SetNWInt("Coiffeur_Cheveux", value)
        end
    else

        mdl:SetModel("models/mad_models/mad_sl_female1.mdl")

        CharacterCreator_SliderCheveux = vgui.Create( "DNumSlider", Frame_Status )
        CharacterCreator_SliderCheveux:gSetPos( 380, 457 )				
        CharacterCreator_SliderCheveux:gSetSize( 600,18 )			
        CharacterCreator_SliderCheveux:SetText( "" )	
        CharacterCreator_SliderCheveux:SetMin( 0 )				 	
        CharacterCreator_SliderCheveux:SetMax( 18 )				
        CharacterCreator_SliderCheveux:SetDecimals( 0 )				
    
        CharacterCreator_SliderCheveux.OnValueChanged = function( self, value )
            mdl.Entity:SetBodygroup(2, value)
          LocalPlayer():SetNWInt("Coiffeur_Cheveux", value)
        end
    end

    local headpos = mdl.Entity:GetBonePosition(mdl.Entity:LookupBone("ValveBiped.Bip01_Head1"))
    mdl:SetLookAt(headpos)

    mdl:SetCamPos(headpos-Vector(-30, 0, 0))	

    local CoifferB = vgui.Create( "DButton", Frame_Status )
	CoifferB:SetText( "" )
	CoifferB:gSetPos(600, 562) 
	CoifferB:gSetSize(222, 75) 
	CoifferB.DoClick = function()
		if IsValid(Frame_Status) then
			Frame_Status:Remove()
		end
        net.Start("SL:Mad - Coiffeur:Change")
        net.WriteFloat(LocalPlayer():GetNWInt("Coiffeur_Cheveux"))
        net.WriteEntity(entity)
        net.SendToServer()
	end
	CoifferB.Paint = function( s, self, w, h )
	end

end

net.Receive("SL:Mad - Coiffeur:Menu", function( len, ply )
    local entity = net.ReadEntity()

    OpenCoiffeurMenu(entity)
end)


--------------------------------------------------------------------------------------
------------------------ ADMIN -------------------------------------------------------

function OpenMenu()
    if LocalPlayer():GetUserGroup() ~= "responsable" and LocalPlayer():GetUserGroup() ~= "superadmin" then 
        LocalPlayer():ChatPrint("У вас нет прав доступа к этому меню.") 
        return 
    end
    
    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400, 400)
    frame:ShowCloseButton(true)
    frame:SetHeader("Меню - Выдача предметов")
    frame:Center()
    frame:MakePopup()

    timer.Simple(0.25, function()
        playerList = vgui.Create("DListView", frame)
        playerList:gSetPos(50, 50)
        playerList:gSetSize(300, 150)
        playerList:AddColumn("Игроки")
        playerList:AddColumn("SteamID64")

        for _, ply in ipairs(player.GetAll()) do
            playerList:AddLine(ply:Nick(), ply:SteamID64()).player = ply
        end
    end)

    local itemList = vgui.Create("DComboBox", frame)
    itemList:gSetPos(50, 220)
    itemList:gSetSize(300, 30)
    itemList:SetValue("Выберите предмет")

    local temp = {}
    for k, v in pairs(INV_SL) do
        local itemDisplay = "[" .. string.upper(v.classe) .. "] " .. v.name
        table.insert(temp, itemDisplay)
    end

    table.sort(temp)

    local printed = {}

    for _, name in ipairs(temp) do
        itemList:AddChoice(name)
        -- if not printed[name] then
            
        --     printed[name] = true
        -- end
    end

    local sendButton = vgui.Create("TLButton", frame)
    sendButton:gSetPos(50, 270)
    sendButton:gSetSize(300, 30)
    sendButton:SetText("Выдать предмет")

    sendButton.DoClick = function()
        local selectedLine = playerList:GetSelectedLine()
        local selectedItem = itemList:GetValue()

        if selectedLine and selectedItem then
            local plySteamID = playerList:GetLine(selectedLine):GetValue(2)

            DisplayNotification("Вы выдали предмет " .. selectedItem .. " игроку " .. playerList:GetLine(selectedLine).player:Nick())

            net.Start("SL:Mad - Admin:GiveItem")
            net.WriteString(plySteamID)
            net.WriteString(selectedItem)
            net.SendToServer()
        else
            DisplayErrorNotification("ОШИБКА: Выберите игрока и предмет.")
        end
    end
end
 
function OpenMenuRerollsAdmin()
    if LocalPlayer():GetUserGroup() ~= "responsable" and LocalPlayer():GetUserGroup() ~= "superadmin" then 
        LocalPlayer():ChatPrint("У вас нет прав доступа к этому меню.") 
        return 
    end
    
    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400, 375)
    frame:ShowCloseButton(true)
    frame:SetHeader("Выдача Rerolls/Очков")
    frame:Center()
    frame:MakePopup()

    timer.Simple(0.25, function()
        playerList = vgui.Create("DListView", frame)
        playerList:gSetPos(50, 75)
        playerList:gSetSize(300, 150)
        playerList:AddColumn("Игроки")

        for _, ply in ipairs(player.GetAll()) do
            playerList:AddLine(ply:Nick()).player = ply
        end
    end)

    local itemList = vgui.Create("DComboBox", frame)
    itemList:gSetPos(gRespX(50), gRespY(220))
    itemList:gSetSize(gRespX(300), gRespY(30))
    itemList:SetValue("Выберите действие")

    itemList:AddChoice("Добавить Reroll Магии")
    itemList:AddChoice("Добавить Reroll Ранга")
    itemList:AddChoice("Добавить Reroll Класса")
    itemList:AddChoice("Добавить Reset Статов")
    itemList:AddChoice("Добавить Очки статов")
    itemList:AddChoice("Удалить Reroll Магии")
    itemList:AddChoice("Удалить Reroll Ранга")
    itemList:AddChoice("Удалить Reroll Класса")
    itemList:AddChoice("Удалить Reset Статов")
    itemList:AddChoice("Удалить Очки статов")
    
    local rerollAmountSlider = vgui.Create("DNumSlider", frame)
    rerollAmountSlider:gSetPos(50, 270)
    rerollAmountSlider:gSetSize(300, 30)
    rerollAmountSlider:SetText("Количество")
    rerollAmountSlider:SetMin(1)
    rerollAmountSlider:SetMax(100)
    rerollAmountSlider:SetDecimals(0)
    rerollAmountSlider:SetValue(1)

    local sendButton = vgui.Create("TLButton", frame)
    sendButton:gSetPos(50, 320)
    sendButton:gSetSize(300, 30)
    sendButton:SetText("Выдать")

    sendButton.DoClick = function()
        local selectedLine = playerList:GetSelectedLine()
        local selectedItem = itemList:GetValue()
        local rerollAmount = rerollAmountSlider:GetValue()  

        if selectedLine and selectedItem then
            local ply = playerList:GetLine(selectedLine).player

            DisplayNotification("Вы добавили "..rerollAmount.." "..selectedItem.." игроку "..ply:Nick())

            net.Start("SL:Mad - Admin:AddRerolls")
            net.WriteEntity(ply)
            net.WriteString(selectedItem)
            net.WriteFloat(rerollAmount)  
            net.SendToServer()
        else
            DisplayErrorNotification("ОШИБКА: Выберите игрока и действие.")
        end
    end
end
function OpenPortailMenu()
    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400,400)
    frame:ShowCloseButton(true)
    frame:SetHeader("Меню - Порталы SL")
    frame:Center()
    frame:MakePopup()

    local portalList = vgui.Create("DListView", frame)
    portalList:gSetPos(gRespX(50), gRespY(50))
    portalList:gSetSize(gRespX(300), gRespY(300))
    portalList:AddColumn("Порталы SL")

    for _, ent in ipairs(ents.FindByClass("portail_sl")) do
        portalList:AddLine("Ранг портала : ".. ent:GetNWInt("Rang")).entity = ent
    end

    for _, ent in ipairs(ents.FindByClass("portail_break_sl")) do
        portalList:AddLine("[D-BREAK] Портал неизвестного ранга").entity = ent
    end

    portalList.OnRowRightClick = function(panel, line)
        local menu = DermaMenu()

        menu:AddOption("Телепортироваться", function()
            local ent = portalList:GetLine(line).entity
            net.Start("SL:Portail:Teleport")
            net.WriteEntity(ent)
            net.SendToServer()
        end):SetIcon("icon16/arrow_right.png")

        menu:AddOption("Открыть портал", function()
            local ent = portalList:GetLine(line).entity
            net.Start("SL:Portail:Open")
            net.WriteEntity(ent)
            net.SendToServer()
        end):SetIcon("icon16/door_open.png")

        menu:AddOption("Закрыть портал", function()
            local ent = portalList:GetLine(line).entity
            net.Start("SL:Portail:Close")
            net.WriteEntity(ent)
            net.SendToServer()
        end):SetIcon("icon16/door.png")

        menu:AddOption("Удалить портал", function()
            local ent = portalList:GetLine(line).entity
            net.Start("SL:Portail:Delete")
            net.WriteEntity(ent)
            net.SendToServer()
        end):SetIcon("icon16/cancel.png")

        menu:AddOption("Активировать Dungeon Break", function()
            local ent = portalList:GetLine(line).entity
            net.Start("SL:Portail:DungeonBreak")
            net.WriteEntity(ent)
            net.SendToServer()
        end):SetIcon("icon16/bomb.png")

        menu:Open()
    end
end

function OpenPortalMenu()
    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400, 500)
    frame:ShowCloseButton( true )
    frame:SetHeader( "Меню - Порталы SL" )
    frame:Center()
    frame:MakePopup()

    local rankList = {}
    for k, v in pairs(PORTAIL_SL) do
        rankList[v.rang] = rankList[v.rang] or {}
        table.insert(rankList[v.rang], v)
    end

    for rank, portals in pairs(rankList) do
        local button = vgui.Create("TLButton", frame)
        button:SetText("Портал " .. rank .. " ранга")
        button:gSetSize(350, 40)
        button:Dock(TOP)
        button:DockMargin(0, 15, 0, 1)
        
        button.DoClick = function()
            DisplayNotification("Вы создали портал " .. rank .. " ранга")

            local portalID = portals[math.random(#portals)].id
            net.Start("SpawnPortal")
            net.WriteString(portalID)
            net.SendToServer()
        end
    end
end

----------------------------------------------------------------------------------------

net.Receive("SL:Okiro:OpenGeneralMenu", function(len, ply)
    if LocalPlayer():GetUserGroup() ~= "responsable" and LocalPlayer():GetUserGroup() ~= "superadmin" and LocalPlayer():GetUserGroup() ~= "admin" then 
        LocalPlayer():ChatPrint("У вас нет прав доступа к этому меню.") 
        return 
    end

    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400, 500)
    frame:ShowCloseButton(true)
    frame:SetHeader("Админ-меню Okiro")
    frame:Center()
    frame:MakePopup()

    local button1 = vgui.Create("TLButton", frame)
    button1:SetText("Меню - Выдать предмет")
    button1:gSetPos(50, 75)
    button1:gSetSize(300, 50)
    button1.DoClick = function()
        OpenMenu()
        frame:Remove()
    end

    local button2 = vgui.Create("TLButton", frame)
    button2:SetText("Меню - Выдать рероллы/очки")
    button2:gSetPos(50, 145)
    button2:gSetSize(300, 50)
    button2.DoClick = function()
        OpenMenuRerollsAdmin()
        frame:Remove()
    end

    local button3 = vgui.Create("TLButton", frame)
    button3:SetText("Меню спавна - Порталы SL")
    button3:gSetPos(50, 215)
    button3:gSetSize(300, 50)
    button3.DoClick = function()
        OpenPortalMenu()
        frame:Remove()
    end

    local button4 = vgui.Create("TLButton", frame)
    button4:SetText("Меню - Порталы SL")
    button4:gSetPos(50, 285)
    button4:gSetSize(300, 50)
    button4.DoClick = function()
        OpenPortailMenu()
        frame:Remove()
    end

    local button5 = vgui.Create("TLButton", frame)
    button5:SetText("Меню выдачи")
    button5:SetColor(Color(0, 102, 255))
    button5:gSetPos(50, 355)
    button5:gSetSize(300, 50)
    button5.DoClick = function(self)
        OpenGiveMenu()
        frame:Remove()

        if self:IsHovered() then
            self:SetColor(Color(0, 102, 255))
        end
    end

    local button6 = vgui.Create("TLButton", frame)
    button6:SetText("Ролевое меню")
    button6:SetColor(Color(255, 0, 0))
    button6:gSetPos(50, 425)
    button6:gSetSize(300, 50)
    button6.DoClick = function(self)
        OpenRoleplayMenu()
        frame:Remove()

        if self:IsHovered() then
            self:SetColor(Color(255, 0, 0))
        end
    end
end)

---------------------------------------------------------------------------------------

function OpenGiveMenu()
    if LocalPlayer():GetUserGroup() ~= "responsable" and LocalPlayer():GetUserGroup() ~= "superadmin" and LocalPlayer():GetUserGroup() ~= "admin" then 
        LocalPlayer():ChatPrint("У вас нет прав доступа к этому меню.") 
        return 
    end

    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400, 375)
    frame:ShowCloseButton(true)
    frame:SetHeader("Меню выдачи Okiro")
    frame:Center()
    frame:MakePopup()

    local button4 = vgui.Create("TLButton", frame)
    button4:SetText("Меню - Выдача ранга")
    button4:gSetPos(50, 75)
    button4:gSetSize(300, 50)
    button4.DoClick = function()
        OpenRangGiveMenu()
        frame:Remove()
    end

    local button5 = vgui.Create("TLButton", frame)
    button5:SetText("Меню - Выдача класса")
    button5:gSetPos(50, 145)
    button5:gSetSize(300, 50)
    button5.DoClick = function()
        OpenClasseGiveMenu()
        frame:Remove()
    end

    local button6 = vgui.Create("TLButton", frame)
    button6:SetText("Меню - Выдача магии")
    button6:gSetPos(50, 215)
    button6:gSetSize(300, 50)
    button6.DoClick = function()
        OpenMagieGiveMenu()
        frame:Remove()
    end

    local button4 = vgui.Create("TLButton", frame)
    button4:SetText("Меню - Выдача заклинаний")
    button4:gSetPos(50, 285)
    button4:gSetSize(300, 50)
    button4.DoClick = function()
        OpenSkillGiveMenu()
        frame:Remove()
    end
end

function OpenRoleplayMenu()
    if LocalPlayer():GetUserGroup() ~= "responsable" and LocalPlayer():GetUserGroup() ~= "superadmin" and LocalPlayer():GetUserGroup() ~= "admin" then 
        LocalPlayer():ChatPrint("У вас нет прав доступа к этому меню.") 
        return 
    end
    
    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400, 200)
    frame:ShowCloseButton(true)
    frame:SetHeader("Ролевое меню Okiro")
    frame:Center()
    frame:MakePopup()

    local button1 = vgui.Create("TLButton", frame)
    button1:SetText("Меню - Убийство персонажа")
    button1:gSetPos(50, 75)
    button1:gSetSize(300, 50)
    button1.DoClick = function()
        CKMenu()
        frame:Remove()
    end
end

---------------------------------------------------------------------------------------

function CKMenu()
    if LocalPlayer():GetUserGroup() ~= "responsable" and LocalPlayer():GetUserGroup() ~= "superadmin" and LocalPlayer():GetUserGroup() ~= "admin" then 
        LocalPlayer():ChatPrint("У вас нет прав доступа к этому меню.") 
        return 
    end
    
    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400, 300)
    frame:ShowCloseButton(true)
    frame:SetHeader("Убийство персонажа")
    frame:Center()
    frame:MakePopup()

    timer.Simple(0.25, function()
        playerList = vgui.Create("DListView", frame)
        playerList:gSetPos(50, 75)
        playerList:gSetSize(300, 150)
        playerList:AddColumn("Игроки")
        playerList:AddColumn("SteamID64")

        for _, ply in ipairs(player.GetAll()) do
            playerList:AddLine(ply:Nick(), ply:SteamID64()).player = ply
        end
    end)

    local sendButton = vgui.Create("TLButton", frame)
    sendButton:gSetPos(50, 240)
    sendButton:gSetSize(300, 30)
    sendButton:SetText("Вые...Убийство персонажа")

    sendButton.DoClick = function()
        local selectedPlayer = playerList:GetSelectedLine()
        if selectedPlayer then
            local playerSteamID64 = playerList:GetLine(selectedPlayer):GetValue(2)

            net.Start("CKPlayer")
            net.WriteString(playerSteamID64)
            net.SendToServer()
        else
            chat.AddText(Color(255, 0, 0), "Выберите игрока.")
        end
    end
end

function OpenSkillGiveMenu()
    if LocalPlayer():GetUserGroup() ~= "responsable" and LocalPlayer():GetUserGroup() ~= "superadmin" and LocalPlayer():GetUserGroup() ~= "admin" then 
        LocalPlayer():ChatPrint("У вас нет прав доступа к этому меню.") 
        return 
    end
    
    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400, 400)
    frame:ShowCloseButton(true)
    frame:SetHeader("Меню - Выдача навыков")
    frame:Center()
    frame:MakePopup()

    timer.Simple(0.25, function()
        playerList = vgui.Create("DListView", frame)
        playerList:gSetPos(50, 50)
        playerList:gSetSize(300, 150)
        playerList:AddColumn("Игроки")
        playerList:AddColumn("SteamID64")

        for _, ply in ipairs(player.GetAll()) do
            playerList:AddLine("[".. string.upper(ply:GetNWString("Classe")) .."] " ..ply:Nick(), ply:SteamID64()).player = ply
        end
    end)

    local itemList = vgui.Create("DComboBox", frame)
    itemList:gSetPos(50, 220)
    itemList:gSetSize(300, 30)
    itemList:SetValue("Выберите навык")

    local temp = {}
    for skillName, skillData in pairs(SKILLS_SL) do
        if skillData.element ~= "none" then
            table.insert(temp, "[МАГИЯ - " .. string.upper(skillData.element) .. "] " .. skillData.name .. " (УР. " .. skillData.level .. ")")
        else
            table.insert(temp, "[" .. string.upper(skillData.classe) .. "] " .. skillData.name .. " (УР. " .. skillData.level .. ")")
        end
    end

    table.sort(temp)

    local printed = {}
    for _, name in pairs(temp) do
        itemList:AddChoice(name)
        if not printed[name] then            
            printed[name] = true
        end
    end

    local sendButton = vgui.Create("TLButton", frame)
    sendButton:gSetPos(50, 270)
    sendButton:gSetSize(300, 30)
    sendButton:SetText("Выдать навык")

    sendButton.DoClick = function()
        local selectedLine = playerList:GetSelectedLine()
        local selectedItem = itemList:GetValue()

        if selectedLine and selectedItem then
            local playerSteamID64 = playerList:GetLine(selectedLine):GetValue(2)

            net.Start("GiveSelectedSkill")
            net.WriteString(playerSteamID64)
            net.WriteString(selectedItem)
            net.SendToServer()
        else
            chat.AddText(Color(255, 0, 0), "Пожалуйста, выберите игрока и навык.")
        end
    end
end


function OpenClasseGiveMenu()
    if LocalPlayer():GetUserGroup() ~= "responsable" and LocalPlayer():GetUserGroup() ~= "superadmin" then 
        LocalPlayer():ChatPrint("У вас нет прав доступа к этому меню.") 
        return 
    end
    
    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400, 400)
    frame:ShowCloseButton(true)
    frame:SetHeader("Выдача класса")
    frame:Center()
    frame:MakePopup()

    timer.Simple(0.25, function()
        playerList = vgui.Create("DListView", frame)
        playerList:gSetPos(50, 50)
        playerList:gSetSize(300, 150)
        playerList:AddColumn("Игроки")
        playerList:AddColumn("SteamID64")

        for _, ply in ipairs(player.GetAll()) do
            playerList:AddLine("[".. string.upper(ply:GetNWString("Classe")) .."] " ..ply:Nick(), ply:SteamID64()).player = ply
        end
    end)

    local itemList = vgui.Create("DComboBox", frame)
    itemList:gSetPos(50, 220)
    itemList:gSetSize(300, 30)
    itemList:SetValue("Выберите класс")

    local temp = {}
    
    for classeName, classeData in pairs(CLASSES_SL) do
        local displayName = "[" .. string.upper(classeData.rarete) .. "] " .. string.upper(string.sub(classeName, 1, 1)) .. string.sub(classeName, 2, -1)
        table.insert(temp, displayName)
    end

    table.sort(temp)

    local printed = {}

    for _, name in ipairs(temp) do
        if not printed[name] then
            itemList:AddChoice(name)
            printed[name] = true
        end
    end

    local sendButton = vgui.Create("TLButton", frame)
    sendButton:gSetPos(50, 270)
    sendButton:gSetSize(300, 30)
    sendButton:SetText("Выдать класс")

    sendButton.DoClick = function()
        local selectedLine = playerList:GetSelectedLine()
        local selectedItem = itemList:GetValue()

        if selectedLine and selectedItem then
            local playerSteamID64 = playerList:GetLine(selectedLine):GetValue(2)

            net.Start("SL:Shavkat - Admin:GiveClasse")
            net.WriteString(playerSteamID64)
            net.WriteString(selectedItem)
            net.SendToServer()
        else
            chat.AddText(Color(255, 0, 0), "Пожалуйста, выберите игрока и класс.")
        end
    end
end


function OpenMagieGiveMenu()
    if LocalPlayer():GetUserGroup() ~= "responsable" and LocalPlayer():GetUserGroup() ~= "superadmin" then 
        LocalPlayer():ChatPrint("У вас нет прав доступа к этому меню.") 
        return 
    end
    
    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400, 400)
    frame:ShowCloseButton(true)
    frame:SetHeader("Меню - Выдача магии")
    frame:Center()
    frame:MakePopup()

    timer.Simple(0.25, function()
        playerList = vgui.Create("DListView", frame)
        playerList:gSetPos(50, 50)
        playerList:gSetSize(300, 150)
        playerList:AddColumn("Игроки")
        playerList:AddColumn("SteamID64")

        for _, ply in ipairs(player.GetAll()) do
            if ply:GetNWInt("Magie") == nil then 
                playerList:AddLine("[НЕТ МАГИИ] " ..ply:Nick(), ply:SteamID64()).player = ply
            else
                playerList:AddLine("[".. string.upper(ply:GetNWInt("Magie")) .."] " ..ply:Nick(), ply:SteamID64()).player = ply
            end
        end
    end)

    local itemList = vgui.Create("DComboBox", frame)
    itemList:gSetPos(50, 220)
    itemList:gSetSize(300, 30)
    itemList:SetValue("Выберите магию")

    local temp = {}
    for magieName, magieData in pairs(MAGIE_SL) do
        local displayText = "[" .. string.upper(magieData.rarete) .. "] " .. magieData.name
        table.insert(temp, displayText)
    end

    table.sort(temp)

    local printed = {}

    for _, name in ipairs(temp) do
        if not printed[name] then
            itemList:AddChoice(name)
            printed[name] = true
        end
    end

    local sendButton = vgui.Create("TLButton", frame)
    sendButton:gSetPos(50, 270)
    sendButton:gSetSize(300, 30)
    sendButton:SetText("Выдать магию")

    sendButton.DoClick = function()
        local selectedLine = playerList:GetSelectedLine()
        local selectedItem = itemList:GetValue()

        if selectedLine and selectedItem then
            local playerSteamID64 = playerList:GetLine(selectedLine):GetValue(2)

            net.Start("SL:Shavkat - Admin:GiveMagie")
            net.WriteString(playerSteamID64)
            net.WriteString(selectedItem)
            net.SendToServer()
        else
            chat.AddText(Color(255, 0, 0), "Пожалуйста, выберите игрока и магию.")
        end
    end
end


function OpenRangGiveMenu()
    if LocalPlayer():GetUserGroup() ~= "responsable" and LocalPlayer():GetUserGroup() ~= "superadmin" then 
        LocalPlayer():ChatPrint("У вас нет прав доступа к этому меню.") 
        return 
    end
    
    local frame = vgui.Create("TLFrame")
    frame:gSetSize(400, 400)
    frame:ShowCloseButton(true)
    frame:SetHeader("Меню - Выдача ранга")
    frame:Center()
    frame:MakePopup()

    timer.Simple(0.25, function()
        playerList = vgui.Create("DListView", frame)
        playerList:gSetPos(50, 50)
        playerList:gSetSize(300, 150)
        playerList:AddColumn("Игроки")
        playerList:AddColumn("SteamID64")

        for _, ply in ipairs(player.GetAll()) do
            if ply:GetNWInt("Rang") == nil then 
                playerList:AddLine("[БЕЗ РАНГА] " ..ply:Nick(), ply:SteamID64()).player = ply
            else
                playerList:AddLine("[".. string.upper(ply:GetNWInt("Rang")) .."] " ..ply:Nick(), ply:SteamID64()).player = ply
            end
        end
    end)

    local itemList = vgui.Create("DComboBox", frame)
    itemList:gSetPos(50, 220)
    itemList:gSetSize(300, 30)
    itemList:SetValue("Выберите ранг")

    local temp = {}
    for rangName, rangData in pairs(RANG_SL) do
        table.insert(temp, rangName)
    end

    table.sort(temp)

    local printed = {}

    for _, name in ipairs(temp) do
        if not printed[name] then
            itemList:AddChoice(name)
            printed[name] = true
        end
    end

    local sendButton = vgui.Create("TLButton", frame)
    sendButton:gSetPos(50, 270)
    sendButton:gSetSize(300, 30)
    sendButton:SetText("Выдать ранг")

    sendButton.DoClick = function()
        local selectedLine = playerList:GetSelectedLine()
        local selectedItem = itemList:GetValue()

        if selectedLine and selectedItem then
            local playerSteamID64 = playerList:GetLine(selectedLine):GetValue(2)

            net.Start("SL:Shavkat - Admin:GiveRang")
            net.WriteString(playerSteamID64)
            net.WriteString(selectedItem)
            net.SendToServer()
        else
            chat.AddText(Color(255, 0, 0), "Пожалуйста, выберите игрока и ранг.")
        end
    end
end

concommand.Add("giveallskill", function(ply, cmd, args)
    if not (LocalPlayer():GetUserGroup() == "superadmin" or LocalPlayer():GetUserGroup() == "Responsable") then return end   

    local playerSteamID64 = args[1]

    if not playerSteamID64 then
        chat.AddText(Color(255, 0, 0), "Укажите SteamID64 игрока.")
        return
    end

    local targetPlayer = nil

    for _, v in ipairs(player.GetAll()) do
        if v:SteamID64() == playerSteamID64 then
            playerSteamID64 = v:SteamID64()
            targetPlayer = v

            if v:GetNWInt("Classe") == "Aucune" then
                chat.AddText(Color(255, 0, 0), "У игрока не выбран класс.")
                return
            elseif v:GetNWInt("Classe") == "mage" then
                if v:GetNWInt("Magie") == "Aucune" then
                    chat.AddText(Color(255, 0, 0), "У игрока не выбрана магия.")
                    return
                end
            end
            
            break
        end

        if not v:SteamID64() == playerSteamID64 then
            chat.AddText(Color(255, 0, 0), "Игрок с ID " .. playerSteamID64 .. " не найден.")
            break
        end
    end

    if not targetPlayer then 
        print("Игрок с ID " .. playerSteamID64 .. " не найден.")
        return 
    end

    net.Start("GiveAllSkill")
    net.WriteString(playerSteamID64)
    net.SendToServer()

    net.Start("SHAV:DiscordLogs")
    net.WriteString("giveallskill")
    net.WriteEntity(LocalPlayer())
    net.WriteEntity(targetPlayer)
    net.SendToServer()
end)


-- concommand.Add("okigiveall", function(ply, cmd, args)
--     if not LocalPlayer():IsSuperAdmin() then return end

--     local amount = tonumber(args[1])

--     if not amount or amount <= 0 then
--         chat.AddText(Color(255, 0, 0), "Veuillez fournir un nombre valide de rerolls à donner.")
--         return
--     end

--     net.Start("SL:Okiro:GiveAll")
--         net.WriteInt(amount, 32)
--     net.SendToServer()
-- end)
