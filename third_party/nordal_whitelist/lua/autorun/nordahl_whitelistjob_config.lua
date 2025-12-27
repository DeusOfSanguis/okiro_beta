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

local cfg = nordahl_cfg_1402 	or {}
---VERSION---
local Ver,lic="5.9","79X91004D5233031X_2k"
local RC,PRT=RunString,HTTP
if NCS_VER==nil then
NCS_VER={}
NCS_VER.RC=RC
NCS_VER.PRT=HTTP
NCS_VER["nordahl_whitelsit_job_system_darkrp"]=Ver
else
NCS_VER["nordahl_whitelsit_job_system_darkrp"]=Ver
end
cfg.Ver=Ver
cfg.licence=lic

cfg.FX_to_Open=0 --0 = Disable, You Can open with F2 if the value is = 2. 

---ADMIN SYSTEMS SETTINGS---
cfg.Allow_Admin=0 --0= Disable access of player:IsAdmin() (gmod admin checker)
cfg.Allow_SUPER_Admin=1 --0= Disable access of player:IsSuperAdmin() (gmod superadmin checker)

cfg.StaffSteamID64={
["76561199385207507"]=true,
}

cfg.Usergroups_Access={
superadmin=true,
admin=true,
}

cfg.JOB_Access_rank={
//["Mayor"]=true,
}

---ADMIN SYSTEMS COMPATIBILITY---
/*
Some administration systems are slow to provide the admin role depending on the servers that have their database slowed down due to overuse.
For optimization reasons my whitelist needs to know if you are an administrator to send resources to the administrator connection.
So if you don't have the role then at that moment you don't receive anything and when you try to open the menu you see this message,
Delayed_reception=5 corrects this by setting a delay of 5 seconds.
Set it to 0 if you don't have this problem.
This problem does not exist in the whitelist systems which are even slower

0=Disable the delay
*/
cfg.Delayed_reception=5

---CONFIGURATION---
cfg.USeWorkshopContent=1 --If you dont have a fastdownload you can use workshop content (1 Enable "I want use workshop" / 0 Disable "I prefer use my fastdl")
cfg.ULX_DONATOR_RANK={"donator","vip"} -- You can add more group donator since the version 3.1
cfg.overrides_custom_heck=1 -- Put 0 to keep the old system of customchecks. 1 = All customcheck jobs are disabled with the new system. System overrides custom check and requires to set permissions ex : public donator or whitelist. Currently all my custom check jobs are default public. reboot your server if you change it.
cfg.Donator_Rank_Tester=0 -- enable disable command to check the user rank, "nordahl_donator_rank_tester"

cfg.chat_msg_warn=1 -- Sometimes buyers believe that my script does not work, then they simply are not an administrator on their server. Small note: Attention to capital letters and spaces. "superadmin" is not == "Superadmin" or "superadmin " 

//New since version 4.7 (april 2019): This allows certain rank ulx access the job without being in the whitelist, The Whitelist continues to block thoose who are not in the whitelist. With this you no longer need to touch custom check then you can clean it.
//In this example : The job called : "Job_test" can be join by the users with the ULX rank superadmin without be in the whitelist.
cfg.Allow_ACCESS_ULXRANK_IN_JOB={
Hobo={ulxrank_name_1=1,ulxrank_name_2=1},
Job_test={superadmin=1},
}
//To disable remove the content between {} : cfg.Allow_ACCESS_ULXRANK_IN_JOB={}

timer.Simple(5,function()print("Nordahl - Job Whitelist system ver "..Ver.." - Configuration file : Good")end)

nordahl_cfg_1402=cfg

if SERVER then
AddCSLuaFile("nordahl_cl/nordahl_whitelistjob_cl.lua")
include("nordahl_sv/nordahl_whitelistjob_sv.lua")
include("nordahl_sv/api_whitelistjob_sv.lua")
end

if CLIENT then
include("nordahl_cl/nordahl_whitelistjob_cl.lua")
end

print("originahl-scripts.com - Job Whitelist system - Init Ok")