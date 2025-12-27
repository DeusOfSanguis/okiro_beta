/* 
- Product of osgmod.com -
Script create by Nordahl you can find here : https://osgmod.com/gmod-scripts/1402/job-whitelist-system
Profile page of the Creator : https://osgmod.com/profiles/76561198033784269

Gmod Script Market Place : https://osgmod.com/gmod-scripts/page-1

- Do not duplicate or reproduce.
- By buying my scripts you contribute to the creations and the updates
- Dont leak, Lack of recognition fuelled by thanks does not bring food to the table
- Respect my work please

Code Minified with Originahl-Scripts Software : https://osgmod.com/en/help/code-minification-optimisation

The satisfied members who offered the coffee and supported me : https://osgmod.com/coffee
*/

local cfg=nordahl_cfg_1402
local Nordah_Whitelist_Job = {}

cfg.first_read=nil

local Add_Job_In_the_Whiteliste = {}
local Add_JobGroup_In_the_Whiteliste = {}
ZJOBwhitelist=ZJOBwhitelist or {}

local ztvo=0.001 --More this number is big more the download of data is slow. antivorflow system. Default value is 0.01 (0 = zero second of delay Too much information is sent your crash server if you have a big list)

local function eRight(a)
return cfg.StaffSteamID64[a:SteamID64()] or cfg.Usergroups_Access[a:GetUserGroup()] or cfg.JOB_Access_rank[team.GetName( a:Team() )] or (cfg.Allow_Admin==1 and a:IsAdmin()) or (cfg.Allow_SUPER_Admin==1 and a:IsSuperAdmin())
end

local norrep=0
local function optim(a,b,c)
if a==nil or eRight(a)==true then
if c[1]==nil then
if norrep==0 then norrep=norrep+1 
print("Nordahl: 'Hello, :) Your command is not complet. Instert the number of month to delete the old entries, like 'whitelist_suppressor_oldentries 4' to remove entries older than 4 months. Don't make me repeat please. ^^'") 
elseif norrep==1 then norrep=norrep+1 
print("Nordahl: 'You?  Read my previous message please... USES THE NUMBERS!!!'")
elseif norrep==2 then norrep=norrep+1 
print("Nordahl: 'Anyway... Good luck :3'")
else
print("Nordahl: '...'")
end
return end
local m=os.date("%m")-c[1]
local y
local mo
if m<=0 then
m=m+12
y=(os.date("%Y")-1)
else
y=(os.date("%Y"))
end
if m<10 then mo="0" else mo="" end
local res=os.date(y.." / "..mo..m.." / %d")
print("All entrie more old than '(YYYY / MM / DD) "..os.date(y.." / "..mo..m.." / %d").."' will be deleted")
for k,v in pairs(ZJOBwhitelist)do
local n=string.Explode( " / ", v[5] )
local nomb=0
if os.date(n[1].." / "..n[2].." / "..n[3])<=res then
nomb=nomb+1
table.remove(ZJOBwhitelist,k)
print("Whitelist Job number Entries deleted: "..nomb)
end
end
file.Write( "zwhitelistjobdata/whitelistjob.txt",util.TableToJSON(ZJOBwhitelist))
end
end
concommand.Add("whitelist_suppressor_oldentries",optim)

if cfg.USeWorkshopContent==1 then
resource.AddWorkshop("493897275")
end


local function FX(ply)
ply:ConCommand("whitelist_systemjob")
return false end

if cfg.FX_to_Open=="F1" then
hook.Add("ShowHelp","norda_whitelistjob_F1",FX)
elseif cfg.FX_to_Open=="F2" then
hook.Add("ShowTeam","norda_whitelistjob_F2",FX)
elseif cfg.FX_to_Open=="F3" then
hook.Add("ShowSpare1","norda_whitelistjob_F3",FX)
elseif cfg.FX_to_Open=="F4" then
hook.Add("ShowSpare2","norda_whitelistjob_F4",FX)
end

if cfg.first_read==nil then
cfg.first_read=1
ZJOBwhitelist={}
local str= file.Read( "zwhitelistjobdata/whitelistjob.txt", "DATA" )
if str==nil then
file.CreateDir("zwhitelistjobdata")
file.Write( "zwhitelistjobdata/whitelistjob.txt", "[]" )
else
local tbl = util.JSONToTable( str )
for k,v in pairs(tbl)do
table.insert(ZJOBwhitelist,v)
end
end

Add_Job_In_the_Whiteliste = {}
local str= file.Read( "zwhitelistjobdata/jobsetting.txt", "DATA" )
if str==nil then
file.CreateDir("zwhitelistjobdata")
file.Write( "zwhitelistjobdata/jobsetting.txt", "[]" )
else
local tbl = util.JSONToTable( str )
for i,o in pairs(tbl)do
Add_Job_In_the_Whiteliste[i]=o
end
end

Add_JobGroup_In_the_Whiteliste = {}
local str= file.Read( "zwhitelistjobdata/jobgroupsetting.txt", "DATA" )
if str==nil then
file.CreateDir("zwhitelistjobdata")
file.Write( "zwhitelistjobdata/jobgroupsetting.txt", "[]" )
else
local tbl = util.JSONToTable( str )
for i,o in pairs(tbl)do
Add_JobGroup_In_the_Whiteliste[i]=o
end
end
end

