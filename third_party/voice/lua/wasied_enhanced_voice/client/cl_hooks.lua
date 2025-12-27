-- Draw the circle describing the voice range
hook.Add("PostDrawTranslucentRenderables", "EVoice:PostDrawTranslucentRenderables", function()

    local tCache = EVoice.tCache
    if not istable(tCache) then return end

    local vecPos = LocalPlayer():GetPos()
    local cNegative = EVoice.Constants["colors"]["negativeStencil"]
	local iOffset = EVoice.Constants["config"]["circleRadius"]

    if tCache.iCurrentRadius ~= tCache.iRadiusTarget then
        tCache.iCurrentRadius = Lerp((SysTime() - tCache.iAnimStart) / tCache.iAnimDuration, tCache.iCurrentRadius, tCache.iRadiusTarget)
        
        if math.ceil(tCache.iCurrentRadius) == math.ceil(tCache.iRadiusTarget) then
            tCache.iCurrentRadius = tCache.iRadiusTarget
        end
    end

    tCache.vecCurrentColor = LerpVector(FrameTime(), tCache.vecCurrentColor, tCache.vecNewColor)

    -- Clear stencil
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()

    -- Draw our stencil
    render.SetColorMaterial()
    render.ClearStencil()
    render.SetStencilEnable(true)

        render.SetStencilTestMask(0xFF)
        render.SetStencilWriteMask(0xFF)
        render.SetStencilReferenceValue(1)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)

        render.SetStencilZFailOperation(STENCILOPERATION_REPLACE)
        render.DrawSphere(vecPos, -tCache.iCurrentRadius, 120, 120, cNegative)
        render.SetStencilZFailOperation(STENCILOPERATION_DECR)
        render.DrawSphere(vecPos, tCache.iCurrentRadius, 120, 120, cNegative)
        render.SetStencilZFailOperation(STENCILOPERATION_INCR)
        render.DrawSphere(vecPos, -(tCache.iCurrentRadius - iOffset), 120, 120, cNegative)
        render.SetStencilZFailOperation(STENCILOPERATION_DECR)
        render.DrawSphere(vecPos, tCache.iCurrentRadius - iOffset, 120, 120, cNegative)
        
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

        cam.Start2D()
            surface.SetDrawColor(tCache.vecCurrentColor:ToColor())
            surface.DrawRect(0, 0, ScrW(), ScrH())
        cam.End2D()

    render.SetStencilEnable(false)
    render.ClearStencil()

end)

-- Draw the current voice range to the screen
hook.Add("HUDPaint", "EVoice:HUDPaint:DrawVoiceMode", function()

    local tCache = EVoice.tCache
    if not istable(tCache) then return end

    -- draw.SimpleText(("%s %s"):format(EVoice.Config.Language[9], (tCache.bMegaphone and "megaphone" or LocalPlayer():GetVoiceModeName():lower())), EVoice:Font(26), ScrW() / 2, ScrH() - RY(25), tCache.vecCurrentColor:ToColor(), 1, 4)

end)

-- Draw current channel on the screen
hook.Add("HUDPaint", "EVoice:HUDPaint:Radio", function()

    local pLocal = LocalPlayer()
    local eWeapon = pLocal:GetActiveWeapon()

    local cSoundEnabled = LocalPlayer():GetRadioSound() and Color(46, 204, 113) or Color(231, 76, 60)
    local cMicroEnabled = LocalPlayer():GetRadioMic() and Color(46, 204, 113) or Color(231, 76, 60)
    local sFrequency = LocalPlayer():GetLocalNWVar("RadioFrequency", EVoice.Config.Language[4])

    local tList = {
        {
            cColor = color_white, 
            mMaterial = EVoice.Constants["materials"]["frequency"],
            sText = "Clic molette pour activer",
            fcShow = function()
                return IsValid(eWeapon) and eWeapon:GetClass() == "evoice_radio" and not LocalPlayer():GetRadioEnabled()
            end
        },
        {
            cColor = color_white, 
            mMaterial = EVoice.Constants["materials"]["frequency"],
            sText = EVoice.Config.Language[3].." - "..sFrequency,
            fcShow = function()
                if not LocalPlayer():GetRadioEnabled() then return false end
                return (IsValid(eWeapon) and eWeapon:GetClass() == "evoice_radio") or isnumber(LocalPlayer():GetRadioFrequency())
            end
        },
        {
            cColor = cSoundEnabled, 
            mMaterial = EVoice.Constants["materials"]["leftClick"], 
            sText = EVoice.Config.Language[1],
            fcShow = function()
                if not LocalPlayer():GetRadioEnabled() then return false end
                return (IsValid(eWeapon) and eWeapon:GetClass() == "evoice_radio")
            end
        },
        { 
            cColor = cMicroEnabled, 
            mMaterial = EVoice.Constants["materials"]["rightClick"],
            sText = EVoice.Config.Language[2],
            iOffsetX = 3.5,
            fcShow = function()
                if not LocalPlayer():GetRadioEnabled() then return false end
                return (IsValid(eWeapon) and eWeapon:GetClass() == "evoice_radio")
            end
        }
    }

    local i = 0
    for _, t in ipairs(tList) do

        if isfunction(t.fcShow) and t.fcShow() == false then continue end

        surface.SetDrawColor(t.cColor)
        surface.SetMaterial(t.mMaterial)
        surface.DrawTexturedRect(ScrW() - RX(50 - (t.iOffsetX or 0)), RY(65 + i * 40), RX(32), RY(32))
        
        draw.SimpleText(t.sText, EVoice:Font(24), ScrW() - RX(55), RY(80 + i * 40), t.cColor, 2, 1)
        
        i = i + 1

    end

end)

-- Open the radio menu
hook.Add("PlayerButtonDown", "EVoice:PlayerButtonDown", function(pPlayer, iKey)

    if not IsValid(pPlayer) or not pPlayer:Alive() then return end

    local eWeapon = pPlayer:GetActiveWeapon()
    if not (IsValid(eWeapon) and eWeapon:GetClass() == "evoice_radio") then return end

    if iKey == MOUSE_MIDDLE then
        EVoice:CreateChannel()
    end

end)