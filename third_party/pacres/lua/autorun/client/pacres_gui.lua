module("pacres", package.seeall)
local Desc,Color1,Color2,Color3,Color4,TextColor
local ThemePacks = {[0] = {"",Color(115,113,117),Color(152,149,156),Color(202,200,205),color_white,color_white},
[1] = {"",Color(191,144,48),Color(255,171,0),Color(255,192,64),Color(255,209,115),color_white},
[2] = {"",Color(64,147,0),Color(98,170,42),Color(139,241,60),Color(166,241,108),color_white},
[3] = {"",Color(29,115,115),Color(0,153,153),Color(51,204,204),Color(92,204,204),color_white},
[4] = {"",Color(155,0,28),Color(239,0,42),Color(247,111,135),Color(247,62,95),color_white},
[5] = {"",Color(57,46,133),Color(42,23,177),Color(93,75,216),Color(125,113,216),color_white},
[6] = {"",Color(151,151,48),Color(185,185,0),Color(220,220,64),Color(255,255,115),color_white},
[7] = {"",Color(191,54,12),Color(245,124,0),Color(255,193,7),Color(255,241,118),color_white},
[8] = {"",Color(74,20,140),Color(123,31,162),Color(103,58,183),Color(149,117,205),color_white}
}
function CreateRestrict(nm,gr,gl)
	local derive = gr["derive"]
	if derive then
		gr[1] = gl[derive]
		gl[nm] = setmetatable(gr,meta)
	end
