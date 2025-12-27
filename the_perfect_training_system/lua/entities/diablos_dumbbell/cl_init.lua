include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local ply = LocalPlayer()

	if ply:GetPos():DistToSqr(self:GetPos()) > Diablos.TS.Optimization * 100 then return end

	local ang = Angle(0, 90, 90)

	local pos = self:GetPos()

	local weightDumbbell = self:GetWeight()
	local sizeDumbbell = Diablos.TS.DumbbellSizeEquivalence[weightDumbbell]

	local sizeX, sizeH = 500, 150
	local relativePos = math.sin(CurTime()) * 70

	local weightValue = sizeDumbbell.kg
	if Diablos.TS.IsLbs then
		weightValue = sizeDumbbell.lbs
	end

	cam.Start3D2D(pos + Vector(0, -12.5, 35), ang, .05)

		surface.SetDrawColor(Diablos.TS.Colors.drawColor)
		surface.DrawRect(0, 0 + relativePos, sizeX, sizeH)

		draw.SimpleText(Diablos.TS:GetLanguageString("dumbbellDraw"), "Diablos:Font:TS:60", sizeX / 2, 10 + relativePos, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		draw.SimpleText(string.format("%4.2f %s", weightValue, Diablos.TS:GetWeightText()), "Diablos:Font:TS:45:I", sizeX / 2, sizeH - 10 + relativePos, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	cam.End3D2D()


	ang:RotateAroundAxis(ang:Right(), 180)

	cam.Start3D2D(pos + Vector(0, 12.5, 35), ang, .05)

		draw.SimpleText(Diablos.TS:GetLanguageString("dumbbellDraw"), "Diablos:Font:TS:60", sizeX / 2, 10 + relativePos, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

		draw.SimpleText(string.format("%4.2f %s", weightValue, Diablos.TS:GetWeightText()), "Diablos:Font:TS:45:I", sizeX / 2, sizeH - 10 + relativePos, Diablos.TS.Colors.Label, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	cam.End3D2D()
end

function ENT:DrawTranslucent()
	self:Draw()
end