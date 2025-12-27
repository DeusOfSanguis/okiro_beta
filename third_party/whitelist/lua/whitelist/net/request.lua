net.Receive("Okiro:Whitelist:RequestWlList", function(len, ply)
	if not IsValid(ply) or not ply:Alive() or not ply:IsSuperAdmin() then return end

	gQuerySelect("okiro_wl", nil, nil, function(data, err)
		if err then
			MsgC(OKIRO.SQL.COLORS.ERROR, "[Okiro Whitelist] Erreur SQL : " .. tostring(err) .. "\n")
			return
		end

		net.Start("Okiro:Whitelist:SendWlList")
			net.WriteString(util.TableToJSON(data or {}))
		net.Send(ply)
	end)
end)