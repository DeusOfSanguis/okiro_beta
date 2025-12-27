include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local ply = LocalPlayer()

	if ply:GetPos():DistToSqr(self:GetPos()) > Diablos.TS.Optimization * 500 then return end

	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)

	local activePly = self:GetActivePlayer()

	cam.Start3D2D(self:GetPos() + self:GetUp() * 12.2 + self:GetRight() * -22.2 + self:GetForward() * -0.5, ang, .05)
		local w = 890
		local h = 495
		surface.SetDrawColor(color_white) surface.DrawRect(0, 0, w, h)

		local SIZE_MATERIAL = 100

		surface.SetDrawColor(color_white)

		surface.SetMaterial(Diablos.TS.Materials.attackSpeed)
		surface.DrawTexturedRect(w - SIZE_MATERIAL - 5, 5, SIZE_MATERIAL, SIZE_MATERIAL)

		surface.SetMaterial(Diablos.TS.Materials.treadmill)
		surface.DrawTexturedRect(5, h - SIZE_MATERIAL - 5, SIZE_MATERIAL, SIZE_MATERIAL)

		surface.SetMaterial(Diablos.TS.Materials.strength)
		surface.DrawTexturedRect(w - SIZE_MATERIAL - 5, h - SIZE_MATERIAL - 5, SIZE_MATERIAL, SIZE_MATERIAL)


		if Diablos.TS.Materials["GUILogoName"] then
			surface.SetDrawColor(color_white)
			surface.SetMaterial(Diablos.TS.Materials["GUILogo"])
			surface.DrawTexturedRect(5, 5, SIZE_MATERIAL, SIZE_MATERIAL)
		end


		if IsValid(activePly) then
			if activePly == ply then
				local useColor
				if ply.trainingDerma then
					useColor = color_black
				else
					useColor = Color(0, 0, 0, math.abs(math.cos(CurTime()) * 255))
				end

				local fontToUse = "Diablos:Font:TS:60"
				surface.SetFont(fontToUse)
				local sizex = surface.GetTextSize(Diablos.TS:GetLanguageString("weighBalanceUse"))
				if sizex > 900 then
					fontToUse = "Diablos:Font:TS:50"
				end

				draw.SimpleText(Diablos.TS:GetLanguageString("weighBalanceUse"), fontToUse, w / 2, h / 2, useColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText(Diablos.TS:GetLanguageString("weighBalanceCantSee"), "Diablos:Font:TS:60", w / 2, h / 2, Diablos.TS.Colors.bl, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		else
			draw.SimpleText(Diablos.TS:GetLanguageString("weighBalanceTipL1"), "Diablos:Font:TS:60", w / 2, h / 2 - h / 5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(Diablos.TS:GetLanguageString("weighBalanceTipL2"), "Diablos:Font:TS:60", w / 2, h / 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(Diablos.TS:GetLanguageString("weighBalanceTipL3"), "Diablos:Font:TS:60", w / 2, h / 2 + h / 5, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	cam.End3D2D()
end

function ENT:DrawTranslucent()

end