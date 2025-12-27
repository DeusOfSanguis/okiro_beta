local wh1 	= 0
local speed1 = 5
local wh2 	= 0
local speed2 = 5
local wh3 	= 0
local speed3 = 5
local wh4 	= 0
local speed4 = 5
local colortxt = Color( 220, 218, 255 )
local hud1 = Material("okiro/hud/base.png","smooth","clamps")

local PANEL = {}

AccessorFunc(PANEL, "roundedModel", "Rounded", FORCE_NUMBER)
AccessorFunc(PANEL, "debugMode", "Debug", FORCE_BOOL)

local function DrawCircle(x, y, radius, seg)
    seg = seg == nil and 90 or seg
    local cir = {}
    for i = 1, seg do
        local a = math.rad((i / seg) * -360)
        table.insert(cir, {
            x = x + math.sin(a) * radius,
            y = y + math.cos(a) * radius
        })
    end

    surface.DrawPoly(cir)
end

function PANEL:Init()

    self.panel2 = vgui.Create("DPanel", (self:GetParent() == nil and nil or self:GetParent()))
    self.panel2.PosSync = false
    
	self.Entity = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	self.FarZ = 4096
	self:SetDebug(false)

    self:SetPaintedManually(true)
	self:SetParent(self.panel2)

	self:SetCamPos( Vector( 50, 50, 50 ) )
	self:SetLookAt( Vector( 0, 0, 40 ) )
	self:SetFOV( 70 )

	self:SetText( "" )
	self:SetAnimSpeed( 0.5 )
	self:SetAnimated( false )

	self:SetAmbientLight( Color( 50, 50, 50 ) )

	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )

	self:SetColor( color_white )

	local self = self
    self.panel2.Paint = function(self2, w, h)

        if not IsValid(self) or not IsValid(self.panel2) then return end

        local x, y = self:GetPos()
        if self:GetSize() != nil then
            self2:SetSize(self:GetSize())
        end
        
        local circleX, circleY = self:GetSize()
        
        if x != 0 and y != 0 and not self2.PosSync then
            self2:SetPos(self:GetPos())
            self:SetPos(0, 0)
            self2.PosSync = true
        end
        
        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilWriteMask(255)
        render.SetStencilTestMask(255)
        render.SetStencilFailOperation(STENCILOPERATION_KEEP)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
        render.SetStencilReferenceValue(1)
        
        surface.SetDrawColor(255,255,255,1)
        
        local radius = math.min(circleX/2, circleY/2)

        DrawCircle(circleX/2, circleY/2, radius, self:GetRounded())
        
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.SetStencilPassOperation(STENCILOPERATION_KEEP)
        
        self:PaintManual()
        render.SetStencilEnable(false)
    end

end

vgui.Register("DRoundeModelPanel", PANEL, "DModelPanel")

local function DrawMask(mask, draw)
    render.SetStencilEnable(true)
        render.ClearStencil()

        render.SetStencilWriteMask(1)
        render.SetStencilTestMask(1)

        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilFailOperation(STENCILOPERATION_KEEP)
        render.SetStencilZFailOperation(STENCILOPERATION_KEEP)

        mask()

        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)

        draw()

    render.SetStencilEnable(false)

end

local tAllowed = {
    ["superadmin"] = true,
	["responsable"] = true,
	["animateur"] = true,
	["moderateur"] = true,
	["support"] = true,
    ["admin"] = true,
}

surface.CreateFont("LexendRegulars", {
	font = "Lexend",
	size = 17,
	weight = 500,
	antialiased = true,
	extended = true,
})

surface.CreateFont("LexendMediums", {
	font = "Lexend Medium",
	size = 27.5,
	weight = 500,
	antialiased = true,
	extended = true,
})

