local PLAYER = FindMetaTable("Player")

-- Get the voice range of a player
function PLAYER:SetVoiceMode(iMode, bNoAnim)

    local iOldMode = self:GetVoiceMode()

    if not isnumber(iMode) then
        return false, Error("iMode must be an integer")
    end

    if iMode > #EVoice.VoiceModes then
        iMode = iMode % #EVoice.VoiceModes
    end

    self:SetLocalNWVar("VoiceMode", iMode)

    if not bNoAnim then

        net.Start("EVoice:UpdateVoiceState")
            net.WriteUInt(iOldMode, 16)
            net.WriteUInt(iMode, 16)
        net.Send(self)
        
    end

    hook.Run("PlayerChangeVoiceMode", iMode, iOldMode)

end

-- Set the player to the next range of voice range
function PLAYER:ChangeVoiceMode()
    self:SetVoiceMode(self:GetVoiceMode() + 1)
end

-- Set radio enable state
function PLAYER:SetRadioEnabled(bNew)
    self:SetLocalNWVar("RadioEnabled", bNew)
end

-- Set radio sound enable state
function PLAYER:SetRadioSound(bEnabled)
    self:SetLocalNWVar("RadioSoundEnabled", bEnabled)
end

-- Set radio mic enable state
function PLAYER:SetRadioMic(bEnabled)
    self:SetLocalNWVar("RadioMicEnabled", bEnabled)
end

-- Set radio frequency
function PLAYER:SetRadioFrequency(iNew)
    self:SetLocalNWVar("RadioFrequency", iNew)
end