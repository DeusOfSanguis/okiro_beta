-- Override the default voice chat gamemode functions to make it use EVoice system (more optimized)
hook.Add("PostGamemodeLoaded", "EVoice:PostGamemodeLoaded", function()

	GM = GM or GAMEMODE

	EVoice.tPlayerCanHear = EVoice.tPlayerCanHear or {}
	EVoice.fcOldPlayerCanHearPlayersVoice = GM.PlayerCanHearPlayersVoice

	function GM:PlayerCanHearPlayersVoice(pListener, pTalker)
		return EVoice:PlayerCanHearPlayersVoice(pListener, pTalker)
	end

	print("[EVoice] Gamemode function successfully overrided!")

end)

-- Set the player voice mode at spawn
hook.Add("PlayerInitialSpawn", "EVoice:PlayerInitialSpawn", function(pPlayer)
	if not IsValid(pPlayer) then return end
	pPlayer:SetVoiceMode(1, true)
end)

-- Start the distance-between-players calculation timer at first tick
hook.Add("Tick", "EVoice:Tick", function()

	EVoice.tPlayerCanHear = EVoice.tPlayerCanHear or {}

	timer.Create("EVoice:CalculateDistance", EVoice.Constants["config"]["calculationCooldown"], 0, function()
		
		local tPlayers = player.GetAll()
		local tDistanceCache = {}
		local tCanHear = {}

		-- Loop through all listeners
		for _, pListener in ipairs(tPlayers) do

			if not IsValid(pListener) then continue end

			local tListenerCache = {}
			
			-- Check if listener is in the range of any other player
			for _, pTalker in ipairs(tPlayers) do

				if IsValid(pTalker) and pTalker:Alive() and pTalker ~= pListener then

					local iDist = EVoice:CalculateDistance(pTalker, pListener, tDistanceCache)
					local iTalkerRange = pTalker:GetVoiceRange()

					if pListener:GetRadioEnabled() and pTalker:GetRadioEnabled() and pListener:GetRadioFrequency() == pTalker:GetRadioFrequency() then
						if pTalker:GetRadioMic() and pListener:GetRadioSound() then

							tListenerCache[pTalker] = 2
							continue

						end
					end

					if pTalker.bIsMegaphoneTalking then
						iTalkerRange = EVoice.Constants["config"]["megaphoneRange"]
					end

					tListenerCache[pTalker] = (iDist <= iTalkerRange and 1 or 0)
					
				else
					tListenerCache[pTalker] = 0
				end

			end

			tCanHear[pListener] = tListenerCache
			
		end
	
		EVoice.tPlayerCanHear = tCanHear

	end)

	hook.Remove("Tick", "EVoice:Tick")

end)

-- Change the voice mode
hook.Add("PlayerButtonDown", "EVoice:PlayerButtonDown", function(pPlayer, iKey)

	if not IsValid(pPlayer) or not pPlayer:Alive() then return end
	
	if (pPlayer.iVoiceKeyCooldown or 0) > CurTime() then return end
	pPlayer.iVoiceKeyCooldown = CurTime() + 0.3

	if iKey == EVoice.Config.VoiceKey and not pPlayer.bIsMegaphoneTalking then
		pPlayer:ChangeVoiceMode()
	end

end)

-- Sync sound disabling with mic disabling
hook.Add("OnLocalNWVarChanged", "EVoice:OnLocalNWVarChanged", function(pPlayer, sVarName, xValue)

	if not IsValid(pPlayer) or not pPlayer:Alive() then return end

	if sVarName == "RadioSoundEnabled" then

		if xValue == false then
			
			pPlayer.bOldRadioMicState = pPlayer:GetRadioMic()
			pPlayer.bSkipFirstNWChange = true

			pPlayer:SetRadioMic(false)

		elseif isbool(pPlayer.bOldRadioMicState) then
			pPlayer:SetRadioMic(pPlayer.bOldRadioMicState)
		end

	elseif sVarName == "RadioMicEnabled" then

		if not pPlayer.bSkipFirstNWChange then
			pPlayer.bOldRadioMicState = nil
		else
			pPlayer.bSkipFirstNWChange = nil
		end

	end

end)

-- Reset the radio when a player dies
hook.Add("PostPlayerDeath", "EVoice:PostPlayerDeath", function(pPlayer)
    pPlayer:SetRadioEnabled(false)
    pPlayer:SetRadioFrequency(1)
    pPlayer:SetRadioSound(false)
    pPlayer:SetRadioMic(false)
end)

-- Reset the radio when a player respawns
hook.Add("PlayerLoadout", "EVoice:PlayerLoadout", function(pPlayer)
    pPlayer:SetRadioEnabled(false)
    pPlayer:SetRadioFrequency(1)
    pPlayer:SetRadioSound(true)
    pPlayer:SetRadioMic(true)
end)