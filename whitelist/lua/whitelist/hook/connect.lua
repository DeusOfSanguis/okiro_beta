gameevent.Listen("player_connect")

hook.Add("player_connect", "Okiro:Whitelist:Connect", function(data)
	local playerCount = player.GetCount()
	local enableWhitelist = playerCount > 120

	if not OKIRO.WHITELIST.Enable or not enableWhitelist then return end

	local steamid = util.SteamIDTo64(data.networkid)

	if OKIRO.WHITELIST.Steamid then
		for _, whitelistedID in ipairs(OKIRO.WHITELIST.Steamid) do
			if steamid == whitelistedID then
				MsgC(OKIRO.SQL.COLORS.SUCCESS, "[Okiro Whitelist] Joueur accepté via config : " .. data.name .. " (" .. data.networkid .. ")\n")
				return
			end
		end
	end

	gQuerySelect("okiro_wl", {"steamid"}, {steamid = steamid}, function(whitelistResult, err)
		if err then
			MsgC(OKIRO.SQL.COLORS.ERROR, "[Okiro Whitelist] Erreur SQL: " .. tostring(err) .. "\n")
			game.KickID(data.userid, "Erreur lors de la vérification de la whitelist")
			return
		end

		if not whitelistResult or #whitelistResult == 0 then
			MsgC(OKIRO.SQL.COLORS.WARNING, "[Okiro Whitelist] Joueur non whitelisté : " .. data.name .. " (" .. data.networkid .. ")\n")
			game.KickID(data.userid, "Vous n'êtes pas dans la whitelist")
			return
		end

		MsgC(OKIRO.SQL.COLORS.SUCCESS, "[Okiro Whitelist] Joueur accepté via base de données : " .. data.name .. " (" .. data.networkid .. ")\n")
	end)
end)