AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/tptsa/turnstile/turnstile.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then phys:Wake() phys:EnableMotion(false) end


	-- Creating the invisible walls
	for i = 1, 3 do
		local colorBlock
		local posBlock
		if i == 1 then
			colorBlock = Color(67, 158, 233)
			posBlock = 50
		elseif i == 2 then
			colorBlock = Color(255, 255, 255)
			posBlock = 0
		elseif i == 3 then
			colorBlock = Color(190, 5, 5)
			posBlock = -50
		end
		local blockPath = ents.Create("diablos_turnstile_trigger")
		if not IsValid(blockPath) then return end
		blockPath:SetSolid(SOLID_VPHYSICS)
		blockPath:SetPos(self:GetPos())
		blockPath:SetAngles(self:GetAngles())
		blockPath:SetRenderMode(RENDERMODE_TRANSCOLOR)
		blockPath:SetColor(colorBlock)
		blockPath:DrawShadow(false)
		blockPath:SetNoDraw(not Diablos.TS.DebugDev)
		blockPath:SetParent(self)
		blockPath:SetLocalPos(Vector(posBlock, -20, 40))
		blockPath:SetLocalAngles(Angle(0, -90, 90))
		blockPath:Spawn()
		blockPath:Activate()
		blockPath:SetTurnstile(self)

		if i == 1 then
			blockPath:SetTypeDirection("forward")
			self.blockBeginningPath = blockPath
		elseif i == 2 then
			blockPath:SetModel("models/hunter/plates/plate1x2.mdl")
			blockPath:SetTypeDirection("middle")
			self.blockMiddlePath = blockPath
		elseif i == 3 then
			blockPath:SetTypeDirection("backward")
			self.blockEndPath = blockPath
		end
	end


	self.blockBeginningPath:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self.blockEndPath:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

	-- Creating the buttons

	local posDist = 23
	for i = 1, 2 do
		local posX
		local colorBlock
		if i == 1 then
			posX = posDist
			colorBlock = Color(0, 255, 0)
		elseif i == 2 then
			posX = -posDist
			colorBlock = Color(0, 0, 255)
		end
		local button = ents.Create("diablos_turnstile_button")
		if not IsValid(button) then return end
		button:SetModel("models/hunter/blocks/cube025x025x025.mdl")
		button:SetPos(self:GetPos())
		button:SetParent(self)
		button:SetLocalPos(Vector(posX, 0, 35))
		button:SetLocalAngles(Angle(0, 0, 0))
		button:DrawShadow(false)
		button:SetColor(colorBlock)
		button:SetNoDraw(not Diablos.TS.DebugDev)
		button:Spawn()
		button:Activate()
		button:SetTurnstile(self)
		button:SetTypeButton("forward")
		self.button = button

		if i == 1 then
			button:SetTypeButton("forward")
			self.buttonGoing = button
		elseif i == 2 then
			button:SetTypeButton("backward")
			self.buttonComing = button
		end

		button:SetNoDraw(true)

	end

	self.isAccessing = false
	self.curDirection = "" -- can be "forward", "backward" or ""

	self:Reset(true)
end

function ENT:SpawnFunction(ply, tr, classname)
	if not tr.Hit then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 32
	local ent = ents.Create(classname)
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent
end

/*
	The access is possible in two directions
	- forward: from the NFC to the button
	- backward: from the button to the NFC
*/

function ENT:Access(ply, direction)
	-- animation of the entity
	if not self.isAccessing then
		self.isAccessing = true
		if direction == "forward" then
			self:NFCValid()
			self:UnlockMiddleWall(true)
		elseif direction == "backward" then
			self:ResetSequence("Button")
			self:NFCLocked() -- locked because you're using the turnstile in the other direction
			self:UnlockMiddleWall()
		end
		self.curDirection = direction
	end
end

/*
	Get the invisible wall behind you when you're accessing in a specific direction
	This wall will become solid for you to be forced to finish in the same direction
*/

function ENT:GetBehindEntity()
	local entityToLock
	if self.curDirection == "forward" then
		entityToLock = self.blockBeginPath
	elseif self.curDirection == "backward" then
		entityToLock = self.blockEndPath
	end

	return entityToLock
