net.Receive("Okiro:Whitelist:AddToWhitelist", function(len, ply)
	if not IsValid(ply) or not ply:IsSuperAdmin() then return end

	local steamid = net.ReadString()
	local name = net.ReadString()

	gQuerySelect("okiro_wl", nil, {steamid = steamid}, function(existingData, err)
		if err then
			net.Start("Okiro:Whitelist:NotifyError")
				net.WriteString("Erreur lors de la vérification : " .. tostring(err))
			net.Send(ply)
			return
		end

		if existingData and #existingData > 0 then
			net.Start("Okiro:Whitelist:NotifyError")
				net.WriteString("Ce SteamID est déjà dans la whitelist !")
			net.Send(ply)
			return
		end

		gQueryInsert("okiro_wl", {
			steamid = steamid,
			name = name
		}, function(success, insertErr)
			if insertErr then
				net.Start("Okiro:Whitelist:NotifyError")
					net.WriteString("Erreur lors de l'ajout : " .. tostring(insertErr))
				net.Send(ply)
				return
			end

			net.Start("Okiro:Whitelist:NotifySuccess")
				net.WriteString("SteamID ajouté avec succès !")
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
end)