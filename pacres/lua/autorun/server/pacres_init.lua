module("pacres", package.seeall)
local timeout,pairs,next = CreateConVar("pacres_timeout",10,{FCVAR_ARCHIVE},"Timeout for outfit content in seconds"),pairs,next
function CreateRestrict(nm,gr,gl)
	local derive = gr["derive"]
	if derive then
		gr[1] = gl[derive]
		restricts[nm] = setmetatable(gr,meta)
	else
		restricts[nm] = gr
	end
end
local function GetLang(path)
	if file.Find(path,"LSV") then
		local e,f,g = pcall(include,path)
		if not e then
			return false,ErrorNoHalt(path.." file corrupted!"..(f and "\n\t"..f or ""))
		end
		return f,g
	else
		return false
	end
end
Langs,LangsQueue=Langs or {},LangsQueue or {}
function GetPhrase(lang,index)
	return Langs[lang] and Langs[lang][index] or Langs["en"][index]
end
function LoadData()
	if file.Exists("pac3restricts.txt","DATA") then
		local tb = util.JSONToTable(file.Read("pac3restricts.txt","DATA"))
		if tb then
			for _,v in pairs(tb) do
				for k in pairs(v) do
					if av[k] == nil and k ~= "derive" then
						tb[_][k] = nil
					end
				end
			end
			restricts = {}
			for k,v in pairs(tb) do
				if type(k) == "number" then
					tb[tostring(k)] = v
					tb[k] = nil
				end
				CreateRestrict(k,v,tb)
			end
			restricts = tb
		end
	end
	if restricts == nil then
		restricts = {[def:GetString()]={}}
	end
	for _,name in pairs(file.Find("pacres_langs/*.lua","LSV")) do
		local lang = GetLang("pacres_langs/"..name)
		if lang then
			Langs[string.StripExtension(name)] = lang
		end
	end
end
if restricts == nil then
	LoadData()
end
local function SaveRestricts()
	if next(restricts) == nil then
		file.Delete("pac3restricts.txt")
		return
	end
	local tbl = table.Copy(restricts)
	for k,v in pairs(tbl) do
		setmetatable(v,nil)
		v[1] = nil
	end
	local write = util.TableToJSON(tbl)
	if write then
		file.Write("pac3restricts.txt",write)
	end
end
function QueueSaving()
	timer.Create("PAC3RESSAVE",15,1,SaveRestricts)
end
hook.Add("ShutDown","SaveRestricts",function()
	if timer.Exists("PAC3RESSAVE") then
		SaveRestricts()
	end
end)
function GetRestricts(ply)
	local sid,gr,deft = ply:SteamID()
	if restricts[sid] then
		return restricts[sid],sid
	end
	gr = ply:GetUserGroup()
	if restricts[gr] then
		return restricts[gr],gr
	end
	deft = def:GetString()
	if restricts[deft] then
		return restricts[deft]
	end
end
util.AddNetworkString("PAC3RESCTRL")
local function SendLang(ply)
	local ind = ply:EntIndex()
	local lang,tbl = LangsQueue[ind],nil
	if lang == nil then
		lang = ply:GetInfo("pacres_lang") or "en"
		net.WriteBool(true)
		if Langs[lang] then
			LangsQueue[ind]=lang
			tbl = Langs[lang]
		else
			LangsQueue[ind]="en"
			tbl = Langs.en
		end
		for _,v in pairs(LangsSend) do
			net.WriteString(tbl[v])
		end
		LangsQueue[ind]=lang
	else
		net.WriteBool(false)
	end