end

/*
	Make the wall solid (for players) to be forced to finish in the same direction
*/

function ENT:CloseBehind()
	local entityToLock = self:GetBehindEntity()

	if IsValid(entityToLock) then
		entityToLock:SetCollisionGroup(COLLISION_GROUP_NONE)
	end
end

/*
	Launch the specific turnstile animation, depending on the direction
*/

function ENT:LaunchAnimation()
	local animName
	if self.curDirection == "forward" then
		animName = "enter"
	elseif self.curDirection == "backward" then
		animName = "exit"
	end

	if not animName then return end
	self:ResetSequence(animName)
end

/*
	Called when you successfully passed the turnstile, to reset values and make the
	invisible walls not solid again except the middle one
*/

function ENT:SuccessfullyPassed()
	local entity = self:GetBehindEntity()
	self:NFCIdle()


	-- make the wall locked no more locked
	if IsValid(entity) then
		entity:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	end

	-- the middle becomes locked
	timer.Simple(1, function()
		if not IsValid(self) then return end
		if not IsValid(self.blockMiddlePath) then return end
		self.blockMiddlePath:SetCollisionGroup(COLLISION_GROUP_NONE)
	end)

	self.curDirection = ""
	self.isAccessing = false
end

/*
	Unlock the middle wall if you have an allowed access
	The wall will be automatically solid again after a certain amount of seconds
	If backIdle boolean is set to true, the idle state will be set on the NFC when the wall will become solid again
*/

function ENT:UnlockMiddleWall(backIdle)
	self.blockMiddlePath:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)

	-- If you don't pass, the wall becomes solid again!
	timer.Simple(8, function()
		if IsValid(self) then
			self:Reset(backIdle)
		end
	end)
end

/*
	Reset everything (idle state, wall, variables) if nobody accessed after a certain amount of time
	If backIdle boolean is set to true, the idle state will be set on the NFC when the wall will become solid again
*/

function ENT:Reset(backIdle)
	self.blockMiddlePath:SetCollisionGroup(COLLISION_GROUP_NONE)
	if backIdle then
		self:NFCIdle()
	end
	self.curDirection = ""
	self.isAccessing = false
end


/*
	Get the NFC bodygroup number
*/

function ENT:GetNFCStateBodygroup()
	return self:FindBodygroupByName("state")
end


/*
	Update the NFC state with the different states possibles
*/

function ENT:UpdateNFCState(state)
	local index
	if state == "idle" then
		index = 0
	elseif state == "error" then
		index = 1
	elseif state == "valid" then
		index = 2
	elseif state == "off" then
		index = 3
	elseif state == "opened" then
		index = 4
	elseif state == "locked" then
		index = 5
	end

	self:SetBodygroup(self:GetNFCStateBodygroup(), index)
end

/*
	Get the current NFC state
*/

function ENT:GetNFCState()
	local bodygroup = self:GetBodygroup(self:GetNFCStateBodygroup())

	local name
	if bodygroup == 0 then
		name = "idle"
	elseif bodygroup == 1 then
		name = "error"
	elseif bodygroup == 2 then
		name = "valid"
	elseif bodygroup == 3 then
		name = "off"
	elseif bodygroup == 4 then
		name = "opened"
	elseif bodygroup == 5 then
		name = "locked"
	end
	return name
end

/*
	NFC error state
	Launches a sound, turned back into idle after a certain amount of time
*/

function ENT:NFCError()
	self:EmitSound("Diablos:Sound:TS:Incorrect")
	self:UpdateNFCState("error")

	timer.Simple(3, function()
		if IsValid(self) then
			if self:GetNFCState() == "error" then
				self:UpdateNFCState("idle")
			end
		end
	end)
end

/*
	NFC valid state
	Launches a sound
*/

function ENT:NFCValid()
	self:EmitSound("Diablos:Sound:TS:Correct")
	self:UpdateNFCState("valid")
end

function ENT:NFCIdle()
	self:UpdateNFCState("idle")
end

function ENT:NFCOff()
	self:UpdateNFCState("off")
end

function ENT:NFCLocked()
	self:UpdateNFCState("locked")
end