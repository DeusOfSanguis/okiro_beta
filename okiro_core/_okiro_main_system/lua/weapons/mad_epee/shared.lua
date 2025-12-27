SWEP.PrintName 		      = "Base : Меч" 
SWEP.Author 		      = "Okiro" 
SWEP.Instructions 	      = "" 
SWEP.Contact 		      = "" 
SWEP.AdminSpawnable       = true 
SWEP.Spawnable 		      = true 
SWEP.ViewModelFlip        = false
SWEP.ViewModelFOV 	      = 85
SWEP.ViewModel =            ""
SWEP.WorldModel = ""
SWEP.ShowWorldModel         = false
SWEP.AutoSwitchTo 	      = false 
SWEP.AutoSwitchFrom       = true 
SWEP.DrawAmmo             = false 
SWEP.Base                 = "weapon_base" 
SWEP.Slot 			      = 0
SWEP.SlotPos              = 0
SWEP.DrawCrosshair        = true 
SWEP.Weight               = 0 

SWEP.Category             = "[ARMES - Okiro]"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic   	= true
SWEP.Primary.Ammo         	= "None"

SWEP.Secondary.ClipSize		= 0
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic   	= true
SWEP.Secondary.Ammo         = "none"

--------------------------------------------------------------------------

local DATA = {}
DATA.Name = "sl_epee_ht_mad"
DATA.HoldType = "sl_epee_ht_mad"
DATA.BaseHoldType = "normal"
DATA.Translations = {} 

DATA.Translations[ ACT_MP_STAND_IDLE ] = {
    { Sequence = "mad_son_run_base", Weight = 1 },
}

DATA.Translations[ ACT_MP_JUMP ] = {
    { Sequence = "mad_eaujump3", Weight = 1 },
}            

DATA.Translations[ ACT_MP_WALK ] = {
    { Sequence = "phalanx_walk_lower_2", Weight = 1 },
}

DATA.Translations[ ACT_MP_SPRINT ] = {
    { Sequence = "mad_son_run_base", Weight = 1 },
}

DATA.Translations[ ACT_MP_RUN ] = {
    { Sequence = "mad_son_run_base", Weight = 5 },
}

wOS.AnimExtension:RegisterHoldtype( DATA )

--------------------------------------------------------------------------

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

SWEP.TypeArme = "sword"
SWEP.BonusDegats = 10
SWEP.holdtype = "sl_epee_ht_mad"

function SWEP:Initialize()
    if IsValid(self) and IsValid(self:GetOwner()) then
        self:GetOwner():SetNWInt("Combo", 0)
        if CLIENT then
        self:GetOwner():SetNWInt("FOV", self:GetOwner():GetFOV())
        end
        self.Weapon:SetHoldType( self.holdtype )
    end
end

function SWEP:Deploy()
    self.Weapon:SetHoldType( self.holdtype )
    print(self:GetOwner():GetFOV())
    self:GetOwner():SetNWInt("Combo", 0)   
end