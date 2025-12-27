include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	self.IconChanged = false
	if not self.IconChanged then
		if Diablos.TS.Materials["PunchingLogoName"] then
			self:SetLogoMaterial()
			self.IconChanged = true
		end
	end
end