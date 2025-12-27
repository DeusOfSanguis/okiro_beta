/* Show the current level */

local curLevelFrame
hook.Add("HUDPaint", "TPTSA:ShowCurrentLevel", function()
	local ply = LocalPlayer()
	local scrw, scrh = ScrW(), ScrH()

	-- Show data automatically
	if ply.beginTraining != nil and ply.beginTraining > 0 then

		if not IsValid(curLevelFrame) then

			local sizex, sizey = scrw / 1920 * 600, scrh / 1080 * 360


			curLevelFrame = vgui.Create("DFrame")
			curLevelFrame:ShowCloseButton(false)
			curLevelFrame:SetTitle("")
			curLevelFrame:SetPos(scrw * 0.05, scrh * 0.05)
			curLevelFrame:SetSize(sizex, sizey)
			curLevelFrame.text = ""
			curLevelFrame.Paint = function(s, w, h) end
			curLevelFrame:SetKeyboardInputEnabled(true)

			local curLevelPanel = vgui.Create("DPanel", curLevelFrame)
			curLevelPanel:Dock(FILL)
			curLevelPanel:DockMargin(10, 10, 10, 10)

			curLevelPanel.Paint = function(s, w, h)

				if ply.typeTraining == "" then return end

				surface.SetDrawColor(color_white)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(Diablos.TS.Colors.CurLevelBox)
				surface.DrawRect(2, 2, w - 4, h - 4)

				draw.SimpleText(Diablos.TS:GetLanguageString("training"), "Diablos:Font:TS:45:B", 10, 10, Diablos.TS.Colors.gl, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

				surface.SetDrawColor(Diablos.TS.Colors.barBackground)
				surface.DrawRect(2, h * 0.2, w - 4, 2)

				local trainingMat
				local typeTraining = ply.typeTraining
				local trainingText = Diablos.TS:GetLanguageString(ply.typeTraining)
				typeTraining = string.lower(typeTraining)
				if typeTraining == "stamina" then
					trainingMat = Diablos.TS.Materials.stamina
				elseif typeTraining == "runningspeed" then
					trainingMat = Diablos.TS.Materials.runningSpeed
				elseif typeTraining == "strength" then
					trainingMat = Diablos.TS.Materials.strength
				elseif typeTraining == "attackspeed" then
					trainingMat = Diablos.TS.Materials.attackSpeed
				end


				local curtime = CurTime()
				local trainingLevel = Diablos.TS:GetTrainingLevel(typeTraining, ply)

				local begPosY = h * 0.23
				local sizeIconY = h * 0.13

				surface.SetDrawColor(color_white)
				surface.SetMaterial(trainingMat)
				surface.DrawTexturedRect(10, begPosY, 40, sizeIconY)

				draw.SimpleText(trainingText, "Diablos:Font:TS:40", 60, begPosY + sizeIconY / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(string.format(Diablos.TS:GetLanguageString("currentLevel"), trainingLevel), "Diablos:Font:TS:40", w - 10, begPosY + sizeIconY / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

				begPosY = h * 0.42
				sizeY = h * 0.06

				local transition = math.min(curtime - ply.startTraining, 1)
				Diablos.TS:WriteProgressBar(10, begPosY, w - 20, sizeY, Diablos.TS:GetTrainingPercentage(typeTraining, ply) / 100 * transition)

				begPosY = h * 0.5
				sizeY = h * 0.3

				local posCenter = w / 2 / 2
				surface.SetDrawColor(Diablos.TS.Colors.CurLevelBox)
				surface.DrawRect(10, begPosY, w / 2 - 15, sizeY)
				local currentTimer = math.ceil(ply.beginTraining-curtime)
				local prefixText = Diablos.TS:GetLanguageString("beginning")

				if currentTimer <= 0 then -- it means the current timer is the ending one
					prefixText = Diablos.TS:GetLanguageString("ending")
					currentTimer = math.ceil(ply.EndTraining - curtime)
				end

				draw.SimpleText(prefixText, "Diablos:Font:TS:35:I", posCenter, begPosY + 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
				local curColor = Diablos.TS.Colors.gl
				if currentTimer <= 3 then
					curColor = Diablos.TS.Colors.rl
				end

				local secondStr = Diablos.TS:GetLanguageString("second")
				if currentTimer > 1 then
					secondStr = Diablos.TS:GetLanguageString("seconds")
				end

				surface.SetFont("Diablos:Font:TS:40:B")
				local sizextimer, sizeytimer = surface.GetTextSize(currentTimer)
				surface.SetFont("Diablos:Font:TS:25")
				local sizexsecond = surface.GetTextSize(secondStr)

				local sizextotal = sizextimer + sizexsecond

				draw.SimpleText(currentTimer, "Diablos:Font:TS:40:B", posCenter - sizextotal / 2, begPosY + sizeY - 5, curColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(secondStr, "Diablos:Font:TS:25", posCenter - sizextotal / 2 + sizextimer + 10, begPosY + sizeY - 5 - sizeytimer / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				posCenter = w - w / 2 / 2
				surface.SetDrawColor(Diablos.TS.Colors.CurLevelBox)
				surface.DrawRect(w / 2 + 5, begPosY, w / 2 - 15, sizeY)
				local leaveKey = string.upper(Diablos.TS:GetKeyNameReference(Diablos.TS.StopTrainingKey))
				draw.SimpleText(Diablos.TS:GetLanguageString("leaveTraining"), "Diablos:Font:TS:35:I", posCenter, begPosY + 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				local fontSize = 30
				if h < 300 then
					fontSize = 25
				end

				Diablos.TS:DrawKey(leaveKey, posCenter, begPosY + sizeY - 5 - 15, fontSize, 10, false)

				if curLevelFrame.text then
					draw.SimpleText(curLevelFrame.text, "Diablos:Font:TS:45", w / 2, h - 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
				end
			end
		end
	else
		if IsValid(curLevelFrame) then
			curLevelFrame:Close()
			curLevelFrame = nil
		end
	end

end)

/* Show the treadmill training information */

hook.Add("HUDPaint", "TPTSA:ShowTreadmillInfo", function()
	local ply = LocalPlayer()
	local curtime = CurTime()
	local scrw, scrh = ScrW(), ScrH()

	if ply.typeTraining == "stamina" or ply.typeTraining == "runningspeed" then
		if ply.keyTipTime != nil and ply.keyTipTime > 0 then

			if IsValid(curLevelFrame) then
				curLevelFrame.text = string.format("%s: %4.2f %s", Diablos.TS:GetLanguageString("treadmillCurSpeed"), ply.curSpeed, Diablos.TS:GetSpeedText())
			end

			if ply.beginTraining > curtime then
				local keyName = Diablos.TS:GetKeyNameReference(IN_FORWARD)
				if keyName then
					keyName = string.upper(keyName)
					Diablos.TS:DrawKey(keyName, scrw * 0.5, scrh * 0.8, 45, 40, true)
				end

			else
				if ply:KeyDown(IN_FORWARD) then
					ply.keyTipTime = curtime
				end

				if not ply:KeyDown(IN_FORWARD) and ply.keyTipTime + 1.5 < curtime then
					local keyName = Diablos.TS:GetKeyNameReference(IN_FORWARD)
					if keyName then
						keyName = string.upper(keyName)
						Diablos.TS:DrawKey(keyName, scrw * 0.5, scrh * 0.8, 45, 40, true)
					end
				end
			end
		end
	end
end)

/* Show the dumbbell training information */

local dumbbellCircleCol = Color(255, 255, 255, 10)

hook.Add("HUDPaint", "TPTSA:ShowDumbbellInfo", function()
	local ply = LocalPlayer()
	local curtime = CurTime()
	local scrw, scrh = ScrW(), ScrH()

	if ply.typeTraining == "strength" then

		if IsValid(curLevelFrame) then
			curLevelFrame.text = string.format("%u/%u %s", ply.curnbKeysSucceed, #ply.keyTable, Diablos.TS:GetLanguageString("keys"))
		end

		local heightPoint = 0.8

		surface.SetDrawColor(dumbbellCircleCol)
		surface.SetMaterial(Diablos.TS.Materials.dumbbellBackground)
		surface.DrawTexturedRect(0, scrh * heightPoint, scrw, 200)

		surface.SetDrawColor(color_white)

		surface.SetMaterial(Diablos.TS.Materials.circle)
		surface.DrawTexturedRect(scrw * 0.5 - 100, scrh * heightPoint, 200, 200)


		if ply.beginTraining <= curtime then

			local totalTime = ply.EndTraining - ply.beginTraining
			local timePerKey = (totalTime - 2) / #ply.keyTable
			for k,v in ipairs(ply.keyTable) do
				local realName = string.upper(language.GetPhrase(input.GetKeyName(v)))

				local diff = curtime - ply.beginTraining
				local xCalc = (scrw * 0.5 * (k-1)) + ((scrw * 1) - ((scrw * 0.5) * diff / timePerKey))

				local intervalTouch = 0.3 -- meaning you have intervalTouch second interval to touch
				local goodTime = diff - k * timePerKey

				-- If the key has not been managed (still not right nor wrong)
				if #ply.keyGreat < k then
					-- If you press a key in the wrong interval: failure!
					for i = 1, 36 do
						if input.IsKeyDown(i) and (goodTime > -(timePerKey - intervalTouch) and goodTime < -intervalTouch) then
							table.insert(ply.keyGreat, k, false)
						end
					end

					-- You pressed the correct key in the good interval: success!
					if input.IsKeyDown(v) and (goodTime <= intervalTouch and goodTime >= -intervalTouch) then
						table.insert(ply.keyGreat, k, true)
						ply.curnbKeysSucceed = ply.curnbKeysSucceed + 1
					end

					-- Too late
					if goodTime > intervalTouch then
						table.insert(ply.keyGreat, k, false)
					end
				end

				Diablos.TS:DrawKey(realName, xCalc, scrh * heightPoint + 100, 45, 40, false, k)
			end

			-- Since it is better to manage keys clientside to not abuse the network traffic,
			-- The net has a lot of verification serverside to ensure everything is alright.
			if ply.EndTraining < curtime then
				net.Start("TPTSA:DumbbellResult")
					net.WriteUInt(#ply.keyTable, 8)
					for k,v in ipairs(ply.keyGreat) do
						net.WriteBool(v)
					end
				net.SendToServer()
				Diablos.TS:StopTraining(ply, ply.typeTraining)
				ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
			end
		end
	end
end)



/* Show the punching ball training information */

hook.Add("HUDPaint", "TPTSA:ShowPunchingInfo", function()
	local ply = LocalPlayer()

	if ply.typeTraining == "attackspeed" then
		if IsValid(curLevelFrame) then
			curLevelFrame.text = string.format(Diablos.TS:GetLanguageString("punchingHitDamage"), ply.curHit)
		end
	end
end)

/* Show the stamina bar */

local staminaPanel

hook.Add("HUDPaint", "TPTSA:StaminaPanel", function()

	-- Don't show the panel if stamina is disabled
	if not Diablos.TS:IsTrainingEnabled("stamina") then return end

	if Diablos.TS.ShowStaminaOnRun then

		local ply = LocalPlayer()

		-- Don't show the panel if the stamina has not been initialized
		if not ply.InitStamina then return end

		-- Don't show the panel if you're training
		if (ply.typeTraining and ply.typeTraining != "") then return end


		local scrw, scrh = ScrW(), ScrH()

		local curStamina = ply:TSGetStamina()
		local maxStamina = ply:TSGetMaxStamina()

		if IsValid(staminaPanel) and (curStamina == maxStamina or ply.StaminaNoClip) then
			staminaPanel:Remove()
		end

		if (not IsValid(staminaPanel) and curStamina != maxStamina) then

			local posX, posY
			if Diablos.TS.StaminaPanelPosX >= 0 and Diablos.TS.StaminaPanelPosX <= 1 then
				posX = scrw * Diablos.TS.StaminaPanelPosX
			else
				posX = Diablos.TS.StaminaPanelPosX
			end
			if Diablos.TS.StaminaPanelPosY >= 0 and Diablos.TS.StaminaPanelPosY <= 1 then
				posY = scrh * Diablos.TS.StaminaPanelPosY
			else
				posY = Diablos.TS.StaminaPanelPosY
			end

			if Diablos.TS.MinimalisticPanel then

				local sizex, sizey = scrw / 1920 * (Diablos.TS.MinimalisticBarX or 200), scrh / 1080 * (Diablos.TS.MinimalisticBarY or 40)

				staminaPanel = vgui.Create("DPanel")
				staminaPanel:SetPos(posX, posY)
				staminaPanel:SetSize(sizex, sizey)
				staminaPanel.Paint = function(s, w, h)
					curStamina = ply:TSGetStamina()
					maxStamina = ply:TSGetMaxStamina()

					local percent = curStamina / maxStamina

					local sizeX = w - 10
					local sizeY = h - 10

					local posXPanel = 5
					local posYPanel = h - sizeY - 5

					surface.SetDrawColor(Diablos.TS.Colors.StaminaBar)
					surface.DrawRect(posXPanel, posYPanel, sizeX, sizeY)

					local percentColor = Color(200 - (percent * 100) * 2, percent * 100, 0, 255)

					surface.SetDrawColor(percentColor)
					surface.DrawRect(posXPanel, posYPanel, sizeX * percent, sizeY)
				end

			else

				local sizex, sizey = scrw / 1920 * 300, scrh / 1080 * 85

				staminaPanel = vgui.Create("DPanel")
				staminaPanel:SetPos(posX, posY)
				staminaPanel:SetSize(sizex, sizey)
				staminaPanel.Paint = function(s, w, h)
					curStamina = ply:TSGetStamina()
					maxStamina = ply:TSGetMaxStamina()

					local realSpeed = Diablos.TS:GetSpeedFromUnit(ply:GetRunSpeed())

					local percent = curStamina / maxStamina

					surface.SetDrawColor(Diablos.TS.Colors.CurLevelBox)
					surface.DrawRect(0, 0, w, h)

					draw.SimpleText(string.format("%s", Diablos.TS:GetLanguageString("runSpeed")), "Diablos:Font:TS:20:I", 5, 5, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					draw.SimpleText(string.format("%4.2f %s", math.Round(realSpeed, 2), Diablos.TS:GetSpeedText()), "Diablos:Font:TS:20:B", w - 5, 5, Diablos.TS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

					local sizeX = w - 10
					local sizeY = h * 0.35

					local posXPanel = 5
					local posYPanel = h - sizeY - 5


					local maxSpeedText = string.format("%s", Diablos.TS:GetLanguageString("timeMaxSpeed"))
					local fontToUse = "Diablos:Font:TS:20:I"
					surface.SetFont(fontToUse)
					local sizexSpeed = surface.GetTextSize(maxSpeedText)
					if sizexSpeed > w - 70 then
						fontToUse = "Diablos:Font:TS:15:I"
					end
					draw.SimpleText(maxSpeedText, fontToUse, 5, posYPanel - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					draw.SimpleText(string.format("%u %s", ply:TSGetStaminaTimeDuration(), Diablos.TS:GetLanguageString("seconds")), "Diablos:Font:TS:20:B", w - 5, posYPanel - 5, Diablos.TS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)


					surface.SetDrawColor(Diablos.TS.Colors.StaminaBar)
					surface.DrawRect(posXPanel, posYPanel, sizeX, sizeY)

					local percentColor = Color(200 - (percent * 100) * 2, percent * 100, 0, 255)
					surface.SetDrawColor(percentColor)
					surface.DrawRect(posXPanel, posYPanel, sizeX * percent, sizeY)



					draw.SimpleText(string.format("%u%%", curStamina), "Diablos:Font:TS:30", posXPanel + sizeX - 5, posYPanel + sizeY / 2, Diablos.TS.Colors.Label, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				end
			end
		end
	end
end)

/* 
	Block the bind presses (for example moving forward, jumping, etc.) when you're doing a dumbbell training
	The only exception is the "Leave training" key that we don't want to prevent in case the user wants to stop the training 
*/

hook.Add("PlayerBindPress", "TPTSA:DisableBindDumbbellTraining", function (ply, bind, pressed, code)
	if ply.typeTraining == "strength" then
		local leaveBind = "+" .. Diablos.TS:GetBindReference(Diablos.TS.StopTrainingKey)
		if bind != leaveBind then
			return true
		end
	end
end)


local hide = {
	["CHudAmmo"] = true,
	["CHudBattery"] = true,
	["CHudChat"] = true,
	["CHudCrosshair"] = true,
	["CHudCloseCaption"] = true,
	["CHudDamageIndicator"] = true,
	["CHudDeathNotice"] = true,
	["CHudGeiger"] = true,
	["CHudGMod"] = false, -- Default gmod hud
	["CHudHealth"] = true,
	["CHudHintDisplay"] = true,
	["CHudMenu"] = false, -- Should still be able to open main menu/console
	["CHudMessage"] = true,
	["CHudPoisonDamageIndicator"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudSquadStatus"] = true,
	["CHudTrain"] = true,
	["CHudVehicle"] = true,
	["CHudWeapon"] = true,
	["CHudWeaponSelection"] = true,
	["CHudZoom"] = true,
	["NetGraph"] = true,
	["CHUDQuickInfo"] = true,
	["CHudSuitPower"] = true,
}

hook.Add( "HUDShouldDraw", "TPTSA:HideHUDElements", function( name )
	if ( hide[ name ] and LocalPlayer().typeTraining and LocalPlayer().typeTraining != "" ) then return false end
end )


/* Hook to create materials when you're on startup */

hook.Add("HUDPaint", "TPTSA:CreateMaterialsOnStartup", function()
	timer.Simple(5, function()
		Diablos.TS:GenerateMaterialsOnStartup()
	end)
	hook.Remove("HUDPaint", "TPTSA:CreateMaterialsOnStartup")
end)