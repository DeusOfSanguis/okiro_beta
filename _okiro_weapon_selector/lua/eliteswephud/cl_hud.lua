--[[
    Addon : EliteWeaponSelector
    By : Esteb
    Support : !Esteb.#6666
    Version : 2.0
--]]
--[[
╔═╗╔═╗╔═╗  ╔╦╗╔═╗  ╔═╗╔═╗╔╗╔╔═╗╦╔═╗  ╦╔═╗╦
╠═╝╠═╣╚═╗   ║║║╣   ║  ║ ║║║║╠╣ ║║ ╦  ║║  ║
╩  ╩ ╩╚═╝  ═╩╝╚═╝  ╚═╝╚═╝╝╚╝╚  ╩╚═╝  ╩╚═╝╩
--]]
-- Optimisation
local surface = surface
local draw = draw
local timer = timer
local Lerp = Lerp
local LocalPlayer = LocalPlayer

-- HUD
local hud = {
    -- Slots général
    slotSelected = 0,
    slotIndex = 1,
    slotDraw = false,
    slotWeapon = "",
    lastWeapon = "",
    recordLastWep = false,
    slotIcon = "",
    slotMaterials = {},
    drawAlpha = 0,
    slotBinds = {},
    -- HUD POSITION
    selectionW = 0,
    totalW = 0,
    posX = 0,
    -- Outline
    outlineX = 0,
    outlineY = 0,
    outlineW = 0,
    outlineH = 0,
    -- Invisible
    noDraw = {
        ["CHudWeaponSelection"] = true
    }
}

function hud:SelectWeapon(wep)
    RunConsoleCommand("use", wep)
end

function hud:EnableDrawing()
    local lp = LocalPlayer()
    if lp:InVehicle() then return end

    if (timer.Exists("eliteswephud_linger")) then
        timer.Remove("eliteswephud_linger")
    end

    timer.Create("eliteswephud_linger", eliteswephud_config.lingerDuration, 1, function()
        self.slotDraw = false
    end)

    self.slotDraw = true
end

