ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "Dumbbell"
ENT.Category		= "Diablos Addon"
ENT.Instructions	= ""
ENT.Spawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "TrainingID")
end

function ENT:GetWeightBodygroup()
	return self:FindBodygroupByName("weight")
end

function ENT:GetWeight()
	return self:GetBodygroup(self:GetWeightBodygroup()) + 1
end

function ENT:SetWeight(newWeight)
	self:SetBodygroup(self:GetWeightBodygroup(), newWeight - 1)
end

function ENT:GetLevel()
	return self:GetWeight()
end
