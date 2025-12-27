module("pacres", package.seeall)
concommand.Add("pacres_gui",function(ply)
	if not ply:IsSuperAdmin() then return false end
	net.Start("PAC3RESCTRL")
	net.WriteUInt(1,2)
	local tbl = table.Copy(restricts)
	for _,v in pairs(tbl) do
		v[1] = nil
	end
	net.WriteTable(tbl)
	local lang = LangsQueue[ply:EntIndex()] or ply:GetInfo("pacres_lang")
	local str = util.Compress(table.concat(GetPhrase(lang,"GUI"),'\\'))
	net.WriteUInt(#str,12)
	net.WriteData(str,#str)
	net.Send(ply)
end)
net.Receive("PAC3RESCTRL",function(len,ply)
	if not IsValid(ply) then return end
	if not ply:IsSuperAdmin() then return end
	local int,gr,var = net.ReadUInt(2),net.ReadString()
	if gr == nil then return end
	if int > 0 then
		if int ~= 3 then
			var = net.ReadString()
			if var == nil then return end
		end
		if restricts[gr] == nil then
			return
		end
	end
	if int == 0 then
		if restricts[gr] then
			return
		end
		restricts[gr] = {}
		local from,base = net.ReadString(),net.ReadBool()
		if from and restricts[from] then
			if base then
				CreateRestrict(gr,table.Copy(restricts[from]),restricts)
			else
				CreateRestrict(gr,{["derive"]=from},restricts)
			end
			if not CheckRestricts(gr) then
				SendRestrict(nil,gr,true)
			end
		else
			SendRestrict(nil,gr,true)
		end
	elseif int == 1 or int == 2 then
		local bool,tbl = int == 1,restricts[gr]
		if av[var] == 0 then
			SetBool(tbl,var,bool)
		else
			if bool then
				tbl[var] = net.ReadUInt(16)
			else
				tbl[var] = nil
			end
		end
		if shared[var] then
			SendRestrict(nil,gr,not bool,{[0]=var,[1]=tbl[var]})
		end
	elseif int == 3 then
		CheckRestricts(gr,true)
		restricts[gr] = nil
		RemoveRecursive(restricts,gr)
		SendRestrict(nil,gr,true)
	end
	QueueSaving()
end)