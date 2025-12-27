util.AddNetworkString("DeathScreen:Net:OpenInteractionMenu")
util.AddNetworkString("DeathScreen:Net:RequestRespawn")

net.Receive("DeathScreen:Net:RequestRespawn", function(len, ply)
	if not IsValid(ply) or ply:Alive() then return end
	ply:Spawn()
end)