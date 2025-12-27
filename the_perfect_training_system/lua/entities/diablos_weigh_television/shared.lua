ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "Weigh Television"
ENT.Category		= "Diablos Addon"
ENT.Instructions	= ""
ENT.Spawnable		= true


function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "ActivePlayer")
end