function Nordah_Whitelist_Job.AddCommand( func, name )
local newfunc = function( ply, cmd, args ) 
local target = Nordah_Whitelist_Job.GetPlayer( args[1] )
if name=="wjs_goto" or name=="wjs_bring" then 
else
if not target or not eRight(ply) or(ply==target and name=="wjs_superadmin") then return end 
end
func( ply, cmd, args ) 
end
concommand.Add( name, newfunc )
end

function Nordah_Whitelist_Job.GetPlayer( id )
if id==nil then return end
local ply = Entity( id )
if not IsValid( ply ) or not ply:IsPlayer() then return end
return ply
end
Nordah_Whitelist_Job.Commands = {}
--Nordah_Whitelist_Job.Tabs = {}
function Nordah_Whitelist_Job.RegisterCommand( name, commandname, chatcmd, args, override )
table.insert( Nordah_Whitelist_Job.Commands, { Name = name, CommandName = commandname, ChatCmd = chatcmd, Args = args, ArgOverride = override } )
end

util.AddNetworkString("SynchAllJobWhitelisted")
util.AddNetworkString("SynchAddJobwhitelist")
util.AddNetworkString("NSynchAddJob")
util.AddNetworkString("NSynchAddJob2")
local function JobWriteToFile()
timer.Create("nord_wl_noflood",0.2,1,function()
file.Write( "zwhitelistjobdata/whitelistjob.txt",util.TableToJSON(ZJOBwhitelist))
MsgN( "[Update Plugin] Whitelist.")
end)
end
local function JobListToFile()
file.Write( "zwhitelistjobdata/jobsetting.txt",util.TableToJSON(Add_Job_In_the_Whiteliste))
MsgN( "[Update Plugin] JobList.")
end
local function JobGrListToFile()
file.Write( "zwhitelistjobdata/jobgroupsetting.txt",util.TableToJSON(Add_JobGroup_In_the_Whiteliste))
MsgN( "[Update Plugin] JobList.")
end
local function JobSynchAddwhite(pl,id,rs,met,date,remove)
net.Start("SynchAddJobwhitelist")
net.WriteString(pl)
net.WriteString(id)
net.WriteString(rs)
net.WriteString(met)
net.WriteString(date)
net.WriteBit(tobool(remove))
net.Broadcast()
end

function Nordah_Whitelist_Job.AddWhitelist(tbl)
local heisinjob=false
for k,v in pairs(ZJOBwhitelist)do
if (v[2]==tbl[2])and(tbl[4]==v[4])then
MsgN( "TRUE")
heisinjob=true
--return
end
end
print("Pass")
if heisinjob==true then
MsgN( "[Update Plugin] msg id 1: Whitelist is not updated because this user exist in this list of Job.")
return
end

table.insert(ZJOBwhitelist,tbl)
JobWriteToFile()
JobSynchAddwhite(tbl[1],tbl[2],tbl[3],tbl[4],tbl[5])
end
function Nordah_Whitelist_Job.RemoveJobWhitelist(steamid,job)
for k,v in pairs(ZJOBwhitelist)do
if v[2]==steamid and v[4]==job then
table.remove(ZJOBwhitelist,k)
JobWriteToFile()
JobSynchAddwhite(steamid,"","","","",true)
return
end
end
end
function Nordah_Whitelist_Job.RemoveJobWhitelist5(steamid)
JobSynchAddwhite(steamid,"","","","",true)
end
local function RemoveJobWhitelist(ply,cmd,args)
if not eRight(ply) or not args[1]then return end
Nordah_Whitelist_Job.RemoveJobWhitelist(args[1],args[2])
end
concommand.Add("wjs_remove_whitelist",RemoveJobWhitelist)
local function AddWhitelist(ply,cmd,args)
if not eRight(ply) or not args[1]or not args[2]then return end
Nordah_Whitelist_Job.AddWhitelist{ply:Name(),args[1],args[2],args[3],tostring( os.date("%Y / %m / %d") )}
end
concommand.Add("wjs_add_whitelist",AddWhitelist)

local function Metajourmalist(a,b,c)
if eRight(a)==true then
if tostring(c[2])=="0" then
Add_Job_In_the_Whiteliste[c[1]]=nil
else
Add_Job_In_the_Whiteliste[c[1]]=c[2]
end
for k,v in pairs( player.GetAll() ) do
if eRight(v)==true then
net.Start("NSynchAddJob")net.WriteString(c[1])net.WriteString(c[2])net.Send(v)
end
end
JobListToFile()
end
end
concommand.Add("Metajourmalist",Metajourmalist)

local function Metajourmalist2(a,b,c)
if eRight(a)==true then
if tostring(c[2])=="-1" then
Add_JobGroup_In_the_Whiteliste[c[1]]=nil
else
Add_JobGroup_In_the_Whiteliste[c[1]]=c[2]
end
for k,v in pairs( player.GetAll() ) do
if eRight(v)==true then
net.Start("NSynchAddJob2")net.WriteString(c[1])net.WriteString(c[2])net.Send(v)
end
end
JobGrListToFile()
end
end
concommand.Add("Metajourmalist2",Metajourmalist2)

