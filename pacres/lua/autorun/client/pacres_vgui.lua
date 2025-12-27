local arrow = Material("gui/spawnmenu_toggle")
local grad = Material("gui/gradient_down")
local function PaintImgBut(panel,w,h)
	local color = panel.Color
	if panel.Depressed or panel:IsSelected() then
		color = panel.SelectedColor
	elseif panel.Hovered then
		color = panel.HoveredColor
	end
	surface.SetDrawColor(color)
	if panel.Img then
		surface.SetMaterial(panel.Img)
		surface.DrawRect(0,0,w,h)
		surface.DrawTexturedRectRotated(w/2,h/2,w,h,panel.Dir)
	else
		surface.DrawRect(0,0,w,h)
	end
end
function PaintFill(self,w,h)
	local color = self.Color
	if self.Depressed || self:IsSelected() then
		color = self.SelectedColor
	elseif self.Hovered then
		color = self.HoveredColor
	end
	surface.SetDrawColor(self.BGColor)
	surface.DrawRect(0,0,w,h)
	draw.SimpleText( self:GetText(), self.m_bFont, w/2, h/2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	return true
end
local function selclrfunc(self,bg,cl,sel,hov)
	self.BGColor,self.Color,self.SelectedColor,self.HoveredColor=bg,cl,sel,hov
end
function CustomRequestPaint(self,w,h)
	Derma_DrawBackgroundBlur(self,tme)
	surface.SetDrawColor(self.Color2)
	surface.DrawRect(0,0,w,h)
	surface.SetDrawColor(self.Color3)
	surface.DrawOutlinedRect(0,0,w,h)
	surface.DrawOutlinedRect(1,1,w-2,22)
	surface.DrawOutlinedRect(2,2,w-4,20)
	surface.SetMaterial(grad)
	surface.DrawTexturedRect(0,24,w,48)
end
function InitButPaint(self,panel)
	if self then
		table.insert(self.Recolor,panel)
	end
	panel.SetColor,panel.m_bFont,panel.SelectedColor,panel.HoveredColor,panel.BGColor,panel.Paint = selclrfunc,"Default",color_white,color_white,color_black,PaintFill
end
function InitImgBut(self,panel,img,dir)
	if self then
		table.insert(self.ColorPanels,panel)
	end
	panel.Color,panel.SelectedColor,panel.HoveredColor,panel.Dir,panel.Img,panel.Paint=color_white,color_white,color_white,dir or 0,img,PaintImgBut
end
function FixDImage(self,sizex,sizey)
	local dimg = self.m_Image
	if IsValid(dimg) then
		function self.m_Image:Paint(w,h)
			local f,t = w*sizex,w*sizey
			self:PaintAt(f,f,t,t)
		end
	end
end
function AddExpandButton(parent,whatexpand)
	local but = vgui.Create("DImageButton",parent)
	but:SetImage("icon16/bullet_arrow_down.png")
	but:Dock(LEFT)
	but:SetWide(parent:GetTall())
	function but:DoClick()
		whatexpand:Expand()
		if whatexpand.Active then
			self:SetImage("icon16/bullet_arrow_up.png")
		else
			self:SetImage("icon16/bullet_arrow_down.png")
		end
	end
	whatexpand.ExpandButton = but
	FixDImage(but,0.15,0.7)
	return but
end
local PANEL = {}
AccessorFunc(PANEL,"m_bFont","Font",FORCE_STRING)
function PANEL:Init()
	self:SetText("")
	self.BGColor,self.Color,self.SelectedColor,self.HoveredColor=color_white,color_black,color_white,color_black
	self.Color = self.m_bTextColor
end
PANEL.SetColor = selclrfunc
function PANEL:Paint(w,h)
	local color = self.Color
	if self.Depressed or self:IsSelected() then
		color = self.SelectedColor
	elseif self.Hovered then
		color = self.HoveredColor
	end
	if self.Active then
		surface.SetDrawColor(self.SelectedColor)
		surface.DrawOutlinedRect(1,1,w-2,h-2)
		surface.DrawOutlinedRect(2,2,w-4,h-4)
	else
		surface.SetDrawColor(self.BGColor)
		surface.DrawOutlinedRect(0,2,w,h-4)
	end
	draw.SimpleText( self:GetText(), self.m_bFont, w/2, h/2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	return true
end
derma.DefineControl( "PRButton", "PRButton", PANEL, "DButton" )
PANEL = {}
function PANEL:Init()
	self:SetText("")
	self.m_bValue,self.Color,self.SelectedColor,self.HoveredColor=false,color_white,color_white,color_white
end
function PANEL:SetValue(val)
	self.m_bValue = val and true or false
end
function PANEL:DoClick()
	self.m_bValue = not self.m_bValue
	self:OnChange(self.m_bValue)
end
function PANEL:SetColor(clr,selected,hover)
	self.Color,self.SelectedColor,self.HoveredColor=clr,selected,hover
end
local agree,cross = Material("icon16/tick.png"),Material("icon16/cross.png")
function PANEL:Paint(w,h)
	PaintImgBut(self,w-1,h)
	if self.m_bValue then
		surface.SetMaterial(agree)
	else
		surface.SetMaterial(cross)
	end
	if self.Based then
		surface.SetDrawColor(self.SelectedColor)
	else
		surface.SetDrawColor(Color(255,255,255))
	end
	surface.DrawTexturedRect(w*0.15,h*0.15,w*0.7,h*0.7)
end
derma.DefineControl( "PRCheckBox", "PRCheckBox", PANEL, "DButton" )
PANEL = {}
function PANEL:Init()
	self.ColorPanels = {}
	InitImgBut(self,self.VBar.btnUp,arrow,90)
	InitImgBut(self,self.VBar.btnDown,arrow,-90)
	InitImgBut(self,self.VBar.btnGrip)
end
function PANEL:SetColor(clr,hover,selected)
	for _,panel in pairs(self.ColorPanels) do
		panel.Color,panel.SelectedColor,panel.HoveredColor=clr,hover,selected
	end
end
derma.DefineControl( "PRScroll", "PRScroll", PANEL, "DScrollPanel")
PANEL = {}
function PANEL:Init()
	self.m_bDelay,self.Active = 0.4,false
end
function PANEL:SetMainTall(h,m)
	self.m_bMainTall = h
	self.m_bFullTall = m
	self:SetTall(self.Active and self.m_bFullTall or self.m_bMainTall)
end
function PANEL:OnChildAdded( child )
	child:Dock( TOP )
	if self.ExpandButton and self:ChildCount() == 2 then
		self.ExpandButton:SetVisible(true)
	end
end
function PANEL:OnChildRemoved( child )
	if self.ExpandButton and self:ChildCount() == 1 then
		self.ExpandButton:SetVisible(false)
	end
end
function PANEL:PerformLayout()
	if self.Active and not self.Sized then
		self:SizeToChildren( false, true )
	end
end
function PANEL:ChildHeight()
	local height = 0
	for _,v in pairs(self:GetChildren()) do
		height = height + v:GetTall()
	end
	return height
end
function PANEL:DeleteRecursive(selected,vl)
	for k,v in pairs(self:GetChildren()) do
		if v.Expand then
			v:DeleteRecursive(selected,vl)
		else
			if v == selected then
				vl:Clear()
			end
			v:Remove()
		end
	end
	self:Remove()
end
local tempfunc = function(a,p) p.Sized = nil end
function PANEL:Expand(force,fast)
	force = force or self.Active
	if self.Sized then return end
	self.m_bFullTall = self:ChildHeight()
	local sz = force and self.m_bMainTall or self.m_bFullTall
	if fast then
		self:SetTall(sz)
	else
		self.Sized = true
		self:SizeTo(-1,sz,self.m_bDelay,0,-1,tempfunc)
	end
	self.Active = not force
end
derma.DefineControl( "PRExpand", "PRExpand", PANEL)