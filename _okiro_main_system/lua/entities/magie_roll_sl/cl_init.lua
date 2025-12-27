include('shared.lua')

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()

	if string.len(string.Trim("Magie - Bibliothécaire")) < 1 then return end

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 400 then
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 500.0)
		alpha = math.Clamp(1.25 - alpha, 0 ,1)
		local a = Angle(0,0,0) 
		a:RotateAroundAxis(Vector(1,0,0),90) 
		a.y = LocalPlayer():GetAngles().y - 90 

		cam.Start3D2D(self:GetPos() + Vector(0,0,80), a , 0.08) 
			draw.RoundedBox(8,-200,-75,400,75 , Color(25,25,25,255 * alpha)) 
			local tri = {{x = -25 , y = 0},{x = 25 , y = 0},{x = 0 , y = 25}} 
			surface.SetDrawColor(Color(25,25,25,255 * alpha)) 
			draw.NoTexture() 
			surface.DrawPoly( tri ) 
			draw.SimpleText("Magie - Bibliothécaire","DermaLarge",0,-40, white , 1 , 1) 
		cam.End3D2D() 
	end
end