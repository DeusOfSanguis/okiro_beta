local PLAYER = FindMetaTable("Player")

-- Get the voice range of a player
function PLAYER:GetVoiceRange()
    return EVoice:GetModeRange(self:GetVoiceMode())
end

-- Get the voice mode of a player
function PLAYER:GetVoiceMode()
    return self:GetLocalNWVar("VoiceMode", 1)
end

-- Get the voice mode name of a player
function PLAYER:GetVoiceModeName()
    return EVoice:GetModeName(self:GetVoiceMode())
end

-- Set radio enable state
function PLAYER:GetRadioEnabled()
    return self:GetLocalNWVar("RadioEnabled", false)
end

-- Get radio sound enable state
function PLAYER:GetRadioSound()
    return self:GetLocalNWVar("RadioSoundEnabled", true)
end

-- Get radio mic enable state
function PLAYER:GetRadioMic()
    return self:GetLocalNWVar("RadioMicEnabled", true)
end

-- Get radio frequency
function PLAYER:GetRadioFrequency()
    return self:GetLocalNWVar("RadioFrequency")
end