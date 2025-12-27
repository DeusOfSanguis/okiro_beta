/*---------------------------------------------------------------------------
	Load the files
---------------------------------------------------------------------------*/

local function LoadDirectory(path, side)
	for _, fileToImport in ipairs(file.Find(path .. "*.lua", "LUA")) do
		local entireFilePath = path .. fileToImport
		if side == "shared" then
			if SERVER then
				AddCSLuaFile(entireFilePath)
			end
			include(entireFilePath)
		elseif side == "client" then
			if SERVER then
				AddCSLuaFile(entireFilePath)
			elseif CLIENT then
				include(entireFilePath)
			end
		elseif side == "server" then
			if SERVER then
				include(entireFilePath)
			end
		end
	end
end

LoadDirectory("diablos_training/init/", "shared") -- initialize variables
LoadDirectory("diablos_training/languages/", "shared")
LoadDirectory("config/", "shared") -- config file
LoadDirectory("diablos_training/client/", "client")
LoadDirectory("diablos_training/vgui/", "client")
LoadDirectory("diablos_training/shared/", "shared")
LoadDirectory("diablos_training/server/", "server")
LoadDirectory("diablos_training/data/", "server")

Diablos.TS:ConsoleMsg(0, "--- Training system is properly loaded ---")