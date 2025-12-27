include('shared.lua')

local rotationAngle = 0
local crystalSizeX = 100  -- Nouvelle largeur du cristal
local crystalSizeY = 213  -- Nouvelle hauteur du cristal

function ENT:Initialize()
    -- Initialize doesn't need any changes for now.
end

function ENT:Draw()
    self:DrawModel()

    if LocalPlayer():GetPos():Distance(self:GetPos()) < 400 then
        local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 500.0)
        alpha = math.Clamp(1.25 - alpha, 0, 1)
        
        -- Update the rotation angle based on time
        rotationAngle = (CurTime() * 50) % 360
        
        -- Create rotation angles for both crystals
        local angle1 = Angle(0, rotationAngle, 90)
        local angle2 = Angle(0, rotationAngle + 180, 90) -- Opposite angle
        
        -- Adjust the position to lower the crystals
        local crystalPos1 = self:GetPos() + Vector(0, 0, 10)
        local crystalPos2 = self:GetPos() + Vector(0, 0, 10) -- Same height, different angle

        cam.Start3D2D(crystalPos1, angle1, 0.08)

			draw.SimpleText("Appuyez [E] pour récupérer","DermaLarge",0,-150, white , 1 , 1) 

            -- Draw the first rotating image
            surface.SetDrawColor(255, 255, 255, 255 * alpha)
            if self:GetNWInt("item") == "crystal" then
                surface.SetMaterial(Material("mad_sololeveling/crystal.png"))
            elseif self:GetNWInt("item") == "crystal2" then
                surface.SetMaterial(Material("mad_sololeveling/crystal2.png"))
            elseif self:GetNWInt("item") == "crystal3" then
                surface.SetMaterial(Material("mad_sololeveling/crystal3.png"))
            elseif self:GetNWInt("item") == "crystal4" then
                surface.SetMaterial(Material("mad_sololeveling/crystal4.png"))
            elseif self:GetNWInt("item") == "minerai" then
                surface.SetMaterial(Material("mad_sololeveling/minerai.png"))
            end
            local centerX, centerY = 0, 0
            surface.DrawTexturedRectRotated(centerX, centerY, crystalSizeX, crystalSizeY, 0)
        cam.End3D2D()

        cam.Start3D2D(crystalPos2, angle2, 0.08)

			draw.SimpleText("Appuyez [E] pour recupérer","DermaLarge",0,-150, white , 1 , 1) 

            -- Draw the second rotating image in the opposite direction
            surface.SetDrawColor(255, 255, 255, 255 * alpha)
            if self:GetNWInt("item") == "crystal" then
                surface.SetMaterial(Material("mad_sololeveling/crystal.png"))
            elseif self:GetNWInt("item") == "crystal2" then
                surface.SetMaterial(Material("mad_sololeveling/crystal2.png"))
            elseif self:GetNWInt("item") == "crystal3" then
                surface.SetMaterial(Material("mad_sololeveling/crystal3.png"))
            elseif self:GetNWInt("item") == "crystal4" then
                surface.SetMaterial(Material("mad_sololeveling/crystal4.png"))
            elseif self:GetNWInt("item") == "minerai" then
                surface.SetMaterial(Material("mad_sololeveling/minerai.png"))
            end
            surface.DrawTexturedRectRotated(centerX, centerY, crystalSizeX, crystalSizeY, 0)
        cam.End3D2D()
    end
end
