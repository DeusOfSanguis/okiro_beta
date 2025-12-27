-- Network strings registration
util.AddNetworkString("EVoice:UpdateVoiceState")
util.AddNetworkString("EVoice:UpdateLocalVar")
util.AddNetworkString("EVoice:ShowMegaphoneDistance")

-- Asked by a client to change the frequency
net.Receive("EVoice:UpdateLocalVar", function(_, pPlayer)

    if not IsValid(pPlayer) or not pPlayer:Alive() then return end

    if (pPlayer.iRadioUpdateCooldown or 0) > CurTime() then return end
    pPlayer.iRadioUpdateCooldown = CurTime() + 0.5

    local iVarType = net.ReadUInt(4)

    if iVarType == 0 then
        pPlayer:SetRadioEnabled(net.ReadBool())
    elseif iVarType == 1 then

        local iFrequency = net.ReadUInt(32)

        if iFrequency <= 0 or iFrequency >= 200 then
            return EVoice:Notify(pPlayer, EVoice.Config.Language[10]:format(0, 200))
        end

        local tRestrictedJobs = EVoice.Config.RestrictedFrequencies[iFrequency]
        if istable(tRestrictedJobs) then
            if not table.HasValue(tRestrictedJobs, team.GetName(pPlayer:Team())) then
                return EVoice:Notify(pPlayer, EVoice.Config.Language[12])
            end
        end

        pPlayer:SetRadioEnabled(true)
        pPlayer:SetRadioFrequency(iFrequency)

    elseif iVarType == 2 then
        pPlayer:SetRadioSound(net.ReadBool())
    elseif iVarType == 3 then
        pPlayer:SetRadioMic(net.ReadBool())
    end

end)