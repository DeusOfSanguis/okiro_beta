include("shared.lua")
AddCSLuaFile()

function SWEP:DrawHUD()

end

hook.Add("HUDPaint", "DrawBowCrosshair", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    
    local wep = ply:GetActiveWeapon()
    local bowtipe = wep.TypeArme
    if bowtipe != "bow" then return end 

    local x, y = ScrW() / 2, ScrH() / 2
    local size = 10
    surface.SetDrawColor(255, 255, 255, 200)
    surface.DrawCircle(x, y, size, 255, 255, 255, 200)
end)

if CLIENT then
    hook.Add("PreDrawHalos", "ArcherMarkHalo", function()
        local ply = LocalPlayer()
        local target = ply:GetNWEntity("MarkTarget")
        if IsValid(target) and target:GetNWBool("MarkArcher") then
            halo.Add({target}, Color(255, 0, 0), 2, 2, 2, true, true)
        end
    end)
end
