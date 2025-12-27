/*---------------------------------------------------------------------------
    +USE key to give a credit to someone
---------------------------------------------------------------------------*/

hook.Add("KeyPress", "TPTSA:GiveBadgeCredit", function(ply, key)
    if key != IN_USE then return end
    local ent = ply:GetEyeTrace().Entity
    if not IsValid(ent) or not ent:IsPlayer() then return end
    if not ply:TSIsSportCoach() then return end
    if CLIENT then return end
    if ent:TSHasTrainingSubscription() then
        Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("cardReaderGiveAlreadySubscribed"))
        return
    end
    if ent:TSGetBadgeCredit() == 1 then
        Diablos.TS:Notify(ply, 1, Diablos.TS:GetLanguageString("cardReaderGiveAlreadyCredit"))
        return
    end
    net.Start("TPTSA:CardReaderGive")
        net.WriteEntity(ent)
    net.Send(ply)
end)

/*---------------------------------------------------------------------------
    Avoid showing and decreasing stamina if the player is in a no-clip state
---------------------------------------------------------------------------*/

hook.Add("PlayerNoClip", "TPTSA:DontShowStamina", function(ply, desiredState)
    ply.StaminaNoClip = desiredState
end)


/*---------------------------------------------------------------------------
    Avoid taking 
        * turnstile button/trigger
        * the "treadmill floor" because you only need to take the treadmill entity, not its subcomponent
---------------------------------------------------------------------------*/

hook.Add("PhysgunPickup", "TPTSA:DontPickupTurnstile", function(ply, ent)
    local class = ent:GetClass()
    if class == "diablos_turnstile_button" or class == "diablos_turnstile_trigger" then
        return false
    else
        if IsValid(ent.treadmill) then
            return false
        end
    end
end)


