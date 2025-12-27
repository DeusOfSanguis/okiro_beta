TOOL.Category = "Diablos Tool"
TOOL.Name = "Training Manager"

if CLIENT then
	TOOL.Information = {
		{ name = "left" },
		{ name = "right" },
		{ name = "reload" },
	}
	language.Add("tool.training.name", "Training Manager")
	language.Add("tool.training.desc", "Create / edit training entity and access the admin panel.")
	language.Add("tool.training.left", "Select this option")
	language.Add("tool.training.right", "Switch between purposes")
	language.Add("tool.training.reload", "Return to the main toolscreen")
end

local level, max, typeEnt, edit, openPanel
local function ResetVars()
	level = 1
	max = 3
	typeEnt = 0
	edit = 0
	openPanel = 0
end
ResetVars()


function TOOL:LeftClick(trace)
	if not IsFirstTimePredicted() then return end
	local ply = self:GetOwner()
	if not Diablos.TS:IsAdmin(ply) then return end


	local stage = self:GetStage()
	if stage == 1 then 
		edit = level - 1 
		openPanel = level - 2 
		max = 6

		if openPanel == 1 then
			if SERVER then
				local players = player.GetAll()
				net.Start("TPTSA:OpenAdminClientPanel")
					net.WriteUInt(#players, 8)
					for _, pl in ipairs(players) do
						net.WriteEntity(pl)
						Diablos.TS:WriteTrainingInfo(pl, true)
					end
				net.Send(ply)
			end
			self:Reload(trace)
		else
			self:SetStage(stage + 1)
		end
	elseif stage == 2 then
		if edit != 1 and openPanel != 1 then
			typeEnt = level
			// self:SetStage(stage + 1)
			if SERVER then
				-- send data to save an entity
				net.Start("TPTSA:OpenAdminToolgunPanel")
					net.WriteEntity(nil)
					net.WriteUInt(typeEnt, 3)
				net.Send(ply)
			end
			self:Reload(trace)
		elseif edit == 1 then
			if SERVER then
				local ent = trace.Entity
				-- if ent:GetClass() == "diablos_punching_base" then ent = ent.punchingBall end
				if IsValid(ent) then
					if IsValid(ent.balance) then ent = ent.balance end -- Hitting the television instead of the balance
					if IsValid(ent.treadmill) then ent = ent.treadmill end -- Hitting the artificial floor instead of the "treadmill" main entity
					if IsValid(ent.turnstile) then ent = ent.turnstile end -- Hitting a turnstile button/trigger instead of the "turnstile" main entity
					if IsValid(ent.punchingBall) then ent = ent.punchingBall end -- Hitting the punching base instead of the punching ball

					if Diablos.TS:IsTrainingEntity(ent:GetClass()) then
						net.Start("TPTSA:OpenAdminToolgunPanel")
							net.WriteEntity(ent)
							net.WriteUInt(0, 3)
						net.Send(ply)
					end
				end
			end
			self:Reload(trace)
		end
	elseif stage == 3 then
		// if edit != 1 and openPanel != 1 then


	end

	return true
end


function TOOL:RightClick(trace)
	if not IsFirstTimePredicted() then return end
	level = level + 1
	if level > max then level = 1 end
	return false
end

function TOOL:Reload(trace)
	if not IsFirstTimePredicted() then return end
	ResetVars()
	self:SetStage(1)
	return false
end

function TOOL:Allowed() return Diablos.TS:IsAdmin(self:GetOwner()) end

function TOOL:Deploy() self:SetStage(1) end

local col = {
	b = Color(20, 20, 20, 255),
	grey = Color(100, 100, 100, 100),
	grey_light = Color(200, 200, 200, 100),
	w = Color(200, 200, 200, 255),
	r = Color(150, 0, 0, 100),
	r_light = Color(200, 30, 30, 110),
	g = Color(0, 150, 0, 100),
	g_light = Color(30, 200, 30, 110),
}


function TOOL:DrawToolScreen(width, height)

	surface.SetDrawColor(col.b)
	surface.DrawRect(0, 0, width, height)

	local stage = self:GetStage()

	local function ToolScreenTypes(...)
		local arg = {...}
		local SIZE_Y = 30
		local numInfos = #arg

		if numInfos == 6 then SIZE_Y = 25 end

		local function DrawText(numLevel, posY)

			if level == numLevel then surface.SetDrawColor(col.grey_light) else surface.SetDrawColor(col.grey) end
			surface.DrawRect(20, posY - SIZE_Y / 2, width - 40, SIZE_Y)
			draw.SimpleText(arg[numLevel], "Diablos:Font:TS:40", width / 2, posY, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end


		if numInfos == 2 then

			DrawText(1, height / 2 - 35)
			DrawText(2, height / 2 + 35)

		elseif numInfos == 3 then

			DrawText(1, height / 2 - 50)
			DrawText(2, height / 2)
			DrawText(3, height / 2 + 50)

		elseif numInfos == 4 then

			DrawText(1, height / 2 - 75)
			DrawText(2, height / 2 - 25)
			DrawText(3, height / 2 + 25)
			DrawText(4, height / 2 + 75)

		elseif numInfos == 5 then

			DrawText(1, height / 2 - 70)
			DrawText(2, height / 2 - 35)
			DrawText(3, height / 2)
			DrawText(4, height / 2 + 35)
			DrawText(5, height / 2 + 70)

		elseif numInfos == 6 then

			DrawText(1, height / 2 - 100)
			DrawText(2, height / 2 - 60)
			DrawText(3, height / 2 - 20)
			DrawText(4, height / 2 + 20)
			DrawText(5, height / 2 + 60)
			DrawText(6, height / 2 + 100)

		end
	end

	local printInfo = true

	if stage == 1 then
		ToolScreenTypes("Create", "Edit / Remove", "Admin panel")
	elseif stage == 2 then
		if edit == 1 then
			draw.SimpleText("Left click on entity!", "Diablos:Font:TS:35", width / 2, height / 2, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			ToolScreenTypes("Weigh balance", "Card reader", "Turnstile", "Treadmill", "Dumbbell", "Punching ball")
			printInfo = false
		end
	end

	if printInfo then
		draw.SimpleText("Training Manager", "Diablos:Font:TS:35", width / 2, 5, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText("Created by Diablos", "Diablos:Font:TS:20", width - 5, height - 5, col.w, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	end
end