local function get_j_t(j_nu)
for k,v in SortedPairsByMemberValue(team.GetAllTeams(), "Name") do
if "Citizen"!=v.Name then
if j_nu==nil or "0" then
Add_Job_In_the_Whiteliste[v.Name]=j_nu
elseif j_nu=="1" then
Add_Job_In_the_Whiteliste[v.Name]=j_nu
elseif j_nu=="2" then
Add_Job_In_the_Whiteliste[v.Name]=j_nu
elseif j_nu=="3" then
Add_Job_In_the_Whiteliste[v.Name]=j_nu
end
end
end
JobListToFile()
end

local function Metajrmalist_G(a,b,c)
if eRight(a)==true then
local j_nu=tostring(c[1])
get_j_t(j_nu)
for k,v in pairs( player.GetAll() ) do
if eRight(v)==true then
v:ConCommand("Metajolist_f_G "..j_nu)
end
end
end
end
concommand.Add("Metajrmalist_G",Metajrmalist_G)

local function MetajolistDe(a,b,c)
if eRight(a)==true then
Add_Job_In_the_Whiteliste={}
for k,v in pairs( player.GetAll() ) do
if eRight(v)==true then
v:ConCommand("Metajolistcl")
end
end
JobListToFile()
end
end
concommand.Add("MetajolistDe",MetajolistDe)

local function MetajogrlistDe(a,b,c)
if eRight(a)==true then
Add_JobGroup_In_the_Whiteliste={}
for k,v in pairs( player.GetAll() ) do
if eRight(v)==true then
v:ConCommand("Metajogrlistcl")
end
end
JobGrListToFile()
end
end
concommand.Add("MetajogrlistDe",MetajogrlistDe)

function sysjobwhitelist(ply,nom,aze)
if eRight(ply)==true then
if aze[1]==nil then
aze[1]="1"
end
file.Write("zmodserveroption/sysjobwhitelist.txt",tostring(aze[1]))
gmjobwhitel=tostring(aze[1])
for k,v in pairs ( player.GetAll() ) do
v:ConCommand("ntsysjobwi "..tostring(aze[1]))
end
hookselection()
end
end
concommand.Add("sysjobwhitelist",sysjobwhitelist)

function syscatwhitelist(ply,nom,aze)
if eRight(ply)==true then 
file.Write("zmodserveroption/syscatwhitelist.txt",tostring(aze[1]))
gmcatwhitel=tostring(aze[1])
for k,v in pairs ( player.GetAll() ) do
v:ConCommand("ntsyscatwi "..tostring(aze[1]))
end
hookselection()
end
end
concommand.Add("syscatwhitelist",syscatwhitelist)

local files=file.Read("zmodserveroption/sysjobwhitelist.txt", "DATA")
if (!files) then
file.CreateDir("zmodserveroption")
file.Write("zmodserveroption/sysjobwhitelist.txt","1")
gmjobwhitel="1"
else
gmjobwhitel=file.Read("zmodserveroption/sysjobwhitelist.txt","DATA")
end

local files=file.Read("zmodserveroption/syscatwhitelist.txt", "DATA")
if (!files) then
file.CreateDir("zmodserveroption")
file.Write("zmodserveroption/syscatwhitelist.txt","1")
gmcatwhitel="1"
else
gmcatwhitel=file.Read("zmodserveroption/syscatwhitelist.txt","DATA")
end

function API_Whitelistjob_nordahl(a,meti,cat)
local pass,passmsg=false,"X"
if gmcatwhitel=="1" then
if cat then
local d=Add_JobGroup_In_the_Whiteliste[cat]
if d=="1" then
	if PlychangeAllowed(a,cat)!=true then
	pass,passmsg=false,"You are not in Whitelist of the categorie '"..cat.."'"
	else
	pass,passmsg= true,"Good"
	end
elseif d=="2" then
	pass,passmsg= false,"CATEGORIE LOCKED '"..cat.."'"
elseif d=="3" then
	if PlychangeAllowed2(a,cat)!=true then
	pass,passmsg= false,"Categorie reserved for the donators"
	else
	pass,passmsg= true,"Good"
	end
elseif d=="4" then
	if PlychangeAllowed3(a,cat)==true then
	pass,passmsg= false,"You are blacklisted of this categorie"
	else
	pass,passmsg= true,"Good"
	end
end
end
end
if meti and pass==false then
local d=Add_Job_In_the_Whiteliste[meti]
if d=="1" then
	if PlychangeAllowed(a,meti)!=true then
	pass,passmsg= false,"You are not Whitelisted"
	else
	pass,passmsg= true,"Good"
	end
elseif d=="2" then
	pass,passmsg= false,"JOB LOCKED"
elseif d=="3" then
	if PlychangeAllowed2(a,meti)!=true then
	pass,passmsg= false,"Job reserved for the donators"
	else
	pass,passmsg= true,"Good"
	end
elseif d=="4" then
	if PlychangeAllowed3(a,meti)==true then
	pass,passmsg= false,"You are blacklisted of this job"
	else
	pass,passmsg= true,"Good"
	end
elseif d==nil then
	pass,passmsg= true,"Good"
