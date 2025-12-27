/*---------------------------------------------------------------------------
	Open the training panel
	Can be opened by choosing the "Admin panel" on the Training Manager toolgun
---------------------------------------------------------------------------*/

concommand.Add("training_open", function (ply, cmd, args)
	if not Diablos.TS:IsAdmin(ply) then return end

	local players = player.GetAll()
	net.Start("TPTSA:OpenAdminClientPanel")
		net.WriteUInt(#players, 8)
		for _, pl in ipairs(players) do
			net.WriteEntity(pl)
			Diablos.TS:WriteTrainingInfo(pl, true)
		end
	net.Send(ply)
end)