EVoice.VoiceModes = {}

-- Register a new voice mode
function EVoice:RegisterVoiceMode(sName, iMaxDistance, cColor, iSpecificOrder)

    if not isstring(sName) then
        return false, Error("[EVoice] Please specify a valid name")
    end

    if not isnumber(iMaxDistance) then
        return false, Error("[EVoice] Please specify a valid maximum distance")
    end

    if not IsColor(cColor) then
        return false, Error("[EVoice] Please specify a valid color")
    end
    
    table.insert(EVoice.VoiceModes, iSpecificOrder or (#EVoice.VoiceModes + 1), {
        sName = sName,
        cColor = cColor,
        iMaxDistance = iMaxDistance
    })

end

-- Register voice modes from the config
function EVoice:LoadConfig()

    for _, t in ipairs(EVoice.Config.Modes) do
        self:RegisterVoiceMode(t.ModeName, t.HearingDistance, t.ModeColor)
    end

end
EVoice:LoadConfig()

-- Get the voice range by id
function EVoice:GetModeRange(iMode)
    return EVoice.VoiceModes[iMode].iMaxDistance
end

-- Get the color of the range by id
function EVoice:GetModeColor(iMode)
    return EVoice.VoiceModes[iMode].cColor
end

-- Get the color of the range by id
function EVoice:GetModeName(iMode)
    return EVoice.VoiceModes[iMode].sName
end