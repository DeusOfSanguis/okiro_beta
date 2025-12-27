-- Notify a player with the specified message
function EVoice:Notify(pPlayer, sContent)

	if not IsValid(pPlayer) or not pPlayer:IsPlayer() then return end

	if DarkRP then
		return DarkRP.notify(pPlayer, 0, 7, sContent)
	end

	return pPlayer:PrintMessage(HUD_PRINTTALK, sContent)
	
end

-- Check if 2 players can hear themselves
function EVoice:PlayerCanHearPlayersVoice(pListener, pTalker)
	
	local iValue = (self.tPlayerCanHear[pListener] or {})[pTalker]
	if not isnumber(iValue) then return true, true end

	return iValue > 0, iValue == 1

end

-- Calculate the distance between 2 players with a cache system
function EVoice:CalculateDistance(pOne, pTwo, tCache)

	-- If we have the value cached, return it
	if istable(tCache) then

		if tCache[pOne] and tCache[pOne][pTwo] then
			return tCache[pOne][pTwo]
		end

		if tCache[pTwo] and tCache[pTwo][pOne] then
			return tCache[pTwo][pOne]
		end

	end

	-- Otherwise, calculate it and cache it for the next time
	local iDistSqr = pOne:GetPos():Distance(pTwo:GetPos())
	
	tCache[pOne] = tCache[pOne] or {}
	tCache[pOne][pTwo] = iDistSqr

	tCache[pTwo] = tCache[pTwo] or {}
	tCache[pTwo][pOne] = iDistSqr

	return iDistSqr

end