end
	else pass,passmsg= true,"Good"
end
a:ConCommand('jswl_chat3 "'..passmsg..'"')
return pass,passmsg
end
print("Nordahl JOB WhiteList System API: Good")

function hookselection()
if cfg.overrides_custom_heck==0 then print("cfg.overrides_custom_heck is == 0 the system is disabled") return end

if gmjobwhitel=="1" then
print("Nordahl Whitelist Job System: Enabled")
if gmcatwhitel=="1" then
print("Nordahl Whitelist Addon Category(Job) System: Enabled")
else
print("Nordahl Whitelist Addon Category(Job) System: Disabled")
end

hook.Add("playerCanChangeTeam", "Nordahl_Job_Whitelist1", function(a,b,c)
local pass,passmsg=nil,"X"
local meti=team.GetAllTeams()[b].Name
local auth_ulx=cfg.Allow_ACCESS_ULXRANK_IN_JOB[meti]
if auth_ulx then
if auth_ulx[a:GetUserGroup()] then
pass,passmsg=true,"Accepted by Allow_ACCESS_ULXRANK_IN_JOB"
end
end
if gmcatwhitel=="1" then
local cat=RPExtraTeams[b].category
local d=Add_JobGroup_In_the_Whiteliste[cat]
if d=="1" then
if PlychangeAllowed(a,cat)!=true then
pass,passmsg= false,"You are not in Whitelist of the categorie '"..cat.."'"
end
elseif d=="2" then
pass,passmsg= false,"CATEGORIE LOCKED '"..cat.."'"
elseif d=="3" then
if PlychangeAllowed2(a,cat)!=true then
pass,passmsg= false,"Categorie reserved for the donators"
end
elseif d=="4" then
if PlychangeAllowed3(a,cat)==true then
pass,passmsg= false,"You are blacklisted of this categorie"
end
end
end
if pass==nil then
pass,passmsg=true,"X"
local d=Add_Job_In_the_Whiteliste[meti]
if d then
if d=="1" then
if PlychangeAllowed(a,meti)!=true then
pass,passmsg= false,"You are not Whitelisted"
end
elseif d=="2" then
pass,passmsg= false,"JOB LOCKED"
elseif d=="3" then
if PlychangeAllowed2(a,meti)!=true then
pass,passmsg= false,"Job reserved for the donators"
end
elseif d=="4" then
if PlychangeAllowed3(a,meti)==true then
pass,passmsg= false,"You are blacklisted of this job"
end
end
end
end
return pass,passmsg
end)
else
print("Nordahl Whitelist Job System: Disabled")
hook.Remove("playerCanChangeTeam","Nordahl_Job_Whitelist1")
end
end

hookselection()

/* OLD
function API_Whitelistjob_nordahl(a,meti,cat)
if gmcatwhitel=="1" then
if cat then
local d=Add_JobGroup_In_the_Whiteliste[cat]
if d=="1" then
	if PlychangeAllowed(a,cat)!=true then
	a:ConCommand('jswl_chat3 "You are not in Whitelist of the categorie, '..cat..'"')
	return false,"You are not in Whitelist of the categorie '"..cat.."'"
	else
	a:ConCommand('jswl_chat3 "Good"')
	return true,"Good"
	end
elseif d=="2" then
	a:ConCommand('jswl_chat3 "CATEGORIE LOCKED, '..cat..'"')
	return false,"CATEGORIE LOCKED '"..cat.."'"
elseif d=="3" then
	if PlychangeAllowed2(a,cat)!=true then
	a:ConCommand('jswl_chat3 "Categorie reserved for the donators"')
	return false,"Categorie reserved for the donators"
	else
	a:ConCommand('jswl_chat3 "Good"')
	return true,"Good"
	end
elseif d=="4" then
	if PlychangeAllowed3(a,cat)==true then
	a:ConCommand('jswl_chat3 "You are blacklisted of this categorie"')
	return false,"You are blacklisted of this categorie"
	else
	a:ConCommand('jswl_chat3 "Good"')
	return true,"Good"
	end
end
end
end
if meti then
local d=Add_Job_In_the_Whiteliste[meti]
if d=="1" then
	if PlychangeAllowed(a,meti)!=true then
	a:ConCommand('jswl_chat3 "You are not Whitelisted"')
	return false,"You are not Whitelisted"
	else
	a:ConCommand('jswl_chat3 "You are in Whitelist')
	return true,"Good"
	end
elseif d=="2" then
	a:ConCommand('jswl_chat3 "JOB LOCKED"')
	return false,"JOB LOCKED"
elseif d=="3" then
	if PlychangeAllowed2(a,meti)!=true then
	a:ConCommand('jswl_chat3 "Job reserved for the donators"')
	return false,"Job reserved for the donators"
	else
	a:ConCommand('jswl_chat3 "Good"')
	return true,"Good"
	end
elseif d=="4" then
	if PlychangeAllowed3(a,meti)==true then
	a:ConCommand('jswl_chat3 "You are blacklisted of this job"')
	return false,"You are blacklisted of this job"
	else
	a:ConCommand('jswl_chat3 "Good"')
	return true,"Good"
	end
elseif d==nil then
a:ConCommand('jswl_chat3 "Job Not whitelisted"')
	return true,"Good"
end
--a:ConCommand('jswl_chat3 "Good"')
	else return true,"Good"
end
return false,"X"
end
print("Nordahl JOB WhiteList System API: Good")

function hookselection()
if cfg.overrides_custom_heck==0 then print("cfg.overrides_custom_heck is == 0 the system is disabled") return end

if gmjobwhitel=="1" then
print("Nordahl Whitelist Job System: Enabled")
if gmcatwhitel=="1" then
print("Nordahl Whitelist Addon Category(Job) System: Enabled")
else
print("Nordahl Whitelist Addon Category(Job) System: Disabled")
end

hook.Add("playerCanChangeTeam", "Nordahl_Job_Whitelist1", function(a,b,c)
local meti=team.GetAllTeams()[b].Name
local auth_ulx=cfg.Allow_ACCESS_ULXRANK_IN_JOB[meti]
if auth_ulx then
if auth_ulx[a:GetUserGroup()] then
return true
end
end
if gmcatwhitel=="1" then
local cat=RPExtraTeams[b].category
local d=Add_JobGroup_In_the_Whiteliste[cat]
if d=="1" then
if PlychangeAllowed(a,cat)!=true then
return false,"You are not in Whitelist of the categorie '"..cat.."'"
end
elseif d=="2" then
return false,"CATEGORIE LOCKED '"..cat.."'"
elseif d=="3" then
if PlychangeAllowed2(a,cat)!=true then
return false,"Categorie reserved for the donators"
end
elseif d=="4" then
if PlychangeAllowed3(a,cat)==true then
return false,"You are blacklisted of this categorie"
end
end
end

local d=Add_Job_In_the_Whiteliste[meti]
if d=="1" then
if PlychangeAllowed(a,meti)!=true then
return false,"You are not Whitelisted"
end
elseif d=="2" then
return false,"JOB LOCKED"
elseif d=="3" then
if PlychangeAllowed2(a,meti)!=true then
return false,"Job reserved for the donators"
end
elseif d=="4" then
if PlychangeAllowed3(a,meti)==true then
return false,"You are blacklisted of this job"
end
end
end)
else
print("Nordahl Whitelist Job System: Disabled")
hook.Remove("playerCanChangeTeam","Nordahl_Job_Whitelist1")
end
end
*/