end
function SendRestrict(ply,gr,sendnil,tbl)
	if ply == nil then
		if gr == nil then
			return
		end
		local def = def:GetString()
		for _,v in pairs(player.GetAll()) do
			local rest,isdef = GetRestricts(v)
			local nl = gr == def or (sendnil and restricts[gr] == nil)
			if rest then
				if (isdef == nil and nl) or isdef == gr then
					SendRestrict(v,nil,sendnil,tbl or rest)
				end
			elseif nl then
				SendRestrict(v,nil,true,tbl)
			end
		end
		return
	end
	local s = tbl or GetRestricts(ply)
	if s then
		if s[0] ~= nil then
			local sh = shared[s[0]]
			if sh == nil then return end
			net.Start("PAC3RESCTRL")
			net.WriteUInt(3,2)
			net.WriteUInt(sh,6)
			if sh <= svcnt then
				net.WriteUInt(s[1] and 1 or 0,1)
			else
				net.WriteUInt(s[1] or 65535,16)
			end
			net.Send(ply)
			return
		end
		if sendnil == nil then
			local contain = nil
			for k,v in pairs(s) do
				if shared[k] then
					contain = true
					break
				end
			end
			if contain == nil then return end
		end
		net.Start("PAC3RESCTRL")
		net.WriteUInt(0,2)
		for _,v in pairs(sendvars) do
			net.WriteUInt(s[v] and 1 or 0,1)
		end
		for k,v in pairs(limits) do
			if s[v] == nil then continue end
			net.WriteUInt(shared[v],6)
			net.WriteUInt(s[v] or 65535,16)
		end
		net.WriteUInt(0,6)
		SendLang(ply)
		net.Send(ply)
	elseif sendnil then
		net.Start("PAC3RESCTRL")
		net.WriteUInt(0,2)
		for _,v in pairs(sendvars) do
			net.WriteUInt(0,1)
		end
		net.WriteUInt(0,6)
		SendLang(ply)
		net.Send(ply)
	end
end
function CheckRestricts(gr,send)
	for k,v in pairs(restricts[gr]) do
		if shared[k] then
			if send == nil then
				SendRestrict(nil,gr)
			end
			return true
		end
	end
	return false
end
local function cvar(ply,cmd,arg)
	if IsValid(ply) then return end
	local val1,val2 = arg[1],arg[2]
	if isstring(val1) then
		if restricts[val1] then
			if val2 then
				local val3 = tonumber(arg[3])
				if val3 == nil then
					MsgN("cfg error: wrong argument #3")
					return
				end
				if av[val2] == 0 then
					local tb,bool = restricts[val1],val3 == 1
					SetBool(tb,val2,bool)
					MsgN("cfg: "..(bool and "enabled" or "disabled").." to "..val1.." limit on "..val2)
				elseif av[arg[2]] then
					restricts[val1][val2] = val3 >= 0 and val3 or nil
					MsgN("cfg: set to "..val1.." limit on "..val2.." = "..restricts[val1][val2])
				else 
					MsgN("cfg error: wrong argument #2")
					return
				end
				if shared[val2] then
					SendRestrict(nil,val1,true)
				end
			else
				CheckRestricts(val1,true)
				restricts[val1] = nil
				RemoveRecursive(restricts,val1)
				SendRestrict(nil,val1,true)
				MsgN("cfg: remove group "..val1)
			end
		else
			restricts[val1] = {}
			local der = ""
			if val2 and restricts[val2] then
				if tonumber(arg[3]) == 1 then
					der = ", based on "..val2
					CreateRestrict(val1,table.Copy(restricts[val2]),restricts)
				else
					der = ", derived from "..val2
					CreateRestrict(val1,{["derive"]=val2},restricts)
				end
				if CheckRestricts(val1) == false then
					SendRestrict(nil,val1,true)
				end
			else
				SendRestrict(nil,val1,true)
			end
			MsgN("cfg: created group "..val1..der)
		end
		QueueSaving()
	else
		MsgN("cfg error: wrong argument #1")
	end
end
function SafetySend(ply,group,sendnil)
	local ok,err = pcall(SendRestrict,ply,group,sendnil)
	if not ok then
		MsgN("Error occured when send restrictions: \n"..err)
	end
