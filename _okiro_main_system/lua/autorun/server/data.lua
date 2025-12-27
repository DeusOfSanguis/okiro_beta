local Player = FindMetaTable("Player")
function Player:Mad_TakeStam( n )
    local stam = self:GetNWInt("mad_stamina")
    if stam > n then
        self:SetNWInt("mad_stamina", stam-n)
    end
end

local dev = 0

timer.Create("SL_STAM_Mad.TIMER", 2, 0, function()
	for i, v in ipairs(player.GetAll()) do
		if not v:GetNWInt("mad_stamina") then 
			print("ERREUR: mad_stamina non défini pour le joueur " .. v:Nick())
			continue
		end

		if not v:GetNWInt("mana") then 
			print("ERREUR: mana non défini pour le joueur " .. v:Nick())
			continue
		end

		if not v:GetNWInt("regene") then 
			print("ERREUR: regene non défini pour le joueur " .. v:Nick())
			continue
		end

		if v:GetNWInt("mad_stamina") < v:GetNWInt("mana") then
			local regenerationRate = 0
			
			if dev == 1 then
				regenerationRate = v:GetNWInt("mana") / 5
			else
				regenerationRate = v:GetNWInt("mana") / 40
			end

			if regenerationRate < 1 then regenerationRate = 1 end

			local newValue = v:GetNWInt("mad_stamina") + regenerationRate

			if newValue > v:GetNWInt("mana") then
				v:SetNWInt("mad_stamina", v:GetNWInt("mana"))
			else
				v:SetNWInt("mad_stamina", newValue)
			end
		end
	end
end)