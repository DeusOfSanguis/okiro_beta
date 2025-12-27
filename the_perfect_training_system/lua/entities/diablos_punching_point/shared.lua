ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "Punching Ball"
ENT.Category		= "Diablos Addon"
ENT.Instructions	= ""
ENT.Spawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "TrainingID")
end

function ENT:GetWeightBodygroup()
	return self:FindBodygroupByName("weight")
end

function ENT:GetChainBodygroup()
	return self:FindBodygroupByName("chain")
end

function ENT:GetImageBodygroup()
	return self:FindBodygroupByName("img")
end


function ENT:GetWeight()
	return self:GetBodygroup(self:GetWeightBodygroup()) + 1
end


function ENT:SetWeight(newWeight)
	self.weight = newWeight

	local bodygroup = self:GetWeight()
	local trainingData = Diablos.TS.PunchingBallSizeEquivalence[bodygroup]
	self.trainingDuration = trainingData.time

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(trainingData.mass)
	end

	self:SetBodygroup(self:GetWeightBodygroup(), newWeight - 1) -- weight
end

function ENT:GetLevel()
	return self:GetWeight()
end


function ENT:SetLogoMaterial()
	local matName = Diablos.TS.Materials["PunchingLogoName"]

	local punchingMaterialIndex = self:GetImageMaterial() - 1
	self:SetSubMaterial(punchingMaterialIndex, "!" .. matName)
end


function ENT:GetImageMaterial()
	local materials = self:GetMaterials()
	local imgMaterial = 0
	for index, material in ipairs(materials) do
		if material == "models/tptsa/punching_ball/img" then
			imgMaterial = index
		end
	end
	return imgMaterial
end