end
hook.Add("PlayerInitialSpawn","AddCLRestricts",SafetySend)
UrlCache,PlayerCache = UrlCache or {},PlayerCache or {}
local function CheckTable(a,b,pl,uid)
	if b[8] then
		local nm,ply = b[1].part.self.Name,Entity(pl)
		if not IsValid(ply) then
			PlayerCache[pl] = nil
			return
		end
		local v2,v1,v3 = b[4],b[5],b[7]
		if v1 then
			if next(v1) then
				return
			end
		end
		if v2 then
			a[0] = a[0] + v2
			local max = b[3].size
			if max then
				max = max*1048576
				if a[0] > max then
					table.insert(b[2],string.format(GetPhrase(LangsQueue[pl],"Size"),a[0],max,v2))
				end
			end
		end
		if v3 then
			if a[-1] == nil then
				a[-1] = {}
			end
			for k,v in pairs(v3) do
				a[-1][k] = (a[-1][k] or 0) + v
			end
			for i,j in pairs(a[-1]) do
				local var = b[3][i]
				if var and j > var then
					local val = v3[i] or 0
					table.insert(b[2],string.format(GetPhrase(LangsQueue[pl],"Count"),i,j,var,val))
					a[-1][i] = a[-1][i] - val
				end
			end
		end
		if #b[2] == 0 then
			b[1].allowed = true
			pace.SubmitPart(b[1])
			if v2 and v2 > 0 then
				a[b[1].part.self.UniqueID] = v2
			end
		else
			if v2 then
				a[0] = a[0] - v2
			end
			net.Start("PAC3RESCTRL")
			net.WriteUInt(2,2)
			net.WriteUInt(#b[2],8)
			net.WriteString(nm or "unknown")
			for k,v in pairs(b[2]) do
				net.WriteString(v)
			end
			net.Send(ply)
		end
		a[uid] = nil
	end
end
local function FetchURL(pl,uid,ind,url,code,len)
	if len then
		UrlCache[url] = len
	end
	local a = PlayerCache[pl]
	if a == nil then return end
	local b = a[uid]
	if b == nil then return end
	local c = b[5]
	c[ind] = nil
	if code == 200 then
		b[4] = b[4] + len
	elseif not b[3]["check_url"] then
		if isstring(code) then
			table.insert(b[2],string.format(GetPhrase(LangsQueue[pl],"FailWhy"),url,code))
		else
			table.insert(b[2],string.format(GetPhrase(LangsQueue[pl],"FailCode"),url,code))
		end
	end
	if next(c) == nil then
		CheckTable(a,b,pl,uid)
	end
end
UrlQueue,TimeoutQueue,UrlTemp = UrlQueue or {},TimeoutQueue or {},UrlTemp or {}
local lasturl,AddQueueUrl = 0
function HistoryLookup()
	local _,to = next(TimeoutQueue)
	if _ == nil then
		timer.Remove("PACRESTMR")
		return
	end
	local tme = SysTime()
	if to[1] <= tme then
		FetchURL(to[2],to[3],to[4],to[5],GetPhrase(LangsQueue[to[2]],"Timeout"))
		TimeoutQueue[_] = nil
	end
	local k1 = next(UrlTemp)
	if k1 then
		for k1 in pairs(UrlTemp) do
			local k,v = next(UrlTemp[k1])
			if k then
				if v[1] <= tme then
					AddQueueUrl(v[2],v[3],v[4],v[5],v[6])
					UrlTemp[k1][k] = nil
				end
			else
				UrlTemp[k1] = nil
			end
		end
	else
		local _,to = next(UrlQueue)
		if _ and to < tme then
			UrlQueue[_] = nil
		end
	end
end
AddQueueUrl = function(host,pl,uid,z,url)
	host = host or "unknown"
	local uq,tme = UrlQueue[host],SysTime()
	if uq == nil or uq <= tme then
		local cnt = 0
		UrlQueue[host] = tme + 0.5
		local ind = #TimeoutQueue+1
		if ind == 1 then
			timer.Create("PACRESTMR",0.25,0,HistoryLookup)
		end
		TimeoutQueue[ind] = {tme + timeout:GetFloat(),pl,uid,z,url}
		http.Fetch( url, function( body, len, headers, code )
			TimeoutQueue[ind] = nil
			FetchURL(pl,uid,z,url,code,len)
		end,
		function(err)
			TimeoutQueue[ind] = nil
			FetchURL(pl,uid,z,url,err)
		end)
	else
		if UrlTemp[host] == nil then
			UrlTemp[host] = {}
		end
		local id = #UrlTemp[host]+1
		UrlTemp[host][id] = {tme+0.5*id,host,pl,uid,z,url}
	end
end
function FixURL(url)
	if url:match("(.-%..-)/") == nil then
		return false
	else
		local match = url:match("[%w%.]*%.(%w+%.%w+)") or url:match("(%w+%.%w+)")
		if url:match("^http+s?://") then
			return url,match
		else
			return "://"..url,match
		end
	end
end
local crc=util.CRC
local namet={crc("children"),crc("self"),crc("ClassName"),crc("Model"),crc("Material"),crc("URL"),crc("Sound")}
local function CheckPartUrl(part,pl,uid)
	local b = PlayerCache[pl]
	if b == nil then return end
	b = b[uid]
	if b == nil then return end
	for i,url in pairs(part) do
		if i == namet[3] then
			if av[url] == nil then
				continue
			end
			if b[7] == nil then
				b[7] = {}
			end
			b[7][url] = (b[7][url] or 0) + 1
		elseif i == namet[4] or i == namet[5] or i == namet[6] or i == namet[7] then
			if b[4] == nil then
				b[4],b[5],b[6] = 0,{},{}
			end
			if b[6][url] then
				continue
			end
			b[6][url] = true
			local x, host = FixURL(url)
			if x then
				if b[3].size then
					url,part[i] = x,x
					local y = b[5]
					local z = #y + 1
					y[z] = true
					local a = UrlCache[url]
					if a then
						FetchURL(pl,uid,z,url,200,a)
					else
						AddQueueUrl(host,pl,uid,z,url)
					end
				end
			elseif i == namet[4] and not b[3]["check_models"] then
				if not file.Exists( url, "GAME" ) then
					table.insert(b[2],string.format(GetPhrase(LangsQueue[pl],"FailModel"),url))
				elseif not util.IsValidModel(url) then
					table.insert(b[2],string.format(GetPhrase(LangsQueue[pl],"InvalidModel"),url))
				end
			elseif i == namet[5] and not b[3]["check_materials"] then
				url = "materials/"..url
				local tab = file.Find(url,"GAME")
				if #tab > 0 then
					continue
				end
				table.insert(b[2],string.format(GetPhrase(LangsQueue[pl],"FailMaterial"),url))
			elseif i == namet[7] and not b[3]["check_sounds"] then
				if not file.Exists( url, "GAME" ) then
					table.insert(b[2],string.format(GetPhrase(LangsQueue[pl],"FailSound"),url))
				end
			end
		end
	end
end
local function CheckPart(part,pl,uid,recursive)
	for k,v in pairs(part) do
		if isnumber(k) then
			CheckPart(v,pl,uid,true)
		elseif k == namet[1] then
			CheckPart(v,pl,uid,true)
		elseif k == namet[2] then
			CheckPartUrl(v,pl,uid)
		end
	end
	if recursive == nil then
		local a = PlayerCache[pl]
		if a == nil then return end
		local b = a[uid]
		if b == nil then return end
		b[8] = true
		CheckTable(a,b,pl,uid)
	end
end
local function CountPart(part,pl)
	local c = PlayerCache[pl][-1]
	if c == nil then return end
	for k,v in pairs(part) do
		if isnumber(k) then
			CountPart(v,pl)
		elseif k == namet[1] then
			CountPart(v,pl)
		elseif k == namet[2] then
			for i,j in pairs(v) do
				if i == namet[3] then
					c[j] = (c[j] or 1) - 1
				end
			end
		end
	end
end
function Initialize()
	SubmitPart = SubmitPart or pace.SubmitPart
	function pace.SubmitPart(data, filter)
		data.filter = filter
		return SubmitPart(data, filter)
	end
	local meta = FindMetaTable("Player")
	if meta then
		SetUserGroup = SetUserGroup or meta.SetUserGroup
		function meta:SetUserGroup(group)
			local a = SetUserGroup(self,group)
			SafetySend(self,group,true)
			return a
		end
	end
	SubmitPartNotify = SubmitPartNotify or pace.SubmitPartNotify
	function pace.SubmitPartNotify(data)
		pace.dprint("submitted outfit %q from %s with %i number of children to set on %s", data.part.self.Name or "", data.owner:GetName(), table.Count(data.part.children), data.part.self.OwnerName or "")
		local allowed, reason = pace.SubmitPart(data)
		if data.owner:IsPlayer() then
			if allowed == "queue" then return end
			if not reason and allowed and type(data.part) == 'table' then
				reason = string.format('Your part %q has been applied', data.part.self.Name or '<unknown>')
				net.Start("pac_submit_acknowledged")
					net.WriteBool(allowed)
					net.WriteString(reason or "")
					net.WriteString(data.part.self.Name or "no name")
				net.Send(data.owner)
			end
			hook.Run("PACSubmitAcknowledged", data.owner, util.tobool(allowed), reason or "", data.part.self.Name or "no name", data)
		end
	end
	concommand.Add("pacres_cfg",cvar)
end
hook.Add("Initialize","InjectCode",function()
	local ok = pcall(Initialize)
	if not ok then
		timer.Simple(5,function() Initialize() end)
	end
end)
hook.Add("PrePACConfigApply","CatchURL's",function(pl,dt)
	local ind = pl:EntIndex()
	if dt.allowed then
		dt.allowed = nil
		return true
	end
	local c = PlayerCache[ind]
	if c == nil then
		c = {[0]=0}
		PlayerCache[ind] = c
	end
	local part = dt.part
	if istable(part) then
		if dt.filter ~= true and dt.filter ~= nil then
			dt.filter = nil
			return true
		end
		local rs = GetRestricts(pl)
		if rs and rs["can_use"] then
			return false,GetPhrase(LangsQueue[ind],"Wear")
		end
		if dt.server_only then return true end
		local uid = dt.uid
		if not uid then return true end
		local parts = pace.Parts[uid]
		if parts then
			if next(parts) then
				local unique = part.self.UniqueID
				if unique then
					if parts[unique] then
						if c[unique] then
							c[0] = c[0] - c[unique]
							c[unique] = nil
						end
						CountPart(parts[unique].part,ind)
					end
				end
			else
				c[0] = 0
				if c[-1] then
					table.Empty(c[-1])
				end
			end
		end
		local uid = #c+1
		c[uid]={dt,{},rs or {}}
		CheckPart(part,ind,uid)
		if c[uid] == nil then
			return false
		elseif not c[uid][5] then
			c[uid] = nil
		elseif next(c[uid][5]) then
			return false,GetPhrase(LangsQueue[ind],"Checking")
		else
			c[uid] = nil
		end
	elseif part == "__ALL__" then
		for k,v in pairs(c) do
			c[k] = nil
		end
		c[0] = 0
		if c[-1] then
			table.Empty(c[-1])
		end
	elseif tonumber(part) then
		local uid,parts = dt.uid,pace.Parts[uid]
		if uid and parts and parts[part] then
			if c[part] then
				c[0] = c[0] - c[part]
				c[part] = nil
			end
			CountPart(parts[part].part,ind)
		end
	end
	return true
end)
hook.Add("PlayerDisconnected","RemoveCache",function(ply)
	local ind = ply:EntIndex()
	if ind then
		PlayerCache[ind] = nil
		LangsQueue[ind] = nil
	end
end)