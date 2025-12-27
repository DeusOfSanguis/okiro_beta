-- Called when the client has changed his voice state
net.Receive("EVoice:UpdateVoiceState", function()

	local iOldMode = net.ReadUInt(16)
	local iNewMode = net.ReadUInt(16)

	local iOldRange = EVoice:GetModeRange(iOldMode)
	local iNewRange = LocalPlayer():GetVoiceRange()

	local cOldColor = EVoice:GetModeColor(iOldMode)
	local cNewColor = EVoice:GetModeColor(iNewMode)

	EVoice.tCache = {
		iAnimDuration = EVoice.Config.AnimDuration,
		iAnimStart = SysTime(),
		iCurrentRadius = iOldRange,
		iRadiusTarget = iNewRange,
		vecCurrentColor = cOldColor:ToVector(),
		vecNewColor = cNewColor:ToVector()
	}

	timer.Create("EVoice:AnimDuration", EVoice.Config.AnimDuration, 1, function()
		EVoice.tCache = nil
	end)

end)

-- Called when the client want to show the megaphone distance
net.Receive("EVoice:ShowMegaphoneDistance", function()

	if net.ReadBool() then

		local iOldRange = EVoice.Constants["config"]["megaphoneRange"]
		local iNewRange = iOldRange

		local cOldColor = EVoice.Constants["colors"]["megaphoneCircle"]
		local cNewColor = cOldColor

		EVoice.tCache = {
			iAnimDuration = 0,
			iAnimStart = SysTime(),
			iCurrentRadius = iOldRange,
			iRadiusTarget = iNewRange,
			vecCurrentColor = cOldColor:ToVector(),
			vecNewColor = cNewColor:ToVector(),
			bMegaphone = true
		}

	else
		EVoice.tCache = nil
	end

end)