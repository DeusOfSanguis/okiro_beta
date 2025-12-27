module("pacres", package.seeall)
CreateConVar("pacres_delay",10,{FCVAR_ARCHIVE,FCVAR_REPLICATED},"Delay before send next outfit")
def = CreateConVar("pacres_default","*default*",{FCVAR_ARCHIVE,FCVAR_REPLICATED},"Default restricts group")
limits,av,shared = {"size","animation","base","beam","bodygroup","bone","camera","clip","command","custom_animation","decal","effect","entity","event","flex","fog","gesture","group","halo","holdtype","jiggle","light","material","model","ogg","particles","physics",
"poseparameter","projectile","proxy","shake","sound","sprite","submaterial","sunbeams","text","trail","webaudio","bone2","clip2","light2","material2","model2","ogg2","trail2","entity2","material_eye refract","sound2","weapon","material_refract","player_config","projected_texture","material_2d","material_3d","player_movement","woohoo"},{},{}
bools,sendvars = {"can_use","editor","check_url","check_materials","check_models","check_sounds","delay"},{"can_use","editor","delay"}
svcnt = #sendvars
for k,v in pairs(sendvars) do shared[v] = k end
for k,v in pairs(limits) do
	shared[v] = k+svcnt
	av[v] = true
end
for _,v in pairs(bools) do av[v] = 0 end
LangsSend={"Error","Editor","Wear","Spam","Wearing","Integrate"}
meta={
	__index=function(t,k)
		return rawget(t,k) or rawget(t,1)[k]
	end,
	__newindex=function(t,k,v)
		rawset(t,k,v)
	end
}
function SetBool(tbl,var,bool)
	if bool then
		if tbl["derive"] and rawget(tbl,1)[var] == bool then
			tbl[var] = nil
		else
			tbl[var] = true
		end
	else
		if not tbl["derive"] then
			tbl[var] = nil
		else
			local rg = rawget(tbl,1)[var]
			if not rg or rg == bool then
				tbl[var] = nil
			else
				tbl[var] = false
			end
		end
	end
end
function RemoveRecursive(tbl,gr)
	for k,v in pairs(tbl) do
		if v["derive"] == gr then
			RemoveRecursive(tbl,k)
			tbl[k] = nil
		end
	end
end