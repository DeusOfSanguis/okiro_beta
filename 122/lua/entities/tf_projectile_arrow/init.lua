
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Size = 0.25

util.PrecacheSound("Weapon_Arrow.ImpactFlesh")
util.PrecacheSound("Weapon_Arrow.ImpactMetal")
util.PrecacheSound("Weapon_Arrow.ImpactWood")
util.PrecacheSound("Weapon_Arrow.ImpactConcrete")

/*---------------------------------------------------------
Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	util.SpriteTrail(self, 0, Color(255,190,190,200), false, 0, 0.7, 0.8, 0/(0.7+0)*0.5, "Effects/arrowtrail_red.vmt")

	self:SetModel("models/weapons/w_models/w_arrow.mdl")
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	self:SetSolid( SOLID_BBOX )
	self:DrawShadow( true )
	self.notstuck = true
	
	self:SetCollisionBounds(Vector(-self.Size, -self.Size, -self.Size), Vector(self.Size, self.Size, self.Size))
	
	-- Don't collide with the player
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE )
	self:SetNetworkedString("Owner", "World")
	self.removearrow = CurTime() + 40
end

local exp

/*---------------------------------------------------------
Think
---------------------------------------------------------*/
function ENT:Think()
	if self.removearrow and CurTime()>self.removearrow then self:Remove() end
	if self.notstuck then self:SetAngles(self:GetVelocity():Angle()) end
end

/*---------------------------------------------------------
Touch
---------------------------------------------------------*/
function ENT:Touch( ent )

if not ent:IsTrigger() then

local speed = self:GetVelocity():Length()

if ent:IsNPC() or ent:IsPlayer() then

if speed < 150 then

local damage = speed * 0

end

if speed >= 150 then

local damage = speed * 0.04
ent:TakeDamage(damage , self.Owner, self)
ent:EmitSound("weapons/fx/rics/arrow_impact_flesh"..math.random(2,4)..".wav")
self:Remove()
end
return false end
if ent:IsWorld() then
self.notstuck = false
self:SetMoveType( MOVETYPE_NONE )
self:PhysicsInit( SOLID_NONE )
self:EmitSound("Weapon_Arrow.ImpactConcrete")
if (SERVER) then
ParticleEffect( "lowV_blood_impact_red_01", self:GetPos() - self:GetForward()*4, (self:GetAngles() + Angle(0,0,0)), nil)
ParticleEffect( "lowV_oildroplets", self:GetPos() - self:GetForward()*4, (self:GetAngles() + Angle(0,0,0)), nil)
ParticleEffect( "lowV_blood_impact_red_01", self:GetPos() - self:GetForward()*4, (self:GetAngles() + Angle(0,0,0)), nil)
ParticleEffect( "lowV_oildroplets", self:GetPos() - self:GetForward()*4, (self:GetAngles() + Angle(0,0,0)), nil)
ParticleEffect( "rocketbackblast", self:GetPos() + self:GetForward()*9.5, (self:GetAngles() + Angle(180,0,0)), nil)
ParticleEffect( "rocketbackblast", self:GetPos() + self:GetForward()*9.5, (self:GetAngles() + Angle(180,0,0)), nil)
end
self:SetPos(self:GetPos() + self:GetForward()*0)
else
if ent:IsValid() then
self.notstuck = false
self:SetMoveType( MOVETYPE_NONE )
self:PhysicsInit( SOLID_NONE )
self:SetParent(ent)
local damageprop = speed * 0.013
ent:TakeDamage(damageprop , self.Owner, self)
if (SERVER) then
ParticleEffect( "lowV_blood_impact_red_01", self:GetPos() + self:GetForward()*7, Angle(0,0,0), nil)
ParticleEffect( "impact_metal", self:GetPos() + self:GetForward()*7, Angle(0,0,0), nil)
end
local physforce = speed * 4
local phy = ent:GetPhysicsObject()
if (IsValid(phy)) then if (IsValid(phy)) then phy:ApplyForceCenter(self:GetForward()*(physforce)) end end
self.removearrow = CurTime() + 22
self:EmitSound("Weapon_Arrow.ImpactConcrete")
self:SetPos(self:GetPos() + self:GetForward()*2)
end
end
end
end