end
function OpenGUI(tbl)
	local lang = langs.GUI
	for k = 0,#ThemePacks do
		ThemePacks[k][1] = lang[k+1]
	end
	if ValidPanel(mpnl) then
		mpnl:Remove()
	end
	local theme = tonumber(LocalPlayer():GetPData("PACRES_THEME",0))
	if ThemePacks[theme] then
		Desc,Color1,Color2,Color3,Color4,TextColor = unpack(ThemePacks[theme])
	else
		Desc,Color1,Color2,Color3,Color4,TextColor = unpack(ThemePacks[0])
	end
	for k,v in pairs(tbl) do
		CreateRestrict(k,v,tbl)
	end
	local w,h = ScrW(),ScrH()
	mpnl = vgui.Create("DFrame")
	mpnl.btnMinim:SetVisible(false)
	mpnl.btnMaxim:SetVisible(false)
	mpnl:SetTitle(lang[10])
	mpnl:SetSize(w*0.6,h*0.7)
	mpnl:Center()
	mpnl:MakePopup()
	function mpnl:Paint(w,h)
		surface.SetDrawColor(Color1)
		surface.DrawRect(0,0,w,h)
	end
	local pnl = vgui.Create("DPanel",mpnl)
	pnl:SetPos(0,0)
	local wid = mpnl:GetWide()
	pnl:SetSize(wid*0.96,mpnl:GetTall()-5)
	pnl:Dock(LEFT)
	pnl.Recolor = {}
	function pnl:Paint(w,h) end
	local cm = vgui.Create("Panel",mpnl)
	cm:Dock(LEFT)
	cm:SetWide(wid*0.03)
	function cm:Paint(w,h) end
	local tm = vgui.Create("DImageButton",cm)
	tm:SetImage("icon16/application_view_tile.png")
	tm:Dock(BOTTOM)
	tm:SetTall(wid*0.03)
	function tm:SlideButtons(act)
		for _,v in pairs(cm:GetChildren()) do
			if v == tm then continue end
			local size = act and wid*0.03 or 0
			v:SizeTo(-1,size,0.5,0,-1,function(a,pnl)
				tm.Active = nil
			end)
		end
	end
	function tm:DoClick()
		if self.Active then return end
		cm.Active = !cm.Active
		self.Active = true
		self:SlideButtons(cm.Active)
	end
	tm:SetToolTip(lang[11])
	FixDImage(tm,0.1,0.8)
	for ind,theme in SortedPairs(ThemePacks) do
		local tm = vgui.Create("DButton",cm)
		tm:Dock(BOTTOM)
		tm:SetTall(0)
		local color = theme[2]
		function tm:Paint(w,h)
			surface.SetDrawColor(color)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(0,0,w,h)
			return true
		end
		tm:SetToolTip(theme[1])
		function tm:DoClick()
			LocalPlayer():SetPData("PACRES_THEME",ind)
			Desc,Color1,Color2,Color3,Color4,TextColor = unpack(ThemePacks[ind])
			for _,v in pairs(pnl.Recolor) do
				if not ValidPanel(v) then
					pnl.Recolor[_] = nil
					continue
				end
				v:ApplyTheme()
			end
			table.remove(pnl.Recolor,table.insert(pnl.Recolor,true))
		end
	end
	local x,y = pnl:GetSize()
	local gr = vgui.Create("PRScroll",pnl)
	gr:SetPos(5,5)
	gr:SetSize(x/2.5,y-33)
	function gr:ApplyTheme()
		self:SetColor(Color3,Color2,Color4)
	end
	gr:ApplyTheme()
	table.insert(pnl.Recolor,gr)
	function gr:Paint(w,h)
		surface.SetDrawColor(Color4)
		surface.DrawOutlinedRect(0,0,w-15,h)
	end
	local ch = vgui.Create("DListLayout",gr)
	ch:SetSize(gr:GetWide()-15,gr:GetTall())
	local vlparent = vgui.Create("PRScroll",pnl)
	vlparent:SetPos(gr:GetWide()+10,5)
	vlparent:SetSize(x-gr:GetWide()-20,y-35)
	function vlparent:ApplyTheme()
		self:SetColor(Color3,Color2,Color4)
	end
	vlparent:ApplyTheme()
	table.insert(pnl.Recolor,vlparent)
	function vlparent:Paint(w,h)
		if pnl.Selected then
			surface.SetDrawColor(Color4)
			surface.DrawOutlinedRect(0,0,w,h+1)
		end
	end
	local vl = vgui.Create("DListLayout",vlparent)
	vl:SetPos(5,5)
	vl:SetSize(vlparent:GetWide()-20,y-35)
	function vl:Clear()
		for k,v in pairs(self:GetChildren()) do
			v:Remove()
		end
	end
	local tooltips = {delay=lang[12],size=lang[13],editor=lang[14],can_use=lang[15],check_models=lang[16],check_materials=lang[17],check_url=lang[18],check_sounds=lang[19]}
	function pnl.AddLabel(i)
		local db = vgui.Create("Panel",vl)
		db.text = (i:sub(1,1):upper()..i:sub(2)):Replace("_"," ")
		db:SetContentAlignment(4)
		db:Dock(TOP)
		local tip = tooltips[i] or string.format(lang[20],i)
		db:SetToolTip(tip)
		function db:Paint(w,h)
			surface.SetDrawColor(Color2)
			surface.DrawRect(0,1,w,h-2)
			draw.SimpleText(self.text, "DermaDefault", 5,h*0.5, TextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
		return db
	end
	function pnl.SelectGroup(k)
		local w = vl:GetWide()
		for _,i in pairs(bools) do
			local db = pnl.AddLabel(i)
			local bl = vgui.Create("PRCheckBox",db)
			local h = db:GetTall()*0.75
			bl:SetPos(w-h,h*0.2)
			bl:SetSize(h,h)
			function bl:ApplyTheme()
				self:SetColor(Color3,Color1,Color2)
			end
			bl:ApplyTheme()
			table.insert(pnl.Recolor,bl)
			function db:OnMousePressed(cd)
				if cd == MOUSE_LEFT then
					bl:DoClick()
				end
			end
			function bl:SetDefault(bool)
				local tb = tbl[k]
				local bool = not tb[i] and true or nil
				self:SetValue(bool)
				self.Based = (tb["derive"] and rawget(tb,1)[i] ~= bool) and true or false
			end
			bl:SetDefault()
			function bl:OnChange(bool)
				bool = not bool
				SetBool(tbl[k],i,bool)
				bl:SetDefault()
				if bool then
					net.Start("PAC3RESCTRL")
					net.WriteUInt(1,2)
					net.WriteString(k)
					net.WriteString(i)
					net.SendToServer()
				else
					net.Start("PAC3RESCTRL")
					net.WriteUInt(2,2)
					net.WriteString(k)
					net.WriteString(i)
					net.SendToServer()
				end
			end
		end
		for _,i in pairs(limits) do
			local db = pnl.AddLabel(i)
			local te = vgui.Create("DTextEntry",db)
			te:Dock(RIGHT)
			function te:Paint(w,h)
				w,h=w-2,h-2
				if self:HasFocus() then
					surface.SetDrawColor(Color3)
				else
					surface.SetDrawColor(Color1)
				end
				surface.DrawRect(1,1,w,h)
				surface.SetDrawColor(Color4)
				surface.DrawOutlinedRect(1,1,w,h)
				self:DrawTextEntryText( self.Based and Color2 or color_white, Color2, Color1 )
			end
			function te:OnLoseFocus()
				self:OnEnter()
			end
			function te:SetDefault()
				local a = tbl[k][i]
				if not a then
					self:SetText('')
					self.Based = nil
					return
				end
				self:SetText(a)
				self.Based = rawget(tbl[k],i) != a
			end
			te:SetDefault()
			function db:OnMousePressed(cd)
				if cd == MOUSE_LEFT then
					te:RequestFocus()
					te:SelectAllText()
				end
			end
			function te:ClearField()
				if tbl[k][i] ~= nil then
					tbl[k][i] = nil
					self:SetDefault()
					net.Start("PAC3RESCTRL")
					net.WriteUInt(2,2)
					net.WriteString(k)
					net.WriteString(i)
					net.SendToServer()
				end
			end
			function te:OnEnter()
				local text1 = te:GetValue()
				text = tonumber(text1)
				if text then
					if text < 0 then
						self:ClearField()
					else
						text = math.Clamp(math.Round(text),0,65534)
						if tbl[k][i] ~= text then
							tbl[k][i] = text
							self.Based = false
							self:SetText(text)
							net.Start("PAC3RESCTRL")
							net.WriteUInt(1,2)
							net.WriteString(k)
							net.WriteString(i)
							net.WriteUInt(text,16)
							net.SendToServer()
						end
					end
				else
					if text1 == '' then
						self:ClearField()
					else
						self:SetDefault()
					end
				end
			end
		end
	end
	function pnl:AddGroupAdvance(derive,k,base,lvl)
		lvl = lvl or 1
		local lb = self.AddGroup(k,base or ch)
		local deriv = derive[k]
		local sumsize = lb:GetTall()
		local expand = vgui.Create("PRExpand",base or ch)
		lb:SetParent(expand)
		local but = AddExpandButton(lb,expand)
		lb.HasExpand = expand
		lb.Level = lvl
		if deriv then
			for c,d in pairs(deriv) do
				local lb1 = self:AddGroupAdvance(derive,d,expand,lvl + 1)
				local wid = lb1:GetWide()
				lb1:DockMargin(wid*lvl*0.15,0,0,0)
				sumsize = sumsize + lb1:GetTall()
			end
			expand:SetMainTall(lb:GetTall(),sumsize)
		else
			but:SetVisible(false)
		end
		return lb,sumsize
	end
	function pnl:BuildGroups(group)
		local expand,sidsexp = vgui.Create("PRExpand",ch)
		local lb = self.AddGroup(lang[21],expand,true)
		AddExpandButton(lb,expand)
		local buildtbl = table.Copy(tbl)
		local derive = {}
		for k,v in pairs(buildtbl) do
			local from = v["derive"]
			if from then
				buildtbl[k] = nil
				if not derive[from] then
					derive[from] = {}
				end
				table.insert(derive[from],k)
			end
		end
		if next(buildtbl) then
			for k,v in pairs(buildtbl) do
				if string.sub(k,1,5) ~= "STEAM" then
					buildtbl[k] = nil
					self:AddGroupAdvance(derive,k,expand)
				end
			end
			expand:SetMainTall(lb:GetTall(),expand:ChildHeight())
		else
			expand.ExpandButton:SetVisible(false)
		end
		sidsexp = vgui.Create("PRExpand",ch)
		local lb = self.AddGroup(lang[22],sidsexp,true)
		AddExpandButton(lb,sidsexp)
		if next(buildtbl) then
			for k,v in pairs(buildtbl) do
				self:AddGroupAdvance(derive,k,sidsexp)
			end
			sidsexp:SetMainTall(lb:GetTall(),sidsexp:ChildHeight())
		else
			sidsexp.ExpandButton:SetVisible(false)
		end
		sidsexp:Expand(false)
		expand:Expand(false)
		if group then
			for k,v in pairs(ch:GetChildren()) do
				if v:GetText() == group then
					v.Active = true
					pnl.Selected = v
					pnl.SelectGroup(group)
				end
			end
		end
		pnl.ExpGrp = expand
		pnl.ExpSid = sidsexp
	end
	function pnl.AddGroup(k,parent,div)
		parent = parent or ch
		local lb = vgui.Create("PRButton",parent)
		lb:SetText(k)
		table.insert(pnl.Recolor,lb)
		if not div then
			function lb:ApplyTheme()
				self:SetColor(Color2,Color4,Color3,Color2)
			end
			function lb:DoClick()
				if pnl.Selected == self then
					self.Active = false
					vl:Clear()
					pnl.Selected = nil
					return
				end
				if ValidPanel(pnl.Selected) then
					pnl.Selected.Active = false
				end
				pnl.Selected = self
				self.Active = true
				vl:Clear()
				pnl.SelectGroup(k)
			end
		else
			function lb:ApplyTheme()
				self:SetColor(Color3,Color1,Color4,Color2)
			end
			lb.Paint = PaintFill
			lb:SetContentAlignment(4)
		end
		lb:ApplyTheme()
		local add = vgui.Create("DImageButton",lb)
		add:SetImage("icon16/add.png")
		add:SetWide(lb:GetTall())
		add:Dock(RIGHT)
		add:DockMargin(0,0,-5,0)
		add:SetToolTip(lang[23])
		local function PutGroup(exp,lb,text)
			local expand = vgui.Create("PRExpand",exp)
			local lb1 = pnl.AddGroup(text,expand)
			local lvl = lb.Level or 0
			lb1.Level = lvl + 1
			lb1.HasExpand = expand
			lb1:DockMargin(lb1:GetWide()*lvl*0.15,0,0,0)
			expand:SetMainTall(lb:GetTall(),expand:ChildHeight())
			AddExpandButton(lb1,expand)
			expand.ExpandButton:SetVisible(false)
			exp:SetMainTall(lb:GetTall(),exp:ChildHeight())
			return expand
		end
		function add:DoClick()
			local func = function(text,base)
				if isstring(text) and #text>0 and not tbl[text] then
					tbl[text] = {}
					if div then
						net.Start("PAC3RESCTRL")
						net.WriteUInt(0,2)
						net.WriteString(text)
						net.SendToServer()
						local exp,sid = parent,text:find("STEAM")
						if exp == pnl.ExpSid and not sid then
							exp = pnl.ExpGrp
						elseif exp == pnl.ExpGrp and sid then
							exp = pnl.ExpSid
						end
						PutGroup(exp,lb,text):Expand(false)
					else
						local tb = tbl[text]
						if not tbl[k] then return end
						if base then
							tb = table.Copy(tbl[k])
							setmetatable(tb,nil)
							tbl[text] = tb
							local sid,parent = text:find("STEAM")
							parent = sid and pnl.ExpSid or pnl.ExpGrp
							pnl.AddGroup(text,parent)
							parent:SetMainTall(lb:GetTall(),parent:ChildHeight())
						else
							tb["derive"] = k
							CreateRestrict(text,tb,tbl)
							local exp = lb.HasExpand
							if ValidPanel(exp) then
								PutGroup(exp,lb,text):Expand(false)
							else
								return
							end
						end
						net.Start("PAC3RESCTRL")
						net.WriteUInt(0,2)
						net.WriteString(text)
						net.WriteString(k)
						net.WriteBool(base)
						net.SendToServer()
					end
				end
			end
			local mpnl = Derma_StringRequest(lang[24],lang[25],nil,
			func,nil,lang[26],lang[27])
			local tme = SysTime()
			mpnl.Color2,mpnl.Color3,mpnl.Paint = Color2,Color3,CustomRequestPaint
			local buttons,textentry = mpnl:GetChild(5),mpnl:GetChild(4):GetChild(1)
			if ValidPanel(buttons) and ValidPanel(textentry) then
				if not div then
					local btn = vgui.Create( "DButton", buttons )
					btn:SetText(lang[28])
					btn:SizeToContents()
					btn:SetTall( 20 )
					btn:SetPos( 5, 5 )
					btn:MoveRightOf( buttons:GetChild(1),5)
					function btn:DoClick()
						mpnl:Close()
						func(textentry:GetText(),true)
					end
					buttons:SetWide(buttons:GetWide()+btn:GetWide()+5)
					buttons:CenterHorizontal()
				end
				for _,z in pairs(buttons:GetChildren()) do
					InitButPaint(nil,z)
					z:SetColor(Color3,Color1,Color4,Color2)
				end
			end
		end
		FixDImage(add,0.2,0.6)
		if k == def:GetString() then
			local icon = vgui.Create("DImageButton",lb)
			icon:SetImage("icon16/group_gear.png")
			icon:Dock(LEFT)
			icon:DockMargin(0,3,-5,0)
			icon:SetWide(icon:GetTall())
			icon:SetToolTip(lang[29])
			FixDImage(icon,0.135,0.73)
		end
		if not div then
			local remove = vgui.Create("DImageButton",lb)
			remove:SetImage("icon16/cross.png")
			remove:SetSize(16,16)
			remove:Dock(RIGHT)
			remove:DockMargin(0,3,-5,0)
			remove:SetWide(remove:GetTall())
			remove:SetToolTip(string.format(lang[30],k))
			function remove:DoClick()
				local mpnl = Derma_Query(string.format(lang[31],k), lang[32], lang[33], function()
					tbl[k] = nil
					if pnl.Selected == lb then
						vl:Clear()
					end
					if ValidPanel(lb.HasExpand) then
						lb.HasExpand:DeleteRecursive(pnl.Selected,vl)
					end
					RemoveRecursive(tbl,k)
					lb:Remove()
					net.Start("PAC3RESCTRL")
					net.WriteUInt(3,2)
					net.WriteString(k)
					net.SendToServer()
				end, lang[34], function() end)
				mpnl.Color2,mpnl.Color3,mpnl.Paint = Color2,Color3,CustomRequestPaint
				local buttons = mpnl:GetChild(5)
				if ValidPanel(buttons) then
					for _,z in pairs(buttons:GetChildren()) do
						InitButPaint(nil,z)
						z:SetColor(Color3,Color1,Color4,Color2)
					end
				end
				mpnl:GetChild(3):SetTextColor(Color4)
			end
			FixDImage(remove,0.135,0.73)
		end
		return lb
	end
	pnl:BuildGroups()
	return pnl,ch,vl
end