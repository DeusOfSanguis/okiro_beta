local tData = {}

util.AddNetworkString("Okiro:Unknown:SendRequest")
util.AddNetworkString("Okiro:Unknown:AllFriends")

local function sendAllFriends(ply)

    if tData[ply:SteamID64()] == nil then return end

    net.Start("Okiro:Unknown:AllFriends")
        net.WriteTable(tData[ply:SteamID64()])
    net.Send(ply)

end

timer.Simple(1, function()

    if not file.Exists("okiro_unknown/", "DATA") then

        file.CreateDir("okiro_unknown/")

    end

    local sFiles, __ = file.Find("okiro/unknown/*.json", "DATA")

    for k,v in ipairs(sFiles) do

        tData[v:gsub(".json", "")] = util.JSONToTable(file.Read("okiro_unknown/"..v, "DATA"))

    end

    print("[Okiro - Unknown] Initialized (" .. #tData .. ")")

end)

net.Receive("Okiro:Unknown:SendRequest", function(len, ply)

    local pTarget = ply:GetEyeTrace().Entity

    if not (IsValid(ply) and pTarget:IsPlayer()) then return end

    if table.HasValue(tData, pTarget:SteamID64()) then 
        
        DarkRP.notify(ply, 0, 3, "Vous connaisez deja %s"):format(pTarget:Nick())

        return

    end

    local iTime = 15
    local iBar = 200
    local vTime = iBar / iTime

    local vKeyAccept = KEY_I
    local vKeyCancel = KEY_O

    local vFrame = vgui.Create("DFrame")
    vFrame:SetSize(0, 0)
    vFrame:SetPos(0, 0)
    vFrame:SetTitle("")
    vFrame:ShowCloseButton(true)
    vFrame:SetDraggable(false)
    vFrame:SetSizable(false)
    vFrame:MakePopup()
    local bIsAnim = true
    vFrame:SizeTo(500, 200, 1.7, 0, .1, function()
        bIsAnim = false
    end)
    
    function vFrame:Paint(w, h)

        surface.SetMaterial(Material("okiro/boutique/popupbg.png","noclamp smooth"))
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetMaterial(Material("okiro/bossbar/healthbarbg.png","noclamp smooth"))
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(w/3, h/1.3, 200, 15)

        surface.SetMaterial(Material("okiro/bossbar/healthbar.png","noclamp smooth"))
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(w/3, h/1.3, iBar, 15)

        draw.SimpleText("Vous venez de recevoir un demande d'ami.", "Presentation:Text", w/1.9, h/2.7, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    end

    local vAcceptPanel = vgui.Create("DButton", vFrame)
    vAcceptPanel:SetPos(130, 100)
    vAcceptPanel:SetSize(120, 35)
    vAcceptPanel:SetText("")
    function vAcceptPanel:Paint(w, h)

        surface.SetMaterial(Material("okiro/character_manque/step_deactive.png", "noclamp smooth"))
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(0, 0, w, h)

        draw.SimpleText("Touche : i", "Presentation:TextBtn2", w/2, h/3.3, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if self:IsHovered() then

            draw.SimpleText("Accepter", "Presentation:TextBtn", w/2, h/1.5, Color(143, 233, 115, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        else

            draw.SimpleText("Accepter", "Presentation:TextBtn", w/2, h/1.5, Color(143, 233, 115, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        end

    end
    function vAcceptPanel:DoClick()

        if not tData[pTarget:SteamID64()] then

            tData[pTarget:SteamID64()] = {}

        end

        table.insert(tData[pTarget:SteamID64()], ply:SteamID64())

        DarkRP.notify(ply, 0, 3, "Vous venez d'accepter la demande d'ami de %s"):format(pTarget:Nick())
        DarkRP.notify(pTarget, 0, 3, "%s a accepter votre demande d'ami"):format(ply:Nick())

        sendAllFriends(pTarget)
        sendAllFriends(ply)

        if IsValid(vFrame) then

            vFrame:AlphaTo(0, 0.3, 0, function()

                vFrame:Remove()

            end)

        end

    end

    local vCancelPanel = vgui.Create("DButton", vFrame)
    vCancelPanel:SetPos(270, 100)
    vCancelPanel:SetSize(120, 35)
    vCancelPanel:SetText("")
    function vCancelPanel:Paint(w, h)

        surface.SetMaterial(Material("okiro/character_manque/step_deactive.png", "noclamp smooth"))
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(0, 0, w, h)

        draw.SimpleText("Touche : O", "Presentation:TextBtn2", w/2, h/3.3, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if self:IsHovered() then

            draw.SimpleText("Refuser", "Presentation:TextBtn", w/2, h/1.5, Color(248, 78, 78, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        else

            draw.SimpleText("Refuser", "Presentation:TextBtn", w/2, h/1.5, Color(248, 78, 78, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        end

    end
    function vCancelPanel:DoClick()

        if IsValid(vFrame) then

            vFrame:AlphaTo(0, 0.3, 0, function()

                vFrame:Remove()

            end)

        end

    end

    timer.Create("Okiro:Unknown:TimeBar", 1, iTime, function()

        if iBar > 0 then

            iBar = iBar - vTime

        else

            timer.Remove("Okiro:Unknown:TimeBar")

        end

    end)

    timer.Simple(iTime, function()

        if IsValid(vFrame) then

            vFrame:AlphaTo(0, 0.3, 0, function()

                vFrame:Remove()

            end)

        end

    end)

    vFrame.Think = function(self)

        if bIsAnim then

            self:SetPos(1422, 440)

        end

    end

end)

hook.Add("PlayerInitialSpawn", "Okiro:Unknown:LoadOnSpawn", function(ply)

    sendAllFriends(ply)

end)