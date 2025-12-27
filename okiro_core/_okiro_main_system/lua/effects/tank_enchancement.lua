EFFECT.mat = Material( "sprites/light_glow02_add" )

local propHalos = {}  -- Tableau pour stocker les modèles nécessitant un halo

hook.Add("PreDrawHalos", "AddPropHalos", function()
    halo.Add(propHalos, Color(1255,0,0,255), 0, 15, 2)  -- Ajouter des halos aux modèles stockés dans la table
end)

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

    self.Model:SetMaterial("models/alyx/emptool_glow")
    self.Model:SetColor( Color(1255,0,0) )
    self.Model:SetParent( self.Ent, 0 )
    self.Model:SetMoveType( MOVETYPE_NONE )
    self.Model:SetLocalPos( Vector( 0, 0, 0 ) )
    self.Model:SetLocalAngles( Angle( 0, 0, 0 ) )
    self.Model:AddEffects( EF_BONEMERGE )

	table.insert(propHalos, self.Model)

    for i = 0,self.Ent:GetBoneCount() do
        self.Model:ManipulateBoneScale( i, Vector(1,1,1) * 1.01 )
    end

    for i = 0, self.Ent:GetNumBodyGroups() do
        self.Model:SetBodygroup(i, self.Ent:GetBodygroup(i))
    end
end

function EFFECT:Think()
    if self.DieTime < CurTime() or not IsValid( self.Ent ) or (self.Ent.Alive and not self.Ent:Alive()) then 
        if IsValid( self.Model ) then
            self.Model:Remove()
        end

        return false
    end

    if IsValid( self.Model ) then
        self.Model:SetColor( Color(255* (self.DieTime - CurTime()) / self.LifeTime,0,0,255) )
    end

    return true
end

function EFFECT:Render()
    if not IsValid( self.Ent ) then return end

end
