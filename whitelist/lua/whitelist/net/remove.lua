net.Receive("Okiro:Whitelist:RemoveFromWhitelist", function(len, ply)
	if not IsValid(ply) or not ply:IsSuperAdmin() then return end

	local steamid = net.ReadString()

	gQueryDelete("okiro_wl", {
		steamid = steamid
	}, function(success, err)
		if err then
			net.Start("Okiro:Whitelist:NotifyError")
				net.WriteString("Erreur lors de la suppression : " .. tostring(err))
			net.Send(ply)
			return
		end

		net.Start("Okiro:Whitelist:NotifySuccess")
			net.WriteString("SteamID supprimé avec succès !")
		net.Send(ply)

		gQuerySelect("okiro_wl", nil, nil, function(data)
			local targets = {}
			for _, player in pairs(player.GetAll()) do
				if IsValid(player) and player:IsSuperAdmin() then
					table.insert(targets, player)
				end
			end

			if #targets > 0 then
				net.Start("Okiro:Whitelist:SendWlList")
					net.WriteString(util.TableToJSON(data or {}))
				net.Send(targets)
			end
		end)
	end)
end)