local function BlockUserKillCommand(ply)
	if not ply:IsAdmin() then
		ply:ChatPrint("Vous ne pouvez pas vous suicidez.")
		ply:EmitSound( "buttons/combine_button_locked.wav")
		return false
	end
end
hook.Add( "CanPlayerSuicide", "DisableKillCommandForUser", BlockUserKillCommand )