function hud:GetWeaponsInSlot(iSlot)
    local weps = {}

    for k, v in next, LocalPlayer():GetWeapons() do
        local slot = 1

        if (v.Slot) then
            slot = v.Slot + 1
        elseif (v.BaseClass) then
            if (v.BaseClass.Slot) then
                slot = v.BaseClass.Slot + 1
            end
        end

        if (slot == iSlot) then
            weps[#weps + 1] = v
        end
    end

    return weps
end

function hud:Draw()
    if (self.slotDraw) then
        self.drawAlpha = Lerp(0.1, self.drawAlpha, 245)
    elseif (self.drawAlpha > 1) then
        self.drawAlpha = Lerp(0.1, self.drawAlpha, 0)
    end

    eliteswephud_config.bgSelectedColor.a = self.drawAlpha
    eliteswephud_config.bgNonSelectedColor.a = self.drawAlpha
    eliteswephud_config.bgSelectedOutline.a = self.drawAlpha
    eliteswephud_config.textSelectedColor.a = self.drawAlpha
    eliteswephud_config.textNonSelectedColor.a = self.drawAlpha

    if (self.drawAlpha > 1) then
        local wepsInSlot = self:GetWeaponsInSlot(self.slotSelected)
        local cW = self.selectionW / 4
        local t = nil

        for i = 1, 6 do
            if (i == self.slotSelected) then continue end
            surface.SetDrawColor(Color(0, 0, 0, 150))
            surface.DrawRect(self.posX + self.selectionW * (i - 1) - cW / 2, eliteswephud_config.originY, cW, eliteswephud_config.bgH)
            draw.SimpleText(tostring(i), "eliteswephud_font", self.posX + self.selectionW * (i - 1), eliteswephud_config.originY + eliteswephud_config.bgH / 2, eliteswephud_config.textNonSelectedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        for k, v in next, wepsInSlot do
            local bgColor
            local color

            if (k == self.slotIndex) then
                color = eliteswephud_config.textSelectedColor
                if t == "Vide" then
                    bgColor = Color(0, 0, 0, 150)
                else
                    bgColor = eliteswephud_config.bgSelectedColor
                end
            else
                bgColor = Color(0, 0, 0, 150)
                color = eliteswephud_config.textNonSelectedColor
            end

            surface.SetFont("eliteswephud_font")
            local cW = self.selectionW
            local tW, tH = surface.GetTextSize(v:GetPrintName())
            tW = tW + 20

            if (tW > cW) then
                cW = tW
            end

            local cX = self.posX + self.selectionW * (self.slotSelected - 1)
            local cY = eliteswephud_config.originY + (k - 1) * eliteswephud_config.bgH
            surface.SetDrawColor(bgColor)
            surface.DrawRect(cX - cW / 2, cY, cW, eliteswephud_config.bgH)

            if (k == self.slotIndex) then
                self.outlineX = cX - cW / 2
                self.outlineY = cY
                self.outlineW = cW
                self.outlineH = eliteswephud_config.bgH

                if (self.slotIcon ~= "") then
                    surface.SetMaterial(self.slotMaterials[self.slotIcon])
                    surface.SetDrawColor(Color(255, 255, 255, self.drawAlpha))
                    surface.DrawTexturedRect(cX + cW / 2 + 5, cY - 5, 35, 35)
                end
            end

            draw.SimpleText(v:GetPrintName(), "eliteswephud_font", cX, cY + eliteswephud_config.bgH / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        if (#wepsInSlot == 0) then
            self.outlineX = self.posX + self.selectionW * (self.slotSelected - 1) - self.selectionW / 2
            self.outlineY = eliteswephud_config.originY
            self.outlineW = self.selectionW
            self.outlineH = eliteswephud_config.bgH
            surface.SetDrawColor(Color(0, 0, 0, 150))
            surface.DrawRect(self.posX + self.selectionW * (self.slotSelected - 1) - self.selectionW / 2, eliteswephud_config.originY, self.selectionW, eliteswephud_config.bgH)
            draw.SimpleText(eliteswephud_config.emptySlotText, "eliteswephud_font", self.posX + self.selectionW * (self.slotSelected - 1), eliteswephud_config.originY + eliteswephud_config.bgH / 2, eliteswephud_config.textSelectedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        surface.SetDrawColor(eliteswephud_config.bgSelectedOutline)
        surface.DrawOutlinedRect(self.outlineX, self.outlineY, self.outlineW, self.outlineH)
    end
end

function hud:PlayerBindPress(ply, bind, bPressed)
    local oldSlotIndex = self.slotIndex
    local oldSlotSelected = self.slotSelected

    if (bind == "lastinv") then
        if (IsValid(LocalPlayer():GetActiveWeapon())) then
            self:SelectWeapon(self.lastWeapon)
            local buffer = self.lastWeapon
            self.lastWeapon = self.slotWeapon
            self.slotWeapon = buffer

            return
        end
    end

    -- Base 
    if (bind == "+attack" and self.slotDraw) then
        local wepsInSlot = self:GetWeaponsInSlot(self.slotSelected)

        if (#wepsInSlot > 0) then
            self.lastWeapon = self.slotWeapon
            self.slotWeapon = self:GetWeaponsInSlot(self.slotSelected)[self.slotIndex]:GetClass()
            self:SelectWeapon(self.slotWeapon)

            if (timer.Exists("eliteswephud_linger")) then
                timer.Remove("eliteswephud_linger")
            end

            self.slotDraw = false
            surface.PlaySound(eliteswephud_config.weaponSelectedSound)
        end

        return true
    end

    if (input.IsMouseDown(MOUSE_LEFT)) then return end

    -- changer de slots par numéro
    if (self.slotBinds[bind]) then
        local slot = self.slotBinds[bind]

        if (self.slotSelected ~= slot) then
            self.slotSelected = slot
            self.slotIndex = 1
        else -- même emplacement mais sans le même emplacement 
            self.slotIndex = self.slotIndex + 1

            if (self.slotIndex > #self:GetWeaponsInSlot(self.slotSelected)) then
                self.slotIndex = 1
            end
        end
    elseif (bind == "invnext") then
        self.slotIndex = self.slotIndex + 1

        -- move to the next slot 
        if (self.slotIndex > #self:GetWeaponsInSlot(self.slotSelected)) then
            self.slotSelected = self.slotSelected + 1
            self.slotIndex = 1

            -- cycle back to 1 
            if (self.slotSelected > 6) then
                self.slotSelected = 1
            end
        end
    elseif (bind == "invprev") then
        self.slotIndex = self.slotIndex - 1

        -- move to the next slot 
        if (self.slotIndex < 1) then
            self.slotSelected = self.slotSelected - 1
            self.slotIndex = #self:GetWeaponsInSlot(self.slotSelected)

            -- cycle back to 1 
            if (self.slotSelected < 1) then
                self.slotSelected = 6
                self.slotIndex = #self:GetWeaponsInSlot(self.slotSelected)
            end
        end
    end

    local lp = LocalPlayer()
    if lp:InVehicle() then return end

    if (self.slotIndex ~= oldSlotIndex or self.slotSelected ~= oldSlotSelected) then
        self:EnableDrawing()
        surface.PlaySound(eliteswephud_config.slotChangeSound)
        local wep = self:GetWeaponsInSlot(self.slotSelected)[self.slotIndex]

        -- if the weapon is valid..
        if (IsValid(wep)) then
            local files = file.Find("" .. wep:GetClass() .. ".vtf", "GAME") -- find its spawn icon

            if (#files > 0) then
                self.slotIcon = "vgui/entities/" .. files[1] -- use this for determining wether to draw or not 

                -- make a material as we haven't made one yet
                if (self.slotMaterials[self.slotIcon] == nil) then
                    self.slotMaterials[self.slotIcon] = Material(self.slotIcon)
                end
            else
                self.slotIcon = ""
            end
        end
    end
end

function hud:NoDraw(name)
    if (self.noDraw[name]) then return false end
end

function hud:Init()
    -- Création de la police
    surface.CreateFont("eliteswephud_font", {
        font = "Poppins Medium",
        extended = false,
        size = 22,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false
    })

    -- Définir les slots
    self.slotBinds["slot1"] = 1
    self.slotBinds["slot2"] = 2
    self.slotBinds["slot3"] = 3
    self.slotBinds["slot4"] = 4
    self.slotBinds["slot5"] = 5
    self.slotBinds["slot6"] = 6
    -- Calculer la position
    self.selectionW = ScrW() / 10
    self.totalW = self.selectionW * 6
    self.posX = ScrW() / 2 - self.totalW / 2 + self.selectionW / 2

    -- HUDPaint Hook
    hook.Add("HUDPaint", "eliteswephud_draw", function()
        self:Draw()
    end)

    -- Bind
    hook.Add("PlayerBindPress", "eliteswephud_bindpress", function(ply, bind, bPressed)
        local result = self:PlayerBindPress(ply, bind, bPressed)
        if (result ~= nil) then return result end
    end)

    -- Hook HUD
    hook.Add("HUDShouldDraw", "eliteswephud_nodraw", function(name)
        local result = hud:NoDraw(name)
        if (result ~= nil) then return result end
    end)
end

hud:Init()