local meta = FindMetaTable( "Entity" )
if ( !meta ) then return end 

local TriggerEntities = {
	trigger_autosave = true,
	trigger_changelevel = true,
	trigger_finale = true,
	trigger_gravity = true,
	trigger_hurt = true,
	trigger_impact = true,
	trigger_look = true,
	trigger_multiple = true,
	trigger_once = true,
	trigger_physics_trap = true,
	trigger_playermovement = true,
	trigger_proximity = true,
	trigger_push = true,
	trigger_remove = true,
	trigger_rpgfire = true,
	trigger_soundscape = true,
	trigger_serverragdoll = true,
	trigger_soundscape = true,
	trigger_teleport = true,
	trigger_transition = true,
	trigger_vphysics_motion = true,
	trigger_waterydeath = true,
	trigger_weapon_dissolve = true,
	trigger_weapon_strip = true,
	trigger_wind = true,
	func_occluder = true,
	func_precipitation = true,
	func_smokevolume = true,
	func_vehicleclip = true,
	func_areaportal = true,
	func_areaportalwindow = true,
	func_dustcloud = true,
	point_hurt = true,
	ambient_generic = true,
	env_steam = true,
	func_button = true,
	npc_maker = true,
	npc_template_maker = true,
	env_smokestack = true,
	item_battery = true,
	item_healthvial = true,
	item_healthkit = true,
	weapon_pistol = true,
	weapon_357 = true,
	weapon_ar2 = true,
	weapon_crossbow = true,
	weapon_smg1 = true,
	weapon_frag = true,
	weapon_stunstick = true,
	weapon_crowbar = true,
	weapon_rpg = true,
	weapon_slam = true,
	weapon_shotgun = true,
	func_door_rotating = true,
	spotlight_end = true,
	func_door = true,
	assault_assaultpoint = true
}

function meta:IsTrigger()
	if TriggerEntities[ self:GetClass() ] then
		return true
	end
	return false
end
