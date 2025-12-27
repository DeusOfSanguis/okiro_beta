local meta = FindMetaTable("Player")

/*---------------------------------------------------------------------------
	Get stamina parameters
---------------------------------------------------------------------------*/

Diablos.TS.Parameters.Stamina = {
	Regen = 1.5, -- Time to regen your health
	MaxStamina = 100, -- Maximum stamina
	JumpInvolveStamina = true, -- true = a jump will consume some stamina, so you could be not allowed to jump if not enough stamina
	MinimumToJump = 10, -- if JumpInvolveStamina is set to true, this is the minimum stamina you need to be allowed to jump ; it will consume that value
}

/*---------------------------------------------------------------------------
	Get the current stamina of the player
---------------------------------------------------------------------------*/

function meta:TSGetStamina()
	return self.CurrentStamina or 100
end

/*---------------------------------------------------------------------------
	Get the maximum stamina the player can have (everyone is capped at 100 currently)
---------------------------------------------------------------------------*/

function meta:TSGetMaxStamina()
	self.MaxStamina = self.MaxStamina or Diablos.TS.Parameters.Stamina.MaxStamina
	return self.MaxStamina
end

/*---------------------------------------------------------------------------
	Get the amount of stamina this is decreasing depending on your stamina level
	First level, you're losing MinimumToJump points - last level, you're losing MinimumToJump * 0.25 points
---------------------------------------------------------------------------*/

function meta:TSGetJumpStamina()
	local level = Diablos.TS:GetTrainingLevel("Stamina", self)
	local levels = Diablos.TS:GetTrainingLevelTable("Stamina")

	local ratio = level / #levels
	local pointsToLose = Diablos.TS.Parameters.Stamina.MinimumToJump * (1 - 0.75 * ratio)

	return pointsToLose
end

/*---------------------------------------------------------------------------
	Update the stamina and return it
---------------------------------------------------------------------------*/

function meta:TSUpdateStamina(newStamina)
	local oldStamina = self:TSGetStamina()
	self.CurrentStamina = math.Clamp(newStamina, 0, self:TSGetMaxStamina())

	-- the self.NextRegen field needs to be updated only if you lose some stamina, otherwise it means you're in the regen mode
	if self:TSGetStamina() < oldStamina then
		self.NextRegen = CurTime() + Diablos.TS.Parameters.Stamina.Regen
	end
	return self:TSGetStamina()
end

/*---------------------------------------------------------------------------
	Get if the player is able to jump, meaning:
		* the player has enough stamina
		* the MinimumToJump is set to 0
---------------------------------------------------------------------------*/

function meta:TSCanJump()
	local minimumToJump = Diablos.TS.Parameters.Stamina.MinimumToJump

	return minimumToJump == 0 or self:TSGetStamina() >= minimumToJump
end

/*---------------------------------------------------------------------------
	Get if the player should regen its stamina
---------------------------------------------------------------------------*/

function meta:TSCanRegenStamina()
	return (self.NextRegen != nil) and self.NextRegen < CurTime()
end

/*---------------------------------------------------------------------------
	Get the run speed you should have considering your runspeed level
---------------------------------------------------------------------------*/

function meta:TSGetRealRunSpeed()
	if not self.TS_JOB_RUN_SPEED then
		self.TS_JOB_RUN_SPEED = self:GetRunSpeed()
	end

	return self.TS_JOB_RUN_SPEED + self:TSGetRunningSpeed()
end

/*---------------------------------------------------------------------------
	Update the run speed of the player with the new run speed
---------------------------------------------------------------------------*/

function meta:TSRefreshRunSpeed()
	self.TS_RUN_SPEED_UPD_STAMINA = false
	local realRunSpeed = self:TSGetRealRunSpeed()
	self:SetRunSpeed(realRunSpeed)
	self.TS_RUN_SPEED_UPD_STAMINA = true
end

/*---------------------------------------------------------------------------
	Update the stamina of the player, this will:
		* update the stamina to the maximum

---------------------------------------------------------------------------*/

function meta:TSRefreshStamina()

	if self:TSIsTrainingDataLaunched() then

		self:TSUpdateStamina(self:TSGetMaxStamina())
		self.RegenStamina = 10

		self.DecreaseTime = self:TSGetStaminaTimeDuration() -- in x seconds you lose all your stamina if holding speed

		self.InitStamina = true
	end

end

function Diablos.TS:IsMoving(cmd)
	return cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK) or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT)
end



hook.Add( "StartCommand", "TPTSA:StaminaCalc", function(ply, cmd)

	-- Don't calculate stamina is disabled
	if not Diablos.TS:IsTrainingEnabled("stamina") then return end

	if not ply.InitStamina then return end

	local inVehicle = ply:InVehicle()
	local isMoving = Diablos.TS:IsMoving(cmd)

	local frameTime = FrameTime()
	local frameRealism = frameTime * (1 / engine.TickInterval()) / 100

	local curStamina = ply:TSGetStamina()
	local waterLevel = ply:WaterLevel()
	local onGround = ply:OnGround()

	if not inVehicle then
		if cmd:KeyDown(IN_SPEED) and isMoving and ply:GetVelocity():Length() > 100 and (onGround or waterLevel != 0) then
			if curStamina <= 0 then
				cmd:RemoveKey(IN_SPEED)
			else
				curStamina = ply:TSUpdateStamina(curStamina - 100 / ply.DecreaseTime * frameRealism)
			end
		end

		-- Manage the jump feature which is a stamina loss if enabled
		if Diablos.TS.Parameters.Stamina.JumpInvolveStamina then
			if cmd:KeyDown(IN_JUMP) and onGround then
				if not ply:TSCanJump() then
					cmd:RemoveKey(IN_JUMP)
				end
				if ((ply.lastJump or 0) + 0.7 < CurTime()) then
					ply.lastJump = CurTime()

					if ply:TSCanJump() then
						local staminaUpd = 0
						if cmd:KeyDown(IN_SPEED) and isMoving then
							staminaUpd = curStamina - ply:TSGetJumpStamina()
						else
							staminaUpd = curStamina - ply:TSGetJumpStamina() * 0.5
						end
						curStamina = ply:TSUpdateStamina(staminaUpd)
					end
				end
			end
		end
	end

	-- Being inside the water also inducts a stamina loss
	if waterLevel == 3 then
		curStamina = ply:TSUpdateStamina(curStamina - 100 / ply.DecreaseTime * frameRealism)
	end


	if ply:TSCanRegenStamina() then
		local staminaUpd = 0
		if (isMoving and not inVehicle) then
			staminaUpd = curStamina + ( frameTime * 0.1 * ply.RegenStamina )
		else
			staminaUpd = curStamina + ( frameTime * 0.5 * ply.RegenStamina )
		end
		ply:TSUpdateStamina(staminaUpd)
	end
end)