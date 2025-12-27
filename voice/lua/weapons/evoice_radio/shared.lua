SWEP.PrintName = "Radio"
SWEP.Author = "Wasied"
SWEP.Category = "Wasied - EVoice"
SWEP.Purpose = ""

SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Spawnable = true

SWEP.ViewModel = Model("models/danradio/c_radio.mdl")
SWEP.WorldModel = Model("models/danradio/w_radio.mdl")
SWEP.ViewModelFOV = 80
SWEP.DrawAmmo = false
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

-- Radio primary attack
function SWEP:PrimaryAttack()

    if not SERVER then return false end

    if (self.Owner.iUseRadioCooldown or 0) > CurTime() then return end
    self.Owner.iUseRadioCooldown = CurTime() + 1

    if not self.Owner:GetRadioEnabled() then return end

    self.Owner:SetRadioSound(not self.Owner:GetRadioSound())
    self.Owner:EmitSound("evoice_radiotone.wav", 50)
    return false

end

-- Radio seconday attack
function SWEP:SecondaryAttack()

    if not SERVER then return false end

    if (self.Owner.iUseRadioCooldown or 0) > CurTime() then return end
    self.Owner.iUseRadioCooldown = CurTime() + 1

    if not self.Owner:GetRadioEnabled() then return end

    self.Owner:SetRadioMic(not self.Owner:GetRadioMic())
    self.Owner:EmitSound("evoice_radiotone.wav", 50)
    return false

end