local model = nil
hook.Add("HUDPaint", "SOLOLEVELING:Mad:HUDPaint", function()
	local ply = LocalPlayer() 
	if not IsValid(ply) then return end

	local health = ply:Health()
	local maxhleath = ply:GetMaxHealth()
	local stam = ply:GetNWInt("mad_stamina")
	local frametime = FrameTime()
	local niveau = ply:getDarkRPVar("level")
	local name = ply:getDarkRPVar("rpname") or ply:Nick()  
	if string.len(name) > 16 then
		name = string.sub(name, 1, 16) .. "..."
	end

	local classe = ply:GetNWInt("Classe")

	local rang = "Ранг " .. ply:GetNWInt("Rang")
	local xp = ply:getDarkRPVar("xp") or 0
	local xpneed = (((10+(((ply:getDarkRPVar("level") or 1)*((ply:getDarkRPVar("level") or 1)+1)*90))))*LevelSystemConfiguration.XPMult)

	if xp and xpneed then
		local target3 = math.Clamp(xp, 0, xpneed) / xpneed
		wh3 = Lerp(speed3 * FrameTime(), wh3, target3)

		local barX, barY = gRespX(731), gRespY(1026)       
		local barWidth, barHeight = gRespX(448), gRespY(29) 
		local progressWidth = wh3 * barWidth    
	
		render.SetScissorRect(gRespX(742), gRespY(1020), gRespX(725) + gRespX(460), gRespY(1020) + gRespY(41), true)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("okiro/hud/t2.png", "smooth", "clamps"))
		surface.DrawTexturedRect(barX, barY, progressWidth, barHeight)

		render.SetScissorRect(0, 0, 0, 0, false)

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("okiro/hud/xpbg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(725), gRespY(1020), gRespX(460), gRespY(41))
	end

    local target1 = math.Clamp( LocalPlayer():Health(), 0, LocalPlayer():GetMaxHealth() ) / LocalPlayer():GetMaxHealth()    
    wh1 = Lerp( speed1 * frametime, wh1, target1 )

    local target2 = math.Clamp( stam, 0, ply:GetNWInt("mana") ) / ply:GetNWInt("mana")    
    wh2 = Lerp( speed2 * frametime, wh2, target2 )

	surface.SetDrawColor( 255, 255, 255, 255 ) 
	surface.SetMaterial( hud1 ) 
	surface.DrawTexturedRect( gRespX(41), gRespY(908), gRespX(451), gRespY(140) )	

	hook.Add("PlayerStartVoice", "ImageOnVoice", function(ply)
		hook.Add("HUDPaint", "ImageOnVoice", function()
			if ply == LocalPlayer() then
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(Material("shavkat/micon/mic.png"))
				surface.DrawTexturedRect(gRespX(490), gRespY(956), gRespX(44), gRespY(48))	
			end
		end)
	end)

	hook.Add("PlayerEndVoice", "ImageOnVoice", function(ply)
		if ply == LocalPlayer() then
			hook.Remove("HUDPaint", "ImageOnVoice")
		end
	end)

	if niveau == nil then return end
	draw.SimpleText("Уровень ".. niveau, "LexendRegulars", gRespX(975), gRespY(1055), colortxt, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1.5)	

	local xp = xp .." / ".. xpneed .. " XP"
	if niveau == 99 then
		xp = "Maximum atteint"
	end

	draw.SimpleText(xp, "LexendRegulars", gRespX(941), gRespY(1055), colortxt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 2)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("okiro/hud/xpicon.png","smooth","clamps"))
	surface.DrawTexturedRect(gRespX(940), gRespY(1045), gRespX(36), gRespY(33))

	render.SetScissorRect(gRespX(255), gRespY(975), gRespX(255) + (wh1 * gRespX(219)), gRespY(975) + gRespY(25), true)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("okiro/hud/hudbar.png", "smooth", "clamps"))
	surface.DrawTexturedRect(gRespX(245), gRespY(975), gRespX(219), gRespY(25))

	render.SetScissorRect(0, 0, 0, 0, false)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("okiro/hud/hudbarbg.png","smooth","clamps"))
	surface.DrawTexturedRect(gRespX(240),gRespY(970),gRespX(229),gRespY(35))

	render.SetScissorRect(gRespX(255), gRespY(998), gRespX(255) + (wh2 * gRespX(219)), gRespY(998) + gRespY(25), true)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("okiro/hud/hudbar.png", "smooth", "clamps"))
	surface.DrawTexturedRect(gRespX(245), gRespY(998), gRespX(219), gRespY(25))

	render.SetScissorRect(0, 0, 0, 0, false) 

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("okiro/hud/hudbarbg.png","smooth","clamps"))
	surface.DrawTexturedRect(gRespX(240),gRespY(993),gRespX(229),gRespY(35))

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("okiro/hud/skillbg.png","smooth","clamps"))
	surface.DrawTexturedRect(gRespX(1858), gRespY(1023), gRespX(45), gRespY(45))

	draw.SimpleText("G", "LexendMediums", gRespY(1885), gRespY(1033), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("okiro/hud/heart.png","smooth","clamps"))
	surface.DrawTexturedRect(gRespX(180),gRespY(972),gRespX(32),gRespY(31))

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("okiro/hud/stam.png","smooth","clamps"))
	surface.DrawTexturedRect(gRespX(180),gRespY(994),gRespX(30),gRespY(33))

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("okiro/hud/logo.png","smooth","clamps"))
	surface.DrawTexturedRect(gRespY(1840),gRespY(12),gRespY(59),gRespY(80))

	draw.SimpleText("discord.gg/okiro", "LexendMediums", gRespY(1905), gRespY(100), Color(255, 255, 255, 100), TEXT_ALIGN_RIGHT)

	draw.SimpleText(formatCount(health), "LexendRegulars", gRespY(208), gRespY(978), colortxt, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2)	
	draw.SimpleText(formatCount(stam), "LexendRegulars", gRespY(208), gRespY(1001), colortxt, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2)	

	if rang == "Ранг Aucune" then
		rang = "Нету Ранга"
	end
    if LocalPlayer():GetNWString("Classe") != "Aucune" then
		draw.SimpleText(string.upper(CLASSES_SL[LocalPlayer():GetNWString("Classe")].name) .. " • " .. rang, "LexendRegulars", gRespY(459), gRespY(946.5), colortxt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    else
		draw.SimpleText(string.upper("Нету Класса") .. " • " .. rang, "LexendRegulars", gRespY(459), gRespY(946.5), colortxt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end
	--draw.SimpleText(string.upper(classe) .. " • " .. rang, "LexendRegulars", gRespY(459), gRespY(946.5), colortxt, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    draw.SimpleText(name, "LexendMediums", gRespY(190), gRespY(940), colortxt, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

	if IsValid(LocalPlayer():GetActiveWeapon()) and string.StartsWith(LocalPlayer():GetActiveWeapon():GetClass(), "mad_") then 
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("okiro/hud/skillbg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(749), gRespY(960), gRespX(55), gRespY(55))

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("okiro/hud/skillbg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(837.03), gRespY(960), gRespX(55), gRespY(55))

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("okiro/hud/skillbg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(925.07), gRespY(960), gRespX(55), gRespY(55))

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("okiro/hud/skillbg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1013.1), gRespY(960), gRespX(55), gRespY(55))

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(Material("okiro/hud/skillbg.png","smooth","clamps"))
		surface.DrawTexturedRect(gRespX(1101.14), gRespY(960), gRespX(55), gRespY(55))

		if LocalPlayer():GetNWInt("Technique1") != 0 then
			if LocalPlayer():GetNWInt("next_attaque1") - CurTime() > 0 then
				surface.SetDrawColor(100, 104, 117)
				surface.SetMaterial(Material(SKILLS_SL[LocalPlayer():GetNWInt("Technique1")].icon))
				surface.DrawTexturedRect(gRespX(753), gRespY(964), gRespX(46), gRespY(46))
			else
				surface.SetDrawColor(219, 227, 255, 255)
				surface.SetMaterial(Material(SKILLS_SL[LocalPlayer():GetNWInt("Technique1")].icon))
				surface.DrawTexturedRect(gRespX(753), gRespY(964), gRespX(46), gRespY(46))
			end
		else
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material("okiro/hud/none.png","smooth","clamps"))
			surface.DrawTexturedRect(gRespX(753), gRespY(964), gRespX(46), gRespY(46))
		end

		if LocalPlayer():GetNWInt("Technique2") != 0 then
			if LocalPlayer():GetNWInt("next_attaque2") - CurTime() > 0 then
				surface.SetDrawColor(100, 104, 117)
				surface.SetMaterial(Material(SKILLS_SL[LocalPlayer():GetNWInt("Technique2")].icon))
				surface.DrawTexturedRect(gRespX(841), gRespY(964), gRespX(46), gRespY(46))
			else
				surface.SetDrawColor(219, 227, 255, 255)
				surface.SetMaterial(Material(SKILLS_SL[LocalPlayer():GetNWInt("Technique2")].icon))
				surface.DrawTexturedRect(gRespX(841), gRespY(964), gRespX(46), gRespY(46))
			end
		else
			surface.SetDrawColor(219, 227, 255, 255)
			surface.SetMaterial(Material("okiro/hud/none.png","smooth","clamps"))
			surface.DrawTexturedRect(gRespX(841), gRespY(964), gRespX(46), gRespY(46))
		end

		if LocalPlayer():GetNWInt("Technique3") != 0 then
			if LocalPlayer():GetNWInt("next_attaque3") - CurTime() > 0 then
				surface.SetDrawColor(100, 104, 117)
				surface.SetMaterial(Material(SKILLS_SL[LocalPlayer():GetNWInt("Technique3")].icon))
				surface.DrawTexturedRect(gRespX(929), gRespY(964), gRespX(46), gRespY(46))	
			else
				surface.SetDrawColor(219, 227, 255, 255)
				surface.SetMaterial(Material(SKILLS_SL[LocalPlayer():GetNWInt("Technique3")].icon))
				surface.DrawTexturedRect(gRespX(929), gRespY(964), gRespX(46), gRespY(46))
			end
		else
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material("okiro/hud/none.png","smooth","clamps"))
			surface.DrawTexturedRect(gRespX(929), gRespY(964), gRespX(46), gRespY(46))
		end

		if LocalPlayer():GetNWInt("Technique4") != 0 then
			if LocalPlayer():GetNWInt("next_attaque4") - CurTime() > 0 then
				surface.SetDrawColor(100, 104, 117)
				surface.SetMaterial(Material(SKILLS_SL[LocalPlayer():GetNWInt("Technique4")].icon))
				surface.DrawTexturedRect(gRespX(1017), gRespY(964), gRespX(46), gRespY(46))
			else
				surface.SetDrawColor(219, 227, 255, 255)
				surface.SetMaterial(Material(SKILLS_SL[LocalPlayer():GetNWInt("Technique4")].icon))
				surface.DrawTexturedRect(gRespX(1017), gRespY(964), gRespX(46), gRespY(46))
			end
		else
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material("okiro/hud/none.png","smooth","clamps"))
			surface.DrawTexturedRect(gRespX(1017), gRespY(964), gRespX(46), gRespY(46))
		end

		if LocalPlayer():GetNWInt("Technique5") != 0 then
			if LocalPlayer():GetNWInt("next_attaque5") - CurTime() > 0 then
				surface.SetDrawColor(100, 104, 117)
				surface.SetMaterial(Material(SKILLS_SL[LocalPlayer():GetNWInt("Technique5")].icon))
				surface.DrawTexturedRect(gRespX(1105), gRespY(964), gRespX(46), gRespY(46))
			else
				surface.SetDrawColor(219, 227, 255, 255)
				surface.SetMaterial(Material(SKILLS_SL[LocalPlayer():GetNWInt("Technique5")].icon))
				surface.DrawTexturedRect(gRespX(1105), gRespY(964), gRespX(46), gRespY(46))
			end
		else
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(Material("okiro/hud/none.png","smooth","clamps"))
			surface.DrawTexturedRect(gRespX(1105), gRespY(964), gRespX(46), gRespY(46))
		end

		if LocalPlayer():GetNWInt("next_attaque1") - CurTime() > 0 then
			draw.SimpleText(math.Round(LocalPlayer():GetNWInt("next_attaque1") - CurTime()), "M_Font3", gRespX(753+22),gRespY(964+10), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
		if LocalPlayer():GetNWInt("next_attaque2") - CurTime() > 0 then
			draw.SimpleText(math.Round(LocalPlayer():GetNWInt("next_attaque2") - CurTime()), "M_Font3", gRespX(841+22),gRespY(964+10), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
		if LocalPlayer():GetNWInt("next_attaque3") - CurTime() > 0 then
			draw.SimpleText(math.Round(LocalPlayer():GetNWInt("next_attaque3") - CurTime()), "M_Font3", gRespX(929+22),gRespY(964+10), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
		if LocalPlayer():GetNWInt("next_attaque4") - CurTime() > 0 then
			draw.SimpleText(math.Round(LocalPlayer():GetNWInt("next_attaque4") - CurTime()), "M_Font3", gRespX(1017+22),gRespY(964+10), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
		if LocalPlayer():GetNWInt("next_attaque5") - CurTime() > 0 then
			draw.SimpleText(math.Round(LocalPlayer():GetNWInt("next_attaque5") - CurTime()), "M_Font3", gRespX(1105+22),gRespY(964+10), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	elseif LocalPlayer():GetActiveWeapon() == "mad_asso_detecteur" then 
		return
	end

	if IsValid(model) and model:GetModel() != LocalPlayer():GetModel() then
		if IsValid(model) then model:Remove() end
	end

	if not IsValid(model) then

		model = vgui.Create("DRoundeModelPanel")
		model:SetPos(gRespX(51), gRespY(917))
		model:SetSize(gRespX(120), gRespY(120))
		model:SetModel(LocalPlayer():GetModel())
		model:SetDebug(false)
		function model:LayoutEntity( Entity ) return end
		local headpos = model.Entity:GetBonePosition(model.Entity:LookupBone("ValveBiped.Bip01_Head1"))
		model:SetLookAt(headpos)
		model:SetCamPos(headpos-Vector(-18, 0, 0))

		function model.Entity:GetPlayerColor()
			return LocalPlayer():GetPlayerColor()
		end

		for i = 1, LocalPlayer():GetNumBodyGroups() do
			local body = LocalPlayer():GetBodygroup(i)

			model.Entity:SetBodygroup(i, body)
		end

	end

end)

local HideElement = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["DarkRP_HUD"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"] = true,
    ["DarkRP_Agenda"] = true,
    ["DarkRP_LockdownHUD"] = true,
    ["DarkRP_ArrestedHUD"] = true,
    ["DarkRP_ChatReceivers"] = true,
	["CHudCloseCaption"] = true,
	["CHudCrosshair"] = true,
	["CHudDamageIndicator"] = true,
	["DarkRP_Notification"] = true,
}

hook.Add("HUDShouldDraw", "MHA:ShouldDraw", function(name)
    if HideElement[name] then return false end
end)

hook.Add("ContextMenuOpen", "BlockContextMenu", function ()
	if ( !tAllowed[LocalPlayer():GetUserGroup()] ) then
        return false
    end
end)

hook.Add("AddDeathNotice", "PreventDeathNotice", function()
    return false 
end)

hook.Add("SpawnMenuOpen", "OKIRO:BlockPropMenuUser", function()
    if ( !tAllowed[LocalPlayer():GetUserGroup()] ) then
        return false
    end
end)

hook.Add("ShowSpare2", "BlockF4Menu", function ()
	return false
end)
