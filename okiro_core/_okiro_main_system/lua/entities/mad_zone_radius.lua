AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.Spawnable = false
ENT.Author = "Zelrows"
ENT.Category = "Origine Guild System"

function ENT:Initialize()
    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
    
        local phys = self:GetPhysicsObject()
        if (phys:IsValid()) then
            phys:Wake()
        end
    end
end

function DrawStencil(fcMask, fcRender,nouveau,bool)
    if nouveau == nil then
		if not isfunction(fcMask) or not isfunction(fcRender) then return end
		render.ClearStencil()
		render.SetStencilEnable( true )
	
		render.SetStencilWriteMask( 1 )
		render.SetStencilTestMask( 1 )
	
		render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
		render.SetStencilPassOperation( STENCILOPERATION_ZERO )
		render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_NEVER )
		render.SetStencilReferenceValue( 1 )
	
		fcMask()
	
		render.SetStencilFailOperation( STENCILOPERATION_ZERO )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilZFailOperation( STENCILOPERATION_ZERO )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		render.SetStencilReferenceValue( 1 )
	
		fcRender()
	
		render.SetStencilEnable( false )
		render.ClearStencil()
	else
		if not isfunction(fcMask) or not isfunction(fcRender) then return end
		render.ClearStencil()
		render.SetStencilEnable(true)
	  
		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)
	  
		render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
		render.SetStencilPassOperation(bool and STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
		render.SetStencilReferenceValue(1)
	  
		fcMask()
	  
		render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
		render.SetStencilPassOperation(bool and STENCILOPERATION_REPLACE or STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		render.SetStencilReferenceValue(bool and 0 or 1)
	  
		fcRender(self, w, h)
	  
		render.SetStencilEnable(false)
		render.ClearStencil()
	end
end

local  function DrawCircle(x, y, radius, angle_start, angle_end, color)
    local poly = {}
    angle_start = angle_start or 0
    angle_end   = angle_end   or 360
    
    poly[1] = { x = x, y = y }
    for i = math.min( angle_start, angle_end ), math.max( angle_start, angle_end ) do
        local a = math.rad( i )
        if angle_start < 0 then
            poly[#poly + 1] = { x = x + math.cos( a ) * radius, y = y + math.sin( a ) * radius }
        else
            poly[#poly + 1] = { x = x - math.cos( a ) * radius, y = y - math.sin( a ) * radius }
        end
    end
    poly[#poly + 1] = { x = x, y = y }

    draw.NoTexture()
    surface.SetDrawColor( color or color_white )
    surface.DrawPoly( poly )

    return poly
end

function ENT:Draw()
    self:DrawModel()

    local pos = self:GetPos() - Vector(0, 0, -2)
    local ang = self:GetAngles()

    local barOffset = Vector(0, 0, 0)   

    cam.Start3D2D(pos, ang, .1)
        DrawStencil(function()
            DrawCircle(0, 0, self:GetNWInt("Radius") * 9.5/10, 0, 360, Color(255,0,0) )
        end,
        function()
            DrawCircle(0, 0, self:GetNWInt("Radius"), 0, 360, Color(255,0,0) )
        end, true, true)
    cam.End3D2D()
end

if CLIENT then 

else

end