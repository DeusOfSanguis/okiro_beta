function CreateCustomRagdoll(ply)
	local ragdoll = ents.Create("prop_ragdoll")
	ragdoll:SetPos(ply:GetPos())
	ragdoll:SetAngles(ply:GetAngles())
	ragdoll:SetModel(ply:GetModel())
	ragdoll:Spawn()
	ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	ragdoll:SetNWEntity("Revive:Ent:Player", ply)

	return ragdoll
end

function RemoveDefaultRagdoll(ply)
	timer.Simple(0, function()
		if IsValid(ply:GetRagdollEntity()) then
			ply:GetRagdollEntity():Remove()
		end
	end)
end

function RevivePlayer(ply, ragdoll)
	if not IsValid(ply) or not IsValid(ragdoll) then return end

	ply:Spawn()
	ply:SetPos(ragdoll:GetPos())
	ply:SetHealth(ply:GetMaxHealth() * 0.1)
	ragdoll:Remove()
	ply:SetNWEntity("Revive:Ent:DeathRagdoll", nil)
end

hook.Add("PlayerDeath", "Revive:Hook:CreateCustomRagdoll", function(ply)
	RemoveDefaultRagdoll(ply)
	local ragdoll = CreateCustomRagdoll(ply)
	ply:SetNWEntity("Revive:Ent:DeathRagdoll", ragdoll)
end)

hook.Add("PlayerSpawn", "Revive:Hook:HandlePlayerSpawn", function(ply)
	local ragdoll = ply:GetNWEntity("Revive:Ent:DeathRagdoll")
	if IsValid(ragdoll) and ply:Alive() then
		ragdoll:Remove()
		ply:SetNWEntity("Revive:Ent:DeathRagdoll", nil)
	end
end)

hook.Add("PlayerUse", "Revive:Hook:CorpseInteraction", function(ply, ent)
	if IsValid(ent) and ent:GetClass() == "prop_ragdoll" and ent:GetNWEntity("Revive:Ent:Player") then
		net.Start("Revive:Net:OpenInteractionMenu")
		net.WriteEntity(ent)
		net.Send(ply)
		return true
	end
end)