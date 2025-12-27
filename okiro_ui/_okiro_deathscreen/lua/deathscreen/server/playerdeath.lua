util.AddNetworkString("PlayDeathSound")

hook.Add("PlayerDeath", "DeathScreen:Hook:PlayerDeathScreen", function(ply, inflictor, attacker)
	net.Start("DeathScreen:Net:OpenInteractionMenu")
	net.Send(ply)
end)


hook.Add("PlayerDeath", "PlayDeathSoundOnDeath", function(victim, inflictor, attacker)
    if IsValid(victim) and victim:IsPlayer() then
        net.Start("PlayDeathSound")
        net.Send(victim)
    end
end)

hook.Add("PlayerSpawn", "DeathScreen:Hook:PlayerSpawn", function(ply, inflictor, attacker)
    timer.Simple(1, function()
        for k, v in pairs(ply.sl_data) do
            if ply.sl_data5[k] and ply.sl_data5[k] >= 1 then
                if INV_SL[k].type == "arme" then
                    ply.EquipWeapon = true
                    ply:SetNWInt("EquipWeapon", true)
                    ply:Give(INV_SL[k].swep) -- Donne l'arme au joueur
                elseif INV_SL[k].type == "armure" then
                    ply.EquipArmure = true
                    ply:SetNWInt("EquipArmure", true)
                    if ply:GetNWString("PMPERSO") != "RIEN" then
                        ply:SetModel(ply:GetNWString("PMPERSO"))
                    else
                        if ply:GetNWInt("Genre") == "male" then
                            ply:SetModel(INV_SL[k].playermodel_male)
                        else
                            ply:SetModel(INV_SL[k].playermodel_female)
                        end
                    end
                    ply:SetHealth(ply:Health() + INV_SL[k].boost_hp) -- Ajoute le bonus de vie
                    ply:SetMaxHealth(ply:GetMaxHealth() + INV_SL[k].boost_hp)
                end
            end
        end
    end)
end)