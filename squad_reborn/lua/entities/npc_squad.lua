ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = false
ENT.PrintName = "Squad creator"
ENT.Author = "Gonzo"
ENT.Category = "Fun + Games"
ENT.Spawnable = true
ENT.AdminOnly = true
AddCSLuaFile()

function ENT:Initialize()
	self:SetModel("models/player/police_fem.mdl")

	if SERVER then
		self:SetHullType(HULL_HUMAN)
		self:SetHullSizeNormal()
		self:SetNPCState(NPC_STATE_SCRIPT)
		self:SetSolid(SOLID_BBOX)
		self:CapabilitiesAdd(CAP_ANIMATEDFACE)
		self:CapabilitiesAdd(CAP_TURN_HEAD)
		self:SetUseType(SIMPLE_USE)
		self:DropToFloor()
		self:SetMaxYawSpeed(90)
		local sequence = self:LookupSequence("menu_combine")
		self:ResetSequence(sequence)
	end
end

function ENT:Think()
	if SERVER then
		self:ResetSequence("menu_combine")
		self:NextThink(CurTime() + 1)

		return true
	end
end

if SERVER then
	util.AddNetworkString("OpenSquadMenu")
end

function ENT:AcceptInput(Name , Activator , Caller)
	if Name == "Use" and Caller:IsPlayer() then
		net.Start("OpenSquadMenu")
		net.Send(Caller)
	end
end

concommand.Add("squad_save_npcs" , function(ply)
	if (SERVER) then
		local tbl = { }

		if (file.Exists(game.GetMap() .. "_squad.txt" , "DATA")) then
			tbl = util.JSONToTable(file.Read(game.GetMap() .. "_squad.txt" , "DATA"))
		end

		for k , v in pairs(ents.FindByClass("npc_squad")) do
			table.insert(tbl , { v:GetPos() , v:GetAngles() })
		end

		file.Write(game.GetMap() .. "_squad.txt" , util.TableToJSON(tbl , true))
	end
end)

hook.Add("InitPostEntity" , "CreateSquadMembers" , function()
	if CLIENT then return end
	local tbl = { }

	if (file.Exists(game.GetMap() .. "_squad.txt" , "DATA")) then
		tbl = util.JSONToTable(file.Read(game.GetMap() .. "_squad.txt" , "DATA"))
	end

	for k , v in pairs(tbl) do
		local ent = ents.Create("npc_squad")
		ent:SetPos(v[ 1 ])
		ent:SetAngles(v[ 2 ])
		ent:Spawn()
	end
end)

net.Receive("OpenSquadMenu" , function()
	if (IsValid(squad_window)) then
		squad_window:GetParent():Remove()
	end

	squad_window_frame = vgui.Create("DFrame")
	squad_window_frame:SetSize(600,500)
	squad_window_frame:Center()
	squad_window_frame:MakePopup()

	if (LocalPlayer()._squad ~= "") then
		squad_window = vgui.Create("dSquadPanel" , squad_window_frame)
	else
		squad_window_frame.Paint = function() end
		net.Start("Squad.Verify")
		net.WriteString(LocalPlayer()._squad or "")
		net.SendToServer()
	end
end)