if cfg.Donator_Rank_Tester==1 then
function nordahl_donator_rank_tester(ply,b,c)
MsgAll("-------nordahl_donator_tester BEGIN---")MsgAll(" ")
MsgAll("1.Script Test:")
MsgAll("    1.1) Your user Rank=                                                           ",ply:GetUserGroup())
MsgAll("    1.2) Donator Rank name set in the script line 48: cfg.ULX_DONATOR_RANK= ",cfg.ULX_DONATOR_RANK)
MsgAll("    1.3) Your user Group is = Donator Rank set in the script:                      ",ply:GetUserGroup() == cfg.ULX_DONATOR_RANK)
MsgAll(" ")
MsgAll("2.In Some Words:")
local fonctionne=false
for _,c in ipairs(cfg.ULX_DONATOR_RANK)do
if c==ply:GetUserGroup() then
fonctionne=true
end 
end

if fonctionne==true then
MsgAll("    2.1) Work for your rank:                                                        "..ply:GetUserGroup())
else
MsgAll("    2.1) Dont work for you, you are    :                                            "..ply:GetUserGroup())
MsgAll("    2.1) If you are donator it's supposed work Go line 48 change the word 'donator' to fix it.")
end

MsgAll(" ")
MsgAll("------nordahl_donator_tester FINISHED-------")

end
concommand.Add("nordahl_donator_rank_tester",nordahl_donator_rank_tester)
end

function CatpchangeAllowed(ply,job)
local SteamID64=ply:SteamID64()
local Job=job
for k,v in pairs(ZJOBwhitelist)do
if v[2]==SteamID64 then
if Job==v[4] or v[4]=="Full Access" then
return true
end
end
end
if Add_Job_In_the_Whiteliste[Job]=="3" then
for _,c in ipairs(cfg.ULX_DONATOR_RANK)do if c==ply:GetUserGroup() then return true end end
end
return false
end

function PlychangeAllowed(ply,job)
local SteamID64=ply:SteamID64()
local Job=job
for k,v in pairs(ZJOBwhitelist)do
if v[2]==SteamID64 then
if Job==v[4] or v[4]=="Full Access" then
return true
end
end
end
if Add_Job_In_the_Whiteliste[Job]=="3" then
for _,c in ipairs(cfg.ULX_DONATOR_RANK)do if c==ply:GetUserGroup() then return true end end
end
return false
end
concommand.Add("PlychangeAllowed",PlychangeAllowed)

function PlychangeAllowed2(a,b)
local SteamID64=a:SteamID64()
local d=b
for k,v in pairs(ZJOBwhitelist)do
if v[2]==SteamID64 then
if v[4]=="Full Access" then
return true
end
end
end
if Add_Job_In_the_Whiteliste[d]=="3" then
for _,c in ipairs(cfg.ULX_DONATOR_RANK)do if c==a:GetUserGroup() then return true end end
end
return false
end

