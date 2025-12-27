ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "Training Card Reader"
ENT.Category		= "Diablos Addon"
ENT.Instructions	= ""
ENT.Spawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "TrainingID")
	self:NetworkVar("Entity", 0, "SportOwner")
end