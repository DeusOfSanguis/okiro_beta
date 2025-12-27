function PlayerHit(ent, dmginfo)
    if ent:IsPlayer() and dmginfo:GetDamageType() == DMG_CRUSH then
        dmginfo:ScaleDamage(0.0)
    end
end
hook.Add("EntityTakeDamage", "PlayerHit", PlayerHit)