--[[--------------------------------------------
                Hunger Stop
             System DarkRP Only
          Script Created By Driven
----------------------------------------------]]

 -- Table of cook players
local HS_CookPlayers = HS_CookPlayers or {}

-- Check if team is cook or not
local function HS_IsCookTeam(pTeam)
	if istable(RPExtraTeams) and RPExtraTeams[pTeam] then
		if RPExtraTeams[pTeam].cook then
			if tonumber(RPExtraTeams[pTeam].admin or 0) == 0 then
				return true
			end
		end
	end

	return false
end

-- Check the player if must starve or not
local function HS_IsRunHunger(ply)
	if not IsValid(ply) then return true end

	local countCook = table.Count(HS_CookPlayers)
	local isStarved = hook.Run("PlayerCanStarving", ply, countCook)
	
	if isbool(isStarved) then return isStarved end
	if countCook == 0 then return false end

	if istable(RPExtraTeams) and RPExtraTeams[ply:Team()] then
		if tonumber(RPExtraTeams[ply:Team()].admin or 0) > 0 then
			return false
		end
	end

	return true
end

-- Player switch team
hook.Add("OnPlayerChangedTeam", "HungerStop.OnPlayerChangedTeam", function(ply, oldTeam, newTeam)
	if HS_IsCookTeam(newTeam) then
		HS_CookPlayers[ply] = true
	else
		HS_CookPlayers[ply] = nil
	end
end)

-- Player first connect
hook.Add("PlayerInitialSpawn", "HungerStop.PlayerInitialSpawn", function(ply)
	if HS_IsCookTeam(ply:Team()) then
		HS_CookPlayers[ply] = true
	end
end)

-- Player disconnect
hook.Add("PlayerDisconnected", "HungerStop.PlayerDisconnected", function(ply)
	HS_CookPlayers[ply] = nil
end)

-- Hunger system
hook.Add("PostGamemodeLoaded", "HungerStop.PostGamemodeLoaded", function()
	-- DarkRP Version >= 2.6.2
	if timer.Exists("HMThink") then
		hook.Add("hungerUpdate", "HungerStop.hungerUpdate", function(ply, energy)
			if not HS_IsRunHunger(ply) then
				return true
			end
		end)
		return
	end

	local HookTable = hook.GetTable()

	if istable(HookTable) and istable(HookTable["Think"]) then
		-- DarkRP Version >= 2.5.1
		if isfunction(HookTable["Think"]["HMThink"]) then
			hook.Remove("Think", "HMThink")
			hook.Add("Think", "HMThink", function()
				if not GAMEMODE.Config.hungerspeed then return end

				for k, v in pairs(player.GetAll()) do
					if HS_IsRunHunger(v) then
						if v:Alive() and (not v.LastHungerUpdate or CurTime() - v.LastHungerUpdate > 10) then
							v:hungerUpdate()
						end
					end
				end
			end)
			return
		end

		-- DarkRP Version >= 2.4.3 
		if isfunction(HookTable["Think"]["HM.Think"]) then
			hook.Remove("Think", "HM.Think")
			hook.Add("Think", "HM.Think", function()
				if not GAMEMODE.Config.hungerspeed then return end

				for k, v in pairs(player.GetAll()) do
					if HS_IsRunHunger(v) then
						if v:Alive() and (not v.LastHungerUpdate or CurTime() - v.LastHungerUpdate > 1) then
							v:HungerUpdate()
						end
					end
				end
			end)
			return
		end
	end
end)

-- Refresh LUA
if istable(RPExtraTeams) then
	for _, v in ipairs(player.GetAll()) do
		if HS_IsCookTeam(v:Team()) then
			HS_CookPlayers[v] = true
		end
	end
end

MsgN("[Hunger Stop] System Loaded")