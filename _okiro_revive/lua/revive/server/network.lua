util.AddNetworkString("Revive:Net:RequestRevive")
util.AddNetworkString("Revive:Net:OpenInteractionMenu")

net.Receive("Revive:Net:RequestRevive", function(_, ply)
	local ragdoll = net.ReadEntity() 
	local target = ragdoll:GetNWEntity("Revive:Ent:Player")

	if not IsValid(target) then return end
	if not target:IsPlayer() then return end
	if ply:GetPos():Distance(ragdoll:GetPos()) > 100 then return end
	if not ragdoll:GetNWBool("Revive:Ent:CanInteract", true) then return end

	ragdoll:SetNWBool("Revive:Ent:CanInteract", false)

	RevivePlayer(target, ragdoll)
end)