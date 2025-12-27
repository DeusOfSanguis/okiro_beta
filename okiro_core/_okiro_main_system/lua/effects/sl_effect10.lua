EFFECT.mat = Material( "sprites/light_glow02_add" )

function EFFECT:Init( data )
    self.Ent = data:GetEntity()
    self.Pos = data:GetOrigin()

    self.LifeTime = 2
    self.DieTime = CurTime() + self.LifeTime

    if not IsValid( self.Ent ) then return end

    self.swep = self.Ent:GetActiveWeapon()

    if self.Ent:GetNWString("CosmetiqueArme") != "RIEN" then
        self.Model = ClientsideModel( self.Ent:GetNWString("CosmetiqueArme"), RENDERGROUP_TRANSLUCENT )
    else
        if self.Ent:GetActiveWeapon().ModelArme then self.Model = ClientsideModel( self.Ent:GetActiveWeapon().ModelArme, RENDERGROUP_TRANSLUCENT ) else self.Model = ClientsideModel( "models/mad_worldmodel/sword14.mdl", RENDERGROUP_TRANSLUCENT ) end
    end

    self.Model:SetColor( Color(255,255,255) )
    self.Model:SetParent( self.Ent, 0 )
    self.Model:SetMoveType( MOVETYPE_NONE )
    self.Model:SetLocalPos( Vector( 0, 0, 0 ) )
    self.Model:SetLocalAngles( Angle( 0, 0, 0 ) )
    self.Model:AddEffects( EF_BONEMERGE )

    for i = 0,self.Ent:GetBoneCount() do
        self.Model:ManipulateBoneScale( i, Vector(1,1,1) * 1 )
    end

    for i = 0, self.Ent:GetNumBodyGroups() do
        self.Model:SetBodygroup(i, self.Ent:GetBodygroup(i))
    end
end

function EFFECT:Think()
    if not IsValid( self.Ent ) then self.Model:Remove() return false end
    if self.Ent:GetNoDraw() or self.Ent:GetActiveWeapon() != self.swep or not IsValid( self.Ent ) or not self.Ent:Alive() then 
        if IsValid( self.Model ) then
            self.Model:Remove()
        end

        return false
    end

    return true
end

function EFFECT:Render()
    if not IsValid( self.Ent ) then self.Model:Remove() return false end
    if self.Ent:GetNoDraw() or self.Ent:GetActiveWeapon() != self.swep or not IsValid( self.Ent ) or not self.Ent:Alive() then return end

end
