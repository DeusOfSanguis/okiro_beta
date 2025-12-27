include('shared.lua')

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()

	if string.len(string.Trim("Racheteur d'Item")) < 1 then return end

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 400 then
		local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 500.0)
		alpha = math.Clamp(1.25 - alpha, 0 ,1)
		local a = Angle(0,0,0) 
		a:RotateAroundAxis(Vector(1,0,0),90) 
		a.y = LocalPlayer():GetAngles().y - 90 

		cam.Start3D2D(self:GetPos() + Vector(0,0,80), a , 0.08) 
			draw.RoundedBox(0,-200,-75,400,75 , Color( 8, 18, 33, 150))
			surface.SetDrawColor(Color(219, 227, 255, 255))
			surface.DrawOutlinedRect(-200,-75,400,75, 1)
			draw.SimpleText("Racheteur d'items","MNew_Font1",0,-40, Color(219, 227, 255, 255), 1 , 1) 
		cam.End3D2D() 
	end
end