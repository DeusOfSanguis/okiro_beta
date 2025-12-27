include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	CreateMaterial( "Diablos:TS:EmptyNFCIco", "VertexLitGeneric", {
		["$basetexture"] = "color/green",
		["$model"] = 1,
		["$translucent"] = 1,
		["$vertexalpha"] = 1,
		["$vertexcolor"] = 1
	} )
end

