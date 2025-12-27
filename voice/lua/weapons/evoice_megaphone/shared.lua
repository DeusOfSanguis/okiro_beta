SWEP.PrintName = "Megaphone"
SWEP.Author = "Wasied"
SWEP.Category = "Wasied - EVoice"
SWEP.Purpose = ""

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.Spawnable = true

SWEP.ViewModel = Model("models/sterling/c_enhanced_megaphone.mdl")
SWEP.WorldModel = Model("models/sterling/w_enhanced_megaphone.mdl")
SWEP.ViewModelFOV = 90
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

-- Megaphone primary attack
function SWEP:PrimaryAttack()

    if (self.Owner.iUseMegaphoneCooldown or 0) > CurTime() then return end
    self.Owner.iUseMegaphoneCooldown = CurTime() + 1

    local eViewModel = self.Owner:GetViewModel()
    local iSeqId

    if not self.Owner.bIsMegaphoneTalking then
        iSeqId = eViewModel:LookupSequence("talk")
    else
        iSeqId = eViewModel:LookupSequence("notalk")
    end

    self.Owner.bIsMegaphoneTalking = not self.Owner.bIsMegaphoneTalking

    if SERVER and EVoice.Config.MegaphoneAnim then
        net.Start("EVoice:ShowMegaphoneDistance")
            net.WriteBool(self.Owner.bIsMegaphoneTalking)
        net.Send(self.Owner)
    end

    eViewModel:SendViewModelMatchingSequence(iSeqId)
    return false

end

-- Megaphone seconday attack
function SWEP:SecondaryAttack()
    return false
end

-- Automatically remove the megaphone when the player does not have in in hands
function SWEP:Holster()

    if SERVER then

        self.Owner.bIsMegaphoneTalking = false

        net.Start("EVoice:ShowMegaphoneDistance")
            net.WriteBool(self.Owner.bIsMegaphoneTalking)
        net.Send(self.Owner)

    end

    return true

end