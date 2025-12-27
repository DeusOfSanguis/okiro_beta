hook.Add("PrePACConfigApply", "donators only", function(ply, outfit_data)
	if not ply:IsAdmin() then
		return false, "PAC3 INTERDIT!"
	end
end)