function PlychangeAllowed3(ply,job)
local SteamID64=ply:SteamID64()
local Job=job
for k,v in pairs(ZJOBwhitelist)do
if v[2]==SteamID64 then
if Job==v[4] then
return true
end
end
end
return false
end

function CAddWhiteList(a,b,c)
if a:IsPlayer() then
if eRight(a)==false then
print("You Are Not Admin")
return
end
end
for k,v in pairs(ZJOBwhitelist)do
if v[2]==c[2] then
if c[4]==v[4] then
print("SteamID64 already exists for this job")
return
end
end
end

if c[1]==nil then
print("[Your command is not complet] Your Sended: Addwhitelist ??? ??? ??? ???")
print("The Format of Complet Command: Addwhitelist "..'"'.."Yourname"..'"'.." "..'"'.."SteamID64"..'"'.." "..'"'.."Nameofplayer"..'"'.." "..'"'.."JobName"..'"'.."")
return
end
if c[2]==nil then
print("[Your command is not complet]Your Sended: Addwhitelist Yourname ??? ??? ???")
print("The Format of Complet Command: Addwhitelist "..'"'.."Yourname"..'"'.." "..'"'.."SteamID64"..'"'.." "..'"'.."Nameofplayer"..'"'.." "..'"'.."JobName"..'"'.."")
return
end
if c[3]==nil then
print("[Your command is not complet]Your Sended: Addwhitelist Yourname SteamID64 ??? ???")
print("The Format of Complet Command: Addwhitelist "..'"'.."Yourname"..'"'.." "..'"'.."SteamID64"..'"'.." "..'"'.."Nameofplayer"..'"'.." "..'"'.."JobName"..'"'.."")
return
end
if c[4]==nil then
print("[Your command is not complet]Your Sended: Addwhitelist Yourname SteamID64 Nameofplayer ???")
print("The Format of Complet Command: Addwhitelist "..'"'.."Yourname"..'"'.." "..'"'.."SteamID64"..'"'.." "..'"'.."Nameofplayer"..'"'.." "..'"'.."JobName"..'"'.."")
return
end
Nordah_Whitelist_Job.AddWhitelist({c[1],c[2],c[3],c[4],tostring( os.date("%Y / %m / %d") )})
end
concommand.Add("Addwhitelist",CAddWhiteList)

-- function CAddWhiteList2(a,b,c)
-- for k,v in pairs(ZJOBwhitelist)do
-- if v[2]==c[2] then
-- if c[4]==v[4] then
-- print("SteamID64 already exists for this job")
-- return
-- end
-- end
-- end
-- Nordah_Whitelist_Job.AddWhitelist({c[1],c[2],c[3],c[4],tostring( os.date("%Y / %m / %d") )})
-- end
-- CAddWhiteList2(user,b,{"System",a:SteamID64(),a:Nick(),"Job Name"})

function CMassRemovewhitelist(a,b,c)
if a:IsPlayer() then
if eRight(a)==false then
print("You Are Not Admin")
return
end
end
if c[1]==nil then
print("[Your command is not complet] Your Sended: Massremovewhitelist ???")
print("Where is the STEAM64? Replace ??? by steamid64")
return
end
print("Nordahl_Whitelist_Job_system: Massremovewhitelist")
local function testencore()
for k,v in pairs(ZJOBwhitelist)do
if v[2]==c[1] and (!c[2] or c[2]==v[4]) then
print(v[2].." Is removed from "..v[4])
table.remove(ZJOBwhitelist,k)
Nordah_Whitelist_Job.RemoveJobWhitelist5(c[1])
testencore()
return
end
end
end
testencore()

for k,v in pairs(player.GetAll())do
if v:SteamID64()==c[1] then
v:ConCommand("jswl_chat "..v:EntIndex().." 3 nil")
end
end

file.Write( "zwhitelistjobdata/whitelistjob.txt",util.TableToJSON(ZJOBwhitelist))
end
concommand.Add("Massremovewhitelist",CMassRemovewhitelist)
--76561197960265732
PrintTable(ZJOBwhitelist)

local function cleanup_joblist(a,b,c)
if a:IsPlayer() then
if eRight(a)==false then
print("You Are Not Admin")
return
else
for k,v in pairs(ZJOBwhitelist)do
if v[4]==c[1] then
ZJOBwhitelist[k]=nil
end
end
print("Whitelist Job System: '"..c[1].."' CLEANUP DONE")
file.Write( "zwhitelistjobdata/whitelistjob.txt",util.TableToJSON(ZJOBwhitelist))
end
else
for k,v in pairs(ZJOBwhitelist)do
if v[4]==a then
ZJOBwhitelist[k]=nil
end
end
print("Whitelist Job System: '"..a.."' CLEANUP DONE")
file.Write( "zwhitelistjobdata/whitelistjob.txt",util.TableToJSON(ZJOBwhitelist))
end
end
concommand.Add("cleanup_joblist",cleanup_joblist)



