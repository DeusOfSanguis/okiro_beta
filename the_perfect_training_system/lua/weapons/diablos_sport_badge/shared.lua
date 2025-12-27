SWEP.Author 			= "Diablos"
SWEP.Base				= "weapon_base"
SWEP.Contact 			= "gmodstore.com/users/diablos"
SWEP.PrintName 			= "Sport Badge"
SWEP.Category 			= "Diablos Addon"
SWEP.Instructions 		= "A sport badge to access to training rooms"
SWEP.Purpose 			= ""
SWEP.Spawnable 			= true
SWEP.DrawCrosshair 		= true
SWEP.DrawAmmo 			= false
SWEP.Weight 			= 0
SWEP.SlotPos 			= 2
SWEP.Slot 				= 4
SWEP.NextAttack			= 0
SWEP.Primary.Cone		= 0.02	
--------------------------------------------------------------------------------|
SWEP.Primary.Ammo         		= "none"
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Delay 				= 1
SWEP.Primary.Automatic   		= false							
--------------------------------------------------------------------------------|
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic		= false
--------------------------------------------------------------------------------|


/* Weapon */

SWEP.HoldType = "pistol"
SWEP.UseHands = true
-- SWEP.SwayScale = 1.5
-- SWEP.BobScale = 1.5
SWEP.ViewModel = "models/tptsa/sportbadge/c_sportbadge.mdl"
SWEP.WorldModel = "models/tptsa/sportbadge/w_sportbadge.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.NeedDeployment = true

SWEP.ViewModelFOV = 60
SWEP.DefaultViewModelFOV = SWEP.ViewModelFOV
SWEP.ViewModelFlip = false

SWEP.IronSightsPos = vector_origin
SWEP.IronSightsAng = vector_origin


SWEP.WElements = {
	["sportbadge"] = { type = "Model", model = "models/tptsa/sportbadge/w_sportbadge.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.5, 2, -2.201), angle = Angle(-8.183, 97.013, 22.208), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Initialize()
	
self:SetWeaponHoldType( self.HoldType )

	if CLIENT then
	
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )
		self:CreateModels(self.VElements)
		self:CreateModels(self.WElements)
		
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)

				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					vm:SetColor(Color(255,255,255,1))
					vm:SetMaterial("Debug/hsv")
					-- vm:SetMaterial("Models/effects/vol_light001")
				end
			end
		end
		
	end
end
function SWEP:Holster()
	self.ViewModelFOV = self.DefaultViewModelFOV
	self.IsMovingArms = false

	self.IronSightsPos = vector_origin
	self.IronSightsAng = vector_origin

	local owner = self:GetOwner()
	if IsValid(owner) then

		if CLIENT then
			local vm = owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
			end
		end
	end
	
	return true
end

function SWEP:GetViewModelPosition(EyePos, EyeAng)
	local Mul = 1.0

	local Offset = self.IronSightsPos

	if (self.IronSightsAng) then
        EyeAng = EyeAng * 1
        
		EyeAng:RotateAroundAxis(EyeAng:Right(), 	self.IronSightsAng.x * Mul)
		EyeAng:RotateAroundAxis(EyeAng:Up(), 		self.IronSightsAng.y * Mul)
		EyeAng:RotateAroundAxis(EyeAng:Forward(),   self.IronSightsAng.z * Mul)
	end

	local Right 	= EyeAng:Right()
	local Up 		= EyeAng:Up()
	local Forward 	= EyeAng:Forward()

	EyePos = EyePos + Offset.x * Right * Mul
	EyePos = EyePos + Offset.y * Forward * Mul
	EyePos = EyePos + Offset.z * Up * Mul
	
	return EyePos, EyeAng
end

function SWEP:OnRemove()
	self:Holster()
end
if CLIENT then
	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self:GetOwner():GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)
		if (!self.vRenderOrder) then

			self.vRenderOrder = {}
			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				end
			end
			
		end
		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			end
		end
	end
	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then
			self.wRenderOrder = {}
			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				end
			end
		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			end
			
		end
		
	end
	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end

			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)
			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r
			end
		
		end
		
		return pos, ang
	end
	function SWEP:CreateModels( tab )
		if (!tab) then return end
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end

			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end

				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
			
	end
		
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	function table.FullCopy( tab )
		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v) // recursion ho!
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end

-- [[ End of the special code ]] --

SWEP.TimeAnim = 0.5 -- in seconds
SWEP.FOVDiff = 20 -- FOV difference
SWEP.OutstretchedArms = 1
SWEP.IsMovingArms = false
SWEP.LastClick = 0

