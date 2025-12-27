include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if Diablos.TS.Materials["TreadmillMat"] then
		self:SetTreadmillMaterial(self:GetTrainingSpeed())
	end

	local ply = LocalPlayer()
	local CUR_DIST = ply:GetPos():DistToSqr(self:GetPos())

	if CUR_DIST > Diablos.TS.Optimization * 100 then return end

	local curtime = CurTime()

	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)

	local w = 600
	local h = 355
	local lineY = 60

	cam.Start3D2D(self:GetPos() + self:GetUp() * 63.3 + self:GetRight() * 15 + self:GetForward() * -44.1, ang + Angle(0, 0, -16), .05)

		surface.SetDrawColor(Diablos.TS.Colors.gl) surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(color_white) surface.DrawRect(10, 10, w - 20, h - 20)

		-- Lines
		surface.SetDrawColor(color_black)
		surface.DrawRect(50, lineY, w - 100, 3)
		surface.DrawRect(50, h - lineY - 3, w - 100, 3)

		local text
		if IsValid(self:GetTrainingPlayer()) then
			if self:GetTrainingPlayer() == ply then
				local timeRemaining = math.floor(ply.EndTraining - curtime)
				text = string.format(Diablos.TS:GetLanguageString("treadmillDrawLeft"), timeRemaining)
			else
				text = Diablos.TS:GetLanguageString("treadmillDrawSomeone")
			end
		else
			text = Diablos.TS:GetLanguageString("treadmillDrawCanUse")
		end
		draw.SimpleText(text, "Diablos:Font:TS:45", w / 2, 80, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(Diablos.TS.Materials.treadmillOrientation)
		local SIZE_MATERIAL = 100
		surface.DrawTexturedRect(w / 2 - SIZE_MATERIAL - 5, h - 80 - SIZE_MATERIAL, SIZE_MATERIAL, SIZE_MATERIAL)

		local orientation = self:GetAngle()
		local tab = Diablos.TS.TreadmillSizeEquivalence[orientation]
		draw.SimpleText(string.format("%u°", tab.angle), "Diablos:Font:TS:80", w / 2 + SIZE_MATERIAL, h - 80 - SIZE_MATERIAL / 2, color_black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	cam.End3D2D()
end