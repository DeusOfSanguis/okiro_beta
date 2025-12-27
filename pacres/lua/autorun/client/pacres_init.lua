module("pacres", package.seeall)
local lang = GetConVar("gmod_language"):GetString()
CreateConVar("pacres_lang", lang or "en", bit.bor(FCVAR_USERINFO,FCVAR_ARCHIVE),"PAC3 Restrictor language(Require reconnect if change)")
langs,vars,outof,values = langs or {},vars or {},outof or {},values or {}
net.Receive("PAC3RESCTRL",function(len)
	local int = net.ReadUInt(2)
	if int == 0 then
		for k in pairs(vars) do vars[k] = nil end
		local int = 0
		for k in pairs(sendvars) do
			int = int + 1
			vars[int] = net.ReadUInt(1) == 1 and true or nil
		end
		for i = 1,64 do
			local int = net.ReadUInt(6)-svcnt
			if int == -svcnt then break end
			local var = limits[int]
			if var == nil then continue end
			vars[var] = net.ReadUInt(16)
			if vars[var] == 65535 then
				vars[var] = nil
			end
		end
		if net.ReadBool() then
			for _,v in pairs(LangsSend) do
				langs[v] = net.ReadString()
			end
		end
	elseif int == 1 then
		local tbl = net.ReadTable()
		if not istable(tbl) then return end
		if not LocalPlayer():IsSuperAdmin() then return end
		local str = util.Decompress(net.ReadData(net.ReadUInt(12)))
		if str then
			langs.GUI = string.Split(str,'\\')
		end
		if langs.GUI then
			OpenGUI(tbl)
		end
	elseif int == 2 then
		local cnt,str = net.ReadUInt(8),net.ReadString()
		chat.AddText(Color(255,255,0),"[PAC3] ",Color(255,55,55),string.format(langs.Error,str))
		for i = 1,cnt do
			local str = net.ReadString()
			MsgC(Color(255,255,255),"\t",str,"\n")
		end
	elseif int == 3 then
		local sh = net.ReadUInt(6)
		if sh <= svcnt then
			vars[sh] = net.ReadUInt(1) == 1 or nil
		else
			local var = limits[sh-svcnt]
			if var then
				vars[var] = net.ReadUInt(16)
				if vars[var] == 65535 then
					vars[var] = nil
				end
			end
		end
	end
end)
local lastsend,istore,SysTime,LocalPlayer = 0,{},SysTime,LocalPlayer
local editor,can_use,delay = shared["editor"],shared["can_use"],shared["delay"]
hook.Add("PrePACEditorOpen","RestrictEditor",function(ply)
	if vars[editor] then
		if lastsend < SysTime() then
			chat.AddText(Color(255,255,0),"[PAC3] ",Color(255,0,0),langs.Editor)
			lastsend = SysTime() + 10
		end
		return false
	end
end)
function Initialize()
	local cvar = GetConVar("pacres_delay")
	SendPartToServer = SendPartToServer or pace.SendPartToServer
	function pace.SendPartToServer(part,...)
		if part.ClassName == "group" and not part:HasChildren() then return end
		if part.show_in_editor == false then return end
		if vars[can_use] then
			if lastsend < SysTime() then
				chat.AddText(Color(255,255,0),"[PAC3] ",Color(255,0,0),langs.Wear)
				lastsend = SysTime() + 10
			end
			return false
		end
		if vars[delay] then
			return SendPartToServer(part,...)
		end
		local tbl = part:ToTable()
		local uid = tbl.self.UniqueID
		if not istore[uid] then
			istore[uid] = true
			lastsend = SysTime()+cvar:GetFloat()
			return SendPartToServer(part,...)
		else
			if lastsend > SysTime() then
				if not istore[1] then
					istore[1] = true
					chat.AddText(Color(255,255,0),"[PAC3] ",Color(255,0,0),langs.Spam)
				end
				return false
			else
				for k,v in pairs(istore) do
					istore[k] = nil
				end
				chat.AddText(Color(255,255,0),"[PAC3] ",Color(0,255,0),langs.Wearing)
				istore[uid] = true
				lastsend = SysTime()+cvar:GetFloat()
				return SendPartToServer(part,...)
			end
		end
	end
	local L = pace.LanguageString
	local function OnPartCreated(part)
		if part:GetPlayerOwner() ~= LocalPlayer() then return end
		local cl = part.ClassName
		values[cl] = (values[cl] or 0) + 1
		local vals,var = values[cl],vars[cl]
		if var then
			local tb = outof[cl]
			if tb == nil then
				local red = vals <= var
				outof[cl] = {L(cl),vals.." / "..var,red and (SysTime() + 5) or nil}
				table.insert(outof,outof[cl])
			else
				local red = vals > var
				tb[2] = vals.." / "..var
				if red and tb[3] then
					tb[3] = nil
				end
			end
		end
	end
	hook.Add("pac_OnPartCreated","PACRES_Add",function(part)
		pcall(OnPartCreated,part)
	end)
	local function OnPartRemove(part)
		if part:GetPlayerOwner() ~= LocalPlayer() then return end
		local cl,tb = part.ClassName
		if values[cl] == nil then return end
		values[cl] = values[cl] - 1
		local vals,var = values[cl],vars[cl]
		if vals == 0 then
			values[cl] = nil
		end
		tb = outof[cl]
		if tb then
			local red = vals > var
			tb[2] = vals.." / "..var
			if red == false and tb[3] == nil then
				tb[3] = SysTime() + 5
			end
		end
	end
	hook.Add("pac_OnPartRemove","PACRES_Rem",function(part)
		pcall(OnPartRemove,part)
	end)
	local txt,wide,total,w,h,st,cur,cnt = "",0,0
	local function Paint()
		if pace.Focused == false then return end
		local count = #outof
		if count == 0 then return end
		total = Lerp(0.1,total,count)
		surface.SetDrawColor(50,50,50,255)
		surface.DrawRect(w-wide,st-cur*2,wide,cur*(total+3))
		surface.SetTextColor(255,255,255,255)
		surface.SetFont("Trebuchet18")
		local syt,cnt = SysTime(),0
		x = surface.GetTextSize(txt)
		surface.SetTextPos(w-wide+4,st-cur*2)
		surface.DrawText(txt)
		wide = 0
		if x > wide then
			wide = x+4
		end
		for k,v in ipairs(outof) do
			if v[3] then
				if v[3] <= syt then
					table.remove(outof,k)
					outof[v[1]] = nil
					continue
				end
				surface.SetTextColor(0,255,0,51*(v[3]-syt))
			else
				surface.SetTextColor(255,0,0,255)
			end
			local txt,x = v[1] .. " " .. v[2]
			x = surface.GetTextSize(txt)
			if x > wide then
				wide = x+8
			end
			surface.SetTextPos(w-x-4,st+cur*cnt)
			surface.DrawText(txt)
			cnt = cnt + 1
		end
	end
	hook.Add("pace_OnOpenEditor","PACRES_Editor",function()
		txt = langs.Integrate or ""
		local pnl = pace.Editor
		if not ValidPanel(pnl) or not pace.Active then
			return
		end
		w,h=ScrW()*0.99,ScrH()
		st,cur = h*0.1,h*0.023
		hook.Add("HUDPaint","PACRES_Draw",Paint)
		local oldf = pnl.OnRemove
		function pnl:OnRemove()
			oldf(self)
			hook.Remove("HUDPaint","PACRES_Draw")
		end
	end)
end
hook.Add("Initialize","InjectCode",function()
	local ok = pcall(Initialize)
	if not ok then
		timer.Simple(5,function() Initialize() end)
	end
end)