/*---------------------------------------------------------------------------
	Called to simulate an animation when you're approaching or moving away
	This just "pushing" the badge, then pulling it after a speficic amount of seconds
---------------------------------------------------------------------------*/

function SWEP:ChangeViewModelFOV()
	local ply = self:GetOwner()

	if self.IsMovingArms then return end

	self.IsMovingArms = true
	self.Animating = CurTime()
	self.Pushing = true
end


function SWEP:Think()

	if not self.IsMovingArms then return end

	local curtime = CurTime()

	local ratio = math.min(1, (curtime - self.Animating) / self.TimeAnim)
	if self.Pushing then
		-- Push
		self.ViewModelFOV = self.DefaultViewModelFOV + ratio * self.FOVDiff

		angHand = Angle(-ratio * 20, ratio * 50, 0)
		angForearm = Angle(-ratio * 20, 0, 0)

		if ratio == 1 then
			if (curtime - self.Animating) >= self.TimeAnim + self.OutstretchedArms then
				self.Animating = curtime
				self.Pushing = false
			end
		end
	else
		-- Pull
		ratio = 1 - ratio

		self.ViewModelFOV = self.DefaultViewModelFOV + ratio * self.FOVDiff

		if ratio == 0 then
			self.IsMovingArms = false
		end

	end

	self.IronSightsPos  = Vector(0, 0, ratio * 2)
	self.IronSightsAng  = Vector(-ratio * 2, 0, ratio * 45)

end

/*---------------------------------------------------------------------------
	Call the "animation simulation", then detecting if your eye trace is focusing an entity
	ie. a turnstile or a card reader
---------------------------------------------------------------------------*/

function SWEP:PrimaryAttack() 
	if not IsFirstTimePredicted() then return end
	if self.LastClick + 1 > CurTime() then return end

	self.LastClick = CurTime()

	self:ChangeViewModelFOV()

	timer.Simple(self.TimeAnim, function()
		local ply = self:GetOwner()
		if IsValid(ply) then
			local ent = ply:GetEyeTrace().Entity
			if CLIENT then return end
			if IsValid(ent) then
				local coachs = {}
				for _, pl in ipairs(player.GetAll()) do
					if pl:TSIsSportCoach() then
						table.insert(coachs, pl)
					end
				end

				if ent:GetClass() == "diablos_turnstile_button" and ent.typeButton == "forward" then
					if ply:TSHasTrainingSubscription() or not Diablos.TS.SubSystem or (not Diablos.TS.PurchaseSubWithoutCoach and #coachs == 0) then
						ent:AccessForward(ply)
						Diablos.TS:Notify(ply, 0, Diablos.TS:GetLanguageString("sportBadgeVerified"))
					elseif ply:TSHasTrainingBadgeCredit() then
						ply:TSUseBadgeCredit()
						ent:AccessForward(ply)
						Diablos.TS:Notify(ply, 0, Diablos.TS:GetLanguageString("sportBadgeVerified"))
					else
						Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("sportBadgeInvalid"))
						ent:NFCError()
					end
					
				elseif ent:GetClass() == "diablos_card_reader" then

					if not ply:TSCanPurchaseTrainingSubscription() then
						Diablos.TS:Notify(ply, 2, string.format(Diablos.TS:GetLanguageString("cardReaderFullyRecharged"), os.date(Diablos.TS:GetOSFormat(), ply:TSGetTrainingSubscription())))
						return
					end

					net.Start("TPTSA:CardReaderPurchase")
						net.WriteEntity(ent)
						net.WriteUInt(ent:GetSubPrice(), 16)
						net.WriteUInt(#coachs, 8)
						for _, pl in pairs(coachs) do
							net.WriteEntity(pl)
						end
					net.Send(ply)

				end
			end
		end
	end)
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end

	self:PrimaryAttack()
end


function SWEP:Deploy()
end

function SWEP:OnRestore() end

function SWEP:IsValidSub()
	return self:GetOwner():TSHasTrainingSubscription()
end

-- Almost the default function but using a SetMaterial instead of a SetTexture
-- https://wiki.facepunch.com/gmod/WEAPON:DrawWeaponSelection
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

	-- Set us up the texture
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( Diablos.TS.Materials.sportbadgeRecto )

	-- Lets get a sin wave to make it bounce
	local fsin = 0

	if ( self.BounceWeaponIcon == true ) then
		fsin = math.sin( CurTime() * 10 ) * 5
	end

	-- Borders
	y = y + 40
	x = x + 40
	wide = wide - 80

	-- Draw that mother
	surface.DrawTexturedRect( x + (fsin), y - (fsin),  wide-fsin*2 , ( wide / 2 ) + (fsin) )

	-- Draw weapon info box
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
end