local function AddWhiteListPlayer(ply,cmd,args)
local target=Nordah_Whitelist_Job.GetPlayer(args[1])
if target then
if eRight(ply)==true then
local reason=""
for i=2,#args do
reason=reason..tostring(args[i])
end
local heisinjob=false
for k,v in pairs(ZJOBwhitelist)do
if (v[2]==target:SteamID64())and(args[2]==v[4])then
MsgN( "TRUE")
heisinjob=true
--return
end
end
print("Pass")
if heisinjob==true then
MsgN( "[Update Plugin] msg id 2: Whitelist is not updated because this user exist in this list of Job.")
return
end

if IsValid(target) then
if cmd=="wjs_addwhite" then
target:ConCommand('jswl_chat '..target:EntIndex()..' 1 "'..args[2]..'"')
else
target:ConCommand('jswl_chat2 '..target:EntIndex()..' 1 "'..args[2]..'"')
end
end


MsgAll("[JOB Whitelist Plugin] "..target:GetName().." was added in Job-WhiteList by ",ply)
Nordah_Whitelist_Job.AddWhitelist{ply:Name(),target:SteamID64(),target:Name(),args[2],tostring( os.date("%Y / %m / %d") )}
elseif eRight(ply)==true then
admincommandst(ply)
end
end
end
Nordah_Whitelist_Job.AddCommand(AddWhiteListPlayer,"wjs_addwhite")
Nordah_Whitelist_Job.AddCommand(AddWhiteListPlayer,"wjs_addwhite2")

local function AddWhitewjs_addbuto(ply,cmd,args)
local identifiant=args[1]
local lenom=args[2]
local travail=args[3]
if eRight(ply)==true then
local reason=""
for i=2,#args do
reason=reason..tostring(args[i])
end
local heisinjob=false
for k,v in pairs(ZJOBwhitelist)do
if (v[2]==identifiant)and(travail==v[4])then
MsgN( "TRUE")
heisinjob=true
--return
end
end
print("Pass")
if heisinjob==true then
MsgN( "[Update Plugin] msg id 2: Whitelist is not updated because this user exist in this list of Job.")
return
end
MsgAll("[JOB Whitelist Plugin] "..lenom.." was added in Job-WhiteList by ",ply)
Nordah_Whitelist_Job.AddWhitelist{ply:Name(),identifiant,lenom,travail,tostring( os.date("%Y / %m / %d") )}
elseif eRight(ply)==true then
admincommandst(ply)
end
end
--Nordah_Whitelist_Job.AddCommand(AddWhitewjs_addbuto,"wjs_addbuto")
concommand.Add("wjs_addbuto",AddWhitewjs_addbuto)

local function ZWUnd_1(a,tab,Jlist,Jlist2)
if eRight(a)==true then
local cnt_list1=table.Count(Jlist)
local cnt_list2=table.Count(Jlist2)
a:ConCommand("whitelist_update "..tostring(table.Count(tab)).." "..tostring(cnt_list1+cnt_list2).." "..tostring(gmjobwhitel).." "..tostring(gmcatwhitel))
if cnt_list1>0 then
for c,d in pairs(Jlist)do
a.num9=a.num9+ztvo timer.Simple(a.num9,function() if IsValid(a) then net.Start("NSynchAddJob")net.WriteString(c)net.WriteString(d)net.Send(a) else return end end)
end
end
if cnt_list2>0 then
for c,d in pairs(Jlist2)do
a.num9=a.num9+ztvo timer.Simple(a.num9,function() if IsValid(a) then net.Start("NSynchAddJob2")net.WriteString(c)net.WriteString(d)net.Send(a) else return end end)
end
end
end
end

local function ZWUnd_2(a,tab)
if eRight(a)==true then
for c,d in pairs(tab)do
a.num9=a.num9+ztvo timer.Simple(a.num9,function() if IsValid(a) then net.Start("SynchAllJobWhitelisted")net.WriteString(d[1])net.WriteString(d[2])net.WriteString(d[3])net.WriteString(d[4])net.WriteString(d[5])net.Send(a) else return end end)
end
else
for c,d in pairs(tab)do
if a:SteamID64()==d[2] then
a.num9=a.num9+ztvo timer.Simple(a.num9,function() if IsValid(a) then net.Start("SynchAllJobWhitelisted")net.WriteString(d[1])net.WriteString(d[2])net.WriteString(d[3])net.WriteString(d[4])net.WriteString(d[5])net.Send(a) else return end end)
end
end
end
end

local function ZWUnd_SynchroConnect(a)
local a=a
local idx=a:EntIndex()
timer.Create("whitelsitjob_bynord0_"..idx,1,1,function()
if !IsValid(a) then return end
a.num9=0
local tab=ZJOBwhitelist
local Jlist=Add_Job_In_the_Whiteliste
local Jlist2=Add_JobGroup_In_the_Whiteliste
timer.Create("whitelsitjob_bynord1_"..idx,cfg.Delayed_reception,1,function()if !IsValid(a) then return end ZWUnd_1(a,tab,Jlist,Jlist2)end)

if tab[1]then
timer.Create("whitelsitjob_bynord2_"..idx,cfg.Delayed_reception,1,function()if !IsValid(a) then return end ZWUnd_2(a,tab)end)
end
end)
end
hook.Add("PlayerInitialSpawn", "ZWUnd_SynchroConnect", ZWUnd_SynchroConnect)

