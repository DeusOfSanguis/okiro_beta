AddCSLuaFile()
DEFINE_BASECLASS("base_anim")

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Spawnable = true
ENT.Model = "models/mad_worldmodel/dague32.mdl"

local DAUGE_MINS = Vector(-0.25, -0.25, 0.25)
local DAUGE_MAXS = Vector(0.25, 0.25, 0.25)

function ENT:Initialize()
    if SERVER then
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_FLYGRAVITY)
        self:SetSolid(SOLID_BBOX)
        self:SetTrigger(true)
        self:SetColor(Color(150, 150, 150))
        self:SetRenderMode(RENDERMODE_TRANSCOLOR)
        self:DrawShadow(true)
        self:SetCollisionBounds(DAUGE_MINS, DAUGE_MAXS)
        self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then phys:Wake() end
        local ply = self.Owner
        if IsValid(ply) then
            if ply.Invisi then
                self.DamageBonus = 2                
                ply:GetActiveWeapon():DesacInvisi()
            else
                self.DamageBonus = 1
            end
        else
            self.DamageBonus = 1
        end
    end
end

function ENT:Think()
    if SERVER then
        if self:GetMoveType() == MOVETYPE_FLYGRAVITY then
            self:SetAngles(self:GetVelocity():Angle())
        end
        if self.removearrow and CurTime() >= self.removearrow then
            self:RemoveArrow(self.removearrow)
            self.removearrow = nil
        end
    end
    self:NextThink(CurTime())
    return true
end

function ENT:Touch(ent)
    local speed = self:GetVelocity():Length()
    local ply = self.Owner
    local weaponBonus = IsValid(ply) and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon().BonusDegats or 0
    if ent == ply then self:Remove() end
    if IsValid(ent) then
        if ent:IsPlayer() then
            self:HitPlayer(ent, weaponBonus)
        elseif ent:IsNPC() or ent:IsNextBot() then
            self:HitNPC(ent, weaponBonus)
        end
    end

    if ent:IsWorld() then
        self.notstuck = false
        self:SetMoveType(MOVETYPE_NONE)
        self:PhysicsInit(SOLID_NONE)
        self.removearrow = CurTime() + 5
        self:EmitSound("bow/impact_arrow_stick_2.wav")
        self:EmitSound(	"bow/de/wind.ogg") 				
        ParticleEffect("[2]_ice_dash_add_5", self:GetPos(), Angle(0, 45, 0), self)
    elseif IsValid(ent) then
        self.notstuck = false
        self:SetMoveType(MOVETYPE_NONE)
        self:PhysicsInit(SOLID_NONE)
        self:SetParent(ent)
        self.removearrow = CurTime() + 5
        self:EmitSound("bow/impact_arrow_stick_" .. math.random(1, 3) .. ".wav")
        self:SetPos(self:GetPos() + self:GetForward() * 2)
        ParticleEffect("[2]_ice_dash_add_5", self:GetPos(), Angle(0, 45, 0), self)
    end
end

function ENT:HitPlayer(ply, weaponBonus)
    local damage = 50 + weaponBonus
    if IsValid(ply) then
        local origWalkSpeed = ply:GetWalkSpeed()
        local origRunSpeed = ply:GetRunSpeed()
        ply:SetWalkSpeed(origWalkSpeed * 0.5)
        ply:SetRunSpeed(origRunSpeed * 0.5)
        timer.Simple(3, function()
            if IsValid(ply) then
                ply:SetWalkSpeed(origWalkSpeed)
                ply:SetRunSpeed(origRunSpeed)
            end
        end)
    end
    local closestHitbox, closestDistance = nil, math.huge
    for i = 0, ply:GetHitBoxGroupCount() - 1 do
        for j = 0, ply:GetHitBoxCount(i) - 1 do
            local bone = ply:GetHitBoxBone(j, i)
            if bone then
                local hitboxPos = ply:GetBonePosition(bone)
                if hitboxPos then
                    local hitboxDistance = self:GetPos():Distance(hitboxPos)
                    if hitboxDistance < closestDistance then
                        closestDistance, closestHitbox = hitboxDistance, bone
                    end
                end
            end
        end
    end
    if closestHitbox then
        local bullet = {
            Attacker = self.Owner,
            Damage = damage,
            Src = self:GetPos(),
            Dir = (ply:GetBonePosition(closestHitbox) - self:GetPos()):GetNormalized(),
            Spread = Vector(0, 0, 0),
            Num = 1,
            Force = 2,
            Tracer = 0
        }
        self:FireBullets(bullet)
        ply:EmitSound("bow/impact_arrow_flesh_" .. math.random(1, 4) .. ".wav")
    end
    self:Remove()
end


function ENT:HitNPC(ent, weaponBonus)
    local damage = 300 + weaponBonus

    if IsValid(ent) then
        ent:TakeDamage(damage, self.Owner)
        ent:EmitSound("bow/impact_arrow_flesh_" .. math.random(1, 4) .. ".wav")
    end
    self:Remove()
end

function ENT:RemoveArrow(removearrowTime)
    if IsValid(self) then
        if CurTime() >= removearrowTime then
            if self.ParticleEffect then
                self:StopParticleEffect()
            end
            self:Remove()
        end
    end
end
