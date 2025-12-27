ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "Treadmill"
ENT.Category		= "Diablos Addon"
ENT.Instructions	= ""
ENT.Spawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "TrainingID")
	self:NetworkVar("Entity", 0, "TrainingPlayer")
	self:NetworkVar("Int", 1, "TrainingSpeed")
end

function ENT:GetAngleBodygroup()
	return self:FindBodygroupByName("angle")
end

function ENT:GetAngle()
	return self:GetBodygroup(self:GetAngleBodygroup()) + 1
end

function ENT:GetLevel()
	return self:GetAngle()
end

function ENT:SetTreadmillMaterial(speed)
	speed = math.Clamp(speed, 0, 50)
	if speed != 0 then
		speed = speed + (5 - (speed % 5))
	end
	local matName = Diablos.TS.Materials["TreadmillMat"] .. ":" .. tostring(speed)

	local treadmillMaterialIndex = self:GetTreadmillMaterial() - 1
	self:SetSubMaterial(treadmillMaterialIndex, "!" .. matName) -- 4 is floor, so it's 4-1 = 3
end


function ENT:GetTreadmillMaterial()
	local materials = self:GetMaterials()
	local floorMaterial = 0
	for index, material in ipairs(materials) do
		if material == "models/tptsa/treadmill/floor" then
			floorMaterial = index
		end
	end
	return floorMaterial
end