function cmdebugjob(ply,nom,aze)
print("ply:getJobTable()",ply:getJobTable().category)
PrintTable(GAMEMODE.Config.CategoryOverride.jobs)
--ply:getJobTable().category == "CloneTroopers" then return true end
end
concommand.Add("cmdebugjob",cmdebugjob)

function nord_check_whitelist_dtfile(ply)
local Tstr={
"zwhitelistjobdata/whitelistjob.txt",
"zwhitelistjobdata/jobsetting.txt",
"zwhitelistjobdata/jobgroupsetting.txt",
"zmodserveroption/sysjobwhitelist.txt",
"zmodserveroption/syscatwhitelist.txt"}

print("Verification DT Whitelsit - Nordahl")

for k,v in pairs(Tstr) do
local str=file.Read(v,"DATA")
if str==nil then
print(k..") "..v.." : N'existe par")
else
print(k..") "..v.." : Existe")
print("Contenu : ")
print(str)
end
print("-------END-------")
end
end
concommand.Add("nord_check_whitelist_dtfile",nord_check_whitelist_dtfile)

function nord_wl_restaure_4(ply)
file.Write("zmodserveroption/sysjobwhitelist.txt","1")
end
concommand.Add("nord_wl_restaure_4",nord_wl_restaure_4)

local function bw_export_to_nw2(ply)
MsgAll("NORDAHL EXPORT INIT\n")
local time=tostring( os.date("%Y / %m / %d") )
local listname={}
local antidouble={}
local RPExtraTeams=RPExtraTeams
ZJOBwhitelist={}
local duplicate_data=0
GAS.Database:Query("SELECT * FROM " .. GAS.Database:ServerTable("gas_jobwhitelist_listing")..",gas_offline_player_data", function(rows)
local count,max=0,#rows
MsgAll("EXPORT WORK... (WAIT)\n")

for k,v in ipairs (rows) do
count=count+1
local name=v.nick
local steamid64=util.SteamIDTo64(GAS:AccountIDToSteamID(v.account_id))
local addby64=util.SteamIDTo64(GAS:AccountIDToSteamID(v.added_by))
local date=string.Replace( v.last_seen, "-", " / ") or time
date=string.Explode(" ",date)
date=date[1].." / "..date[3].." / "..date[5]
local job_id=v.job_id+0
if RPExtraTeams[job_id] then
local job_name=RPExtraTeams[job_id].name or ""

if !antidouble[steamid64] and job_name!="" then
if listname[v.added_by] then
local adder=listname[v.added_by]
antidouble[steamid64..job_name]=true
table.insert(ZJOBwhitelist,{name,steamid64,adder,job_name,date})
else
GAS.Database:Query("SELECT nick FROM gas_offline_player_data WHERE account_id="..v.added_by.." LIMIT 1", function(rows)
local adder=rows[1].nick
listname[v.added_by]=adder
antidouble[steamid64..job_name]=true
table.insert(ZJOBwhitelist,{name,steamid64,adder,job_name,date})
end)
end
end
else
duplicate_data=duplicate_data+1

end
--print(count.."/"..max)
end
end)
MsgAll("Find double : "..duplicate_data.."\n")
MsgAll("Number of entries saved : "..#ZJOBwhitelist.."\n")
MsgAll("EXPORT WORK FINISH\n")
MsgAll("NORDAHL SAVE INIT\n")
JobWriteToFile()
MsgAll("NORDAHL SAVE DONE!!!\n")
MsgAll("YOU CAN REBOOT\n")
end
concommand.Add("bw_export_to_nw",bw_export_to_nw2)
concommand.Add("bwhitelist_export_to_nw",bw_export_to_nw2)

function bw_count_entries(ply)
GAS.Database:Query("SELECT * FROM " .. GAS.Database:ServerTable("gas_jobwhitelist_listing")..",gas_offline_player_data", function(rows)
MsgAll("Bwhitelist jobwhitelist_listing COUNT= "..#rows.."\n")
end)
end
concommand.Add("count_entries_bwhitelist",bw_count_entries)

function PrintTable_test(ply)
PrintTable(ZJOBwhitelist)
end
concommand.Add("PrintTable_test",PrintTable_test)

function PrintTable_test2(ply)
ZJOBwhitelist={}
local str,strpld= file.Read( "zwhitelistjobdata/whitelistjob.txt", "DATA" ),{}
if str==nil then
file.CreateDir("zwhitelistjobdata")
file.Write( "zwhitelistjobdata/whitelistjob.txt", "[]" )
else
str=string.Replace(str, "[[", "")
str=string.Replace(str, "]]", "")
strpld=string.Explode("],[",str)

for k,v in ipairs (strpld) do
local xpld=string.Explode(",",str)
table.insert(ZJOBwhitelist,{xpld[1],xpld[2],xpld[3],xpld[4],xpld[5]})
end
end

PrintTable(ZJOBwhitelist)
print(#ZJOBwhitelist)
end
concommand.Add("PrintTable_test2",PrintTable_test2)

function Norda_Whitelist_API_Pass( ply , job_name )
Nordah_Whitelist_Job.AddWhitelist({"Add by API",ply:SteamID64(),ply:Nick(),job_name,tostring( os.date("%Y / %m / %d") )})
end