local function PlayerDeath(victim, weapon, killer)
	if LevelSystemConfiguration.KillModule and victim ~= killer and killer:IsPlayer() then
		local victime = victim:Nick()
		local money = DarkRP.formatMoney(LevelSystemConfiguration.TakeAwayMoneyAmount)
		local XP = 0

		killer:addMoney(LevelSystemConfiguration.TakeAwayMoneyAmount)
		net.Start("SL:Notification")
		net.WriteString("Vous avez reçu " .. XP .. " XP et " .. money .. " ₩ pour avoir tué " .. victime .. ".")
		net.Send(killer)

		if guthlogsystem then
			guthlogsystem.addLog("DarkRP Leveling System", "*" .. killer:Name() .. "* got &" .. XP .. "& XP and &" .. money .. "& for killing ?" .. victime .. "?")
		end

		if victim:canAfford(LevelSystemConfiguration.TakeAwayMoneyAmount) then
			victim:addMoney(-LevelSystemConfiguration.TakeAwayMoneyAmount)
			net.Start("SL:Notification")
			net.WriteString("Vous êtes tombé au combat, vous avez perdu " .. money .. " ₩.")
			net.Send(victim)
		end
	end
end

hook.Add( "PlayerDeath", "manolis:MVLevels:PlayerDeathBC", PlayerDeath )


local function NPCDeath(npc, killer,weapon)
	if (LevelSystemConfiguration.NPCXP) then
		if (npc != killer) then 
			if (killer:IsPlayer()) then
				local XP = killer:addXP(npc:GetVar("GiveXP") or LevelSystemConfiguration.NPCXPAmount, true)
				if (XP) then
                    if guthlogsystem then
						guthlogsystem.addLog( "DarkRP Leveling System", "*"..killer:Name().."* got &"..XP.."& XP for killing an NPC" )
                    end
				end
			end
		end
	end
end

hook.Add( "OnNPCKilled", "manolis:MVLevels:OnNPCKilledBC", NPCDeath )


if (LevelSystemConfiguration.BoughtXP) then
	local function BoughtXP(ply, ent, price)
		local XP = 0.1 * ent.price
		ply:addXP(XP, true)
		if guthlogsystem then
			guthlogsystem.addLog( "DarkRP Leveling System", "*"..ply:Name().."* got &"..XP.."& XP for buying ?"..ent.name.."?" )
		end
	end
	
	hook.Add("playerBoughtPistol", "manolis:MVLevels:PistolBought", BoughtXP)
	hook.Add("playerBoughtAmmo", "manolis:MVLevels:AmmoBought", BoughtXP)
	hook.Add("playerBoughtShipment", "manolis:MVLevels:ShipmentBought", BoughtXP)
	hook.Add("playerBoughtCustomEntity", "manolis:MVLevels:CEntityBought", BoughtXP)
end


local time = LevelSystemConfiguration.Timertime
timer.Create( "PlayXP", time,0,function()
	if (LevelSystemConfiguration.TimerModule) then
		for k,v in pairs(player.GetAll()) do
			if IsValid(GetConVar("aafk_enabled")) and GetConVar("aafk_enabled"):GetBool() == true then
				if v:GetNWBool( "aafk_away" ) == false then
					if table.HasValue(LevelSystemConfiguration.TimerXPVipGroups, v:GetNWString("usergroup")) then
						local XP = v:addXP(LevelSystemConfiguration.TimerXPAmountVip, true)
					else
						local XP = v:addXP(LevelSystemConfiguration.TimerXPAmount, true)
					end
				end
			else
				if table.HasValue(LevelSystemConfiguration.TimerXPVipGroups, v:GetNWString("usergroup")) then
					local XP = v:addXP(LevelSystemConfiguration.TimerXPAmountVip, true)
				else
					local XP = v:addXP(LevelSystemConfiguration.TimerXPAmount, true)
				end
			end
		end
		if guthlogsystem then
			guthlogsystem.addLog( "DarkRP Leveling System", "*Everyone* got &"..LevelSystemConfiguration.TimerXPAmount.."& or !"..LevelSystemConfiguration.TimerXPAmountVip.."! XP depending of their rank" )
		end
	end
end)